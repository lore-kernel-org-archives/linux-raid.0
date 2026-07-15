Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021119.outbound.protection.outlook.com [52.101.70.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C37936F415
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 02:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784083963; cv=fail; b=I9kzJsqLPEZDgJ7Ul8uamw5LrLPEIUyUqO2PyW2C52jVfr2vzmg99RfYvOvLFkb4OSf9aVpVlllLrUMzR4Jf9ppIfyjRsqTZUReGxeosQfAjSSjGwRqmoiSoPQUfBTiMQpw42BYuI9rkX7d4U1jbRWVMZ4BZOMYZk3bkuPM5Olo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784083963; c=relaxed/simple;
	bh=6IrUMgM55FPsK8jPmyBo3+IrWyVIdHRK9LOf0XLDRs8=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=fD+Jaj585PjewVdgJxyffIRiZtmDEDwP9Bs3UI12PaNV/2bcdnGn4LrbFUJanTFKVpGhyHprRL4isKA4KGnlQG7ccu860Ub0ooBT/6mfZRS3L1g0lU4UVIceOkU0iU3f8TEKd+e6tEH6Cx/oyQ2uz3rudqLa5JCGOYtwaCQyKO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl; spf=pass smtp.mailfrom=hunenet.nl; dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b=Z2XaN+Uu; arc=fail smtp.client-ip=52.101.70.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b="Z2XaN+Uu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rz+3fnUVfHzt3oMREDA6vsx59NFX1k+PE+gXH/WOX27I0ceN7dKopStYpsCelCEfNB8uzoSDhMpDiBz0erimE6Zlh7rWPUfwzAskGu/M/h/MNY5GLFVmcVVz7SfMFmDnr4oMolgI+CM+ykXi59sjnioxgUzkXuL+fEjbie9mWes+1OG4O2tThMBk3RCXfyGSmC+AgnDRNCt3hBbQEVopAyXsiVekoBH6ilyol2fHydJtL4/uAdffCE/GNiNa+5PeOe/+bmDA6s3BCEQMKl3CspmzWcaKJzzY0ciD78jOmtl8/6SEhCnqTytzhCvqL+Rg8bQO4cbOgnnLMZRD8Pe9jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IrUMgM55FPsK8jPmyBo3+IrWyVIdHRK9LOf0XLDRs8=;
 b=AJXJSnTTtrWgmX8xr7s3bVvJSPG3SmeFz+q/FhFvkNsV6zOhTq9koHs/G5iNxWoD8FOC2TCdhycYsc8kcsOgpeDyz3c8OJjJCmNMGxThWGjzv699wL7MwT8Ft91c1FLlyvFgVN0Ek7KJzBMadTa50n77VYXgc7k8ujFYExjJJDX6fEInRDi8sNBqgKvbkQALlvhNk+e3O2y6UE27BjE8GKuRWzizXttFJac2Thkcb0Qzqf0ggTP7wPkSnFvLrc15J0ORg0gd3UKlzt7hDyYg79QtiCVICCF0v1s/WXHBxO2Lq8nCCu+Gi9F4QYxyBg02B2vy0rpX5H2ooqsoKmhVeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hunenet.nl; dmarc=pass action=none header.from=hunenet.nl;
 dkim=pass header.d=hunenet.nl; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hunenet.nl;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IrUMgM55FPsK8jPmyBo3+IrWyVIdHRK9LOf0XLDRs8=;
 b=Z2XaN+UuSUobLm1zXxee7L4mtOQmP/xggyQXBQAWcoaiBCzFtPCBPDN1tPtDk2vX9lJftOHDuvfzN7xGedl5pZMBCFoH+l01iDCUc0Y/4IoD67qNowhPw6okGXh43tITzZmq/aC6O+o2Kp8ZrQzMX5dJhlA9HLFTDTbpm9J9Vv5BmM2oawXXqBRNu+Q/PZFlqsnkpLM3fuG7eEpekI9jd5XqndZN6KcXEBWXvWzw82PanqdaL7J0w6XzRxbsEKmQeHHSLSaw5OWjCFpFR3IRSujua/cQfWnq/0fc9xBuy3JtUH7EZDbyiBQJ7vsrpwpmZ1VnbFbmeTgga1pe45YIjA==
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com (2603:10a6:803:e8::33)
 by PAXPR05MB8062.eurprd05.prod.outlook.com (2603:10a6:102:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Wed, 15 Jul
 2026 02:52:36 +0000
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5]) by VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 02:52:36 +0000
From: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Subject: RFC: Read repair for md RAID1 after mirror read failures
Thread-Topic: Subject: RFC: Read repair for md RAID1 after mirror read
 failures
