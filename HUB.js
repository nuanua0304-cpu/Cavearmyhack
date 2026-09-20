const {
    Client,
    GatewayIntentBits,
    PermissionFlagsBits,
    SlashCommandBuilder,
    EmbedBuilder,
    ActionRowBuilder,
    ButtonBuilder,
    ButtonStyle,
    ChannelType
} = require('discord.js');
require('dotenv').config();
const fs = require('fs');
const path = require('path');
const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

const licensePath = path.join(__dirname, 'licenses.json');
let licensesData = {};

if (fs.existsSync(licensePath)) {
    try { licensesData = JSON.parse(fs.readFileSync(licensePath, 'utf8')); } catch (e) {}
}

function saveLicenses() {
    fs.writeFileSync(licensePath, JSON.stringify(licensesData, null, 2), 'utf8');
}
function isAdmin(member) {
    return member?.permissions?.has(PermissionFlagsBits.Administrator);
}

// ==========================================
// Express API 엔드포인트
// ==========================================

// 1. 허브 정보 및 유저 인증 API (/api/hub)
app.get('/api/hub', (req, res) => {
    const robloxName = req.query.roblox;
    if (!robloxName) {
        return res.json({ success: false, message: "roblox 쿼리가 누락되었습니다." });
    }

    // 해당 로블록스 닉네임으로 등록된 라이센스 탐색
    let matchedLicense = null;
    let matchedDiscordUid = null;

    for (const [uid, data] of Object.entries(licensesData)) {
        if (data.robloxName === robloxName) {
            matchedLicense = data;
            matchedDiscordUid = uid;
            break;
        }
    }

    if (!matchedLicense) {
        return res.json({ success: false, message: "등록되지 않은 유저입니다." });
    }

    res.json({
        success: true,
        robloxName: robloxName,
        discordName: matchedLicense.discordName || "HCS User",
        discordPfp: matchedLicense.discordPfp || "https://cdn.discordapp.com/embed/avatars/0.png",
        products: matchedLicense.products || [] // 등록된 제품 리스트
    });
});

// 2. 실행 로그 기록 API (/api/log)
app.get('/api/log', (req, res) => {
    const robloxName = req.query.roblox;
    const product = req.query.product;
    console.log(`[LOG] 사용자 [${robloxName}] 님이 [${product}] 스크립트를 구동했습니다.`);
    res.json({ success: true });
});

// 3. 비공개 스크립트 반환 API (/api/script)
// ※ 버튼을 눌렀을 때 실행될 실제 비공개 스크립트 코드를 이 안에서 제품별로 리턴해주시면 됩니다!
app.get('/api/script', (req, res) => {
    const robloxName = req.query.roblox;
    const productId = req.query.product;

    if (!robloxName || !productId) {
        return res.status(400).send("잘못된 요청입니다.");
    }

    let luaScriptCode = "";
    
    // 제품별 비공개 스크립트 분기 처리
    if (productId === "pc_v1") {
        luaScriptCode = `print("동굴부대 PC V1 비공개 스크립트 실행됨!")`;
    } else if (productId === "pc_v2") {
        luaScriptCode = `print("동굴부대 PC V2 비공개 스크립트 실행됨!")`;
    } else if (productId === "vip") {
        luaScriptCode = `print("VIP 스크립트 실행됨!")`;
    } else {
        luaScriptCode = `print("${productId} 스크립트 실행됨!")`;
    }

    res.send(luaScriptCode.trim());
});

app.listen(PORT, () => {
    console.log(`[EXPRESS] 서버가 포트 ${PORT}에서 구동되었습니다! 🚀`);
});

// ==========================================
// Discord 봇 설정
// ==========================================
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent,
        GatewayIntentBits.GuildMembers
    ]
});

const productChoices = [
    { name: 'PC V1', value: 'pc_v1' },
    { name: 'PC V2', value: 'pc_v2' },
    { name: 'PC V3', value: 'pc_v3' },
    { name: 'Mobile V1', value: 'mov_v1' },
    { name: 'Mobile V2', value: 'mov_v2' },
    { name: 'Mobile V3', value: 'mov_v3' },
    { name: 'TDC', value: 'tdc' },
    { name: 'MP', value: 'mp' },
    { name: 'VIP', value: 'vip' }
];

const commands = [
    new SlashCommandBuilder()
        .setName('라이센스영구')
        .setDescription('특정 디스코드 유저에게 로블록스 닉네임과 제품을 연동하여 영구 라이센스를 부여합니다.')
        .addUserOption(o => o.setName('유저').setDescription('대상 디스코드 유저').setRequired(true))
        .addStringOption(o => o.setName('로블록스닉네임').setDescription('연동할 로블록스 닉네임').setRequired(true))
        .addStringOption(o => o.setName('제품').setDescription('부여할 제품 선택').setRequired(true).addChoices(...productChoices)),
    new SlashCommandBuilder()
        .setName('라이센스제거')
        .setDescription('특정 디스코드 유저의 라이센스를 제거합니다.')
        .addUserOption(o => o.setName('유저').setDescription('대상 유저').setRequired(true))
];

client.once('ready', async () => {
    console.log(`[DISCORD] 봇 로그인 성공: ${client.user.tag}`);
    try {
        const finalCommands = commands.map(cmd => cmd.setDefaultMemberPermissions(PermissionFlagsBits.Administrator));
        await client.application.commands.set(finalCommands);
        console.log('✅ 슬래시 명령어 등록 완료');
    } catch (e) {
        console.error('명령어 등록 오류:', e);
    }
});

client.on('interactionCreate', async i => {
    if (!i.isChatInputCommand()) return;
    if (!isAdmin(i.member)) {
        return await i.reply({ content: '❌ 관리자 권한이 필요합니다.', flags: 64 });
    }

    try {
        await i.deferReply({ flags: 64 });

        if (i.commandName === '라이센스영구') {
            const targetUser = i.options.getUser('유저');
            const robloxName = i.options.getString('로블록스닉네임');
            const product = i.options.getString('제품');

            // 유저 프로필 사진 및 이름 추출 저장
            licensesData[targetUser.id] = {
                robloxName: robloxName,
                discordName: targetUser.username,
                discordPfp: targetUser.displayAvatarURL({ extension: 'png', size: 256 }),
                products: [product] // 선택한 제품 부여
            };
            saveLicenses();

            const embed = new EmbedBuilder()
                .setTitle('🌐 영구 라이센스 연동 완료')
                .setDescription(`- **디스코드 유저**: ${targetUser}\n- **로블록스 닉네임**: \`${robloxName}\`\n- **부여된 제품**: \`${product}\``)
                .setThumbnail(targetUser.displayAvatarURL())
                .setColor('#0099FF');
            return await i.editReply({ embeds: [embed] });
        }

        if (i.commandName === '라이센스제거') {
            const targetUser = i.options.getUser('유저');
            if (!licensesData[targetUser.id]) {
                return await i.editReply({ content: '❌ 등록된 라이센스가 없는 유저입니다.' });
            }
            delete licensesData[targetUser.id];
            saveLicenses();
            return await i.editReply({ content: `✅ ${targetUser}님의 라이센스가 제거되었습니다.` });
        }
    } catch (err) {
        await i.editReply({ content: '❌ 명령어 실행 중 오류가 발생했습니다.' }).catch(() => {});
    }
});

if (process.env.TOKEN) {
    client.login(process.env.TOKEN);
}
