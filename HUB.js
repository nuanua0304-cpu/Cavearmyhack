const {
    Client,
    GatewayIntentBits,
    PermissionFlagsBits,
    SlashCommandBuilder,
    EmbedBuilder,
    ActionRowBuilder,
    ButtonBuilder,
    ButtonStyle,
    ChannelType,
    StringSelectMenuBuilder,
    StringSelectMenuOptionBuilder,
    ModalBuilder,
    TextInputBuilder,
    TextInputStyle
} = require('discord.js');
require('dotenv').config();
const fs = require('fs');
const path = require('path');
const { createWorker } = require('tesseract.js');
const express = require('express');
const cors = require('cors');

// ==========================================
// Express 서버 설정
// ==========================================
const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// ==========================================
// 파일 경로 및 데이터베이스 설정
// ==========================================
const dbPath = path.join(__dirname, 'channels.json');
const pointsPath = path.join(__dirname, 'points.json');
const shopPath = path.join(__dirname, 'shop.json');
const attendPath = path.join(__dirname, 'attendance.json');
const scriptPath = path.join(__dirname, 'scripts.json');
const ticketDbPath = path.join(__dirname, 'tickets.json');
const fishPath = path.join(__dirname, 'fishing.json');
const moderationPath = path.join(__dirname, 'moderation.json');
const licensePath = path.join(__dirname, 'licenses.json');
const backupDir = path.join(__dirname, 'backups');

if (!fs.existsSync(backupDir)) {
    try { fs.mkdirSync(backupDir); } catch (e) {}
}

let logConfig = {
    welcomeChannel: null,
    leaveChannel: null,
    aiAuthChannel: null,
    aiSupportChannel: null,
    ticketStartHour: 0,
    ticketEndHour: 24,
    ticketClosedDays: "",
    shopChannelId: null,
    shopMessageId: null,
    buyLogChannel: null,
    attendChannel: null,
    botInfoChannel: null,
    stockLogChannel: null,
    scriptChannelId: null,
    scriptMessageId: null,
    attendChannelId: null,
    fishingChannelId: null,
    fishingLogChannel: null,
    accountLogChannel: null,
    warningLogChannel: null,
    maintenanceMode: false
};

let userPoints = {};
let shopProducts = [];
let attendance = {};
let scriptProducts = [];
let ticketDatabase = {};
let fishData = {};
let licensesData = {};
let moderationData = {
    ticketBlockedUsers: {},
    punishWords: {},
    punishServerLinks: {},
    whitelistUsers: [],
    whitelistRoles: [],
    whitelistChannels: [],
    whitelistServerLinks: [],
    warnings: {}
};

// 데이터 불러오기
if (fs.existsSync(dbPath)) { try { logConfig = { ...logConfig, ...JSON.parse(fs.readFileSync(dbPath, 'utf8')) }; } catch (e) {} }
if (fs.existsSync(pointsPath)) { try { userPoints = JSON.parse(fs.readFileSync(pointsPath, 'utf8')); } catch (e) {} }
if (fs.existsSync(shopPath)) { try { shopProducts = JSON.parse(fs.readFileSync(shopPath, 'utf8')); } catch (e) {} }
if (fs.existsSync(attendPath)) { try { attendance = JSON.parse(fs.readFileSync(attendPath, 'utf8')); } catch (e) {} }
if (fs.existsSync(scriptPath)) { try { scriptProducts = JSON.parse(fs.readFileSync(scriptPath, 'utf8')); } catch (e) {} }
if (fs.existsSync(ticketDbPath)) { try { ticketDatabase = JSON.parse(fs.readFileSync(ticketDbPath, 'utf8')); } catch (e) {} }
if (fs.existsSync(fishPath)) { try { fishData = JSON.parse(fs.readFileSync(fishPath, 'utf8')); } catch (e) {} }
if (fs.existsSync(moderationPath)) { try { moderationData = { ...moderationData, ...JSON.parse(fs.readFileSync(moderationPath, 'utf8')) }; } catch (e) {} }
if (fs.existsSync(licensePath)) { try { licensesData = JSON.parse(fs.readFileSync(licensePath, 'utf8')); } catch (e) {} }

function saveLicenses() {
    const data = JSON.stringify(licensesData, null, 2);
    fs.writeFileSync(licensePath, data, 'utf8');
}
function generateLicenseCode() {
    return 'HCS-' + Math.random().toString(36).substring(2, 7).toUpperCase() + '-' + Math.random().toString(36).substring(2, 7).toUpperCase();
}
function isAdmin(member) {
    return member?.permissions?.has(PermissionFlagsBits.Administrator);
}
function initUserPoints(uid) {
    if (typeof userPoints[uid] !== 'number') { userPoints[uid] = 0; }
}

// ==========================================
// Express API 엔드포인트 (로블록스 허브 연동)
// ==========================================

// 1. 유저 인증 및 허브 정보 확인 API (/api/hub)
app.get('/api/hub', (req, res) => {
    const robloxName = req.query.roblox;
    if (!robloxName) {
        return res.json({ success: false, message: "roblox 쿼리가 누락되었습니다." });
    }

    // 예시 데이터 연동 (필요에 따라 라이센스나 DB와 연동 가능)
    res.json({
        success: true,
        robloxName: robloxName,
        discordName: "HCS User",
        discordPfp: "https://cdn.discordapp.com/embed/avatars/0.png",
        products: ["pcv1", "pcv2", "mov1", "mov2"]
    });
});

// 2. 실행 로그 기록 API (/api/log)
app.get('/api/log', (req, res) => {
    const robloxName = req.query.roblox;
    const product = req.query.product;
    console.log(`[LOG] 사용자 [${robloxName}] 님이 [${product}] 스크립트를 구동했습니다.`);
    res.json({ success: true });
});

