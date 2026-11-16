Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.171.137
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794811188;
	b=Oms5bXCFFuN5VIXp7/9vCrdMXFQFOCSh3JjhiQOBYHhVgG72fy49Eo1pElrR1RijVpZt
	 8LCZzQZcYe4kikj/iluvGLrGRNN4OMqdUuK72NdgJ7w29SmMIFkppCI3KGKCrowq941lU
	 VV1TKPTo6brGu5t1j4KhqUUdzw1G4MxcJQmST6spuLCnX8IWyONtKQCNJ8yxSlrBy9m+/
	 3WDWumyZk6ACWSJlZ1SlPln/HOaTFLUe2YS9f4UL89eHoGWkkPu3/fptnrx5bkav9Vqdn
	 P49zhk45Naij/J/dK6PuLiqiY0bX1kXe30rjxKAPeZyU/fMPUBdctf+UR3Gp1rwNlFA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794811188;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
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
	bh=R+yty7mYymsXYiP8CGD92/x7eekMGuQKGu7lplP/BEs=;
	b=2vyLjCfLzqfmpbThWV+c4BLi9PKFeb35z3rkU39PknAkiqn/juZ6h1bq2s18KybtL4SV
	 rUA/R/Xg104VQKAdzWx1nHP72Ci+PF9O3p3hRtUY2RBzbdTASnZE8DiVW2zkzvAaLAURj
	 tE5yb1wcDCpP/uRMq62JLaD6zV3cesU6zvU9+pLvXtd5uU/7JwMpd54Nje5LJV9k+5DGC
	 YGlX5qaPl7EURyehBZGwRqQg9/BLJWWlTGleXvU3N/mo7wDGd3fyLNdKrFaYA6/qT/Ld/
	 yGVoemAUzKdgkdA97qLN0I4QdLRVDwB5SIHj0BnvFQA2H+YYCb4IEOfIFogumsmt57w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collogia.de;
	spf=pass smtp.mailfrom=collogia.de;
	dkim=pass header.d=collogia.onmicrosoft.com header.i=@collogia.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-collogia-onmicrosoft-com header.b=AmbS2YNB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.171.137
