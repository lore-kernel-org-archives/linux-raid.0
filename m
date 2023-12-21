Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF75154AA;
	Thu, 21 Dec 2023 07:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="u4VkpnpQ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Cj3cF+6o"
X-UUID: 7f4f19709fd611eea5db2bebc7c28f94-20231221
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=JSPLrIswenw4/VCO5jH374A1m82LA504xQiJzltSu1U=;
	b=u4VkpnpQ7E3mNLoDRuKv/IhdWAATBZZsuSYRVRiXTkhB2qjxaXbTbjkf+tjFPsbhrNawiuL2G0GSg1/trOG232tTiOk/gVbumNT8yebtaWzOwvgozgogEeXh1QK9+903FbyqpmRLchrWhnRhKznliD5MZqBxSEj5Qau1WE5gxbE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:9592839b-b295-4016-8180-27ff979360e2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:5d391d7,CLOUDID:dc4d552e-1ab8-4133-9780-81938111c800,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,
	DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: 7f4f19709fd611eea5db2bebc7c28f94-20231221
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1620122746; Thu, 21 Dec 2023 15:56:50 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 21 Dec 2023 15:56:49 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 21 Dec 2023 15:56:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RfYa4aWSaoCNKYsGuLl3Bxw+9lZ0fKO+GU+wOel6zvESZ+RKrCNr87TVA79iZBAgOqElfUOLF148aRp83r9JXrmxZOi8XouQWYR4vZWo783DiburCzYWr4xDoeYWdvpZV73+F2k08h2B3XT5AfYXDK0YzAX3vEk1MOkR03vcdcsFQi+NT2M9lDm88xjMBfFAmoBBpdt+4yZ/5P+BNNwOvoMdIA+GrRAKNsAUxRfQhaQKzQjbijxzfayJp8CQsHLI9qX3nw505f3d5RwJ4dUegXD86WXWqf1QQhXipIjutp9+VsPY/oZXpnzi3sCDCafjzWFsRLZ99meqXBXrf5e3aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSPLrIswenw4/VCO5jH374A1m82LA504xQiJzltSu1U=;
 b=B3V+KlExbjOuk9Wbw9YnA3Pj5wF32D7L9J1wMJm6D9eBg31PDleGsychrvC7bit1HIkdxUSWnFSb93ykJt2Gi5Lok7oXEZTcVFoP7OhGZHkn8oIrnLdzImzWRdkU5q73K/y702v/xC0P9pAdROMUxOk3xjUPRHOs2F0tr83O/aqpCUyow7IU1EJc+YPxPy16lIewrQnf0GHkjScaPmdBLt6t0mbS0TJhzA8K/aGeB+TxGzvRARbih0VTK22AEAxLljr+2lyHluK096D6dgZLH1fPrcw3enxndyZ48g5XifOj4GF99zNe7s+zBuyZSYYI5y6RKvkHQn1WgqM4pgSPXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSPLrIswenw4/VCO5jH374A1m82LA504xQiJzltSu1U=;
 b=Cj3cF+6ohrL2XJ0njYH4Ft5I+2HHXHloKAW+jDsXFxDWcPJklRc06sgIs4PmXngfick5A9EQU90vJteRwQeC981lWkgc47TP1mufLQlgKBB+nx1rSBrMMk4syVRT/pIYhCkItbbqvhe54NC2dn8Bp59pCyTWEBQOLxFocbVE+tc=
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com (2603:1096:4:131::9) by
 TYZPR03MB7519.apcprd03.prod.outlook.com (2603:1096:400:425::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.20; Thu, 21 Dec 2023 07:56:46 +0000
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::d398:103e:796d:76b9]) by SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::d398:103e:796d:76b9%5]) with mapi id 15.20.7113.019; Thu, 21 Dec 2023
 07:56:45 +0000
From: =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>
To: "kent.overstreet@linux.dev" <kent.overstreet@linux.dev>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"colyli@suse.de" <colyli@suse.de>, "song@kernel.org" <song@kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "janpieter.sollie@edpnet.be"
	<janpieter.sollie@edpnet.be>, "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] block, md: Better handle REQ_OP_FLUSH
