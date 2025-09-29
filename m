Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54A12E06C3;
	Mon, 29 Sep 2025 13:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152074; cv=fail; b=XsZcc1Ocj1vdpRqwQLnz4c28YjBzhYF3ChKnIUbYNIZl/7Wi49fCu7zp+hizJS1N10C2vIlJzs3ZTnrp3AHqJG1RjART1UgzbRe++3epBLeKMGdyNaLH0ABtbSxTMWrC8MFgoKlhI5W4Zu0qlLk6sxyXhvFajch3Fn0FyORFhWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152074; c=relaxed/simple;
	bh=UPWtc3VHPKBthoBLHuvQC1wz4S1xch0bQ+fUqOTHnj4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EOzNDIzBa+8xn3jpljIKkpJhvSbDWBG2j7Mo1iu3K9/y1tIef38JS+1e2lw/0VvhFJYMbEgP0cn98frAgh1oDfmVYK4ku7cEEPh5SmFl7k17vLbI7P7jXV2/qye8w4HXQya33j1OKUN6JDHUrxICsdcTC2lvOL9bGUeg0V0LZiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GZVJ0gY8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=pGC+w65z; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GZVJ0gY8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pGC+w65z"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1759152072; x=1790688072;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UPWtc3VHPKBthoBLHuvQC1wz4S1xch0bQ+fUqOTHnj4=;
  b=GZVJ0gY8Vy6lBtvx5T9ULl5aKXoAGElQ0TugW3JrTJMHY9WW8aIvcc3N
   DjLQkYReBOZaBbExfIW6uhVD5l67dkbsB1PdytNl4GZMQyfGZb1yHhYnS
   eKPrY8Gg19jMKM+zPyonYsHZbawwhf11ZyMy50EqB4ZsnMXwrUoz8shY8
   tysc5vUslw2+1NNC5LP6CB8vp+2k3CQ20uKn21bEUuVhHMc04SBXaUVxx
   nWUigMT03GIYtpMi6/+hjqKYitQxEC5saERxsOwR9WXc9Uihb2JXyRYKT
   QjSvEw+kQk7xjbCKRAohpkqHYeqmAL7Ghh0dO4hWio8jqRQ8N6thxANmE
   A==;
X-CSE-ConnectionGUID: cFIrKM7PQ0qpzTnixAmU3g==
X-CSE-MsgGUID: pl0i/RXFQwCaqqC2mMQZeg==
X-IronPort-AV: E=Sophos;i="6.18,301,1751212800"; 
   d="scan'208";a="131851969"
