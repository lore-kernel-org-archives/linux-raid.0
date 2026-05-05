Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011029.outbound.protection.outlook.com [40.107.208.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329B5EEBB
	for <linux-raid@vger.kernel.org>; Tue,  5 May 2026 00:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777941174; cv=fail; b=aBFuekvf6YcM7qrbwVOCY7s33ZbgkhDBrDbArK60R3QQihsCivNn2Z2IV8vRj2mYCr/TYJQZLpTlUYE6HbeZGDYO7Ll4KCcamuD4TIe/3voq1gVVgA2S8RIAXMDJwGazdl06KGE07mhAlO9OCwBZjszx0M+TDYorfsG572kv8H8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777941174; c=relaxed/simple;
	bh=aTxls/YzXqcihj21jYy/nyubIY901I9jUi48sqJs3pU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZrIH+o2rSGDxLRHmVIv1UTKTOfHVJ3l0cwIU/pgsxe8Cb3v5E0ad1nkq1rNaPbfNw3kWJ3FaZqlLW3R0M4krSVi7z8sqfr2f3+0d9l0NXQeoWX22mS2RlyK3O20srQjcALP0NpTr51UD6c2EejLm1BDhDHEPsyhocsC19AOjSbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AgI/ViMl; arc=fail smtp.client-ip=40.107.208.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AgI/ViMl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CyuJvXAXs09OiA1koRpEjhJvplneHFfB5/TnZXccUhahiTSLTeXe03Nug1wu2/xxLQQH+WS0iJJtmkTaoT5jxoKYmGoJZl3NMZVptecaNnVB+BHgL0D16c4vxnoemg1pNm2SAo/Z3jR1NRHL/HGtpCXpUlTTQRIQ2AXEbklYchFhhbVE7HS6MA3oDgHr/GhJenDqOtgy01Bxta/Rehi2P6mXmJiWnBsZBvbD1fet4Ze52skXlf7Nnuoa2knV9aoOO1vWiy86Gj7BFZIYKGYpTybzy7O0hzgA0/rDQSlI5MX6Ojqoj6ji6eXEiysGqif2QUsCOULt5oWqzWksT29fkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTxls/YzXqcihj21jYy/nyubIY901I9jUi48sqJs3pU=;
 b=c4wfGXBrqysXwd53OwqDFmO45O51XD4tXT1IBEUCw88g30ixTCOQ38kvTqohMHpJz6rFG584YXP86e7D8fkYqLEdQdyfImriOCjDrOP1GerhbWtZ09oG2imvF6LgMsgXOI0jpwH4/9gcVBx02Yq/XFfbO5tI0OsBF2dm8zeRdqUGZWIQzF54Uq1ZesOKgYKPwBg+vyeA8gUs8IfscazQjgl/3ZIGgyOUrVrKQ9BZH7Sf9hwxOO6flR+4b1Oyw+tJv3wqfa35ydvoc+ZenC6kG9K9AuQaeHU14xHouG6OyQUrPj7ZC1duJHBm4DQySZOLIlKfk5twxlgcYepMZHdPnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTxls/YzXqcihj21jYy/nyubIY901I9jUi48sqJs3pU=;
 b=AgI/ViMlIitdIAzwShlatXIat5TvXKXgPLmpVuoDyMrqarvPG0jVfhWSe4lP3KCfP1qPbT7vVHm/z2RIIiEiGqfUQMNcbjd0CpQna9qdkLi6EB4OdC6QzX20T0dBZCxrfA85fIMH153n2qVxFS8HA7Uyjjg06tNz9kzB6JRjQnltg/E831gqtr+IfucKwOkUI2Y3bd8xqlrjJqXUL/5Pbv2xoqCSpU2sqvKdkTcKDNlkljw6K/wKlzMKcLtP7wxLESf2udqq0g6jrv2qyKmlqfR5DbEhE/VMAZgFJz6uCmkCTLt+xsGaJFV2nlnZDJUFyEmQG9ZYl5F+UztXL701Hw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 00:32:46 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008%6]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 00:32:45 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>, Chaitanya Kulkarni
	<chaitanyak@nvidia.com>
CC: "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com"
	<yukuai@fnnas.com>, "linan122@huawei.com" <linan122@huawei.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Kiran
 Modukuri <kmodukuri@nvidia.com>
