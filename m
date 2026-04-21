Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010060.outbound.protection.outlook.com [40.93.198.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB18C26B2DA
	for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 22:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776810740; cv=fail; b=DyMtSM0sX8CCyPQmI3PFOA5VO5CnUKQkoLDHqOjAJAReuxcOiU5P++n7jCe5xvFxuoBo91Q/z65BiSwDVIlyJzipN8/ThLSuX0oS355EyKd+YfwFIChnOOXDqGdJte5vaaGeFhdpDgYyY6V0Xseot/1NThPDtcxgGSnxbF55qQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776810740; c=relaxed/simple;
	bh=P/z/Cq7f3EnRh0h6MxzhpQB0PunRiMZ9MCcYxBhqtVM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OYKuEDstR9gHcu1bMbhQ9IeL4zPRt8PkqhaEQ8G+pwKMBQGJei0bimX5B3keisEPtDo5IMOiGuWMLuG8Q/KNt+guQD2YLHy0uizcVL0vxRLhbDbGmyUvW+lA28kgXV6cPHIX+F25CjJZ6jndoNfPFkGgJZFpkoZQKsdjBjjzToY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hyxUI5rh; arc=fail smtp.client-ip=40.93.198.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hyxUI5rh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uCfIPWPAo0Y6j8EJKjyGjQIwVBkUsgJjEKt2NpxrUhOntD+s50w3IDOxoJ2jQ0HpPp3uC6g+5AbUlJ287cn22IMrIAlQ5YVK9UczgzQSbhMdLzq6a9cgth/iKPsEu6VbTyjHB7RJwqc6ss7FyVrPde91KSJevYJmG19pjTGS3GtpStiY0daIqIkiHbtgq88QwvmCQvPgW4X4+tUyNoFnpZBHaIprtHlR79FAzhYbXZlVxOGcBhM4zlWRfhlnelCUUA7o91iWDetc6tZe37CGmmdlK9PUvceyQB+9s3xlP/FK+lvl2c4v8ehoA3MveE0Qme5tdVZxZ/9ldP3DW3sTLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/z/Cq7f3EnRh0h6MxzhpQB0PunRiMZ9MCcYxBhqtVM=;
 b=rukI1FcaAcIrz1Yxjo+PRCPHPDoN5gZ9liEtdIoWILwPd+UiSPwXxBvLA7+5BktOKWjNfaXGMRt1wEJHTjBMxkTeCDKusx1VsKSaAMEFrrthlkSL6q4mmp+uDC2yxvrwr6p1D4z6piThXbEZdRk9SGfOgH2Fw8G+B7TYV75SMd1hQ7vinevvHG++vSg160TB66ym0sYgJ32fi3Glw923yc7hV+9YXqbX+Y/31TpgSvKAJaTbdm2a6rlcrza61gzyYYPHcNpeQASuBvBKHSq6YTWyWm4kTfK2qGgCBk+3jIj/y3zAb1xeMey/FH0XcKKfax1ZQZXcmSmP1q1ho2fm0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/z/Cq7f3EnRh0h6MxzhpQB0PunRiMZ9MCcYxBhqtVM=;
 b=hyxUI5rhuTGKG+ZjHSC0JhNHxN2KNP5sZC/siJsEEJUBoY0BS4PoicjO40dZFUoQQqNz0r40QR80iqbnAgO1Smyxdq5prlvQsBKaqWNXADiIE+YAHkK0ojSkJog6ALJIqVHp4FAVmeTX6DJuO4t+O4NOnyjn+NmtQI/+Ap/vGlXtPVjSD26p0eFYGxEPG1KcsRzSKSM1qq6S1nrxCJwH2aMDuKUxHkzqKMm1aO8TmpE4WpGwXkyuD3274xzT4iCzJwu2r+S8K8UOWW8o3aAgE0teULVqvdeoJ953lQn7YUhHCJyxL84kPrT2ALv+EpTIf+mM3ChFRCD58h53/4O2+A==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.15; Tue, 21 Apr
 2026 22:32:14 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008%6]) with mapi id 15.20.9846.016; Tue, 21 Apr 2026
 22:32:14 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com"
	<yukuai@fnnas.com>, "linan122@huawei.com" <linan122@huawei.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"hch@lst.de" <hch@lst.de>
