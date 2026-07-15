Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023141.outbound.protection.outlook.com [52.101.83.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C8A33ADA0
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784124833; cv=fail; b=NJpShoDb/ZC7kgyz/3vAwYFozgQlTqrR3q8dEonQ7RKtBm2A7LtzPJFdpOBfjURLnQ6XlD31GxWcUDtX02g4UVQ+o4gDutKnZHV5/CMwMoByFNQBNET6+hLdnViEPV5XlrghMkDS94vqUABvtdPk4zf0Lfs/lBLJv9FliJD5Uvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784124833; c=relaxed/simple;
	bh=A7PEe+HA3wH+LZTuPW8nGjNgdRscRbdj/8di7jWgKJE=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mSxd/ERKT/Itw75pxN8Fe7bcYQJoD16FoY6SwZYO78dBY3HJOHlatKowad6IPAszyNlLSL/ee9QGz0KtJv8kfMz9k790i8VLpajR2NkKe2+WPmTy0JAtmyAxP8KMDR+mWa4YWjhVIwVP1G8zUyaTO6i0Oyde+cHCSaP27mB32fI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl; spf=pass smtp.mailfrom=hunenet.nl; dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b=hdRHIZET; arc=fail smtp.client-ip=52.101.83.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b="hdRHIZET"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yChJs91WbeVyAwk+fuChZxvjK9saBNKYWg6WIRqwLD5zWlxDf11dPkrpSUkmebO74/2FSp5AkXYl1SPGg3CSjqOnm5gTU765vnQhn54hgNbtXPxE3mLA0YV2xTxb2J+PfymFUx5bPulb4NKIukmPig+Wevls2hsGkcHzdY7gwyGQZWWAz1To3cr4cVaHYJ36AL5lhM1YgsA8JCaSz0gVuEHyB/oc3tXdbZuCcjguvFxb+eULhMx1MwnHLSsn/dGGsYc+LKxnfgAWfPW0pltSZ1i3t/D0KqI5r/dh1yiNfP0+cfmRUYFkFBwhMm8Ui8tGkLJxsUjldw/VKcQn5oCqAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7PEe+HA3wH+LZTuPW8nGjNgdRscRbdj/8di7jWgKJE=;
 b=Zjl3KoxyynrUMcZ4iJz+gg3A/h8LMYCAf8QsOHKQUmgzHoxqA//VX/tIDy5Vj9vRz2/CJRorPSECDpqRksHb1L2B0Tx4HeWd8v/g/OV80/iXihfqr/h7Tqwge+iUKXWI6KU78J/ghoYLaExjCqgq5QMbUwrpdhXf6JWjWdVDkxjnb6dl4xh386BhdjLfISAQae/GsPL147BU6Dh6VwKi2bRL+CoZUTDdiq/8Ns1sXILOMadT8/1dl96xnFwZAPI+INWGa8kNM40Da5h/Zp/LKgyD/hgskqIGF+Nm+Ib3I3SggNMFUFecoBapVcAyBea7KHEGs4+dAnuEzxO1XfGyZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hunenet.nl; dmarc=pass action=none header.from=hunenet.nl;
 dkim=pass header.d=hunenet.nl; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hunenet.nl;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7PEe+HA3wH+LZTuPW8nGjNgdRscRbdj/8di7jWgKJE=;
 b=hdRHIZEToHrzNkJ8/bfcIeaXlFYaDhbL5sq3Y45GsFPOWbzhP5HEQ++tZmFBtq/i/8bsQodqmJ5FnJ4ewQXct4Q4XHOZiGDHMCrSBjZIinvNDDBgQAhz6MikttGdu6cwX5o4Iut45SB6/uzVP3hTDxIsvL6UktIqqeU9VRN+0xhbtk2u8FOmwCz11Ev28rKfUYz0VZshnU98xrldyON6JQmak7p/eFZg2L0mLirCamgM7SRTOOh0qhLS0kR+7OKvhudoB0o98c40bLqie6JReGaZL1eR85+qrvXbirehgVmiE1cLkBnOgvGubA7EfKBf9LBDJxURr+zkrXWqqcwXlg==
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com (2603:10a6:803:e8::33)
 by VI2PR05MB11573.eurprd05.prod.outlook.com (2603:10a6:800:273::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Wed, 15 Jul
 2026 14:13:45 +0000
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5]) by VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 14:13:45 +0000
From: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "yukuai@fygo.io"
	<yukuai@fygo.io>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
