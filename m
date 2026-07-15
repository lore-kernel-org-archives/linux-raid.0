Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021126.outbound.protection.outlook.com [52.101.65.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0FB4483AA
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 11:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.126
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784114684; cv=fail; b=NMjkXe9ABkNvCxKnpUVD4kQQ1h2maenId911fh9hK+Uwi9t2iBCf8ayRzGs4wd439h4VNPc5RLedD9NFO2flvc3UI9IOMPxa9HEGiEvQjlWU+QgHUchg+VG7uEV1QpP0hRcgCC4jS225igz3GtaYKzcgYbW41lvtfMVHpqiqqwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784114684; c=relaxed/simple;
	bh=eqqKWNIBefzJufLRujMucp4IidR6BQkxa7SHl27aUcE=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YcN1Q6deqSyejoejZ6A90+rusza8VabXO7MV+vpI1iiPZB1GZnKpJc3Tjl31+Z+jUBOYNp41MMWLUMyVo3PvWg9e7yWGOblsxQcXGlFtYr7rFN6+eQiuxIt5AGhUKrXUGBmvhOxZ3GDbydrMW3pqHDnFtTmwVUzPEMkTsv7IsYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl; spf=pass smtp.mailfrom=hunenet.nl; dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b=LXpa+uke; arc=fail smtp.client-ip=52.101.65.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hunenet.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hunenet.nl header.i=@hunenet.nl header.b="LXpa+uke"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pp4TlQy403/xhJUZmbFRltpWw54ZePjSqeNaa+RbjVmZfBZnDkAvmWhKtblocweXcQFmuTE+UOnnNrmNXhc0lWy0JmSjVdgS5FWqCQzGGB4iX80nIJtgSUjq6P3xeF/qS6bNx8p9H6mfaahNOVFC4JiOjyqkLh+TTx64f1XX0QCnORFBPqIdqN8berlhspT9xasyAWL+pHvepx7PmAQzjQuD9I8ZCoiAAxq2km0RbtPt7kn5LYRwnNGARB42TpCWaMXkys5CWChssD/FXLVQRYBHiwHl+/DDOFR5P6nl5rry13ZSoD3smmlxSbSI1bzWSLVJpIo7jDEq/SSDAvboDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqqKWNIBefzJufLRujMucp4IidR6BQkxa7SHl27aUcE=;
 b=gDy5KIdO9qGnHHPF/2s8rGLD/YDnezgnuoSk4jw8tTNtUwp4WBzzq3Y257yCOur6Uqz4rxss6QGzBqtz/SGXEIrRg0FVvK3IrDD6bDwcYdjDIWNrC/l93GzcgugzNhcX7HLbOgGFPUZTw30MccSVXHCPt9BTQKO1RT1CS+0Ebhoa0K48D0W8+nfUenc70UdmAYJlul4+gZCcmIHZFiA7dgib8e/N08ulBAp4Vcf6XMwL4v2/60T82cjmkNlMK1BvEqL3RbT64kl+ggkMYabNaTVb3ImRqXV0tbW7TxoalwhWPAXZic3mZvH8uhFH+gua2Ic/Vm+g3QxHiHbGl1C6yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hunenet.nl; dmarc=pass action=none header.from=hunenet.nl;
 dkim=pass header.d=hunenet.nl; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hunenet.nl;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqqKWNIBefzJufLRujMucp4IidR6BQkxa7SHl27aUcE=;
 b=LXpa+ukeNhz1+Q/GSuvTk6eNrDP8Q5AwLhkUG8z6dSNsnhka24q7DQsnCpMvOLSySC0W0iQ0UG5HxsvJVYFnZATu+vN0rTdM7P/UanoR8//aur5eQ6Y9bqa8ih09ETHfmmbtbnop2wWHP/9fTDdw6Y2EOkfVCF0p8wK1BJa3CxLJjFeVvtluou0SuauwMRkkoCTdUXaJ1YxVIzgLTTGEBdwDqAKq2BIaIcfXp3OqFjcIsF3m7s3zyQM1dD6aGoQmMhVKZ/ajOVTDxnLcpxFN2YTLGXDTXCv3YU6XfmLYTPOEqQd8KQUvI7eUF7fz8/f63Xts1DdV5VMhwUqYfEJRCw==
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com (2603:10a6:803:e8::33)
 by DB9PR05MB7788.eurprd05.prod.outlook.com (2603:10a6:10:214::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Wed, 15 Jul
 2026 11:24:37 +0000
Received: from VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5]) by VI1PR05MB6144.eurprd05.prod.outlook.com
 ([fe80::6c89:8ead:10b6:b5a5%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 11:24:37 +0000
From: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>
To: "yukuai@fygo.io" <yukuai@fygo.io>, Abd-Alrhman Masalkhi
	<abd.masalkhi@gmail.com>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
Thread-Topic: Subject: RFC: Read repair for md RAID1 after mirror read
 failures
Thread-Index: AQHdFAT9gXN+3UMPxEiBW2BLzju2krZuDRaAgAAc44CAAATDgIAAQkOA
Date: Wed, 15 Jul 2026 11:24:37 +0000
Message-ID: <4b6f442a-6b6b-486c-b992-d1995767e8e8@hunenet.nl>
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
 <m2y0fcesbe.fsf@gmail.com> <368d1223-1d41-4227-af33-bd6bd00b5c3d@hunenet.nl>
 <2718fd27-9453-4dea-9d1d-13cfecef4e6c@fnnas.com>
In-Reply-To: <2718fd27-9453-4dea-9d1d-13cfecef4e6c@fnnas.com>
Accept-Language: nl-NL, en-US
Content-Language: nl-NL
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hunenet.nl;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR05MB6144:EE_|DB9PR05MB7788:EE_
x-ms-office365-filtering-correlation-id: 0caf9877-6d08-42c0-65e3-08dee263a7b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|56012099006|4143699003|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 wRzzSv8Gls5kz/Xqh1d0kFWU8cFi/oDU3Vumf6sEf0jLyy1pk8hNNqboBgzPnoQHlEnXdA9muy0HksdnmBKHPVecbQXZiNJ4pQicIVTot/UpESVgkeWBGID9d7R1aXavR4+vadddSo+5SvaGCDOVqg8LZvtN6CyUm1DC/er9yNbGNWmMBAtGJ9ffNQEXAIMz5sOccP6vMUU2BKPDV8+G42uTTP2MDHTBSnsV4b7y3gdaBDu+65f1f3ewH1Sgf7OyiUy+bXGCx+xm1fSU2XvJiAMzzkmx0HtKejQUjDxApenhQ7LBmRs9i/czSrnqGWxS0lI99bC5ysaBNIjJACb7Kpp3igEUtE21abQF2QBuhrTje+JY3nLSUSFBLYUp1df0t3ODcYXfzG5VwoqH3d+MpVKFPr/FACOBhEIk8vmRUmpXpCGr9vp/ecgv0Sjj0To3V2rfrD8m4jiC8fDxjWUgNQZzC0+fXNgja7xdGrZ3Z9Ujf+Lai5PCJraWdIxesteZLx9pj/biTsto9F0IgG1bF9lNN5bEFlBJUzvL5tcjKSZjkDqqm7qlyU2bFvPUPoxoOz8n+KAYbV/9ze9dfKYO5kjBxO/RAviqpDENKGT2peyxMwSIUl6tk+1t1I3X7TRYXbG7P/OlSWecr5g0fMagNQYF3awI3AaTlpt7edIS6pjIW+rHvitFl//GAxYeUtBrs2bgQG7ovhGaho1R2BPMYjf7wsUgy4Z7Dyf6Q+VXqeM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB6144.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WUsxckRlZk9hTjNrSU1TcXlHTTE2Vmgzcjc4L1ptRURCT1BZOE94Tm91NXlq?=
 =?utf-8?B?dXc5UktYZVoveEphMm5CU3NLTXk2UmJVc2ZLMUFDWWl4bm9ZN3JoMUVqZ05O?=
 =?utf-8?B?TFJCNXpROG9XTmxvczI4RzVLbHBUb3RndFp0ejJtbVptaUFGbDc1dWpLR2dX?=
 =?utf-8?B?N2VsdDhyMlFuLzlYWUJ0Mm10OTVzbHl3MzBqVmMrd1ZlbTZGM3FQUkhSUGpU?=
 =?utf-8?B?ZHJtbkFIb3BMdFJwUG9haHcyQXl2TnpCOGFESlBNZGdKNlVkdmtvVHA5SkJB?=
 =?utf-8?B?cWk0MHVUaE4ra2tuM3k4R3BLUEQ5WEdwWStpeTdSTkE4aWx0MHFNVDR0ZlZ6?=
 =?utf-8?B?QS93SlV4THdia1ZkK3BFUVJrbm9MbTFlNVc1dnpFY3BoSk5jVlo2a3A2VDdx?=
 =?utf-8?B?aWlRUnYvNnN6bzlGdWZ6U3ZmMndaaWRxTWJMb200cWFHUThGRHJTTjFUWVRQ?=
 =?utf-8?B?WW5mWWNnQ29rZWE3aUl4QnJWNUZBTUU3MGVvTnFKa1J1RUx4Sk1aNlV6TE5V?=
 =?utf-8?B?b0l2ZUJjRjlrSENMS1JrQ1o2VDhvR0FnT1cxSUJEUnRIWTlsc3VUZlgzTkdU?=
 =?utf-8?B?Vkp5WWlvaVdwVU1WS2xWT25OYklSWXR0ZEZrZWdxeDVNam84TVh5NjJGS04v?=
 =?utf-8?B?ZnI1V1NlQTFsTjQyVzlKdnN3WUt0dm9rMnE1TzFyTGV1cW5KTG1GSjRJSDFN?=
 =?utf-8?B?Rm9MZi9tL0lYbGtKMlYyeGkvd2tKMHhGc05TUjBjN1VtcjB1N3RhbTBBbEs5?=
 =?utf-8?B?RXdOaUxmSUZOR0RkM0lZdmJPd3BFemE0eko4L3Z4QVBxam9IRHFLOVhaakNl?=
 =?utf-8?B?NDFDaVZKZGxNL2s1YmFWMCtJTG5MNWt5OEJHVFJrQ0pqQmlUVzhJdU1WeTJz?=
 =?utf-8?B?WWk2eEFWbW8wVDllZnJZNXBESTBYZkc2TEZVeGs0U3JWYU91cWZmbnZzOEk2?=
 =?utf-8?B?ZDArY0JCM01EcnNNb1o3cU9yMm95ZldiZ3RTNFhVNDVLOWlwREl6RHVOYUxX?=
 =?utf-8?B?WGVPUHNGalJ2ekd1c3NoYUd3SDBvTUtoSWt1dzFwazA1aWdEdW5lN3ZVcTBw?=
 =?utf-8?B?MlRiYVlpWnhjbmJYSDI5MFY0QnVXZTRYc3VwRGVja2g0NkV0eGdOampWT2t5?=
 =?utf-8?B?QXRMSEpCMGs5UzFrZFdDZ2IvS1pGNW1DOTMvZ2NUdzFreWpyWVFqUUc2YkEx?=
 =?utf-8?B?Z3o3U3Nvb1VsQmVMc0RNWFZHc2YvMlk5TmFPUG00TktHY1JrVE0ydm4rdXY5?=
 =?utf-8?B?RmxrU09lRlh5Z3pPNGN6RGJZZzcydmZOZGREWG85clY5VEhDSlc5cGhpV3Ur?=
 =?utf-8?B?Q1RVVFRDVnZYdnpaYjNRamNWT2NFUXdNMjRFU0xWTVRuakJXK1RiUWJXSjFX?=
 =?utf-8?B?NFFRTHRFcnFBZEdjb2dLejNBS3ZpY1FyUWNvckFkVUlPamw0SisvYVZWUkV3?=
 =?utf-8?B?RTNBcjdZc3RySzRUdFdKYnRUN1JvS2I0RCtJaDRTQkhROWJmQ05ieVFUSjl2?=
 =?utf-8?B?UUtTOEhFMEVTTzJLcGpFOWs3UE9xc0ZVWmdiYzNsZTV5U0Y1Y1YxcUFBb0tP?=
 =?utf-8?B?dDduVGt5WXk1dGNuZkk0a1MybE9QQnFsVjJRZm5ZU29WeGNHVGE2UXM3M0lK?=
 =?utf-8?B?Rk5zQTZwdDRveldoRmVvUWcyc3djR3ZBWmwwMlJNYXd6d0NvZE50dU1FN1Jr?=
 =?utf-8?B?M2R4NWhoeW9adGt1ZGExTy9nM1Vld0p6bUx0UXExSXJlU3VLc1hPWTFHaHhV?=
 =?utf-8?B?OUlNN0ZGR2lyU2ZMUzRXWUJnQmpnNUFSanRnbVpyUTZXcCtKd1FzVitzNDl2?=
 =?utf-8?B?MmgxeXk1a1BOOXNYcjR4M3k1REhVR3JkU0RvanNrbHg1dEhwTWg1K3RHQmtJ?=
 =?utf-8?B?K1I3WSs0RVA4UGxTVFhOUUJTalBwNVpBUjdQSnZGLzVRZG9NcWI2aUVHbjRL?=
 =?utf-8?B?eUEvb1lKRUtHNUZsd1g4T3ZqaGFDK0w5L1hHcW1ZbjlGclFINE0wdXh0WVI1?=
 =?utf-8?B?aWNvVnkwRFdQQy9yTklFRUlLalZYZ2Fza3UxQmhoQUIxWlJycUVjeWJCaldN?=
 =?utf-8?B?OTI1TlRoRUlIeGwxcjU2Qk13VERHbE04NU5pNHdldUxGQlBmRlMvVytlYzMr?=
 =?utf-8?B?NlA1ZCs3VzBaK29jb2JKMEg5VGIxUDRBOTc2TmE0ODdxVUlScUREYXJPeVpH?=
 =?utf-8?B?YlM1eHI3VTQrd1luajlMK2VYU0F0ZjY1K2lOcmdOaXkyd0pQUDJ2UU1PQ3Mr?=
 =?utf-8?B?d04wNERUT0YzUG5nbU5JdGw3Tkp6Y1lMenFIdGdZNnBOTlY0RFdmdC8yRVBi?=
 =?utf-8?Q?ObsQyKv/FKhXE3Hdht?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5EB1E86FC52C0D478F40F16F33FEE581@eurprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0caf9877-6d08-42c0-65e3-08dee263a7b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2026 11:24:37.6078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 887aa16f-e08f-4cfb-bc70-8f3f25a72a41
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c8/xkufVtP1vJ2QyfoK+RK32FF/DXTFdqo0kmEhoCZcqPW5u9fwjlPUc44o9e650mRUt540hqEzFx1pdGzVuww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB7788

T24gNy8xNS8yNiA5OjI3IEFNLCBZdSBLdWFpIHdyb3RlOg0KPj4gVGhhbmsgeW91LiBmaXhfcmVh
ZF9lcnJvcigpIHdhcyBleGFjdGx5IHRoZSBwaWVjZSBJIHdhcyBsb29raW5nIGZvci4gSQ0KPj4g
aGFkIG1pc3NlZCB0aGF0IG1kIGFscmVhZHkgcGVyZm9ybXMgcmVhZCByZXBhaXIgd2hlbiBhbm90
aGVyIGhlYWx0aHkNCj4+IG1pcnJvciBpcyBhdmFpbGFibGUuDQo+Pg0KPj4gTXkgc2l0dWF0aW9u
IHdhcyBpbmRlZWQgZGlmZmVyZW50IGJlY2F1c2UgdGhlIGFycmF5IGhhZCBhbHJlYWR5IGxvc3Qg
b25lDQo+PiBtZW1iZXIsIHNvIHRoZSBzdWNjZXNzZnVsIHJlYWQgb3JpZ2luYXRlZCBmcm9tIEJ0
cmZzIHJlZHVuZGFuY3kgYWNyb3NzDQo+PiBhbm90aGVyIG1kIFJBSUQxIHJhdGhlciB0aGFuIGZy
b20gdGhlIHN1cnZpdmluZyBtZCBtaXJyb3IuDQo+Pg0KPj4gT25lIHF1ZXN0aW9uIHJlbWFpbnMs
IHRob3VnaC4gY2hlY2svcmVwYWlyIHBlcmlvZGljYWxseSByZWFkcyBhbGwNCj4+IHNlY3RvcnMs
IGJ1dCBhcyBmYXIgYXMgSSB1bmRlcnN0YW5kIGl0LCBzdWNjZXNzZnVsbHkgcmVhZCBzZWN0b3Jz
IGFyZQ0KPj4gbm90IHJld3JpdHRlbi4gRnJvbSBhIG1lZGlhIGFnaW5nIHBlcnNwZWN0aXZlIHRo
aXMgaXMgYSBkaWZmZXJlbnQNCj4+IHByb2JsZW0gdGhhbiByZWNvdmVyaW5nIGZyb20gYSByZWFk
IGVycm9yLiBIYXZlIHRoZXJlIGV2ZXIgYmVlbg0KPj4gZGlzY3Vzc2lvbnMgYWJvdXQgYSB0cnVl
IG1lZGlhIHJlZnJlc2ggcGFzcyB0aGF0IHJld3JpdGVzIHN1Y2Nlc3NmdWxseQ0KPj4gcmVhZCBz
ZWN0b3JzIHRvIHJlZnJlc2ggbG9uZy1saXZlZCBtYWduZXRpYyByZWNvcmRpbmdzPw0KPiBQZXJo
YXBzIHRoaXMgaXMgd2hhdCB5b3UgbG9va2luZyBmb3I6DQo+IA0KPiBbUkZDIHYyIDAvNV0gbWQv
cmFpZDE6IGludHJvZHVjZSBhIG5ldyBzeW5jIGFjdGlvbiB0byByZXBhaXIgYmFkYmxvY2tzIC0N
Cj4gWmhlbmcgUWl4aW5nDQo+IDxodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjAyMDMw
NjEyNTkuNjA5MjA2LTEtIA0KPiB6aGVuZ3FpeGluZ0BodWF3ZWljbG91ZC5jb20vPg0KPiANCj4g
SG93ZXZlciwgQUZBSUssIFFpeGluZyBubyBsb25nZXIgd29yayBpbiB0aGlzIGFyZWEgYW5kIHRo
ZXJlIHdpbGwgbm90IGJlDQo+IG5ldyB2ZXJzaW9uLg0KPiANCj4+IEJlc3QgcmVnYXJkcywNCj4+
IERpb24gS2FudA0KPiAtLSBUaGFua3MsIEt1YWkNCg0KSGkgS3VhaSwNCg0KVGhhbmsgeW91LCB0
aGlzIGlzIGNlcnRhaW5seSBjbG9zZWx5IHJlbGF0ZWQuDQoNCkFzIEkgdW5kZXJzdGFuZCB0aGUg
cHJvcG9zZWQgJ3JlY3RpZnknIGFjdGlvbiwgaXQgb3BlcmF0ZXMgb24gcmFuZ2VzDQp0aGF0IGFy
ZSBhbHJlYWR5IHByZXNlbnQgaW4gYW4gbWQgbWVtYmVyJ3MgYmFkLWJsb2NrIHRhYmxlLiBJdCBy
ZWFkcyB0aGUNCmRhdGEgZnJvbSBhIGhlYWx0aHkgbWlycm9yLCB3cml0ZXMgaXQgdG8gdGhlIGNv
cnJlc3BvbmRpbmcgTEJBIG9uIHRoZSANCmFmZmVjdGVkIG1lbWJlciwgYW5kIGNsZWFycyB0aGUg
YmFkLWJsb2NrIGVudHJ5IHdoZW4gdGhlIHdyaXRlIHN1Y2NlZWRzLg0KDQpUaGF0IHdvdWxkIGJl
IHZlcnkgdXNlZnVsLCBidXQgSSB0aGluayBpdCBhZGRyZXNzZXMgYSBzbGlnaHRseSBkaWZmZXJl
bnQNCnByb2JsZW0gZnJvbSB0aGUgbWVkaWEtcmVmcmVzaCBvcGVyYXRpb24gSSBoYWQgaW4gbWlu
ZC4NCg0KVGhlIGxhdHRlciB3b3VsZCBwcm9hY3RpdmVseSByZWFkIGFuZCByZXdyaXRlIGFsbCBh
bGxvY2F0ZWTigJRvciBwZXJoYXBzDQphbGwgYWRkcmVzc2FibGXigJRibG9ja3MsIGluY2x1ZGlu
ZyBibG9ja3MgdGhhdCBhcmUgc3RpbGwgcmVhZCANCnN1Y2Nlc3NmdWxseSBhbmQgaGF2ZSBuZXZl
ciBiZWVuIGVudGVyZWQgaW4gdGhlIGJhZC1ibG9jayB0YWJsZS4gVGhlIA0KcHVycG9zZSB3b3Vs
ZCBiZSB0byByZWZyZXNoIGNvbGQgbWFnbmV0aWMgcmVjb3JkaW5ncyBiZWZvcmUgdGhleSByZWFj
aCANCnRoZSBwb2ludCBhdCB3aGljaCB0aGUgZHJpdmUgcmVwb3J0cyB0aGUgZmlyc3QgVU5DLg0K
DQpTbyBJIHNlZSB0aHJlZSBzZXBhcmF0ZSBtZWNoYW5pc21zOg0KDQoxLiByZWFkIHJlcGFpciBh
ZnRlciBhIGZhaWxlZCBub3JtYWwgcmVhZCAoYGZpeF9yZWFkX2Vycm9yKClgKTsNCjIuIHJlcGFp
ciBvZiBhbHJlYWR5IHJlY29yZGVkIGJhZCBibG9ja3MgKGByZWN0aWZ5YCk7DQozLiBwcm9hY3Rp
dmUgcmVhZC1hbmQtcmV3cml0ZSBvZiBzdGlsbC1yZWFkYWJsZSBjb2xkIGRhdGEuDQoNClRoZSBw
cm9wb3NlZCBwYXRjaCBhcHBlYXJzIHRvIGltcGxlbWVudCB0aGUgc2Vjb25kIG1lY2hhbmlzbSwg
d2hlcmVhcyBteQ0KcmVtYWluaW5nIHF1ZXN0aW9uIGNvbmNlcm5zIHRoZSB0aGlyZC4NCg0KTmV2
ZXJ0aGVsZXNzLCBgcmVjdGlmeWAgaXMgaGlnaGx5IHJlbGV2YW50LCBhbmQgaXQgaXMgdW5mb3J0
dW5hdGUgdGhhdA0KdGhlIHNlcmllcyBtYXkgbm8gbG9uZ2VyIGJlIGRldmVsb3BlZC4gSSB3aWxs
IHN0dWR5IHRoZSBwYXRjaCBzZXQgYW5kIA0KaXRzIGRpc2N1c3Npb24uDQoNClJlZ2FyZHMsDQpE
aW9uIEthbnQNCg0K
