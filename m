Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023096.outbound.protection.outlook.com [40.107.162.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2C2314D35
	for <linux-raid@vger.kernel.org>; Fri, 17 Jul 2026 15:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303291; cv=fail; b=ZwdUgb3UaovrEUpWZF2zyJHLzQjGLR70a9hdw8ioD6MqYkbME+irFHTttbXC/jslGltLZLdrfOLvr/6pBYv443qGYSYJSwgmQ4p7A0yLsXEFtKMUdXjXVHoRkHnV7qeLhs/1XlAvsq45F1Fhwf8iB4haBync496lmv+1RSrOn9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303291; c=relaxed/simple;
	bh=5mhUZDtK/X4AWAw7MBPBHaunq0MEDsjI8XYHtlFWlOI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IXSN/5epRlpVc+IgNkPl3cufDUid9B1GRewTQQ/HlMripAuoDLoeWuZFE6cXQ+twPN6TeByNAqBjad8StTNI+ma7T37FV/WDZQd8JJSF8edFGLGPkOJVJ5yHDvBAmlz7XqhCarbRknI274t3kA1220HqsfINjvd44TJgONNmAMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl; spf=pass smtp.mailfrom=hunenet.nl; dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b=jnzNH3CO; arc=fail smtp.client-ip=40.107.162.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b="jnzNH3CO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bz8a+JuorXkwoGqocm6XlxZehd5gHOKqNvvGC/a/FKhiJr3vw3oRvY0xkzffwaYiXxpESt/7XYEA1J+C5BccnGP/oufaNkOM/fXJmC4kKCMUEX+WtyfpWrEiWnkt7XEX48T8IUbOmIBU3nsThedQNK3v0NVDYHAAzOK8jBFLs3fo6CkvfF2v3b/XP/BsHKRtbFP1lnSL+vJxvAYjAVl/rcwJJ3xKDljBmRYShXSZDhv4oWoneL3WapjNkIAQ0JpQtgw1OxP8R7um8RrQ2S7EbjfSECQnWK1M+A7YW6iQh4m2ktk/XPz6/CMmS92qMYgXK8jqmrU4kkyb358wpHklGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mhUZDtK/X4AWAw7MBPBHaunq0MEDsjI8XYHtlFWlOI=;
 b=gexoeVlUj8nkKVwsHcFrGJ3OzYuOF56l6Dgwf4m2Q47edRmQRGKeKlr8jAfusHXeQGRRpkI9kIakG2Bf9r7bu/+ehlBpuwQiMdc6Qdi5AzEuVP36YZk3uA55kP0Rmz1CxCiYKEDp9fmbOxVmadsDVQbG53GZy22r0hSaJXsinC3CWBUGhouk+vc80O1qMEs670Zu6ASD7oBDR/5dLAoWXbI+n8Yf+9GeQwi6KDDE8ljE5KaJu7EsbGUxrkWCsM1zjL4JBFdCdbrt89ImhIYOCHpq5g4ond2cAyk7hDUvqO0j0/hy505Fc17rW1McKb7LK4ZWkUu6FzXu5fFgt4OqpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hunenet.nl; dmarc=pass action=none header.from=hunenet.nl;
 dkim=pass header.d=hunenet.nl; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hunenet.nl;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mhUZDtK/X4AWAw7MBPBHaunq0MEDsjI8XYHtlFWlOI=;
 b=jnzNH3CONXWDnD0C0BAy1gbC98iSyfPzkGrpOEW53TI+YOMd9R+NL2U4cVMF0K+/aKaX5dVg0ifgHlrFcTDWuttz5bJ2mHjLS4xKraP3cH90oGk1uEP8bh3bvjDrTdBfWI4yen8GeJza9HnBR92rWuzBTNQa1f9nHCbG2hmQtJ23IseIRuMNezH47V8yNvz0qA1gUWKqhOp6O+8U5PBi5MSZ4W4HORMil5hmtA22+jrveitGUv84KO2H2nlup9/AYlCSXAgSs5hqNacJqNRz5bFH3FhDtExsOO2f02q+2+c3GNY9QHmLklZij1LLzQLqb8cIipVb40Pzbf2avn69Jg==
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com (2603:10a6:803:e8::33)
 by GVXPR05MB11556.eurprd05.prod.outlook.com (2603:10a6:150:1c1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.13; Fri, 17 Jul
 2026 15:48:03 +0000
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5]) by VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5%5]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 15:48:03 +0000
From: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>
To: Roger Heflin <rogerheflin@gmail.com>
CC: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "yukuai@fygo.io"
	<yukuai@fygo.io>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
