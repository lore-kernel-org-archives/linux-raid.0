Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.11.79
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794215140;
	b=ihtC4alvJE/xspFNNojzWhbY8elyqbRJg+j8RSsv3OEo/TCDAeHea7UFlJd0BV0nE1lQ
	 6q9ZeU6kN+8Pz7CdF8UQ78eX6t4E73Wh5tnkTURQK3DkUnffVGB2AuRjJwx8XmXn6WaPP
	 DVrN7VHUfUJvbBRz/0Op7yS2/KQerQhYR5BN+Lz1ysI433g0fs9AVgOj1Fu0VnQCyVw5/
	 fs/9mijH0AsWuSvRXKns74XoF55PW0fVxxscg81OVd48lbw3MnoTIwvYep+7l/RtVEQYG
	 3nkSFZej3s2rbna178MSEVu2HxwIehswWJwp1n0D1fVpPLkFPCUKBNpwThv3BgpfL8g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794215140;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=JtNO1LQAvVkuWjOVwKv9IaK2qv4ZL3i7KGgFIeWF+IY=;
	b=VwJ+YRaduEBSIsG9HJXBmoKS5BtWmgqoIoj/qLXq/c2IysU69SJjCBYRjO7iGx413dVn
	 oH6oeFlAF3j2efz7lt7rVp0krdzC4WH+tUdqT8TkOU/bpn2eUk+fq/BopuSTSDIuxet+t
	 MrHjMblov3qZdKzYGcFwYSVUAq9PnmKboox37XR2aGqFBuLaM+9gABAx4zJ+Gf9DrHgPD
	 /HEw9vpCZuQthA+gm0CiooMhxKSgUYhOTZDTqUEDCtog4I0BGJVoaYE1f9DZhiJIyw/zg
	 675UTy5/FoT8CFYYjMA5/hJJWNaR24RD063+0+g3dhj0V/T0JAFZKr9ab0SGFTERScg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=RcRP2CVb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.11.79
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazolkn19012079.outbound.protection.outlook.com [52.103.11.79])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3513E606A31C;
	Mon,  9 Nov 2026 09:05:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3513E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=RcRP2CVb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iFiddbte4vvJxPUNrBRGxW42wkSmz3rZ6iTdKn39QOeyFnSvOjkV5JVp8vvYhb78lhfvFzhEs4qCi57p7MaUtjgrUS4ZELPOJaPOhO078H0oLyAh6XXYDDZAHGx3ZQllTvVjfAY5CRJq0EnzMNUelkbggsijHlrKCuKYm/EKBkMbHOaY7SJRHV/zDJiWlPJl3SXblfdlqwS2qIW7QMMUezEYEg0+oVOjtwSxClCLOI/SoHLp61+aJszlunWRqxTaikWvELNRiGPt9urLIyS/jssKaYzRqwLMAGUfGcKaHuQRzGngZYCYKF09x6ucIlsWWyOxNSTf+PzwJJLtyl9SKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=JtNO1LQAvVkuWjOVwKv9IaK2qv4ZL3i7KGgFIeWF+IY=;
 b=hA5geDGMP2rKHZkm0mVobIUH6BXlBUhOE0HNiADHZx5dO22JLi8GNyGDNAp/6zhQ9NYbcRYhxdmBDYld1yhGOY/XAE0fOH4gxU6edNGWvTlVbDW0OQspXwBdOQGIC2eAtotT2r0o5DSBDe+OvJ3NSxwmWgGy8MW/b3z1MripltV0nB652jOinvhG6+PGvpPf7lYkxJlQ0rgwSh05xTDdxm+AxGqptDgbAB16upH8ql2cIwmC+MbZVOqnkxS6+2ms2Wo/xP0A0Ij6w7ECxQM5Pdzgdgyo0F3vbL6I1O05mKaXH+ieRlKbXpadcpt03RhvpxMGK5YizTCbP+Y1Xmg1ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtNO1LQAvVkuWjOVwKv9IaK2qv4ZL3i7KGgFIeWF+IY=;
 b=RcRP2CVbHzD0yKfHCItGUDe4c4So7glwcyXfnMF4Ond1mK+rx9T7XEtGDwTHbJHcH8UhR4/1whZUiZxYGtVeZWD4lTgXVPf7kAKICEqIdEgKyroolkXQdzaHzWO9guQg0hGrKJnSskmqgIzYYRz7MJvkcQfqezzeqnuH7TemmkICJ9ar+hOAbFduDyCkDvyN5qkfOCQzCX1EKZo6KZr/d1WHpXOxfIE5czQXSgzVHzrlMrm+zRNyxSqo7EGORQ911f/3hh8i/W0krtjbad6/Z1i0wJn8Yciqdhyshc1RkkWGm5Orx0zQ1wT/GBHRMoD8bXfH1BfaVhZ8kB1M0oCuuw==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by IA3PR05MB10668.namprd05.prod.outlook.com
 (2603:10b6:208:536::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 09:05:38 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0592.010; Mon, 9 Nov 2026
 09:05:37 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: Song Liu <song@kernel.org>
CC: Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>, Xiao Ni
	<xiao@kernel.org>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] md/raid5: fix PPL disk add and replacement removal
