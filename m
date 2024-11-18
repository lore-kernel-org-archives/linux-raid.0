Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6FE192B66;
	Mon, 18 Nov 2024 10:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731927049; cv=fail; b=p0mRhSnLWyWyJKwLUkrgaYjFURyKQnTLL6yHyNtHgPTNFW3nYzQk6NbkKxdP9MlEOshDc74g/ec/boR7YRxpDCu2HWO+I9PFsr2BttDToPU6rqJs5MuiW/o5c7Twf1xKN0D0wdsSUpCVrGQAX01VcT3Dx43xGIaqoTdsRypaS9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731927049; c=relaxed/simple;
	bh=UMnwj0R4PWI2JDburXOCiqnxMZmMZSqzqS/+wnXsM9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xb/JXFORYi4uiN2kWBfHxWVfEwLNyv6Sh+XLHi4UDwi7omBYSmEZXpU0jc20Uf53oFoKoW5tVn07vb+dxJVYvnoVNNXXk8x7y89ahMjUQBWffQIpW9yTQnJdvHET/xgGp4AzrYRDlrOLpd3slRrKSl0JuI2RpLWJyZPtqaPj1nw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cS5EAKh0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ky8XG+5i; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cS5EAKh0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ky8XG+5i"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AI8QaXB004695;
	Mon, 18 Nov 2024 10:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=LKaQT1gAswVTR63fej5uKXIxRxLERAbzAeJy134X9HQ=; b=
	cS5EAKh06luJFHhRBAFR196VaMCuQGWNA81kjTqiELQwLsn5jTJXM6PByYgUSte+
	doggdqBj1XnGURZYxSigFRfqDqL3hj8H5yZGwTppcWBnSpIsVrikE+XieArcIygg
	t6DHTlsIliHRfCxc5jZk+gxPFmLRO1CvmgxwM3MFzbH7kRnFNZ6u32Zqf7rGcF/c
	SdWIKSHKPwCsa/BsRiLOFMcmQjmzlJbC8TmaD5bujc7ZuJUzxOTtKIWcd7xqvPwz
	A3Mw6mjp0FK7pJlcQXT5b8z7lfCZJIYsnuKp4dKPRvDfObrLduHyhfXPOhGtPSKt
	dbXgMv9fLRriw1xECXdMeg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xkebtd1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AI8gFxF008934;
	Mon, 18 Nov 2024 10:50:35 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu75s8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=elbYuMqxjE0I55jZF1gYZuoClfliw8jFPcTO7rfwUA+h2F8sq9ZzHToSA3s+coVfLYJVHPr3e7QCCc3dYma6cUVj7EPHE18BfO5GhqafegsG6X33CNL2sJ7thdeHtnvemt0h+SyGpQm7VSK1lCj3mzilj5XY5LXIkHywCNtbV0qynmkeXkpVQHPrlWbHzPwmpDEfpVos0z4MeKDHVZB39hmHfVD2QW/ip2fUp+SeXm3hEuJlOPgKe5BHbJE5wcRUoqI251kgge/9zliF/WpV3GdmUR+i/dFaN4/kZQ/Hybi+aezfLOPJ1Vw7hFGBCLxCl+1Q36EFk1erFcfzrJiaMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LKaQT1gAswVTR63fej5uKXIxRxLERAbzAeJy134X9HQ=;
 b=fvmQDNkjicuakg+gdqFOVpIpIVObmmBI8PLBY+UdTaYEqoZR0dl1Itfe5F9/AJ6TGjH0mVQNmNoiTH1t5yNOVV0ephFpd7AjvyVwoEzDjR6dQznHmy/BzQpx4zx2luQo9vCMzll1Cs0v2M7FD4YLrWxHoziGRMKwawiQPzNh5Uj4tBj9e0NF53kwJXolDKnT5fuo6BKrRQSbaeyX1GXDmUodkCPEAOhCky/FC0w8+uOP4NCGVBaUWLzbZmhgUcLmtg2KbJNO91ef1U8dJImnhWZvfaJFxm0GnIl7vYfK4l3g24Sff40//M/T0aSSTt4Ne4pkdywCvgjTXD5fENg9LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKaQT1gAswVTR63fej5uKXIxRxLERAbzAeJy134X9HQ=;
 b=ky8XG+5iXW0QlT10RG6rpbUsI1Z0pTI57oWmr0FUB8j6JKO4tgE+BvPAGS7hOuRB4xtVieKPBuHHtJd+9n/soNPHXWHExj8fz+bYG90kZt3jdT3Dy1yixPebyolsY/OSq1FdpLJyieXtwkVPttYwQg1rhOl/Q+q3tPBzFze9lvg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6812.namprd10.prod.outlook.com (2603:10b6:610:14b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Mon, 18 Nov
 2024 10:50:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8158.019; Mon, 18 Nov 2024
 10:50:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 1/5] block: Add extra checks in blk_validate_atomic_write_limits()