Thread-Topic: Subject: RFC: Read repair for md RAID1 after mirror read
 failures
Thread-Index:
 AQHdFAT9gXN+3UMPxEiBW2BLzju2krZuDRaAgACTK4CAADoKgIAABn6AgAJl+ACAAEbMAIAAUbUA
Date: Fri, 17 Jul 2026 15:48:02 +0000
Message-ID: <fd1f940e-4382-4a8a-9d16-e70a708da3cb@hunenet.nl>
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
 <m2y0fcesbe.fsf@gmail.com> <cff97a09-ee38-4785-9a45-1fd562fbaf5e@hunenet.nl>
 <m2jyqwduba.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
 <m2ech4dt8k.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
 <59fa3f9f-eda1-4f8a-917d-8f6612639a1b@hunenet.nl>
 <CAAMCDeefBEP0c4oW3iX4_cbZBLDuyfuAtCREtFgiH-qS4ZaiXQ@mail.gmail.com>
In-Reply-To:
 <CAAMCDeefBEP0c4oW3iX4_cbZBLDuyfuAtCREtFgiH-qS4ZaiXQ@mail.gmail.com>
Accept-Language: nl-NL, en-US
Content-Language: nl-NL
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hunenet.nl;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR05MB6144:EE_|GVXPR05MB11556:EE_
x-ms-office365-filtering-correlation-id: 6cba605a-a2e6-439e-4af8-08dee41ac93b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|23010399003|1800799024|366016|38070700021|6133799003|5023799004|56012099006|10067099003|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 HhZm9ELZXWKvi3s975oV8HSiOS3DPh5BwU/69jG4iUQ5LYPxYJt2tDEYUvLLzQ5n1xodlTqykFiF9Z3WqqeLxcC5Y3Jgnrcn+GHySzME8uJApTG02++v3gAredHLvuoxpCuVqgIlchIPv+/OkrJoLsUqk3aoWeqRrBnB7oHL5YKPS8ZmKrVyP72SXU8dJYXBp3TAyi83DsPRlh3YIYNpUb9VDQ7HHFQTFx1UTL4UKeyWPpdJ0OK609av8anppx9pM1SB0UPTbbTLu/+uf/I/iRCQl9fCStk6Mn89YjozfVvGyzaTmJrhz1KJLIDAoWiRmI4wHHO32Yf05Jt1KluWhRoP7LbUowqVO9ENc1yFp+Cw/imXq2BgicCo9TzrvI+bGmyoxtdTr1NIQPgq23aYWg6BB3S5Gjira0fjZ+8rEXjO+o3zh2O+G57Q/7OwlaOpxV/KUn7ZnDz2Nm54ZUCltf26PAdZSU2ESxH43xKZS+DuGh63CpCxaFJGDSn1uL1doT/yJ/MzfOezWYfzIWFPgBvRSmroAgTh8FGIFN6H+PDdK3f4MzFxoNvTL8SIb4g0+blJrRzy6oQbC32LAlsZMWeOm/bA3zGq2RNmuiFcni3IlvSASWnkTnFONrT8t7cupMV/TLJ3LixnVwoahJ9a8P6OpTPLFRQzWAS98+9ljli94Kx8GONN+i4Ukl9bpTg7sWux2fFvhNOtUKw7xH9ehCC2ubnkdsVNIcfIQhtd++E=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB6144.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(23010399003)(1800799024)(366016)(38070700021)(6133799003)(5023799004)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bUZrMmFtSmJWOHZYdVQxMVBoSTZNaC8wUXBnRWQyaWhNMmxJRjhNUC9lMzhP?=
 =?utf-8?B?TnhZQ25YVHN5K3JheGlhdFgxUkdmS3czdW5nT3BVb1NaOGdOcEkxc1prUFQ1?=
 =?utf-8?B?YUN6L0N1Mjc2N1JCL0w1R3lmMnQrcStLRjZUZEM2dyttalpUeFZlMTgwVGoy?=
 =?utf-8?B?Qm03WXdMRk9vcEc2cDZXTTJDSFFzUFVOcHkrTmFFaWFqekh5b1FYTXkybHFl?=
 =?utf-8?B?eUxYYVJtc3pPOWZpSldNRldyaGJQbUQzVVdxd1lMcWdlVnVGZ2diZ1BKWGJr?=
 =?utf-8?B?aGt0WWpzN0hhckZzU2VYeWxOSUFHdGN5UTJNVjJxVk9nZnE3U0VwYS9lSk95?=
 =?utf-8?B?SEZMTGF3eTZ5dmU3T0MweVZDcHZleGNaN2tFM2d0K0tJUFgxWE5SNDgyakZj?=
 =?utf-8?B?RXVHRzc4YWJ5b0lkZWQrR0hlR1ZRcnJYSzZ6R1V1azlMRVNvWUVhWkRnZUlB?=
 =?utf-8?B?Tk9vV1QvOTRDS2xjeUQ5bHlFUTlmSkNpLzR6cjgvSzVUdFlNOHlycmpOTzk0?=
 =?utf-8?B?TE9ZdUFvT3ZFajlzVkNvVGpTZ1RiZEQ5UGgrZWdTelZGUWFPT1JMM1BvN202?=
 =?utf-8?B?TTdVa09yM0ZHai9EMWJZb2tnY2luaFpaYlVuT25yYnhTNHMxeXBYaUJJRVJw?=
 =?utf-8?B?VmZicnB3NzhEbUpjaUNBaDloa282MEF6amxvQncxdENzVmd3S1BGUjY5NUNi?=
 =?utf-8?B?WHZzaENBNWpUL0E1UDBYd2NoWUxOLy9PYTQyUGJpcUc4enBaRFBHMFJQcStJ?=
 =?utf-8?B?Q05RblRKOEFkZUJIOVJaWDJsM0pZNitEZjVYMHRSVzF1RFhvNk5sa25CcDVW?=
 =?utf-8?B?TmVCRGgxV2Q2ZDE3aURsWTg0MTBLeEExZzQxYTFYMVNUc0g4UHhnS01keHQy?=
 =?utf-8?B?bWZaUkJDbndMckJpS0U4ZjBwbkt0MUExKzZpNmduRmhpcGdRS0lIbjQvc3lE?=
 =?utf-8?B?K1U1dVJ6YVhxN1dlSWk1bUltbVFhSzE3WmsvZ2ZCZmRHT1lCR3JON2V2dUxH?=
 =?utf-8?B?THBFc2FzQVdYaEJJaVc4UzBzU2dSL2xhTzQwa1orOVpuT1RibE5CYkJwMEJG?=
 =?utf-8?B?WVkyLzlLY2VKeHJBQXNuT1EyT2RYek1HVGRUMUlzNkRaVUM4aWlpeXNXLzB4?=
 =?utf-8?B?dndudXREMytIZ2ZmMFptbGpwUTBSaGpuUnVMdzQwWk1yVHUzd1BOK2tSdkha?=
 =?utf-8?B?dFZJQUQ5cm02Rzd1akc0TG1lam9DT2d4WHRrbHNiVWgvL0xBSlRrbzFJUnFY?=
 =?utf-8?B?VFM2L2Q1Z0xKZ1RYSlJkTnFTcmF6bnY5eGRtMU1oYzNSaVA1RzRDVlZlQ09j?=
 =?utf-8?B?NVVBclhHQkVFK0NValFZWEh4eUV1eWR6Tkt3YnhkdjVHWW5ocmpXbXJ3YXNP?=
 =?utf-8?B?MXpLTWNlMml6T3dZWkV6WFZReGV2dWRiWDZJNVY0bGpvMzdHcFBDT01jTkVh?=
 =?utf-8?B?dzdZSGtlRUt2VmE4ZVB1VHZpb2ZJcEY4WkkrYldwTUk3WXl3L21NTjJOb1BY?=
 =?utf-8?B?MEh3T3Q5aHlhcmsvbTBSTGZidnZQRDk0VkcyS2pYVzl4cGNIdld2WXZEV2U5?=
 =?utf-8?B?U0tJdzIxMUkyTWFXM1VCczh4U1B3S1R5YjVKTlFJZ1Rnd040MzZEYXF2K3dB?=
 =?utf-8?B?cmUwTnFMdjBKU1VqQ0ZyM3FEa2p4VmVZRysvcG5tQTVKR1dQMUhReW93K2tk?=
 =?utf-8?B?UVJvbElBNk5BMk1RU21kNVJGZkpWRTdoODlOSkpOOHRraVNPSFBpSDJJVU0x?=
 =?utf-8?B?d0ZmWlc4dmxjK3M4VDNpdmVKSDJOZEM4d0EwRzNrSGV1UG1qeDY4SkJNVVhu?=
 =?utf-8?B?TmFnOFVzd2FPa1hqb3FVcHd2RFJEUGg4RlFsWFFCYlI2djRIZWtvM3pNOW1z?=
 =?utf-8?B?OWNhMjUyNWlaWUMxUCtnK0VJV3Q0ZWc2UHg2ZkMrYnZiN1J0NWttNWRXcXdS?=
 =?utf-8?B?SUtOWHB1L2ZJcDBzT05UVUZEeHpWUU8xNGc1SThVdVNLOEwyaDdrQjJQbTE1?=
 =?utf-8?B?TGJidUsvdGIxV25XWkRKaC9IalZ0YU10bHlXY0Y1WjhzRXVWaWRsUkprd08v?=
 =?utf-8?B?dEg2OUp0QWowWDJSU0pzcmx6dmJTaWtVa29WYzgvN0Q1REtaTmNxZVByWEcy?=
 =?utf-8?B?bWRRcEtJTi9GVElrb3ZzdVZybTZlK2NrWFMza0RhNjRQQ21WTVpvQktpdzdW?=
 =?utf-8?B?WWNpb3dSanorUDBnZUFoQ3pkSUZwSUNRT3Raa0VjS0tmZ0orNmpBcXN3YnhT?=
 =?utf-8?B?RHdZdnNsdllNU0lzUFRWdU10M0NMQXV2RzVFZjF3dUNpSHNGdE1FOTdvOUpX?=
 =?utf-8?B?QmorQTNwZE1QQzUweEVES0tSdGVtTnUwb2psZ3pvMmdjNE9QWnBwd0JkZFBS?=
 =?utf-8?Q?2q0z/0AFRsmBl5AiDQKDTzkN1Fa5PMymxkTbu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1BE98FD8F052C46B73B5500D22A4904@eurprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cba605a-a2e6-439e-4af8-08dee41ac93b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2026 15:48:02.9092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 887aa16f-e08f-4cfb-bc70-8f3f25a72a41
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7UP9HwKRIsUwQlPY3MIz/Q8KD5IPb5n1JBbKQKlthkIcGKcAYeGxI8WygMM8CbUaJCFvRiWNGOcdCbAGwY+09g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR05MB11556