Thread-Topic: Subject: RFC: Read repair for md RAID1 after mirror read
 failures
Thread-Index: AQHdFAT9gXN+3UMPxEiBW2BLzju2krZuDRaAgACTK4A=
Date: Wed, 15 Jul 2026 14:13:45 +0000
Message-ID: <cff97a09-ee38-4785-9a45-1fd562fbaf5e@hunenet.nl>
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
 <m2y0fcesbe.fsf@gmail.com>
In-Reply-To: <m2y0fcesbe.fsf@gmail.com>
Accept-Language: nl-NL, en-US
Content-Language: nl-NL
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hunenet.nl;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR05MB6144:EE_|VI2PR05MB11573:EE_
x-ms-office365-filtering-correlation-id: a7c34d5c-5c74-4299-6060-08dee27b4865
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|22082099003|18002099003|38070700021|10067099003|56012099006|4143699003;
x-microsoft-antispam-message-info:
 M2lzbpOAbR3B5UgE0IT4XHR+sITEFdSKE99BnWqjfDRuFY7ycIIElN2VA+V9hEdSc+WkAHv0rAeew6t8+jxouQVEnP58eB53Eiwwcp61/1QEbe6tMQ4H5Hyb7FGMmOoXkG2VO/7pELdoblWCvaS5CJFU1hAV4sy0ID3c93bFcVdKLUziyPurp270Ls29L1kuAS4EwZpxEKziddt3hQ/g3GeLE712Ec7X7DNYEHMOFCluOCuv4O4dijqyk5T/NKHc+tnIJs+Y/e3S4nPv09glqwd9FSR7hPMxKhj8p2SQtxPIk8H6HaJltR/tZxwDDXF+ET2ospI6/9H8P8x5XEBaA/on3ORjWc8U+GQnOVs8TFcRpm4hjEB/MmnU09bH1Yz5/zEVPrMPERA48LiEK5eAhmrwC3gWya6eZx/DXGC/ZIBkHv3Jhtc72Ebw+jxZNSPN+WlwpaPL0pLuFr6OaCjfCQIcMjE4paE7WfMPe0+z09YmtM0W47l3oJRf1HSr4rpcUoANbydNNMNF0A1SKQqno8BVg4VxHb63+T5m4EdM8eGI0fCp1x58c7Gga8QmH/f9Wj/bUw/HNVqQVVRfPWvHi74S+vfy/2Y5sHQPptWeiSzIj6rEiE0U6JgiRft+GXUGlEU6s64UxdWrUjnLVS+PEJf1SRW24cDHGAoktGPiSmetd/c5vz0IS22mPg2q3OqyLdqpdvBtd51VFKFmVnD9Kwh85wy1a+q+vkIDUm7VzRk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB6144.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(22082099003)(18002099003)(38070700021)(10067099003)(56012099006)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M2llVytGT2h4cDRBWEFQWXY5YktDZzQ0bUpPaHBCb1E3blZPc3h2MVVoUDZF?=
 =?utf-8?B?eG04VU5XODc3d1U1bWpwLzZZMUpZclRqL2FrYnVmQ2c1OHV1cVp1SjA3NlMx?=
 =?utf-8?B?YU1Nb0phcmlSYStVQTVpS205bU9iOTI1ZGtJUUJ3RG02cStFbmFoT3lFaFJi?=
 =?utf-8?B?U3cwWmVLOVk0NUxPbEZMSzZReER1RkNVWk5XRGNDSnQ4cWcyUGswNUVsOUNu?=
 =?utf-8?B?NnB4YUtpeXhydFJlQTBpUVVmNnJOajJTeEJlakhmMjVSYlB5UWJTVERCY1hD?=
 =?utf-8?B?QkYxWHR0dWFuKzlIK3ZXajhBeFJJTnplWHdVSjh3eXNlR2l3UGg1RnM1ekpI?=
 =?utf-8?B?ZWc5ZGFWTVljRmd5bVd6VVAvRDhiejA0UnFPS0o1bk1FdWJvU2E4NGxzb0Yz?=
 =?utf-8?B?ZXc2eHV5STVuU3dLWlBhbmtuSU45YkRGYnF2MlBkOHZ4NjlyUW82S05tVHZq?=
 =?utf-8?B?MHNFWmwwdFptOXpsY2w5NTJhTzg1Y3RJM0loYlJlRk51bWpvRHQwUGEvS3hV?=
 =?utf-8?B?aXFGcWxSRlFCakp1emxvaHFXdytPRVhmRkhoNGdOdkx5OU1KRUEzWWFOVkJv?=
 =?utf-8?B?akRKcVlFNGhZTy9BeXphaDk3REQ5N1dxeDZlRTV0ZW5ya2d0aTJwZEtKZ1V0?=
 =?utf-8?B?aDk1UjhteW5ZazJDaWc4Mnh6TDVhTHAzQ1R3WlIzR1R6SXpCdk45OEl1OTMx?=
 =?utf-8?B?VmMreDVqbVJWMEowaXE2OGM3VHo0NEsvVldLNFRUT2xNN2R0VlZxYWo5NTNH?=
 =?utf-8?B?cXNTOVJmOWEya3J5WWhiSE9Yc1RhSEducDVydE1ZUHVub3VDaHUrc0g2Rjhn?=
 =?utf-8?B?V2FSTEwzSDBSVkNZZlhIckM4dVJGOWVKeEZ0WFh0bGNmSFdrMnA3S2hOMzZJ?=
 =?utf-8?B?ZVhzdXBUSFhuK0s1YXdvUHNQdmh4VkkyU21XYVJZbitxWXdkTks1cmJYQkNK?=
 =?utf-8?B?QVluMVpjYytSN2dFSXVNS1EyWGFaUjlaRFp4L1ZCa2w2ZndCbkxFU3ZUMlpV?=
 =?utf-8?B?WmtWOXZQZ2wxK3F5SXhNUmtUSmxOWEpMbGxVNGNPdEp1N1ZwbWhQVlFLWDJT?=
 =?utf-8?B?S1N4TytBc1FJSHlCYUNxSmZ4OVh3dWYvSXFpdnRmaUIwTHR1VFY3NkFDTlRZ?=
 =?utf-8?B?TXdpMC80S2l2c0JDOHNqeUcveXZEWlRWRDZESlVnM0YvaFJ3WjBpY1JPS2Ra?=
 =?utf-8?B?TE5WQ3pnbHNXMzhWRU1FUEl6ZS9xajdRR0lYdWJ0RHNtOUZsejNTOEJUSHJs?=
 =?utf-8?B?T3V2N3pIRk9OeFI3QzV0UEhvbDR6U21kdkJNbHFrdnUvQ2NRcm5MUUdjWnlN?=
 =?utf-8?B?bXZvQ3hFTzVTVGVpWkx3ZE9qY1NGM2F3cklLbjdVU0hZZzRaRm9oMkRLNFk5?=
 =?utf-8?B?M1B4bjhSRkJtQkRMNUtuS1lDOG1nK2tZUlZ3RTVoYTVDQkdueFV3TDAxZ21F?=
 =?utf-8?B?SnVwK3U2NWpiUy9zbWRkVFh5VVlxdDFGL05xSDd3LzVQeTFzbUUzQVExQ2hO?=
 =?utf-8?B?Tm5rTEFXWTFkUmhCdE4vbjhpTDdxSElML2U5MHVDSGJ1N2NxVjZqVmdGK1NT?=
 =?utf-8?B?Z1lMK2YyL3ZWUFh0b3l6S2s5QUtHZXU1emwydjlVT2pSR1Z5MjFPeVA1aGN0?=
 =?utf-8?B?WGFGbEtkMmxackRmS0hoOEhHNzlub1dTaCtqY0NPOFFFNkNXMFAwNFVKS01t?=
 =?utf-8?B?TWRDb3c2eDk5S2RnWnc5SHlQeUErN0ZOM2VEak00MWNnVmwzeE5QQnl3NUlp?=
 =?utf-8?B?Wm1iRTdFdDdCV2xUZ0tPTGt1aWhIb0RZNkpucmVFTVJranByYTZqLzZ5RHZt?=
 =?utf-8?B?Y2R3Ynd4WnJSU3JUbm8yWmFYY1Fpclg1K2MyNmZtVkMvL1RIdmlGeU5FRGtj?=
 =?utf-8?B?UXMwSjZLN1l5WkxTR1ljQklqc1hScGlJUk0yRHU1ZmxtM2pEMGplNmtXdFhi?=
 =?utf-8?B?dmNYcmZCZWZZcDMvVHFFNUNsQWx0UGFJZkJUaFp3TEZzeVlvV1UrN2tnMUUw?=
 =?utf-8?B?bTZqMDh3dDhEZVVodm43UjlFQzRWUDJPMi91VjZ2WmdoTVlvTy9WVk9GRFZi?=
 =?utf-8?B?RmZEMTI4YnpjVER0ODdDUk1vOGtmYVRuTFl2VE5CcXZ2UTNTMm9FQllkQkl3?=
 =?utf-8?B?WHVYS2tRQTFlY2VBOW5sZnpsZytVWWpqUS9ZNko0TEdpYnFXNUpQRXk5ZERF?=
 =?utf-8?B?SFRxYTY0b1pVRWozZTZzNFVrUlZNMTU5a1pJcmhrTzQ1dHNyMjJ1T2FvMk5B?=
 =?utf-8?B?QmQyOHdOa1F6RkZIaWp3SEVuaTVLNjFENm53K1ZQN3V6cWhvbUVadWtoUkI1?=
 =?utf-8?Q?tXh3X26ff2fO4kfQIx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CC62321BB8E6545AA2AF080CD05A892@eurprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c34d5c-5c74-4299-6060-08dee27b4865
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2026 14:13:45.6115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 887aa16f-e08f-4cfb-bc70-8f3f25a72a41
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1SLyVoIORGP+d76Pa6MHjjDVQTrrYbHEzeY4TIQWz1rCX7PUO2GRytdOhnWScoYrUTQMujk6eS49eRIINGY4Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR05MB11573