Date: Mon, 18 Nov 2024 10:50:14 +0000
Message-Id: <20241118105018.1870052-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241118105018.1870052-1-john.g.garry@oracle.com>
References: <20241118105018.1870052-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6812:EE_
X-MS-Office365-Filtering-Correlation-Id: fe35d1ba-c2e3-4def-f06c-08dd07bed330
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kPvMG4d42HLZpJboT385w+kx3TXgI5YPkZaLwvVJ0hEEAyCddaxDI78AfARR?=
 =?us-ascii?Q?p/Q/U3mQ390+o3ejjwb6MoKwqYvkumJuIZKp2udHVGyYuuQPfhORBjXxTIEL?=
 =?us-ascii?Q?uoyF2rsQd1yQv8gt/sxieFJ/+sBbbLpvhRzalcHLeEb3UvQlp/qaB7KWB5RC?=
 =?us-ascii?Q?zOKm4lV5Nw11uJsoP5onFtCt7u+9Ag+rtjIMnPchWEcFEft2MOEjLuNc9xG9?=
 =?us-ascii?Q?dyGRFhjurCCaNbVS44iCK0GdK3EXH/kxzdpLov1DK4pl+F8aLCCNHoWk+j5c?=
 =?us-ascii?Q?pftz/5SPwW5xKIXeOR9K+vEXCPVyKvXxPmSFIy5lhPRLq0voonE0zSZVdnZ4?=
 =?us-ascii?Q?f8LkFbzJr+XvpngCu8IesTlnNGTCB947/H00rmwiIumPZrp2ePCZjbDyPYeY?=
 =?us-ascii?Q?KF/3F3FHBdb8G+R0S3uA/G7kWBdwoQ61znpKxSeh13Hl0eOoYnMVa/7OuZd3?=
 =?us-ascii?Q?oRy1fJ98VCX/oPnFo4uwxVMMePIEmpoyMv+V383taZir1q5fzzA1tPuelWIc?=
 =?us-ascii?Q?GHK8DbXgoSgTAV19So/qD7fx/zZq02xXkBPT8Ip6tPgdnoE3/8PJ3kJzLpkJ?=
 =?us-ascii?Q?HaMk8EKYEuRrSOQ56m/GJ6/Yne69m5uErG6SI4T5Z8BpGlTmCfSVmsvyyuOq?=
 =?us-ascii?Q?b2yVhpDE3D3Efx3rQXCJ+tIfZidwmHauBZGLU6HhAFpYOqWUYW0HPaSR66WO?=
 =?us-ascii?Q?JtGu0PK4gxJx13UphkeNyaFR2CPyaGueSvIDZuOQLH7sOlCr26kL6H6a/pT5?=
 =?us-ascii?Q?9P9NXm9kQhLtBjkxuPGshlyIYndiAv2DfM8TGE/UGbfvP24RuKP8DpvZa4NS?=
 =?us-ascii?Q?OsaACadBff0UtKOBLkjt4rsVsrKk8oMSdlSV6xAL35y+W15GFySD3vLOxASy?=
 =?us-ascii?Q?PZVMGAS9LGfuY8PsuZA9RkE+T7iaySAQOo24h3FHSkurMNtuupAeqar+043L?=
 =?us-ascii?Q?woydQGxrvTHex8aqIYbaQCpanXIpUt2GlUHm2uFcucRsgek11v34YBMO2zzU?=
 =?us-ascii?Q?NKzpIU6/0bvR6vWsPlD4tEiBsrGncn1iQ8U91jXKGdpz5ve6QNOZsxTNa+YU?=
 =?us-ascii?Q?np7UaEQUy9nBuMVbr8GtohfIypXIexWtHQ+V7xBB//+CW2jh2llhU4u1f8tm?=
 =?us-ascii?Q?8Tx8vX5aAnvoGf1fPXvprExth69mUOsazIffBpm5BI6oX8bi5qwB2SFkyXRN?=
 =?us-ascii?Q?K5GRdkwxL0PDNlQutqbjLNdbqndVuYFUGk5ZG9tTjkgEAbh7iG7QV8p/zE5l?=
 =?us-ascii?Q?ijiTjNTqNAbn4riJOzHyUO+sRRfZuztRxn3TTAxbPi+We/9bHMrlINjAYTpX?=
 =?us-ascii?Q?CjwgIiRRr+ELsDbECG7aUwvP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DoVx7i6VgMbUE7vsskSbUPMaWZYVhB49bN9MwtpAnp2DmaRDzBy1fnjp7fRA?=
 =?us-ascii?Q?1R8GeZzhjWolCmPCE7HLk2A8IlmVWqPDpxLQTrUQGRDIyfa3BFZzJjrvmioT?=
 =?us-ascii?Q?/dIuDWhPv1krJiU0Uh5J9Rkqrov7cAadiimLLmzEdlilbKGcjtGU+LwrwuPK?=
 =?us-ascii?Q?ZS/y3nlhL+sbaq3MJdobtKnZzfZ2Efil+AGUtp/lGmntG7yaaTHI1R4BDfHg?=
 =?us-ascii?Q?tAKDdrOKmiXyroOVBw6wj9tPTnamPqGcRhirdJ/SAioigqCtVDE4llDpLcDt?=
 =?us-ascii?Q?ynF3P+F7GCXFMyzNj3MorgWCe0Xx2St5jYIRK4xMrUmx1yAkdV1mo7VhBJbO?=
 =?us-ascii?Q?Km/GM4B4Y/xURGxWCeH855Nn7Ij49FZuBaucpOnYQZrgmdgwZqVwBejb1cu6?=
 =?us-ascii?Q?Gj7TnvU3br0ihA5WmBedH1qIOk0APHH+/ezlR2Xp97Z1vcQFwIBeE97AbdA/?=
 =?us-ascii?Q?AKxCISISmyTPK47vUvycjrdwqDV3KHsKGxTUap6zCyn5QofuSWXuSFeNGadj?=
 =?us-ascii?Q?G8P/lg4axERS8eS1MfhdOZWGsPQgqTnuFl6q4FGJEQqkgGu2AgpL9Nwl5xx1?=
 =?us-ascii?Q?07dq6LmsVmeIRhnAv4cgJ9B7l9HIXELAAq6VfXjM9r1XX92PXx/vfvkllq//?=
 =?us-ascii?Q?seA+mOQBb+GebBxxcfoTzZcD4jUtpGgByZ89dE7Jbo/luXLjccQcNAPUa9gK?=
 =?us-ascii?Q?leyvKkSNi0GxRnbR1baAiTbT+r4Q1DjdiWOk2/sDwbVyylHp7Vw6WAdzcXYO?=
 =?us-ascii?Q?tROwGFcah9npebMAoEh/hLA4SPNZVkuzW1uiRj7sYnlxsfo5imAea4U7UdbZ?=
 =?us-ascii?Q?3oEgexBBCSVtRN/kdZFicEolW3zRtE5ft7UKUw8jeA9RUx63ZR9ol9KkLSpZ?=
 =?us-ascii?Q?8cunc+sXEiNxeXoEQA6jtCRwtcmLLQcUEMwF25/FdjjYVm337aUw5WxDIkDx?=
 =?us-ascii?Q?cH9DiaQIELhdLVIwp7t7HWxqSTdHWrb0UCwtoF9tHfFyOYMDMffiXPzEuc5c?=
 =?us-ascii?Q?TyabsrZEdMS3l9lQWKtVc3mTybPrFpnmFBcIvwna+vkhYSLrAU6TX0pXFCNR?=
 =?us-ascii?Q?QLIa9u1JXKGblRMWRbOkqzhfdEZ6ldAmKaygHxX6jwicB7wMg7sH9Eib3tpo?=
 =?us-ascii?Q?nLIvP3AWHLmYJT13bVqPhX0JCQDymTgrYRioHFzZ+TnG6jnbcnK3sGZSfh13?=
 =?us-ascii?Q?GiPcle2eLyqrpChThR+3dlKlEA9F7hUjhnWk0UwtOITQJS4zyvGuyGmxwvT8?=
 =?us-ascii?Q?n1837bB0ZkItPurjAfzTlFOWIgXdVo5c/Y9/1YpPT4f148oCXQXre/R4A+vD?=
 =?us-ascii?Q?MEju7m1ayNtZIGjogxMHvpE2yFrq8YBzCOYrriLFum8Eun21VKRWob0U59IY?=
 =?us-ascii?Q?ws6knNBzUGzumjXBqIEtkFofU4IyOWK4Ae0woIFVVGVBJJF7LYadkFR6IddY?=
 =?us-ascii?Q?aMrwK/e/4+lo1+o/kZeqtCX7l5GsgPCIIBzSfBBe+Ajq867lr7nnxRnQ58Kn?=
 =?us-ascii?Q?SPcm3YKgJG6NjK0o59x5sF36AgQnnpWQPUMYOs0Au1KOrHkQhbyrR0U/OmoO?=
 =?us-ascii?Q?OJbfKlRgZFvVAcQmZXOBj1N2+UV+FVS5AlGeURWmQmtXd0ysU8Y81NS918Xp?=
 =?us-ascii?Q?1A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R/cmSF7KE+ccVvtBOetk4ma+lIKGY5XToI1Zgg+ryCQFKScwJ8UMBaBtxW17S+5mVRLBYEgt+Gc7PT4chX9c/lS/WYm+0qgFoL2gJKFvvLeYjNbxNhRmIe/zwPWbkbi3RjMgirFz7dKuLEaPrJUVTVn6deAbIZauglN/aD+F2uqfy/VNkAzcCD13GW5UrZx0bkuzb9nW2/3W/2Xyp2tS0ZOBYBwN9zqpLKUfouXtofGPeqY9hLQC7LlSS3TKTV5dP7SUsmi8i415DM/rvrOvEa0VNsHFUb+xpu9N5BtKCtPuto9ccprCCAPfh0PpKQM8lyv2271JOgWRQ81OOFO5WdgCyJpb8fwce2kfwkRa9nXmRzvzFUvS+vihOcn3X7ztUpL+0MVR/ywE3f3ZwVYDe/74n9sXjAFyUiUvF7PGZXadhXgeFXW7WQWvZby+8NdFWGSCp38cBPFXADuT87RKe5D5871njveJ8szJgu2NUdFP0rpIPpLE63+LJ+u+1nznlXPPiGgR6ETNG6gUBc80zZTJ6nR1PUqyfqjdLZlKRGI6GxEMug0AyTOGHlu2lQQAbw7QXzbPTeaZt+GUEGWsGsfJgiBjUfmvwNZ4lrAokoo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe35d1ba-c2e3-4def-f06c-08dd07bed330
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 10:50:32.6225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xIN+LNQBPD+kdnxRH8jbxcVthy4akZYWtvZEi1Gle1qSCbdNSGvLHcDlYecNhh5SUY+BIvKGWmv4N0BhmZM29w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-18_07,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411180089
X-Proofpoint-GUID: CHbTWgA-YjoFpTpiyTERUFz8rowo1alX
X-Proofpoint-ORIG-GUID: CHbTWgA-YjoFpTpiyTERUFz8rowo1alX