// 3. 스크립트 코드 반환 API (/api/script)
app.get('/api/script', (req, res) => {
    const robloxName = req.query.roblox;
    const productId = req.query.product;

    if (!robloxName || !productId) {
        return res.status(400).send("잘못된 요청입니다.");
    }

    let luaScriptCode = "";
    if (productId === "pcv1") {
        luaScriptCode = `print("--- HCS HUB: 동굴부대 PC V1 실행됨 ---")`;
    } else if (productId === "pcv2") {
        luaScriptCode = `print("--- HCS HUB: 동굴부대 PC V2 실행됨 ---")`;
    } else if (productId === "mov1") {
        luaScriptCode = `print("--- HCS HUB: 동굴부대 모바일 V1 실행됨 ---")`;
    } else if (productId === "mov2") {
        luaScriptCode = `print("--- HCS HUB: 동굴부대 모바일 V2 실행됨 ---")`;
    } else {
        return res.status(404).send("존재하지 않는 스크립트 제품입니다.");
    }

    res.send(luaScriptCode.trim());
});

// 4. 라이센스 검증 API (/verify) - 디스코드 봇과 연동
app.get('/verify', (req, res) => {
    const { code, user } = req.query;
    if (!code || !user) return res.send('INVALID');
    const license = licensesData[code];
    if (!license) return res.send('INVALID');

    // 1회용 (24시간) 라이센스 확인
    if (license.type === '1day') {
        if (Date.now() > license.expireAt) {
            delete licensesData[code];
            saveLicenses();
            return res.send('EXPIRED');
        }
        return res.send('VALID');
    }

    // 영구 (특정 유저 전용) 라이센스 확인
    if (license.type === 'permanent') {
        if (license.robloxName !== user) return res.send('INVALID_USER');
        return res.send('VALID');
    }

    res.send('INVALID');
});

app.listen(PORT, () => {
    console.log(`[EXPRESS] HCS 허브 & 라이센스 서버가 포트 ${PORT}에서 구동되었습니다! 🚀`);
});

// ==========================================
// Discord 봇 설정 (기존 명령어 및 기능 포함)
// ==========================================
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent,
        GatewayIntentBits.GuildMembers
    ]
});

const commands = [
    new SlashCommandBuilder().setName('라이센스1회용').setDescription('하루(24시간) 동안 사용할 수 있는 라이센스를 생성합니다. (관리자 전용)'),
    new SlashCommandBuilder().setName('라이센스영구').setDescription('특정 로블록스 유저 전용 영구 라이센스를 생성합니다. (관리자 전용)').addStringOption(o=>o.setName('로블록스닉네임').setDescription('사용 가능한 로블록스 닉네임').setRequired(true)),
    new SlashCommandBuilder().setName('라이센스제거').setDescription('등록된 라이센스를 제거합니다. (관리자 전용)').addStringOption(o=>o.setName('코드').setDescription('제거 할 라이센스 코드').setRequired(true))
];

client.once('ready', async () => {
    console.log(`[DISCORD] 봇 로그인 성공: ${client.user.tag}`);
    try {
        const finalCommands = commands.map(cmd => cmd.setDefaultMemberPermissions(PermissionFlagsBits.Administrator));
        await client.application.commands.set(finalCommands);
        console.log('✅ 디스코드 라이센스 슬래시 명령어 등록 완료');
    } catch (e) {
        console.error('슬래시 명령어 등록 오류:', e);
    }
});

client.on('interactionCreate', async i => {
    if (!i.isChatInputCommand()) return;
    if (!isAdmin(i.member)) {
        return await i.reply({ content: '❌ 관리자 권한이 필요합니다.', flags: 64 });
    }

    try {
        await i.deferReply({ flags: 64 });
        if (i.commandName === '라이센스1회용') {
            const code = generateLicenseCode();
            licensesData[code] = { type: '1day', expireAt: Date.now() + (24 * 60 * 60 * 1000), robloxName: null };
            saveLicenses();
            const embed = new EmbedBuilder()
                .setTitle('🌐 라이센스 하루용이 추가되었어요!')
                .setDescription(`\`\`\`${code}\`\`\`\n-# ^^^ 복사해서 사용하세요.`)
                .setColor('#00FF00');
            return await i.editReply({ embeds: [embed] });
        }
        if (i.commandName === '라이센스영구') {
            const robloxName = i.options.getString('로블록스닉네임');
            const code = generateLicenseCode();
            licensesData[code] = { type: 'permanent', expireAt: null, robloxName: robloxName };
            saveLicenses();
            const embed = new EmbedBuilder()
                .setTitle('🌐 라이센스 영구 유저용이 추가되었어요!')
                .setDescription(`\`\`\`${code}\`\`\`\n\`\`\`${robloxName}만 사용이 가능합니다.\`\`\`\n-# ^^^ 복사해서 사용하세요.`)
                .setColor('#0099FF');
            return await i.editReply({ embeds: [embed] });
        }
        if (i.commandName === '라이센스제거') {
            const code = i.options.getString('코드').trim();
            if (!licensesData[code]) {
                return await i.editReply({ content: '❌ 존재하지 않는 라이센스 코드입니다.' });
            }
            delete licensesData[code];
            saveLicenses();
            return await i.editReply({ content: `✅ 라이센스 (\`${code}\`)가 성공적으로 제거되었습니다.` });
        }
    } catch (err) {
        await i.editReply({ content: '❌ 명령어 실행 중 오류가 발생했습니다.' }).catch(() => {});
    }
});

if (process.env.TOKEN) {
    client.login(process.env.TOKEN);
} else {
    console.log("[DISCORD] .env에 TOKEN이 설정되지 않았습니다.");
}
