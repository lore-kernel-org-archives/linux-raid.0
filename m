Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022108.outbound.protection.outlook.com [52.101.43.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9C240B11C
	for <linux-raid@vger.kernel.org>; Thu, 15 Oct 2026 21:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099616; cv=fail; b=kFz+JD1H9AQ220wWKp4VTfFfEw7369N3UMGj7Q/WUJ31TvNHKTPwKgaf0SjtqPryEpk5WGta0ERjNdzk3xI96na/u9rnsEcYjGJbdfiFuithZOWubjnytg5yOfrz/EAmOkOmVsOJB8MMAZbZ37pwpM/lb7aV3CWJlE22Ub3l5s4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099616; c=relaxed/simple;
	bh=TXAB0cT4Ml9F45IXNRJd7ERP/qWE5RdtoCLG1QsolXs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kc2nKWhMnXCxmPzr2g5mqvGvo203rFiMgdkmNDc+lPX6YPm55hRJ8eK8BCwhZqe8F703qe8uiEVocaZB/dHphA6nrBqWg2Kd6AtUAdyzFZr5pSxcAwHRup531iAIag9L2NeAYirR/xNLnp3FEbxObZh7oi4qfQwe7zscgVgT2h8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu; spf=pass smtp.mailfrom=gatech.edu; dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b=ncbKhqWs; arc=fail smtp.client-ip=52.101.43.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b="ncbKhqWs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rtRyAbESPzCzJybmHQcW0uhCPJaTL5elI5Tdgt3hVjZltCZoAFD+zDNDTskvQfg0fCEVejsBOonwh6OU5T6vB1etPqCb7VYuLoFHQnKNRBO6S1M9UqYZt3zFH3bSXeFSPXpd1qaOdjOITnsnCZ26vjZ2rW70a6JVTdwrqGNnMS8sddU7F780YZy5x7sE4PlT76nEVxyWhqsoWihXpBayIEcVd/Qx3V2wr3XcEfbtbgJsMzQ7rnKjNXaGyxH/sSrbkxXE41NvxENVDbMZ6HW1TVVZ9g52x9pWqGHVD5XM1EDxyVy0q7PDkhUf0peZBdqjuaWIzwkekI2Y5j7qUt/aQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXAB0cT4Ml9F45IXNRJd7ERP/qWE5RdtoCLG1QsolXs=;
 b=jbzmaM3NQR/HQy03hRN2xk/XRpekQ/Z9mQzFRMiHSP9FmHdv54Jv+olluFp2lJ1HGFVcS1Peoe0nPm8pBKSq4bnzJ5PjGmxrTzzAqieDq46aLCEHzR61FqOLLaJaiFJk+kMTYdcgcA1aU3l47HO5t0Uai6q0sqqbFxBbKkTiYXj8fRfhAVBO6Cm2d0/V3CbyCe/2hufPy2fFgTQdPXGwkkKJE3GbiWIp2fM61sj9AULw7IcpJ0IAagnm4XO0990trY4MgoCG1uv3bAGZ74dWI4UW1pK44FOwLWvYUVAuot+urDijhIMLqXqj8qj6fkSdbR+wA6qGvXpkO/oDtikiOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXAB0cT4Ml9F45IXNRJd7ERP/qWE5RdtoCLG1QsolXs=;
 b=ncbKhqWsK1SQzP3lH+/ImRzjal3WfoctpIUq4p2KZ1uAuUCj2hzNaSAmQf4eF4h9Tf/FN97PgzlORIETOgq1R87wjeg77BNceaD7WwMYVwaYTbZPGap6yMZnuJWzsxjDUCGrk567IVsy3CKCi4k91TkXEQbH9jv7MHMsCAqRPKnqskHLoLncTU2+MBw6N7e3l44UeITVVnqmZdxXlihvO/ROV/TVsTbPj9r5i4vtEBfVgH627h+Gk5LOMWnoMOhbHzbN+QpyH51+DEFBjzJP7z2zf+14xkmLub3jg7KqPZZdRn8CT+0KS1g/JHqciLoh0rSg6Lu9qB3H0tSpFaQKHQ==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by BLAPR07MB8354.namprd07.prod.outlook.com (2603:10b6:208:331::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Thu, 15 Oct
 2026 21:26:51 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 21:26:51 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"yukuai@fygo.io" <yukuai@fygo.io>
Subject: Re: [RFC PATCH v4 1/4] md: add uapi definitions for the md control
 device
Thread-Topic: [RFC PATCH v4 1/4] md: add uapi definitions for the md control
 device
Thread-Index: AQHdXOZ34eMoUnosXEyOBRuypH8AnLb/FSsAgAAIzQA=
Date: Thu, 15 Oct 2026 21:26:51 +0000
Message-ID: <m2a4oe4puv.fsf@gmail.com>
References: <20261015204640.1184848-1-abd.masalkhi@gatech.edu>
 <20261015204640.1184848-2-abd.masalkhi@gatech.edu>
 <sashiko-outbox-173415@kernel.org>
In-Reply-To: <sashiko-outbox-173415@kernel.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gatech.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR07MB9958:EE_|BLAPR07MB8354:EE_
x-ms-office365-filtering-correlation-id: f31f7d5c-841c-4b16-505e-08df2b03070a
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|786006|1800799024|23010399003|4143699003|56012099006|11063799006|38070700021|18002099003|22082099003|4133799003|261009223027099003|3023799007|10067099003;
x-microsoft-antispam-message-info:
 HtTGXvoyuRCJIIXvah9IqgD0k+g2XNFTls46/HRvZ+Ebh3+YtFe4DxSC6ku8nvQdV0KZe0+YtFVhzquBC1HLa7D9SAOOx0X9JYGOhbMWjydVCKVDmnipFwFzKhvZe0o9K8kE/K628cEb7fVwrT3aSQg17ikYSjY44yy97Hu5XqWGSBg8Dm52ydhCt8liorBO3BiCVwlrsJe178xzqygfDGYg4RsJUCTnJ/M+dK+jXtVPbGW7ax4vXuuPZm7b38GLfDowp+7PRMxtMG+F4/rOmDU7asPEa/S2EgUBb7zZgHGKfdjjwuA9E2Uia6LzGKxJvXhiK/rKbPrghI5cjI8qwv+qRJxI1CWThifT8NkzyUZ4eJp6/9j5/L8DtS4K2LCQn0xmrYpkZeP3jg9IhTD72Hg0WM49Z3V02ShrOBw/kPXPfN7mqZNPGHDs8Y1pgDDHGixVp5HTEFFwMfWb5sFe+nt594siuDhTw6o6MiFI7n+7IR0aPl09DHlQXjJYuSkCKDjr4KPo8ge7/ObUNeFEiF9gaZ3KevIcEnnkGvwfnh6vyYeQ6DW7e1W9LX+hL/OLobICQJGe11GRh/N7oWhIft4CZwNArSJP4DsCLlNQcfVx3AngssXyIE5avBrZmvypZOAZuW7Dc86Re2agU/1qekKCUX0V5nqBefU5brd1f8c=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(786006)(1800799024)(23010399003)(4143699003)(56012099006)(11063799006)(38070700021)(18002099003)(22082099003)(4133799003)(261009223027099003)(3023799007)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZllnY1BzWkNqVVNWQStrRGJBUDRxd3F6QlN6SVVFMmlIVUJBV0x4T0h4SnBw?=
 =?utf-8?B?bjNid3FnMzhjY0FDUkhpNnB2LzRFZ2t6V3c4UXp2RW5pLzlTczlOeGdWY0p5?=
 =?utf-8?B?V0xNZEtTdmtMU01MQmF0NDJhMkc1TTZkWmY1ZTUrWkRDcmNGK01oYXEwaEp4?=
 =?utf-8?B?YklnL1RpOGNRVjl3Qk91ZktuY2VQU1F0dnJZdXFwVFZudWpNNndJOWVxRWRW?=
 =?utf-8?B?R1VTTXpXaUQ3TnUvUG4wMzJMbHl2RkRXcWJjVnlCa2JYakFnNDFneFVnZHlF?=
 =?utf-8?B?a1FFV25wQ3EyNldBR1RMRWVNNlpiTDA0L2szSUFkcm1hRWlQSER5aFowc21v?=
 =?utf-8?B?K1RacGZOb3lFZTBVTmQ1MFJtZ2g3S2pNNEZ1K0haT2E3Vy9wZ3hqT1JxSDFM?=
 =?utf-8?B?TS9uR0k2TEhFc1NEOUZaSHpMSUwvQkRpcThGeko5ajR6OUdWMVZnMFlVUW9v?=
 =?utf-8?B?ZGNvWHoySXRVR2hQaldRU1JhWjVEWmxOdFdybUdPNEthczRmS2ZxL1ZTQkVN?=
 =?utf-8?B?dVJyeXF4MXViWnMrNVdBU2EwV25TUzVHeUNYUEgzZnE2Mms5bmY3bWpJQVdK?=
 =?utf-8?B?cVVseE1sb1hONGFudTJQKytHRG1TN3RwNjF5YTVqcE1nTVlRcndWZGdaaVBS?=
 =?utf-8?B?R05ZVkp4ZjAzUWkxMWJaMDRMYUhoWVIvYVJteHV1eGRyME9TalgycWZmSWRY?=
 =?utf-8?B?emxtZkpXc3JLVWUwV05vMmZJMGsyaDBYSVVTT2svTVUzczVFQTQ0ZHZ1SFAr?=
 =?utf-8?B?bms4K093YVUvV1BiS2FrNTUyajEvMHFuQmxHcjl6MTNQVjVtZnNLR1lteTdJ?=
 =?utf-8?B?eVF2a3FxNlN4Y0pPNTRuMytXQnhiQjFhWkZCZ2p3VW1hVVU0Sk9ncnk1NWdW?=
 =?utf-8?B?ODVmMUc3d0RGc3p2ajBGNnkzN082TnlSUDdpenliS0hRUWtoWTRmQm1LWVo5?=
 =?utf-8?B?OVg4cE4yYkVSVGdWNWFBTVByQW1JMFE5SnNYeU5LN0RyaGdHNS85T0pCQlhV?=
 =?utf-8?B?VWFRTU9tMUwxZXJKMkZJdFl2c0xpVHlUQkhNcVJxR1plejhhMkwya1ZtNGdo?=
 =?utf-8?B?aDNWSDF4b0kyRFFlc3BaaVk3U3dTYkdpMXRlK1JkYWJRQ1hVNVNRbXJYQ3VW?=
 =?utf-8?B?ZzM3WGMvQWZXSkVQVEw1aStSN3c4czRza2ZJSVp4V00vQTMyaW9xLys5QjJh?=
 =?utf-8?B?Wjd5V1ZheVMxL1FYZ0NDK2JLZHRuU3p6NkE1Nk1FbnF2aVhlWi9JdktmbWla?=
 =?utf-8?B?ZlVBcEJYWDRlZi9EemwxdW50MkIxOC9KZjRrdnJDdE91VlBNWGs3TFdjeGNj?=
 =?utf-8?B?djBEQWlpakhSakxaSFVHaW9QVUcvR08ycVd4eUgrRDk0dTJuVGQ5OHhKQWJX?=
 =?utf-8?B?QStDbW9NQ001NGx5S0ZmRFhmamhTUVJrZ01ScHhEb2FkcUVoWGFFNmRTZ3dD?=
 =?utf-8?B?bEpPS3lLdndkbmR2VHJOQ3pCVEhYSmhqVlM4aEJWK2VZNHRmY01ORHVXWFhv?=
 =?utf-8?B?enZETHB4b2hwdUpselRzcE5NbVQ0WGVocE5TdS9GbnduVnJaSFpMd1VRRmRy?=
 =?utf-8?B?U1dRQ0lHZjB5akQrY2RrZHJ4Y1BaajU5cDFhM3BLS2xJMk83WHhpU3FxQWZR?=
 =?utf-8?B?ZWMxWjV3UVJySExuejFGcFpkSkJkZ1l5aXZHR05TdW4yUUNPMEUyUHplVndV?=
 =?utf-8?B?SDhZdDNNd3hRRGRraFJ6VjNaN05tWVdUc1dZTXZkRCs4OFRVanl4T3cxdk1x?=
 =?utf-8?B?amQrVWtFVzJNNk5qVDdWQ1hRWmsyc2Q0OTJDQ1RMdjFHcFhaR1dqR0J2ZVZJ?=
 =?utf-8?B?WlZzanN0bFVWakVIaC9mNFhlZHhlVm5YMHBsbVFvbE1Qb3RpS0JoZC81d1o2?=
 =?utf-8?B?d2NkL3l0cUdBa1ZDT3paaElqRGthSmZUU2RUSk03MjZhT0lHT0VQVjh6Y1lD?=
 =?utf-8?B?N09NN1dsditVVjl1YzJXZzFSZXpiMmlUMXhlOGtwaTNOQngrNnlLZlgwbGRG?=
 =?utf-8?B?VlhiT080WnJNRS9Ld2VpZmU3eHRvck5HL3gxTDJGbFpacWlZSndIbGFsU2xJ?=
 =?utf-8?B?Zzh3Ky9rV2l5WHh1SHZuU2pXVkI3NmMzd0hJdEpLaVhDRFF2cE50ODVyTi9L?=
 =?utf-8?B?N0VhVEZuMzczTDUvOTN1a04reXUyQlZxMWRaNVl6SkJIeExlK0JzNk1DK2NQ?=
 =?utf-8?B?MURaaXJkQjdzM0JBN0hXV0ZZcW9tUkNlWmtwb1FKeExxVlgzUXIxaXBqb2NP?=
 =?utf-8?B?eTZlUjhFOHA4ZHV3NDJmRHNMWFNjclVLNHdEMDFJeUNtTlZNTjVBU0R2b1M3?=
 =?utf-8?B?azhBenNHSnRudEpEcGhtc0hqZ0R2NmNLanZvN1d2eTdpQXdYa2sxUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <560679C81838974C977AE48F8655609D@namprd07.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f31f7d5c-841c-4b16-505e-08df2b03070a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 21:26:51.1764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BaMWAeZ97E0Q3lP9nIHcrtcuKY3JjXeCiMsbAJ34Xo8DRgHYjdm07nylQvLmaPFMKg9IpEzMu2PRFxTPJpMk4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR07MB8354

SGkgS3VhaSwKCk9uIFRodSwgT2N0IDE1LCAyMDI2IGF0IDIwOjU1ICswMDAwLCBzYXNoaWtvLWJv
dEBrZXJuZWwub3JnIHdyb3RlOgo+IFtZb3UgZG9uJ3Qgb2Z0ZW4gZ2V0IGVtYWlsIGZyb20gc2Fz
aGlrby1ib3RAa2VybmVsLm9yZy4gTGVhcm4gd2h5IHRoaXMgaXM9bXBvcnRhbnQgYXQgaHR0cHM6
Ly9ha2EubXMvTGVhcm5BYm91dFNlbmRlcklkZW50aWZpY2F0aW9uIF0KPgo+IFRoYW5rIHlvdSBm
b3IgeW91ciBjb250cmlidXRpb24hIFNhc2hpa28gQUkgcmV2aWV3IGZvdW5kIDEgcG90ZW50aWFs
IGlzc3U9KHMpIHRvIGNvbnNpZGVyOgo+IC0gW01lZGl1bV0gbWQ6IGltcGxpY2l0IDQwOTYtYnl0
ZSBidWZmZXIgY29udHJhY3QgaW4gbmV3IE1EX0NUTF9HRVRfQklUTUE9X0ZJTEUgVUFQSQo+IC0t
Cj4KPiBjb21taXQgMDRjYWJmZWE2NmRlZjFkOTExMzZhZGI3YWZmZjdjMWIyYzcwZDY2OQo+IEF1
dGhvcjogQWJkLUFscmhtYW4gTWFzYWxraGkgPGFiZC5tYXNhbGtoaUBnYXRlY2guZWR1Pgo+Cj4g
bWQ6IGFkZCB1YXBpIGRlZmluaXRpb25zIGZvciB0aGUgbWQgY29udHJvbCBkZXZpY2UKPgo+IEFk
ZCB0aGUgaW9jdGwgY29tbWFuZHMgYW5kIHN0cnVjdHVyZXMgZm9yIC9kZXYvbWQtY29udHJvbCwg
YSBtaXNjIGRldmljZQo+IHRoYXQgbWFuYWdlcyBtZCBhcnJheXMgd2l0aG91dCBvcGVuaW5nIHRo
ZSBtZCBibG9jayBkZXZpY2UuIFRoZSBkZXZpY2UKPiBpdHNlbGYgaXMgYWRkZWQgaW4gdGhlIG5l
eHQgcGF0Y2guCj4KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9yYWlkL21kX3Uu
aCBiL2luY2x1ZGUvdWFwaS9saW51eC9yYWlkL21kPXUuaAo+PiBpbmRleCBhODkzMDEwNzM1ZmJh
Li5mNWE4NDYwNWI2NzcyIDEwMDY0NAo+PiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvcmFpZC9t
ZF91LmgKPj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L3JhaWQvbWRfdS5oCj4gWyAuLi4gXQo+
PiBAQCAtMTQ2LDQgKzE3NCw5MCBAQCB0eXBlZGVmIHN0cnVjdCBtZHVfcGFyYW1fcwo+PiAgICAg
ICBpbnQgICAgICAgICAgICAgICAgICAgICBtYXhfZmF1bHQ7ICAgICAgLyogdW51c2VkIGZvciBu
b3cgKi8KPj4gIH0gbWR1X3BhcmFtX3Q7Cj4+Cj4+ICsvKiBzdHJ1Y3R1cmVzIGZvciB0aGUgTUQg
bWlzYyBjb250cm9sIGRyaXZlciAqLwo+IFsgLi4uIF0KPj4gK3N0cnVjdCBtZHVfaW9jdGwgewo+
PiArICAgICBjaGFyIG5hbWVbTURfTkFNRV9MRU5dOwo+PiArICAgICBjaGFyIHV1aWRbTURfVVVJ
RF9MRU5dOwo+PiArICAgICBfX3U2NCBkZXY7Cj4+ICsgICAgIF9fdTMyIGZsYWdzOwo+PiArICAg
ICBfX3UzMiBwYWRkaW5nOwo+PiArICAgICB1bmlvbiB7Cj4+ICsgICAgICAgICAgICAgX191NjQg
YXJyYXk7Cj4+ICsgICAgICAgICAgICAgX191NjQgZGlzazsKPj4gKyAgICAgICAgICAgICBfX3U2
NCBwYXJhbTsKPj4gKyAgICAgICAgICAgICBfX3U2NCBiaXRtYXBfZmlsZTsKPgo+IFtTZXZlcml0
eTogTWVkaXVtXQo+IERvZXMgdGhpcyBpbXBsaWNpdCA0MDk2LWJ5dGUgYnVmZmVyIGNvbnRyYWN0
IHJpc2sgdXNlci1zcGFjZSBtZW1vcnkKPiBjb3JydXB0aW9uPwo+Cj4gTG9va2luZyBhdCB0aGUg
bmV3IFVBUEkgc3RydWN0LCBpdCBkZWZpbmVzIGEgZ2VuZXJpYyBwb2ludGVyIGZvciB0aGUgYml0
bT1wCj4gZmlsZSBwYXRoIGJ1dCBsYWNrcyBhIGxlbmd0aCBmaWVsZCBvciBhbiBhc3NvY2lhdGVk
IHR5cGVkIHBheWxvYWQgc3RydWN0dT1lLgo+Cj4gV2hlbiBhIHVzZXItc3BhY2UgYXBwbGljYXRp
b24gY2FsbHMgdGhlIG5ldyBNRF9DVExfR0VUX0JJVE1BUF9GSUxFIGlvY3RsID1pdGgKPiBhIHN0
YW5kYXJkIGR5bmFtaWNhbGx5IGFsbG9jYXRlZCBzdHJpbmcgYnVmZmVyLCB0aGUgaW9jdGwgaGFu
ZGxlciBkaXJlY3RseQo+IHBhc3NlcyB0aGUgZ2VuZXJpYyB1c2VyIHBvaW50ZXIgdG8gZ2V0X2Jp
dG1hcF9maWxlKCk6Cj4KPiBkcml2ZXJzL21kL21kLmM6bWRjdGxfaW9jdGwoKSB7Cj4gICAgIC4u
Lgo+ICAgICAgICAgY2FzZSBNRF9DVExfR0VUX0JJVE1BUF9GSUxFOgo+ICAgICAgICAgICAgICAg
ICBlcnIgPSBnZXRfYml0bWFwX2ZpbGUobWRkZXYsIGFyZyk7Cj4gICAgICAgICAgICAgICAgIGdv
dG8gb3V0Owo+ICAgICAuLi4KPiB9Cj4KPiBUaGUga2VybmVsIGJsaW5kbHkgY29waWVzIHNpemVv
ZihtZHVfYml0bWFwX2ZpbGVfdCkgKDQwOTYgYnl0ZXMpIHRvIHRoZSB1PWVyCj4gcG9pbnRlciB3
aXRob3V0IHZhbGlkYXRpbmcgdGhlIGJ1ZmZlcidzIGNhcGFjaXR5Ogo+Cj4gZHJpdmVycy9tZC9t
ZC5jOmdldF9iaXRtYXBfZmlsZSgpIHsKPiAgICAgLi4uCj4gICAgICAgICBpZiAoZXJyID09IDAg
JiYKPiAgICAgICAgICAgICBjb3B5X3RvX3VzZXIoYXJnLCBmaWxlLCBzaXplb2YoKmZpbGUpKSkK
PiAgICAgICAgICAgICAgICAgZXJyID0gLUVGQVVMVDsKPiAgICAgLi4uCj4gfQo+Cj4gV2l0aG91
dCBhbiBleHBsaWNpdCBzaXplIHBhcmFtZXRlciBvciBhIGRlZGljYXRlZCBzdHJ1Y3R1cmUgdG8g
aW5kaWNhdGUgdD1lCj4gZXhwZWN0ZWQgNDA5Ni1ieXRlIHNpemUsIGNhbGxlcnMgYWxsb2NhdGlu
ZyBhIHNtYWxsZXIgYnVmZmVyIGNvdWxkIGZhY2UKPiBtZW1vcnkgY29ycnVwdGlvbi4KCk1EX0NU
TF9HRVRfQklUTUFQX0ZJTEUgZXhwZWN0cyBiaXRtYXBfZmlsZSB0byBwb2ludCB0byBtZHVfYml0
bWFwX2ZpbGVfdAooNDA5NiBieXRlcyksIGp1c3QgYXMgdGhlIG9sZCBHRVRfQklUTUFQX0ZJTEUu
IEEgY2FsbGVyIHRoYXQgcGFzc2VzIGEKc21hbGxlciBidWZmZXIgaXMgbWlzdXNpbmcgdGhlIEFQ
SSwgYW5kIHRoZSBrZXJuZWwgc2lkZSBpcyBzYWZlIGVpdGhlcgp3YXkuCgo+Cj4+ICsgICAgICAg
ICAgICAgX191NjQgYXJnOwo+PiArICAgICB9Owo+PiArfTsKPj4gKwo+PiArLyoKPj4gKyAqIElm
IHNldCwgTURfU1RPUF9BUlJBWSB3aWxsIHN3aXRjaCB0aGUgYXJyYXkgdG8gcmVhZC1vbmx5IG1v
ZGUgaW5zdGVhZAo+PiArICogb2YgZnVsbHkgc3RvcHBpbmcgaXQuCj4+ICsgKi8KPj4gKyNkZWZp
bmUgTURfQ1RMX1JPX0ZMQUcgICAgICAgICAgICAgICgxdSA8PCAwKQo+PiArCj4+ICAjZW5kaWYg
LyogX1VBUElfTURfVV9IICovCj4KPiAtLQo+IFNhc2hpa28gQUkgcmV2aWV3IMK3IGh0dHBzOi8v
bmFtMTIuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vPz1ybD1odHRwcyUzQSUyRiUy
RnNhc2hpa28uZGV2JTJGJTIzJTJGcGF0Y2hzZXQlMkYyMDI2MTAxNTIwNDY0MC4xMTg0ODQ4LTE9
YWJkLm1hc2Fsa2hpJTQwZ2F0ZWNoLmVkdSUzRnBhcnQlM0QxJmRhdGE9MDUlN0MwMiU3Q2FiZC5t
YXNhbGtoaSU0MGdhdGVjPS5lZHUlN0M0MDAxYTFhYmVlYWQ0NTBlOTVjYzA4ZGYyYWZlOWZlNCU3
QzQ4MjE5OGJiYWU3YjRiMjU4YjdhNmQ3ZjMyZmFhMDgzPTdDMSU3QzAlN0M2MzkyNzY5NDUyMzM1
NjAyOTglN0NVbmtub3duJTdDVFdGcGJHWnNiM2Q4ZXlKRmJYQjBlVTFoY0draU9uUnlkPVVzSWxZ
aU9pSXdMakF1TURBd01DSXNJbEFpT2lKWGFXNHpNaUlzSWtGT0lqb2lUV0ZwYkNJc0lsZFVJam95
ZlElM0QlM0QlN0MwPTdDJTdDJTdDJnNkYXRhPXdUTWpaY2F1TjY1ZnRmOWZmclNoQTZMTEVxdzE0
ekJRVTJuTHFwYkZUd28lM0QmcmVzZXJ2ZWQ9M0QwCgotLSAKQmVzdCBSZWdhcmRzLApBYmQtQWxy
aG1hbgo=
