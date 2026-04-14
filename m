Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011008.outbound.protection.outlook.com [52.101.57.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5102853FD
	for <linux-raid@vger.kernel.org>; Tue, 14 Apr 2026 02:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776135484; cv=fail; b=q0aN8ZkTiCsvJs4WT7vyDPuwSr6si2OCvNltTOgtMF2UmTnYQFvdqjXzidbkZsFEhJUO9wRMK/+ial7h46tTmXIpkRGQ8d0cKzwIv59fPF33CNfMmNiRYHlpWku7S8v6RGjqgQJa2nk+8Z9HceX5XaYK6tVZ8sVYqFkXwpDr+as=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776135484; c=relaxed/simple;
	bh=To6rGl2HI0Au45bJLhxrxXy1bvOS38vlTrO11zHaO0M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c1CrSp/EmYzcE+K6tWj6cRzl8sQDT0KR1TwNsgvVu1AEd9l1nQNQLrHxAz4XlW9q2iVqgUvUbjMPPl4u+iK922R1SwTQ2rn3rX+mkoJjht4z1eFc+TWx3RDosjTjk3aWUQ87dXWbDg2+1ctnx4HdiFWkT8TOaF4JdVlvGz6YKTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SNTJMhHa; arc=fail smtp.client-ip=52.101.57.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SNTJMhHa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CiuGQgimoLCj4m3Ph2uqYWecOUs2lRfdRX9i43KvOFsL5KbZGs3orn7S5Z1xSRvyc+AX8t6uEGHH60ndOOh5asBb4soFSUG6Vr5KNVew6ispmot9TnFWJ4thfKYXiAB7PATZYMMgM3olpazwOZpyYT7Rc9K5tLSzih7awn6aTJkS45w2NAIa1pODySACx8htO1BYYMf8qR5rTGORqGjoQE0hATQQAkVWdoIauxADx719bw6gmlpN8pzmbIGAqsUJAe8kvyIIDGwYinN9i0jZWD1AeOmfa72n1unuwGyXNLKQwRH9Cr998bEso1z/ioBjrFjRaq8XP30/fsKq/Y3tyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=To6rGl2HI0Au45bJLhxrxXy1bvOS38vlTrO11zHaO0M=;
 b=QYSz6qPMZ3JF5gOQRa5apuq5V3lWncvwEf16rhXq4QbXFEGR+rF9hIrbA1phmp9yD05ZKtbucm258khtUnhAV0Yv9JPWKTvAHMQY2BPqw6MdyRK2Gfj6rpgW2r1lIGmgOiWTIH+ObqkDkYBatvK8WfrNpDWN2LsGPpS//nb8guuVmuHt4qhV7SZBReWXEeviqxOyor4mis1cLpUBcg1SigjnH7TEJTDk9fK4Oi63QG/nqjCUV+VdKUrv26l8Akt+8CsRV7nJV/mCMMd+ta1TmFGcvDM2cSxJxzEspZappZ59ZdVFNyb1YW5RdN4sZeDnC6ID2SrZ0WbO3BnMP1TuHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=To6rGl2HI0Au45bJLhxrxXy1bvOS38vlTrO11zHaO0M=;
 b=SNTJMhHa/+FLxyMze0rehushrbzT6yo+sRxNA5vWUTYoCjQRRdSx5kjTFqZLookoe5Dy7gYKdBp7pY51gg1Dvgikrx2ezlC9fVXBMqobr1EeV1oG5rCyMP34Zm9FKd7ZjBEkb8CPfJQBwG0yyF9VqOMW3EW2gRcIh1m+iTPRBYzOxoXdz8G96DV+GfPTrNLYMm7PWXXusmW/rG4CR19+9pxG34scWqA+wkXqK9uqglNQ7KbLRtnCvUC2YMX+F84UKcEJvkXwz71xXIDcfzFUvLatsemxTm3ZaDYXfxQqYh+PIdEJ5wyvUs5qWYmlnyxYEEHKNPY921nVSxC9SDGs0A==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MN0PR12MB6173.namprd12.prod.outlook.com (2603:10b6:208:3c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 02:57:58 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008%6]) with mapi id 15.20.9818.017; Tue, 14 Apr 2026
 02:57:58 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC: "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com"
	<yukuai@fnnas.com>, "linan122@huawei.com" <linan122@huawei.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"sagi@grimberg.me" <sagi@grimberg.me>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Kiran Modukuri <kmodukuri@nvidia.com>
