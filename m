Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.91
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793190714;
	b=KTTpKCCAmVFhzIsqfdNHhtcRMWUySLp7nFF4TmRnRwUrTLGOf1arb8W+86yu2P1Oxiiq
	 r+ORav4QNPWnwnTPj/j3wP2vAYc4FGs4FOOyvKl8hhnrIxZiwsjaWTFgrBObiHtD2qnba
	 kIKadaxig+tsgGWlGZCYQ+RhcBb+n+uk2FYcZHAIvBAvgkyM5c1CdDvCKsbrI9nJsU5c8
	 kUjDXBSPvKNl2AnpSB93LsURFJh6nnnFPa/kigcyU66O+NmRnbQ+XR+fZD+LFczy5NDBB
	 fpHz45ZV+BwkaKddt4hfx6UY+hYBYGNZcsCid2dzdHKw0uivH6IAK3m0ZR+Ot6rsyZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190714;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-gt-tenant:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=DNZLcrYHm8E7p/toAs2Nf5U5OR2x8ynWDSvKrE5GXBU=;
	b=pvdgnUgru1+6VOiuDMpCGOi14/r6kXriP/1kg6LaRbF9g5tU6Lhk4zhmhBuwYtuHnUyS
	 o/mpMC01ZD05Dztjqnqg/EedtoKaCbVH3ks9LCyIyvpqlC4RdJikDuDNmWAcKAToUJrf8
	 WP00/78v/NRVAaX0Lf7RWj9+Ht5LrxBY5i9I1R8Un1btfUAznN8OriXAoLkKpJYS8haet
	 FlFqsfHCQeV67TDiXlJSYub+rlBj+OUyFM4MpNA2I4DVbLvst+g0trm6lqa9WfYN2yzOI
	 Vw3kZPlXwpgZGIilvBDmcGqwf16cpi5r3wtEUs0CCt2ol+pDzy/Hsjyj0EZiNYHsMZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gatech.edu;
	spf=pass smtp.mailfrom=gatech.edu;
	dkim=pass header.d=gatech.edu header.i=@gatech.edu header.a=rsa-sha256 header.s=selector2 header.b=nIYF3ddb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.91
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023091.outbound.protection.outlook.com [40.93.201.91])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A89606A31A;
	Wed, 28 Oct 2026 12:31:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3A89606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gatech.edu header.i=@gatech.edu header.a=rsa-sha256 header.s=selector2 header.b=nIYF3ddb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LyaybgN1chb6EAtcSpOLWF/F0swuy0MriN3fOvW3TVGoWBaGQskdu/HDQ4e3GpMdsB9Gka2C52MiIQ4r3R/v8uL8XfHo8BQZ7sV0uK+zzj7r3vAVU1YcCU6KiJGR8oIl3N7PycBiLHl4C2XDBOimV41btKVgTXKMyfIPcIglPDrxKtqEjlk3fyAGRGT1VaEcGIGGKorKjjowHjNA6Z4QSfbVH5mUOMI2QmoADN3Rwt8WTtwOcTEFIjqg51VU5LS/IIQgCAhvawWGj0/au6vHpnROvW40JvfGcfAFX00/KqeXRC/s/TRK0mJlPNCzoJDm46ro6V+UnFf2p1Mou0c96w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNZLcrYHm8E7p/toAs2Nf5U5OR2x8ynWDSvKrE5GXBU=;
 b=N0kZw8JpIo/I7+ua0IFsx9QOmqXc7IAyzb07r8vHqQPYqiyW17zjbdX2dTAU26/yqaL9r7kLLcCfwmHNkX8JtadI2pLOmQFsJAJI4jMRANqZ1YsaH3feLXAFmtPE8z4/0iZdDuZ0vIeaxgFYuVa3Wik8yIZBL0dA5qf+99RApo+AmguQg1LuwvKKnl/TA66RMcij2Tl2VKvn2SsuorLkfGTdSjwgVFVFjpww4rrjrZfM5JJnsnuu2OPFmTeWsI69DGMKoCKIaei0KwEYC9oiC0LkvcXL0VN138HgG4ESy/6lgI0BJdFNQP5moPCr1Qcli6aLuW/k3BU0OBar/XcNOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNZLcrYHm8E7p/toAs2Nf5U5OR2x8ynWDSvKrE5GXBU=;
 b=nIYF3ddbneKunDMF1jSrp2u5/uzPMA24Y0HDamUOpGMw46yS068JhRtPD8ipgh2nyoySCmn+MbAOIfI9OonqP/MhcjMCygldKs/A8KbXZKGy6q8ww4NuRApDZrK4CpM0Py0xtFEOwg0NVjZiBdyIlkN19xZ7q0iM7Sa7c/dg6cTF2wrSKeAH4E8u+aEj1bz3CcN0RF7rxZ1K603VnW4Li4DwrBseDEinHRb2LAQa27jNHOvQUwqfnj2vTc5P/LQEwlASgAiJv4N67jl5sxGr6H5GtrpbcpdNR6ukoOjvMliEnL1eVZMLslTOn2LFPbBt57Yy9K1ktYNX71wBH8NTWA==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by MW5PR07MB9407.namprd07.prod.outlook.com (2603:10b6:303:1ce::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 12:31:51 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0569.007; Wed, 28 Oct 2026
 12:31:50 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>
CC: "song@kernel.org" <song@kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	"magiclinan@didiglobal.com" <magiclinan@didiglobal.com>, "xiao@kernel.org"
	<xiao@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] md: add a control device for array management
