Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011016.outbound.protection.outlook.com [52.101.57.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB20B2D5932
	for <linux-raid@vger.kernel.org>; Wed, 25 Mar 2026 03:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774410610; cv=fail; b=bf6DN9HgSzxATZ7BrejpW03NIJS6mRFQbhe0QBkgz7yn8xuMLBebnr7bRCaiKUoarsDhvSpHwkoruPoQsNSSKSwZlue+rbcD6AznCSy0R3fXBXIix0ukGuEnwy3xQ+xw5LjD/Gyn+waf1nbUsazwcfNLuc5XIZ8JzuDSbBXMGdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774410610; c=relaxed/simple;
	bh=zxvPsE0Z3i72FxIrCzlYfn6In6MxSZLG9N0iiX/6jzA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CjOb5mssgZ5q2d1QHmFvI5Ylyri46o/d7sqYOi8laUekN573vqn3NdkM/0IL/1gqDeajopYtWzeZ53YY8kMCjqnwPRugYeF+8jjaariUf1BnsZXMLiX9eY1YnS9tPFRHPuITyqL+tGYLRF4XePaO782DKxQkUVTTi0xALmVJwPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SLsKIiHk; arc=fail smtp.client-ip=52.101.57.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SLsKIiHk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ucWIJJdjsl+PYvkStyfC2r++jLhct3MizdFHYpqRg6Yv9G2j9A4K9ZF8Up6pB5XsKGUM7uvCqbDNvHSV9WPtxE1bsT0DF3kexpz02CNGueAK4Jyy1CP0WQOTDdCGV0qFi0RUPHY7PjxkfRPawVIqwhvrn553nwXhc3MYo45Th3191g4rSyJxxuEqzrKUcrE+mE1hc3xCA2fUNJFri6ltHPy90mMTQIU7bCL2dGfT3piG5dbinkCy24qZawXsOtgeLouh2p1lc1KOCgyHmVWaLNydFtAakLvziymo6r9hO4pL7n7K+XY+9yYCScLyqjZOAknRRM5joJPV/k+dNJqpPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zxvPsE0Z3i72FxIrCzlYfn6In6MxSZLG9N0iiX/6jzA=;
 b=RY7kwocr5lNbrZtJpRH3ZXJvpkoYip49Fs2BGKfTcx2k1GXNXJ6H1mgz8MWGwd4gIJDJ2XiKOmuVVsH5a3cR9oSyd4hrTMKLOeEROyfZaluCYeRbDL+l/PW9mZNgrslK3tZQ3zlqVw8XSxh54Hppvzx0Kev2D+KWO1aRli24UfKjuYPf/A0DKMEuD8oqqOTWtTem7UFhsdpPY9ogPmJp9yAF/Jv/JJhEUwY6krWksvzYAbNcDcgs0rMbTM6GxFXCgrSksF9PoJK/bHx9XmrQvFLMG4t4OQbs5OUEL+Msq0sGgLF6r1DmqxBUCkUG/Tq7BuCY8PeVm6FFchMM+7sHyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxvPsE0Z3i72FxIrCzlYfn6In6MxSZLG9N0iiX/6jzA=;
 b=SLsKIiHkyjNSZ3FiE+yGZnA4Tb4h0Rlx2vuPosMYmA50qzaO4SPtEMgpWZ4SJCXYIY9GpBHOFYDkLYYmDfji8Ve0yfv4LNrvPeA/FvQ2lEuYurAyGfD3MkRRIaBoeD9rVlGvq8E4SkPAWNbxJY+/I7F9UqFer6E4VctaO3RX5DmS7MS9nl1GPBWwoOpKzueLcVAr5VvM6h3SUbahqKm/HUnUcYdzGR5poXOFoaJHMrwVJtWTSfWn6TcMO9am4u1NTjrv68Zg9TzUKsyVStvcepYhRvqGvajTo4+PMgyXIzqbulVrhRiNpp21UBSSwq4v+9ObXbNfXR0pmgrX3MVBlg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DS7PR12MB8290.namprd12.prod.outlook.com (2603:10b6:8:d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 03:50:01 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008%6]) with mapi id 15.20.9745.019; Wed, 25 Mar 2026
 03:50:01 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
CC: Chaitanya Kulkarni <chaitanyak@nvidia.com>, "song@kernel.org"
	<song@kernel.org>, "yukuai@fnnas.com" <yukuai@fnnas.com>,
	"linan122@huawei.com" <linan122@huawei.com>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Kiran
 Modukuri <kmodukuri@nvidia.com>
Subject: Re: [PATCH 2/2] nvme-multipath: enable PCI P2PDMA for multipath
 devices
Thread-Topic: [PATCH 2/2] nvme-multipath: enable PCI P2PDMA for multipath
 devices