Subject: Re: [PATCH V2 2/2] nvme-multipath: enable PCI P2PDMA for multipath
 devices
Thread-Topic: [PATCH V2 2/2] nvme-multipath: enable PCI P2PDMA for multipath
 devices
Thread-Index: AQHcxykCbXqtyYU/5kiubF81rKYLxLXWRWuAgAehQYA=
Date: Tue, 14 Apr 2026 02:57:58 +0000
Message-ID: <0ed18538-695b-4915-bb78-4e154a2a2d9d@nvidia.com>
References: <20260408072537.46540-1-kch@nvidia.com>
 <20260408072537.46540-3-kch@nvidia.com> <20260409062659.GA7335@lst.de>
In-Reply-To: <20260409062659.GA7335@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MN0PR12MB6173:EE_
x-ms-office365-filtering-correlation-id: e5d8ee87-e3d3-4040-79ab-08de99d1a25f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|56012099003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 5bhDCbFomXaf0BFNO45NKlu0pPt7RCGucll7bcspxcFGemV1MvuKdfK5WOfuGDhEIIs/cLEuHWAzXbAUBipp+9YCM3HYIr6xPJS7PYbf4sWrHGcYyp/Ocp6yrkWhWn9lAh4dvuBDwEis4JljaqQELZ6WhbU+diHEd8QOydCz7ecl6CGAV9iMq0jsog3/cwwcGWL7vH0BxSWPGyXwnNsV+DWkkHwEIPMh5voabI5GTY4hzXI5wZtq1lkdfOdhOks12vKZs5VL+I4tBThBcksEhll3awmBGIWCIsM6p4lZ6jafuvAK2Ao2ocOI9RYFs9Lbzw4jIV65DBYrJFSS4pvaZnLlVjZQhVF/BZz2xtLk4NxxdgaH18V4vNAnhtI9SYRZVXit5+mEnsGiPZE9hDmHHHwht/SxaYDukJ5tmcQhAa3WCGhBSOnDaNe5z+fgp8cqMA84C5EPQbnU/ECIlCBRK9s8Q/iQbPv00rTJtoNACLLE5ClvnwQRmoEPGUxUrRbFTrkxs/cy4nnV02uqEuBYCzpJYjAigN23VFu7IJRKM9wxO/Vxt5ptaHdtfdb4ncieW2biwWTA3APa8C9jUNdpLA0VgNYA8Hscx4gfkOylEa4qtx9j1AtkP2F3i50kroxXZ97XAU9ROXmqs+C4PEA64N6fUM0a04eKIi51QgwotD4gSJf0yhBPEP91FtsluoB+OWQH84FUjX+OiKafLLuIOp6nHITnF86jdw4WxcW3DrEvnTVYYHK31Ssu/jdr6YOPMX3lK1ng9RecVX713EBIs+bWGsECghak1TXAnmXzQhw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(56012099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SEZRTGc0Q0tlSUxySFEyaTVrN04zYkhjekx4TGdSZkxadlFaQ3lIbXljUmRM?=
 =?utf-8?B?MWg4dnp3UzBBWE0xUnd1S2hITUZiejdHSThnbmJIRHRKMmdLT0V0SUFCd3NH?=
 =?utf-8?B?TnRXYkhBWlgwUm15U0Jrc01YRm5WS09uQ1RaWWtMNTVkeDBnVnRaK2JTZDdn?=
 =?utf-8?B?bk9TOVgzRFg1VGNUNDFIRjRGT3NYQ2tPbTErUS9XTGJoQ280aG9HZ2lLVTJC?=
 =?utf-8?B?U3cxV28vcnZmdXJpWmc3Y0Y3N01RZit0KytSQ0grK3RpS0p4dGQ2TG0yWUZU?=
 =?utf-8?B?SVBxQ1ZnV25WT0szYW14NGNyaENlL1NZYUhYYldGb011dWdnSVRUVmczcWhH?=
 =?utf-8?B?eTFYc2IyYlY3dmhXYjJ6VXZkSHpFN2hCMlJRbVd6bmlSL3A4eGFlZXc3b2pC?=
 =?utf-8?B?czFXeGpyem41L0ptZjJlTDJweHczZGVpQW1ZYm1ISjhLOTA1cmwxOVgrbGQx?=
 =?utf-8?B?TUMwWGNmNG9RNmFIWXhiM0Joc1NBVS9KWGFKQkk1bkZTNFBRQk5ib1g0U040?=
 =?utf-8?B?NWJSaE94NXNQNTVvVGZnY2Q5ZFNtKzhYZ2FXNk9zMjBtcmRUbWJRY1dVRTJu?=
 =?utf-8?B?VFQrcVBWVHBQV0lMaE52a2wzVkljSVRLLzRidXFRTTZzRndSL3ZRbkNhME1J?=
 =?utf-8?B?UFcvdktza21wTFdidm5ERW9VWEtCUm1kWHFtcDYwRDNMdHlVS1FSTm1ydlhM?=
 =?utf-8?B?bHJQQjNpS2lEaUJWclQvRDljSGJHR2xYM2NPWVlwT3padWkveGZhamFoRHRm?=
 =?utf-8?B?TXNRbjhVY3pwbVVlRkRmS0tNSk5tbUZxUDdtRUFPMGFhNkNYTWgreXpxY1FU?=
 =?utf-8?B?eXBzR2srNzk3S2JJQmFSeTRqQkJ0TDlTR0JMdjEvbTBXT1NIVEZyT25PSW0x?=
 =?utf-8?B?QVM5Q3haVUdyai9pVDJQeFNMbloyK01qZW1ZbGdBOUdkMjZvYjlPVUdYOFpu?=
 =?utf-8?B?a0dvSnBaWmFBRkdrYXpDMmRVVTA0RWZFOG1YVHArcXFHUDM4T3hoQkVnM3NO?=
 =?utf-8?B?SVplRHFJQmJjYVNzUmJMMzlKVHVjTEpYSkdXcENqK3hid2FOY2IxeENMR1JE?=
 =?utf-8?B?STZOWlhIdmhEWmZ1MHpiaHI3Y3FYSkNwbGVLRFM5WC9lMkpUVm85WkpVY2wy?=
 =?utf-8?B?Q0wxVHZvbTI2Q3ZCV3h1cVhhQWJPdmpDdXZ3TGhSYjZnaUdpQ2F3TjlPQTFo?=
 =?utf-8?B?ZDFuaDNwMGMwc0JlcUg4VHZRV1BhLy9TYUIyNEFlTTlkMXZKa2V3cENEaTFX?=
 =?utf-8?B?b3k0Uy9idkdwVkJNbUxCcUhKVlc0K05iMERPNzI5WlR6MkFiTE1vY3EvcUtm?=
 =?utf-8?B?UlJhR2pLSmt6Q2ZUWlBvUEl2RTZIY2RFT2pSSmVpWXc2bnRML3l1dEtwKzkz?=
 =?utf-8?B?VTBRekJveW5VVVBSNHZaS1N2dDBBUTh0SS9kUjEzMEtFTHBodHJuVFBwOHRG?=
 =?utf-8?B?TGJ1QzBWVDNOZkVTOExGaHN0RFJEdys0RTBQVTMxTUlPbTdmY3RxL1lKL3JI?=
 =?utf-8?B?WXhaWWNDK2E1YS9jQXFZMzJjNnYxTW5KZnJ2T0J5cEoyb1BPcjJVb0hyUFRu?=
 =?utf-8?B?SjN5Wi9pT2taT1hhTmJNaDFoalJpenhLUERVcVBZcHpIcTNMZmJydExwRjF0?=
 =?utf-8?B?RTRWYXh4Z0RRRzQrV0p1SUJlME9tS0d2Q1puaE5OSi8xOXVhZWwwNlBJTUVa?=
 =?utf-8?B?Nks1dFZrdVFSeDlPRWI5WFBzWG9kdkhkTW5sZ0VCSzdlT0NMUWJYZTdkWE15?=
 =?utf-8?B?N0RuWDdJQUU2ZkxYOVBDcks5bis0Z1Vva1UxSHZUT2xRQk1ibUFnek9Sd0R5?=
 =?utf-8?B?aXB2L3p0VGZ2SmJlZjdGY0FCVk1ORkdxSFZvK0NBNnFvWXlYejJuSW92NTh2?=
 =?utf-8?B?SjF3SllVbkExc3krU000T0QzblBDUE9RS3FhTEJOLzJvSEtTVW5Vd1RGTmJB?=
 =?utf-8?B?bmVTc0NMRy9JV1JXNW5ZZXFLeDJhdlJjclhMZE4vcXMyaW85SlZvekZicnRm?=
 =?utf-8?B?d2tCV2ZuclJXcXhINjZjNXRIMDBXMXM0amRoTEVVWDFBeXN0dlljQWlmbyt3?=
 =?utf-8?B?TU5RMmFMeG5NOWZkZzEvTzdRV1VNK2FVcHVnRHdRRnRpNjErVWhxT2Zuclgv?=
 =?utf-8?B?N2VnWDQxUjZ4VzBMTkVtMmlibDN2UXZ4UDRsL1pmcHN6Q2RicTJoaTlJQlAx?=
 =?utf-8?B?Wk9jdEp4RytBTVdFU0ppbXBiNEg3RUg0ZUxXSDc5QnBKL2lLN2FJRk5ONTBp?=
 =?utf-8?B?QWFTMVk2cVg1U3pNYWdBaStsUGVYTEd6YTE4WTJQNkhRM1NLcGpiQ2hDajZi?=
 =?utf-8?B?dzc2eUtvUGs2NTVpUHhUOEdRV3NoSEM2TGoyZEVFTU45TXpDc3I1eVVEQ3Ri?=
 =?utf-8?Q?oncgUBxiGiTbnkw0ggzk2jpsbVX7jeBIIwI6+o5dmtxVO?=
x-ms-exchange-antispam-messagedata-1: pQOS4Qjw6/uV+g==
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DBB0B1409719541B64A2D0FEB31895E@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d8ee87-e3d3-4040-79ab-08de99d1a25f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2026 02:57:58.3976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JozPk7XKkTC5isu0VRR3NNo+iMB/WqgGaoHr57tl9sK/5nFF2vOepFByfKIytkZ7QRVUnJB4FmKZU+1BBEp0+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6173

T24gNC84LzI2IDIzOjI2LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gT24gV2VkLCBBcHIg
MDgsIDIwMjYgYXQgMTI6MjU6MzdBTSAtMDcwMCwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOg0K
Pj4gRnJvbTogS2lyYW4gS3VtYXIgTW9kdWt1cmkgPGttb2R1a3VyaUBudmlkaWEuY29tPg0KPj4N
Cj4+IE5WTWUgbXVsdGlwYXRoIGRvZXMgbm90IGV4cG9zZSBCTEtfRkVBVF9QQ0lfUDJQRE1BIG9u
IHRoZSBoZWFkIGRpc2sNCj4+IGV2ZW4gd2hlbiB0aGUgdW5kZXJseWluZyBjb250cm9sbGVyIHN1
cHBvcnRzIGl0Lg0KPj4NCj4+IFNldCBCTEtfRkVBVF9QQ0lfUDJQRE1BIGluIG52bWVfbXBhdGhf
YWxsb2NfZGlzaygpIHdoZW4gdGhlIGNvbnRyb2xsZXINCj4+IGFkdmVydGlzZXMgUDJQRE1BIHN1
cHBvcnQgdmlhIGN0cmwtPm9wcy0+c3VwcG9ydHNfcGNpX3AycGRtYS4NCj4+DQo+PiBTaW5jZSBt
dWx0aXBhdGggY2FuIG1hdGNoIHBhdGhzIGFjcm9zcyBkaWZmZXJlbnQgdHJhbnNwb3J0cyAoZS5n
LiBQQ0llDQo+PiBhbmQgRkMpLCBub3QgYWxsIHBhdGhzIGFyZSBndWFyYW50ZWVkIHRvIHN1cHBv
cnQgUDJQRE1BLiBDbGVhcg0KPj4gQkxLX0ZFQVRfUENJX1AyUERNQSBmcm9tIHRoZSBoZWFkIGRp
c2sgaW4gbnZtZV9tcGF0aF9hZGRfZGlzaygpIGlmIHRoZQ0KPj4gbmV3bHkgYWRkZWQgcGF0aCBk
b2VzIG5vdCBzdXBwb3J0IGl0LCBlbnN1cmluZyB0aGUgZmVhdHVyZSBpcyBvbmx5DQo+PiBhZHZl
cnRpc2VkIHdoZW4gZXZlcnkgbWVtYmVyIHN1cHBvcnRzIGl0Lg0KPj4NCj4+IFNpZ25lZC1vZmYt
Ynk6IEtpcmFuIEt1bWFyIE1vZHVrdXJpIDxrbW9kdWt1cmlAbnZpZGlhLmNvbT4NCj4+IFNpZ25l
ZC1vZmYtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQo+PiAtLS0NCj4+
ICAgZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRoLmMgfCAxOCArKysrKysrKysrKysrKysrKysN
Cj4+ICAgMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRoLmMgYi9kcml2ZXJzL252bWUvaG9zdC9tdWx0
aXBhdGguYw0KPj4gaW5kZXggYmEwMGYwYjcyYjg1Li40OGQ5MjBjZTgwM2YgMTAwNjQ0DQo+PiAt
LS0gYS9kcml2ZXJzL252bWUvaG9zdC9tdWx0aXBhdGguYw0KPj4gKysrIGIvZHJpdmVycy9udm1l
L2hvc3QvbXVsdGlwYXRoLmMNCj4+IEBAIC03MzcsNiArNzM3LDkgQEAgaW50IG52bWVfbXBhdGhf
YWxsb2NfZGlzayhzdHJ1Y3QgbnZtZV9jdHJsICpjdHJsLCBzdHJ1Y3QgbnZtZV9uc19oZWFkICpo
ZWFkKQ0KPj4gICAJCUJMS19GRUFUX1BPTEwgfCBCTEtfRkVBVF9BVE9NSUNfV1JJVEVTOw0KPj4g
ICAJaWYgKGhlYWQtPmlkcy5jc2kgPT0gTlZNRV9DU0lfWk5TKQ0KPj4gICAJCWxpbS5mZWF0dXJl
cyB8PSBCTEtfRkVBVF9aT05FRDsNCj4+ICsJaWYgKGN0cmwtPm9wcyAmJiBjdHJsLT5vcHMtPnN1
cHBvcnRzX3BjaV9wMnBkbWEgJiYNCj4+ICsJICAgIGN0cmwtPm9wcy0+c3VwcG9ydHNfcGNpX3Ay
cGRtYShjdHJsKSkNCj4+ICsJCWxpbS5mZWF0dXJlcyB8PSBCTEtfRkVBVF9QQ0lfUDJQRE1BOw0K
PiBJIHRoaW5rIHdlIGNhbiBqdXN0IGFkZCB0aGlzIHVuY29uZGl0aW9uYWxseSBoZXJlLCBzaW1p
bGFyIHRvIGFsbCB0aGUNCj4gb3RoZXIgZmVhdXJlcyBhYm92ZSB0aGUgWk5TIGNvbmRpdGlvbmFs
IGFzIGFueSBub24tc3VwcG9ydGluZyBjb250cm9sbGVyDQo+IHdpbGwgY2xlYXIgaXQgbGF0ZXIu
DQo+DQo+PiAgIA0KPj4gICB2b2lkIG52bWVfbXBhdGhfYWRkX2Rpc2soc3RydWN0IG52bWVfbnMg
Km5zLCBfX2xlMzIgYW5hZ3JwaWQpDQo+PiAgIHsNCj4+ICsJc3RydWN0IG52bWVfbnNfaGVhZCAq
aGVhZCA9IG5zLT5oZWFkOw0KPj4gKw0KPj4gKwkvKg0KPj4gKwkgKiBDbGVhciBCTEtfRkVBVF9Q
Q0lfUDJQRE1BIG9uIHRoZSBoZWFkIGRpc2sgaWYgdGhpcyBwYXRoIGRvZXMgbm90DQo+PiArCSAq
IHN1cHBvcnQgaXQuIE11bHRpcGF0aCBtYXkgc3BhbiBkaWZmZXJlbnQgdHJhbnNwb3J0cyAoZS5n
LiBQQ0llIGFuZA0KPj4gKwkgKiBGQyksIHNvIGV2ZXJ5IG1lbWJlciBtdXN0IHN1cHBvcnQgUDJQ
RE1BIGZvciBpdCB0byBiZSBzYWZlIG9uIHRoZQ0KPj4gKwkgKiBoZWFkIGRpc2suDQo+PiArCSAq
Lw0KPj4gKwlpZiAoaGVhZC0+ZGlzayAmJiAhYmxrX3F1ZXVlX3BjaV9wMnBkbWEobnMtPnF1ZXVl
KSkgew0KPj4gKwkJc3RydWN0IHF1ZXVlX2xpbWl0cyBsaW0gPQ0KPj4gKwkJCXF1ZXVlX2xpbWl0
c19zdGFydF91cGRhdGUoaGVhZC0+ZGlzay0+cXVldWUpOw0KPj4gKwkJbGltLmZlYXR1cmVzICY9
IH5CTEtfRkVBVF9QQ0lfUDJQRE1BOw0KPj4gKwkJcXVldWVfbGltaXRzX2NvbW1pdF91cGRhdGUo
aGVhZC0+ZGlzay0+cXVldWUsICZsaW0pOw0KPj4gKwl9DQo+IEFuZCB0aGlzIHJlYWxseSBzaG91
bGQgZ28gaW50byB0aGUgY29yZSBibG9jayBjb2RlIGluIGJsa19zdGFja19saW1pdHMsDQo+IHNv
IHRoYXQgQkxLX0ZFQVRfUENJX1AyUERNQSBpcyBjbGVhcmVkIHdoZW5ldmVyIGEgbm9uLWNvbmZp
cm1pbmcNCj4gZGV2aWNlIGlzIGFkZGVkLCBzaW1pbGFyIHRvIEJMS19GRUFUX05PV0FJVCBhbmQg
QkxLX0ZFQVRfUE9MTC4NCj4NCkkndmUgYSBWMyB3aXRoIGFsbCB0aGUgY29tbWVudHMgZml4ZWQg
aW5jbHVkaW5nIHRoZSBwcmVwIHBhdGNoDQp0byBtb3ZlIHRoZSBhYm92ZSBpbnRvIHRoZSBibG9j
ayBsYXllci4NCg0KV2FpdGluZyB0byBnZXQgaXQgdGVzdGVkIG9uIHdpdGggS2lyYW4ncyBzZXR1
cCB0byBnZW5lcmF0ZSB0aGUgdGVzdCBsb2cuDQoNCi1jaw0KDQoNCg==