Subject: Re: [PATCH V3 0/2] md/nvme: Enable PCI P2PDMA support for RAID0 and
 NVMe Multipath
Thread-Topic: [PATCH V3 0/2] md/nvme: Enable PCI P2PDMA support for RAID0 and
 NVMe Multipath
Thread-Index: AQHczefMw/2L6wnrAEunHJMvgSqt97X+fU6AgAA0RIA=
Date: Tue, 5 May 2026 00:32:45 +0000
Message-ID: <0be2a81b-239c-4b04-911c-ba4e50f2adcf@nvidia.com>
References: <20260416212633.72650-1-kch@nvidia.com>
 <afkO1WExGV9-jv8b@google.com>
In-Reply-To: <afkO1WExGV9-jv8b@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|SA0PR12MB4349:EE_
x-ms-office365-filtering-correlation-id: 026c28cb-751b-43eb-65a8-08deaa3dd3ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|18002099003|22082099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 UBKaJmlAC7Gnl0AlF9xZ17bwTfWig73Wo/sKt+pDtQFw8DhcVWYsZ7iVmXy8Hzr5CzcoTMpSH5fXZUBGR+Vk+IldYP2Ax7ECj92lggyZHR8KlwcXKgQSY1lN6skiHF8ekrJ1lKUfTZK4ze5quvpAD4EO0PiY3oS9Ly/rP3AQzoB5PF3Zjp6En1nk2MJpxk6cjNkYR7BY/q6sWQ7fhiJa3Ndx7qRqN+OiineZUhH1GPcEomVVtQQj7mKyOo5EFOpwQR1SBttkxIFgBUHHl/GRsTV1M8Cw5Wz5tRlbPhSSn1Pvu1gxwoJgsOl6QPz+iR0fcd0/72MX17WNz7Vi1QLNBnb2BVDrS8dqgy6O1Te2o6oE0jtUm7GTpqCI5DVpfAWu3DXZ1pd+rgMVrFbqtbrVxp3LxaaXhcj0kJhwEb1i+6V0nRKxjBm07EHsR6xHm442muVB/r9PNTW8iaGDRZRDgeE/u6A+NCPctQDDEh0p72a07QdTv/sPvmqY1LipwG7aSzbZQ7ixjhucXNy97sEzgXBy0/ZgqVvX/rUB7UfSFVpK2HbMdNB5IynhMyOVqNf9LEOprWi95r562U3y5X8YIxvFZqenbN/SHPP8RYbmJlWIq3cf02s4wZc8OWP+/7mP9FPWVakTueY+f9yaMBLNMKzbdyWDgg/YYLg16pocbXQZEevqJA0ARmNpe5r7fhrd1PJtR74dqqAYH10woaEOcSp7+QLoZpZDmOJ8lixLK/cefqCWUV+zgRWHTJIuBWEg
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RnJrL0x2K3NUMzFHVm44Z3lMYVgzUlZnRWZaOWovb25CTWNHVkorNFlyeVcv?=
 =?utf-8?B?YnR0UTQvbThvbWxFeHZMUGtDSWl3ZXJ6OStJNGRNWkIyYXJ5VDl4MnVWT3VJ?=
 =?utf-8?B?c0VoWk9FNW5MUHlYdnFBc3hEM2swQ3ZmajhMNnNidFFuRlBjd1RDQ2lvZ2NJ?=
 =?utf-8?B?SXozZ2NiM3dnNWdJWXZwSkNzMVZadUJCNWFVTmVDRTBTVFRPWUNxdk45VHdH?=
 =?utf-8?B?S21nMjBQdVM3TTRBRFBOTmxnMWIzM3dJRGpwYzJ1U2dMSG5mNlZFV0pVWHo0?=
 =?utf-8?B?bWpyL0w1QXNvMFVTSmlheHNNQ3M0R3kzV1hERmk0VFZidVI3eE55NmVUZjB1?=
 =?utf-8?B?OVlIaGpsRVNOMXp6K25EYmR4T3VyN24vbEx2NGtnZXpCcDNiemlyL1NtaDFM?=
 =?utf-8?B?ZnRyV0NwUDUwczN3Wnl3WTNPSnYyTWg4OXZ6MGhCY1didm52QVl3dTZOVFBF?=
 =?utf-8?B?bmJna2FzbldJVFVQTmh2SVlHVnh5OWJhY1NCN1lYemtxWGNaUDdRMXRHU0M5?=
 =?utf-8?B?d3plZW14M0lwRFh4eFBMMXpPTWNVY3hnaEZxWjMvU20vcktmWVRBaGtodm1k?=
 =?utf-8?B?RDY3RlFqK25jNVVMRzU0emFPRFlmQnQ4c1d1czZGT0tPV0NnUUpmd29TaUw4?=
 =?utf-8?B?ZGR4dzN2SC9hV245TE1LUDFmY1Jha2pXQ2lEd1ZMMWIzSzBqVHdjQjFwdWFL?=
 =?utf-8?B?VHRBOTVuUkxoNTYvd0l5dFJhNE1aSncrWU9wUlpUQjVsNzl3SklBUk5BNGhq?=
 =?utf-8?B?VXFHdFQ4bHRQSHVjZXc4Tk5td3R0MWRPSVNoM0ZkOGl4OTRpekFRTStBUXps?=
 =?utf-8?B?RkN6eWRjMzJZcWZKdzhva3JucThRTmRhaGFBeHpWa1dsUWxCdGV0Y2hlU0hW?=
 =?utf-8?B?YmdHZWQ2M3p4ck45VlEzR0ZxeURkOFMvVDBJdHQvM3pxc3F0RzNJL05CRTk4?=
 =?utf-8?B?TmlVMm5UVGZsK1JlNnd3L3ZnbTV3a2VRaWtva3drdjhnZ2RJaG1zRUN5YkpZ?=
 =?utf-8?B?VTYvaFZWdkMrVnhncnU1SkMreDlnWFJWUHY5S2l2VkF4VGFmTzhEY2hSbmNG?=
 =?utf-8?B?YWpkZ1pwWjMwdnVtUUUxMmJhajdCSFBlK3lQVWlQaE9XZXgwdXRJbld1ZjlM?=
 =?utf-8?B?OHBhTXhKbEtldHQwR1pLYWVpUThJcnlwaHdqZ2VEM1RPS1BVdmpIdDBrbEla?=
 =?utf-8?B?S2lXc1MrcE1MRnNHU0hQaFIxSFhWZ1k2VUttK1hyWk1rV3kyVFFBemxDVmQ4?=
 =?utf-8?B?R2t3WlRLb2FWTGZmMVQyYlRxMFV6T0E3UXVrV20rMzRsc0ZoUTNYUXRhN2RM?=
 =?utf-8?B?dzZEdFkxaUFnNlBnRnFDUllEVDc2SUlydUpuMklmQmYzOXBSSnRmeVEvU2kz?=
 =?utf-8?B?bWFLcTV2em1TdDlzMWY1VmxQYWE0ZmNyaTlOV0U2a1BYcHdPbURzcDhqT0hL?=
 =?utf-8?B?N1l5Y0JxSmU2RVBXNlBWZGZ5U1MrQ1dFdjJGamNqTGtiRGRDdFpnMEY1MXhl?=
 =?utf-8?B?cGNGWkZkSHRwUE5aZFJKRVA5cTJHbE9ZalVGN3lZK3FCN3dIOWlEZjhMNzZK?=
 =?utf-8?B?QXhHZ2J3b3ZCdzVTTWhOVy9hZ24rVVU2YWhCMVZMRkVGa3lRRzlGc21haTZR?=
 =?utf-8?B?RGJvR09xTzAyNlpSMzZuSFJ0YVl1SGowLzNsczRsL2FWQXJiclpCYzJvRVlB?=
 =?utf-8?B?aWVrVHNPZ1VDR0poNzB6Qlp6RzV4K2JNemFYVmVVbWVtcjNaaWJTRWJIQVZy?=
 =?utf-8?B?SW8zKzBDYmVYcHBUemZZY1FPMDZTZnlHZ1k4TS9pNXovUWp5TlI2dnQrVExX?=
 =?utf-8?B?ZlF5ZlNzVGg4RWJMYm8vd05oQWNTajZYVlVhTmRwbnhKUXVQTWpjVlRZd1pL?=
 =?utf-8?B?SXhQU3BOUmJremJReGNJaEhDcEdZRHVGeUNxdk83Z1lFRCtEdkR0MEhLaWYx?=
 =?utf-8?B?dGdmK2J0b016dkVqajRjeCtpTVlFUVFIdU82d296TEhwaXFLT1FVWUp0ektz?=
 =?utf-8?B?ZkRNOGJjVWloc042V2VhVlo3YW5QL3kxbldqeVliQkVHbTk0a2hSeEV5R1lP?=
 =?utf-8?B?Ym1zQzBKUFVDWUtiZnBKMDMrQlAyeDZYbDlqc21BNGE1V3ZxdU8zWUNvSFQ5?=
 =?utf-8?B?c2lXTEpDTGN4YmJMekxpUU5nZzMyQ2hKQjN0d1grV1ovM2QvRm1pWmFUZnVP?=
 =?utf-8?B?VW9CbDl6WFI2V013eHRiRW1IVGhyMm8xZUFhMnFwWjNkbnl6NFdVb1pKR2w4?=
 =?utf-8?B?Q0FkTGN5dkRnRnpvcUZkeFA0Skl1TWtxMzhUMm1QMy8xcFFMdXVqMXBYVUQ3?=
 =?utf-8?B?eFZManQ1UlhTZUZWUVk4WjlyYVNaaW5MQ1pKb2FWLzg4TGxNeVpMWEU2amlY?=
 =?utf-8?Q?8n/8hRmMOPiIHUEqd5IetxPqHL/wFipzC8P/ETgb6C1uO?=
