Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55258F47;
	Thu, 21 Dec 2023 03:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Fhe9yD8J";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="VUilSDTG"
X-UUID: 2a5950ee9fb211eeba30773df0976c77-20231221
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=u79u3nrEszlnx2bXwBvmStlsjbEPYjcwwLOlNL4EupE=;
	b=Fhe9yD8Jv7qIQlP4Sc/+szTASXY3qDkmj7BsQ4tnrVngiq9oeMhSGXnX/6V8CJ6JTOef2n86/8czYAnJhnoGEdegBsA5Qy2a52LySN4z40eoWinsHeH0WAfovm66RCdiknb3eFBc5TRWEjkPtVpvIoLbZChWmLAPawn6e7AeYL4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:6d4cfa0c-2fe0-4a68-80b5-923ce1056ccd,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:5d391d7,CLOUDID:0ba7522e-1ab8-4133-9780-81938111c800,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,
	DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: 2a5950ee9fb211eeba30773df0976c77-20231221
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1345405011; Thu, 21 Dec 2023 11:36:45 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 21 Dec 2023 11:36:44 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 21 Dec 2023 11:36:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2m0B9TNme/xsO0JVtGIsXgvaEn80B2JlGF2yrba+w21pACWbKAq7qpV0z37RLNe/aX/anK0Ijn8ecpyVf6VOW1YZgrbIKdSibhj5egAFOl52qKa7q12G4QIk2mTV+UxZJkpfPKKgk1rFA/GNvpKAO26JChbyUjl7QomJTrzSt/nP+CAPgr9V3lNQyL6dFPVFDnd4AQH7i7WFBYK1oFRjITLxfmF/n9nhsTa6ZNhgvabNpK+dIfd+0MwITV47EJDkazfRDq+ZnCtc7tYc1WbPHhCLUrHDokzsiMg4zlQ6M1+Z4hv2yTE/Uz+btwb0CT9zHw/iHMFGq1WGpkXcvTItA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u79u3nrEszlnx2bXwBvmStlsjbEPYjcwwLOlNL4EupE=;
 b=csJIAw8Qn1J3luhszr7lgVCb0uYjPdKWNR/QEY1zECuA71fEvQR+I3RJLU5enRvqr5+uYv1M/25TJ/aElU5ZKLUmCfYT4INzyYOnXmICpGPuk/TYcs7Bdx6wzIwtLCdWLZ7GPUeWmMEjvsfE74ndXCQEAYc530XtgNikCErclAMe+3HJepmiRo10zCQOjUIlFoYcsm+e9YNK3DsxOFzyYvZ+CxzHS6vHNlqSnVk5zJVlMZp6Mo73yX/rIMJDj4hPnCpDCEm6zWNP54rUfxMctsjzWT2WL3QQYuh7q7F4OWsDLWmKxr5vf7MZM7utAqPMYLCVXiV+PAnycV4vFn8ujA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u79u3nrEszlnx2bXwBvmStlsjbEPYjcwwLOlNL4EupE=;
 b=VUilSDTGBOld1aa91GUVtV6MCQXOqm7fi4GaV9N05367ZTcrMAoZt1fHah0UA9Yh/VS/vTIYlmymmaITP+4dH6sMgJ+z8U4e7x9IRYRHd4BBID60ObViIHP4Gtkp9xUx76Pz4/Wx4UIUHRSzgP0qD6XQDUSOpW3dhdoIOXtrAtg=
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com (2603:1096:4:131::9) by
 TYSPR03MB8081.apcprd03.prod.outlook.com (2603:1096:400:470::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Thu, 21 Dec
 2023 03:36:41 +0000
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::d398:103e:796d:76b9]) by SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::d398:103e:796d:76b9%5]) with mapi id 15.20.7113.019; Thu, 21 Dec 2023
 03:36:41 +0000
From: =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>
To: "song@kernel.org" <song@kernel.org>
CC: "bagasdotme@gmail.com" <bagasdotme@gmail.com>, "colyli@suse.de"
	<colyli@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"janpieter.sollie@edpnet.be" <janpieter.sollie@edpnet.be>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "kent.overstreet@linux.dev" <kent.overstreet@linux.dev>