Thread-Topic: [PATCH 0/2] md/raid5: fix PPL disk add and replacement removal
Thread-Index: AQHdcCl8PumpOy7w+U+zl4LHZPtY7A==
Date: Mon, 9 Nov 2026 09:05:37 +0000
Message-ID: <cover.1794215128.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|IA3PR05MB10668:EE_
x-ms-office365-filtering-correlation-id: e415f602-7d79-4f17-b5a9-08df3e409f05
x-microsoft-antispam:
 BCL:0;ARA:14566002|39105399006|38102599003|8062599012|19110799012|41001999006|22091999003|24121999003|8060799015|15080799012|22141099003|4140399003|24021099003|25010399006|31061999003|102099032|3412199025|440099028|12091999003|40105399003|30101999006|26121999007;
x-microsoft-antispam-message-info:
 =?utf-8?B?T1ZlYllqenprMkRBVTJRVGtUamVJR09qMW56Um9nNmNNNldib0NIcEluR2VZ?=
 =?utf-8?B?bXU5dWZab1NNRFI3L29FYjN0R3prY2dBNnpEYlpzdlllVUNtcWpXR0JaYlhm?=
 =?utf-8?B?MUZ0cnVkQ1Fia2dvQ29Tb3NLMEpLU0xRRkFxS1NMa3Y0L3NBRlBldHpOZWs5?=
 =?utf-8?B?VzJmVG5UWFNJU3FGTnR6aGZZR2xSN3lEcEVYZ0ozVDQzMmcwN3RXcjl1eUw0?=
 =?utf-8?B?OVc4S2NtbmVVV1E0OWFJSUY1SElrY29jaVZNaENJQXVqZGo5OTNPMjFlWU13?=
 =?utf-8?B?VCt6QzRic2d3MklLMjBRS3VrU1hXb2pSOTc3c2EwYTIrdjZJOEdjbUFncnJu?=
 =?utf-8?B?L0FoSFh0QWFRNlY1Mm9ocDBaOTVrTm5DV1BMTWVmdjZMcGplWEJiYS91R2xJ?=
 =?utf-8?B?bk1yOU5KWldGZjVrZVBGamM3eTA0dUR6dGZiM2ZBVGRNSFBOdm53SW8vT2Rl?=
 =?utf-8?B?Zld1QTY1cDIraHJJWmJiN05SNGc1L1hTYTBYR0xBa1RwWWYybnV4U3V2cytl?=
 =?utf-8?B?ZGJ3UTJXR3Bta00xRk5Td3lDa2hSRVo0QnBBaExNVkM4QlBtelZhb2ltKzh4?=
 =?utf-8?B?aytOTUt4cSsrKzRoOW5SM29WYVNBZnNpZnFOQU5sYjEwUUkzYXVSaWFMKys4?=
 =?utf-8?B?UGVFNmJjU1VGbFJIUDdFZGZtcm1Nbmo3Z1Z5V3lXMmFscWxYSFlWMmZWY29Z?=
 =?utf-8?B?RndTd3lYTyt6U0hHUldhdG5HbG16Vno1UGlXSTl1OUNuQmF0K2dIMk9XdDBy?=
 =?utf-8?B?S25VdzlwaCsxTG1Iak5tb3VDb1dpMExrOWgrd1VXN1BlSFYvUGFYQ0RUNDM0?=
 =?utf-8?B?V0JMTkVnYzU4amlNbElSR003TkNyWjQ4RTdhRDlxWlFYaEQ5YnVSdXBjVlk0?=
 =?utf-8?B?QnhOM2x4WE5DTUl1Y0NaOHRoUU82RnVTdkx5UjMwRVlRT3B4N0JmYyt2ODdP?=
 =?utf-8?B?bkt0a241ZzVIMXBWUy9lcWZTNldtUmM4bUVmbFNPZ0RtUE5UV0MxSnJ0Qlph?=
 =?utf-8?B?QUhUMXROc0tKdUdxcS9UOHhRZnQyZDJvaE82NFFVQXpTcWxCTW11YnROSmFM?=
 =?utf-8?B?TXBpa0o3YXY0NWM3R2k4Y1c5SDZXTW12N0kyMzd0eFZCNTBQTG9ZbGlaTEc0?=
 =?utf-8?B?WTJJd2x0L0NjTU5kdVJreVBHYm5JNlgwTFhCcGlWd1RTM2R2aXoyMGd6eEE0?=
 =?utf-8?B?eUZTMXpVcmUxN3BHbENsUVRVTExCMDArbGlyWWlSVkN6R1Flc25nS2QxbGM4?=
 =?utf-8?B?TDJOUGduTnRjQk1PNFBFQlpVQUxMWlFCRTVycm5pWUZqQkhUUi93Z2Vabmc5?=
 =?utf-8?B?cXlra0h4azJ0NEE0WFZzQWJzdEgrZ0U0T1VUSXV1c2FLYUVuWEthV3VnRTU0?=
 =?utf-8?B?UEtZc2h3N1cvWUFrWVVDVE9PTGcwYnBXemFmeml2U1h2bC91Zmdtd3plb0Zl?=
 =?utf-8?B?TVNvSHN6MnFacTR5ekFOQm13aEpzZFRSdUgxS1V1Q0dNUS9kLzJ5RmFwVU5Z?=
 =?utf-8?B?WmdzcVVNR3JjU25BSk9Hb3liY1BwOXNKUEd6SnRsOEliQXhOK3hKelBSc0xM?=
 =?utf-8?Q?g7vxjrF401N06bLiVDvIs1+VQaSKG0rDq14rekiQNIuFLI?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N3d1R3VqdlI5bGE3UVZVclkzUmVGYVZvR2prL2lsWFpOVFlVbDF4by9laXcw?=
 =?utf-8?B?eWhpMytQNXlNbmFZL2xhWUU3Z01ZdHV4YUQ3bEdXVWlnSS9TeVZvc0VOZklW?=
 =?utf-8?B?eE40RXp1QS9mTHQ2bmpWdExiUWh5K3AzQ3IyY29Va3VFYW5Edm5YNGlkVVpi?=
 =?utf-8?B?cEltVmJBMExBUktWcUIvb05LK3JjSG1yWEw1OVBlOC9LRk54cUdsQW1UVDc1?=
 =?utf-8?B?QTRMMXdNWFJLcHRkaG5qdER5c3M1ZDlmbGZpNWwyWXJ5U0sxcHpoYXdEdDk2?=
 =?utf-8?B?N0RPMzNRRTZndVo1V08zbUZoNnBOeTlocnIxY2xXazByOXczQ2l6eEhpbTJQ?=
 =?utf-8?B?TmNFeFZoUXB4RlZwbFAwbEZ6VUprbFQreUJ0SVJpemhsbEVxaDg3SEhOdTJK?=
 =?utf-8?B?S1h5WUFVcVVmMUw5ZEZoeUppdm8zUjJxMmx4TkhPS2QxYWdoemJOb3lKVGJZ?=
 =?utf-8?B?VFJodGF6bWE1NjRnN2tXM2xvTTZ2VThjSzJReGoyY3VFNjVoNEhQdTlmMTM3?=
 =?utf-8?B?cVl3cmFWeFhqcGk3MkRsVDFyeHZXRlNyZW16N2MwbVJoYXl1VGhsSHZmaXll?=
 =?utf-8?B?dFFGMTk4cWQ1d3RncGs4SW9UK0ZsTEYwZ0UwSC85WFRDbTZSVzVmMmZrTVZi?=
 =?utf-8?B?cHFHVnEyUjk0dVhweDVEbUxTSUl3K2dKb1ZtMVZCUTZObjRxUWdILzNON1Zl?=
 =?utf-8?B?QktqUnRyZ05BYkxoR3ExR2ZJY0NtK21uNW4zZy9pWFpaK0JUa2hMc2g0WVpn?=
 =?utf-8?B?MWttelEvNmFzbzNOendWMC92RndkbEluUkR6bzg1ZXY2ekV1RTlOdE1WUHdt?=
 =?utf-8?B?eGticDhjUjg2bEcwRS93WlF2VkJVZXFGN1U3a09UaDlkalBhM0JPVHNOZ0cr?=
 =?utf-8?B?Z1J6eVNDVW5BeGZhL05QajIyWG11ZHNqaXkwS2pQOEZ3dmQ3SlNxa09pV2c5?=
 =?utf-8?B?amZSSitRM2ljVHFqWWdGTFUvcytyVGFLMzlOd1p6dWI0WU95ZXB3TERMeXVE?=
 =?utf-8?B?UkY3Rlp6d3pEcnBFajk4eU42NnYvWTh2R1FIZGhjL25NUXpQQ2ozNUJwUG9T?=
 =?utf-8?B?RWFGU01ieFNiL096eTNzVU9YWWFwQTRuT0NySzBWY1BDdkdTUVpCNkZoc3E3?=
 =?utf-8?B?Umg5RU01MnlNN3N1TVJ2NGY4TXZJZTlUOWNvRTVNb3BDUlBreSt4VG41dEZy?=
 =?utf-8?B?RW02V1hRb0hZbjlHYU4xY3V5bjhEYVVDMk1XWURKUEVZMldnYUpyR2t4cXNN?=
 =?utf-8?B?YUR6U3ZDbU1NRjZUMUcvalBUTzY1cHZyc3JhR2o4TlRsbDJRT2Q2ZHJVL2dk?=
 =?utf-8?B?bzgyb1VMN1NXWjBtTkMxcVBObENkWnRNWFFkRU1URzdNMFlNakQwdVd6N3pD?=
 =?utf-8?B?a2p0aEVZQ096Uk8vQm4vUktZdk9ZcWlnQUhHZlhxWG51eUdQRlJRa3JTaFJj?=
 =?utf-8?B?M2R6NDNnLzFJSGlLNmFERjdyVVRhYTdSbmpvT2RZMm5mcEdHOHRHblRkbjJV?=
 =?utf-8?B?MnRmekJhWGR0Rm1vdVVWUlhRYXlSR3dzOXppc1Q3VWVXcDMzQzlFS0RwSmpk?=
 =?utf-8?B?K29Rc2Z0bjY1MGhPNDVEUE5NNFZKVkdSWXFnYzNCWmFGQ1ltTHZ2dXgweXdl?=
 =?utf-8?B?THo1bE5MZUxWVjFIZkkzVnZxVmViZmIrWUtISU40Y2dLaXdFSHRRalpiRk5z?=
 =?utf-8?B?OXhrR2tIU1hEeEVCdlJHS3ZRUFllU25zbHU3WDVYWE5qYmNEeE1DazNaY3A4?=
 =?utf-8?B?VVdhN0xaZVVqaEFOOHA3eCtmUjhibHhQTURRdjZyU1NmK3hSNUo2c3MvQThP?=
 =?utf-8?B?UHhlK1FkM3R6SnZXaytQaURQNTBmcnh4TVQ5K3llNCsvLzdqTDc4LzVva3li?=
 =?utf-8?Q?yTkrfpV0ccLhB?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: e415f602-7d79-4f17-b5a9-08df3e409f05
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2026 09:05:37.6162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR05MB10668

