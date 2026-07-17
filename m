Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021087.outbound.protection.outlook.com [52.101.65.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3893C3B71D6
	for <linux-raid@vger.kernel.org>; Fri, 17 Jul 2026 06:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784270552; cv=fail; b=OOQGRXcpOFe8RngHyiUFkpJ60CQl4j7/Jtl8AYK8Hk1xEIevBHiCQkZqKfN4NmPEFmvUvcjD+u/LeQIwuuQ7hFfIBDnksFzUxyIpcqwY0vWkNxqv2rivjTcjQKDu0kctNlSZVZ/UBkQ76JalAfFXf9dDWwPHd5Ix7oqpV0Y3Gz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784270552; c=relaxed/simple;
	bh=niWZEeMUcCR/4fulDzHJfs6/ZEGZ8c0MNvmrLnBEJfY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ozIQf3WEgmqt+wKvPtSwWoLULN1cx2dvtkKcZHDFd3GD3ZU/CBNh4XetJMrW0hrIyhY1h99mcA65P2LCeUWTwChbt/bxs73yRFb2hxBO/BHOjVLkv4cp73Jnn8QXtMalCh5mORSj6E1kGoAUS+GMNcpfxglmkOf4ieTToyAf41I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl; spf=pass smtp.mailfrom=hunenet.nl; dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b=e4Jpt0zc; arc=fail smtp.client-ip=52.101.65.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b="e4Jpt0zc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YBzNRzo2745HegENVkUhYIvP00yvA1oszXiFqhwcKm74fTfSYpjMl8Q46BGPPPpNo31GBgULu6yKhJbwvn8JA4vOYitgMaP02xI2VWhxmnlksLiTn7VS3XN4PuYJP1l6RzckdJqsOb6recdvzvzxoqTaO5lQN+ot8qCSuPL72DQLYA+tDSR540Qfu3qtva/Per3zjMIqwVzOTX/zW66W1Y03nCOKvb+K3FvN0U5sbSeRxYgKyGtsMX6ItOUX7Pl/8RmfWFbOonRo3SKuMfQAbehWRqo57wfQzcBc6izi4nyYV452kSkwsA3Mr5gXwqm28jQw9zSEBX4G6yVAXZJ4lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=niWZEeMUcCR/4fulDzHJfs6/ZEGZ8c0MNvmrLnBEJfY=;
 b=y+kd/NgnTKdL5s7dHwoCInjNT/PCNxR5qw59whRZAQBhF0sv1sAk6xsduMAMDryoP6iCahLRcEMQjyfQUT4q9rYmAd7Pm2/2GxNPzMxmhM14PYsSP3Ouk5Pn2D3QrQ82fF1kMLa+PAn8mKOJFlC7czB5meaHRd02KNfCIiViAwy2nKsWkgmx2TnUkvOR4dFCbHCY8gbm6uhrQnV8z2uSHInUp1h0kCuG0sh/kX2LOu3s1cc/gy83WTPfFVtMg13h2DTD/3Hr9B2A0tcKosODdYYmXdMrqlb1ry8+nDIC0lbZ75cxZdZPHDvG1ttDDPOXG7VybDJsEEcI/9uDQkgF6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hunenet.nl; dmarc=pass action=none header.from=hunenet.nl;
 dkim=pass header.d=hunenet.nl; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hunenet.nl;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=niWZEeMUcCR/4fulDzHJfs6/ZEGZ8c0MNvmrLnBEJfY=;
 b=e4Jpt0zcbgQpG5NVV3s2zoKVrSHxj/tclqanA3GNq/6xg/EyeFY4KSwfIkozy8Sw+VHpBHX1pE/pXqYkWjG3dCCGf7R6D1Opr3g70aXlh4ZiG7a5O+OPQC3gfhlEbShosTMEIdiYdPJtdqnXR9ckA8cJ6YgsB2A8q15dDhs7X4zJniM2bMSKkCzVH5iF2t7NMPGHp2v5CwCfAUhZ2ElE8lpsiViO7xUhuLFRgseMO2Zb8HNuGh0zhmeTWWgKf8ErXNSza2cUaQAjVYoFY5pIIzLEnVwVtGHOrNBdjgneAW41NpIArDdPJeU4OYLopUf83ufkwJIxCKqnihzc4OXXNw==
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com (2603:10a6:803:e8::33)
 by GVXPR05MB11176.eurprd05.prod.outlook.com (2603:10a6:150:14a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 06:42:12 +0000
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5]) by VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5%5]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 06:42:12 +0000
From: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "yukuai@fygo.io"
	<yukuai@fygo.io>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