Thread-Index: AQHcux8UPGxmbu3dYUK2SmLhcB/nibW9PoSAgACDoQCAANyFAA==
Date: Wed, 25 Mar 2026 03:50:01 +0000
Message-ID: <10bf7610-e441-4f8c-a733-e4530b3ed1cc@nvidia.com>
References: <20260323234416.46944-1-kch@nvidia.com>
 <20260323234416.46944-3-kch@nvidia.com> <20260324064937.GB1409@lst.de>
 <acKibPVk578SwyFR@kbusch-mbp>
In-Reply-To: <acKibPVk578SwyFR@kbusch-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DS7PR12MB8290:EE_
x-ms-office365-filtering-correlation-id: b31a8004-61c8-4e59-b8ba-08de8a21977a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 EijIlx2VmxHyezJdv35DoUHEMztOuo/skvhUGIOZFBQ0xTpcVdzHWHekEV3xjWPvtqhbvMOrarSUFnKbSiT3lh6+p08qjrqK/VHVouyHp1R1lMDWCXJ6SZtip0BTrGbYPoPDCxnGBZzYGOIpOgi5lv1Sy1B29gQyiXYgzvoSBjLXPGhwlpvYvD84htH1v7/Nsl4HKr+FtKrYW+G9Ual21oHJmIuJPuUWZ1+L70iXBNicSv94+XcwTwrFrIZVS+5kVOdCvXQZsM4QI2ofleFWGXoxS65zy2gbSYLjBkSG7/ckD4QlizPLrfNqYNfdoWq1vd2kBuN2KNmI2HB63E2OBNKnVFSh+AqRj0lAWN3xsCj6JsgMiiPCMXpRjshR78Pz5/oJ2aw8Xy1erqpxCNOAO20T8dijCW7HDVofDrUPiULLYgM5VsFqGQ+cZY3zk8SXi0oef4LpHzza33/oTYWtW/IEaOgtf3TsRGT0V5pI0BNES3EPtTonFzCSlCo4/CjXpgtoZZuSVRnNGGpJ+vcXTY4DAOVeRNFmR1HqXiiyAUqoc3OMWGDwiKeaFOSs56slzU1bQB7TVO9pxdUPHhYGwk7uOuP1+6/AhtjCHkcxxCtSrMDL2ux1B5uMhmxHez/memnvhUJK1N0iD+5PYGYjcvWOoiAVFLtbfqbF5YbhYsYvwB34floxC74rTnbCld6XU/C25JBc8XKoe+GE2Rw+mDXbZLhLA3k/30PppO6wntlviXQHfjGCv8FLzvEX3R2Tz4RsgWlQtJ/b2eOyWTesZLfMt8M/M+QOzTsMdmmymyE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RFpQYmZGN0ZLODFFYlEyVStoK3Z5d3lmbWRwbFUvSTRjZlpTWFllUndwYStJ?=
 =?utf-8?B?UStOL2RyUHlXbG5jMFo5R0QvWG1EU0p4bkRwYlVCcGRyWFdEcnFwZHFOM1ZW?=
 =?utf-8?B?YjJmNHBVZnEwZ2hsanhHOGhlOVJjRzlmNFRJcS8yWmxxbXE0VS9pOTJ0ajRv?=
 =?utf-8?B?VjlPYlRYaTFYNmJYZ1ZYQ1AxTlBkbWVIWElsNDlMdXVGTFk3cFhSRXBSaFpP?=
 =?utf-8?B?d3czVXE5N1R3WDcvU05vUHM1NHdneG1BVzFZL2JVbGVuM1lrRXhYSmVpT3E1?=
 =?utf-8?B?RmZGak04TGNDSjU1VjhLOEhpYkxuMjBYZi9DOUtqR1lJRWdHMWsydWJLVHBh?=
 =?utf-8?B?R0RYSjBNQ0dOdklRVGJOeHplem11VVFtYnFHb2tucWcrT2lxdCt4ZnplL1ZH?=
 =?utf-8?B?ZDM1Z1dLSktvM0pwbnJPTGdPUXhjaWJ0UFlXZWxZbHdiK1hGS1JGZWdNbVM4?=
 =?utf-8?B?Mk5xRjlRYnp0UnY0ZFJ6VEx5cGtQb3hUek0wU0xKYVBicGZMY2pQY21aa0U0?=
 =?utf-8?B?TFBxYUJJUTBNOTZES3MrK2JjYVErWVM5YzEwams2NC9ZZDVSU1cyRDlQeHVP?=
 =?utf-8?B?WEt1V0lha1BVazdKTXdmNXUvSnpzdmdJYWtlUUEwWlJWWTlYR3pabVRoU3RB?=
 =?utf-8?B?QTBHckp4L0FBWUdIM3BKeVV6MDNTZ1FsNkpRTGprZGJ6bHdkL2MreGdSaXVX?=
 =?utf-8?B?WnNuRFR1ay9QSUYrMEhRQmFRcTRhUEFFbU9yY2UxUktMSE43YnRmc0lkUTNQ?=
 =?utf-8?B?WkhDTStlREdkM1lmWmdITEpKNnJoQjdjSHNYRlVvVEkweHRTczNrU1ZXRUdr?=
 =?utf-8?B?Y1VKQklqTERmRE9maWJwQ1Y2eG1sT3NHQm1weTM5QTl0L3o5UHA3SUdUMTE0?=
 =?utf-8?B?dWJYblpnWU1rVXplb2FHcVZIaTBsc1V4MlVjYTI2VEtxaUpEUi9RYXlYSGdC?=
 =?utf-8?B?SVdyRGNIb3RxK2ZzWVY4Z0NSeCt5WlJ0UmhteHJqMFUwOWxjQm02OXhMeVBi?=
 =?utf-8?B?MHdZVlo3SzVsZTZpQVRkQ0RrTnFsZnBEVFRPczA3NkpCQ210M09Fcm9oTXEz?=
 =?utf-8?B?NVBxMnRJTWtRRk4yL2VMd1pKQlUrNVd2a0VLMGFkNENwVXZ5REM4WXl5Ukk2?=
 =?utf-8?B?MHd3UG9mN1QrblkvemtaM0dSMXY4cHpKeDVrR2RrcWtRK3V3WGVrdlZGVDlo?=
 =?utf-8?B?REUzbjVzQTVwUnEva1lIOFRBcHlmOWhnYWdLaUhFOXR2NVVCaloxL2RqZnlV?=
 =?utf-8?B?U2ZWK0FYS2d0ZW5aTDlLUHVkazRQdHdQcklGb3FqSldEYk92ek9jYTV0cTBZ?=
 =?utf-8?B?N290QnRZbWwyY1ltdHRDbEc2TEZWMWdJbnBoK2tjOW9PNGVRakpVZzdNRGpL?=
 =?utf-8?B?OW5oRGFldXpEc3NHZW5jV3ZGY0dMZm5vRFFyREI5ekRoUnpiWW85OFVPeS9H?=
 =?utf-8?B?b0U1OEd3MUo0cDllV0JrVGlvWlhRdXJuNi8veGNZc1EzR2l2ME9xYy8vZXVJ?=
 =?utf-8?B?a2lvWDlKdFViUjdCckVGRVRpMWpxQ0IxdWQ4OHF0V0h5T0ZhbDF4Z1JDeTNT?=
 =?utf-8?B?dXNKV0FxbVdmcWpacXB1YW93ZkQ3bk95dStQRitDazRHQmJyM3lDYkdUYklN?=
 =?utf-8?B?U1U0QmlrRWxPM1ROUEJKRmVKODBXalhaOFJCZXlxV0FmZWFjT2tSZ3N5T2Y3?=
 =?utf-8?B?U1N4TlFYczNCYjFLakx1TXVqcG4xSGppQ09IbFdRTXVqOEQwU1JxazRFZGU3?=
 =?utf-8?B?Q1RwNVEwMEU0a09nWkRFTG80WGtXM29YREFzUFhRUDByUXE2RCtvVEZEVTJi?=
 =?utf-8?B?QXlLcWNsd1VYREMwbTR3V3JUd2IreS9lY1RXU09tUzJYKy9lNW5RK3UvcXhy?=
 =?utf-8?B?UXZQRGNmRWVyaVpxaWtzanFiVkEvcVFJVFlXQkZxM0FUVG1ycTdLK1NNT25C?=
 =?utf-8?B?MEpER05aZUcyVmM3TFF6bVJJUFZMQXo1bG43TnVpek13Ui9FY09jb1oycTZ2?=
 =?utf-8?B?VGpjaXlBT0JhYWNyeVNHWEtPRHlhNERxYjVqcmJMVXRrTXlTT0M1bkRGTUNq?=
 =?utf-8?B?SzBqUWpjd2d4WDJ0cGMvN0F1YXZyU1VvV3FBV0N2S1F6ZUpmc3V5SkNQZmpx?=
 =?utf-8?B?M0JzUExMM28yTSt1bjZ4T01yVVhPTXdXSG9CcUtXRzllVXExcVJCUGZPK1JW?=
 =?utf-8?B?VzZseTNIZlhpNTh0bXlndk1YamQvaFN0RUNEbmcraUpjQWE3S3R4UFZGaEcz?=
 =?utf-8?B?UTBqbUNYa1loMmlGZGo4NjRPcDhlR2ZvYlpsakpHV3Z4YjAyVzhIcFYzak00?=
 =?utf-8?B?R3NPaWhyUzMxUENPMnlVUERoS2ZOcHE4b0tBUWpxY2g4YmhUQ1ZXaGNtYjdE?=
 =?utf-8?Q?Bs0/gSOYtkJZ7fhCUpbhxWncf5LgdraonwH3mL+f6LdWP?=