CC: Chaitanya Kulkarni <chaitanyak@nvidia.com>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Kiran Modukuri <kmodukuri@nvidia.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>
Subject: Re: [PATCH V3 0/2] md/nvme: Enable PCI P2PDMA support for RAID0 and
 NVMe Multipath
Thread-Topic: [PATCH V3 0/2] md/nvme: Enable PCI P2PDMA support for RAID0 and
 NVMe Multipath
Thread-Index: AQHczefMw/2L6wnrAEunHJMvgSqt97XqIZaA
Date: Tue, 21 Apr 2026 22:32:14 +0000
Message-ID: <3c4d2714-cbd4-40ce-b845-be9a02561d71@nvidia.com>
References: <20260416212633.72650-1-kch@nvidia.com>
In-Reply-To: <20260416212633.72650-1-kch@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DS7PR12MB6214:EE_
x-ms-office365-filtering-correlation-id: 3ea60c21-d965-4cac-93cf-08de9ff5d626
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|18002099003|38070700021|22082099003|56012099003;
x-microsoft-antispam-message-info:
 WcrH4TUUf/eDEuETUa29F83Mqv1PLRJyF572P4vq1D170IK+GstTpl+BKGWLg1yZCmlWjkfVYYZIlf6qN7iwl1nRT5fask9KksV4ZGi6YyNrvmGOej5TTZYhX6yJA/X6synYjl6B4dE9o5RXhz7n7KmKy421d9Px2+FlcYr53TXfMrjePg70IT780zzg7tjfmMTLH1di/roFthb9gpI5KzHJGRj3klazx4fvwIpCDb1UsEAMfMnRgkKApltF3AkdGlnnKEC0nEXOpjSGZeCnX88QdyjGxAHEigbunngj2Ydy6nJFzouYJp1ybLDTTlJ2dVmlZaDCSqx0qsFupMotZYF/rBUqAW/emDuBH6PhgsGGCBfUkVpXLE3hWcRHpQC9cHA6GVYw2W3018iNqSV9RZyEYnIdZOcnRe17x4QLvJV3J7gfsVyNMV7eOkJrqRJDrNiDEHv3Y7a24vvfRRHaxYYsPTcxIcQkBA/OSE7yqPNh3IPMUdRGtQm0Is0ixTeCxqVWW25+zMZMRcW0Z66NU/xQIKnzetcTLiirvRiEqU1HAeqoNOf1a4JMuX3v7f5NTEBmGFx+7C/unXenxzI8+q5K64niJE/8tPHR5jIkzVZO+Whc4v0cdyVfJFSD5jHwRuDbDeGT08LewZtP0Rw3n1y1+OgHH5vWaOjJFS+pSCqc548kN4EFtq8v2kCJqiZIck1i+xH6DPXQWtK1ow/va74rvLllE2bi8ntepW/KkM99wvCgUg5e7DNGFb5n5GZlDGNWgoOTXsRuY8v4lIHXmcsekWmEovKtvuoKQcShQ1M=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(18002099003)(38070700021)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RUJXb0JsWmF4dmRTVUZFOEVYeUNIajNSVFJ4U2RzRmUwY3k1azZ1T3kvR0pI?=
 =?utf-8?B?cnEycEt0OXRrNS85Zk9Sa3FrQkVvNjZSNE1laWxZY2tScDFjbG5IeXRQWk1Q?=
 =?utf-8?B?aHVERUpyeVB0Q0tCZVlmWndPODJ4RWhIczNSTm1Ka1drbTRaWndVcjcySkRz?=
 =?utf-8?B?amZrMnhzQVJBOVlrV09ZelZMRkN5ZndxeExNZWF3ZnhuY1o2UktSRlZWY3o3?=
 =?utf-8?B?ZXZJdHIxQjZ2OWVCRVNFVjRSQzFUc3cxMG91T3N5d1gwalRobXVrZ0IzalFa?=
 =?utf-8?B?TnFhSUVhazMyYnJ3NjBkZzlsaHcwVFlQbUxoUXRzYnZaTUhLSUg1dWN2Y3JF?=
 =?utf-8?B?Z2FVRHptOFV5bWFPN29Hc1RDSDRzRklGKytoSlhHTTFOU1gyam9hU3BZUWFK?=
 =?utf-8?B?R29vMDNUQU0vbTZ6dkVoTCtsQWpYOWpxdHdaT1hlblc1WUxMSC9WUUtDR0s3?=
 =?utf-8?B?TUtIUHpyVVMwdHZucmQ2d0VTMHloM3piUGc1WXB5eHYrM0lJTUdUNWhWdGxL?=
 =?utf-8?B?VXg1UjVDT3NnUUwwaWNBaVBxYkFCYUNTbDNsZ09JeHFkSjh4OE1jOGZZb0dT?=
 =?utf-8?B?UTRMMy9TMFhHSmthVi9VZFhDYjhrMGdHVklPczFGSVNLWExIT2hhSW4vOEVQ?=
 =?utf-8?B?ODlnamlLUFViZFQwQ1RTSS83TG9FK2dtNGoyZVJZQ1N6V2hKenRRSmhpTVVp?=
 =?utf-8?B?WUtrVXRRV29LYUNIUFlNMlBLQlR6OFBuWUt5dlcvRHgxY09uaVdhT1BrK0Vt?=
 =?utf-8?B?VEtWYnhiWDF2YU9tU0dBQWt2RVJrZDYvaE1EZm9kSFRSajV6V3lkdVZCaTJp?=
 =?utf-8?B?Q3AvK1Y0ZnRLSFUrS0M4RmtPVVdTZEZlcUdEeUd4emxhWDNzN2x5TUM0L3Vv?=
 =?utf-8?B?UnczOThGb3k5ZC9CUWxvWDVKVnBXcW10a0cydjYvVERudHEwMkNpcTlRdTZp?=
 =?utf-8?B?SWRJcVZzY0tmWXJFaURQV1NxVjNlNjN0SlRleTVRQ21MVnE4Kzh4YlRHU3lO?=
 =?utf-8?B?NzUzbTVjZVNsdzZRS0lTK1ZpRFluaTRwQUQ5a0xYaFVDbGlEclNlME5xZkJI?=
 =?utf-8?B?WXVacnRXYng3WDE3ejJ5bm1HRHlmeEdRNC80Q21sWi9aMFNEcS9keGlYSUpq?=
 =?utf-8?B?NHl3bmFpcm54VXo0d0g0U3FIaVFBK1N6U2FRSkVNOTVXSGhKUTFQM3VsOE9N?=
 =?utf-8?B?WmhIbFhoUEtRYWkxVnJPczFqR0Y0YzR6SHVBZnpxTWRzZzdFYjZtcWx6RE5k?=
 =?utf-8?B?WUxTODFmWEY4YjQva1RRUWRLZDBLVmtiVEtLZlMrVGtRb2M3T2hVU1FQem1q?=
 =?utf-8?B?c3U1KzNiaWExVE5UcnpZd3dZbHFDellJRUczZjB0c1pGeHA3ZHhaNjRIWlNo?=
 =?utf-8?B?akhaZDdBaW9ZNy90WmRwRnFremYrblQxT3dJYjlDMUg4YXJTUkVac0FqbEFU?=
 =?utf-8?B?R1lLUjQyNlVLSEJ2VndHTjhmVFB0SVZLYk9MdmcyWkkrcVcvUEMrOEl2OHZM?=
 =?utf-8?B?Zi8zZXBERmlIL0NlZmZKeFFZaWEyZWlGYUZVNTZGMGRUOGhRTFd2aUtmVUs1?=
 =?utf-8?B?Wk9mRVZFU2ZKNlhzOHVURFAveVBLbWFZYUc4d0h1bXk3SU9HOVJPU1pNSEpF?=
 =?utf-8?B?aGZZSml5Y3pGM09tblFzZjlJS3E3b09JMktpRGlSVVVKSUQ2QUpGclpHc1Fm?=
 =?utf-8?B?MFVGNllnWmNIajZ6emExZFJDQUxUZkdacFNPbExDRFBvK2lpZEl4MnRpNVd0?=
 =?utf-8?B?R0F1bzdYakZxTzQ3ejFjTkRxQ0pZWitvRExoT2FTd0xZTHVmdSszUEpYemFM?=
 =?utf-8?B?QklNWkRuUUxkY2g0Zzd4U1NyTzNNbklDUXI0L1FEYzJOMU1TejJMQzZtS2Jm?=
 =?utf-8?B?L0czK0NkdkZqR0xET0dsQVlJb2RJV3BKQUtvbGNvTWQ5RlN6Y3dzVHRUZ2Nk?=
 =?utf-8?B?Mnp4TjRXWWRNZW5WNHI2NXpUU2FxUzFENHlYc1JkeHowUmdhOW4wSWF2WGZZ?=
 =?utf-8?B?T2VGTU80a1RvcXgrM29QbWhXalZCWFZGOXd1a21mbVVVUlRNOHFXN3pSanNh?=
 =?utf-8?B?NGZFdk1QQzlCSkk1aG5YYmpYRjBaVloxbWIvbG1TaVl2akdJdDZXSGtCUlNY?=
 =?utf-8?B?M1EweHhtakVNQUc5a1RobDd3TCtuU2tNRmVtdDc1aEtDVmROWVkxY0NIQUFH?=
 =?utf-8?B?b1dSRWllMGh6d2lRUE1SdnplK3hWWU83MXJua0MxTWFuT1ZDWm43NTJxL29L?=
 =?utf-8?B?RUZmMWcwcGJoeEhhRWg2M1RGeVgxb0VtbjlpUUJBZncvZmthaDJQVThQcElO?=
 =?utf-8?B?SDBYU2RhWnRlek1IZlA2eGlrY0JvdFZOcWdjejNkbFhHRXIzckEwUXNuMFgv?=
 =?utf-8?Q?/mvouHeffXgK4El29Z2fIYy3BjHelNkZT/mCyL526e4P9?=