Thread-Topic: [PATCH 0/2] block, md: Better handle REQ_OP_FLUSH
Thread-Index: AQHaM60rpds0RfSqekKon2ULHGSqc7CzFnWAgAAfvwCAACjtgA==
Date: Thu, 21 Dec 2023 07:56:45 +0000
Message-ID: <fb146972062ea1547eaa809817237f7c546a9e88.camel@mediatek.com>
References: <20231221012715.3048221-1-song@kernel.org>
	 <9dfc7e93f49f5b3595985ce6ed60e4c08cf05a4c.camel@mediatek.com>
	 <20231221053016.72cqcfg46vxwohcj@moria.home.lan>
In-Reply-To: <20231221053016.72cqcfg46vxwohcj@moria.home.lan>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5545:EE_|TYZPR03MB7519:EE_
x-ms-office365-filtering-correlation-id: 58855add-f6d0-47a6-c8cb-08dc01fa60eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GHKRg/1eMcBXhDArmNxWe2s+03LKlAs9rh/tSyTYQi4bKqaDaEZNBKYKplxNR2j4SH3wP4KjWAYHtX6vNXKcpJamAZ+rurhy4RU4QUHmPVCiqUrFl/biEq1EBNnTuIxtN7GI2h6+S4yJLNB/ncaAEq56AkLtwoJ09TQjr/kZZIvgcJ/v35zNNjH/kFxLII6x1gSsxRB/PZsfgYpimLZNHouDyx1WB79SG0iQ4fu4Sh+MylPn8uMyACPzRJ+9F2JdmQzqhwb/+BAgy0+QOolOVwA6nH+yqoci5ugEPO+NmxaPXjsLbqslfdWNSyqJj1zp1+6biw+gWnniYDJKc1yJTN6v+zN1LbrsgT2BStZG0+351mO8zCjtqOoTrprvPeEYn16u7QctoLMuurKXY5owhobDKzO5oObSwWAl3oQ9dTqTP5+B2iR86gaybE68aEbQULwn2/t505xxc/mdkUX0DNVCZx2nkXG6F2zjMBBHhcy1T3Gljpty8vZ+MvTlPm8R+thrzcyG+ozlOAKUbIpcMupr+1845DGepeuauElls0jkwaPjta+uSt6l5D3N52JEWPNlpxe2WH61x4+CGjBGL56euuxxF+15eGH+9VoafW40P9Bp2Xyvb7N6x+jakgiaxSWT5VQe6TxfnIiwHbzUyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5545.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(376002)(366004)(39860400002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(6486002)(71200400001)(966005)(478600001)(54906003)(6916009)(66476007)(66556008)(66446008)(316002)(64756008)(8676002)(8936002)(66946007)(76116006)(91956017)(83380400001)(6512007)(6506007)(26005)(2616005)(41300700001)(2906002)(4001150100001)(4326008)(5660300002)(86362001)(38070700009)(85182001)(36756003)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODVXdnlQZm1JVVpycWE2eTZadmthMDFxOEZtWG9FU0UwR3RSeWUwNTllYlhx?=
 =?utf-8?B?VlN5YUZRTlZ2aVlQdHIrQVdyK0dvdGRxb2ZwWUV6VzROYlVpUjB4TVIxaWNu?=
 =?utf-8?B?WEpFNXJXaTVzOVo5UTd2bFdGTnNMQTV6eFR4UXRtVWE5dkRNemo1R2JLNEdu?=
 =?utf-8?B?SnVtL3djQUgrWmR6UTkrdGNsTXdFTWZ0aVhHWk9JaFB6MmtmaUlOL3ZEekpH?=
 =?utf-8?B?Q3o4NlYxMmlTSW44MTdPN0kwZEdiTkJpTFRsVGdhODlVYTRDQVZUWWlIT1dX?=
 =?utf-8?B?TkNOcVhQUW10YjA1cm93QjBZbml1SmJ2STl1aU0xRGNWNThVaE5JOTdSYjZD?=
 =?utf-8?B?SWZEeGwvL3o1WlZPMXNaNVVIZDEwczhHNzQ4SmhkQXlzMHFzWDRpTnllSWJ1?=
 =?utf-8?B?ZFdTTTY2WTRpWmZDOVdJMWwxVUcwTFpNL1ZwR3hmV3lmZHIzaDFqbFpad3g5?=
 =?utf-8?B?RmROdzFzeVRJbDZ1aHh2R0d4bHdhS1ZrWEx2RzV3VWVsS0RkV1lpbXg1aVRj?=
 =?utf-8?B?VUlaVkx4MjJIK2ZqRGt2NmNZcUhnaWNrWGhpdzRYdkF4em5HOVJ1SUxFcDlM?=
 =?utf-8?B?Rkw1Y2VUbzNwV1BTdkwyTldkZEZKK1J3QVJvSkpLVi9SVmZMSWFDVkMxYzg0?=
 =?utf-8?B?UHR5VTBaUUFEL0lBZy9jYTJwbTc1ZDQ3SExTK1JQaUxyd1VvcVZOTXhSdFJv?=
 =?utf-8?B?NEhRZERtRHFiOUg0dWxBQkZSL0VXZG5SNGZhVjA4aGR4YzQvQmlOK0J5UTFj?=
 =?utf-8?B?bzdwZnVKbjNaOWk4U1k4ZEVqeWRyTDhxTkRpWXpXejYwL05HSldsM0NXaUFo?=
 =?utf-8?B?TTh0V3B0TXdHWUd4T1lvcjNXTnl1Yzlxa3E4WGNCTHpON1B3MzBETHZjS0xN?=
 =?utf-8?B?akN6SVRxSVZNbzd6QnNEdmZ3bWdJKzMvWisraitPVWlQWEhIdXZ5YVE0OWQ3?=
 =?utf-8?B?RndhcjFicDhFaURQTGxYanNyd1p5L21pTjFLSzhkdFZLQ3hTcHEyOUdVMGpr?=
 =?utf-8?B?ZDdDS3ppb3RybE1qSWM0ZTNMaWpDMjJFWUlhVEY3eDViWlJtbVdMeUkyRno5?=
 =?utf-8?B?M3psaGtlMTkyR25Rb1NmVWpCZzJ0VGgyeVNvM1d0b0dvWG9YSWRRK2xVUUhR?=
 =?utf-8?B?VkhLSXdIZC9OZWVnUkVtUFNTdE5vOXNuWm9BVkYrK25NbUVRVUtheTFQcDNR?=
 =?utf-8?B?ZzdHbHRUK1I4OUZEclZqdnJ2d1Ria3F4TmtNTTVpeVQxK21jQVN1T2FlUS9i?=
 =?utf-8?B?ZzFEUDMrV0dqMlNDbU1PUUNoMm1UdUZkTk42bVAyZkRwV1hCUlphNE91MnJZ?=
 =?utf-8?B?c1RrSDFTQlcyNGN0Z05uVlhQaTkwQ2JtZHlEdFI2ZTNlSDJ1Nk9mRVlNcWRB?=
 =?utf-8?B?VDgrMktST3ZvUmwrR1RJM0lXSHhZbUtNYkZtUVREZzVxNmphU0I4SnJteWZt?=
 =?utf-8?B?WXZwOGJmWHZLc1N3YVVpTFV6MDR1ZzlxYzJNYmhFRVJIS0VneEZnR3NIbUxM?=
 =?utf-8?B?MFgvOFZIc3lXZ2hPZXNvQUJ6MUl2ZmRMMURBMkxlSkIrNldYQzE1NG85SkJ2?=
 =?utf-8?B?aThxeUd2ZGh3Uk9xUG04bUlPWmVrejB4RjJObm5RbFVZenk0d0dSeDBxU1Zv?=
 =?utf-8?B?a0Y0Q3Rob01ibTArUFJCQ2R4dU11elpUeEZKY3QxVDNNQkdPbk9mRHlHb1VS?=
 =?utf-8?B?eU5abWpZWkdzQ2RyS3hFbnk1VEtWSExNb0lzRjByVEVCRjU0eHdlWml1OUti?=
 =?utf-8?B?dzF4WjVDZFRad2hhKzlrMVZ0SFJIOElZNmN2VTUzSFVGNUVSZDFBYWNGblZu?=
 =?utf-8?B?UXg0KzlzeDBmUGQxZERNSzAzWCtpdUdYdmVKd1NRZHVTbi9MLytrMGFNRmln?=
 =?utf-8?B?a0E4MU1yWWRNRnBBNHJJZDRiMkhreXI0MnZLSkxJb2x3b2xaKzN2TWxsN2kz?=
 =?utf-8?B?UjlGbHB0cjdOSnJKbHZadlQyZVJzM3FHRWdFWnJTQURSTTByUEhGalhCbGo2?=
 =?utf-8?B?RjQ0SUE5anFGR2pGb29HUEhCOG1RWko2ZmdQOTUxMERUajRMRFB4aEE0cDJX?=
 =?utf-8?B?TTluajBIdlVEWHJrcXNvWFhFeUwrK1AyVFJ2dUJnRUJTVkRCWXZpODJaM3Fr?=
 =?utf-8?B?ZzF0TmdLdTVrNUhMbkx2WEhNMUdjVnJvbXhVOCtvc1lDMzkvY1I3K2Q2anY3?=
 =?utf-8?B?akE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D080262016DB6648B7CA7AB1A6B5DF5C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5545.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58855add-f6d0-47a6-c8cb-08dc01fa60eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2023 07:56:45.8870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zSlH+z9cMaQ5Duw0jiM2YOBa7s9t+3bvhXoTMyNkelPrvq/b5TB7xYcssHxnzx5wtOZMUD5mnf4KW86imYoqSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7519

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDAwOjMwIC0wNTAwLCBLZW50IE92ZXJzdHJlZXQgd3JvdGU6
DQo+ICBPbiBUaHUsIERlYyAyMSwgMjAyMyBhdCAwMzozNjo0MEFNICswMDAwLCBFZCBUc2FpICjo
lKHlrpfou5IpIHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAyMy0xMi0yMCBhdCAxNzoyNyAtMDgwMCwg
U29uZyBMaXUgd3JvdGU6DQo+ID4gPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiA+ID4gIEEgcmVjZW50IGJ1ZyByZXBvcnQgWzFdIHNob3dzIG1kIGlzIGhh
bmRsaW5nIGEgZmx1c2ggZnJvbQ0KPiBiY2FjaGVmcw0KPiA+ID4gYXMgcmVhZDoNCj4gPiA+IA0K
PiA+ID4gYmNoMl9qb3VybmFsX3dyaXRlPT4NCj4gPiA+ICAgc3VibWl0X2Jpbz0+DQo+ID4gPiAg
ICAgLi4uDQo+ID4gPiAgICAgbWRfaGFuZGxlX3JlcXVlc3QgPT4NCj4gPiA+ICAgICAgIHJhaWQ1
X21ha2VfcmVxdWVzdCA9Pg0KPiA+ID4gICAgICAgICBjaHVua19hbGlnbmVkX3JlYWQgPT4NCj4g
PiA+ICAgICAgICAgICByYWlkNV9yZWFkX29uZV9jaHVuayA9Pg0KPiA+ID4gICAgIC4uLg0KPiA+
ID4gDQo+ID4gPiBJdCBhcHBlYXJzIG1kIGNvZGUgb25seSBjaGVja3MgUkVRX1BSRUZMVVNIIGZv
ciBmbHVzaCByZXF1ZXN0cywNCj4gd2hpY2gNCj4gPiA+IGRvZXNuJ3QgY292ZXIgYWxsIGNhc2Vz
LiBPVE9ILCBvcF9pc19mbHVzaCgpIGRvZXNuJ3QgY2hlY2sNCj4gPiA+IFJFUV9PUF9GTFVTSA0K
PiA+ID4gZWl0aGVyLg0KPiA+ID4gDQo+ID4gPiBGaXggdGhpcyBieToNCj4gPiA+IDEpIENoZWNr
IFJFUV9QUkVGTFVTSCBpbiBvcF9pc19mbHVzaCgpOw0KPiA+ID4gMikgVXNlIG9wX2lzX2ZsdXNo
KCkgaW4gbWQgY29kZS4NCj4gPiA+IA0KPiA+ID4gVGhhbmtzLA0KPiA+ID4gU29uZw0KPiA+ID4g
DQo+ID4gPiBbMV0gDQo+ID4gPiANCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBz
Oi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjE4MTg0X187ISFDVFJOS0E5
d01nMEFSYnchZ1FianRTX2Y1ZDNEdTJwcnBJVDh6VU00bWtaZjdxRGxleWFBdUVmRzhqNXRNckR2
dzdjZkpVQjA0VldsMHVWQUw0Qko0WVdiVm9wcCQNCj4gPiA+IA0KPiA+IA0KPiA+IFJFUV9PUF9G
TFVTSCBpcyBvbmx5IHVzZWQgYnkgdGhlIGJsb2NrIGxheWVyJ3MgZmx1c2ggY29kZSwgYW5kIHRo
ZQ0KPiA+IGZpbGVzeXN0ZW0gc2hvdWxkIHVzZSBSRVFfUFJFRkxVU0ggd2l0aCBhbiBlbXB0eSB3
cml0ZSBiaW8uDQo+ID4gDQo+ID4gSWYgd2Ugd2FudCB1cHBlciBsYXllciB0byBiZSBhYmxlIHRv
IGRpcmVjdGx5IHNlbmQgUkVRX09QX0ZMVVNIDQo+IGJpbywNCj4gPiB0aGVuIHdlIHNob3VsZCBy
ZXRyaWV2ZSBhbGwgUkVRX1BSRUZMVVNIIHRvIGNvbmZpcm0uIEF0IGxlYXN0IGZvcg0KPiBub3cs
DQo+ID4gaXQgc2VlbXMgdGhhdCBSRVFfT1BfRkxVU0ggd2l0aG91dCBSRVFfUFJFRkxVU0ggaW4N
Cj4gYGJsa19mbHVzaF9wb2xpY3lgDQo+ID4gd2lsbCBkaXJlY3RseSByZXR1cm4gMCBhbmQgbm8g
Zmx1c2ggb3BlcmF0aW9uIHdpbGwgYmUgc2VudCB0byB0aGUNCj4gPiBkcml2ZXIuDQo+IA0KPiBJ
ZiB0aGF0J3MgdGhlIGNhc2UsIHRoZW4gaXQgc2hvdWxkIGJlIGRvY3VtZW50ZWQgYW5kIHRoZXJl
IHNob3VsZCBiZQ0KPiBhDQo+IFdBUk5fT04oKSBpbiBnZW5lcmljX21ha2VfcmVxdWVzdCgpLg0K
DQpQbGVhc2UgcmVmZXIgdG8gdGhlIHdyaXRlYmFja19jYWNoZV9jb250cm9sLnJzdC4gVXNlIGFu
IGVtcHR5IHdyaXRlIGJpbw0Kd2l0aCB0aGUgUkVRX1BSRUZMVVNIIGZsYWcgZm9yIGFuIGV4cGxp
Y2l0IGZsdXNoLCBvciBhcyBjb21tb25seQ0KcHJhY3RpY2VkIGJ5IG1vc3QgZmlsZXN5c3RlbXMs
IHVzZSBibGtkZXZfaXNzdWVfZmx1c2ggZm9yIGEgcHVyZSBmbHVzaC4NCg0KPiANCj4gQWxzbywg
Z2xhbmNpbmcgYXQgYmxrX3R5cGVzLmgsIHdlIGhhdmUgdGhlIHJlcV9vcCBhbmQgcmVxX2ZsYWdf
Yml0cw0KPiBib3RoDQo+IHVzaW5nIChfX2ZvcmNlIGJsa19vcGZfdCksIGJ1dCB1c2luZyB0aGUg
c2FtZSBiaXQgcmFuZ2UgLSB3aGF0IHRoZQ0KPiBoZWxsPw0KPiBUaGF0J3Mgc2VyaW91c2x5IGJy
b2tlbi4uLg0KDQpObywgcmVhZCB0aGUgY29tbWVudCBiZWZvcmUgcmVxX29wLiBXZSBkbyBub3Qg
bmVlZCB0byB1c2UgdGhlIGVudGlyZSAzMg0KYml0cyB0byByZXByZXNlbnQgT1A7IG9ubHkgOCBi
aXRzIGZvciBPUCwgd2hpbGUgdGhlIHJlbWFuaW5nIDI0IGJpdHMgaXMNCnVzZWQgZm9yIEZMQUcu
DQo=