Thread-Topic: Subject: RFC: Read repair for md RAID1 after mirror read
 failures
Thread-Index: AQHdFAT9gXN+3UMPxEiBW2BLzju2krZuDRaAgACTK4CAADoKgIAABn6AgAJl+AA=
Date: Fri, 17 Jul 2026 06:42:12 +0000
Message-ID: <59fa3f9f-eda1-4f8a-917d-8f6612639a1b@hunenet.nl>
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
 <m2y0fcesbe.fsf@gmail.com> <cff97a09-ee38-4785-9a45-1fd562fbaf5e@hunenet.nl>
 <m2jyqwduba.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
 <m2ech4dt8k.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
In-Reply-To: <m2ech4dt8k.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
Accept-Language: nl-NL, en-US
Content-Language: nl-NL
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hunenet.nl;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR05MB6144:EE_|GVXPR05MB11176:EE_
x-ms-office365-filtering-correlation-id: 30567c08-d169-4d48-c543-08dee3ce8878
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10067099003|4143699003|6133799003|56012099006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 9Ty3Zd40vmIsR9Rsc/F5wZDXqS8ekLlDp63rbplOOzDfwog5jug3QbsYEUYFEPJqIkz3COJuIBR1ns758tAQ35fZsViv2Nb78zdn4vp0UTB/hcrQtvOBrfxXIHpuXclMKa9IKdHeV4owr+PATafZBtSPyy6L9Oly18K3ABLzMoc/ycrw32q+ETlgi6lOitNDWZSBa8Bq3BMsH+Jjz/tjpRWqY4DzGSeIqM4+ivNYYkoS1s5ROesl5xQKONDVhsleC8BeDOP3F/34Kvbo8HPp+LB6hBBULOKbDmj5eqhf0X5JRl6+ISpFbLr7qaphmRYgyMZUHYzKJgnttUy6lZjrWxU5bpP5drRI5wKSwNqr5A8TpFZ9hKsGYciGbp2+K6xixcL6eYHg79ll5mnsXdBHPI5Uf2QUf09CRtUXxaL1GnsGTrfcP+tvkTJrBo1wcmRh89AsVIj4hYhAQMiMyNiwEBP5gKTlc9CIqP1LpKpgzHQGODm7OGZjpOEw/e5yuZniYvTkfN+MF5OZZ5AMSUETgILXwzxhFjJTiEjcKAlTEfv4tXUIX/Hs4Fye0/FS1qhqcT5NKLHCLWB0itm5PShe1hgBjN3pzC8z5qePHCFvoqIi6hYHvHG3zuP3NGcLt0fYl91ggWzCEeNEM0UyV5LoIhMAwSgX5GuAqWmxv9UFF/4JMUNoInDwbL8fkNDaevplX4Axjo39dSxgWRnDfMjXFl2JkUT6KM3cNJPb2qkbuO0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB6144.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10067099003)(4143699003)(6133799003)(56012099006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YTQ1OFBmVTlvVjFObFNoalZvRFUvZmhtTk4wbjJhNXpGekNPRms2M1h2U1dW?=
 =?utf-8?B?UWt6WmZIcjl4NEFvVWJGaU1FOU1zN3JtUXhGSE0yQWYvSXAzdmhidjhjZTdK?=
 =?utf-8?B?NjI0RVVMZEMxZ0toa2tKWUo3amUvOFB1T0kvUi95aDRyWGphTml6YktBTkFl?=
 =?utf-8?B?OWp1OWROakpoMTFxSzBaWCs2Uy9wZWxaaW5IYUM4WWdOeXpSZkNuVjZ2aURX?=
 =?utf-8?B?QnFwREtjNUJITXVHcXNaUXp4SFpXbEtIN2NJSXF1TlBiTExsT2dsZkdUUGd5?=
 =?utf-8?B?bVdUNllIdzNEd3Y1cTBXTzlGYldhNDhyZlY4R0dVeGFtTmhQWXNlQ29nZFVq?=
 =?utf-8?B?QXlaaUdnZDhoMEJidDhuM05PdkJ3U3FGQThKWjRxeWtva1k0eE83TTVhc0dn?=
 =?utf-8?B?Zi9yaXgzS0dPMk54MVJmMVh4Mzl3WElrcE5VM3JFS2M2dkY5WEZhRHZtZDUz?=
 =?utf-8?B?YzRiUjlPdUVCWWx0TG1KeGRrczd3QzJIU0dXTERKeTl1RkVnRCtETFVxRjZS?=
 =?utf-8?B?Tjd0SkRrRyt2NkVkcFFub2FCYVZzUFpNMDE2Y1l2S1JEWnB1eHpvZExlMEFt?=
 =?utf-8?B?MG1xeCtkai9kTE10VEtRZy9STDYzRHpHSDA4QlZQMks4ajRqeGNRWHNwNGcy?=
 =?utf-8?B?V01IOGREbitDblFuLzI3cHRzeXdHckZXR3hmWGkzWkt6SzFXQ3hiTWdOZks2?=
 =?utf-8?B?SHBJNUJaWjVOdUJVTlA0MFcyV1N6RzBaTlNqd1JHNTc3aEl5L1dWR3psWTVF?=
 =?utf-8?B?OTlOM0lXbC8zdk0ybExXQzFkNTlIaW1vWkI2K0J3Z1hFWWxrMlNNYS8zKzQx?=
 =?utf-8?B?SktIclkxQmtVTHE2N3l6T0lnN2gxbFVNUUFScWRGbUlOb2NWNXRPQWkxUmsv?=
 =?utf-8?B?SDl1dk54bG9VRVE3Z21UUy9zMkFsWUcraU5pY2NTWHdLVXdDVzZVc2R2ODNo?=
 =?utf-8?B?eUFtNDc1Mm5ZdEpmUUpOQzNsaHA3MXVJa0kxTENnUk5Iamd4NGdObzg4Q09k?=
 =?utf-8?B?Ni9NRGRJYnYvNDJGV3NPc2dnS09zWXBqSGI0Y2UxdmZyb21QZFJqbmRwN1ZE?=
 =?utf-8?B?bE85YThHT0xwWHR4RllIbm9zSUhlQkJGOGpZS0xpQTRxSWM5MDgvRzc3M0pN?=
 =?utf-8?B?WTB2d3VJL2tZT2hJbzhHNWo2K2ora2RrNk1BZXBLMW1SZ0xNTVYyalZQWjc1?=
 =?utf-8?B?NzI1QTM4UEU2TTU2Uk00d0g5a2JzZGJvYlMycFloWUI3UHFwVitsQXhXbFFm?=
 =?utf-8?B?Wkljb2k0dk1pb0M2RGl0NGMzVzZpc3JqcWd3eEpSdUhVN3FsSXY0SWE0Z2tE?=
 =?utf-8?B?VHlMNzRFNEF0RHRYRVBjTWJ1MVZJK3RKdVlGbWFUMVl0UjMyRURld0E4VkRX?=
 =?utf-8?B?Sk1zeEdNY3F2Vm1VS1F1aVczTE83bUdIMm0xUjJ1MExJaFBqUzdzOE8yeklu?=
 =?utf-8?B?Y3dQd0lSbHlxd2lFNHJ4aHF4VmM4WmVuR3RFcWxYUEZVaVVuUlVidkJCTUpN?=
 =?utf-8?B?S29Ia1R2Nk9uUVpId3dCb0pWbWVZQmZCNGIzS2pNN3NLN0tXVGxYcnlaM3BY?=
 =?utf-8?B?RXZJTHhRU1I1emlHOFNkSWxhenFqTndGWm9xYVZtTWIvMWNTVlRoSldQUGYy?=
 =?utf-8?B?dllYSjg3VjhSMnhqSWtJSyszYWNkeS9kOUFpSERVaFBodlVISG9Qc044YVYw?=
 =?utf-8?B?ZDJVdWlnaGtVREhuaDZKYitrdjdTemd5dU9qU256a1lvTUV3anVaZjRhc2Ji?=
 =?utf-8?B?NlhSb0hHNDcrZzVET1pMWWtwWTk3UTBMTWg5cTN0cXNGZ3ZIc3Z3ZE1EZTFk?=
 =?utf-8?B?cUdZZ1lCb0FiYUw3bzZna1lKRFltWE02SXl3dUpIdkdER3ZaY3c5ZFRLT2cx?=
 =?utf-8?B?aGt5NC9VQytYdVdkR09HQlI3L2xrOTc2N0dFMzgyc05vZ0F3UWxrVkxvRy9K?=
 =?utf-8?B?VDJBZVZhMk10VzRkb0lLb0wrSW05ZDh2aVNqbVYzMDVEaXBQQkNQZFpzaUsy?=
 =?utf-8?B?bjUzRjNRRlRRUXgvQjVZcGZveVBHS0pvQzBJalMyUXczZXIydzQzWXlvYzdC?=
 =?utf-8?B?MVhJR3NsSUhhNzJjbU0xZVI2a1ZFR3lNSXFRTHIxZFNSaHRvM2F5Q2V3ZlVF?=
 =?utf-8?B?MzhzdjZtOUh2TlZpc3RsNnFQZGYrODZucFQzY1h5amJERWdScGpJTi8wbjM1?=
 =?utf-8?B?dFdOai9CaHVZbG1QSjJpRjlsYTM2VldlUEt2QXl2ZC9mdDQ5YmV6TXc0WFBl?=
 =?utf-8?B?MjRIUkVaV3hYNmVZZVpORkVVUm9FVllvVncxd1JFS0t6OUZaTmRoZ2FqWUlF?=
 =?utf-8?Q?SHHFf3pFjgP6Avmc2z?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71B5D2AE2CFAB4499588BBF9BFE6B47A@eurprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 30567c08-d169-4d48-c543-08dee3ce8878
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2026 06:42:12.5433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 887aa16f-e08f-4cfb-bc70-8f3f25a72a41
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j5SnztAMCuO8brarBBuy14VS2lY1PLvlSvahFaBqCqKfPD7YLde3j63cy0BueAvtMIutLw7gcTjZblZP7UN2pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR05MB11176

T24gNy8xNS8yNiA4OjA0IFBNLCBBYmQtQWxyaG1hbiBNYXNhbGtoaSB3cm90ZToNCj4gT24gV2Vk
LCBKdWwgMTUsIDIwMjYgYXQgMTk6NDEgKzAyMDAsIEFiZC1BbHJobWFuIE1hc2Fsa2hpIHdyb3Rl
Og0KPj4gSGkgRGlvbiwNCj4+DQo+PiBPbiBXZWQsIEp1bCAxNSwgMjAyNiBhdCAxNDoxMyArMDAw
MCwgRy4gVy4gS2FudCB3cm90ZToNCj4+PiBIaSBBYmQsDQo+Pj4NCj4+PiBPbiA3LzE1LzI2IDc6
MjcgQU0sIEFiZC1BbHJobWFuIE1hc2Fsa2hpIHdyb3RlOg0KPj4+Pj4gV2l0aCB0b2RheSdzIDE4
4oCTMjQgVEIgSEREcyBhbmQgYmFja3VwL2FyY2hpdmUgd29ya2xvYWRzLCB3aGVyZSBkYXRhIG1h
eQ0KPj4+Pj4gcmVtYWluIHVuY2hhbmdlZCBmb3IgeWVhcnMsIGxhdGVudCBtZWRpYSBkZWdyYWRh
dGlvbiBzZWVtcyBpbmNyZWFzaW5nbHkNCj4+Pj4+IHJlbGV2YW50LiBBIHN1Y2Nlc3NmdWwgcmVh
ZCBmcm9tIHRoZSBhbHRlcm5hdGUgbWlycm9yIG1heSBiZSBvbmUgb2YgdGhlDQo+Pj4+PiBsYXN0
IG9wcG9ydHVuaXRpZXMgdG8gcmVmcmVzaCBzdWNoIGEgc2VjdG9yIGJlZm9yZSBpdCBiZWNvbWVz
DQo+Pj4+PiBwZXJtYW5lbnRseSB1bnJlYWRhYmxlLg0KPj4+Pj4NCj4+Pj4gQW5kIENoZWNrL1Jl
cGFpciBpcyB0aGUgcmlnaHQgZGVmZW5zZSBmb3IgY29sZCBhcmNoaXZhbCBkYXRhIG9uIGxhcmdl
DQo+Pj4+IGRyaXZlcy4NCj4+Pg0KPj4+DQo+Pj4gSSBoYXZlIGJlZW4gbG9va2luZyBpbnRvIHlv
dXIgc3VnZ2VzdGlvbiB0aGF0IHBlcmlvZGljIGNoZWNrL3JlcGFpciBpcw0KPj4+IHRoZSBhcHBy
b3ByaWF0ZSBkZWZlbnNlIGZvciBjb2xkIGFyY2hpdmFsIGRhdGEgb24gbGFyZ2UgZHJpdmVzLg0K
Pj4+DQo+Pj4gQmVmb3JlIEkgc3RhcnQgcmVhZGluZyB0aGUgcmVzeW5jIGNvZGUsIEkgd291bGQg
bGlrZSB0byBtYWtlIHN1cmUgSQ0KPj4+IHVuZGVyc3RhbmQgd2hhdCByZXBhaXIgYWN0dWFsbHkg
ZG9lcy4NCj4+Pg0KPj4+IFN1cHBvc2UgYWxsIG1pcnJvcnMgcmVhZCBzdWNjZXNzZnVsbHkgYW5k
IGNvbnRhaW4gaWRlbnRpY2FsIGRhdGEuIEluDQo+Pj4gb3RoZXIgd29yZHMsIHRoZXJlIGFyZSBu
byByZWFkIGVycm9ycyBhbmQgbm8gbWlzbWF0Y2hlcy4NCj4+Pg0KPj4+IERvZXMgcmVwYWlyIHNp
bXBseSB2ZXJpZnkgdGhlIGRhdGEgYW5kIG1vdmUgb24sIG9yIGRvZXMgaXQgYWxzbyByZXdyaXRl
DQo+Pj4gZWFjaCBzdWNjZXNzZnVsbHkgcmVhZCBibG9jayB0byB0aGUgY29ycmVzcG9uZGluZyBM
QkEgb24gZXZlcnkgbWlycm9yPw0KPj4+DQo+Pj4gVGhlIGRpc3RpbmN0aW9uIGlzIGltcG9ydGFu
dCBmb3Igd2hhdCBJIGhhdmUgaW4gbWluZC4NCj4+Pg0KPj4+IE15IGNvbmNlcm4gaXMgbm90IHJl
Y292ZXJ5IGZyb20gYW4gZXhpc3RpbmcgcmVhZCBlcnJvcuKAlHRoYXQgaXMgYWxyZWFkeQ0KPj4+
IGhhbmRsZWQgYnkgZml4X3JlYWRfZXJyb3IoKeKAlGJ1dCByYXRoZXIgdGhlIGxvbmctdGVybSBh
Z2luZyBvZiBjb2xkDQo+Pj4gbWFnbmV0aWMgcmVjb3JkaW5ncy4NCj4+Pg0KPj4+IElmIGEgc2Vj
dG9yIGlzIHN0aWxsIHJlYWRhYmxlIHRvZGF5IGJ1dCBpcyBhcHByb2FjaGluZyB0aGUgcG9pbnQg
d2hlcmUNCj4+PiB0aGUgZHJpdmUncyBFQ0Mgd2lsbCBldmVudHVhbGx5IG5vIGxvbmdlciBiZSBh
YmxlIHRvIHJlY29uc3RydWN0IGl0LA0KPj4+IHRoZW4gYSBzdWNjZXNzZnVsIHJld3JpdGUgd291
bGQgZWZmZWN0aXZlbHkgZXN0YWJsaXNoIGEgbmV3ICJ3cml0ZSB0aW1lIg0KPj4+IGZvciB0aGF0
IHNlY3Rvci4gSWYgdGhlIGRyaXZlIGNhbiBubyBsb25nZXIgcmVsaWFibHkgc3RvcmUgdGhlIGRh
dGEgYXQNCj4+PiB0aGF0IGxvY2F0aW9uLCB0aGUgcmV3cml0ZSB3b3VsZCBhbHNvIGdpdmUgdGhl
IGZpcm13YXJlIGFuIG9wcG9ydHVuaXR5DQo+Pj4gdG8gcmVtYXAgdGhlIHNlY3Rvci4NCj4+Pg0K
Pj4+IFNvIG15IHF1ZXN0aW9uIGlzIGVzc2VudGlhbGx5Og0KPj4+DQo+Pj4gRG9lcyByZXBhaXIg
cGVyZm9ybSBzdWNoIGEgcmV3cml0ZSBvZiBzdWNjZXNzZnVsbHkgcmVhZCBibG9ja3MsIG9yIGRv
ZXMNCj4+PiBpdCBvbmx5IHJld3JpdGUgYmxvY2tzIHdoZW4gYSByZWFkIGVycm9yIG9yIG1pc21h
dGNoIGhhcyBhbHJlYWR5IGJlZW4NCj4+PiBkZXRlY3RlZD8NCj4+Pg0KPj4gT2theSwgSSBzZWUg
d2hhdCB5b3UncmUgZ2V0dGluZyBhdCBub3cuIE5vLCBjaGVjay9yZXBhaXIgd29uJ3QgcmV3cml0
ZQ0KPj4gc2VjdG9ycyB0aGF0IGFyZSByZWFkIHN1Y2Nlc3NmdWxseSBhbmQgbWF0Y2ggYWNyb3Nz
IGFsbCBtaXJyb3JzLiBJdCBvbmx5DQo+PiByZXdyaXRlcyBkYXRhIHdoZW4gaXQgZW5jb3VudGVy
cyBhIG1pc21hdGNoIG9yIG5lZWRzIHRvIHJlY292ZXIgZnJvbSBhDQo+PiByZWFkIGVycm9yLg0K
Pj4NCj4+IEkgdGhpbmsgYSBmdWxsLWFycmF5IG1lZGlhIHJlZnJlc2ggaXMgYSByZWFzb25hYmxl
IGlkZWEuIGJ1dCB0byBteQ0KPj4ga25vd2xlZGdlLCBtb2Rlcm4gZHJpdmVzIGFscmVhZHkgcGVy
Zm9ybSBiYWNrZ3JvdW5kIG1lZGlhIHNjYW5zIHRoYXQNCj4+IHJlZnJlc2ggb3IgcmVtYXAgbWFy
Z2luYWwgc2VjdG9ycywgd2hpY2ggY292ZXJzIHBhcnQgb2YgdGhpcy4uLg0KPj4NCj4gDQo+IEkn
bSBub3QgZW50aXJlbHkgc3VyZSBhYm91dCB0aGUgbWVkaWEgcmVmcmVzaCBwYXJ0IG9uIG1vZGVy
biBkcml2ZXMuLi4sDQo+IEknbGwgaGF2ZSB0byBsb29rIGludG8gdGhhdCBmaXJzdC4NCj4gDQoN
Ck1heWJlLCB3ZSBjb3VsZCBhc2sgdGhlIHNtYXJ0bW9udG9vbHMgcGVvcGxlIGFib3V0IHRoaXMu
IFRoZXkgc2hvdWxkIA0Ka25vdyB0aGlzLiBCdXQgSSBoYXZlIG5ldmVyIHJlYWQgYWJvdXQgYSBy
ZWZyZXNoIGFjdGlvbiBpbiB0aGVpciANCmRvY3VtZW50YXRpb24uDQoNCkJlc3QgcmVnYXJkcywN
Cg0KRGlvbg0K