x-ms-exchange-antispam-messagedata-1: NYKv3LaLXHRWxg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1A48122B5935344AFAC37B580D0973A@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b31a8004-61c8-4e59-b8ba-08de8a21977a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2026 03:50:01.2929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9mlGu/+Qu4aEsAW9tDa67fbV4Kk2UvBBf7AheuqElNL/hncbdXy+3p+UPMH2/yyZMbZ5SV2Ntqndw8tvUClrYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8290

T24gMy8yNC8yNiAwNzo0MCwgS2VpdGggQnVzY2ggd3JvdGU6DQo+IE9uIFR1ZSwgTWFyIDI0LCAy
MDI2IGF0IDA3OjQ5OjM3QU0gKzAxMDAsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPj4gT24g
TW9uLCBNYXIgMjMsIDIwMjYgYXQgMDQ6NDQ6MTZQTSAtMDcwMCwgQ2hhaXRhbnlhIEt1bGthcm5p
IHdyb3RlOg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL252bWUvaG9zdC9tdWx0aXBhdGguYyBi
L2RyaXZlcnMvbnZtZS9ob3N0L211bHRpcGF0aC5jDQo+Pj4gaW5kZXggYmEwMGYwYjcyYjg1Li5j
NDlmY2E0M2VmMTkgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRo
LmMNCj4+PiArKysgYi9kcml2ZXJzL252bWUvaG9zdC9tdWx0aXBhdGguYw0KPj4+IEBAIC03Mzcs
NiArNzM3LDkgQEAgaW50IG52bWVfbXBhdGhfYWxsb2NfZGlzayhzdHJ1Y3QgbnZtZV9jdHJsICpj
dHJsLCBzdHJ1Y3QgbnZtZV9uc19oZWFkICpoZWFkKQ0KPj4+ICAgCQlCTEtfRkVBVF9QT0xMIHwg
QkxLX0ZFQVRfQVRPTUlDX1dSSVRFUzsNCj4+PiAgIAlpZiAoaGVhZC0+aWRzLmNzaSA9PSBOVk1F
X0NTSV9aTlMpDQo+Pj4gICAJCWxpbS5mZWF0dXJlcyB8PSBCTEtfRkVBVF9aT05FRDsNCj4+PiAr
CWlmIChjdHJsLT5vcHMgJiYgY3RybC0+b3BzLT5zdXBwb3J0c19wY2lfcDJwZG1hICYmDQo+Pj4g
KwkgICAgY3RybC0+b3BzLT5zdXBwb3J0c19wY2lfcDJwZG1hKGN0cmwpKQ0KPj4+ICsJCWxpbS5m
ZWF0dXJlcyB8PSBCTEtfRkVBVF9QQ0lfUDJQRE1BOw0KPj4gVGhpcyBhc3N1bWVzIGFsbCBjb250
cm9sbGVycyBzdXBwb3J0IFAyUCwgYnV0IHdlIGFsbG93IG1hdGNoaW5nDQo+PiBvdmVyIGRpZmZl
cmVudCB0cmFuc3BvcnRzLiAgU28geW91J2xsIG5lZWQgdG8gZG8gdGhlIHNhbWUgc2NoZW1lDQo+
PiBhcyBmb3IgTUQgUkFJRCB0aGF0IGNoZWNrcyB0aGF0IGV2ZXJ5IG1lbWJlciBzdXBwb3J0cyBQ
MlAuDQo+IElmIHRoYXQgaXMgYSBwb3NzaWJsZSBzZXR1cCwgdGhlbiB5b3UgY291bGQgYWRkIGEg
cGF0aCB0aGF0IGlzIG5vbi1QMlANCj4gY2FwYWJsZSBzb21ldGltZSBhZnRlciB0aGUgTUQgdm9s
dW1lIHdhcyBzZXR1cCB3aXRoIFAyUCBzdXBwb3J0ZWQsIHNvDQo+IHRoYXQgY2FzZSBtaWdodCBu
ZWVkIHNwZWNpYWwgaGFuZGxpbmcgdG8gbm90aWZ5IHRoZSBzdGFja2luZyBkZXZpY2Ugb2YNCj4g
dGhlIG5ldyBsaW1pdHMuDQoNClRoYW5rcyBmb3IgcmV2aWV3IHdvcmtpbmcgb24gVjIgYW5kIHRl
c3RzY3JpcHRzLg0KDQotY2sNCg0KDQo=