x-ms-exchange-antispam-messagedata-1: Z9BN/S/vvKiJLQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDE7DD2E47A66A44BC05FC9B6BC1B9D2@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ea60c21-d965-4cac-93cf-08de9ff5d626
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2026 22:32:14.1424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SR1cWjGjjcqj3gpGmsKj/r9RRmSm0NwWhab+UdgUiHubOxkaywW3/FP1Jbp4wWzhUbltmSnRwFnvk9xi14gvaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6214

T24gNC8xNi8yNiAxNDoyNiwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOg0KPiBIaSwNCj4NCj4g
VGhpcyBwYXRjaCBzZXJpZXMgZXh0ZW5kcyBQQ0kgcGVlci10by1wZWVyIERNQSAoUDJQRE1BKSBz
dXBwb3J0IHRvIGVuYWJsZQ0KPiBkaXJlY3QgZGF0YSB0cmFuc2ZlcnMgYmV0d2VlbiBQQ0llIGRl
dmljZXMgdGhyb3VnaCBSQUlEIGFuZCBOVk1lIG11bHRpcGF0aA0KPiBibG9jayBsYXllcnMuDQo+
DQo+IEN1cnJlbnQgTGludXgga2VybmVsIFAyUERNQSBpbmZyYXN0cnVjdHVyZSBzdXBwb3J0cyBk
aXJlY3QgcGVlci10by1wZWVyDQo+IHRyYW5zZmVycywgYnV0IHRoaXMgc3VwcG9ydCBpcyBub3Qg
cHJvcGFnYXRlZCB0aHJvdWdoIGNlcnRhaW4gc3RvcmFnZQ0KPiBzdGFja3MgbGlrZSBNRCBSQUlE
IGFuZCBOVk1lIG11bHRpcGF0aC4gVGhpcyBhZGRzIHR3byBwYXRjaGVzIGZvcg0KPiBNRCBSQUlE
IDAvMS8xMCBhbmQgTlZNZSB0byBwcm9wb2dhdGUgUDJQRE1BIHN1cHBvcnQgdGhyb3VnaCB0aGUN
Cj4gc3RvcmFnZSBzdGFjay4NCj4NCj4gQWxsIGZvdXIgdGVzdCBzY2VuYXJpb3MgZGVtb25zdHJh
dGUgdGhhdCBQMlBETUEgY2FwYWJpbGl0aWVzIGFyZSBjb3JyZWN0bHkNCj4gcHJvcGFnYXRlZCB0
aHJvdWdoIGJvdGggdGhlIE1EIFJBSUQgbGF5ZXIgKHBhdGNoIDEvMikgYW5kIE5WTWUgbXVsdGlw
YXRoDQo+IGxheWVyIChwYXRjaCAyLzIpLiBEaXJlY3QgcGVlci10by1wZWVyIHRyYW5zZmVycyBj
b21wbGV0ZSBzdWNjZXNzZnVsbHkgd2l0aA0KPiBmdWxsIGRhdGEgaW50ZWdyaXR5IHZlcmlmaWNh
dGlvbiwgY29uZmlybWluZyB0aGF0Og0KPg0KPiAxLiBSQUlEIGRldmljZXMgcHJvcGVybHkgaW5o
ZXJpdCBQMlBETUEgY2FwYWJpbGl0eSBmcm9tIG1lbWJlciBkZXZpY2VzDQo+IDIuIE5WTWUgbXVs
dGlwYXRoIGRldmljZXMgY29ycmVjdGx5IGV4cG9zZSBQMlBETUEgc3VwcG9ydA0KPiAzLiBQMlAg
bWVtb3J5IGJ1ZmZlcnMgY2FuIGJlIHVzZWQgZm9yIHRyYW5zZmVycyBpbnZvbHZpbmcgYm90aCB0
eXBlcw0KPiA0LiBEYXRhIGludGVncml0eSBpcyBtYWludGFpbmVkIGFjcm9zcyBhbGwgdHJhbnNm
ZXIgY29tYmluYXRpb25zDQo+DQo+IEkndmUgYWRkZWQgdGhlIHBhdGNoIHNwZWNpZmljIHRlc3Rz
IGFuZCBibGt0ZXN0IGxvZyBhcyB3ZWxsIGF0IHRoZSBlbmQuDQo+DQo+IFJlcG86LQ0KPg0KPiBn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYXhib2UvbGludXgu
Z2l0DQo+DQo+IEJyYW5jaCBIRUFEOi0NCj4NCj4gY29tbWl0IDg4YTU3ZTE1ODYxOTk3ZGQ2ZmE5
ODE1NGFkMDg3Zjc4MzFiYmVhZDEgKG9yaWdpbi9mb3ItbmV4dCkNCj4gTWVyZ2U6IDgxYTBhMmU0
ZTUzNSAzNjQ0NmRlMGMzMGMNCj4gQXV0aG9yOiBKZW5zIEF4Ym9lPGF4Ym9lQGtlcm5lbC5kaz4N
Cj4gRGF0ZTogICBGcmkgQXByIDEwIDA3OjAyOjQyIDIwMjYgLTA2MDANCj4NCj4gICAgICBNZXJn
ZSBicmFuY2ggJ2Zvci03LjEvYmxvY2snIGludG8gZm9yLW5leHQNCj4NCj4gICAgICAqIGZvci03
LjEvYmxvY2s6DQo+ICAgICAgICB1YmxrOiBmaXggdGF1dG9sb2dpY2FsIGNvbXBhcmlzb24gd2Fy
bmluZyBpbiB1YmxrX2N0cmxfcmVnX2J1Zg0KPiAtY2sNCj4NCj4gQ2hhbmdlcyBmcm9tIFYyOi0N
Cj4NCj4gMS4gVW5jb25kaXRpb25hbGx5IHNldCB0aGUgQkxLX0ZFQVRfUENJX1AyUERNQSBmb3Ig
bWQgYW5kIG52bWUgbXVsdGlwYXRoLg0KPiAgICAgKENocmlzdG9waCkNCj4gMi4gQWRkIGEgcHJl
cCBwYXRjaCB0byBkaWFibGUgQkxLX0ZFQVRfUENJX1AyUERNQSBpbiB0aGUgYmxrX3N0YWNrX2xp
bWl0KCkuDQo+ICAgICAoY2hyaXN0b3BoKQ0KPg0KPiBDaGFuZ2VzIGZyb20gVjE6LQ0KPiAtIFVw
ZGF0ZSBwYXRjaCAxIHRvIGV4cGxpY2l0bHkgc3VwcG9ydCBNRCBSQUlEIDAvMS8xMC4NCj4gLSBG
aXggc2lnbm9mZiBjaGFpbiBvcmRlciBmb3IgcGF0Y2ggMi4NCj4gLSBDbGVhciBCTEtfRkVBVF9Q
Q0lfUDJQRE1BIGluIG52bWVfbXBhdGhfYWRkX2Rpc2soKSB3aGVuIGEgbmV3bHkNCj4gICAgYWRk
ZWQgcGF0aCBkb2VzIG5vdCBzdXBwb3J0IGl0LCB0byBoYW5kbGUgbXVsdGlwYXRoIGFjcm9zcyBk
aWZmZXJlbnQNCj4gICAgdHJhbnNwb3J0cy4NCj4gLSBBZGQgbnZtZSBtdWx0aXBhdGggdGVzdCBs
b2cgZm9yIG1peGVkIHRyYW5zcG9ydCBUQ1AgYW5kIFBDSWUuDQo+DQo+IENoYWl0YW55YSBLdWxr
YXJuaSAoMSk6DQo+ICAgIGJsb2NrOiBjbGVhciBCTEtfRkVBVF9QQ0lfUDJQRE1BIGluIGJsa19z
dGFja19saW1pdHMoKSBmb3INCj4gICAgICBub24tc3VwcG9ydGluZyBkZXZpY2VzDQo+DQo+IEtp
cmFuIEt1bWFyIE1vZHVrdXJpICgyKToNCj4gICAgbWQ6IHByb3BhZ2F0ZSBCTEtfRkVBVF9QQ0lf
UDJQRE1BIGZyb20gbWVtYmVyIGRldmljZXMgdG8gUkFJRCBkZXZpY2UNCj4gICAgbnZtZS1tdWx0
aXBhdGg6IGVuYWJsZSBQQ0kgUDJQRE1BIGZvciBtdWx0aXBhdGggZGV2aWNlcw0KPg0KPiAgIGJs
b2NrL2Jsay1zZXR0aW5ncy5jICAgICAgICAgIHwgMiArKw0KPiAgIGRyaXZlcnMvbWQvcmFpZDAu
YyAgICAgICAgICAgIHwgMSArDQo+ICAgZHJpdmVycy9tZC9yYWlkMS5jICAgICAgICAgICAgfCAx
ICsNCj4gICBkcml2ZXJzL21kL3JhaWQxMC5jICAgICAgICAgICB8IDEgKw0KPiAgIGRyaXZlcnMv
bnZtZS9ob3N0L211bHRpcGF0aC5jIHwgMiArLQ0KPiAgIDUgZmlsZXMgY2hhbmdlZCwgNiBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCklmIHRoZXJlIGlzIG5vIG9iamVjdGlvbiBpcyBp
dCBwb3NzaWJsZSB0byBtZXJnZSB0aGlzIHZpYQ0KbGludXgtYmxvY2svZm9yLW5leHQgPw0KDQot
Y2sNCg0KDQo=
