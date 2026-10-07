Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022088.outbound.protection.outlook.com [40.107.200.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD8347F762;
	Wed,  7 Oct 2026 11:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791373948; cv=fail; b=atu1MjrBqPTu0heiSKzR9D21d9uC2tmMa39KHKhsxzLRo6LiVa+rdBnt+/6DDqrXhFtKdPUrfMdjcuB4vx/PWLKomGu9nKs8dn3h8gIGdSKIZ1u9jOF+HTxEwkA+yX16lrXUhqAfMfmezmbOC0IVdCfqfGgmgQ1SA9LquN5fGeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791373948; c=relaxed/simple;
	bh=N+KT2BkEzp63gtPj7+KMiD1KtK7rMeqO2nVSNTtrV7I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kPJTwFUf2i1cS0Nm4XRHO08WbpMZO+02QLI3/rSm1tswbGPkESRU9kkwg+BoC9f8nXbH56M08om9nwFf+DHzcXX9uk1TcLLGE5ismw6K1R+wcbuOgVIofPtLsnsnmiqpCLJc5R9l73XKjqHWWpwza8ARfzt87bGwB7SmPZd/Ke8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu; spf=pass smtp.mailfrom=gatech.edu; dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b=2pe7yUxW; arc=fail smtp.client-ip=40.107.200.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b="2pe7yUxW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=czC6xUAz5EI5ZK0h0SK0jt2WSqmUqQL+banXTZk/70WQ3Vsd0MrIcFfiMgEJen220KjN+hCzIGBFi+HYAoh4pdDhGahZ26+Z3Dxcb5Q2AKXCvuN3p9+PWg4QVUCAPKZbU3Ggkyry5V9l8lp4cYqXLhV6kkNEoFuH7aaWbBH/6rVWrjGLU3+UVyGQWg0WkYkosqrtPDnpVcAp4ii3NAiF0scBEndFJurE7PnpFHdPNCINSkWRjftGru12BDFPFQ06267s08qX8J9FTR6b4mhsvNw/XR8U+yXRMM6oy46jSCBPROYT6lBlagCIZd8dz6l1dzVH/XthwjUUVIGpqCGWMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+KT2BkEzp63gtPj7+KMiD1KtK7rMeqO2nVSNTtrV7I=;
 b=p1cMs2GJTiD7SyNDduR8+YhscTiofTHO+uObNUNvOopcudOztD6j786Q8smzL0KeimDQimyDTUywRrX/EvXN50k/595IaEQJUI6igyn+a+gTT0jb5hmik/F88ZShNYffvcN7+1B737Ehq5ZPlERMgBVvW2Dwuf4LzEqhgMc7eo51L6hvUKc2ZgVNTSOWWoFlNBNYSxkoBunYGYSxFUeLBt5ieiMyIOijDcmvT8ik8QZVfpwkjkic4e34tVQTDW8VGZqKTLXHpAaTtkxWUH1Ag2tQgtb6HxOGJg0RDS+I5GCUQVvIWid0H7vJcri4E95kfSpIKGfNez96iMBgcSQBZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+KT2BkEzp63gtPj7+KMiD1KtK7rMeqO2nVSNTtrV7I=;
 b=2pe7yUxWXcaPYWiRXEsWunaBOhqQLJu5g841q95P+d8curJFabykzOBWAshAhqMCyyZcXzd18blpp9eXf8JYXOZ0l9vpJmQFn3vKgZsTAPZjdiwoCUlFWLA92kPBJ+CwkLKdqyVU1xFWRxCf6peAUrUL/W7v4WNDoIsjgOQl9EC24QoDVPyLafWwrngUPAW7wQ8XxhKiVDuaYNJj103/P92sBysWciG0M1w/OlH3ej0mZE5l2iS4jBImPk1J5ZF9S0yFoRkvbu+aD4obsHBGMtzxMPf/JeGT5CImSTjVzCA0+xiExd1if4aqvLliKoLtvYrLr+eMsOczJTbLjnfHmQ==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by BY1PR07MB10725.namprd07.prod.outlook.com (2603:10b6:a03:5c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 11:51:56 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 11:51:56 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: "song@kernel.org" <song@kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	"magiclinan@didiglobal.com" <magiclinan@didiglobal.com>, "xiao@kernel.org"
	<xiao@kernel.org>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Masalkhi, Abd
 Alrhman" <abd.masalkhi@gatech.edu>
Subject: [RFC PATCH v3 2/4] md: pass struct mdu_disk_info64 to
 md_add_new_disk()
Thread-Topic: [RFC PATCH v3 2/4] md: pass struct mdu_disk_info64 to
 md_add_new_disk()
Thread-Index: AQHdVlJAF3mQrCD/bUGqrmx4tkx3pw==
Date: Wed, 7 Oct 2026 11:51:56 +0000
Message-ID: <20261007115104.13884-3-abd.masalkhi@gatech.edu>
References: <20261007115104.13884-1-abd.masalkhi@gatech.edu>
In-Reply-To: <20261007115104.13884-1-abd.masalkhi@gatech.edu>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gatech.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR07MB9958:EE_|BY1PR07MB10725:EE_
x-ms-office365-filtering-correlation-id: 7062822d-cf13-4472-ff39-08df24696313
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|786006|38070700021|11063799006|10067099003|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 F8e34G9HjE/oSElBdZ8SBO5YlAZdPtNgFGgk6NaGmVqWF7xFGdReNDT1HBom9ThlY8lHZBoWDOcZ0b5ujGFiThwyVoTuT3ENdCWxNdcZHlUA84wgfppWFUkkhlJ/ogR9zZ1weY0oR6VKeyAA3ltVXR3JNWxBeEdDHZhKtkNxh09Rx1ph2VFq7KK9d6uE/Iv+hlahILjH1ATLx5iCHFziR3GwHFwwm76UyHZTKSHbQFiw/pjflQJowcbhcqHwhwZJIxiwMO6PxvLqR4oB6RVlOH/QQA01otV4CE+aReULIbJVmzEXDXI3cVC1oLf4jtSBx2Hya36ScESt/3WeK7oTmPSJ4Jx3B2wuJ0WT2F/ZUhyXxZv5qSoIq3Q2h/xOiH01LOASLTtP047xp0Q1mf0Hwgwi5RtKhqvuwf6PwhFuUQ2lN/AxoDOJ6pwK9jUp/ZtOmp1CR8DIpJu8eOlgpxdex/W4D2PNCBU4cSEeWgOo4yvaj0PLIf/TtZT7e4e/xOMaGctI2924YzVFLmfNn0Zb24wtb0zIhDRO2rmJbTGXtKDoXUQpXP22AQcdNOlytYr5AJ5ixYGWzWDTp3RvoBTk3ZSBuc0Sz42TY9zIvUvSiEuXYD76f2/Slz++S/wFRY14EKgm3ZLjISXeDDl95MwhKNOPr9yx5C0YWGetjarrV4WOIsur8vy/COrLFWdWRySiYu9+UGygM5P8Hfr+PpAWuJqhWPJPPTPy94Cx3PY0P9U=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(786006)(38070700021)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dHJGYmtEUFd4ZGV5djRkeks4c2JGcmIza3BaRUhIWUx4bkluNmRtRGF1aXFJ?=
 =?utf-8?B?SW00alNjajF3M3FLaWdZb2hkdzdBY3RpL2xWRjRDWWg1YzlDaE9UTzdxcGI4?=
 =?utf-8?B?RDd3enlrZXBZa1djUTV5cW4xcVpoL3FRREF2eWViNjVJaTA4N2tMQlBka2t6?=
 =?utf-8?B?VW1DRHdwVzhQbkpPTmFHV3oxTzlxNHlpNHQyTCtEeHdwQyt6YlZ4WDRLcml6?=
 =?utf-8?B?bElBWG1oeUtjMXhjdG9QZ0FpRGhaaWhnRjFRZmRKVi9kKytSK3FQZ0M5RE9q?=
 =?utf-8?B?OHBPRVB2YVZTSUZOcldoTGpxOHkvQkhxUXNTdzZjVnRoSE1IcVZWSk5NMVdh?=
 =?utf-8?B?Z1d5THhiUFZkY0pnNGk1N05BZ1FqMGpJR1ptcnFMUUQ0b0o1d0s1UVNKOWw3?=
 =?utf-8?B?OUtrVGtYMXVyanh0RGtlbUZOOGoxZkVEbFBSR1JRUWxNVHdVVHJ1YlZDRlpl?=
 =?utf-8?B?Sy95SkxyV1U2dk9XT0ZvamdrajIvNUQwaHV6d1lsMjJwb1RYWE5aNDZzazkw?=
 =?utf-8?B?R0p1YkZCMW9rc1hjVGtldlJDVmJ0SG9FMHMrQ0lpZVVNMFU0RmkxVmorbE1P?=
 =?utf-8?B?bFRxT1haL0h2bkhUQ3ZuQUE4cGNJckYvd3c4K1NxZitUWGg2bk5EdmFBTkJ0?=
 =?utf-8?B?TTRrdzBGbU1jcFMra09DWnZ3T0FLRXVCWUh1d1VFRXhHY1ZPS24yUE1Rb1NX?=
 =?utf-8?B?MnB3ZGtSU0xRbDk5ZmxRRk51aTRkcFpUbmt4K1lwazRDNFBrZnZGU1JHN28w?=
 =?utf-8?B?NVMwQWZpWHNibkdPVlRHcE8vN1JXblBIMmlTQURXTWZlbjFCNEpZVFdpeFBN?=
 =?utf-8?B?bVVNbzZCSjlCaUg5TGdoVzZyVkNsaTB5TGdwZE42RUtJcjA4R2lqRWYwT25r?=
 =?utf-8?B?cnpNRXNqeGMyRDdwVTNkOExtSkovYmpLc00wZ2o0NkFhREJ1aE1TQnlERVRk?=
 =?utf-8?B?S25XMk1udE1iRFpZTHAvZk8ycURhZTc2M0tDV2grckpJWU85MzVGTlVsZlFk?=
 =?utf-8?B?YlBwTitqWE5OTHJWbGQxaXc2Q1pYMEU0a09JS2VoY2tpQzVSUTM1SGJ3OHFh?=
 =?utf-8?B?TVZGcUVKRENSZGR3clZDUmZsV3pweFlmb3lqenVoeHRBMHpsbUpZUzgrb0Yw?=
 =?utf-8?B?alhKN3BUci9ta3RHVVpmSG9PVnJnYTRrTjNhcDRrSWhWSGwvQjNDRXdEMStt?=
 =?utf-8?B?bWNGaElUNzdaK1hkbnU1enVnWWxKeVdtTCtLeGlISnFBb0RSTk9oajlQbmts?=
 =?utf-8?B?R2piamxCR2JDcXNVeFVlN2kwVUJXTEFwaE0rejhoV0VTUk9VSG9na1hleldI?=
 =?utf-8?B?RmhWMTZNTEV4d1NRdzFXZ2lCSlNrb04rT1J4aVVOT2NJc01aeXZhV1M5SS8v?=
 =?utf-8?B?SU0zalo4RlYrQkZPeDhIbWRIMnp2b3pkOG03MWRheTdKL1N6d2g5TzFRaUlU?=
 =?utf-8?B?VGw1S3Z3ZjlKSTZtRkhJZTE1UUJCOTVFM1dNYWVZM280SVl2WHFGMENMTDVh?=
 =?utf-8?B?NXJFWE5PNnFVRVhhSzI5b29jTzYzYWVtM2ZVdDV0SjJXV05BSWUxdzBMY3h5?=
 =?utf-8?B?MTF2Mm9iVFlLUVJYbEV6a1FOOVBDNVdlQ1BWRlFTUmtGNWEvdUJobWtYeVpR?=
 =?utf-8?B?UGhpdjk4MXB1VW92Wms0VGtkejlBekQ5THhOREVJTkhqQnRKUHYxOXN5UDdT?=
 =?utf-8?B?cnhLK0hDS2FSQjVGRkE0TlpoWXBXRm9SeWpOYS9xNEhmUGdyZkFIL1dDVmg2?=
 =?utf-8?B?ZXdOcng1MVdNMXhnVUFKTkpZVkY4WEtqVElrWlJzT1BWWkdHVy94bGFyeEVs?=
 =?utf-8?B?QVo3WHpLV2NOSFlIa0pWYWFRdzlhbk9pY3J4MEV4VFh1WXNNVUh6T1l3MVlX?=
 =?utf-8?B?RFhuRmxlemZIYWJzMDFTV1dCMTk5Znc1ODRwcHRseEpWcmxLNVNJWU5kRGFt?=
 =?utf-8?B?MVJqRlhoejlBOTBibWsvc1JaZTd0ZlZCSmROd2E3aEJPNTRybDVHeVFsSFZQ?=
 =?utf-8?B?UWlqUkZCTGtNUzJtL0s2WWxhbUFlWWtGREJXRDdZOVFnNmYzUjFLVjZaQjNl?=
 =?utf-8?B?S1Y5YW5SVTB3dnFDYXBXcEtPSElTcGFaT1ZoYkRSaGJLU21HaC9wMFJFRGZ3?=
 =?utf-8?B?OU5Ud3FjNGMvVDFXeHJrVUxtRVdiSnl1SHZaanh2cVJPakZjeWVXaGRKZjl1?=
 =?utf-8?B?eGtKNlpXQitxZWtzR0taR0lLYU1wR2hsZlpNeUZLU2ZvaHJ1RkVpaUNpZGJ3?=
 =?utf-8?B?eXgyL243VE5yWlVSTUZFT0JRUEpSVVljdHo5OHhhVWV0eEk1c091QXdxOUU1?=
 =?utf-8?B?WDRaRzNLd1N5ekM0WmVKWFB0czFwN0tqajN0cXZIOFRtcE1PTVE3UT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: gatech.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR07MB9958.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7062822d-cf13-4472-ff39-08df24696313
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2026 11:51:56.2137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d4ZwBPBq50xTaNsMhQhRtK9JglG4PagOcrU1Y6R+rqDJivAW3Hspk0EV/g2E1ut9G9zXHiPUcgWQ0TXQvMOqdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR07MB10725

RnJvbTogQWJkLUFscmhtYW4gTWFzYWxraGkgPGFiZC5tYXNhbGtoaUBnYXRlY2guZWR1PgoKVGhl
IG1kIGNvbnRyb2wgZGV2aWNlIHBhc3NlcyBkaXNrIGluZm9ybWF0aW9uIGFzIHN0cnVjdCBtZHVf
ZGlza19pbmZvNjQuCk1ha2UgbWRfYWRkX25ld19kaXNrKCkgdGFrZSB0aGlzIHN0cnVjdHVyZSwg
c28gdGhhdCB0aGUgY29udHJvbCBkZXZpY2UKYW5kIHRoZSBvbGQgQUREX05FV19ESVNLIGlvY3Rs
IGNhbiBzaGFyZSBpdC4KClRoZSBBRERfTkVXX0RJU0sgaW9jdGwgY29udmVydHMgaXRzIG1kdV9k
aXNrX2luZm9fdCB3aXRoIHRoZSBuZXcgaGVscGVyCmNvbnZlcnRfdG9fZGlza19pbmZvNjQoKSwg
YW5kIG1kX3NldHVwX2RyaXZlKCkgdXNlcyBhIHN0cnVjdAptZHVfZGlza19pbmZvNjQgZGlyZWN0
bHkuCgpObyBmdW5jdGlvbmFsIGNoYW5nZS4KClNpZ25lZC1vZmYtYnk6IEFiZC1BbHJobWFuIE1h
c2Fsa2hpIDxhYmQubWFzYWxraGlAZ2F0ZWNoLmVkdT4KLS0tCiBkcml2ZXJzL21kL21kLWF1dG9k
ZXRlY3QuYyB8ICAyICstCiBkcml2ZXJzL21kL21kLmMgICAgICAgICAgICB8IDI2ICsrKysrKysr
KysrKysrKysrKysrKy0tLS0tCiBkcml2ZXJzL21kL21kLmggICAgICAgICAgICB8ICA0ICsrLS0K
IDMgZmlsZXMgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL21kL21kLWF1dG9kZXRlY3QuYyBiL2RyaXZlcnMvbWQvbWQtYXV0b2Rl
dGVjdC5jCmluZGV4IDRiODAxNjVhZmQyMy4uOWJhMDYxZjFhNjI4IDEwMDY0NAotLS0gYS9kcml2
ZXJzL21kL21kLWF1dG9kZXRlY3QuYworKysgYi9kcml2ZXJzL21kL21kLWF1dG9kZXRlY3QuYwpA
QCAtMjAxLDcgKzIwMSw3IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBtZF9zZXR1cF9kcml2ZShzdHJ1
Y3QgbWRfc2V0dXBfYXJncyAqYXJncykKIAllcnIgPSBtZF9zZXRfYXJyYXlfaW5mbyhtZGRldiwg
JmFpbmZvKTsKIAogCWZvciAoaSA9IDA7IGkgPD0gTURfU0JfRElTS1MgJiYgZGV2aWNlc1tpXTsg
aSsrKSB7Ci0JCXN0cnVjdCBtZHVfZGlza19pbmZvX3MgZGluZm8gPSB7CisJCXN0cnVjdCBtZHVf
ZGlza19pbmZvNjQgZGluZm8gPSB7CiAJCQkubWFqb3IJPSBNQUpPUihkZXZpY2VzW2ldKSwKIAkJ
CS5taW5vcgk9IE1JTk9SKGRldmljZXNbaV0pLAogCQl9OwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZC9tZC5jIGIvZHJpdmVycy9tZC9tZC5jCmluZGV4IDE1NGVlNWE2NWNiNy4uYmUxNjM0YWUxZDA5
IDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL21kLmMKKysrIGIvZHJpdmVycy9tZC9tZC5jCkBAIC03
NDg2LDcgKzc0ODYsNyBAQCBzdGF0aWMgaW50IGdldF9kaXNrX2luZm8oc3RydWN0IG1kZGV2ICpt
ZGRldiwgdm9pZCBfX3VzZXIgKiBhcmcpCiAJcmV0dXJuIDA7CiB9CiAKLWludCBtZF9hZGRfbmV3
X2Rpc2soc3RydWN0IG1kZGV2ICptZGRldiwgc3RydWN0IG1kdV9kaXNrX2luZm9fcyAqaW5mbykK
K2ludCBtZF9hZGRfbmV3X2Rpc2soc3RydWN0IG1kZGV2ICptZGRldiwgc3RydWN0IG1kdV9kaXNr
X2luZm82NCAqaW5mbykKIHsKIAlzdHJ1Y3QgbWRfcmRldiAqcmRldjsKIAlkZXZfdCBkZXYgPSBN
S0RFVihpbmZvLT5tYWpvcixpbmZvLT5taW5vcik7CkBAIC04MzA1LDYgKzgzMDUsMTYgQEAgc3Rh
dGljIGJvb2wgbWRfaW9jdGxfbmVlZF9zdXNwZW5kKHVuc2lnbmVkIGludCBjbWQpCiAJfQogfQog
CitzdGF0aWMgdm9pZCBjb252ZXJ0X3RvX2Rpc2tfaW5mbzY0KHN0cnVjdCBtZHVfZGlza19pbmZv
NjQgKmluZm82NCwKKwkJCQkgICBtZHVfZGlza19pbmZvX3QgKmluZm8pCit7CisJaW5mbzY0LT5u
dW1iZXIgPSBpbmZvLT5udW1iZXI7CisJaW5mbzY0LT5tYWpvciA9IGluZm8tPm1ham9yOworCWlu
Zm82NC0+bWlub3IgPSBpbmZvLT5taW5vcjsKKwlpbmZvNjQtPnJhaWRfZGlzayA9IGluZm8tPnJh
aWRfZGlzazsKKwlpbmZvNjQtPnN0YXRlID0gaW5mby0+c3RhdGU7Cit9CisKIHN0YXRpYyBpbnQg
X19tZF9zZXRfYXJyYXlfaW5mbyhzdHJ1Y3QgbWRkZXYgKm1kZGV2LCB2b2lkIF9fdXNlciAqYXJn
cCkKIHsKIAltZHVfYXJyYXlfaW5mb190IGluZm87CkBAIC04NDUyLDEzICs4NDYyLDE2IEBAIHN0
YXRpYyBpbnQgbWRfaW9jdGwoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgYmxrX21vZGVfdCBt
b2RlLAogCQkgKi8KIAkJaWYgKG1kZGV2LT5wZXJzKSB7CiAJCQltZHVfZGlza19pbmZvX3QgaW5m
bzsKKwkJCXN0cnVjdCBtZHVfZGlza19pbmZvNjQgaW5mbzY0ID0gezB9OwogCQkJaWYgKGNvcHlf
ZnJvbV91c2VyKCZpbmZvLCBhcmdwLCBzaXplb2YoaW5mbykpKQogCQkJCWVyciA9IC1FRkFVTFQ7
CiAJCQllbHNlIGlmICghKGluZm8uc3RhdGUgJiAoMTw8TURfRElTS19TWU5DKSkpCiAJCQkJLyog
TmVlZCB0byBjbGVhciByZWFkLW9ubHkgZm9yIHRoaXMgKi8KIAkJCQlicmVhazsKLQkJCWVsc2UK
LQkJCQllcnIgPSBtZF9hZGRfbmV3X2Rpc2sobWRkZXYsICZpbmZvKTsKKwkJCWVsc2UgeworCQkJ
CWNvbnZlcnRfdG9fZGlza19pbmZvNjQoJmluZm82NCwgJmluZm8pOworCQkJCWVyciA9IG1kX2Fk
ZF9uZXdfZGlzayhtZGRldiwgJmluZm82NCk7CisJCQl9CiAJCQlnb3RvIHVubG9jazsKIAkJfQog
CQlicmVhazsKQEAgLTg0OTMsMTAgKzg1MDYsMTMgQEAgc3RhdGljIGludCBtZF9pb2N0bChzdHJ1
Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBibGtfbW9kZV90IG1vZGUsCiAJY2FzZSBBRERfTkVXX0RJ
U0s6CiAJewogCQltZHVfZGlza19pbmZvX3QgaW5mbzsKKwkJc3RydWN0IG1kdV9kaXNrX2luZm82
NCBpbmZvNjQgPSB7MH07CiAJCWlmIChjb3B5X2Zyb21fdXNlcigmaW5mbywgYXJncCwgc2l6ZW9m
KGluZm8pKSkKIAkJCWVyciA9IC1FRkFVTFQ7Ci0JCWVsc2UKLQkJCWVyciA9IG1kX2FkZF9uZXdf
ZGlzayhtZGRldiwgJmluZm8pOworCQllbHNlIHsKKwkJCWNvbnZlcnRfdG9fZGlza19pbmZvNjQo
JmluZm82NCwgJmluZm8pOworCQkJZXJyID0gbWRfYWRkX25ld19kaXNrKG1kZGV2LCAmaW5mbzY0
KTsKKwkJfQogCQlnb3RvIHVubG9jazsKIAl9CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbWQu
aCBiL2RyaXZlcnMvbWQvbWQuaAppbmRleCA2NDQwZGEyOTIxMDUuLmE4NGM4Yjk3ZmEyYyAxMDA2
NDQKLS0tIGEvZHJpdmVycy9tZC9tZC5oCisrKyBiL2RyaXZlcnMvbWQvbWQuaApAQCAtMTA0Mywx
MiArMTA0MywxMiBAQCBzdGF0aWMgaW5saW5lIHZvaWQgbWRkZXZfdW5sb2NrX2FuZF9yZXN1bWUo
c3RydWN0IG1kZGV2ICptZGRldikKIH0KIAogc3RydWN0IG1kdV9hcnJheV9pbmZvX3M7Ci1zdHJ1
Y3QgbWR1X2Rpc2tfaW5mb19zOworc3RydWN0IG1kdV9kaXNrX2luZm82NDsKIAogZXh0ZXJuIGlu
dCBtZHBfbWFqb3I7CiB2b2lkIG1kX2F1dG9zdGFydF9hcnJheXMoaW50IHBhcnQpOwogaW50IG1k
X3NldF9hcnJheV9pbmZvKHN0cnVjdCBtZGRldiAqbWRkZXYsIHN0cnVjdCBtZHVfYXJyYXlfaW5m
b19zICppbmZvKTsKLWludCBtZF9hZGRfbmV3X2Rpc2soc3RydWN0IG1kZGV2ICptZGRldiwgc3Ry
dWN0IG1kdV9kaXNrX2luZm9fcyAqaW5mbyk7CitpbnQgbWRfYWRkX25ld19kaXNrKHN0cnVjdCBt
ZGRldiAqbWRkZXYsIHN0cnVjdCBtZHVfZGlza19pbmZvNjQgKmluZm8pOwogaW50IGRvX21kX3J1
bihzdHJ1Y3QgbWRkZXYgKm1kZGV2KTsKICNkZWZpbmUgTURERVZfU1RBQ0tfSU5URUdSSVRZCSgx
dSA8PCAwKQogaW50IG1kZGV2X3N0YWNrX3JkZXZfbGltaXRzKHN0cnVjdCBtZGRldiAqbWRkZXYs
IHN0cnVjdCBxdWV1ZV9saW1pdHMgKmxpbSwKLS0gCjIuNDMuMAoK
