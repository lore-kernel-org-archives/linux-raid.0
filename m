Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9390D1474C3;
	Mon, 29 Jul 2024 12:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722255571; cv=fail; b=PzD4amO8pHJ9qSBpqjqEJR2h+1EWecpgTUUd8GyBgxjXsZyCS3akFTmYZFXqEtrmf2OmZQ9EXAtH9JbBXeDXZLrgnjnLTr6faLR3bHiV5s/+HuJlgtQBk+JdtSOlb5Nv9w0Ixa0HEiAJbRD0MddP9iHNzZK6M4baTk7e42+kCiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722255571; c=relaxed/simple;
	bh=2EyqISDLXg9oVFN6v0vqkZKr2vRAPDmj45hfm8CIAN4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mGB1k8+Ez1YEEWEO+nj8plrbZSVr3EBegQKPbVNQY1BcsgS/Vlr3Egyrcsg2licOeTYETdeUhV6xlUt6w7gUs7lRaokTNqy6j5kuL/xigFEiW1c52s5eeVidTMaWvCS5NRAfp8miqD80ia1Lm4K0D2KGNLg9bvRKnxIsqg9aXe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rPe3buj+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=cwOgEhuJ; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rPe3buj+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cwOgEhuJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722255569; x=1753791569;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2EyqISDLXg9oVFN6v0vqkZKr2vRAPDmj45hfm8CIAN4=;
  b=rPe3buj++7gBcuWtz/4viyupfmVQUYQEkC108IGJKPWQCiNss9SuavUH
   qEEQNvCQ2WpnKuNHOe8+rleEez8/xBkVBtPwwFh+GeGL5RlY6Tcdpzhzm
   Fe6OyRnyay6jGHQZkGSdRHRNzb23ub7W/N6evd4mbDTBJGCE5G8uXJ7GN
   qOuDwQar1wVxJKi7j1PReHeaZ2b75RA9//Z/3KaXfAf7f5FJZKyrejx8K
   lfJWAVLINdOqK7wUGfEWEJl0eQ3f8YvaIKwObVNdWCQAsKolmBloBaxON
   fdVcJXweJEvQKJwA2FNKn/Vw1xkfuKrJtrLr1NFo7Av0mrad6f2OaXHvu
   w==;
X-CSE-ConnectionGUID: 9paI+rAwRb6hEFwO2tdCjA==
X-CSE-MsgGUID: hh83tzUNRLS/WX49m9o2GQ==
X-IronPort-AV: E=Sophos;i="6.09,246,1716220800"; 
   d="scan'208";a="23627563"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2024 20:19:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+G7Uk4N5hghVKDLxxam7ruyDrl+YeMiVnOfKOtISfxYV1Hl/Myr1WrEabrIaaqHa8RJ2lTQFpMepveDyFw9FqAFQlVxfCOyT+1yrhmG4IWor1xGVP+WNZ8z/xs4diTZakH9eyIUlQVnaCKU8q8qACrU2bJzh6eIk6bIvs5F/lROm6DVti7KekCBLV4SOVG4XhlJKkrN0lJjw+pN8U5lFXZgAK50ZUQXlQyTuvKIViDEqrzSoCvN7GFnLp807wXh32/nNaQSNH1h9dMUdBhZatWN0KFQOl2ijXhwiUwKbllimm+oVez2oZKCwaYZPJGWIjZw4Gbtoe//2/UoDdL5Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWFqRHt7anBW/2LSf+GdWezwrpLEy/sFMPBCsmNi9Is=;
 b=a7lQqVCn8SdAJtdO7MJLUz60Gs2g/GW0t6/vpgul+aDkhy2Qe/L9CDV+2kHV++0S4f4YLbnvPF06bFY/8cvnq6estOOjIqaqRkBl2ce66vZm7umCkvTc6ng77h5lnTK31jnjnsWjmkNWqJQJZSiiGJrvFOiX3LMFy16O4cX7/iac5ATF2TLoq4/mG7oWXSSaNUgszeyKB5jHW/tzGXNSlkq6pUifzhuFPtlhTOz7z9hYAu3Zqy1y+s3WN/2gqzl1iF75D53S5yvc4QLFEJzX4kJ/jiJsbA9g20GPAVyVsUUQuhZXiwA8goFJBFYqUK/VxqPw66atL5Sk4wq6NXM1UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWFqRHt7anBW/2LSf+GdWezwrpLEy/sFMPBCsmNi9Is=;
 b=cwOgEhuJd3Dzk/mXsfl2Kp1h8nKPkF+htqpHMGqwTzMrGKM+Lj7/wwlYnipYzAq4h/3VqgJacgud4g3D3eHQm1LemL/IHZZIabDmTNulmIgHa8UsmuRcN0J7w0V0TPqqXvSGFIpH0BJuDIPJXzv0RtpsoLBCBCF0W6oM5FhjORU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6642.namprd04.prod.outlook.com (2603:10b6:a03:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Mon, 29 Jul
 2024 12:19:21 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7807.026; Mon, 29 Jul 2024
 12:19:21 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Ofir Gal <ofir.gal@volumez.com>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dwagner@suse.de" <dwagner@suse.de>, "chaitanyak@nvidia.com"
	<chaitanyak@nvidia.com>, "yukuai3@huawei.com" <yukuai3@huawei.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH blktests v4 0/2]md: add regression test for "md/md-bitmap:
 fix writing non bitmap pages"