Received: from mail-southcentralusazon11011062.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.62])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2025 21:21:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q7+KGWi0EyFQewRXBeficr74S5bs5k+Q2cn+3MGOWb+DO1NjRfSkMv5lKwohVkBU6I4x5YrORbJU5y+O3RjGvmxb+4e1ix1rat8eRb2T+nfQ3fCujGRhQG/f+2oqIljGyy9d9lGIXbQe7gBTU8YKUyIOwOMI+LjbbBhIxz9ONkUusRYrP9RYqhbwKFjqiIeqHcqjh23ieJu3y/7P56yYrUarSovibRrwjLpFZbvxiUI/m7FK/5Geyz6l8sLq5CXmkXEEYa2X0G3DX7Nn2XMy0aBo+zSsqhegp1fzoIMW8zpywvhtH4iqnRZPK4UJpUQefXHSpVYfEO/uESFSUQZ2wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1LUuXldqUOyz/3paDOpOBXoYVhS0WATVWmbt6DE3Dg=;
 b=UujyRGu0bnRP8MFF+6MSEIAkRdG8SCqgISu7wlpj+tPOLfmWTlSZFUqq0QTBpMEk4HTQYothyC8AyMFNvVxJxeQf82zlPnj8QGgNLJZ/PyHnqkwZK8++zvvWuhD0lk91fWiklZ6brx6q3j8Rdm08z6igGhliLqHbsioyCqsvh0WFrXK/0wGKXH4uLCiojqwsCu0oWwh1WNoqWe/lA7gRdghBXSafppD9k+GW+pV8ijPYVN2JCnlm0fvrPktp8Bhi/1VvumeWQGwlx8HOROEWB5PVjPVI1UA8JQ40bdPJFledC5+ubGXqs+USepkZ2HqrgH5OxKvJfcHqMEzRdmVr/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1LUuXldqUOyz/3paDOpOBXoYVhS0WATVWmbt6DE3Dg=;
 b=pGC+w65zxPVJMqvapUurFMSlDwv2olU+YzZ7j+GVdp3csG93txaVUXnRPzWDFSfGcIX3uGZW+qrc+yLUIqInGliWpJ8y27lpZc801X7cKVaIZlLNgkM8pw4oKqr86xDt/EuXhbkcobU10l3UCsurcsxc+z2kuCKS1a7OwOjQbJc=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by SA2PR04MB7516.namprd04.prod.outlook.com (2603:10b6:806:14d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Mon, 29 Sep
 2025 13:21:03 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 13:21:03 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"yi.zhang@huawei.com" <yi.zhang@huawei.com>, "yukuai3@huawei.com"
	<yukuai3@huawei.com>, "yangerkun@huawei.com" <yangerkun@huawei.com>
Subject: Re: [PATCH blktests] md/004: add unmap write zeroes tests
Thread-Topic: [PATCH blktests] md/004: add unmap write zeroes tests
Thread-Index: AQHcLqwtqqVPOo8UV06/Ioui6pvwZLSqKnSA
Date: Mon, 29 Sep 2025 13:21:02 +0000
Message-ID: <lkyvsmrsep4dh7tfunhplltezt64g7rvsbjdknhdk27xby7hox@j23hyvhr73m3>
References: <20250926060847.3003653-1-yi.zhang@huaweicloud.com>
In-Reply-To: <20250926060847.3003653-1-yi.zhang@huaweicloud.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|SA2PR04MB7516:EE_
x-ms-office365-filtering-correlation-id: 25724a87-761e-458b-6bb8-08ddff5b0a23
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?hk8UR9WO5O3vf6zoctXSRhlcCstnnyujii5NZZxL6J0r4gJDZy2DMXq24XPv?=
 =?us-ascii?Q?TxA0BiuR5S5Eqneru6iswot8i7nBvMQpXijswTEx/6RBUJRgajaCJo2asuyW?=
 =?us-ascii?Q?rwO/RW3hzocy2H1UOpu2/6vM30cQRft+6GxeukPknj+rY0JHtpZ3j3erqVor?=
 =?us-ascii?Q?hBHbtHrDZrRAI1LLpf6LVPwTAyX5G5oUpzor7Sah9ARP+oSHHbgsKbjJjwQQ?=
 =?us-ascii?Q?aCHRlNuC4OI91V32ebGgSapEZXoBeCKR4o9GwOvixnfB5/htqNe3Vly0AWvU?=
 =?us-ascii?Q?NgbypQ2KTWzomM+4xaKvm2LVFOGyFKr/8J/C0lZj+FuqNRO8cuoXteg6o2X1?=
 =?us-ascii?Q?heN6vl4btuZSlpoLQhNV9jaZQT6hdGxe6do4rN4eMbQieupunzs07U2Ntvij?=
 =?us-ascii?Q?eQWkdiJOXgWDE1k6ScuOqkGDWKqX3x6moQuU+LIG7rInjSqwWfm2qq9gZN9W?=
 =?us-ascii?Q?XP3c/7duoboMU8hpIPik4ORKXf8V143gSceXgBryDbmiqsKE8nIjAY3zJB3P?=
 =?us-ascii?Q?tGrGWRgst0g/qb8ph32XwvlJNjuFPWMSLiK6CdbmpQC2IV/BHsxyNaVGaWWe?=
 =?us-ascii?Q?cSaKkxOiKG9uNGtZqg5YLSJ+8IljX0zeZf309fFq4/0pPclf1bkE/8fD9hDR?=
 =?us-ascii?Q?T8bODT2tz7PNNcZFA3YR9xTJahV9fvbMKhwa5L3Rv4oFdlGsXOan9hO3VaMc?=
 =?us-ascii?Q?KOnRHHgo5LSjO4EHwtIKhuDMXzBVqOYlXSILFuwt9d8UGVPZvSpEX8qX4R5y?=
 =?us-ascii?Q?4ZArDxMyT+UeIaIyQ3Pzy68WPFVxPVUqAtR4Xg5kAuX9PvnkZ+Wk1Rokxbm8?=
 =?us-ascii?Q?R5y7+4f/WvMbK/xdhCaJYTJe6EktJZJ9o+qB5r9wkKkRHrc4GZ9ugIkn3/EX?=
 =?us-ascii?Q?MhJuUZ5T9ku4i2PVrV0+/nB4HX6cLSJ1WsI87Tjmwbq/2hD3XSYTAoaY2axX?=
 =?us-ascii?Q?NXNmAscUwUg/wGYXtSJqcXKHnWrlAZ5a6A5B1JejBofWstaC4bSUHkRBgHxc?=
 =?us-ascii?Q?jHWIONFUF46bhYMF6gIMtCZKLL9uf/RAQhJOnrBBXa3YF75RjF6eKKoI53cj?=
 =?us-ascii?Q?QQpjOPPmdp2k9sLpQp4rhL4YtU6yPl5H1jmbB4dUhCQGteY/NgVdnIbsjFyd?=
 =?us-ascii?Q?QFEEMme5RYI5mOuB8ZcjjpaQ2X7/1YR3Bb8rmltNNLXoC51BdmU2szvPMC4s?=
 =?us-ascii?Q?B4Q+RO+eOoZ0q0Axgb6pciFMAiS/kuIMCNfoNq2BicZ4CnQ7h+qvzvyganOH?=
 =?us-ascii?Q?q0R0Ja8qAZauIBfooQyi+XnXL0g/3JONTeHwtJwmHj254moJ0AU8Szk6WXSO?=
 =?us-ascii?Q?v7RZ442j0tIVF/74d8j5JVDKpgtb/KoAlWP4gQAh9LZxHdyvg3YzLx0b3NCQ?=
 =?us-ascii?Q?0gl6yBbXBAnkAOo8xFXxA9LjgDbRlD3QVBr9pDCkgQKZC9BQGs9kGslcmjx9?=
 =?us-ascii?Q?sqGjK5/RZbsbYt5V5Hi81AJx8KPOuntksgQlb3OF8qxIwQiU1LrihbX+WVZp?=
 =?us-ascii?Q?fLl3aY6DFr7+cujHTb5lSe5rxXnS12w5kmdq?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UcGKyUo+W4rrvGDg4R3AWkeje58ZImT2hNBgCRvT9OGoHatMOhyuXtohs7Kh?=
 =?us-ascii?Q?6aPQmpPuU/ZqCwQSGGewZJbeLJTInaar5jDIMDit9w6FCudDGoZ+jtbomMvG?=
 =?us-ascii?Q?KE3n/lR5GL/DC6qZK/xT1i5+lGGQ+QGuTSGT0cgl3qAiFj7VpTpnoEY2j2oT?=
 =?us-ascii?Q?rePkLMeLHocucuy0iPvxC9gU47LXYWRBvJMPFsh4E14jskWVL/cureLE2cM2?=
 =?us-ascii?Q?vdQL61na7HSMfi8cPnND+vnPJAF0IQU83eaEnsdnqBn2wMmGE90DHftyxpBW?=
 =?us-ascii?Q?I69WrQmkqmVNNVpoenL8qz+frFZCUIx1GVeKMmnjVyEvab+BWEeGdbzavF89?=
 =?us-ascii?Q?QN11daIuvw84LJZyiM0AOtxcLZyZ1SDZFpI5hn1z7SJHLe3VIpeYvSOTFdQf?=
 =?us-ascii?Q?YLngUpx2rBWtM8wowxwZyP3Rq7O4Zhjz/voLDA9lJLs/cd7kxuR8wQ180tWu?=
 =?us-ascii?Q?/yhQ8HQW36AyBjeANu4sAFP5oGLFZCrjW3vYyovifbYpzI2szHzv5D2bEA5m?=
 =?us-ascii?Q?yD7x1+Cl6ismzODw93jtpuHCLe2KG0zcU+v5tS21w/ilIygWA5kzf/B9bZ16?=
 =?us-ascii?Q?qStDhBnyYjyhK3i2nek8sUMDhhBDIxMuslfeB/XrBksgapN8FiZJ3qXPNORy?=
 =?us-ascii?Q?wd519wrWTzLeCb1v2YsTKaW/9fMfjY2gA3SVdkxrKqd53SceA2SWQztscye0?=
 =?us-ascii?Q?Vdl67hwrMCAGctnfdOIjMpin8n/pJifdzWJMlTsP28CsmtDdt0OIK6wrGBKL?=
 =?us-ascii?Q?N8+WcYCFSW3PzB/OLR4ZuY/ePR9aFxzyyLRZLpYdWp6h5gzf/4Rf0ltIyAoA?=
 =?us-ascii?Q?7NdKfedYn2rnU18jliH7tDVEcRQQ1VGQzGQplzkKd8uUQbQZ6XjZScEjOARX?=
 =?us-ascii?Q?LpR+8R8NdgFdqWVHH+EgjpaSDfqsw6pl4QLkWxU3c+Zk8NaD6ynBa5t3yheb?=
 =?us-ascii?Q?2GP5rf2xsMOeC53eiIPRQFz+IGZXozCkebJnuKHIQzyTCjU+Pj7NkHxr1kyo?=
 =?us-ascii?Q?k9J1WE72veZ9snIh2N2MyDh6/w+5qcx4EelRUusveysuxAeAil0hYh3wSNPj?=
 =?us-ascii?Q?A7R7J9JzhcPApMa/KxK7jTwHJcDWAnd8lvj/h05ynb9RsiNAn3E8ZEGZtfCH?=
 =?us-ascii?Q?zu3cqWmYPP8Iibj4skDENZwIAfDdl2YRE/diwXbwHNVhEa7bwGKoi7S6wjU8?=
 =?us-ascii?Q?fgig8wb++rkgVWx5M17oAnB/O5VaAfUevfOWQNtRYOFxUqLnRrJaRq9EYXmr?=
 =?us-ascii?Q?dVPAiFlU54A+HNrlhhxFeXNcY7DQinhJi3hjtB3hF+kR6OkdQQNFwXzz+26B?=
 =?us-ascii?Q?7xOYrGEUgwZXfaCGXzqI7jkkxm9yiqDVYfBtCxnCeP+HMMJ1lh5BnCdVmnsX?=
 =?us-ascii?Q?BENLaMtGXAHiAvX74BDO5MCplIwsv/wC+JOB2hupX3TedYHDBp223Rjf6HaY?=
 =?us-ascii?Q?0k0qphet2IM/5KTwHLtjtvsA5vcpwALc7a32VS8buv8ulx5LM3f2tgUkKuDT?=
 =?us-ascii?Q?Ml7fG1vlQht9BYIMpErmufYziW/u7eyWZpSUcIl58X/AhybQUCtT6V5MZ5Zk?=
 =?us-ascii?Q?cK3D3aKxTY+NTLtZR2m3j0QO+Ts6EnxCVVUzN1JsHw5d37R/xQkigY5F5+XU?=
 =?us-ascii?Q?9g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3F532471DD97D542BB3A1EB14621AAFD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MEEQZJ0nMCbculLQ7jJFs5KUxcS4rK6PRtk+G9b1rtn62P45JZkp8HAd5MoDKuXta7oFnCJQ7k0+PLpEwxWdepwzNPPBxeexieh/ewbHPSIkbKKBwlgZ+cT7A130vErOdjZLwxJiSlzzn/xLcPdyymy0aINUlt7Ov28l3hPN7N5C5u1Jwe/HDEu82DViFeNMjoO+z/wLzBi26GQiWdxgNon0gnMo4Up/XbH5SvNM68XtvmTvpDyXD5o5dAIYuaNv0+3yuJhtT1Vzd8IoTCRr6TE4PgxOr0i6SUOaVcIeh7YkHi5BCo4om+0AnD6PDnlW0cQTcaPHsWjg4vrbFe2kLQbmpFYrhzNyOlYiuxHb7hzDg4hGx14cb+60YyM3q1PBW8vAKjWkvI74/TrX5flv0qUVI33NaktnKpByEscPL/G/ZFu2VhKvFxEbjTRCWD/dOaBAaOIElFrluKldGCQSK8/RtYXpKaEubRN4sufOX7JH1f2MJKzHV7q2qUQ2/yMF/PbSfTGCHQRtaSBbM06dftY3nBxfw0shwNQ3YBdeETeZ+XWTvT8ri6T27pR356H0UqMhLwDSiej2esnuC0lyCFYtfRBo4QnsWbzlvI/5AXDpaa54jwlHuGmJCjigKrNL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25724a87-761e-458b-6bb8-08ddff5b0a23
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2025 13:21:03.3258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PlwNheSuunhYhDQ6zVRTKNvLmwC6WlfOT22s8ls0Q6gD41OodLr8WcZqACPqN7rtwl+1+nPNJHGGylh2mujazwyi2H/IkusGs6BX8nRGVW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7516

On Sep 26, 2025 / 14:08, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> The MD linear and RAID0 drivers in the Linux kernel now support the
> unmap write zeroes operation. Test block device unmap write zeroes sysfs
> interface with these two stacked devices. The sysfs parameters should
> inherit from the underlying SCSI device. We can disable write zeroes
> support by setting /sys/block/md<X>/queue/write_zeroes_unmap_max_bytes
> to zero.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Hello Zhang, thanks for the patch. Overall, it looks good to me. Please
find a couple of nit comments below.

> ---
>  tests/md/004     | 97 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/md/004.out |  2 +
>  2 files changed, 99 insertions(+)
>  create mode 100755 tests/md/004
>  create mode 100644 tests/md/004.out
>=20
> diff --git a/tests/md/004 b/tests/md/004
> new file mode 100755
> index 0000000..a3d7578
> --- /dev/null
> +++ b/tests/md/004
> @@ -0,0 +1,97 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2025 Huawei.
> +#
> +# Test block device unmap write zeroes sysfs interface with MD devices.

I guess this test confirms the fix by the kernel commit f0bd03832f5c ("md: =
init
queue_limits->max_hw_wzeroes_unmap_sectors parameter"), right? If so, I sug=
gest
to add here the short description like,

# Regression test for commit f0bd03832f5c ("md: init
# queue_limits->max_hw_wzeroes_unmap_sectors parameter")

> +
> +. tests/dm/rc
> +. common/scsi_debug
> +
> +DESCRIPTION=3D"test unmap write zeroes sysfs interface with MD devices"
> +QUICK=3D1
> +
> +requires() {
> +	_have_program mdadm

This check for mdadm command is not required since it is done by
group_requires() in tests/md/rc.


If you agree with my comments, I can fold in the two changes when I apply t=
his
patch. Please let me know your thoughts.=
