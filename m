Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021119.outbound.protection.outlook.com [40.107.208.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEA7361964
	for <linux-raid@vger.kernel.org>; Wed,  7 Oct 2026 10:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791369742; cv=fail; b=EhitFSSOk0vUJQxA68bu2JQKiHyHNYJdp2QUdC8VLLqIVzQOjaw3vWeDdnRrxpet0XkSN7VQAAohd4chlbfnHAsxTH9pmP2kWcKx2WuVDCfOpoBTJm5fIPY8Ajt/GYo8iyO+orWe9jsrb80NudwpR5AOpwGHcBNLHC+f5+fdusA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791369742; c=relaxed/simple;
	bh=vRGlMjpVf9beO41MQGDbzAf1daBX/en7Q4OPj4BmpIg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=idKcMdADxVzHfpQrKtB9tCwZ65VpK8apfidOaB7ovnTVp0aVfDZ7fLxXKFf9pjLnsSJNKZ8Ao2IWzeFnq4TAbIT/mJUDVmIaqsvAJAfCT3bbt+4kUX+9kRVFLewOFDYHqMitNqG3T8uUnzvs3uItPHO8bM8GJffmkJDe4UUJF54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu; spf=pass smtp.mailfrom=gatech.edu; dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b=CJ9GiAqn; arc=fail smtp.client-ip=40.107.208.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b="CJ9GiAqn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nGbzUxzgxaknBzFTSTVPk5z6m3wqkxBZh9qFe19RGgMeY1+z5MA+rGefJ7yA7Z0mvc+qEDGyscGN28d/PRSO6iMhF86l9P+oMz6bpB/WsCGfRGcvmvwCg8d1nBQDfmNVIyQEo9ZiTCKn+nxkCSHMWw1zekP8Hc+9k8QTOkzs3xsd4ouUjnSjx8sz0XzzS4BSgbq+ewFaiH0So1NHXzAI+eH638IfnP62w4ucziPa8Y8Bk2ZOz3oJhe6Dkm1/571CKDr575NYxDkK3WqQ8x8AvzPMh+N6s1gLFmhNj6A+S+5VrG6dGbQjjjmUfwdWmjSAtFkPCJXNl1fO8jOolirfJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vRGlMjpVf9beO41MQGDbzAf1daBX/en7Q4OPj4BmpIg=;
 b=gJYZD4uBkgV5CD2PQsvA3ILPqjMYanBt4Uoxkh0uW7OjfYAhVh2qnuym0b8Ef3NAJ6kEJ5el7PLnnanPkzOTCiTHkTySIL7Ab84CztqmCdpSZI60SMilH9aZu1h3c0epQPqfgM2bvGRriAubQpfaFzfcxo48Iqhqm9KzOImRVc6s5c16zt5FY1mmnoHgCWPzWvZBgkybyY9dxgRanbSEjpk2XgE5AqW1OV8+EBLs8pJ0BYXa2DhviupkfKysWHxGkuCXelBweHKAdsMWbLfqcwz5rAOE2meHUKM27+eOy5vjWcagRD3HC1bO0CZbayQhlSXchiWqENrkxMxTLzpz/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRGlMjpVf9beO41MQGDbzAf1daBX/en7Q4OPj4BmpIg=;
 b=CJ9GiAqnzvysf521+AHJ2Ke5V616dtEbT3eF6Dbp6e56GHGMjbWw/VE+Z7LCIpGxZciYFxJrvLLu3M4W92za/3fSumIILHNyMrqkOWKrxYGLV2RCoFcDsVJKzqPA8hfz8QIm94Q2iihCJAtFMNO9XjlvKxD0ypX/Pgk7Q67huNL68vynlRa2Hz+Yo+FmO6hfvc1Lo8MTmNpoUKMNT7GZNErBA4BtyAr7WoxQXNFKv9+ZqRNdOmqRmkxU327FtxDBj/v3pVRoVDAaXYMYRYYPffs85koa9daxY8fswEcfnEE43YLaQQ2t3H3AKW2naex3QsYPUZo66gdLB27J0A3g+A==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by LV3PR07MB10137.namprd07.prod.outlook.com (2603:10b6:408:23c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Wed, 7 Oct
 2026 10:41:49 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 10:41:49 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"yukuai@fygo.io" <yukuai@fygo.io>
Subject: Re: [RFC PATCH v2 4/4] md: add a control device for array management
Thread-Topic: [RFC PATCH v2 4/4] md: add a control device for array management
Thread-Index: AQHdVkh0HTAb3CbfckCSZKnmeGGVSQ==
Date: Wed, 7 Oct 2026 10:41:49 +0000
Message-ID: <m2jyntbxn8.fsf@gmail.com>
References: <20261001125611.943731-1-abd.masalkhi@gmail.com>
 <20261001125611.943731-5-abd.masalkhi@gmail.com>
 <20261001131958.E1E6C1F000FF@smtp.kernel.org>
In-Reply-To: <20261001131958.E1E6C1F000FF@smtp.kernel.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gatech.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR07MB9958:EE_|LV3PR07MB10137:EE_
x-ms-office365-filtering-correlation-id: 57606ad2-829f-4aa1-8585-08df245f9774
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|786006|1800799024|376014|366016|6133799003|18002099003|10067099003|22082099003|38070700021|4143699003|260925022911599003|260925021311599003|260925021911599003|56012099006|11063799006;
x-microsoft-antispam-message-info:
 q1rlNj7C50j+2jFxmkaPvC4OfSJMRJGXYAlQMSp625wYtALpMEeMxBJl1LLuMahsaFn9gElItQyj605uLuDsdv00eyqlgePHmYP+6c6hAlzZ0WT8lrjGnCz9sH7CelEjY9HPK+XHYiRCA46cI2D+7QMPcyVLbgMmOlN0vEDXnKpfatH0uu7HN4k3EdJF/OviNG+IgHID3gAK6y2DlUgC/ORHTihUbMIDceXmhXZP8WZh33FiNwtZPKlIJRfNgcB1U8RjvJEAkpg/NKyBmia+R0paJThAvD4jL6cuFckIu5JZwSAVf65pTOdoJ/y2lU4OJlO3oXC8XweW58GSD+lFD7F4BL7hAZBYOalHauInspSZihhE5pfFe5yzDpUOK/VbnCO2mAnWrSzdKwPIdYRDXspONX61Uu1eBxpYORdNpqPnmQwN4ry5DSUXyDCdA6wLL4lvLt/C65E4s/3fja/x7kleKJh/KPIfwgoACC2RNob/yPUNelR18f7YvipFDIFPOJD7Tli+wCyl8oBP6qpXT0UPn/mNniaF7txn4hPadx8q63EMbIxWBDfC4nbKYhxmAQDphHhM3LqZsgCF1ZguzHLmi8eDUo0wLc181W0s+Ir7FBMXaGBc+8syM/LkKyd6Jm+akaLbqfmrBYI1huvWkGoHJzebTmDUut9ssQJ8Jl4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(786006)(1800799024)(376014)(366016)(6133799003)(18002099003)(10067099003)(22082099003)(38070700021)(4143699003)(260925022911599003)(260925021311599003)(260925021911599003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RFRqWE9rK0xidlVKOVhYYnluNk1PeG5Ia0pzcEYzeEVlaHd3RWNnV0J2eExY?=
 =?utf-8?B?ZmR5ZXkyd1NrOUljdTd6OW9aaU5XalRVZUVxb0pDbTh0Z1RPblZZbnJTMUZa?=
 =?utf-8?B?eVREQ1dRSlR6SFRabU5PSk0xcGZ4UHpZNCtESVRoREVLK29MczV5RXJWZHZv?=
 =?utf-8?B?K2hkankxbmpHRUQxUkh5eVIxM08rd1FBWmFHenBqQmJyV29zYkNTbkcwL2x5?=
 =?utf-8?B?eHF6SlpFc2JubERRTk5YU1ZBcE5xaDB0eXZBUFowRy9VSCtVcUNJTStQQlhF?=
 =?utf-8?B?ckhMTkMwdFptcExmUTN0aHY2ZExibnp0cnBicXlOSUtBdEl2SWJBV2lXaU12?=
 =?utf-8?B?bmFPblNDd0ZMSEkrV2ROcm51WDRzUVRSNS9iRDY0ejdSdlVxbHRvZ2hkdWVl?=
 =?utf-8?B?VklycTZIbUIwSHVlSzVzMmYxbzUzTGpKVnFlTmtJdG15dDREYm9nRjNndktW?=
 =?utf-8?B?TmRxVWJMME1vTmp5aTFQRXcxUnJBeWpGZW41dGt1WGM1SFdjejBqMEtrTzBp?=
 =?utf-8?B?UzFBVXdZM1Z4cEpnTkE1SW4ydDRHZmN1YzlRblNrM2hQNmMreUU2eWtuTkcv?=
 =?utf-8?B?cjBNdmdUV2JnMEdzTTNhQVVWQVpHZnFselkvU1FWK21rMHZwNTNUeE80Ym1X?=
 =?utf-8?B?bzhkYTVHWUJ6Q3pINmlmRXIxVTNoN1V1Z2J2c2N0b3NJZ1BxSGxKeFVINWZy?=
 =?utf-8?B?T0JWK2wxb1BhK3MyQVJtSXZncnQrSVVyRHdJMXhmNW0xOUxKdElUMDU2UjVh?=
 =?utf-8?B?Y1pBR1JqK0lRMWRkQWd5blYreklWNUxvTTNTVWVDdzArTXFiRi9TUXZvVjQx?=
 =?utf-8?B?Q0NOODVFWlY3OEw4VXdsSHdESkNORCtSVkxESzhNYUEyZ0dlUkRDbVlSdlZD?=
 =?utf-8?B?TVQrQUpMTkQ0RWlZNVZxZ0Z0MWc1WFFFOXk2a2lHellNaFVVaUYxbVZ0SHQy?=
 =?utf-8?B?bnBTbkdKNFlNeFlIYVRncEJma0tFWTI0amQybE9SNlhYWURIa1hoc0I5Zyt4?=
 =?utf-8?B?MnVtMERpK0twbEtlNThTdEhIOGdZY1ZnekZjR1hNMDJTTllQcmNkVU5mZElG?=
 =?utf-8?B?SEF4WGgwNTQ5WDlqaTY2Z0xLY3FueE56NFR1K3BjdWIxZmdNcjd4N0hRRVBs?=
 =?utf-8?B?SUJBN3VmdUFhTWZkUHFBb0VRcmhDYlZqaWpvME5ER2Q4a1d0dksxVDFIOHFm?=
 =?utf-8?B?M1BYOS9Oc0hQZkpCNXRiTUs0OEs0eU1GVWU0Y3dCK3hCWkhoOHp2WHV3eUdh?=
 =?utf-8?B?T1JJOTJzMEYydk1ZcDhaK0ozUGkrdTlVdDgzQ3pmUjMrWWdTaTdYUDlSbzZs?=
 =?utf-8?B?Z092Zm5pbG85RXVkajFhRVJBMVkxL1hvbHBmMitNeFF1RkxsQ1FDT3pPeXVu?=
 =?utf-8?B?emZBR1dwWnhhU0ZnY0dJTnU0b2lNQk1WUDRSY2pKVWs0L2N3aTlGdHVJQzhC?=
 =?utf-8?B?aVVHMHVjY0RVRjVmZEJVSCs0cjFJcmxWaVhaSUxBQUpveXdSSTZLZHppS1ox?=
 =?utf-8?B?ZDBUY3dBRVBYOFBvdTRYREVabG0vL2NPK0NvQjNUbnV2Q2hveFowRWFQUXQv?=
 =?utf-8?B?c3BHY04zYjg1aWRrWWhtZXQ4NGVsVXkvWjdlYlcrcmRidlZ6Z05jeG9WUi8y?=
 =?utf-8?B?Y2c4T1hvZEpiM2tNRXd0eWdNdHROUis0RE9YbVJGeDBFSWFTVWgrY1ZjaGx6?=
 =?utf-8?B?RmY0YVAvVmxYRXRxQzJ0dnRnWm54bmEvb3ZaVjljUmtzR2hlUXF1YjN5MUhh?=
 =?utf-8?B?ZEY3YTZGb3RrZ3FNNnZCNS84NkV6MWlsUE1FZ1N1a1Z0THg4eW82WFVYaFQ5?=
 =?utf-8?B?YWFWSHZHeFNaYzNRZkQxOUF1R0pzMDJYM09WZHZ6OHhkWlpkRkhHSnlwNHVN?=
 =?utf-8?B?UXg2aldSaC9hQ1pLYUJkaUkvYlVsV1VUTk4rNnFKV0QwRHJKOVQxNSszQkt5?=
 =?utf-8?B?eTcxV1hmY0loL2R6cTRQZW5qVGRUZ1lnbTgyenU0ZHlIRFJTeW1NY05QbytY?=
 =?utf-8?B?TFBKaEZwSFYzY2EwejRDYzEwUWN2dnIwWDliODE5VlRNbW96Y1ZSdHdGbm1T?=
 =?utf-8?B?TVAvR3BGSTYwNk9kbEtQLzFYN0ZpbDhObzhVVXk5ZXlsSkZQREJucFRhNndJ?=
 =?utf-8?B?YzY4Wm83Yk9UQ0tYN2pqemJvY1gxTGZ1aGpBa0ZKZGJYc1BMSEVybWw4OVB6?=
 =?utf-8?B?cnBTdmZiRk00SHBXTmtFb2pCNWVLQzVUTVFTRXlSRTltQS9adTJ4bjJseEN4?=
 =?utf-8?B?bEtqTUpZVGFaTzR0RkxJUnBiVmM0dnkvTSt1VzZHSHVrbCtCN1N6enVPaUtH?=
 =?utf-8?Q?YBvl8FCdxdJsWH7ADH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <504F50684106B04A880C59E6808FCD8C@namprd07.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 57606ad2-829f-4aa1-8585-08df245f9774
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2026 10:41:49.1133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nZ//bCtDsSahUJE0GWIOa93n2Uzr62IaNIBbbWtVdroOFVO97DmqtAY9UsBt6JIPsvRCj0AVFj3/eHdFag8uqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR07MB10137

SGkgS3VhaSwKCk9uIFRodSwgT2N0IDAxLCAyMDI2IGF0IDEzOjE5ICswMDAwLCBzYXNoaWtvLWJv
dEBrZXJuZWwub3JnIHdyb3RlOgo+IFRoYW5rIHlvdSBmb3IgeW91ciBjb250cmlidXRpb24hIFNh
c2hpa28gQUkgcmV2aWV3IGZvdW5kIDIgcG90ZW50aWFsIGlzc3U9KHMpIHRvIGNvbnNpZGVyOgo+
IC0gW0hpZ2hdIG1kOiBNRF9DTE9TSU5HIGZsYWcgaXMgbm90IGNsZWFyZWQgb24gZXJyb3Igb3Ig
Uk8gdHJhbnNpdGlvbgo+IC0gW01lZGl1bV0gbWQ6IHN0cmljdCBib3VuZGFyeSBjaGVjayBvbiBV
QVBJIG5hbWUgZmllbGQgcmVqZWN0cyB2YWxpZAo+IGlucHV0cwpJIHdpbGwgZml4IHRob3NlIGlu
IHYzLgoKPiAtLQo+Cj4gY29tbWl0IGMyZDYzNTFiZjc1YmJlMjVhNTczNGIxNzYzOGQxNDMxNzEz
NDg4NmMKPiBBdXRob3I6IEFiZC1BbHJobWFuIE1hc2Fsa2hpIDxhYmQubWFzYWxraGlAZ21haWwu
Y29tPgo+Cj4gbWQ6IGFkZCBhIGNvbnRyb2wgZGV2aWNlIGZvciBhcnJheSBtYW5hZ2VtZW50Cj4K
PiBUaGlzIGNvbW1pdCBpbnRyb2R1Y2VzIGEgbmV3IG1pc2MgY2hhcmFjdGVyIGRldmljZSwgL2Rl
di9tZC1jb250cm9sLCB0byBoPW5kbGUKPiBtZCBtYW5hZ2VtZW50IGlvY3RscyB3aXRob3V0IHJl
cXVpcmluZyBhbiBvcGVuIGZpbGUgZGVzY3JpcHRvciB0byB0aGUgbWQgPWxvY2sKPiBkZXZpY2Ug
aXRzZWxmLiBUaGlzIHByZXZlbnRzIHJhY2VzIGR1cmluZyBhcnJheSBzdG9wIGFuZCByZWNvbmZp
Z3VyYXRpb24gPWhlbgo+IG11bHRpcGxlIHRhc2tzIHNoYXJlIHRoZSBzYW1lIGZpbGUgZGVzY3Jp
cHRvciB0YWJsZS4gVGhlIGV4aXN0aW5nIGJsb2NrIGQ9dmljZQo+IGlvY3RscyBhcmUgcHJlc2Vy
dmVkIGZvciBjb21wYXRpYmlsaXR5IGJ1dCB0cmlnZ2VyIGEgd2FybmluZyByZWNvbW1lbmRpbmc9
bgo+IHVwZ3JhZGUgdG8gbWRhZG0uCj4KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbWQuYyBi
L2RyaXZlcnMvbWQvbWQuYwo+PiAtLS0gYS9kcml2ZXJzL21kL21kLmMKPj4gKysrIGIvZHJpdmVy
cy9tZC9tZC5jCj4gWyAuLi4gXQo+PiBAQCAtODYwMiw2ICs4NjA4LDYyMyBAQCBzdGF0aWMgaW50
IG1kX2NvbXBhdF9pb2N0bChzdHJ1Y3QgYmxvY2tfZGV2aWNlICo9ZGV2LCBibGtfbW9kZV90IG1v
ZGUsCj4gWyAuLi4gXQo+PiArc3RhdGljIHN0cnVjdCBtZGRldiAqbWRjdGxfZ2V0X21kZGV2X25h
bWUoY29uc3QgY2hhciAqbmFtZSkKPj4gK3sKPj4gKwl1bnNpZ25lZCBsb25nIG1pbm9yOwo+PiAr
CXN0cnVjdCBtZGRldiAqbWRkZXYsICpyZXQgPSBFUlJfUFRSKC1FSU5WQUwpOwo+PiArCj4+ICsJ
aWYgKHN0cm5jbXAobmFtZSwgIm1kIiwgMikgfHwgbmFtZVtNRF9OQU1FX0xFTiAtIDFdKQo+PiAr
CQlyZXR1cm4gcmV0Owo+Cj4gW1NldmVyaXR5OiBNZWRpdW1dCj4gV2lsbCB0aGlzIHN0cmljdCBi
b3VuZGFyeSBjaGVjayByZWplY3QgdmFsaWQgdXNlciBpbnB1dD8gSWYgYSB1c2Vyc3BhY2UKPiBw
cm9ncmFtIHBvcHVsYXRlcyB0aGUgbmFtZSBmaWVsZCB3aXRoIGEgc2hvcnQsIHByb3Blcmx5IG51
bGwtdGVybWluYXRlZAo+IHN0cmluZyBidXQgbGVhdmVzIHRoZSB0cmFpbGluZyBwYWRkaW5nIGJ5
dGVzIHVuaW5pdGlhbGl6ZWQgb24gdGhlIHN0YWNrLAo+IHRoaXMgY2hlY2sgd2lsbCBmYWlsIGJl
Y2F1c2UgdGhlIGFic29sdXRlIGxhc3QgYnl0ZSBpc24ndCB6ZXJvLiBDb3VsZAo+IHRoaXMgYmUg
cmVsYXhlZCB0byBlbnN1cmUgdGhlIHN0cmluZyBpcyBudWxsLXRlcm1pbmF0ZWQgYW55d2hlcmUg
d2l0aGluCj4gdGhlIGJ1ZmZlciBpbnN0ZWFkPwo+Cj4gWyAuLi4gXQo+PiArc3RhdGljIGxvbmcg
bWRjdGxfaW9jdGwoc3RydWN0IGZpbGUgKmZpbHAsIHVpbnQgY21kLCB1bG9uZyB1KQo+PiArewo+
IFsgLi4uIF0KPj4gKwlpZiAoY21kID09IE1EX1NUT1BfQVJSQVkpIHsKPj4gKwkJLyogTmVlZCB0
byBmbHVzaCBwYWdlIGNhY2hlLCBhbmQgZW5zdXJlIG5vIG9wZW5lcnMgKi8KPj4gKwkJZXJyID0g
bWRkZXZfc2V0X2Nsb3NpbmdfYW5kX3N5bmNfYmxvY2tkZXYobWRkZXYsIDApOwo+PiArCQlpZiAo
ZXJyKQo+PiArCQkJZ290byBvdXQ7Cj4+ICsJfQo+IFsgLi4uIF0KPj4gK291dDoKPj4gKwltZGRl
dl9wdXQobWRkZXYpOwo+PiArCXJldHVybiBlcnI7Cj4+ICt9Cj4KPiBbU2V2ZXJpdHk6IEhpZ2hd
Cj4gRG9lcyB0aGlzIGV4aXQgcGF0aCBuZWVkIHRvIGNsZWFyIHRoZSBNRF9DTE9TSU5HIGZsYWcg
aWYgaXQgd2FzIHNldAo+IGVhcmxpZXI/IFdoZW4gYSBwcml2aWxlZ2VkIHVzZXIgY2FsbHMgTURf
U1RPUF9BUlJBWSBhbmQgdGhlIGFycmF5IGlzCj4gYnVzeSBvciB0cmFuc2l0aW9ucyB0byByZWFk
LW9ubHksIE1EX0NMT1NJTkcgaXMgc3VjY2Vzc2Z1bGx5IHNldCwgYnV0Cj4gdGhlIGlvY3RsIG1h
eSBsYXRlciBqdW1wIHRvIG91dCBvciByZXR1cm4gYW4gZXJyb3IuIFNpbmNlIHRoZSBmbGFnIGlz
Cj4gbmV2ZXIgY2xlYXJlZCBvbiB0aGVzZSBwYXRocyBpbiBtZGN0bF9pb2N0bCgpLCB3b3VsZCB0
aGlzIGxlYXZlIHRoZQo+IGJsb2NrIGRldmljZSBwZXJtYW5lbnRseSBsb2NrZWQgb3V0IGZyb20g
ZnV0dXJlIG9wZW5zIHVudGlsIHJlYm9vdD8KPgo+IC0tIAo+IFNhc2hpa28gQUkgcmV2aWV3IMK3
IGh0dHBzOi8vc2FzaGlrby5kZXYvIy9wYXRjaHNldC8yMDI2MTAwMTEyNTYxMS45ND03MzEtMS1h
YmQubWFzYWxraGlAZ21haWwuY29tP3BhcnQ9NAoKLS0gCkJlc3QgUmVnYXJkcywKQWJkLUFscmht
YW4K