Thread-Topic: [RFC PATCH v4 0/4] md: add a control device for array management
Thread-Index: AQHdXOZyexdWiYnXCUOsbLEcfqNrA7cSv38AgAA3T4A=
Date: Wed, 28 Oct 2026 12:31:50 +0000
Message-ID: <m28q3i2eh6.fsf@gmail.com>
References: <20261015204640.1184848-1-abd.masalkhi@gatech.edu>
 <20261028101352.272d7d37@kernel.org>
In-Reply-To: <20261028101352.272d7d37@kernel.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gatech.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR07MB9958:EE_|MW5PR07MB9407:EE_
x-ms-office365-filtering-correlation-id: c802f96c-00cb-487d-3436-08df34ef70bf
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|786006|38070700021|4143699003|11063799006|56012099006|261021121427099003|10067099003|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info:
 4rJ2z+B72Au3EU623NA2czrfQkpYUuLEqMh9DtTK9y32mlDUBrtaAUym3uXXoN8r4ARd3eyTBLvQzLnesRceZZusPae5ksdaKNyiBT/az/6KN9CYarppq6gDCx1QKhnex0DrAcaS8j0r48rbLvc10v3xGbuvRJ5Sy2Rfjj/jHA3TU4QSKVbrUcpBIpv4hrMRV+O0fVlGunLuT92Eg4euctrWV9aHx9HNai9QNsl6LEulcqC8T1DAxyoBpfUv9Zgb7l+c1HKl3lFtzL+WH1kn5lok+qSrpi7xEoaye2ALd68bbjOV66CcghZtCJtKq77PYb6jQ1nDUQLXdXDcWOcDIIJ4nvMpQ7VUpyzZJOxvMo/7CWMYXipQVWDmnezYTvxCX/3ttxGCCfvFRFSaoxLxpZX5eb0vwCykeJ14BPQqI1sEsJgwY/s0bbTusFiFacU2DGuGfsldOqmfi5G50oE88WwekIeV+Ya3SzB94MBH0GalQaQWrDyHaWgC9g8QyU9td7uVxrLK8NFevMy5earseDg5sPD5pJOtr5Cei0RGtuhGzFgo0Rrcm9Ai/zSPvIgKHy2qNMAKUV+qiUPp/vy93DW/97q4axlJRKvV9thSVU2vBmKwYsmOhOesW1HFln3cketVvtb5RI+q8h/cfvey/NI2QOokVvOrZZOxoWVV1Zg36JF0tTWO5KAvalcaruCVbx63GqJ7OoE/d+EbfV02V4NXe7Yb7baCSkSkUV56j84=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(786006)(38070700021)(4143699003)(11063799006)(56012099006)(261021121427099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?enZHSW82SWhrRXkzd0FaOFNHQVFqSDcwTG1iMTRTVE00aHhnRG5qZTlWTkdP?=
 =?utf-8?B?QVVScTNaWjNxRkttbHA4dmlSeC9FTjNpblJNQXFzekJrZjJPVmhUK0RET29n?=
 =?utf-8?B?OHcxQytEdkJ5Vm1uOWFyRXhZUkRuR21YbWF3ZzBTNDlQYnpMS0EyY1RVWDVO?=
 =?utf-8?B?SURZbXc1WW4wTk8vMDhTRmZSOXlXejE1NHVrZmF6NXNUTkl1dkZCanJNNWZT?=
 =?utf-8?B?bmVDbE5NY1oweVRJL1MyaUJicGEwdTlMVVpaaWtOdVNCb2hRM050MFRyRnpk?=
 =?utf-8?B?K1FPVkRxMHFYMUhKb25IZFE1bG9pSU9iTXVwdGxvdXpIN2JYZWpiYkVYSzF1?=
 =?utf-8?B?T1RPOGQ4blJBVzdWQjBQR1Z6UWoxVFVqM0wwNGdpU2Uwa2JhSFNvTDM5RWtZ?=
 =?utf-8?B?ZTVmWUx6cFhITnZrcXFHanUzS0RDeE9jQWJVaDNQQjcwTThheUVqbzVmSit6?=
 =?utf-8?B?RHlQeVBKOHdiOUxTWU44UzhWN2Q0clErTjNTRHhaekZwSjNJeGhtSlJraU9o?=
 =?utf-8?B?aU9paUpNT2kwaWwxdVlaa3F6ZmRkd1ZFWHdTbkNrVnF2SEpyN1pOOVlHYUdx?=
 =?utf-8?B?bUxPYUtPbDVZMkRvemNzUVdzemVBb09SOWJneUgyN1h2OVZBd0tjK1ZrRk96?=
 =?utf-8?B?RFNjOEc2NGlDZUdHU1JjWGhtVnRtZ04vUlRrNHpiOVcwaysrWndyQ29mQzRC?=
 =?utf-8?B?R0Jxcis2WWxzVERKY0ZoSHlRdkJXcFg4SUk3Z29yT3R6aUI3cHBBazZtU2gw?=
 =?utf-8?B?NVNSWEVQaGRIejQyWVFUTjhKU2c5UEZCdG9DV1AvSDVUOVlkamg0NTJCZFo2?=
 =?utf-8?B?WTQreStBSWNCUWhZWUR2dVpMOEJkZzR3OTlySjBmZElhdjk0YW9wbloyUnBE?=
 =?utf-8?B?SCtac3NxZy80Y0hvVVk0QzZySlBSVEt3dU95YkhTU3MxbERqUDNKMEtBQU9S?=
 =?utf-8?B?OUN4NlJwWFVncjZsS0VwUTZyaWtpR1JWNjdpbFRTVE5NZHlySE1TaEJGdkZJ?=
 =?utf-8?B?L09ad3BBaDFNVnI3R2lkUjBMS0N0RFNFTEQxNkp6L1cySE9YUGtKaWs0NDN2?=
 =?utf-8?B?bFhjSGYyNFNUVm5LcEdQQ2Y2bXNDeW9wcjVscFF1UWx4QUJ5UkdPRUxRd0lP?=
 =?utf-8?B?MkRhdGQ0OWRNY2FMUlZUb25mbXRHK2xoSzBsREpNSURSWmZGVmRnQXgvTGRE?=
 =?utf-8?B?TEM5S25xeDdmajJMNzQ1Zml0Q3hSRW9vUkdkS2lhQlFNZDR1ME03bytWWWk1?=
 =?utf-8?B?OSt3WGVDU3dQSlpRWCtuMGtYRlNsQXJxMk1wMHV3WnlMRndSeEJKbjlMZWxG?=
 =?utf-8?B?OERnTnhQZmJ1bkxmSnJJM0ZlcG5tN1VMUXFQYitWcHVyczhWRDRSelF2aTNT?=
 =?utf-8?B?TGpUN0txSlc5anFqK3I5d2toL1g0NFkzdkpXMW9RTURDaTFRczZveVJQTktK?=
 =?utf-8?B?bkFRK3pkVzVSZ1ZJSWt3Q1BlVjUwS3FIdzI0ZSt6cHdGTDcxdUtMM1crd1F1?=
 =?utf-8?B?d2ZIUjJ4dDh4eCt4b0ljWEtpY1BOVnJEODQ4U3kwS1VLU2VHWTJVenBDTjIx?=
 =?utf-8?B?M0JqN2RidklHMnoxdE1pRkhDM1IyTXdYMUsxbEw3L09rU0ZwMlRxSjVUT2p4?=
 =?utf-8?B?TzNNYTNjTXQyaStEV2ZNaDhjYXBwSm93VjNvMG5yak4xSVNGSG0zdy9uZFRE?=
 =?utf-8?B?MnJPZE5hK0Z2VC9zdFFvNVErS29ZM2xXakx6bE9YcEZtelp5c2R4QUdQOUo5?=
 =?utf-8?B?aCtaSE5nNUdsSDY5bTFOZVZuMjREM0QyZ25lZ2NDUDV3QXh4ZGlUczVwalMr?=
 =?utf-8?B?OFpXRjJwdGhlVk1IWG9sSDRqbFpVRjB0eE41aktqSis1aXRjRjFoNlNQZ21k?=
 =?utf-8?B?dCtKVnNYeGJVWCs0TVo1N1BxdWxzTlMzV0QvMzNVUGpZR3NZb3FnaEw1UVVS?=
 =?utf-8?B?OURZOThFd0JhTmxHS2cwaVA2MHppUW9yRzFQY3FBMmFKQnVRdjdlcnE0L2hZ?=
 =?utf-8?B?bk1NUDVCLzdkVThtL3l4L1dpUExkQ1AwTlppTEJXQnhFOVEybFZPZEU0czdM?=
 =?utf-8?B?YjYyRFpYVmMwMkZKOXRlOUVqY1R2eU9BNTBiRW5kOFRURTdDUnB4YmJ2dVNX?=
 =?utf-8?B?OEFRcDA5VTVSZ0w2eVQ2cVNkcXVOWVR6Y1AvV2gwQ1kwNzQrclZaN3JCbCtC?=
 =?utf-8?B?a1UzcDVsZUowVW9vdG5uZXROYWFTM1V5Y2RmdmhwWkZ0d09sWlZlb2YybzFL?=
 =?utf-8?B?Z3JUUXRmaElLd3B5NFk4dmZWRjBRS3V6aHlZZ0RCWFZNanJYRXRTTnU3QVdG?=
 =?utf-8?Q?s2mle1kuyj6YDB1LjM?=
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
X-OriginatorOrg: gatech.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR07MB9958.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c802f96c-00cb-487d-3436-08df34ef70bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2026 12:31:50.2831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I1ZD5aANcTBiZmTGuC4Vq0D3Zdnoq6ayTsk9UzpXmDhgXqbpdkUNbhQvnuHbLqwpwhEYrH7PHS1K85LIeAfTyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR07MB9407

SGksCgpPbiBXZWQsIE9jdCAyOCwgMjAyNiBhdCAxMDoxMyArMDEwMCwgTWFyaXVzeiBUa2Fjenlr
IHdyb3RlOgo+IE9uIFRodSwgMTUgT2N0IDIwMjYgMjA6NDc6NTEgKzAwMDAKPiAiTWFzYWxraGks
IEFiZCBBbHJobWFuIiA8YWJkLm1hc2Fsa2hpQGdhdGVjaC5lZHU+IHdyb3RlOgo+Cj4+IEEgd2Fy
bmluZyBpcyBlbWl0dGVkIHdoZW4gaXQgaXMgdXNlZCB0byByZWNvbW1lbmQgdXBncmFkaW5nIG1k
YWRtIHRvCj4+IHVzZSB0aGUgbmV3IGNvbnRyb2wgaW50ZXJmYWNlLgo+Cj4KPiBEZWZpbml0ZWx5
IHlvdSBzaG91bGQgbm90IHJlZmVyIHRvIG1kYWRtIGZyb20ga2VybmVsIGNvbnRleHQsIHVzZXIg
Y2FuCj4gc2VuZCBpb2N0bHMgZnJvbSB0aGUgb3duIGFwcGxpY2F0aW9ucyB3aGljaCB3b3VsZCBi
ZSBtaXNsZWFkaW5nLgo+CgpUaGFuayB5b3UgZm9yIHRoZSBmZWVkYmFjay4gSSB3aWxsIHVwZGF0
ZSB0aGlzIGluIHRoZSBuZXh0IHZlcnNpb24uCgo+IE1hcml1c3oKCi0tIApCZXN0IFJlZ2FyZHMs
CkFiZC1BbHJobWFuCg==