T24gNy8xNy8yNiAxMjo1NSBQTSwgUm9nZXIgSGVmbGluIHdyb3RlOg0KPiBPbiBGcmksIEp1bCAx
NywgMjAyNiBhdCAxOjQy4oCvQU0gRy5XLiBLYW50IC0gSHVuZW5ldCBCLlYuDQo+IDxnLncua2Fu
dEBodW5lbmV0Lm5sPiB3cm90ZToNCj4+DQo+PiBPbiA3LzE1LzI2IDg6MDQgUE0sIEFiZC1BbHJo
bWFuIE1hc2Fsa2hpIHdyb3RlOg0KPj4+IE9uIFdlZCwgSnVsIDE1LCAyMDI2IGF0IDE5OjQxICsw
MjAwLCBBYmQtQWxyaG1hbiBNYXNhbGtoaSB3cm90ZToNCj4+Pj4gSGkgRGlvbiwNCj4+Pj4NCj4+
Pg0KPj4+IEknbSBub3QgZW50aXJlbHkgc3VyZSBhYm91dCB0aGUgbWVkaWEgcmVmcmVzaCBwYXJ0
IG9uIG1vZGVybiBkcml2ZXMuLi4sDQo+Pj4gSSdsbCBoYXZlIHRvIGxvb2sgaW50byB0aGF0IGZp
cnN0Lg0KPj4+DQo+Pg0KPj4gTWF5YmUsIHdlIGNvdWxkIGFzayB0aGUgc21hcnRtb250b29scyBw
ZW9wbGUgYWJvdXQgdGhpcy4gVGhleSBzaG91bGQNCj4+IGtub3cgdGhpcy4gQnV0IEkgaGF2ZSBu
ZXZlciByZWFkIGFib3V0IGEgcmVmcmVzaCBhY3Rpb24gaW4gdGhlaXINCj4+IGRvY3VtZW50YXRp
b24uDQo+Pg0KPj4gQmVzdCByZWdhcmRzLA0KPj4NCj4+IERpb24NCj4gDQo+IEkgYW0gbm90IHN1
cmUgd2h5IHlvdSBiZWxpZXZlIHRoZSBzbWFydG1vbnRvb2xzIHBlb3BsZSB3b3VsZCBoYXZlIEFO
WQ0KPiBpZGVhIGFib3V0IHRoZSByZWZyZXNoIGFjdGlvbi4gIFNtYXJ0bW9udG9vbHMgc2ltcGx5
IGV4cG9zZXMgdGhlDQo+IGludGVybmFsIGRyaXZlIGNvdW50ZXJzIHRoYXQgdGhlIGRyaXZlIG1h
bnVmYWN0dXJlciBleHBvc2VzIGFuZC9vcg0KPiBkb2N1bWVudHMuDQo+IA0KPiBUaGUgcmVmcmVz
aCBhY3Rpb24gaXMgMTAwJSBlbnRpcmVseSBjb250cm9sbGVkIGJ5IHRoZSBkcml2ZSdzIGZpcm13
YXJlDQo+IGFuZCBoYXMgbm90aGluZyB0byBkbyB3aXRoIHRoZSBzbWFydG1vbnRvb2xzLCBhbmQg
dGhlIHNtYXJ0IGNvdW50ZXJzDQo+IG1heSBub3Qgc2hvdyBhbnkgb2YgdGhlIGludGVybmFsIEVD
QyBmb3JjZWQgcmV3cml0ZXMuDQo+IA0KPiBBcyBmYXIgYXMgSSBjYW4gdGVsbCBpbiBnZW5lcmFs
IHRoZSBkcml2ZSBkb2VzIHdoYXQgaXQgd2FudHMgdG8NCj4gKHJlZnJlc2ggb3Igbm90LCByZWxv
Y2F0aW9uIGJhZCBzZWN0b3JzIG9yIG5vdCkgYW5kIHRoZXJlIGlzIE5PIHdheQ0KPiB0aGF0IEkg
aGF2ZSBldmVyIGZvdW5kIHRvIGZvcmNlIHRoZSBmaXJtd2FyZSBkbyBkbyBzb21ldGhpbmcgZWxz
ZS4NCg0KV2hlbiB5b3UgcmVmZXIgdG8gInRoZSByZWZyZXNoIGFjdGlvbiIsIGFyZSB5b3UgcmVm
ZXJyaW5nIHRvIGEgDQpkb2N1bWVudGVkIGZpcm13YXJlIG1lY2hhbmlzbSB0aGF0IHBlcmlvZGlj
YWxseSByZXdyaXRlcyBzdWNjZXNzZnVsbHkgDQpyZWFkYWJsZSBzZWN0b3JzLCBvciBhcmUgeW91
IHVzaW5nIHRoZSB0ZXJtIG1vcmUgZ2VuZXJhbGx5IGZvciBhbnkgDQppbnRlcm5hbCBtZWRpYSBt
YWludGVuYW5jZSB0aGUgZHJpdmUgbWF5IHBlcmZvcm0/DQoNCkkgaGF2ZSBub3QgeWV0IGZvdW5k
IGRvY3VtZW50YXRpb24gZGVzY3JpYmluZyBzdWNoIGEgcmVmcmVzaCBtZWNoYW5pc20gDQpmb3Ig
Y29tbW9kaXR5IEhERHMuIFRoYXQgaXMgd2h5IEkgbWVudGlvbmVkIHRoZSBzbWFydG1vbnRvb2xz
IA0KZGV2ZWxvcGVyczogbm90IGJlY2F1c2UgSSBleHBlY3Qgc21hcnRtb250b29scyB0byBpbXBs
ZW1lbnQgb3IgY29udHJvbCANCnN1Y2ggYSBtZWNoYW5pc20sIGJ1dCBiZWNhdXNlIHRoZXkgYXJl
IGZhbWlsaWFyIHdpdGggdGhlIGNhcGFiaWxpdGllcyANCnRoYXQgbW9kZXJuIGRyaXZlcyBleHBv
c2UgdGhyb3VnaCBTTUFSVCBhbmQgcmVsYXRlZCBzdGFuZGFyZHMuDQoNCkknbSB0cnlpbmcgdG8g
dW5kZXJzdGFuZCB3aGF0IGlzIHB1YmxpY2x5IGtub3duIGFib3V0IHRoaXMuDQoNCkJlc3QgcmVn
YXJkcywNCg0KRGlvbiBLYW50DQoNCg==
