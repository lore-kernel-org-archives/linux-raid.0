Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.2.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794728503;
	b=KfG99RI4GZH1LroJxnJ+sqJiie/C2gp5pOKnMn2BgEFJ+UhuSN0CnjESTVdx07XD+BZd
	 TaOszwThDJZ4jMLKttSANXysLmQcCO+52ixmUi750HtQmHbN4HmCd7QJ4L63mTNio5oPq
	 vIzU9x357Z0ad7/0UqMCxWULFw60N+Pyyp1of7sqGdad3FMBHTOt+HWNw3mIYGngBD3kb
	 O3WjL98AsGAWsAZEQo+lDbkhokUhd3yoXyNBqlCAOcx/E3s9YkYlRT2IseC2NOzimYLI7
	 TOGxJyhBiQVAiHYCCXaIKG9YwofMzEJYXgkrciLAznJVJ3HTedyLZL3B7U4fy8sIZ0w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794728503;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=I3WByo8hq0A3AZv0A7D84Ij4JJGgH5ur7QrnfCQ0p58=;
	b=SX3QWn2mEyQaIEBybOykC1cz3qKi+ky9T6b5fy6zTPpsxtkwx1ZzAU2aTZBG+QtSPISx
	 3nG5Pwe0I/PikDDVmnVFPuLWjmdmHCE3Q+bGpDtcLBr06qNuX/XkCwc60rcVRGmK0MWGF
	 v7f5DSC1gtdSCba2tVzYi+Yj5+eBO5Fjsu3RV0S5MvevvW3A+zz4LZn+Y7Q3XQE6c8gVu
	 CAzqBnO1DFlwO7qHlgLnaR8CbZzREKAmlAw93nde6ZN9+2XrxANAO5ImncBtiBxHStT6e
	 oDGuS1Urc0PAMLNYwvcyRpy4tXGjOStJ76GyhqS0NiSUABTYi/iQOGd+HWz0rgMch/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=RxHe5Qku;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.2.0
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazolkn19010000.outbound.protection.outlook.com [52.103.2.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B682606A333;
	Sun, 15 Nov 2026 07:41:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B682606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=RxHe5Qku
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QpP7f5kHXPh8b1CBqvG+VULXPRFhpmAh7qvPvZQy1bWxxhcrPZd/QurveWIksnNEpikvb+RJxCQhbMEMIkKbNPcX5ryETUTm+lIPAhZQOJK3xFJMAJwoLSg2XxAfBkgat2Bx/kPTYYklz8CkcDRqpBpWrzLkM6Bqlc7GB+zR1zFzzEg43NGKYQbfDDLavyFQLK3NiQrzbYV81B0YQPBqAJIw2Vq3n7CGHh/c0d8Qth0hfDcD4SIC+PNCwJJf8kZg4sfLPacqJMoAH7Kn9fhIEE1cXr9lgO5nLbX6gWx8KLdmGBCIdC1YxrAPa+/PSQNRm0kpzABvyvQPdLHlg2IlPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=I3WByo8hq0A3AZv0A7D84Ij4JJGgH5ur7QrnfCQ0p58=;
 b=csZye5PKTW17PS5BbmSiUHTIwgzw/7EYxD8S9+jRJNXuznuT+Aj9r+A1elimh16+bOReH7CefSXLgMdvixAV8WnBVa4w+y6ZxD2zbUJETK0E+wvc/ebRTx82CI/fL/RCHZ0E9wAfb+zP/sP8/4j1yOhJE3U1kyuerE1NMykl4vQnwF3+ZgfH0dbpnxbXRMgBbQVoilTbkXS01JYgXn25dSl1OvA4r1wAorkQFY2yiAjFbq+Tp3SCQNAckQk6BEcvnvmIQ55DDrm4L5kt4I3mQ7GANbUiSNyuZYh7dj3O3i6AQlQmDS7lS5PWY3tC61XCTGMK5dkhjSBZ3ZsOJYmKRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3WByo8hq0A3AZv0A7D84Ij4JJGgH5ur7QrnfCQ0p58=;
 b=RxHe5Qku2AyrVYnY8FZwLiufUmULea1seno6Ow8+Bd8+yq7u0nOQCbFZK2//ztr/ev7bgv796bnBk3JfF5tFU9DMZPSqOK8Jfhd1ErgiKi6yHvcSqPCOg6xVBPUfkqaDsA+IrZlr62nZ1gsir531Bo+8Ep8LRNRHsoh69UHqIN/W399c/Olh9ZzHXoUc4graoVfxf+5zx5StnGVRwbad3W2roGOXXeIPWlyLelDPoaUXwpbYsmC15SDwYWoVKLHKpB53JL00mLIo5faWHDUfkEGIe/5lNaTmRn6jmYcpzv0LPkbK6VscjMTgfbo6MGEbDqWp+qcQTvPhifx28+pqyA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH7PR05MB9777.namprd05.prod.outlook.com
 (2603:10b6:510:279::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Sun, 15 Nov
 2026 07:39:39 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0615.012; Sun, 15 Nov 2026
 07:39:39 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: Song Liu <song@kernel.org>
CC: Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>, Xiao Ni
	<xiao@kernel.org>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] md/raid5: fix PPL disk add and replacement removal
Thread-Topic: [PATCH v2 0/2] md/raid5: fix PPL disk add and replacement
 removal
Thread-Index: AQHddNR4NvT1XTTtWEeATR/zssZ/iQ==
Date: Sun, 15 Nov 2026 07:39:39 +0000
Message-ID: <cover.1794555233.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH7PR05MB9777:EE_
x-ms-office365-filtering-correlation-id: 9d514a4c-596e-4990-c157-08df42eb9acf
x-microsoft-antispam:
 BCL:0;ARA:14566002|41001999006|51005399006|5062599005|38102599003|8062599012|8060799015|19110799012|24021099003|31061999003|25010399006|15080799012|4140399003|24121999003|22091999003|10035399007|12091999003|1602099012|40105399003|102099032|30101999006|440099028|4302099013|3412199025|26121999007;
x-microsoft-antispam-message-info:
 =?utf-8?B?Nzg0SVpmRE5pcVkxY2djeEdjRi9Nc2pVaFNnUGRqWjFCdVg4bXYrMEZIeEw3?=
 =?utf-8?B?aHI5dzNxbEthZ3dLb3VhL0JYUTBYMVpCU1pYeVpNYjNqTS9DdXFNZTRzYkE5?=
 =?utf-8?B?T1lJcjhhR0tqNHVjQkQyRVlsTEdFODdUS01WYytyd2xYMWVmZmJpWVhjUkw2?=
 =?utf-8?B?K3pOWGx5VURLclBwZzdFMGxiZjNGSFI3L2R5UWlBZVBqT0J4Wmg1Sk94MTlp?=
 =?utf-8?B?aDBkZEs1d0kzcW44ZUE3T2VYOFFYSTMwclNOZjJPRXNmdTBoMkhSUERXT1pC?=
 =?utf-8?B?OWFaOGl3WGdSaWpOZ29JY2sxMThWckRSVnQ4bXN4UDhMTkNzazdXdnFFcXA3?=
 =?utf-8?B?M1pLMnJFMjJERHFPdWM3QVhES1RlRWVEeU9sUExnZGVVUFJFcEJBTXdYNFpo?=
 =?utf-8?B?SDBJcHFlbG00aFVtM1grdVJLMmxUa2dRTnNGaDlxS1hkVFpScEM0aXNzZU9L?=
 =?utf-8?B?RTJTQStQcHZhSURuZVBNc1kxT1NtT1YvTVpnRzIxbHZSTUxjNEFwM0ZsVHRB?=
 =?utf-8?B?WWk3NEJuNk1nQ1pnYkhqdUZTc09qN1lyM1VSclFmYVdsK2lXS3NHYVFQWTlD?=
 =?utf-8?B?TXFUUUt1cm03NERqb3lRSnZSc3J3T0dhbVFQOEExV1l2aGRFM1dTY1crTWF6?=
 =?utf-8?B?WGV2ZDhkZkFnMy9CNGlkcXY5WEJxTlo3VXJxZUNKT2cvZS9UNkliaUxndjl0?=
 =?utf-8?B?YkJmNXdpelorM3JVVlhDRUpuTzk2UkMrTlF0Mys2K25RQlNTN0ZoY01pbWJZ?=
 =?utf-8?B?LzNkMXNOVFNmZTAzRFpQWjIrTE1VdUhFaEVjMDFjQ3hlZWY5OXV2UG1vZTBr?=
 =?utf-8?B?RWdRM1Q0bGw0dktMOS9rVW9wR2NCN3RFbXdrRUpvaWp3RlpwSGNvMU5wZXUw?=
 =?utf-8?B?MHUzZUphWThNZGcvV1p5UEE1T29FZXFtLyt3ZzRxalJHSHd5ZVlLMEJHbXJX?=
 =?utf-8?B?dVZWMUlDeHowelNaaXRDVzVNWG1VOVJyVHVlbHFOMGpuanZDOGxqRmFmaHNW?=
 =?utf-8?B?akJqdWdLVXJLOFg5bTlrY3pZSkhSM1dMV1U4eldCS0ZRNjBoMnUxdFFhR2NR?=
 =?utf-8?B?QmltWXJabm9lUm5uamtQQk5OclBScU44cUFGMEVZa2g4Vjk3R1A1VS9id2t1?=
 =?utf-8?B?RUJXRDI3c0ZRMFlwbHNlMXVSSDJianJ3K1dTekJQUCtxTzIxdDl3QTFBN0g2?=
 =?utf-8?B?MkJQaDNxQUliZ3pTbXVRZit5RTNRaEJVaHN6TTlHSmplZkNZdGgyWEdzYkVz?=
 =?utf-8?B?V3hIejc2NVZEWTZ1Z1IrbXNuV0dNU1BuNmExR2hXZmNSbi9mYm5sNXplWVpl?=
 =?utf-8?B?TUt5dWp5UFJJbGRJc2IvYXB6ZmNHY0Y0RUdDejZyTkxpdk9WaTQvNm45dDhw?=
 =?utf-8?B?YkZaSDAyUkRDdFF2UHNESmsvTXd2c2Fvb0RWMGdITjVMUFluOW1NRFoxcmRW?=
 =?utf-8?B?QzNXU2pINkk0TXJhbUx4bzE1TWx3cGloUlM2Z090dEliWkFrQW4rZzhSNGZK?=
 =?utf-8?B?aW4yOGthdU1iYUZtOFhhTjFRV2l0NHZKd2M3akVoQUQzMld5alIveXZGZzFT?=
 =?utf-8?B?RWtUN3diZS82OFVrZ3V3bEN3c05aMzRtb0Q4MzBScG9TV2hWcUlOWTRDNEl2?=
 =?utf-8?Q?EcBi2oIqcOH4dfg2TaI7DnkvVwBVZINppmihXesdgTZg=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WGFsdkgwcE1rbC8wQVNldmpyQnN0a1J3ZjBaai93Y2RnbHVtR2JvbWdCSWhy?=
 =?utf-8?B?bGV4Z3JnVVdXdkFRMi9SQWRaMnNPazhUeXRhU2F0WnVsWGNqSzdHRk0wNXMy?=
 =?utf-8?B?anNqWEtKOGxYSzhYRmIwQnpKVkNsdGs5OXBBZnRGbkdiRis1QWNSdGQ0UTJs?=
 =?utf-8?B?Y0N3OFUyM2xiMW4xSkY3MWpRWFRnUFYzL1hwR2dldTNNUWJidXlLQW9iOUVQ?=
 =?utf-8?B?MUtjUkRCb1FQK0lJZXJ3NVNoM0hUQ2JoQ0JMK2lWUjVQVVh1V0V1UmJpaSt3?=
 =?utf-8?B?bHhPYWluN01aNVMzUVYzVU5ncDlYOFVFTEJ4dWhpeHd6dkc3K3lIMjVqa0Vu?=
 =?utf-8?B?TnAwZG81eFdSaDVCNGFvMHJVQ1cySEVLR09Nd1dIVnUwRzN5UVUwSHJWNlJu?=
 =?utf-8?B?TzNsR0kydTVxTGx5OGlEUitzT1ozUGVBUzdadkRObzVBMVdwci9yN2s0ZTNQ?=
 =?utf-8?B?MkZkM3M4bUVXdXJ2UXdNMFBkM2RRMW4vOXpTcDdiQms3QVRpZVJWT2Ruc01K?=
 =?utf-8?B?MTdTMEFUY3pvZGN1QjgxNUwxWXE4c2ZNdTk2R0lHczhZSDYvZnMydEpHd3pV?=
 =?utf-8?B?SytaODl4ZEhpRlF6akd1aUJGaUh0R2ZoWUlxZzZvZnFySUkzTmRqSDR5WjVi?=
 =?utf-8?B?bHB2VitDRDJtU3VROTBKTGdxaDZwVEFwZHBDcHc1SG51WFNxM2RPK2l0eGpT?=
 =?utf-8?B?ZWtRbWVCS2NTZGJYM28xbklHZWxFY0M5YVFqUmZpN2xkc1M1VHU3ck1qTXBW?=
 =?utf-8?B?K2NtTk5sRUVRMmlyTjR4b1FtOHVLRk51enpldUx2V251b1RYa21tMUdLQUtM?=
 =?utf-8?B?WlVtZ3NQeTNmK1VpT3VmSUJkclkyNUtSTGw5OXl2S2NtelREOG5tREFWVzRZ?=
 =?utf-8?B?N1JGSHBnYmZCL1JPcHFzSnQ2NlV3akx5a0lIK2crWUcyOVZ5RXlFY2tPbkFj?=
 =?utf-8?B?K1ZXWXZydmxmRlJCOUs0eGx0cU9nU0YrVVF6WW5xeW91WllKRVk0dzBuSHNw?=
 =?utf-8?B?d2dYb2RHMTYzVDRCUm9Qbks3SExLZm5sRkpNSkp2M2RUS1JOMjlZOGlEbTBt?=
 =?utf-8?B?dm43UzhoeUIrWW5mMlhGd2NmSGtLYk8yaFUxVEpGM1VXTC9KZmtacjdvdFFl?=
 =?utf-8?B?ZzVYMDUxNkgzOUdvdkFPTFJmUGJsYU1vbUFlUDBhT0h3Q0Z6d3VRZk14YThl?=
 =?utf-8?B?M1FzS2xOTFJkTTR6NXNsSmJnN3JOcFI3S0VuZkFKbnh6N24vNkNUcEQyY1J5?=
 =?utf-8?B?ZHg3Y0RlVDhpb3V3UE5QUmdFM1ljSUJkQnJYMWRGc2dwbnNaME9SbjBOREdI?=
 =?utf-8?B?ejZTSFR2L3EzLzFSNHVCZ01RMEJCZUpkR0J0WC9vU1gxMm1mQzh5MW9ZYmNP?=
 =?utf-8?B?dnRXczJibjVJZXZ0SS9uT1pBSXFYYnJod3cxWVoyanVZR3dBak1wRk9OZ1M0?=
 =?utf-8?B?eGh3Zm1zcURJVjJzTDAwSmdDYjZNU2tUVzc4S0ZKTDRHeHEwVE1FMkZLTTls?=
 =?utf-8?B?UkVBVDZyQStabVFKaVVmM25hbmZscXg2T2FjbzJlOFEwdXl5ZkxUT1hvL2xR?=
 =?utf-8?B?N1RKVjU0RGZXTnIxZTlPTGZyeXZ4ZHZqVVVFeDU2ZHFlVkV5ck1SSjZERjFL?=
 =?utf-8?B?N1hHbjJycERGZWhpa2hPbHZ5dUVKeXBMMVArVmFuUjRpR3RXT21KdnhxTG12?=
 =?utf-8?B?RkNuR01Jd3pWSTVGZnEwdjVycGQ3S1FUcDFicm1zQTc3UjdSWUgvRXoxUXdV?=
 =?utf-8?B?RXRtWVc0eS9tZE1MNzBacEZRQkZqTjN3VDlrNHJ0Q0I5NUh5RDUyTno4WXVR?=
 =?utf-8?B?TjZYTjUvRkJKSXJ6VWpQejBSenJMTjAwbFJqMjU0Nk03Tkc0K3R0dUJIemMx?=
 =?utf-8?Q?kcK+bUH6JIS9T?=
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
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d514a4c-596e-4990-c157-08df42eb9acf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2026 07:39:39.1604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR05MB9777

VGhpcyBpcyB2MiBvZiB0aGUgdHdvIGluZGVwZW5kZW50IFBQTCBkaXNrLXRyYW5zaXRpb24gZml4
ZXMuIFRoZSBmaXJzdApwYXRjaCBpcyB1bmNoYW5nZWQuIFRoZSBzZWNvbmQgcGF0Y2ggYWxzbyBo
YW5kbGVzIGEgc2xvdCB0aGF0IHJlbWFpbnMKYXNzaWduZWQgYWJvdmUgdGhlIGN1cnJlbnQgYXJy
YXkgd2lkdGggYWZ0ZXIgYSBSQUlENSBzaHJpbmsuCgpXaGVuIGEgbmV3bHkgYWRkZWQgZGlzayBm
YWlscyBQUEwgc2V0dXAsIHJhaWQ1X2FkZF9kaXNrKCkgY2FuIHB1Ymxpc2ggdGhlCnByaXZhdGUg
ZGlzayBwb2ludGVyIGJlZm9yZSB0aGUgY2FsbGVyIHJvbGxzIGJhY2sgcmFpZF9kaXNrLiBBIGxh
dGVyCnJlbW92YWwgY2FuIHRoZW4gZnJlZSB0aGUgZGlzayB3aGlsZSBSQUlENSBzdGlsbCByZWZl
cmVuY2VzIGl0LiBQYXRjaCAxCnByZXBhcmVzIHRoZSBQUEwgbG9nIGJlZm9yZSBwdWJsaXNoaW5n
IHRoZSBwb2ludGVyIGFuZCByZXN0b3JlcyB0aGUKcHJldmlvdXMgc3RhdGUgb24gZmFpbHVyZS4K
ClBhdGNoIDIga2VlcHMgdGhlIGFjdGl2ZSBQUEwgbG9nIGF0dGFjaGVkIHdoZW4gYW4gdW5wcm9t
b3RlZCByZXBsYWNlbWVudAppcyByZW1vdmVkLiBJdCBhbHNvIHNraXBzIGxvZ19tb2RpZnkoKSB3
aGVuIHJlbW92aW5nIGFuIGFjdGl2ZSBkZXZpY2UgZnJvbQphIHNsb3QgYXQgb3IgYWJvdmUgdGhl
IGN1cnJlbnQgcmFpZF9kaXNrcyB2YWx1ZS4gU3VjaCBhIHNsb3QgaGFzIG5vIFBQTApjaGlsZCBs
b2cgYWZ0ZXIgYSBzaHJpbmssIGJ1dCBpdHMgZGV2aWNlIHBvaW50ZXIgc3RpbGwgaGFzIHRvIGJl
IGNsZWFyZWQuCgpDaGFuZ2VzIGluIHYyOgoKICAqIGd1YXJkIHRoZSBhY3RpdmUtZGV2aWNlIGxv
ZyB1cGRhdGUgd2l0aCBudW1iZXIgPCBjb25mLT5yYWlkX2Rpc2tzOwogICogYWRkIGEgc2hyaW5r
IHRlc3QgdGhhdCBsZWF2ZXMgYW4gZXh0cmEgc2xvdCBibG9ja2VkLCBlbmFibGVzIFBQTCwgYW5k
CiAgICBjb21wYXJlcyB0aGUgdjEgYW5kIHYyIHJlbW92YWwgcmVzdWx0cy4KClRoZSB2MSBwdWJs
aWMgdGhyZWFkIGlzOgpodHRwczovL2xvcmUua2VybmVsLm9yZy9yL2NvdmVyLjE3OTQyMTUxMjgu
Z2l0LngtcHJvZmVzc29yQG91dGxvb2suY29tLwoKVGVzdGVkIG9uIHg4Nl82NCB3aXRoIEtBU0FO
LCBQUk9WRV9MT0NLSU5HLCBERUJVR19BVE9NSUNfU0xFRVAsIExPQ0tERVAsCk1ELCBhbmQgUkFJ
RDQ1NiBlbmFibGVkOgoKICAqIHBlci1jb21taXQgVz0xIGJ1aWxkcyBmb3IgYm90aCBjb21taXRz
OwogICogZmFpbGVkIFBQTCBkaXNrIGFkZGl0aW9uLCB3aGljaCByZWFjaGVzIERPTkUgb24gdGhl
IHYyIHRpcDsKICAqIHVucHJvbW90ZWQgcmVwbGFjZW1lbnQgcmVtb3ZhbCwgd2hpY2ggcmVhY2hl
cyBQQVNTIGFuZCBET05FIG9uIHRoZQogICAgdjIgdGlwLCB3aXRoIHRyYWNpbmcgb2JzZXJ2aW5n
IGBwcGxfd3JpdGVfc3RyaXBlKClgIGFuZCBhIHN1Y2Nlc3NmdWwKICAgIHJldHVybiBkdXJpbmcg
YSBzdWJzZXF1ZW50IGFycmF5IHdyaXRlOwogICogdGhlIHNocmluayBjb21wYXJpc29uLCB3aGVy
ZSB0aGUgc2VudCB2MSByZW1haW5zIGF0IHNsb3QgMyBhZnRlcgogICAgdGhyZWUgcmVtb3ZlIGF0
dGVtcHRzIHdoaWxlIHYyIHJlbW92ZXMgdGhlIHNsb3Qgb24gdGhlIGZpcnN0IGF0dGVtcHQ7CiAg
KiBlbXB0eS1oZWFkZXIgYC1FSU9gIGluamVjdGlvbiB3aGlsZSBhZGRpbmcgYSBzcGFyZSwgd2hl
cmUgYHNsb3Q9MGAKICAgIHJldHVybnMgYW4gZXJyb3IsIGxlYXZlcyB0aGUgc2xvdCB1bmFzc2ln
bmVkLCByZXN0b3JlcyBgcHBsX3NpemVgLCBhbmQKICAgIGxlYXZlcyB0aGUgZGVncmFkZWQgYXJy
YXkgd3JpdGFibGUuCgpUaGUgcnVudGltZSB0ZXN0cyB1c2UgbmF0aXZlIG1ldGFkYXRhIDEuMi4g
SU1TTSBleHRlcm5hbCBtZXRhZGF0YSB3YXMgbm90CnJ1bi4gVGhlIGVtcHR5LWhlYWRlciBmYWls
dXJlIHVzZXMgYSBkZWRpY2F0ZWQga2VybmVsIHdpdGgKYENPTkZJR19GQUlMX01BS0VfUkVRVUVT
VGAgZW5hYmxlZDsgdGhlIHNlcGFyYXRlIHBhZ2UtYWxsb2NhdGlvbiBgLUVOT01FTWAKaW5qZWN0
aW9uIHdhcyBub3QgcnVuLgoKWWluZ2ppZSBXYW5nICgyKToKICBtZC9yYWlkNTogcm9sbCBiYWNr
IGZhaWxlZCBQUEwgZGlzayBhZGRpdGlvbnMKICBtZC9yYWlkNTogcHJlc2VydmUgYWN0aXZlIFBQ
TCBsb2cgd2hlbiByZW1vdmluZyBhIHJlcGxhY2VtZW50CgogZHJpdmVycy9tZC9yYWlkNS1wcGwu
YyB8IDExICsrKysrKysrKystCiBkcml2ZXJzL21kL3JhaWQ1LmMgICAgIHwgMTMgKysrKysrKysr
LS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoK
CmJhc2UtY29tbWl0OiA0N2UxYjE4ZjM4ZDc0MDE1Y2I5ZmQzMGI1ZmYyYTFlYjg4ZTc3ZDMxCi0t
IAoyLjQzLjAKCg==