SGkgQWJkLA0KDQpPbiA3LzE1LzI2IDc6MjcgQU0sIEFiZC1BbHJobWFuIE1hc2Fsa2hpIHdyb3Rl
Og0KPj4gV2l0aCB0b2RheSdzIDE44oCTMjQgVEIgSEREcyBhbmQgYmFja3VwL2FyY2hpdmUgd29y
a2xvYWRzLCB3aGVyZSBkYXRhIG1heQ0KPj4gcmVtYWluIHVuY2hhbmdlZCBmb3IgeWVhcnMsIGxh
dGVudCBtZWRpYSBkZWdyYWRhdGlvbiBzZWVtcyBpbmNyZWFzaW5nbHkNCj4+IHJlbGV2YW50LiBB
IHN1Y2Nlc3NmdWwgcmVhZCBmcm9tIHRoZSBhbHRlcm5hdGUgbWlycm9yIG1heSBiZSBvbmUgb2Yg
dGhlDQo+PiBsYXN0IG9wcG9ydHVuaXRpZXMgdG8gcmVmcmVzaCBzdWNoIGEgc2VjdG9yIGJlZm9y
ZSBpdCBiZWNvbWVzDQo+PiBwZXJtYW5lbnRseSB1bnJlYWRhYmxlLg0KPj4NCj4gQW5kIENoZWNr
L1JlcGFpciBpcyB0aGUgcmlnaHQgZGVmZW5zZSBmb3IgY29sZCBhcmNoaXZhbCBkYXRhIG9uIGxh
cmdlDQo+IGRyaXZlcy4NCg0KDQpJIGhhdmUgYmVlbiBsb29raW5nIGludG8geW91ciBzdWdnZXN0
aW9uIHRoYXQgcGVyaW9kaWMgY2hlY2svcmVwYWlyIGlzIA0KdGhlIGFwcHJvcHJpYXRlIGRlZmVu
c2UgZm9yIGNvbGQgYXJjaGl2YWwgZGF0YSBvbiBsYXJnZSBkcml2ZXMuDQoNCkJlZm9yZSBJIHN0
YXJ0IHJlYWRpbmcgdGhlIHJlc3luYyBjb2RlLCBJIHdvdWxkIGxpa2UgdG8gbWFrZSBzdXJlIEkg
DQp1bmRlcnN0YW5kIHdoYXQgcmVwYWlyIGFjdHVhbGx5IGRvZXMuDQoNClN1cHBvc2UgYWxsIG1p
cnJvcnMgcmVhZCBzdWNjZXNzZnVsbHkgYW5kIGNvbnRhaW4gaWRlbnRpY2FsIGRhdGEuIEluIA0K
b3RoZXIgd29yZHMsIHRoZXJlIGFyZSBubyByZWFkIGVycm9ycyBhbmQgbm8gbWlzbWF0Y2hlcy4N
Cg0KRG9lcyByZXBhaXIgc2ltcGx5IHZlcmlmeSB0aGUgZGF0YSBhbmQgbW92ZSBvbiwgb3IgZG9l
cyBpdCBhbHNvIHJld3JpdGUgDQplYWNoIHN1Y2Nlc3NmdWxseSByZWFkIGJsb2NrIHRvIHRoZSBj
b3JyZXNwb25kaW5nIExCQSBvbiBldmVyeSBtaXJyb3I/DQoNClRoZSBkaXN0aW5jdGlvbiBpcyBp
bXBvcnRhbnQgZm9yIHdoYXQgSSBoYXZlIGluIG1pbmQuDQoNCk15IGNvbmNlcm4gaXMgbm90IHJl
Y292ZXJ5IGZyb20gYW4gZXhpc3RpbmcgcmVhZCBlcnJvcuKAlHRoYXQgaXMgYWxyZWFkeSANCmhh
bmRsZWQgYnkgZml4X3JlYWRfZXJyb3IoKeKAlGJ1dCByYXRoZXIgdGhlIGxvbmctdGVybSBhZ2lu
ZyBvZiBjb2xkIA0KbWFnbmV0aWMgcmVjb3JkaW5ncy4NCg0KSWYgYSBzZWN0b3IgaXMgc3RpbGwg
cmVhZGFibGUgdG9kYXkgYnV0IGlzIGFwcHJvYWNoaW5nIHRoZSBwb2ludCB3aGVyZSANCnRoZSBk
cml2ZSdzIEVDQyB3aWxsIGV2ZW50dWFsbHkgbm8gbG9uZ2VyIGJlIGFibGUgdG8gcmVjb25zdHJ1
Y3QgaXQsIA0KdGhlbiBhIHN1Y2Nlc3NmdWwgcmV3cml0ZSB3b3VsZCBlZmZlY3RpdmVseSBlc3Rh
Ymxpc2ggYSBuZXcgIndyaXRlIHRpbWUiIA0KZm9yIHRoYXQgc2VjdG9yLiBJZiB0aGUgZHJpdmUg
Y2FuIG5vIGxvbmdlciByZWxpYWJseSBzdG9yZSB0aGUgZGF0YSBhdCANCnRoYXQgbG9jYXRpb24s
IHRoZSByZXdyaXRlIHdvdWxkIGFsc28gZ2l2ZSB0aGUgZmlybXdhcmUgYW4gb3Bwb3J0dW5pdHkg
DQp0byByZW1hcCB0aGUgc2VjdG9yLg0KDQpTbyBteSBxdWVzdGlvbiBpcyBlc3NlbnRpYWxseToN
Cg0KRG9lcyByZXBhaXIgcGVyZm9ybSBzdWNoIGEgcmV3cml0ZSBvZiBzdWNjZXNzZnVsbHkgcmVh
ZCBibG9ja3MsIG9yIGRvZXMgDQppdCBvbmx5IHJld3JpdGUgYmxvY2tzIHdoZW4gYSByZWFkIGVy
cm9yIG9yIG1pc21hdGNoIGhhcyBhbHJlYWR5IGJlZW4gDQpkZXRlY3RlZD8NCg0KUmVnYXJkcywN
Cg0KRGlvbg0K