Thread-Topic: [PATCH blktests v4 0/2]md: add regression test for
 "md/md-bitmap: fix writing non bitmap pages"
Thread-Index: AQHa2z065ZmjSJoGq02ojDKBcBQy+LINrJkA
Date: Mon, 29 Jul 2024 12:19:20 +0000
Message-ID: <5mct7smno6rklwptl6i7cjpklu6wquopqvbtpp2ei4kqwuiahq@ljjmpxy3gpy5>
References: <20240721071121.1929422-1-ofir.gal@volumez.com>
In-Reply-To: <20240721071121.1929422-1-ofir.gal@volumez.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6642:EE_
x-ms-office365-filtering-correlation-id: 7367b1a0-bbdd-4512-178f-08dcafc8ad0f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?2eUDgFhaGbtQR4UPTO/PRNEoTF8sCt5v+zhmY4xXV8BWkpXTWoscg3ZbKNwi?=
 =?us-ascii?Q?UmRvbDiUHJHOnF7vTuN9t8m1NbZ5hmfI0dOIaaMdzRSGg1hoQshdp+ioI2ew?=
 =?us-ascii?Q?8Pvi8lRRyxyIzamQl7f3avdOOYkJsRzkHyu85dYlEOqisfpFdiUC++qjG3sY?=
 =?us-ascii?Q?BYvdG1v48aBZwj+a7stKb0gQQZKw7MjAd1NTeoHCuiEnIkwNgIlaHB21+6sq?=
 =?us-ascii?Q?pLddT9EGJU6FoiAUTpcUt/r6qGXaxpQNt3SUOp1ZBBfqse7/dPOSPzC5aqkx?=
 =?us-ascii?Q?uDuJ/Sy+knmNh5R1Q0t08gB3p8P957/k2zYatM5x0zMw7iRomelXk2oN3S5W?=
 =?us-ascii?Q?e4c3Notc314woGrdZfbyJTTKmEsWAA9Q+N0kbaazdFe6OKFhkdAWxgTtPdWH?=
 =?us-ascii?Q?z/lVv7wU1c9B/4NGWq3qN24T4bo61vtd/NcE7J2pzEfc7jYuRH3201Yrutvd?=
 =?us-ascii?Q?/J5nM4pUb76olQ3qqmdq4JDBzf1x5YMCKYSlEU1gWtSJRCsANzsGb3gDPmBM?=
 =?us-ascii?Q?ijPUsrdZGENjqQRcNoeoGv2gyWe0GfN3jYC020EE8I641pkdBKZjFXJY9EBz?=
 =?us-ascii?Q?uygRYvdJlrIvaEXLzEiIkttYrgC6ZcYq4dblKdvs+m2aqxDGmnmKw6XFcBWh?=
 =?us-ascii?Q?66h+OrSbe6Uosfb/zUyyiLxk2RuVvTuiDs3eG8uWYOOrnt4/JFy5dANYqM+l?=
 =?us-ascii?Q?U/wUM8dnQaTM/Ahigw6D5JtgAoobuAAbUQvVGOLatsUNvALOp4Py2HnBfXlB?=
 =?us-ascii?Q?/3jOBPa4d51sSeQo+6HEezVCO1wp1QrbjW6NxaNjDmF1Ba6vxE26sUSrzHXV?=
 =?us-ascii?Q?2lIxYAVNdlM4FGR5TyDLpVEEi4IVvXnyOwHYeZVEaZ8MBqNujLKa0ydgaCWa?=
 =?us-ascii?Q?TeL07nQOLZ4BnV3upODy5UzObRsWSx7Ys/Bl+fM4eeJCd/jBDjrnt1ZBOwm8?=
 =?us-ascii?Q?X9EgsT4qUeBfEDSu4irL4XnIRpJLGhwlXrTT2gKDFn3VVq/M+xpnuygX78s/?=
 =?us-ascii?Q?5eE9r40dJDSVf3Hk5mcSzxYMtCEjgF0cNsnZmsr4YyI3PX2w7q/u6Rptj5i3?=
 =?us-ascii?Q?uacuR4EoMMt5b1zi03fjZEV8mnaer7kzcaEnhbs16dbhIgMDHRN1s4kAtpIr?=
 =?us-ascii?Q?YQ8c7eNEygYJBCTzbllA8OtoS84/pWdIwcQ08X7X5SwoKGJfiYXpg2TYUz+I?=
 =?us-ascii?Q?yY9aeA1d+oAewqYG5020gO0FhR+cMreyesl4SHeLB+3lDz1IOQGqXBKpY9lW?=
 =?us-ascii?Q?4rEX1Y6IzMe2qFT20CT0kmcbF8AverYYCzxJrjDyDhpc8kN74hiquMM8Z44O?=
 =?us-ascii?Q?gSQdE9PZLuBYajQBLPwZU5a/NhI1MSSUl2JI9JejQkSpxCla8N7hEIbqBhs9?=
 =?us-ascii?Q?KQoUy5ZRzfew2BRXlLkx9Bx+N7SNiNZH3dclhi5K7xoZxa9C/A=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?6bPTltOJjs0flwHQd1fmdkfr0n/lm1YJ/9mfwoeylDrFwPlPWLxrZIAhJ+5v?=
 =?us-ascii?Q?z5l17uyhoPkKRXs8a9Jc8YEGpyi+lRNjMTvEV2WPCRIralx0I5s9SkNkUuL9?=
 =?us-ascii?Q?KnNQiSmHd97eO1IRoQkfUf3XI07dBADh5khF3Z5iXOOAF2Q9nNzrJoh1TjNu?=
 =?us-ascii?Q?dK5bAPReT9zh+Rv4CMwjobe3GCc++6Ikhal59DZdrDJ/Bvwo9wrx7cb0uUUp?=
 =?us-ascii?Q?a4NXtfbBWz+yy/HzYtShhg5pI7igc15ofU+CXAQOhe7+5Rco1aaPCZNhviNZ?=
 =?us-ascii?Q?2uwcsupio/svg6qXDBE1OR6jPYhWA8g6+QwYu3UPbaR2UmPY+OgKsKop+XRO?=
 =?us-ascii?Q?NkxQyuUVLEXIHPc6MuoB8ED2aQ4Gi9/BssmSvetEnIBl4UViWrbTeAP6UsmT?=
 =?us-ascii?Q?1a+Qh8CEoGfdOI66F3KoyfK0il7eBkNvWbNq5DWtDo7JUfnDnW6KmU4SlUmY?=
 =?us-ascii?Q?33HX5dqlfuoueQy6x8/nRId1HFVq3ZAVTJFMJZEz/KiUr+VVM0IIJA+g+vrS?=
 =?us-ascii?Q?Ds1SR1RxAvYK0wvh4uYGfBQ5Vp1lJMIwoba+k39Q1mhsAzMxxiSU2zFQMaTe?=
 =?us-ascii?Q?mdf8aubleKgqq7DV1WM9OQZ4pPo6lk76OfYty8VbF8p1oS4t9uuaPB1K0PgU?=
 =?us-ascii?Q?jvyZELXj/Mx26T0hKEZ+RNKzVI1VTE3WnelblKE3DOGmwD3NdQG0Gip5tJL3?=
 =?us-ascii?Q?4kKNIe/Cz8cyNSSr8WlWAvzpea6emIGwMdsUgY7Yjzd7D4nalHyiUp+LApcG?=
 =?us-ascii?Q?+fEMc1R4J1xjuYXJTh7GFyEl3RIOgS96T8GuihA1kNStFoK5SxFjiFDa+aYw?=
 =?us-ascii?Q?yWJmdDxZ8LBFmuvdD+/jzf57bzdik9EET2Vv+dOFBuIfe0nSoY+IKpjv6NlN?=
 =?us-ascii?Q?NBqIRepoMgvLl+I0njgTt2YCrPBmmdFzrjpILY33FOJelCaBuWIujKm+UcRp?=
 =?us-ascii?Q?ZojlDpueEq2gszcVPPU6iIvD7HuCXZ+4dYcN9JjiCwE9Eos6icVIuARhDLD1?=
 =?us-ascii?Q?w/3eLXqooe6oWvDJEHbMguHwkUFmmRrdHemCqToYHyMFHATAk1ztL+hOGzBm?=
 =?us-ascii?Q?6AAp0kQw4XC7FKoyjoLkyK1SWmWpaNHJFrdo+dNJpK0/OEpCZcFAHn3I0IOE?=
 =?us-ascii?Q?JZP9TkudDRfnj0LpFXcyVTqFN71HAc/zxhupFjgMOPG+LAVFtjXrNdV2cd5L?=
 =?us-ascii?Q?0G1qtrTCCwnYgMB+yYiMBtIf3r4Zs9b85YFMIRGyxJ/H3SD443e2VV2X5tgU?=
 =?us-ascii?Q?MJBv+z8hKNVe+GEKq83VwvxocDirezpPGyjy5xReYGBtkvFjUZM2eUJVxDKh?=
 =?us-ascii?Q?GSsHOHID2ZhnMMXZcAg4PM8Ue3Pj7XKY8gAL0NiAZOcxgk1IuyF/tOfAbBLf?=
 =?us-ascii?Q?hBNJey4Zw0fPaaHnlh8vWuKWeJP+lXknIV9FT/jr+2wGj7VF1aC4Xw1JP82n?=
 =?us-ascii?Q?Dt5q+z3StCB40bfKywDrVoG/ZPl5JI2RxL+CoHXxfe8mKnKynF+FmWlbjb4v?=
 =?us-ascii?Q?Y/KaAtnqKpTJvGcc4+f2zL7xOdZA1xTwHvsB8MAHi0iDWzgIVD99AJHO5yjr?=
 =?us-ascii?Q?P1u877woqTJ3RP44AD8/NFW2WLYS9ZL2FFKs/ROdYHcLchxd43XsW5Ywpuc0?=
 =?us-ascii?Q?P+Ztgzp0pNgiZ1BbWyPk4y4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C07F4FDDAE80F946AAC10CD28648628F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9F/lkyh7tSPY873iBfECwQ1Gf0jsqkhdSqD/FE7oniBuQOna7NH93Y1Qp9ro6IP/vCcPzqV3pCDoc16Z2JGFVOgnIToSV34F3ZJmPVpRtGhRBhV87+iQqyJfgF4cElBAukkstWTfpoDgsI0fQ6B0ujIbuZ5wmfpcYUfgRUMSZ9eVmD06FWFbj/lXDnp38sbtN6+WXy7wJeZpORWDBj3rInibYUqm2Lzl0Zi0h+8U7GhIF5MAys1ZPWwS9Mz8XVL+cGj4fTMn6uP45xD2cTjdqLttqLuZnAXhNcOTXPQ9gVN8bN/j+/H0FPsrpp01bqB35r3pEXrlTE/xOhusmUWgt2Cd3UAjVGLU9P/XmoZ3tTlhShss2vZJd7Xin1o/m4z38FNvQWpq4PF0RSO5XEn+xWGCL96j/kFr0szcaT/eO1ecl6MQjuf7QNZUnmvsZqeHdCXhb/TNBx/d1FApv4WrBTg+7U/shZQiyx98FkUeirtTlFEHH9h2QroKK6Hy3D2esOvrvr1m4G64588dkJ3MhYsAml4J22i3zKaKsq6ngSjq6nqcNCzvSNADpiRcG4mDLC5aFwk1hZBtjkPT8N6K3NBe91dbTTYnDREyqzDvapUJVwx50726lHQOJgbWKoUl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7367b1a0-bbdd-4512-178f-08dcafc8ad0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2024 12:19:21.1287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t/fWIKGkccX9Aw052HsyA3G2GqBolpmPtHgM9/TEZ8dh9gonZDH/JH9rV/fkOT8P4e3PRi66oVKHUJ7UWA/gBLawmpdxxxi+wifJxvWTm50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6642

On Jul 21, 2024 / 10:11, Ofir Gal wrote:
> This patchset adds a regression test for "md/md-bitmap: fix writing non
> bitmap pages".
>=20
> The regression test requires a network layer as the underlying layer of
> md, it use nvme-tcp as the network layer.
>=20
> Changelog:
> v2 - applied Shinichiro's comments, use common/nvme instead of
>    tests/nvme/rc, disconnecting nvme controller on cleanup_nvme_over_tcp
>=20
> v3 - applied Shinichiro's comments, fixed shellcheck, moved
>    _nvme_disconnect_ctrl() to common/nvme. applied Daniel's comments,
>    using ${def_subsysnqn}, moved _find_nvme_ns() to common/nvme.
>=20
> v4 - applied Yu's comments, add requires() for md-mod and raid1

I applied this series with the some comment improvements in the second patc=
h.
Thanks!=