Thread-Index: AQHdFAT9j8au+wwOjUCGTza8C03iOA==
Date: Wed, 15 Jul 2026 02:52:35 +0000
Message-ID: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
Accept-Language: nl-NL, en-US
Content-Language: nl-NL
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hunenet.nl;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR05MB6144:EE_|PAXPR05MB8062:EE_
x-ms-office365-filtering-correlation-id: 0712e5d2-985f-4c1e-1e2e-08dee21c2024
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|38070700021|18002099003|56012099006;
x-microsoft-antispam-message-info:
 p9mYpOBW1WYdTOLN9wAhffcIptfqfaUVT6xNL2wZAwKvnQ5k48TPOWBZmCZW8hkvk5YOUFeBmICX/o/Tz7yWkSLrtEie2kvvfrWzOvif4nUuo2L6C/CoILO1XOn2+khrgPLrSzDwUnGpv+jCl54aUYMkdS2BavVlto/Z7/zakYnWHQ1llSrOI93f6dMxjehKCtv4tjpv6B0BdX6XldZaF6TS/tryEbFV4oDsrb4V2fAuyBu4C19i+uZ34yO7EnjG+7WOObQu3Zi6q5Czc5GcC4Xx9g7vj2JAarFoqfpapbYuwPBiVkZ4x44FuBLtdUavC5sqqDc+aVOi2OkNvqYDigLhPsutpfVHrJ2/Oam7W7LFTYtIJ8HN1pgTJdDMN5lm49lJHIJZnuMPdHVuWr+cTnKZW5TeqG2c4uCKtBHOaS3hqegaHussSw6GvqSbYmysiuHgAkngNA0fRrXxwLSQuOU70qopKTcGj9V5EhI5/SCuYtD7AE5gDSDsuqxm4UCgu52RpCrjfb/vkNhyImhC5M3XecdtdWxJD1FH7OSwGocAF3Kqo259tgwlEpl1VHLfDN0gVWEgTkfQ90JHaY7Wd8Myf5A/OhwZvEpfmRQlprcq6+fZuQsRlA/o3TSK4EpYmKLg07limEljI2K911Jz0DWVlVYNguB97yexsQ1oozjskYEcRHO55cMlajbe6kdyXGv98AxvbSSSQFilFevR/IEKhZKLm2tVheMYpGf97Sw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB6144.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(38070700021)(18002099003)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bzhQZitVQkVDUkJDSW1uUVFDa0YxVnZMalErN0RPejJYNU5MM2t2NG8rb3N5?=
 =?utf-8?B?eFVISnNxbyswSXh0R1hEZlF6Mzg1RjRZM3pwV1lYaDJqeW9scU9PTmF0SGFJ?=
 =?utf-8?B?QlU3T3NNVDU3SC91Wis0WXJWVUNpdk5nREtHM0NkVzB1am9GeldmQXYzTmJi?=
 =?utf-8?B?a3Q4M3JsNGxQMi9VSGs4WnJQL28vM1NwMm5YeHVScXpURlZZWTdTaitjNitH?=
 =?utf-8?B?RllOdGpQYTdWeldpNVNjbkFHbXd1a0VTS0pGTUFjOXM2eFZra2RSMjcwL3VL?=
 =?utf-8?B?L0dhdWx0U0Eva1Bkd3ZJQ001TFdreS8zZUNuWDFxb0tLdEczRzZuRmpLSzVz?=
 =?utf-8?B?M2FYMitlZjZWeG5PcGZxdWpXV1haVmRPU2Q4a1BEWkpXQkQ2SG5iayt0emtw?=
 =?utf-8?B?ZVFxNFR6eTFWZUwzUDBjdjlHTTN2WW5KT2pzRzg4TUFkMS95U1hTa0d5SDBV?=
 =?utf-8?B?ejRtRHN0M0ovWXhScFlUMm4vUDBRWUI5cUtJY2JnTDNGR1Rhbmw5Mk5LdU1E?=
 =?utf-8?B?eDN1NXAzUjNpMitYY0J0Tld4MkdGdWVwZ1pWNithS2E3M2NzZFBPWlFSNHZS?=
 =?utf-8?B?OUx6N3FheS9HWnJ3elVtN0ZhUXM0RnVuMTdjOUoxMnJ5ZHhjU29TeklRUjVq?=
 =?utf-8?B?NFpod2thMXhONENZSjFJbEJXR1hJTnZrSVZUU0JwRDBGdUJFUnBzZHNXU2lC?=
 =?utf-8?B?b0FKNlkrMnQ4T05FaU56Ny9pek1tUGJEMnh2b2FPLzlOdTZPMkl1bHhQamNy?=
 =?utf-8?B?TEJKb0VOR2xyR096ZUFBdmphZTVjSDNxaGxrUVo0UlpKRWtUZURhSDJrcEUz?=
 =?utf-8?B?Z2kxSk9VUS9KU3Z0SHVockNVa3pUbnk2RjhvU3U0d1l3UzRVdzNiTVh2N2RR?=
 =?utf-8?B?dU0yS29NNHc5N29HV1RsejRQSnY4OUZHN0hJRVl6ZEFDVmpHeWRzbXhUTzNq?=
 =?utf-8?B?OUdnYVJpTVBDWjNTRXIxMmpsYVBHdUJydmlNUVpIRHFTNmY1NkpVVjhTQmFI?=
 =?utf-8?B?NFpFODlsNURlZHFjUTJORzM0WnBQZGRGRThLaDRuYnVqNThsazRUOG4rckFN?=
 =?utf-8?B?Ky9UUS9FZkFLQmJNbVRjTnVPZkdlREw1ZU8zbnloNHBHQ0YwS1lnK2pSK0c0?=
 =?utf-8?B?bTJPYmZGK2ZYTG1QWElsdlozbWVza2pxc2tlWXNqbGQ4SVA4dC9hbzJkV2dF?=
 =?utf-8?B?S2dhdWhGbjlsSUZUVHBqTzJVc3FGSDFtYVVSSDN3dFo5UnZsMWdCRTNnRlo3?=
 =?utf-8?B?dENqVGYrWldFQS91cGVJYkxYcWo1azNYUHY5Wi80ZjdibWZBd0t1cmNhOC9p?=
 =?utf-8?B?NGlRR2d2dlJ1SHZHUC9OUlNtWHdzWlJIUkQ3dUlPQno2SkkydC9uR3ZLL0li?=
 =?utf-8?B?NjFFa0RyRm4zbS92V2ppVmFhRXRQbXNoY010VGM0WDZ4aWl0QnptcENBV2ZJ?=
 =?utf-8?B?bU92aXBHb3hxMUV5UFVGc1dhTHp4YUZjSFlaUWNyLzhaWGZSOHpMaWhaTTc0?=
 =?utf-8?B?SVZqMElMTnV2UlRaYU1DaENQOVVSWU90RTRmQS9UdUJpcDVCM0ErMC96MU9t?=
 =?utf-8?B?UktwYk5TZkVsWllocnpXQUZ1c0lMMDJhWjlsRGY0L1ZKKzUyRXRTcGd5REVy?=
 =?utf-8?B?LzM0U3F3WGN5M2dudlhOK1VLcGRGeTZKUytBV1pIWVJmTkt3Q0Jwek1nMWRz?=
 =?utf-8?B?VHdXWGRybWlqakNaVUN2WTRBVTQ1cXRxblNOVnJDYmhtZ1dSSzhJaWF4K2xa?=
 =?utf-8?B?cWV2b3JBY1VLVUZXbi9KdFVzSkd2RmZVNWVhaU1Rc2ZLZHhvc2NoNGpJRTcx?=
 =?utf-8?B?MkFMNVRXamxsNHdQbHkrZ3NkQXlpYnlKVTN4Wk9STjh1ekFrZ1IrL1lMRkV2?=
 =?utf-8?B?TnVsa0VNVVFBK2lvNzBiRGdOWVJxVGhVV00xS0lVemF5ZkpIRFV3N0UzUzJD?=
 =?utf-8?B?MFU1aGNsNTBkaG9YQmhPK2c2OUI1SU42RHczamswV0t2NFpFY3IyMCtrQ3lw?=
 =?utf-8?B?b3VjR2tJN1MydTF1bVZHaWYwMWtrWnAyUXBFV2FlbHlRRjkxUXhvWDZ4RFF6?=
 =?utf-8?B?cXlWVlpjYWtoSVp4cldxWERoaVZxVmZlT05xbUp2TVVURnpoendoTVdQdmV6?=
 =?utf-8?B?aVRrTWpPalNNMWhWaVVCMDhqUVlvbFZsNDFZY0c4OU4yVUV0aEZHN2lrYmo5?=
 =?utf-8?B?ZGYrbmMrTHJ5UVMrdHgwZndjTDRmU3ZuSUhHRzBmaU1TeGtxN1k4S3BKRE5M?=
 =?utf-8?B?NVAxVEZ6UUN0THE4Q0tjQjU2ZjRiMDNuMHZtdDczdkRDQTJ2VE1CbHpKaGhG?=
 =?utf-8?Q?Ul0wKbZaFyfViYp6J2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E10C616DE44654094C1D543E29A91BE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: hunenet.nl
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB6144.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0712e5d2-985f-4c1e-1e2e-08dee21c2024
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2026 02:52:35.8794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 887aa16f-e08f-4cfb-bc70-8f3f25a72a41
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ry2xznSq2Op+kn3k/z6okh1HpqloFx4ZUgYYNsQ4ZfD0KtjgBPMlvRUxCeUNWA95+LKOod6eBwfbxJYYCH5tGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8062