It is so far expected that the limits passed are valid.

In future atomic writes will be supported for stacked block devices, and
calculating the limits there will be complicated, so add extra sanity
checks to ensure that the values are always valid.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index f1d4dfdc37a7..cdfebbd5f571 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -178,9 +178,26 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 	if (!lim->atomic_write_hw_max)
 		goto unsupported;
 
+	if (WARN_ON_ONCE(!is_power_of_2(lim->atomic_write_hw_unit_min)))
+		goto unsupported;
+
+	if (WARN_ON_ONCE(!is_power_of_2(lim->atomic_write_hw_unit_max)))
+		goto unsupported;
+
+	if (WARN_ON_ONCE(lim->atomic_write_hw_unit_min >
+			 lim->atomic_write_hw_unit_max))
+		goto unsupported;
+
+	if (WARN_ON_ONCE(lim->atomic_write_hw_unit_max >
+			 lim->atomic_write_hw_max))
+		goto unsupported;
+
 	boundary_sectors = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
 
 	if (boundary_sectors) {
+		if (WARN_ON_ONCE(lim->atomic_write_hw_max >
+				 lim->atomic_write_hw_boundary))
+			goto unsupported;
 		/*
 		 * A feature of boundary support is that it disallows bios to
 		 * be merged which would result in a merged request which
-- 
2.31.1