Received: from FR6P281CU001.outbound.protection.outlook.com (mail-germanywestcentralazon11020137.outbound.protection.outlook.com [52.101.171.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C43A606A323;
	Mon, 16 Nov 2026 06:39:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C43A606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=collogia.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collogia.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=collogia.onmicrosoft.com header.i=@collogia.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-collogia-onmicrosoft-com header.b=AmbS2YNB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HOA4B8EXipTaAstoJIjVInv9uqkhSROGBCGwoRz0Dh3E+TXpysWC/DlaWcSYUUHmzAY3I+Nzx9N4SG2OkREEXwFGtGNXCKjEJD08MpdXmY/HunGzSow7k62GrMD/IufRmFL0o3IhVDr+2TGN+279R19zxhMjdTYkTTX2PWqNIY4/xP4RqLRwPr6I3tlx9J6ZhesWG6TVKK8Ed+t/WpY83/cEv8vU2Zv2lvLoo5jhjdOmRbEdXJNAbrgVXUfZwc4CnZQlmV5mEoLYmGHyCzHkVtqI8dOqSb+eIV4CGg6EFDdbAX89424GE+kNGEo4x4RGy1Yg74QqtVLqGNgC2vrhcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+yty7mYymsXYiP8CGD92/x7eekMGuQKGu7lplP/BEs=;
 b=uuejWgbM4jOBkKlI54oOI2xknqAOprV2BGybscEipLI37QxQt8GSOif2T85UoNxEuESISVktauIpwW5LdpHRqvkamMuWgitmRsTzscFXJNU5H7i4oSqWXvL3jwLd33izbrTdBvTlxWExGngtacS/cTEP23V7/YDgKm2c7gkYrUuP7rczJwbokx3etFe8di6qic2gPPPgd2c5Yc28h4dKqp8h7an6pum1EMuTGQYNRvQYpvnHlfK+a0/KHzt0Avu9xbREY6E9bUpwRm6mkUzZ+OuZo2DmpoPytydD2j1RUieWPbixScNyVgE6SJl0IEmNSLtAJen+LfjeDs8ycoXJVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=collogia.de; dmarc=pass action=none header.from=collogia.de;
 dkim=pass header.d=collogia.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=collogia.onmicrosoft.com; s=selector1-collogia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+yty7mYymsXYiP8CGD92/x7eekMGuQKGu7lplP/BEs=;
 b=AmbS2YNBznYe3/CTyAs8v8WL1yVrqgM7GHEoLs6ZQkQQiQoeNSurZai9hf/ez5rMqApSKdyH4KU8QYLTNiwz4HTnKUuXdQvYxYRLwlkFtzOR4jP4uIsBe3XWZEQkg8TbaO6+oXp9QLa3r2FSMLL2Mjfs5pNFoj0ycumwKiHUko8=
Received: from BE3P281MB134990.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:13c::8)
 by BE3P281MB6281.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:104::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 06:39:42 +0000
Received: from BE3P281MB134990.DEUP281.PROD.OUTLOOK.COM
 ([fe80::c548:c8b5:4ef3:24c3]) by BE3P281MB134990.DEUP281.PROD.OUTLOOK.COM
 ([fe80::c548:c8b5:4ef3:24c3%2]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 06:39:42 +0000
From: Markus Stockhausen <markus.stockhausen@collogia.de>
To: Christoph Hellwig <hch@infradead.org>, Miroslav Cimerman <mc@raidlab.org>
CC: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, Andrew Morton
	<akpm@linux-foundation.org>, Li Nan <magiclinan@didiglobal.com>, Xiao Ni
	<xiao@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: AW: [PATCH] raid6: use normal stores in the x86 x4 xor_syndrome
 functions
Thread-Topic: [PATCH] raid6: use normal stores in the x86 x4 xor_syndrome
 functions
Thread-Index: AQHddZFNKO80THY+gE6am6ddczCYVrcwPfgQ
Date: Mon, 16 Nov 2026 06:39:42 +0000
Message-ID:
 <BE3P281MB13499002481334EA64A4B91379807C2@BE3P281MB134990.DEUP281.PROD.OUTLOOK.COM>
References: <20261109030805.25709-1-mc@raidlab.org>
 <avqegZd_W0kce0UA@infradead.org>
In-Reply-To: <avqegZd_W0kce0UA@infradead.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=collogia.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BE3P281MB134990:EE_|BE3P281MB6281:EE_
x-ms-office365-filtering-correlation-id: fba38b26-58de-4e10-4fcc-08df43ac6598
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|786006|366016|376014|7416014|261028144727099003|261102123227099003|261022105027099003|261021121427099003|261026140227099003|38070700021|11063799006|4143699003|56012099006|10067099003|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info:
 UJHilsFLj8h9ygYNhAeE1sk2dhFJ829urwjUMVqv2p+wexNSv2h/097EQidHZNyZBnVcch/LbbxTG4DNOSdlAGYTDcHt284n1thTjbxy7ceAToWHkmNVAIWZI3lD8fImvJSWfG/8XjHP4wzBQS8219NOYWtgwMg7/jNYM1Juvh5q7gZMwHBJya1CCDaXCkWPnIQ24wFfBwXO375mv6rujHfggbFk6i85H28huyxoUAQtQCA6znE/Wuqx1rPI+VFpKzkYN79q390vJboa9MQxqOSaV5Yvo5hpZl+m71cP5P2U2Cx/xVSQgGKAhDjm5Wr11ximKemhbTnVbOABiAlZ6iAI37BH6chpImiFBfwxZzu2Hp/xKikUQiNdE00H+7pIGfr2GJAcCycSO+ufDOGC8UxJM0LQJangwEha1b4am9u8e5G+3Tv6MWdzqRN3aBf5iuJTtA2nHDz8JqmCawYLxZWXD5LLgxjh1nAb5FINT3mbaRc/xj7u8f08ogwQSpoDO8Y2LD044/d/P5/qOn1WODOJErH3fx8nCITAteHghB3BDgSUWEuClbfxC8k4zjH60sVDI9N+2vN+Po4CvXPdxxYow4D0Et5/ikJnlplZAFZL7qt+1J3NooSgDKTHolLb+8f1RoxyJ4hps/J6YDDU/Y7ZXdJ+ZQYMfNs82ptInDXRnBkEggAT2TsMHQULP6WAm8ka4FK8g5FicCozGzJ+guaKuorrc5bkrl17h8gauy0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE3P281MB134990.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(786006)(366016)(376014)(7416014)(261028144727099003)(261102123227099003)(261022105027099003)(261021121427099003)(261026140227099003)(38070700021)(11063799006)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YrSEK0Cd6iHxFu/HfFeJASF/+0OdQSYiwmdkNZFHpaR1y7aUrsDutuFsbiWd?=
 =?us-ascii?Q?lFtEJZrWJLO19hokRZbk387Oz1O1PR5ttVv4r1oCPZBwHCHu2/JuW8xgtpwa?=
 =?us-ascii?Q?mNrX1Kdmn2PcrTivHgMx/00gHTVcRYlMGDFaTyGBv2GMXaJBrlvvG8tyHiZR?=
 =?us-ascii?Q?UltpNQBoIuh9qPtoCFuSVpNL5iAEm6AMUX2Rn4ht4XiMoFydp6V2rmsjpZ0c?=
 =?us-ascii?Q?sDavM/0tpjnYHTZsYBkL3AfuTeURD6X04RU3YKg/zdiMo0bTI3BS7fRAwxaN?=
 =?us-ascii?Q?MZAVy7qcg1m1TQ/VJCjISEbupIMe5wDr8SQvjNIECum7h1RNIPRY5IjlvcG/?=
 =?us-ascii?Q?eUFlIBnSpqWo78CzUvQLyPMfIfoAANlBS52NMyRJb/7pgnw/kWydXNo/beZa?=
 =?us-ascii?Q?ncf4OuElkoBipTBZ1nyXJshhXqqqEbHcpVGLnKeeA2OJ4ZnrWWIet7KkdOty?=
 =?us-ascii?Q?LZq/prJO1MFcpTvFah4mIK9cjk6inkDka3FJ6mwaNBsbz7m0xMNqa/ghgS9J?=
 =?us-ascii?Q?8E7drogAOpQlfNbKLIfBdep4DrEyD84neVe4fH3JOQt+e0B5QY6AoJk+HnpB?=
 =?us-ascii?Q?/16u+LEG8dZKynBNjS235aAt7oVeORvsq+nbMULLW8Dog32HWwk0mUUQAi/y?=
 =?us-ascii?Q?a7hNZk7tirN4dBT436DFExt+iLbzjtw472sZXyoFZUtAg22A9yCsXty1YSSp?=
 =?us-ascii?Q?GRK6o4e53kNmLiH2v7YiPxs/8lvDdOuCsS9QWoSBVyR3chz10rVyvdWr9PVQ?=
 =?us-ascii?Q?llwh3x0B7vSG8iVUr4zjNAw3t7hgICsGqikB4h2bg4gZIrnScKhJqsYuSlmm?=
 =?us-ascii?Q?bt7ei9GGErl9q3s8j2OOySjGghpleL+wCXHnSClfuPecjzrU7/XjrxsaSUHn?=
 =?us-ascii?Q?kuZXydqWl58nA2cwWQH/OrVDkFqWr8DKkBnvPZ7WDR4dHeu1svgnXzwNk+sw?=
 =?us-ascii?Q?1XmHBTkfuNvJHW5saRLTEgGv5fponrW5QH2hSg5FOZNmq+hqhUG7muEYBGD5?=
 =?us-ascii?Q?y6GLZrTtG0h+YwndE1x+TEpSbSyHgtdCpAliWW4vpHGR/zMsw5ctyqzw/86x?=
 =?us-ascii?Q?bqreuWgcacXiS1zOFJ/vhwV1xQ82ZXprIr2b0Z9iPdcLqwPH3JYGPWqbkI/e?=
 =?us-ascii?Q?1hvtAwKBhvXQdFogbEfeEePOY3K9x7jn4tUMMbhZNyos4jkukQUlsWC+hjd9?=
 =?us-ascii?Q?9JmmjNDMzXBe9rTmto0AuhXCjNqtASBaMbMYIMx1VV/0gKYRHfXbRqTlYucO?=
 =?us-ascii?Q?GK6J8aUtiKqSDJsCGgQxHYbtbwIXa5ld8KIsaHIJLvz2aSc50p6iH8qjUcX1?=
 =?us-ascii?Q?vzgOo36ogCmwYwo1mzAv00LkqLk0/umPGjWd4pA+TZ5MggyjLROInnvZo6dX?=
 =?us-ascii?Q?3Mhh/3i1E8nDW8pE2Eqfe4QHWyXHW9JHoiC95BDTra03qsTuAaFaZkZPKAiD?=
 =?us-ascii?Q?re/AuujqQ++c/LbBZBTMstuptheCO0V3ewd1gmcJoQVz+kIxYt7I801lQwMV?=
 =?us-ascii?Q?hlritC8edQs1uMe81fiK1CpUyUSzh+smppWuP03cUmq7ZhZwIMCNj+csNx2n?=
 =?us-ascii?Q?bOtZfuA2x+X7SEKjYecFb8l5xdKWZkqgAr6nwMzcdhBV3IUKLMKZx6nCAiZv?=
 =?us-ascii?Q?/WmSLecTDpJfw08MQKGMCRhNAmcBCLJVPbSo+X6jEbXY+YzHZuV7m66cvxRj?=
 =?us-ascii?Q?uzk4/joz0Qujpw4PiVmGkmuN+0g8Lcu8LINwGhQcHmAmnw8XpE/rQ/Mj+nKU?=
 =?us-ascii?Q?+N81hZgdKw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: collogia.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BE3P281MB134990.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: fba38b26-58de-4e10-4fcc-08df43ac6598
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2026 06:39:42.7320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f122a7c-b4c5-420f-943e-53287da7b94c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QiqcBj3xSygv8XnqlTIbJ+8y3WTcjU06YrDL78gBaDAbCytfeFcypFKDhvHVLznq+nu5J8pXQYX3Vi/G4PAl8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE3P281MB6281

> Von: Christoph Hellwig <hch@infradead.org>=20
> Gesendet: Montag, 16. November 2026 07:11
> An: Miroslav Cimerman <mc@raidlab.org>
> <markus.stockhausen@collogia.de>
> Betreff: Re: [PATCH] raid6: use normal stores in the x86 x4 xor_syndrome =
functions
>=20
> On Mon, Nov 09, 2026 at 03:08:05AM +0000, Miroslav Cimerman wrote:
> > xor_syndrome() updates P and Q in place for a read-modify-write. md
> > calls it twice on the same P/Q page per write, to remove the old data
> > and to add the new data. The x1 and x2 unrolled versions write P and Q
> > with normal stores since commit a582564b24be ("md/raid6 algorithms:
> > xor_syndrome() for SSE2"), which argued that non-temporal stores of
> > less than a cache line are slow, but kept non-temporal stores in the
> > x4 version, as it writes whole cache lines. The AVX2 and AVX-512
> > versions followed the same pattern.
>
> Adding Markus as the author of that commit.

Thanks for the update after a long time. Happy to see that this is still in
place. I had only 2008 hardware at the time of the initial commit. So
all observations might be wrong with newer hardware.

Markus