SGVsbG8gbGlzdCwNCg0KUmVjZW50bHkgSSBlbmNvdW50ZXJlZCBhbiBpbnRlcmVzdGluZyBmYWls
dXJlIG1vZGUgd2hpbGUgbWlncmF0aW5nIGRhdGEgDQpmcm9tIGFuIGFnaW5nIGJhY2t1cCBzeXN0
ZW0uDQoNClRoZSBzb3VyY2UgQnRyZnMgZmlsZXN5c3RlbSBzcGFubmVkIHNldmVyYWwgTFZNIGxv
Z2ljYWwgdm9sdW1lcywgZWFjaCANCmJhY2tlZCBieSBhbiBtZCBSQUlEMSBhcnJheS4gT25lIG9m
IHRoZXNlIGxvZ2ljYWwgdm9sdW1lcyByZXNpZGVkIG9uIGEgDQpkZWdyYWRlZCBSQUlEMSBhcnJh
eSwgc28gSSBhZGRlZCBhIG5ldyBsb2dpY2FsIHZvbHVtZSBvbiBhIG5ldyBSQUlEMSANCmFycmF5
IGFuZCBzdGFydGVkIG1pZ3JhdGluZyB0aGUgZGF0YSB1c2luZzoNCg0KYnRyZnMgZGV2aWNlIHJl
bW92ZQ0KDQpEdXJpbmcgdGhlIG1pZ3JhdGlvbiwgbWFueSByZWFkIHJlcXVlc3RzIGVuY291bnRl
cmVkIHVucmVjb3ZlcmFibGUgcmVhZCANCmVycm9ycyAoVU5DKSBvbiB0aGUgcmVtYWluaW5nIG1l
bWJlciBvZiB0aGUgZGVncmFkZWQgUkFJRDEgYXJyYXkuIFRoZSANCm1pZ3JhdGlvbiBjb250aW51
ZWQsIHdoaWNoIGlzIGV4YWN0bHkgd2hhdCBJIGhhZCBob3BlZCBmb3IsIHNpbmNlIG9ubHkgYSAN
CnNtYWxsIGZyYWN0aW9uIG9mIHRoZSBtZWRpYSBhcHBlYXJlZCB0byBiZSBhZmZlY3RlZC4NCg0K
VGhpcyBtYWRlIG1lIHdvbmRlciB3aGV0aGVyIG1kIFJBSUQxIGhhcywgb3IgaGFzIGV2ZXIgY29u
c2lkZXJlZCwgYSByZWFkIA0KcmVwYWlyIG1lY2hhbmlzbS4NCg0KQ29uc2lkZXIgdGhlIGZvbGxv
d2luZyBzaXR1YXRpb246DQoNCm1pcnJvciBBOg0KcmVhZCAtPiBVTkMNCg0KbWlycm9yIEI6DQpy
ZWFkIC0+IE9LDQoNCkR1cmluZyBhIFJBSUQxIHJlYWQgcmVxdWVzdCwgaWYgbWQgY2FuIHNhdGlz
ZnkgdGhlIHJlYWQgZnJvbSB0aGUgDQphbHRlcm5hdGUgbWlycm9yLCBubyBkYXRhIGlzIGxvc3Qu
IEhvd2V2ZXIsIHRoaXMgYWxzbyByZXByZXNlbnRzIGFuIA0Kb3Bwb3J0dW5pdHkgdG8gcmVwYWly
IHRoZSBkZWdyYWRlZCBjb3B5LiBPbmNlIGEgcmVhZCBoYXMgZmFpbGVkIG9uIG9uZSANCm1pcnJv
ciwgdGhlIGFycmF5IGhhcyBlZmZlY3RpdmVseSBsb3N0IGl0cyBhYmlsaXR5IHRvIHRvbGVyYXRl
IGEgc2Vjb25kIA0KcmVhZCBmYWlsdXJlIGZvciB0aGF0IGxvZ2ljYWwgYmxvY2suIFRoaXMgd2lu
ZG93IHBlcnNpc3RzIHVudGlsIHRoZSANCmFmZmVjdGVkIGJsb2NrIGlzIHJld3JpdHRlbiBieSBu
b3JtYWwgZmlsZXN5c3RlbSBhY3Rpdml0eSwgd2hpY2ggbWF5IA0KbmV2ZXIgaGFwcGVuIG9uIGNv
bGQgYXJjaGl2YWwgZGF0YS4gUmVwYWlyaW5nIHRoZSBkZWdyYWRlZCBjb3B5IA0KaW1tZWRpYXRl
bHkgbWF5IHJlc3RvcmUgZnVsbCByZWR1bmRhbmN5IHdoaWxlIGEgdmFsaWQgY29weSBpcyBzdGls
bCANCmF2YWlsYWJsZS4gV3JpdGluZyB0aGUgcmVjb3ZlcmVkIGJsb2NrIGJhY2sgdG8gdGhlIHRo
ZSBjb3JyZXNwb25kaW5nIA0KYmxvY2sgb24gdGhlIGZhaWxlZCBtaXJyb3Igd291bGQgZ2l2ZSB0
aGUgZHJpdmUgYW4gb3Bwb3J0dW5pdHkgdG8gDQpyZWNvdmVyIHRoYXQgbG9jYXRpb24sIGZvciBl
eGFtcGxlIGJ5IHN1Y2Nlc3NmdWxseSByZXdyaXRpbmcgdGhlIHNlY3RvciANCm9yIHJlbWFwcGlu
ZyBpdCBpZiB0aGUgd3JpdGUgY2Fubm90IGJlIHZlcmlmaWVkLg0KDQpJbiBvdGhlciB3b3Jkcywg
dGhlIGZpcnN0IHN1Y2Nlc3NmdWxseSByZWNvdmVyZWQgcmVhZCByZXF1ZXN0IGNvdWxkIA0KYXV0
b21hdGljYWxseSBiZWNvbWUgYSByZXBhaXIgb3Bwb3J0dW5pdHkuIFRoZSByZXBhaXIgY291bGQg
ZXZlbiBiZSANCnNjaGVkdWxlZCBhc3luY2hyb25vdXNseSwgc28gdGhlIHN1Y2Nlc3NmdWwgcmVh
ZCBpcyByZXR1cm5lZCBpbW1lZGlhdGVseSANCndoaWxlIHRoZSByZXdyaXRlIGlzIHBlcmZvcm1l
ZCBpbiB0aGUgYmFja2dyb3VuZC4gVW5saWtlIGEgcGVyaW9kaWMgDQpyZXN5bmMsIHRoaXMgcmVw
YWlyIHdvdWxkIGJlIGRyaXZlbiBieSBhbiBhY3R1YWwgcmVhZCBmYWlsdXJlLCBtYWtpbmcgaXQg
DQp0YXJnZXRlZCByYXRoZXIgdGhhbiByZXdyaXRpbmcgdGhlIGVudGlyZSBtaXJyb3IuDQoNCldp
dGggdG9kYXkncyAxOOKAkzI0IFRCIEhERHMgYW5kIGJhY2t1cC9hcmNoaXZlIHdvcmtsb2Fkcywg
d2hlcmUgZGF0YSBtYXkgDQpyZW1haW4gdW5jaGFuZ2VkIGZvciB5ZWFycywgbGF0ZW50IG1lZGlh
IGRlZ3JhZGF0aW9uIHNlZW1zIGluY3JlYXNpbmdseSANCnJlbGV2YW50LiBBIHN1Y2Nlc3NmdWwg
cmVhZCBmcm9tIHRoZSBhbHRlcm5hdGUgbWlycm9yIG1heSBiZSBvbmUgb2YgdGhlIA0KbGFzdCBv
cHBvcnR1bml0aWVzIHRvIHJlZnJlc2ggc3VjaCBhIHNlY3RvciBiZWZvcmUgaXQgYmVjb21lcyAN
CnBlcm1hbmVudGx5IHVucmVhZGFibGUuDQoNCk9uZSBhZHZhbnRhZ2Ugb2Ygc3VjaCBhbiBhcHBy
b2FjaCBpcyB0aGF0IGl0IGRvZXMgbm90IHJlcXVpcmUgbWQgdG8gDQpkZWNpZGUgYmV0d2VlbiB0
d28gY29uZmxpY3RpbmcgY29waWVzLiBPbmUgbWlycm9yIGhhcyBhbHJlYWR5IHJlcG9ydGVkIA0K
YW4gdW5yZWNvdmVyYWJsZSByZWFkIGVycm9yLCB3aGlsZSB0aGUgb3RoZXIgaGFzIHN1Y2Nlc3Nm
dWxseSANCnJlY29uc3RydWN0ZWQgdGhlIHJlcXVlc3RlZCBibG9jay4gVGhlIHByb3Bvc2FsIG9u
bHkgYXBwbGllcyB0byB0aGlzIA0Kc3BlY2lmaWMgY2FzZS4NCg0KSGFzIHRoaXMgaWRlYSBiZWVu
IGRpc2N1c3NlZCBiZWZvcmUsIG9yIGlzIHRoZXJlIGEgcmVhc29uIHdoeSBtZCANCmRlbGliZXJh
dGVseSBhdm9pZHMgdGhpcyB0eXBlIG9mIHJlYWQgcmVwYWlyPw0KDQpSZWdhcmRzLA0KDQpEaW9u
IEthbnQNCg==