x-ms-exchange-antispam-messagedata-1: xgCzgoIwh/H8QA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <EEBB90CF347CCE42B3C11A700CED32AB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 026c28cb-751b-43eb-65a8-08deaa3dd3ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2026 00:32:45.8357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jP5Hvm5k90NdMotSN3/lLZ1LV1I20RYsXZI8AjmPqkmjsDLCYUqwSIWNOEqeff7AMxp1USsDIrFukXtUpkxnEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349

UHJhbmphbCwNCg0KT24gNS80LzI2IDI6MjUgUE0sIFByYW5qYWwgU2hyaXZhc3RhdmEgd3JvdGU6
DQo+PiBDaGFpdGFueWEgS3Vsa2FybmkgKDEpOg0KPj4gICAgYmxvY2s6IGNsZWFyIEJMS19GRUFU
X1BDSV9QMlBETUEgaW4gYmxrX3N0YWNrX2xpbWl0cygpIGZvcg0KPj4gICAgICBub24tc3VwcG9y
dGluZyBkZXZpY2VzDQo+Pg0KPj4gS2lyYW4gS3VtYXIgTW9kdWt1cmkgKDIpOg0KPj4gICAgbWQ6
IHByb3BhZ2F0ZSBCTEtfRkVBVF9QQ0lfUDJQRE1BIGZyb20gbWVtYmVyIGRldmljZXMgdG8gUkFJ
RCBkZXZpY2UNCj4+ICAgIG52bWUtbXVsdGlwYXRoOiBlbmFibGUgUENJIFAyUERNQSBmb3IgbXVs
dGlwYXRoIGRldmljZXMNCj4+DQo+PiAgIGJsb2NrL2Jsay1zZXR0aW5ncy5jICAgICAgICAgIHwg
MiArKw0KPj4gICBkcml2ZXJzL21kL3JhaWQwLmMgICAgICAgICAgICB8IDEgKw0KPj4gICBkcml2
ZXJzL21kL3JhaWQxLmMgICAgICAgICAgICB8IDEgKw0KPj4gICBkcml2ZXJzL21kL3JhaWQxMC5j
ICAgICAgICAgICB8IDEgKw0KPj4gICBkcml2ZXJzL252bWUvaG9zdC9tdWx0aXBhdGguYyB8IDIg
Ky0NCj4+ICAgNSBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4+DQo+IFRlc3RlZCB3aXRoIE5WTWUtb0YgKFJETUEpLg0KPg0KPiBUZXN0ZWQ9Ynk6IFByYW5q
YWwgU2hyaXZhc3RhdmE8cHJhYW5AZ29vZ2xlLmNvbT4NCj4NCj4gVGhhbmtzLA0KPiBQcmFhbg0K
DQpUaGFua3MgYSBsb3QgZm9yIHRlc3RpbmcuDQoNCi1jaw0KDQoNCg==
