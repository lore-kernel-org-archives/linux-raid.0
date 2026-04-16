Received: from MEUPR01CU001.outbound.protection.outlook.com (mail-australiasoutheastazolkn19010000.outbound.protection.outlook.com [52.103.73.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82AD37C11C;
	Thu, 16 Apr 2026 10:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.73.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776334116; cv=fail; b=L0BolOfs1dgbD8exNcEUBm2Y0GMX5p9RffsMRP0p+g78m7UjpUmZHfWnNTReMfxCdNtLwCFu/WUvrSZRpqzNYDorz8PSUkkgJ+3SevFEE0JnUgm/G6rFkpiq5TJz4RWIGPjhvGexChyo8LJ/Nkpsc8bsnfzBFs20ycUtWbOlKmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776334116; c=relaxed/simple;
	bh=af81q5vOVRWljEzq4TAAby7fcw62NXvczf9EFPczp6o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YxZbkrntISeP/+0bTwITpUbOT2Y40KxKzk3OfLdXvsXs3OZX6y4L0yqwgpCVRfyt4TFsfug+Akwj6JvMi1zG5OwCBRJtkHngyHYcjEp9cxBN0H7rjRuc3M3sNmcNj+MUcPfaquSzzG2zfF+PxIo4t0cQXgOi3zFuavh5o1vxv6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=j/K4JWuF; arc=fail smtp.client-ip=52.103.73.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="j/K4JWuF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ouaw+FZAfNA+r6eeSCPd3jiOksTa/i32kNQYyg/m+KtBOVuzqA3rW1mChD/FfKpqlfsDFCUqjTPVHiAHGZihAVxDwvjanRuvmIUeRxjI9IQrFLrHHclqTQzonbrJpYfKHmrC9apGUHnYKX23sUU9IPrVC+Cff1k5HRezxirbZvQ51BBgRjBLvjnzjzdZILgiJhAI+k4gv5t59NNRy3nfesESzKt0MV5SfXwQL29dLhpV0Tx4Ys2Mddq3T2Icm2spwzBbRUHYPTx+HlZ+0Spnkpg77j3ZGOVjORc6t612ULSj/+Q4S90vExbltPViFB5KVHHh/ytHA5wcXnxbX6HY7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=af81q5vOVRWljEzq4TAAby7fcw62NXvczf9EFPczp6o=;
 b=XxklZRujaA9tYC4FK/4ser0NCBN14ALRNIuUWjqPtQEvBG3pYvGBjeXXWr2vkcnArrDPr6dCgh2waEHMrKu1xeGhgdbCRvwvt8B6DXeossWuJLX2VnttXZBpPS4uP88DZER7m4v/MjjP7X0ueWIOHZPVETLXl/6QbKLx83/2LUjgv2hPGvgsqSR80KiFVlq5oijyA7emzlYCwNAqJJS9j+NRHefCpdLPc2uhRFB2YYkRr8gkxNYNz8GXRxX1g9+9+CGv3XBwqEesmMPb//HmlVl4G8n4/LN7LZYrRJIUTyy4vaGalQ7WbFro0ViHaVEDUgp0+TcjlxXeNuJ7JGaHTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=af81q5vOVRWljEzq4TAAby7fcw62NXvczf9EFPczp6o=;
 b=j/K4JWuFdUPyR5e4lmb1iHvQb7NqfKJPyV2mSRcQAA8IY8J4/9sCCaR3H/W5EUmpDEozE65m/pHYOf/qzt0idwAe8hGFaMJOE5Es/gKtPBZZBMpmu7169RVj8f4E253Ca6/UBmfNqvElnx7hMEn09s3G/qwWiZHGLvEkV6MmLZlnsLWBjKBhn5w658ilelN6ZweONlP2Rq91yfbBPs4xzgr+zPQFD6e2UlmUt9sVi1Gfn9uUMHOIf0UU3H2zcYhcfntxLTtbyvPfRFkarsRtIXDFUpsYA8HIR+pD5cDfLIY2K6G0RM0MQaWgrsrG1DvtJjglZEgiT3khEFlnED+1hg==
Received: from MEYPR01MB7886.ausprd01.prod.outlook.com (2603:10c6:220:17e::8)
 by MEWPR01MB8968.ausprd01.prod.outlook.com (2603:10c6:220:1fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Thu, 16 Apr
 2026 10:08:28 +0000
Received: from MEYPR01MB7886.ausprd01.prod.outlook.com
 ([fe80::19df:3891:d8aa:692d]) by MEYPR01MB7886.ausprd01.prod.outlook.com
 ([fe80::19df:3891:d8aa:692d%3]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 10:08:28 +0000
From: Junrui Luo <moonafterrain@outlook.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
CC: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
	<linan122@huawei.com>, NeilBrown <neil@brown.name>, Jonathan Brassow
	<jbrassow@redhat.com>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Yuhao Jiang <danisjiang@gmail.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] md/raid10: fix divide-by-zero in setup_geo() with zero
 far_copies
Thread-Topic: [PATCH] md/raid10: fix divide-by-zero in setup_geo() with zero
 far_copies
Thread-Index: AQHczVLOPVmDpt9fWUGpfw6voHPxobXhNr4AgABAfYA=
Date: Thu, 16 Apr 2026 10:08:28 +0000
Message-ID: <BA3D2E50-0F0F-464B-AA69-29ACF83EAF42@outlook.com>
References:
 <SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <803b6b1c-6aef-43e0-89e2-3d0f1308e892@molgen.mpg.de>
In-Reply-To: <803b6b1c-6aef-43e0-89e2-3d0f1308e892@molgen.mpg.de>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MEYPR01MB7886:EE_|MEWPR01MB8968:EE_
x-ms-office365-filtering-correlation-id: c7071ec9-07ca-4982-3fe5-08de9ba01b2f
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|461199028|8062599012|19110799012|12121999013|51005399006|15080799012|8060799015|41001999006|22091999003|24121999003|40105399003|3412199025|440099028|102099032;
x-microsoft-antispam-message-info:
 =?utf-8?B?RGxvUi9iZmtEcTgzNFduY28zYlNmMm5YTXdCWThwRUg3ci9TYndYZ0dJM2hI?=
 =?utf-8?B?K0NEUTlMSDJEVHFIY0F2eFAxZ0xYL1I5Ny8vM1pQMGQ2bW5BREtYS2ZsUnVr?=
 =?utf-8?B?K2tCVkJQa3RGeHM0U2FJR0x4V3VFeC9NREYyOVArNlJNNFF2RVRRYVFoaWo4?=
 =?utf-8?B?bnduQmphUTc1aEVwSGhFSHRLdFh6a295clIrMnQra3YzOUJtbHh1Y2hiM2lO?=
 =?utf-8?B?ZE1CSHVxMjFSb1JMUTl2RnR4WnNhYlV2U2JWTW5DZGlrU3U1K3VwTzBmQy9F?=
 =?utf-8?B?QTJNRXRiY3lMWW94N2g0Qm5GeFJNTWVQY2dudDArTk16TmRiTkZhSndSR0ZW?=
 =?utf-8?B?MjhZVmlDR2d1UVIvZmxIU1NYVUJ0b2syZnhBSnlPRW5oQVhjUGhLa2dFb05L?=
 =?utf-8?B?NnBuZkk5Q1VINHNmYTNkL25PUjkzbEw3SUdwVXVjdTFOd3pnR0krQU0rcGRi?=
 =?utf-8?B?RlVpYnhzMlA2ZFhpWUFITUZPQkJ5WHZIeWdvRTVib3pobDBuQWhWL2drcmVF?=
 =?utf-8?B?bkliaDlRSHBHbm1XUitDbk5xLzRWeFZRaE5nTWY4V1lTWXBVLzROWlNDTHli?=
 =?utf-8?B?aHpsNEhzQWZ3RjRjcXJjVU5LbG9UMmRsLzRPTVNLTUdqUEt3M2QyR0F3UGVP?=
 =?utf-8?B?bjFHTjdvb3dkeW5vaVBFMmpFUnFjNzg1VmdDQmI1WUZPQVBiMkUzT25mck1l?=
 =?utf-8?B?aXdjc1FuY1BJZzNFUjVBYjNaK2dsV0pvWURLZWM2ak45MjFHRFNYOVRXVkxH?=
 =?utf-8?B?cElkNmh1cnU5UDF6Qk43NVpacEtKa3lzTldsSjZFeXhzOWw0bEZxcUg3VnBl?=
 =?utf-8?B?MkF5TzBpNWllZUxqQ2t2V1BkaTRseFBRL2dQTW1XNGxxSGVzd3lPWHpuOFBM?=
 =?utf-8?B?S085M3hNZGwyOERGSzZGbFk3cHpUVGdnRHZ2K0xIcnRVbVd5NzZHb0tnR3Rx?=
 =?utf-8?B?RWxGV215Vzg1Z2x2bTJFYlhBR3hsRmpnaHZiQXdrcTJxV3RwdnpoQnZsMlJW?=
 =?utf-8?B?OG9aN1hSQ2g2OFdnV2R4cHM3YWZPbkJGdEVGN2FVYWlnR01ORVFheWR6OGpF?=
 =?utf-8?B?b0pVV1ZUQ3AyTElyNi9IY0ZIYjlXSm9PK0V3anh4bndIM1dQQXBybDFXNm5X?=
 =?utf-8?B?RGE1OWUwZHZoUUtxb3cyU1lQOUxzS2JYQTcvZlFqTTRtODFlUDNhcHBBUXBH?=
 =?utf-8?B?Z0NzMFU3V2oyam1jYlFGdmFQOXFQUXhGWS9ISDNYbFFoNkdJVkdvK21ZR2I4?=
 =?utf-8?B?S2NEaG4rL2paeDN3MnFwR05rcFBFdmFkY2F6UjlCck4yU2EvQUVLNnQzTzVM?=
 =?utf-8?B?MEZkVHVnb2pEUjJ4WjdkS0NzNnlLdlpTQWJXVmRFWlRaSlI4M2JNTER4RGlj?=
 =?utf-8?Q?Vbk8F0N2b43MN2puVvWSoH34AHJOrcX8=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bU9tOFFNSkoxYmNWOWJOQUtQMk5iaTAyeFVFbWs2VGQ1NjZPS243ZGNRZXhG?=
 =?utf-8?B?QndKYVA4aGExU0d0SGFYZGR5b29QSDBYVnp0SnVUelBzREpEdmZWMEVicjg4?=
 =?utf-8?B?cGdBaEVLcU5RZkRzVHpuNkhnQVlqRHNlZWQraFp2YWxwN0FjTnl0UHBuL0J0?=
 =?utf-8?B?eG9HL2FaQ3NaZitUVnhjNTBKNFRqcGJlOS9LNkJBTHE1eFpoQmFlTWlGNHBm?=
 =?utf-8?B?ZkhObVMrTHBkMWVyNUtiWGNDeWFWMU9HWnBKcGE1ZUwrTEFqWlh5dkFLcnF2?=
 =?utf-8?B?TENxVWg2YWg4MHVKZS81WEJiY2xGbjRacGNNMmlFcmpoaGFKb1JCV3VkSUdK?=
 =?utf-8?B?VjE0Ykk2M0ltdjFPci9Tb1BHcC93YjhzVkxHMzQ5TzU0dEhvRVlIdS8rMkZN?=
 =?utf-8?B?WjMrUG84Q3VQZVA1WXZwS2drTGFqeWFXMXN1QXpwdDV3dHVUTFBCU0pPc01y?=
 =?utf-8?B?b1NVaEQrUDdZU3NONitSZzhTWGY5MDVTYjNaM0Zsd2R1TVhwZlo2Y0kyMFFr?=
 =?utf-8?B?cWRHbUhKT0RRYUNlay9CQzlHRkxyQ0VnVGw5OEtlamFENklwMzUzaE0vSTRX?=
 =?utf-8?B?TkY2Slh6eXkySjgyM1B5bGZ1azJJbG5rZTI3RWRYakQ2aFJiMnRXV1E3Y0xy?=
 =?utf-8?B?OVRINi9IODV1aWx6d1VLeWRENURXQ0hlc0J1a3duNG1WMS9OeDNWclg3cDZi?=
 =?utf-8?B?SEZpVFA1VWFCNzFtdE00WUdCbXdCQS9ma1Y1ODRqc3dVZ0NHekVxVy9qK0FP?=
 =?utf-8?B?Y0I3UFdzZkVJMWRwOHgzR2ExRE9oeEN0cnphelBPQ0RDSUxRanJ3a1IvMWRT?=
 =?utf-8?B?bUNiWEV1amxYNzZodmNsMllzalRmSWQ4b0hVaVBMVG1yNVByZDhaS2w1dElT?=
 =?utf-8?B?ckQwVkdIeUhWN0lNeWx3a0REaXJhUzdQaUtWYVkrOVdWZzEwd0tUUzRuQkpZ?=
 =?utf-8?B?ZlB3UzQ2QWI1TUtYa2g4c1NsRVA2bzlXTUlhdUNYOCtWSWxrREVJVVhkNG14?=
 =?utf-8?B?VXByWEd3SUNrMFFRamx3RG94bWJtYXh0Rk05L25TdVMxRm92U1NZZnkzMXhB?=
 =?utf-8?B?RzlOUDlXMnM0Wm5GMG5OSkljbVFpWmVMYTlHbi9EWDd5aVQ2dzh0YXh0MVVs?=
 =?utf-8?B?Y3BORmRjNWZEampLN2w4aWpNbEFHTEEyWS91dU1YZ0wxaHpISDg3R09rQWVJ?=
 =?utf-8?B?eTc1ZjhEK1kveWhUUXBkaC90NXhNU2J2dGNldXAxMlpPMWFLYXRPdlJXdGQ5?=
 =?utf-8?B?L0VCMnZyd1crU29RSHN2bDV3R0pOYU5xbk9OamNGWnB3QThXTHdsQWpyTFI5?=
 =?utf-8?B?QUVwUWJwd2V3aDF1MENraXFKL2VZNGhHRnFmdXR4WWVjcFFpbW5rWTIwZnk0?=
 =?utf-8?B?VCtjNVVteTJiNStWTlZ5S0tqYzRHb0ROQ1MvRHJwUnlscTNrRnUrSENQUHlU?=
 =?utf-8?B?SW9kN2wwNy9aTHB3QU5OK0V5b2NkSnJCemE3OExaczhIUkZoTkZzeDNmbU85?=
 =?utf-8?B?MXNFYUFlOGVMeXJTS1FyZStrQ1hLTUZnbEwwOFB0bU5hWTMzTFhVTUpET2Vr?=
 =?utf-8?B?eXRWdHhOYStkUmhEUGs5NVlBWDFBYVJYbFN0em9jWEd6SW9iMDBhZUJHT0t4?=
 =?utf-8?B?aE4wZzhRQ2FWc0dhclFBcVpkODhla0lrZlhta0djRnlaTCtNQlNvbGVabWR0?=
 =?utf-8?B?aHo3MkRpOXBHMkE1dHplU3l2UTA4RDVjeGowMlJSRmFncjFYMi9pWWxxSWR1?=
 =?utf-8?B?M3E2a0xDYWV4ZTdFQXdNRWROU3lEZE9RYlhCN24xZmxxQW9kQktsS1Frdm43?=
 =?utf-8?B?aVRmKzRManNDeHNxZng2ZzE2Q0lvVGJnY3d3UHQ2NXd6Y1ZyQXlHTkUxSmM0?=
 =?utf-8?B?MXgwdk5PWGhJNVovQWlsMUNPTW9ZbjR5Uk5FQy92eFl6Z1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FCAAC56ED8D9645B1FC1F38FD53B06C@ausprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MEYPR01MB7886.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c7071ec9-07ca-4982-3fe5-08de9ba01b2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2026 10:08:28.5821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEWPR01MB8968

SGkgUGF1bCwNCg0KVGhhbmsgeW91IGZvciB0aGUgcmV2aWV3Lg0KDQpPbiBUaHUsIEFwciAxNiwg
MjAyNiBhdCAwODoxNzoyNkFNICswMjAwLCBQYXVsIE1lbnplbCB3cm90ZToNCj4gV2h5IGFsc28g
YG5jYCBhbmQgbm90IGp1c3QgYGZjYD8NCg0KbmMgYW5kIGZjIGFyZSBkb2N1bWVudGVkIGFzICJt
dXN0IGJlIGF0IGxlYXN0IG9uZSIgKHJhaWQxMC5jDQpsaW5lIDQ3KSwgaXQgc2VlbWVkIGNsZWFu
ZXIgdG8gcmVqZWN0IGJvdGggdG9nZXRoZXIuDQoNCj4gSXTigJlkIGJlIGdyZWF0LCBpZiB5b3Ug
ZG9jdW1lbnRlZCB0aGUgY29tbWFuZCBob3cgdG8gY3JlYXRlIHN1Y2ggYSBsYXlvdXQuDQoNCkhl
cmUgaXMgYSByZXByb2R1Y2VyIHRoYXQgdHJpZ2dlcnMgdGhlIGRpdmlkZS1ieS16ZXJvDQoNCiAg
Zm9yIGkgaW4gMCAxIDIgMzsgZG8NCiAgICBkZCBpZj0vZGV2L3plcm8gb2Y9L3RtcC9sb29wJGkg
YnM9MU0gY291bnQ9NjQNCiAgICBsb3NldHVwIC9kZXYvbG9vcCRpIC90bXAvbG9vcCRpDQogIGRv
bmUNCg0KICBnY2MgLW8gcmFpZDEwX3BvYyByYWlkMTBfcG9jLmMNCiAgLi9yYWlkMTBfcG9jDQoN
CmBgYA0KICAjaW5jbHVkZSA8c3RkaW8uaD4NCiAgI2luY2x1ZGUgPHN0ZGxpYi5oPg0KICAjaW5j
bHVkZSA8ZmNudGwuaD4NCiAgI2luY2x1ZGUgPHVuaXN0ZC5oPg0KICAjaW5jbHVkZSA8c3RyaW5n
Lmg+DQogICNpbmNsdWRlIDxzeXMvaW9jdGwuaD4NCiAgI2luY2x1ZGUgPHN5cy9zdGF0Lmg+DQog
ICNpbmNsdWRlIDxzeXMvc3lzbWFjcm9zLmg+DQogICNpbmNsdWRlIDxsaW51eC9tYWpvci5oPg0K
ICAjaW5jbHVkZSA8bGludXgvcmFpZC9tZF91Lmg+DQoNCiAgaW50IG1haW4odm9pZCkNCiAgew0K
ICAJaW50IGZkLCBpOw0KICAJbWR1X2FycmF5X2luZm9fdCBhcnJheTsNCiAgCW1kdV9kaXNrX2lu
Zm9fdCBkaXNrOw0KDQogIAlta25vZCgiL2Rldi9tZDAiLCBTX0lGQkxLIHwgMDYwMCwgbWFrZWRl
dig5LCAwKSk7DQoNCiAgCWZkID0gb3BlbigiL2Rldi9tZDAiLCBPX1JEV1IpOw0KICAJaWYgKGZk
IDwgMCkgew0KICAJCXBlcnJvcigib3BlbiAvZGV2L21kMCIpOw0KICAJCXJldHVybiAxOw0KICAJ
fQ0KDQogIAltZW1zZXQoJmFycmF5LCAwLCBzaXplb2YoYXJyYXkpKTsNCiAgCWFycmF5Lm1ham9y
X3ZlcnNpb24gPSAxOw0KICAJYXJyYXkubWlub3JfdmVyc2lvbiA9IDI7DQogIAlhcnJheS5sZXZl
bCA9IDEwOw0KICAJYXJyYXkubGF5b3V0ID0gMHgyMDAwMDsNCiAgCWFycmF5LnJhaWRfZGlza3Mg
PSA0Ow0KICAJYXJyYXkuY2h1bmtfc2l6ZSA9IDY1NTM2Ow0KDQogIAlpZiAoaW9jdGwoZmQsIFNF
VF9BUlJBWV9JTkZPLCAmYXJyYXkpIDwgMCkgew0KICAJCXBlcnJvcigiU0VUX0FSUkFZX0lORk8i
KTsNCiAgCQlyZXR1cm4gMTsNCiAgCX0NCg0KICAJZm9yIChpID0gMDsgaSA8IDQ7IGkrKykgew0K
ICAJCW1lbXNldCgmZGlzaywgMCwgc2l6ZW9mKGRpc2spKTsNCiAgCQlkaXNrLm51bWJlciA9IGk7
DQogIAkJZGlzay5yYWlkX2Rpc2sgPSBpOw0KICAJCWRpc2suc3RhdGUgPSAoMSA8PCAxKSB8ICgx
IDw8IDIpOw0KICAJCWRpc2subWFqb3IgPSA3Ow0KICAJCWRpc2subWlub3IgPSBpOw0KICAJCWlm
IChpb2N0bChmZCwgQUREX05FV19ESVNLLCAmZGlzaykgPCAwKSB7DQogIAkJCXBlcnJvcigiQURE
X05FV19ESVNLIik7DQogIAkJCXJldHVybiAxOw0KICAJCX0NCiAgCX0NCg0KICAJLyogdHJpZ2dl
cnMgc2V0dXBfY29uZigpIC0+IHNldHVwX2dlbygpIC0+IGRpc2tzL2ZjIHdpdGggZmM9MCAqLw0K
ICAJaW9jdGwoZmQsIFJVTl9BUlJBWSwgTlVMTCk7DQoNCiAgCWNsb3NlKGZkKTsNCiAgCXJldHVy
biAwOw0KICB9DQpgYGANCg0KPiBJ4oCZZCBhbHNvIHByaW50IGEgd2FybmluZywgc28gdGhlIHVz
ZXIga25vd3MsIHdoYXQgd2FzIHdyb25nOg0KPiANCj4gICAgIHByX3dhcm4obWQvcmFpZDEwOiVz
OiBuZWFyIGFuZCBmYXIgY29waWVzIG5lZWQgdG8gYmUgZ3JlYXRlciB0aGFuIDAsDQo+IG1kbmFt
ZShtZGRldikpOw0KIA0KV2l0aCB0aGlzIGZpeCwgbmM9MCBvciBmYz0wIHJldHVybnMgLTEsIHdo
aWNoIGhpdHMgdGhlIGBjb3BpZXMgPCAyYA0KY2hlY2sgYW5kIHByaW50cyB0aGUgZXhpc3Rpbmcg
d2FybmluZy4gQWRkaW5nIGFub3RoZXIgcHJfd2FybiBpbnNpZGUNCnNldHVwX2dlbygpIHdvdWxk
IGJlIGluY29uc2lzdGVudCB3aXRoIHRoZSBvdGhlciBgcmV0dXJuIC0xYCBwYXRocyBpbg0KdGhh
dCBmdW5jdGlvbiwgd2hpY2ggYWxsIHNpbGVudGx5IHJldHVybiAtMSBhbmQgbGV0IHRoZSBjYWxs
ZXIgcmVwb3J0Lg0KQWRkaW5nIGEgcHJfd2FybiBmb3IgdGhpcyBjYXNlIGFsb25lIHdvdWxkIGJl
IGluY29uc2lzdGVudDsgZG9pbmcgaXQNCnByb3Blcmx5IHdvdWxkIG1lYW4gYWRkaW5nIHdhcm5p
bmdzIHRvIGFsbCB0aGUgcmV0dXJuIC0xIHBhdGhzLCB3aGljaA0KaXMgYSBsYXJnZXIgY2hhbmdl
IGJldHRlciBkb25lIHNlcGFyYXRlbHkuDQoNClRoYW5rcywNCkp1bnJ1aSBMdW8NCg0K