Subject: Re: [PATCH 0/2] block, md: Better handle REQ_OP_FLUSH
Thread-Topic: [PATCH 0/2] block, md: Better handle REQ_OP_FLUSH
Thread-Index: AQHaM60rpds0RfSqekKon2ULHGSqc7CzFnWA
Date: Thu, 21 Dec 2023 03:36:40 +0000
Message-ID: <9dfc7e93f49f5b3595985ce6ed60e4c08cf05a4c.camel@mediatek.com>
References: <20231221012715.3048221-1-song@kernel.org>
In-Reply-To: <20231221012715.3048221-1-song@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5545:EE_|TYSPR03MB8081:EE_
x-ms-office365-filtering-correlation-id: ec32105d-15e0-4e1f-786f-08dc01d60ba8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1WVDsEBlWbwCaFKLhHIgVQDCxzohMt2QtCLZEp3piM4AqG+BKlsWpZ+HLp6N3lTdWRg/MJ6zNNDDx3n11ExC68TyNccvJH2DTGfpNgqEg0mayJ2sUmPleOWm/Gr5D/NEQXpqTI6+KG+BXewGdqrhm+WYluDUNXb0oweRkfpldxvMuW6NrRYi2s9MilPM5V1+mabJyrUWpjUCg5rHiXGzWVfv/vPKFeIE1HjuIvQUrGEt5PC7NSTgnqEJNl+bkeBRly87ijJfybKVpLjPvrL8TIu7OR0d0CW0Ne/5RSC5kCLO0eZOHxmcNF/LIO6erPvsX4bQVoBppM3zNv4ldhgm9kqJpRZKR0dFR23F9NzpYy3dzyS3nEbs0MMgWRgv8mwlHZeZ6ILPtTctpmW1AP0JqsnAb71vkOUo9IxkxJBcCevAYmQpokvBPxkOXneDWIXcxOrIVWTF0to4Lm3T5BSmdTPjwIqoc8SOmwzwZ2U7BK72THbTpA9160zXN3Wy2HQlhRpKmDJ8Y1CVEs2QZmCwKAFonhfSTT8hYw/pLDLRCHtdKWtgyZy4BJKX1VJo2q/N6v9Tn/t1MTAeDcZBhWBIizE6tQEoHlO8pqLpOX4A4sOrr3Ojq6oh4n/353nghujfv/mB0Z0Ixe2xBbci1GV0WhzHwG1psjw6sFlV35SBPpMca5K441Csw+D5gzoS6uCt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5545.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(346002)(39860400002)(376002)(230922051799003)(230273577357003)(230173577357003)(186009)(451199024)(64100799003)(1800799012)(38070700009)(4001150100001)(85182001)(38100700002)(36756003)(2906002)(122000001)(41300700001)(83380400001)(86362001)(8676002)(8936002)(6486002)(4326008)(71200400001)(966005)(478600001)(2616005)(26005)(66476007)(76116006)(91956017)(54906003)(66946007)(6916009)(316002)(66556008)(5660300002)(6506007)(66446008)(6512007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1dKUmUva2R4d21kL3NjdnVmMCtwN1pwOWdUb1hWUFU4RjJvM3NjRkUrTTJF?=
 =?utf-8?B?ZkhkWHFkOFYzcFpuQ3FqV1dmWXpkZ3JsZ285K1lHU3l5a0NucmNQMXlBcjlF?=
 =?utf-8?B?d0hJZmVEZkgzVVdiM1lOMktyaHkwczgybk1lclpiZ1hjaHVLckpRL3U3NjFB?=
 =?utf-8?B?eGp5OHVLV0l3SWQ2endWdTlqSE5wVHUxY0dlb2lVV2swRzJQaXpBYlZvK1Aw?=
 =?utf-8?B?Tnh0MFFhZTQwUis4TExNQVZGWDdZbVJIUDJGOHlzODc2Ukk2L2ZoZEEybnNk?=
 =?utf-8?B?R0ZCbWQvVEE0QUNtQk4rRmRZeE1ncllOMEYwWUJ4bVAvc2hvdGFSRTgreU5U?=
 =?utf-8?B?QUNnNm1MMDZsSjdvNE1oYjBUTmJLZlRLZWhtdlNBaHZNbUNJbkRiUXR6RnBV?=
 =?utf-8?B?Yy9pTUtIUGsyc09RUzRtTW04MFNmWm1RbERyMzFwQ0xtd2NyMVArK2s1cjc5?=
 =?utf-8?B?WkluU3kxSm04QTg2N2F6em1aN3B4TmxtNEhJN2I1dG5ZeTdUdWg1ZTRFSlZl?=
 =?utf-8?B?TTU1TWkyc3pnR0NlTnRCaTg0RStWS3E2eno1ZTl2Z0dKR0NLaHVoRnlKcmJS?=
 =?utf-8?B?Kzh1WGNNSnYvbUV5SG43MmZDOFVEU2pRWlh5SzFmMlpxOXdKUHFyS2RTSW5L?=
 =?utf-8?B?c09maFk5TGVaUnk4dTkrd21zWXZOSmwwZ1paUkx1N01OTTlkQ2JoNEd5azFz?=
 =?utf-8?B?M0MxN3hZUHkrQ3d1U2ZLV3d3WUpvSEpjYUk3TGx1QjB6WDFPbmhCdzZUWko1?=
 =?utf-8?B?OFhXTitqRDdwZDNmQml4VStnY1lMNEJHYWNacjl2RllWWGVRc3ZLbi9vMUwr?=
 =?utf-8?B?K2ZXNmd5VmxGVFREcUR3b3JoNUFDWjdlN21PekQzeFlHOHVENUZYSmtyZ0lv?=
 =?utf-8?B?eFhHTGpuMk51S0l2MFowZjMvZkhCRHhONmxBUHpQM0FaK2tGWENmR2ZkS1ll?=
 =?utf-8?B?M3lTdTV0MWtKZCtIQnJJSGhIUUZGR2RrSWxna3F2VFV6eWFvYmFTaFM5U25l?=
 =?utf-8?B?Y01uaE1zR2M0d2dQVy9xZ01jYnJzRnlsN1JjenhUVDUzV0NuKzl3K1l1ajhX?=
 =?utf-8?B?WnU5cXZDMlMxaW8rTWdqaGdRVlN6cFVwRGd6aDRaamhqR2NFVGQ5alA5WEJH?=
 =?utf-8?B?ajJrU1dqRExlVkZ5dkptT1M3ZGRhQjFKZmRPT3BhM2h2cGpBUWtDcVVnVjBF?=
 =?utf-8?B?S2xBeUlyUC9tcjlsR3djLzRORWxqaEVvWkZBK00zL282OWRHdC8rckJrZnd5?=
 =?utf-8?B?VGJkcDRpcHA0emsxbjZIMzZ1OVFENUFvRTFtb3lhaWJqaE5UWUE2UUNza3NT?=
 =?utf-8?B?aktRQ1BIK0NoQWluS0JDU1VoRUFWdTJOejgyOGxxSTAySXFjLy9Bc3FYQkp2?=
 =?utf-8?B?aFFsSTlrNFMwcUp2RmIxQUpDUGs1MDIwbC8rUldRdlg1L3dpZTB4eG1UeGc0?=
 =?utf-8?B?bElPbjBjRWV1UWVQdmV6MGoxK3ZYQi9IZHNzRnZHa1NLY2tRVEJ3MFNqOGRt?=
 =?utf-8?B?c0l5RDRJcDVWK3lmK21tVUlyT0xXdjFnSHgycmRjcHAvNEcxeVF4dkQ0bjZY?=
 =?utf-8?B?TG1pNTBIVjhpL2ZFWFFzUnZrSGJuQWlydTUzeGRjZjVhY1ZSdjBrUWlNV3Bm?=
 =?utf-8?B?OVk3SDJUbHFZRE1yaUdqQ2dQQTB3bmRaRE9FZ1B4NnNTVk54M3FGblZodGFs?=
 =?utf-8?B?VzBuaG1Ga1ZTOXNYb0ZZdVpoMlYxS0RxRGd5QmdvSnd5QWthVitscnJwOUMx?=
 =?utf-8?B?U056dzUwRXRPWGEyQVMwbnJzeEhweGpNbzdCTDNaZlZVTXAvZGNuVGNoSXRV?=
 =?utf-8?B?SVh1enlEMFYxTTBWZVArZmFBYU91SUxzamxqNy94WUdUU2UvWjR5amRoTk9F?=
 =?utf-8?B?d2RlVlZ2VU84ZGJzYXVKaG10Z0h1M3EvZ2l5RkphMnR2c0phU2tqc1VuR1FS?=
 =?utf-8?B?eXhSWk1PUlJyTG04QXlDV3lER3lKSEVWRzFDN3lEYW53OU9BdjR4cXdjQzlT?=
 =?utf-8?B?NnQ4LzExT1g2RmNFZ05la3NqUlU0dlJiMXNhVll5NEtsaUg5ZnU2WGl2REFl?=
 =?utf-8?B?TGI0eExENXJsNTVSRUhVV3VlNWczS0JHM0wzRWt3dnl5czBYakNTL09ISTJm?=
 =?utf-8?B?NkVHclpwaHB1aFJ0V3lFTzd5QzlHbXlHZm50TUFhZDBWeUltM2tMcXVhVWVF?=
 =?utf-8?B?bnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CE2AB3FB26C2143AD9CBC307A28B734@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5545.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec32105d-15e0-4e1f-786f-08dc01d60ba8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2023 03:36:40.9233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AqLhjgLRezlKCTDaeoIS1tCXhx/on99G2mTmoFHHxbEMdZg2qp1h5ga/zfoOGYwRajXBEdDrfzvQqGzKEHXM2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8081

T24gV2VkLCAyMDIzLTEyLTIwIGF0IDE3OjI3IC0wODAwLCBTb25nIExpdSB3cm90ZToNCj4gIAkg
DQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhlIGNv
bnRlbnQuDQo+ICBBIHJlY2VudCBidWcgcmVwb3J0IFsxXSBzaG93cyBtZCBpcyBoYW5kbGluZyBh
IGZsdXNoIGZyb20gYmNhY2hlZnMNCj4gYXMgcmVhZDoNCj4gDQo+IGJjaDJfam91cm5hbF93cml0
ZT0+DQo+ICAgc3VibWl0X2Jpbz0+DQo+ICAgICAuLi4NCj4gICAgIG1kX2hhbmRsZV9yZXF1ZXN0
ID0+DQo+ICAgICAgIHJhaWQ1X21ha2VfcmVxdWVzdCA9Pg0KPiAgICAgICAgIGNodW5rX2FsaWdu
ZWRfcmVhZCA9Pg0KPiAgICAgICAgICAgcmFpZDVfcmVhZF9vbmVfY2h1bmsgPT4NCj4gCSAgICAu
Li4NCj4gDQo+IEl0IGFwcGVhcnMgbWQgY29kZSBvbmx5IGNoZWNrcyBSRVFfUFJFRkxVU0ggZm9y
IGZsdXNoIHJlcXVlc3RzLCB3aGljaA0KPiBkb2Vzbid0IGNvdmVyIGFsbCBjYXNlcy4gT1RPSCwg
b3BfaXNfZmx1c2goKSBkb2Vzbid0IGNoZWNrDQo+IFJFUV9PUF9GTFVTSA0KPiBlaXRoZXIuDQo+
IA0KPiBGaXggdGhpcyBieToNCj4gMSkgQ2hlY2sgUkVRX1BSRUZMVVNIIGluIG9wX2lzX2ZsdXNo
KCk7DQo+IDIpIFVzZSBvcF9pc19mbHVzaCgpIGluIG1kIGNvZGUuDQo+IA0KPiBUaGFua3MsDQo+
IFNvbmcNCj4gDQo+IFsxXSANCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8v
YnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjE4MTg0X187ISFDVFJOS0E5d01n
MEFSYnchZ1FianRTX2Y1ZDNEdTJwcnBJVDh6VU00bWtaZjdxRGxleWFBdUVmRzhqNXRNckR2dzdj
ZkpVQjA0VldsMHVWQUw0Qko0WVdiVm9wcCQNCj4gDQoNClJFUV9PUF9GTFVTSCBpcyBvbmx5IHVz
ZWQgYnkgdGhlIGJsb2NrIGxheWVyJ3MgZmx1c2ggY29kZSwgYW5kIHRoZQ0KZmlsZXN5c3RlbSBz
aG91bGQgdXNlIFJFUV9QUkVGTFVTSCB3aXRoIGFuIGVtcHR5IHdyaXRlIGJpby4NCg0KSWYgd2Ug
d2FudCB1cHBlciBsYXllciB0byBiZSBhYmxlIHRvIGRpcmVjdGx5IHNlbmQgUkVRX09QX0ZMVVNI
IGJpbywNCnRoZW4gd2Ugc2hvdWxkIHJldHJpZXZlIGFsbCBSRVFfUFJFRkxVU0ggdG8gY29uZmly
bS4gQXQgbGVhc3QgZm9yIG5vdywNCml0IHNlZW1zIHRoYXQgUkVRX09QX0ZMVVNIIHdpdGhvdXQg
UkVRX1BSRUZMVVNIIGluIGBibGtfZmx1c2hfcG9saWN5YA0Kd2lsbCBkaXJlY3RseSByZXR1cm4g
MCBhbmQgbm8gZmx1c2ggb3BlcmF0aW9uIHdpbGwgYmUgc2VudCB0byB0aGUNCmRyaXZlci4NCg0K
PiAgDQo+IA0KPiBTb25nIExpdSAoMik6DQo+ICAgYmxvY2s6IENoZWNrIFJFUV9PUF9GTFVTSCBp
biBvcF9pc19mbHVzaCgpDQo+ICAgbWQ6IFVzZSBvcF9pc19mbHVzaCgpIHRvIGNoZWNrIGZsdXNo
IGJpbw0KPiANCj4gIGRyaXZlcnMvbWQvcmFpZDAuYyAgICAgICAgfCAyICstDQo+ICBkcml2ZXJz
L21kL3JhaWQxLmMgICAgICAgIHwgMiArLQ0KPiAgZHJpdmVycy9tZC9yYWlkMTAuYyAgICAgICB8
IDIgKy0NCj4gIGRyaXZlcnMvbWQvcmFpZDUuYyAgICAgICAgfCAyICstDQo+ICBpbmNsdWRlL2xp
bnV4L2Jsa190eXBlcy5oIHwgMyArKy0NCj4gIDUgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25z
KCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gLS0NCj4gMi4zNC4xDQo=