VGhpcyBzZXJpZXMgZml4ZXMgdHdvIGluZGVwZW5kZW50IFBQTCBkaXNrLXRyYW5zaXRpb24gYnVn
cy4KCldoZW4gYSBuZXdseSBhZGRlZCBkaXNrIGZhaWxzIFBQTCBzZXR1cCwgcmFpZDVfYWRkX2Rp
c2soKSBjYW4gcHVibGlzaAp0aGUgcHJpdmF0ZSBkaXNrIHBvaW50ZXIgYmVmb3JlIHRoZSBjYWxs
ZXIgcm9sbHMgYmFjayByYWlkX2Rpc2suIEEgbGF0ZXIKcmVtb3ZhbCBjYW4gdGhlbiBmcmVlIHRo
ZSBkaXNrIHdoaWxlIFJBSUQ1IHN0aWxsIHJlZmVyZW5jZXMgaXQuIFBhdGNoIDEKcHJlcGFyZXMg
dGhlIFBQTCBsb2cgYmVmb3JlIHB1Ymxpc2hpbmcgdGhlIHBvaW50ZXIgYW5kIHJlc3RvcmVzIHRo
ZQpwcmV2aW91cyBzdGF0ZSBvbiBmYWlsdXJlLgoKUGF0Y2ggMiBrZWVwcyB0aGUgYWN0aXZlIFBQ
TCBsb2cgYXR0YWNoZWQgd2hlbiBhbiB1bnByb21vdGVkIHJlcGxhY2VtZW50CmlzIHJlbW92ZWQu
IFdpdGhvdXQgaXQsIHdyaXRlcyB0byB0aGUgc2xvdCB0YWtlIHRoZSAtRUFHQUlOIHBhdGggaW4K
cHBsX3dyaXRlX3N0cmlwZSgpIGFuZCBhcmUgZGlzcGF0Y2hlZCB3aXRob3V0IFBQTCBwcm90ZWN0
aW9uLgoKVGhlc2UgZml4ZXMgYXJlIGluZGVwZW5kZW50IG9mIHRoZSBzZXBhcmF0ZSByZXBsYWNl
bWVudC1hY3RpdmF0aW9uIHdvcmsKYW5kIGNhbiBiZSBhcHBsaWVkIG9uIHRoZWlyIG93bi4KClRl
c3RlZCBvbiB4ODZfNjQgYXQgdGhlIGZpbmFsIGNvbW1pdDoKCiAgKiBwZXItY29tbWl0IFc9MSBL
QVNBTitQUk9WRV9MT0NLSU5HIGJ6SW1hZ2UgYnVpbGRzOwogICogZGV0ZXJtaW5pc3RpYyBhZGQg
cm9sbGJhY2sgd2l0aCAtRU5PU1BDOyBhbmQKICAqIHJlbW92YWwgb2YgYW4gdW5wcm9tb3RlZCBy
ZXBsYWNlbWVudCwgd2l0aCBlbnRyeS9yZXR1cm4ga3Byb2JlcyBvbgogICAgcHBsX3dyaXRlX3N0
cmlwZSgpLgoKT24gdGhlIHVucGF0Y2hlZCBtZC03LjQgYmFzZSwgdGhlIGFkZC1yb2xsYmFjayB0
ZXN0IHRyaWdnZXJzIGEgS0FTQU4Kc2xhYi11c2UtYWZ0ZXItZnJlZSBpbiBoYW5kbGVfc3RyaXBl
KCksIGFuZCB0aGUgcmVwbGFjZW1lbnQtcmVtb3ZhbCB0ZXN0Cm9ic2VydmVzIG9ubHkgLUVBR0FJ
TiByZXR1cm5zIGZyb20gcHBsX3dyaXRlX3N0cmlwZSgpLiBUaGUgZmluYWwgc2VyaWVzCmNvbXBs
ZXRlcyB0aGUgYWRkLXJvbGxiYWNrIHRlc3QgYW5kIHJlY29yZHMgYSBzdWNjZXNzZnVsIFBQTCB3
cml0ZSBhZnRlcgpyZXBsYWNlbWVudCByZW1vdmFsLiBObyBLQVNBTiwgQlVHLCBXQVJOSU5HLCBP
b3BzLCBvciBsb2NrZGVwIHJlcG9ydCB3YXMKb2JzZXJ2ZWQgb24gdGhlIGZpeGVkIGtlcm5lbC4K
CkFsbCBydW50aW1lIHRlc3RzIHVzZWQgbWV0YWRhdGE9MS4yLiBFbXB0eS1oZWFkZXIgLUVJTyBp
bmplY3Rpb24gYW5kIGFuCklNU00gZXh0ZXJuYWwtbWV0YWRhdGEgcnVudGltZSB0ZXN0IHdlcmUg
bm90IHJ1bi4KCllpbmdqaWUgV2FuZyAoMik6CiAgbWQvcmFpZDU6IHJvbGwgYmFjayBmYWlsZWQg
UFBMIGRpc2sgYWRkaXRpb25zCiAgbWQvcmFpZDU6IHByZXNlcnZlIGFjdGl2ZSBQUEwgbG9nIHdo
ZW4gcmVtb3ZpbmcgYSByZXBsYWNlbWVudAoKIGRyaXZlcnMvbWQvcmFpZDUtcHBsLmMgfCAxMSAr
KysrKysrKysrLQogZHJpdmVycy9tZC9yYWlkNS5jICAgICB8IDEzICsrKysrKysrKy0tLS0KIDIg
ZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCgpiYXNlLWNv
bW1pdDogNDdlMWIxOGYzOGQ3NDAxNWNiOWZkMzBiNWZmMmExZWI4OGU3N2QzMQotLSAKMi40My4w
Cgo=
