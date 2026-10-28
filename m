Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.122
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793191955;
	b=3d2KAc6BpTVRvQSUwC8W+8dGdMjGLpJLT78kOQhq6lrXWzcqLbokEyX1/Vi8HejyOdrr
	 P/HCTsqAmbrECvieI7cp3nNT0s7A8gCgppqShdpZoGEiHejPg4n0XqwIB+uUR7w/iSq4k
	 TfcoMsR4phbMDweNhsZwpM/EP5RNk3EHn1E/pvXz7VjasO/pG5A0bUGc03uNAETNPHmrk
	 ndjfmLJBeleDXmyHqemkHkULSLetxkkFZizwuvnzEPAJTy0CRXWc5G0ScK9+N5f6bSuZ4
	 zgyBoRtreGXSbhkKNibVIYCHEBKmaI4Yf486mHxHMYbgjp2cM0RDpoUzltgFvRAxahA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793191955;
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
	bh=gZkJoYwx8DZjFmj7av7g5Mb7sf+cv0K2s3ylgZaFHRw=;
	b=IylRiV9hv+gFxp48gIQ0WFranzgifaPESAMkFxzFr1GLIV2pj4lZbWCB7Dam16T7W9HS
	 EHx4mWaNaVRR/wze9kLZtAcMNEBb51FqJM62d/NzuUT5Fk77f7BFied/nrLYDEfznOXut
	 oUg9Bpr/YhxfXxi/IKWyNr3lkRZykp9TjGQzy09nwycPFjDwPeszdCptCjK6wLRuCd+nA
	 FeFRHV6SIAAg+srCGH2qE8bF+UbDxLYphf5mc+hX+QPzMM8LIGBOeM+/H2Lhpjxpl0ep1
	 lciYiMfTHfiGXB2XMM3ib/v/fmV8w23k7kX7rUaZAi7isd04/40IYq92JC24FlXLhHg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gatech.edu;
	spf=pass smtp.mailfrom=gatech.edu;
	dkim=pass header.d=gatech.edu header.i=@gatech.edu header.a=rsa-sha256 header.s=selector2 header.b=y3pUoNKA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.122
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022122.outbound.protection.outlook.com [40.93.195.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D562606A320
	for <linux-raid@vger.kernel.org>; Wed, 28 Oct 2026 12:52:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D562606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gatech.edu header.i=@gatech.edu header.a=rsa-sha256 header.s=selector2 header.b=y3pUoNKA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eDfAS2FD3FOTrrVoX1ahBDAkZW+oIjofT1oiri2era8mJ9BTw79bSpGMawDQuqMSG4QCouR57ObgM1MTZ8d5t0azUlV3jXceFji58pGjHofSFnzxmsHaoOBQ2OpyMo9p/NWEEGXKfOjop7yYp34Q/sgMCZlbiBClevLkF0ZYBUasQd8tmHIHtC9Rf5Rbbj4KJDtEDgROtR2X0jhilZ/27QGkriQ711EnKzhNcUUpxzUv25ETVh4ze5AlFPqDHArJDTSi+W+P8Ulm7l4gR+AwxJkpJIUUQ+pNxncOLGeIgHeLVRFwaiT1Sd9DlDNlVtPZ4ojaiOV56hAYQP4xLJQ4nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZkJoYwx8DZjFmj7av7g5Mb7sf+cv0K2s3ylgZaFHRw=;
 b=O9zITaTl6a3tHFswOz/OvbGNXQONdMurUKEG34hYrp+fmv+HV+/A/zoA1N+KyuEKkOjx2WTFLIPZJTlxmTNI+XGTnAjkSoStnmTo58N3jzZlb28JV+C2hCFH9/FWP0BzBnd3goioOxQjoZPPBKHSpuC9P5KT49TFO2149XCJ1sw1hUDFFSbnktLupwlnhpe50Mt/RGdWFnb3vhnXaJ0xPkFC0xfDxLjD+4LbFhXjq+uoM/az++qf0bqv9ykbC5Y9IUfKjG7OZnKoQpWa7c8m/VvVW60RUCiullOiQZOOQvfN/0uh5+ay7JYBVyRYZClOqVHHYN5eIj7MhLPhzWZwlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZkJoYwx8DZjFmj7av7g5Mb7sf+cv0K2s3ylgZaFHRw=;
 b=y3pUoNKA3j1uMkVbnAS8CXYGuifIXOsABDSuVxfYklGKSVP8taMl9nQhlAULxczGWz3P9Hk4iLdNt1YS1crLotzoELrDWBvnCd7TY/byHox3gKAGNiYn0wIAItjv8o3gXkUpAS1J3dNTVRs529o8DeZkYKA9knvSy9DGq0HrymkxMdNPLBa8eBavLfLl8twavTdHvx9h3iow6LEigEa2MNAkTQHFHju/YdcaU3+mZamf0hwrMb6cpDCJjOqhucDxd5UMX2iaXobONlStu22XVuYvq4PJi5jbqVgjaaHdX7RtfVAHcXadF+hW/PsDx2qumNcV4KGUoCM44owggmpcMw==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by DS0PR07MB11496.namprd07.prod.outlook.com (2603:10b6:8:28c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 12:52:31 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0569.007; Wed, 28 Oct 2026
 12:52:30 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>
CC: "blazej.kucman@graidtech.com" <blazej.kucman@graidtech.com>,
	"ncroxon@redhat.com" <ncroxon@redhat.com>, "xni@redhat.com" <xni@redhat.com>,
	"song@kernel.org" <song@kernel.org>, "yukuai@kernel.org" <yukuai@kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] mdadm: Deprecate the obsolete --auto-detect option
Thread-Topic: [PATCH] mdadm: Deprecate the obsolete --auto-detect option
Thread-Index: AQHdXKWk/Eu9yn3gWkG8xQmEoOcxmbcSvQyAgABACYA=
Date: Wed, 28 Oct 2026 12:52:30 +0000
Message-ID: <m25wym2diq.fsf@gmail.com>
References: <20261015130326.442915-1-abd.masalkhi@gatech.edu>
 <20261028100317.3b964788@kernel.org>
In-Reply-To: <20261028100317.3b964788@kernel.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gatech.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR07MB9958:EE_|DS0PR07MB11496:EE_
x-ms-office365-filtering-correlation-id: 5cfc428a-ad88-4166-fcc2-08df34f25421
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|786006|38070700021|11063799006|4143699003|56012099006|261009223027099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261021121427099003|261021123027099003|10067099003|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info:
 +HC83k0dhXi68WZ5wxWwx1tGTgw4yqCa1Su19HSvplVdERfXCgxamhhp05zeir0sxsFybWbxz17D5EOXSmAy/miOj/OWSVJDKgKte3IaaQmW/ZtbagY+AcX7TltHt1QhYLQYR+hCGZshg4ZXXRMEWNlraeCqoFTR/5FOoa0QSBqwIXawaUGFUTxSYks4UCXHLxFhb5VFV5rIYATzT0EmL9Iqo2AU9RbX2rRco9cQH3Tg5uwGGkDXwTc9yDyfVpY4aHp11gaDC0VngInOzGSZ3T0JiX99ZrN9kO2L/9qsBpfZsePPMi6hPmbpqeH4J1eORTBue2CWXHqfnqQ6IHCTMJZBZyMdSKVFp2gFV6/CYKOP3t3MxmluMdgD3wZrxyKzDmAuoYS7vT233yNwo5cb4c8Oa8nhJ9GICQL/1ecWcifPOsFKa7ogHUjbVRGgr5HY9q9ZkF4RvmJzIlbzsUxbSp+5spQ5Xd2SGQFxIVTDi3PX30e6bkryrAtGmuFl+jRZW1YAGDa5yK3zFLoDt39sy91CsY9eHTH+XRo80EWJLN4YrS14wi9rDbT2u/7KZrjzE1UsiiaGEoDU8ExeOQWSOz6kKhqGF+NnTspA2hf57XiF1JtkLrVAb814/PZx/YzFUfYng7GhlGGPmtn+rDqjDcC9n+2Kvd1Mtgic5mwPUATJBJl31jMRlKn1Ir1OBcoh0dUyyJ8iXovGjQuwJOwBBi3vCHZ4dopv24lTOXdW8oA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(786006)(38070700021)(11063799006)(4143699003)(56012099006)(261009223027099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261021121427099003)(261021123027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RUVoVU5MRURvVDdBVjRrYkZ3aVpxdmd0V1dxcFVaUGVQK21RUDhpWTlJY21i?=
 =?utf-8?B?VWhRWlQxODdQZ2RyWlZoS1pvNWlNTzFiSkNQNEFyUmgvTkdWa1JHSlVRVTN5?=
 =?utf-8?B?M1FkeEk1a1ViTExlckVKYmg3Q3c1K3RDcDBvQzVBYktMdm1XREFnM1AwOHV3?=
 =?utf-8?B?Y0lWYy9mc3MwMnpHYmE5U3MrbjZLUk01ME12M1dUTGtsWWpLNGFvMndkZi92?=
 =?utf-8?B?elNsQUdoOUsxc0NZYks3aGdYZFZKalNYQnFGZXdlOHBFaTg3eXh1Tm9RSzlR?=
 =?utf-8?B?cnlhSWVHUUxuUHJOUUVNakxhRWl1Y1VRU1J6MVl4LzBVQjNKaFRNN042MTBN?=
 =?utf-8?B?OWdLelBDRnkvMkxVVk1wZ0k3MUE2eG40bzY1R2dVTjh3cS8vWFVoM1dneTF4?=
 =?utf-8?B?Szk1Szk2S1FUb1owWmt5aWdkeEJCMGNNVDg3bDBZR1hCYk5vZlB0UU9pOWV4?=
 =?utf-8?B?THBVMFdQNGpFVmoxek1GYm5vaDdDZ1kwRWNLVlpaSms0M1BTZlpqVGp6VUw3?=
 =?utf-8?B?RzVtZXNCcWZCSHNGbVRzMGhEQWVVM0tvMWg0K0xkdUxSNnViSWRraVB1SnJP?=
 =?utf-8?B?ektFdmtYMUIxRWttNHpvdGphZnllaEhtTURLYlpFd3NTNzM1aElkZGNzTWVB?=
 =?utf-8?B?UnRGa2xFODFGcVQ4R1VKc0lOT3haeFM2Z1dvbE4zZGl6SVY0c0VxTnN0QWNm?=
 =?utf-8?B?NTNJamUyTEhDVXFvaXlNWDRqNHJ4eERoVE1SR0t3ZEZMdStSOHk5elVFbGwr?=
 =?utf-8?B?UWZMU1BDUS9kUFVPY2t1aFE0dG9GQVZZa1c0eWVJbDl2TFhVWW5NTUlpdlZa?=
 =?utf-8?B?bFFEeEt3R3Z3Y2d1dXNYOXdiY093RzVwcHB0TFVRZ0x4K0ovRTY5bUgxak5H?=
 =?utf-8?B?TTk2cjVzU3F4bnNVYUQySEJlY0ZUcUQvWWJLamlpcmZ0V1pDRm44V1JhRmVj?=
 =?utf-8?B?UVhMR2htZ0VJSjJMMVZCMWhKY2pqcExaMUtnZ2Z6WWZwbUZLdnFsbGU5NEJF?=
 =?utf-8?B?bXdyUmRpZ2pGWWxEUXh4aGpnZTA2SlZoSmhwYUdxU1lMcUV6UDVBa2VHa3pE?=
 =?utf-8?B?eDF2eHBwTEVQKysydUVFcnp0N0JoczhoSndMaXl6U1hjbENQUm9McXE1YWRx?=
 =?utf-8?B?bTYyR2Z1cnhCcG1DcjB6eEdUR2w0Ri9raks5d1ZETURyWmtyNTcrM3NIZDBL?=
 =?utf-8?B?WkhoenpqMTZ2SDBack14ZFlqWlVFeEszNGc4cXRob1hnSmNLMXNOQkg3S0t4?=
 =?utf-8?B?V29tRmR1NGJqczYzUTBzMUhudVVqdXJSYlVFTnAvYzRWaEM1bWN0eVZ4MzM3?=
 =?utf-8?B?Sy9rWGY2dFhTa2JCdFdTSC9tWmwzZFFqVWV5MTBpcEpSLzlNcjRsU2dFYS9w?=
 =?utf-8?B?TGpNdW1VMC80WGZLU3krL2ZRSkJoaUo5OU1ISVlNaTVJVTJhOGpadTNyb1Zj?=
 =?utf-8?B?bTlRNm1qclNzb3lNQ2puSFB5alhjZzB2ZlRrcE9RWDlUTnFLVGdtem1RZEo1?=
 =?utf-8?B?UnF2aVN3Y253TnpiaFFoY1lFL3ZvOEFIWE9WNHBySzBPYmNzdHJ1V2liMS85?=
 =?utf-8?B?VldEcm84Vk8yUGlLakhMa3ZuTStmSnhsSnhqRHFmRFB2K2VIeFVWdVdIN0N4?=
 =?utf-8?B?UXhNTy9mVnpxUjJaTytzSUdHQ3dMbDhId0t5aUUrR3h0RmlKNFd4UFlodldK?=
 =?utf-8?B?ZWNuYVpBYVVXTEZZcHRDSXJjNE90cjlXOVZRemNwQ1hCdFI5R1RFd0o2b0Zy?=
 =?utf-8?B?K1RMNi9uYjJNeWx0MmZZMGdJa0xxVEhVSVRXU3JNRks0d3NIYzhIK2QzOUpP?=
 =?utf-8?B?R3R4Z0RSU0hmMThuQUxJNzB1YngvZEdqVU1jZGkvUU1jaldGbGNlOXhMOUxv?=
 =?utf-8?B?Uzh0VDhmMzFKS005VUY4TDA2UlNQYTFxNFoyQW9CMnhFVWY4a3dDbjNQaWdO?=
 =?utf-8?B?UG9pbmI4dlFUazJ4VkhPWU02K3AxeHAranZPMmE5MEtBQUJJQkNzNnVpMUVi?=
 =?utf-8?B?WTMvOUt6Zk1WNDF5RzhKanlpdEE5T201U2NHOTZFd3VTSGRmSkdYdXRBTzFP?=
 =?utf-8?B?eWtyajg3aXdVTXpIcEp1cktNNVAyM3NqWHVwY0d1QmdOb0pkOEU5VXE3d3FE?=
 =?utf-8?B?a3BNdE1aZmhDS2RxTTNKd1NsQjY2bW9QYUVaVVczSkhHME1WYTRhbXZmb2t0?=
 =?utf-8?B?cGJPbzViYllPcGZDWnJWZUVWSHlTRnVmY01zWk80V04wR05ONGExKzBYQVBv?=
 =?utf-8?B?ekZodFBuZUJNeEVxeXJBUG1LZ0VQL3lyY2U1eVpVMjBYQVd0dEluWWxKYUpQ?=
 =?utf-8?Q?f/Bi2TNFz8QMWGgQxw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cfc428a-ad88-4166-fcc2-08df34f25421
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2026 12:52:30.7507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vR4+HCTS4vPfEQPkbr9CU0J+WLLfIo6uaXH2UqZ9mBElPx9jOtxVP/3+cogU51UmZyrpdSksLkkWgKzO3JnNCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR07MB11496

SGkgTWFyaXVzeiwKCk9uIFdlZCwgT2N0IDI4LCAyMDI2IGF0IDEwOjAzICswMTAwLCBNYXJpdXN6
IFRrYWN6eWsgd3JvdGU6Cj4gT24gVGh1LCAxNSBPY3QgMjAyNiAxMzowMzo1OSArMDAwMAo+ICJN
YXNhbGtoaSwgQWJkIEFscmhtYW4iIDxhYmQubWFzYWxraGlAZ2F0ZWNoLmVkdT4gd3JvdGU6Cj4K
Pj4gRnJvbTogQWJkLUFscmhtYW4gTWFzYWxraGkgPGFiZC5tYXNhbGtoaUBnYXRlY2guZWR1Pgo+
PiAKPj4gLS1hdXRvLWRldGVjdCBvcGVuZWQgbWQwICg5OjApIGFuZCBpc3N1ZWQgdGhlIFJBSURf
QVVUT1JVTiBpb2N0bCB0bwo+PiBhc2sgdGhlIGtlcm5lbCB0byBzdGFydCB0aGUgYXJyYXlzIGl0
IGhhZCBhdXRvLWRldGVjdGVkLiBUaGUga2VybmVsCj4+IHJlbW92ZWQgdGhpcyBpb2N0bCBpbiBj
b21taXQgZDgyZmE4MWMyMzY0ICgibWQ6IHJlcGxhY2UgdGhlCj4+IFJBSURfQVVUT1JVTiBpb2N0
bCB3aXRoIGEgZGlyZWN0IGZ1bmN0aW9uIGNhbGwiKS4gQmVmb3JlIHRoYXQsIGl0Cj4+IHdvcmtl
ZCBvbmx5IHdoZW4gbWQgd2FzIGJ1aWx0IGludG8gdGhlIGtlcm5lbC4gU2luY2UgdGhlbiwgbWRf
aW9jdGwoKQo+Cj4gUmVkaGF0IHN0aWxsIGJ1aWxkcy1pbiBtZCBpbnRvIGtlcm5lbCBzbyB0aGVy
ZSBpcyBjaGFuY2UgdGhhdCBzb21lb25lCj4gaXMgdXNpbmcgaXQuCj4KPgo+PiBoYXMgcmVqZWN0
ZWQgaXQgd2l0aCBFTk9UVFksIG1ha2luZyAtLWF1dG8tZGV0ZWN0IGluZWZmZWN0aXZlIG9uCj4+
IGN1cnJlbnQga2VybmVscy4KPgo+Cj4gSGVsbG8sCj4gRG8geW91IG1pbmQgdG8gc3VibWl0IGdp
dGh1YiBQUnMgZm9yIG1kYWRtIHBhdGNoZXM/Cj4gaHR0cHM6Ly9naXRodWIuY29tL21kLXJhaWQt
dXRpbGl0aWVzL21kYWRtCj4KClN1cmUsIEkgd2lsbCBzdWJtaXQgdGhlIG5leHQgdmVyc2lvbiBh
cyBhIEdpdEh1YiBwdWxsIHJlcXVlc3QuCgpPbmUgcXVlc3Rpb24sIHNob3VsZCBJIGFsc28gc2Vu
ZCB0aGUgUkZDIHBhdGNoZXMgZm9yIHVwZGF0aW5nIG1kYWRtIHRvCnVzZSB0aGUgbmV3IFVBUEkg
dG8gdGhlIG1haWxpbmcgbGlzdCwgb3IgaXMgc3VibWl0dGluZyBHaXRIdWIgUFJzCnN1ZmZpY2ll
bnQ/Cgo+IG1kYWRtIGNvbW11bml0eSBpcyB0aGUgbW9zdCBhY3RpdmUgb3ZlciB0aGUgZ2l0aHVi
IHRvZGF5Lgo+Cj4gSW5kZWVkLCBpdCBoYXMgYmVlbiByZW1vdmVkIDYgeWVhcnMgYWdvLiBUaGUg
cXVlc3Rpb24gaXMgaWYgNiB5ZWFycyBpcwo+IGVub3VnaCB0byBzdG9wIHN1cHBvcnRpbmcgdGhl
IGNvbmZpZ3VyYXRpb25zIHdpdGggbmV3IG1kYWRtIGFuZCBvbGQKPiBrZXJuZWwuIEkgdGhpbmsg
aXQgaXMgbm90IGVub3VnaC4KPgo+IEkgd291bGQgZG8gdGhhdCBhdCBsZWFzdCAxMCB5ZWFycyBh
ZnRlciBrZXJuZWwgcGFydCByZW1vdmVkLgo+Cj4gV2hhdCBjYW4gYmUgZG9uZSBoZXJlIGlzIHdh
cm5pbmcgYW5kIGltcHJvdmVkIGVycm9yIG1lc3NhZ2Ugc2F5aW5nIHRoYXQKPiAiVGhlIG9wdGlv
biBpcyBkZXByZWNhdGVkIGFuZCBwcm9iYWJseSBpdCBpcyBub3Qgc3VwcG9ydGVkIHdpdGggdGhp
cwo+IGtlcm5lbCIuIElmIHlvdSB3aXNoIHlvdSBjYW4gYmUgbW9yZSBkZXRhaWxlZCBhbmQgYWRk
IHZhbGlkYXRpb24KPiBhZ2FpbnN0IGtlcm5lbCB2ZXJzaW9uIGJ1dCBJIGhhdmUgbm8gaGFyZCBm
ZWVsaW5nIHRvIHRoYXQuIEl0IGlzIG1pbm9yCj4gY2FzZSwgcHJvYmFibHkgbm90IHVzZWQgYmVj
YXVzZSBubyBvbmUgZXZlciBjb21wbGFpbmVkIGFib3V0IHRoZSByZW1vdmVkCj4gaW9jdGwuCj4K
PiBZb3UgY2FuIGxlZnQgc29tZSBUT0RPIG1lc3NhZ2Ugc2F5aW5nIHRoYXQgYWZ0ZXIgMjAzMHkg
aXQgY2FuCj4gcmVtb3ZlZC0gdGhhdCB3b3VsZCBiZSBoZWxwZnVsIGZvciBmdXR1cmUgbWFpbnRh
aW5lcnMuCj4KClRoYW5rcyBmb3IgdGhlIGNsYXJpZmljYXRpb24uIEkgd2lsbCBtYWtlIHRoZSBj
aGFuZ2VzIGFjY29yZGluZ2x5LgoKPiBUaGFua3MsCj4gTWFyaXVzego+Cj4+IAo+PiBSZW1vdmUg
YXV0b2RldGVjdCgpLiBLZWVwIHRoZSBvcHRpb24gZm9yIG5vdyB0byBhdm9pZCBicmVha2luZwo+
PiBleGlzdGluZyBzY3JpcHRzLCBhbmQgcHJpbnQgYSB3YXJuaW5nIG1lc3NhZ2Ugd2hlbiBpdCBp
cyB1c2VkLgo+PiAKPj4gU2lnbmVkLW9mZi1ieTogQWJkLUFscmhtYW4gTWFzYWxraGkgPGFiZC5t
YXNhbGtoaUBnYXRlY2guZWR1Pgo+PiAtLS0KPj4gIE1hbmFnZS5jIHwgMTMgLS0tLS0tLS0tLS0t
LQo+PiAgbWRhZG0uYyAgfCAgMiArLQo+PiAgbWRhZG0uaCAgfCAgMSAtCj4+ICAzIGZpbGVzIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxNSBkZWxldGlvbnMoLSkKPj4gCj4+IGRpZmYgLS1naXQg
YS9NYW5hZ2UuYyBiL01hbmFnZS5jCj4+IGluZGV4IDQwZDUyY2ZjLi5kMzgzMzZhMCAxMDA2NDQK
Pj4gLS0tIGEvTWFuYWdlLmMKPj4gKysrIGIvTWFuYWdlLmMKPj4gQEAgLTE3MzgsMTkgKzE3Mzgs
NiBAQCBhYm9ydDoKPj4gIAlyZXR1cm4gIXRlc3QgJiYgYnVzeSA/IDIgOiAxOwo+PiAgfQo+PiAg
Cj4+IC1pbnQgYXV0b2RldGVjdCh2b2lkKQo+PiAtewo+PiAtCS8qIE9wZW4gYW55IG1kIGRldmlj
ZSwgYW5kIGlzc3VlIHRoZSBSQUlEX0FVVE9SVU4gaW9jdGwgKi8KPj4gLQlpbnQgcnYgPSAxOwo+
PiAtCWludCBmZCA9IGRldl9vcGVuKCI5OjAiLCBPX1JET05MWSk7Cj4+IC0JaWYgKGZkID49IDAp
IHsKPj4gLQkJaWYgKGlvY3RsKGZkLCBSQUlEX0FVVE9SVU4sIDApID09IDApCj4+IC0JCQlydiA9
IDA7Cj4+IC0JCWNsb3NlX2ZkKCZmZCk7Cj4+IC0JfQo+PiAtCXJldHVybiBydjsKPj4gLX0KPj4g
LQo+PiAgaW50IFVwZGF0ZV9zdWJhcnJheShjaGFyICpkZXYsIGNoYXIgKnN1YmFycmF5LCBlbnVt
IHVwZGF0ZV9vcHQKPj4gdXBkYXRlLCBzdHJ1Y3QgbWRkZXZfaWRlbnQgKmlkZW50LCBpbnQgdmVy
Ym9zZSkKPj4gIHsKPj4gZGlmZiAtLWdpdCBhL21kYWRtLmMgYi9tZGFkbS5jCj4+IGluZGV4IDI1
MTdiMDM3Li5jNGUyMzRlMyAxMDA2NDQKPj4gLS0tIGEvbWRhZG0uYwo+PiArKysgYi9tZGFkbS5j
Cj4+IEBAIC0xNzQ0LDcgKzE3NDQsNyBAQCBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltd
KQo+PiAgCQkJcnYgPSBJbmNyZW1lbnRhbChkZXZsaXN0LCAmYywgc3MpOwo+PiAgCQlicmVhazsK
Pj4gIAljYXNlIEFVVE9ERVRFQ1Q6Cj4+IC0JCWF1dG9kZXRlY3QoKTsKPj4gKwkJcHJfZXJyKCIt
LWF1dG8tZGV0ZWN0IGhhcyBubyBlZmZlY3QuIEl0IGlzCj4+IGRlcHJlY2F0ZWQgYW5kIHdpbGwg
YmUgcmVtb3ZlZCBpbiBmdXR1cmUgcmVsZWFzZXMuXG4iKTsgYnJlYWs7Cj4+ICAJfQo+PiAgCWlm
IChzcykgewo+PiBkaWZmIC0tZ2l0IGEvbWRhZG0uaCBiL21kYWRtLmgKPj4gaW5kZXggZGVhYzdh
NTYuLjk4NTk1MWQzIDEwMDY0NAo+PiAtLS0gYS9tZGFkbS5oCj4+ICsrKyBiL21kYWRtLmgKPj4g
QEAgLTE0MzQsNyArMTQzNCw2IEBAIGV4dGVybiBpbnQgTWFuYWdlX3N0b3AoY2hhciAqZGV2bmFt
ZSwgaW50IGZkLAo+PiBpbnQgcXVpZXQsIGV4dGVybiBpbnQgTWFuYWdlX3N1YmRldnMoY2hhciAq
ZGV2bmFtZSwgaW50IGZkLAo+PiAgCQkJICBzdHJ1Y3QgbWRkZXZfZGV2ICpkZXZsaXN0LCBpbnQg
dmVyYm9zZSwKPj4gaW50IHRlc3QsIGVudW0gdXBkYXRlX29wdCB1cGRhdGUsIGludCBmb3JjZSk7
Cj4+IC1leHRlcm4gaW50IGF1dG9kZXRlY3Qodm9pZCk7Cj4+ICBleHRlcm4gaW50IEdyb3dfQWRk
X2RldmljZShjaGFyICpkZXZuYW1lLCBpbnQgZmQsIGNoYXIgKm5ld2Rldik7Cj4+ICBleHRlcm4g
aW50IEdyb3dfYWRkYml0bWFwKGNoYXIgKmRldm5hbWUsIGludCBmZCwKPj4gIAkJCSAgc3RydWN0
IGNvbnRleHQgKmMsIHN0cnVjdCBzaGFwZSAqcyk7Cj4KPgoKLS0gCkJlc3QgUmVnYXJkcywKQWJk
LUFscmhtYW4K
