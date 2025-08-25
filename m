Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BDF285050;
	Mon, 25 Aug 2025 19:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756151555; cv=fail; b=JL+yMv47ldFxkDs5ligQH4T4o7PwmP3q6PI7att/XVYrk9qryKjlPmZanfe1a7taj/OE3A75BC1s+WJ+75DY/Y8FOuz/Nw4UrnvqSEMBgcsAivOXBIQ1VG8l35xeruWBrXZFBF5PWjPI+Q+0OaLHTaP/0i6MxnAgqwSiQOfuIeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756151555; c=relaxed/simple;
	bh=HBS9YF3cR3YUshi8g02BoxMARqTBztFIcKF9UTMcD8o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=suh+zst6AFbCLYslVZ+l1hOZtyNwrEcEofijspdMtZEXCy8RI+I8x8SASbOs6NFP+D2PXyCoyaIG6IwCM/wiIjQMTb4ZUDt3ZfOInjavK60klseVGHneQjj/7dEIseGbpthErPgy34L5f1u+LDTePCo3naMUYqriKiefXF2uC6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I4PNWjKg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zGTszs3G; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I4PNWjKg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zGTszs3G"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PJC3sT013416;
	Mon, 25 Aug 2025 19:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CtALDyRVV1Kstt+IVq
	N7FtjaPb9ZqnWsXERM9NY3qbU=; b=I4PNWjKg/9YiVsSZTBV/xvPNxab5sJup6c
	QL8iApxebKz7Krn1yUB6bi4f7jIqnmIpAyQuHudJwKvMCaw5nmCPcNixiI0OjgfP
	Npb+EUAt+lkTGzunZpj9QHPD4TAuhtxbDSkqphMrjFU7HiFJKSkUIr3kLY59pytM
	mkObhJS0VoZtG0QH7vUCxhZ597TvZJta9eUWLzJ0t8VhKL0V1KJk2QvD9tVHviAt
	6Ymyw21pKI0/umvXBH/EbmLvpL0FbUoUGHyDM6jhYUksgEbgK/EL8MhPsbgUfv05
	cnO9LaTvFjZMdpinc9NLk68fsLWRffX+57A3fYWdrCeOBEBK+HlQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e2334m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 19:51:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57PJkFA3005064;
	Mon, 25 Aug 2025 19:51:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q438uc6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 19:51:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfI5R3wd4Q6QCeYk71YEGjQPlbo9zA0KfFT3z1BLs3UJi4C79mltB82VT/fUkCtUd20CE5nVcyK2JxBEunQzeUlNNEAzHnpOgwgWLCuXPq8YpmeeCoH/ViIHpSOj2T8ZbVOYhWfswZBv8CHnaSnmI8vxr853DxyEjUxbYUpPIcAApOjgSTJjDhjEZq1cNGNoebFO+SLtsUU5/3yRF0C2WMBcuhh3KRvmWdH1bSJdQKlNQDTwJezWG0wyUh0VtpvbW3PxZ5APwDvvKj74h3AjiraNMPREUvnkyNv3UBdkqGh8Vt/Ds2D0OnR//N8vy5Fu5vtPxOB5lWzvJRb1xmDMDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CtALDyRVV1Kstt+IVqN7FtjaPb9ZqnWsXERM9NY3qbU=;
 b=DU5M0HaDeay5sZ1Chq7R+vM0sLYHHvAaKW9YWdQnDrQ1cSS3OsQO7IOFPL4u4LJp2x7NFQBSHoQwWwyptWmGe1TWBdCdVlF4ULM9ftsU/IMUP9eXFb0PqtgukxtTGF4xdRoHcaK3WIOSLBNfXxhyD0uVBh1YekYYHg6FJ6HS4DBOQfB0JrrDdauEMEx14TDxehyvFV0JflkaaV+vSpNr6j3IBUMDlwEVIDaBKzSFWbar+4I9yH4fxp4Pa2Jx6tFg5RPLKdjr8TRTHykKDpxm30dYkY9nA5Z1OSmQeGYRJcmt2DLYzrsLwTbuPf8Irn7ft06pzuoC/VoTE9pcrWIYHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtALDyRVV1Kstt+IVqN7FtjaPb9ZqnWsXERM9NY3qbU=;
 b=zGTszs3GaINu9sXbMXuYvtftPlIesxQsqbA/UOuZnMLldj8hZ+52ctYKuSb2SCFBlkA7raJA9Tc8qyAbcl/M32TVC90N00wA5yNs8vDniG2x8+g6yAxG8TcYAmxRfDuzbjsPozjI7P6Nc9PcQQxzXdTB9umvH0Wg1TaeZ89QK8Y=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7258.namprd10.prod.outlook.com (2603:10b6:610:124::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 19:51:47 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Mon, 25 Aug 2025
 19:51:47 +0000
To: linan666@huaweicloud.com
Cc: <song@kernel.org>, <yukuai3@huawei.com>, <linux-raid@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <martin.petersen@oracle.com>,
        <bvanassche@acm.org>, <hch@infradead.org>, <filipe.c.maia@gmail.com>,
        <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: Re: [PATCH v3 2/2] md: allow configuring logical_block_size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250825075924.2696723-3-linan666@huaweicloud.com> (linan's
	message of "Mon, 25 Aug 2025 15:59:24 +0800")
Organization: Oracle Corporation
Message-ID: <yq15xebqiwu.fsf@ca-mkp.ca.oracle.com>
References: <20250825075924.2696723-1-linan666@huaweicloud.com>
	<20250825075924.2696723-3-linan666@huaweicloud.com>
Date: Mon, 25 Aug 2025 15:51:44 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7258:EE_
X-MS-Office365-Filtering-Correlation-Id: d878dda0-cd4e-48c7-8db2-08dde410d31c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xllHLHqkiIDgP5rSsN72kpTccO+0ellnhdktDJv5WVNqSmNu6Amx7OY3pi6a?=
 =?us-ascii?Q?UNrDjNPzDhyLi95QTKJHOAkkL73FsIPkrNOMKPxOzGWxItxQgseWzfFkgxPs?=
 =?us-ascii?Q?wrShjdwnVWqxOUAZcA4C0awhOvZAFXSf9s7ySFCF+bOwKo0qpp+qfgL6kEdu?=
 =?us-ascii?Q?1OCE1Vw4/Ga+JtJkUHq/7GSN/HdX0oGCv77oTQPVgQ7L8ht4x59+oc2OrPs/?=
 =?us-ascii?Q?uq1ey+XGEL32WUyrH04e/BhM2HbWZjVEb+Ub77YW/FQMfc4Vb0f5+qVNsi74?=
 =?us-ascii?Q?Io8jaw/zAN/u9TBWx5OhUBvG3RmJ6vnrfSWcYoKgxMWyM3ihqq16paalhs0r?=
 =?us-ascii?Q?CudeUst8YZYGDBzMQkVrBOO/8qN/G6FulVBQTPIuDSOcf9Rzid+/wc1EpBok?=
 =?us-ascii?Q?nfDJmv1DUFYvq2iqRMbC4Q/Uabk+Ph0RkH8ZttAy6JLVoNvKpExN7Uv05F7X?=
 =?us-ascii?Q?QYa9WPU8U0nDHCvwbK8pEQhDUSqPrtf9W3n8Nk2z5v9Wo0fKR73z2uX70JzY?=
 =?us-ascii?Q?AKhYTLsFX+tzp74KXTfXOe5w/+AzxgJC++wepSehSH/FZ7WA4tLTtcnvFpYQ?=
 =?us-ascii?Q?fcFomvUXnBVYpQ2nQTX5GuuF18DhGAAZF1lfCKx1UABRtasWmF61DlbC3hD1?=
 =?us-ascii?Q?LqXswRM8IZ6FCg3p0g8jWOOXrk3DWj+X02hmDWah3aDaMuzAo3Wp+L/2A11b?=
 =?us-ascii?Q?DRUbPeN9DNj9/UNQd4141wM7ISdFg6Ttp74z4iOuZ0rFVfdym/BZyPAzC1Tp?=
 =?us-ascii?Q?uRlYKr1OeLFrd4cwgsclZfsLacSdmUNmmr1Lj5Xg1yPLjA/g1+OjPeFwpld6?=
 =?us-ascii?Q?km+3ruSXjjP0yDNjt2QAxq2aEw6ttWqb6wzsu9NhPOXrBRlBNm9oLv5SiN3N?=
 =?us-ascii?Q?jYAgfHM7X6HfAwGC2DbKQX3cxgyo0k+KT+GBOQ06HxeVESX0NaydbgbQYvpM?=
 =?us-ascii?Q?o5fpGGuTB1N7/x4bdzvNX50xm6H7vA+JEhGDXegBZsPL0yCe7SB+/K3vTqXd?=
 =?us-ascii?Q?Etog2JKPvsWu830/VRWw0Y30IPb6Gejk7O+UC5k/Ghs3BQDvatKEmacNCoDM?=
 =?us-ascii?Q?QB7iUdAt3RqGIoDCviI+QYaOYTOwCDHFD2Bs8uQy+77nfxLrXQyzhnlF/Qvl?=
 =?us-ascii?Q?T0SWgI8quatGVhnyPA8hhyiR0QFr5Q53ydByMoVuOHFKY2lgVEx/bFNqq84e?=
 =?us-ascii?Q?f0uuSUpUl8+O01/v6ETCqT6zEeX8bTHYpMnQ0u8SbiTTV0oNNa5yKIpWEzM8?=
 =?us-ascii?Q?Qo71uTazgMSPpnBUuZ3eSNsfpWUooBcZILUmEVKhCUUJ1eVVNIU2zaK2AV76?=
 =?us-ascii?Q?sxvW+HCOQn8vkca1B3Wn7lXIdXz0UgzyGN+3lmhhVhb+edOOZE/uORphpgWR?=
 =?us-ascii?Q?OYcSiHYBhnX+mHof2Tdrqp1BW+lajxlajtbHQl4mOSsjP9IqF7LlzI54pFP9?=
 =?us-ascii?Q?Y4PPgp4SOqE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9VPud+4mLVG+BTq7ta+Mv2RHO7zu6wygAwn7h41dHT42bORrdIx3PyDzO63x?=
 =?us-ascii?Q?Mhjq13KfDqQeLUjSLGbOt/OpLNRMDLNFS7IOBlvWBleg1e3+sMdB8X03VZKf?=
 =?us-ascii?Q?TAPbUJ3FrjIDaWSHpE355rlgMj78Q4fzEcXF+4phmhTXrV8J3D/BmLLe1nd/?=
 =?us-ascii?Q?j1NyK8+FXH0aXJuQYokGA7ODy83/WgxLdmNO0zqAxXpAgBV2wqVOb+EfriA3?=
 =?us-ascii?Q?b/LXE539vKvgDiS+31rFHic13D7Nw8JuKzJZxFue9/VeHbVXgOUsk3DACxkf?=
 =?us-ascii?Q?bfbXhaj1ZezlyICY0BIbho51gEUTdtsUJT8QQVt1orpgFhrNM6kzX081RImx?=
 =?us-ascii?Q?OOsxyCNWtzH4mRXbl0vubrO22dsG7noSxKJ3Iu24t2wTc01lu7Y6SxIFwNPD?=
 =?us-ascii?Q?HQ+HmJ4p/2TCzQRKqDxWFKi5RO+1isO2TAthQ2cnHZDuRuNrg2AkIrsToQ1I?=
 =?us-ascii?Q?UrpTxYhS6J6V1WiAp4QBCJOVJGkh+2iOlYC12Yk7gL5DnVytkyWus6+doBdW?=
 =?us-ascii?Q?QnZeau8/SVc0953g6jz02mmGf1T4QY9Raff+7FWjWSum/aQIHB1aOQr3gI0J?=
 =?us-ascii?Q?ItsdwwWQyT3h6Sxd3k4/OZnBX7mWpyVJk7j3Hl7I3FLudOFjOPmtXUweElBS?=
 =?us-ascii?Q?Dd1/TWXX3UNki6oWTQaMi1BxMNVPdrooTekIocARNmVENutKV5nipZeu83zI?=
 =?us-ascii?Q?zRmNU/TRag1EdTaxVqGeFppyhRFGy2mQEUJOzkxLEcZQT1XhLKpN9FZAm6bL?=
 =?us-ascii?Q?pXCR4Q4NAM2AWx0SU2hyyf/ckBJWryGrubqKM5Upma5BtzlmDDJ2zu4a/eWR?=
 =?us-ascii?Q?nf0wt6/PXgcr5UZeymxNVCrORhDCYxFslciUyRYq3n4YLkLZ0jsbN3pBeCd6?=
 =?us-ascii?Q?2PnyZ7vIYoXzZ2S50i7WY8Cs4qN7MhBLoBfxr2h6gYCBTbEMSMiJa0YQoiWr?=
 =?us-ascii?Q?Al1bFkbfOcfL170DrJD2L0T7qEvDMf0H/OzW++/rX7AthyLppLMTddinbuuC?=
 =?us-ascii?Q?vUoKo4eOX3M+IlrXnPiighAWKdSUCN8Yg5LvoX6Rm8Q58EWWX5CH0vfmxtmL?=
 =?us-ascii?Q?PDDijdO+E8BqA7dhY7ZSRhAmgRbWMOy9yZ1w1x96DD+hRm5LBA0UWTnmx5md?=
 =?us-ascii?Q?OcYIVRngn5ceuMeWCe901mpNu2umqa84jkhiQ4i4WIwlMusVsTc/d2GHAubW?=
 =?us-ascii?Q?mkNNSyZ5qgMDk0WKxQymD1Am+1Yk2srcevP/EGwfwBppDQznFyDcy2/tsICn?=
 =?us-ascii?Q?GessQ4WsNMVmVN+2iHxS5hzvOIBSsWDfDTYjcp/c9bThpljPZ7YelgSKTaEl?=
 =?us-ascii?Q?xxfzxw6LcgOqL2c+5LsIgE9vXyiH18JmfN+j55lC+DmFIENBG0G8qRgTpAHl?=
 =?us-ascii?Q?/r4SrB7RsYS/piJxQvnf2a6HxOcCkSEAOWbXMs5TyYoJIOS2kyhbMizApBIP?=
 =?us-ascii?Q?s1I8ZS6LOnrhf9RVWhzfxRPSdYUxAdaqrsShM3JGNHyGvVH5IT7elggtArPo?=
 =?us-ascii?Q?OpAXe+UOmeVDZ62J5T4FDWz3EU7g6XavhJKYNjMUWi0HyNgHShJ+l8r+j2QC?=
 =?us-ascii?Q?NF//yftqXnYQxYoAl6/wGWkdB43yFe/Df9tt5JtGxSkyT8RMvTKrPc9EAwtb?=
 =?us-ascii?Q?nQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FCzdFhaG8DCXqEFRgwtd6N280+AdchETsUANlltF6KhZgnGqYg49uELRoZAj+/Q4QAc9yQBWssewBI3or6WA0ktO/NkzLSDY5Qlfrk09QB0XPQOtMKuY/Rj1pWoYoJm1GfCmNLifb9RwpyF9g4n2d2vOQYTjX2mAihaFHfVZlyWiWiYHiigFOIhIegVPLkNMrxGQKNUbwy7Z2b+mtqEqYA515KiKHNsenIdbXkAYsVDpMJL2JYejeznlL+qHQD/uc7+rnx61CdWdF6KloGwfTfeD8psRwApWDrZSu333UWbOp/b+MHhhjnsOQKJdjHRTSFqzcS5w3uq/tyCXISTRB2rhxwXifeBqYGzxCsgoP1BUt3v4EK4pImO9zp1XjuqJV0QWpn6nXNLG2QOVfVG2hFKUriaR2yvvZMFwbxztd2MT0gWizMYXAXX7QVzHat0vZrr3N7BO6vG8CAMLj0aeninFCS7TK/mlbwDebwGnEuwAN7oxbUGhh5tIYQVQSiSrAgCaLeazn75/aH8EpC8dgAhO9+IZW87bJGGa8+n0LPKenH6+qm9BE0nk+ZR0VFfq0TNiaRmcSblVP4vHhq1LWpyilM7JuyfKltdG0UakV3s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d878dda0-cd4e-48c7-8db2-08dde410d31c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 19:51:47.0074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HaELESNscc1I56oDc9Z2QaBlFqn6pn32LOho0VEPWBrRejDHlhcuk8PZo0R8oLWHzu6XWR2S2PB6sO16IljEDQSzMIqNMxcRWFZPwIqHxqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7258
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_09,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=946 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508250179
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX8U2DI3M54dD7
 rxY/KRlNkTfqQzwyi5Pa4Rk20Y2SSpdV24wMag4n4NSABVZjmFuADQlMJl7kdoHOw7pSTzDl4wV
 jP7C09dL2k3S76C1mfQQzv4v5/ZlMjybCTP2zLU4ruUWYtVBz+/KzBi4cLmuclyZHRG/gzJaEL1
 TuaH1IB7m6/g4qBq8ttBnHaEVhwP+qR9spQWMbXBf/opvIBRRvCtG53alW/7n6+yIgXu34Mu3L9
 T+DHoTL5tclnppGahHuHdYY2ng9jz6OUHHdWo7glbKJTYFZ+Jzufoh37g42kuI+2W3IprsjanP9
 GetdPZNLRnFLNKOZTv7kUoo228cQzXt3BnGTs75QG+16MzLIbgBF1dOJKoN3VgO74RC7L1tzviB
 wG0qMRF4
X-Proofpoint-ORIG-GUID: vGvusocIVMylK3g5SQn37_kledS-7Gr3
X-Proofpoint-GUID: vGvusocIVMylK3g5SQn37_kledS-7Gr3
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68acbed7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=2PgjU8rtQcID3_b171cA:9


> Previously, raid array used the maximum logical_block_size (LBS) of
> all member disks. Adding a larger LBS during disk at runtime could
> unexpectedly increase RAID's LBS, risking corruption of existing
> partitions. Simply restricting larger-LBS disks is inflexible. In some
> scenarios, only disks with 512 LBS are available currently, but later,
> disks with 4k LBS may be added to the array.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
