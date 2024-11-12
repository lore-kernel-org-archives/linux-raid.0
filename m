Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8232B1FA85F;
	Tue, 12 Nov 2024 12:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731415424; cv=fail; b=d3hlFUchN8QCf7uTHg0DnGBmmc2l4UoJPpnHvJG20IWgTq1oCUZkJEVVy9t1omd1l17iOGGULp5V5nmG9LVp8tvOVJyuEQAaOMfMVWzh+v4y+5/dfmpwdeEQQ8HfLTqRZI9gNtGOxL0J8Nf/ZW5f0arN0lYQZFdLZqLxD7yvd/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731415424; c=relaxed/simple;
	bh=Xz9Z30ZTkfYi0F4uiVst9jahQNWzKKQNQ+COZh2wCK4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Lb9snwmwASopyPM+iogWGYb3i9Obqkgl8NsBmfJQWWN1MjGsUXHUyfnGcorrSsoZpzuqjfgJadOIUrEzOl5uwgS7JmhN+tYrc9LjuDcrT32d5wC98sXP/yDKX6W+MeC5uRjl7q5Z9lncL5yWVSKxjoJOsp5RYEvWuPv6s4JDbhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gLq2cqow; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yS52w/we; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gLq2cqow";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yS52w/we"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCfiIQ017443;
	Tue, 12 Nov 2024 12:43:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=eshDoH+qO7lGHZ9+7QXypbf1EQFLEYIUd8JIJNGaL00=; b=
	gLq2cqow/x/mOwvxLPT5s98/FGyXn2fJlWKQc6euHkQaZ3ygLOH/U3EkEyIIeqrE
	RkX9aifISotS4My0njVrdt4bAlnxXJOsPXHltbmM6XrhGgVND0koHjh/E3D9FRsL
	e4O8A9qSblPTcnA7vQ0RgML+NbUMbIHwVEYCAKmAU9s164EuplRmCs7wUHuScGHr
	Y3e4fabRD8yvy5hfaKdfLLT/8H2D0b5eY5a9w4tdpMSO83w8XW6KC2gFQwxDjmL6
	gxaLUKRWMcdjXL18ZmmqF5L4/pEM3EKHi0MonKDiV7g5BCdZb66aKKYFNqCBQxiU
	5KGAxOixQP2g1Thw8yjlaA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0mbc8fy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCX4Gd005677;
	Tue, 12 Nov 2024 12:43:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx6825sj-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FnkLPwz1M3lHMe9Prh9RnRK+7OvA2jE36HCUcogyL6rxSJeMLSUaKFWU/UccA8Cp1G52F4TaxVlCYaROyDhEiqMyyJ9N4kIUNPEpy8LW0vJVUOFwYx1ST55+MxSCZLF3k+MmDoyrRKQJvL/Tut5qaKGcSz9o7tCPkGgs/v3hERs+psIMch0r2WRq4kHZFqhpiusZB7u6E/iLKWLcWkit1lNt2rUK5yu1HJ/nf1MY21BSJmlBQD6q38nUz/NpUipxqVdsFclEwocDXw3HZf5B6Ky5mcBc5MRU+u3BTFvHMnyAU9n9QQGM5hKb6Iw36gy01oGbsvqvBswWg1OXFsJsFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eshDoH+qO7lGHZ9+7QXypbf1EQFLEYIUd8JIJNGaL00=;
 b=p1Y7W4axd/upBZA7FJWZWjACbmj75VwCKtsxsXbB3kPRwzDoo3+ehWY9jNIcW9FVtAHzZ8kwuWcgwmG6/h50femEDSXpmCalzOa6heNhYJF7uq/fpGIWmXt6RkjmrvT6x52qXcNhJI4ALbE4YYfCHtAgmhAh3RE72LUYmqT1MuvCqHPa6l7TCJMcS+i+UTeXsmYRAIThcDWvwedLVjoTwN5wEg7CyUXZenoFpe9zDzcyAsss3QCk0gRKsXbxxY788bqXFEWzq723x2a3TcPg5lo6COWy9d1lOxdjaod9L4u5BkVbWni7iXJa980IcVri2jh08hoqItdT7d5HORWbYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eshDoH+qO7lGHZ9+7QXypbf1EQFLEYIUd8JIJNGaL00=;
 b=yS52w/weZ5EMRGwNHYkXbqyKAiOxEVDgYSimioJ42pwCoQ/5Kk1Uc53mxPcURzI7WIiGsUZbDatROq9/aA9Li+cK8noBcykJRLKgX/w11MxHI6uq3YOgodaWcUlg0AhqcF25cy44qSC5W1rjz+vt5x1Us46fbXMhErYBHnkDw0k=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYXPR10MB7974.namprd10.prod.outlook.com (2603:10b6:930:da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Tue, 12 Nov
 2024 12:43:15 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 12:43:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 5/5] md/raid10: Atomic write support
Date: Tue, 12 Nov 2024 12:42:56 +0000
Message-Id: <20241112124256.4106435-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241112124256.4106435-1-john.g.garry@oracle.com>
References: <20241112124256.4106435-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:408:ee::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYXPR10MB7974:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a9ecf64-e6e4-4f42-2cc9-08dd0317933f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3mD62HkxaW0RBTuQ3rpRBlqe4hClDiNDGPSGDHQrYGrUwVreajtwbw6S9Umb?=
 =?us-ascii?Q?zZpliniKuW7Vp5BK9eSDUwNNd8nsg1e7TqWpbvz2P8s9g9liWXaPveJdTgPl?=
 =?us-ascii?Q?BnLKGct/9QHDiPYZ4hXK1GpJBet9WKmBD8emST21B2l+BiboYE9ih0eH4kxP?=
 =?us-ascii?Q?R3pEQcEhpBQ0g8tONKMiqxbDfqJR++jgCkrB+pdPhN1M92nR+RQscQNVIq1v?=
 =?us-ascii?Q?TOg+zaGB3DqZb2eLnkl2Ot7oHGoKyuIoNFFvg/L2MkfDTzenZP08DzeTJ17L?=
 =?us-ascii?Q?a0N9jo8xLKICAJzJKYw5WYZs27+lHmZBdtuyy4Y3MppP+rbpan74I4DzL4NI?=
 =?us-ascii?Q?L+SP8GhLpfI7RLgVFuLNnsazCNnCiAXzlNU2x7FykHp6pA9mxbw+XgsEQVyu?=
 =?us-ascii?Q?daFwjUdUYxCpkQ2Wf5I+BUyUIewGYiDGbmz8Gq4CIPAOoLm7B45eCYyN5sRa?=
 =?us-ascii?Q?K0LyIVMo8gTxGKzn3Hc96uuCqfgO16t3tpUgT5gNUP3F+TEkGXN8+4RSLxCX?=
 =?us-ascii?Q?cRvaX1CDlO+rUILRJL/kUnHv/6wxFam7Fppahr5vxmA2Y7mNLTp4h3HqvaFD?=
 =?us-ascii?Q?nUDZEIELxEMorjAp/6a79GXoEPpIwxP4pjhvV991eVwzPNy573OzoaFplyPZ?=
 =?us-ascii?Q?Dh6Fnpf5g3/x1LX+Y2zIpydMWpd0mFWXTPdw/hsnTeMaGUv5j9lz5ej9Lb+O?=
 =?us-ascii?Q?mgzzJyWnXeZxXnPOzmrbNsbYhrra8KE+koYFa9EW617MwjBFuLEdepj6ygde?=
 =?us-ascii?Q?3T2UrlTyAWNYKBbTTVXZ1DcALILyylI48uYOdQR2nCQWjuM61ulp2OPXainS?=
 =?us-ascii?Q?ZxRYmgPSeMsoDxoM+0YPBC1eqQlg/5oPkOwBQ+7l420Psjlu0YG3w3nJ3Gcb?=
 =?us-ascii?Q?0UNmHL3pWGp8Li8DuO6HmyVVclpFmUijRXj/lbnYAywQPY4OMoR7Hy9ciH17?=
 =?us-ascii?Q?4dQNLNIG6WWzu4xPexqcAkmqqUSKvBwc52vZoI+/eKtC7gdt1n256KilCpaV?=
 =?us-ascii?Q?K0mzO9ObZuVB+0jrX9rONL2CpBYkuvP9QV08N2quz54eJsBp+o2vvXo3aWqm?=
 =?us-ascii?Q?VBrAToxdi6PlK1gElCaSkmVkQN/tN7lh4CB6jjf9DHC6ENqOq3sdUnXiaO9v?=
 =?us-ascii?Q?eo1hM+vxFL0L52K82ex1QnU9tHZKwXqW7/+GbjK3NvUiLfYMXurTUnZlCIpx?=
 =?us-ascii?Q?dh9n2s8ziHaSU+zDWJAkVWA+wylvcdKsuMQJUn0jgZZd4QSgxu0ML07/o3qz?=
 =?us-ascii?Q?xmyvk2yRfJ/zlYj6tt54qtOIULW/uJWFcui2Y68BiLbwM/hnyyaer9xCEoi7?=
 =?us-ascii?Q?wSXh035cPNCgu5ExjRzmnRwq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QAepNiDpqA4t0Et+r52ZRRz2sV3PfMputBG5LUlq6I/edRY9uYCwDcVePLpn?=
 =?us-ascii?Q?K1m4vpBsLTjnPPdQ3pdEFa70VPkXYzBY13rwBOl5PCNmfE1c8Icqi//kwk7y?=
 =?us-ascii?Q?OEhw0/+kQm42fzlUIHGHL0ROy+Hpl2IvZTJIdUI228P8JoP8l4XpGPmP5s6X?=
 =?us-ascii?Q?hQNN9sweXbiQBnCYWlzQO6TXJ4m2FtYZ8JS8hzFEGIPbeUVo6S4mFYZgusl/?=
 =?us-ascii?Q?ESk6hB6dhAIrvAeKqY/8nb0pMk6jB3vcFLRR8rK590LbJevELkxE8RSXpx1Y?=
 =?us-ascii?Q?hTj5DTiIE+X0uLTFLRkXiB1F8GtL9eUDf5Pu+vK9O5OnILwrc9XROYbk5EMM?=
 =?us-ascii?Q?FKJQcNEe4/cVaijCdUy+Dg4JMVohg4oEm06SKt513tGzw1nRn7nQz8sU4CfY?=
 =?us-ascii?Q?E7W8TvoYbVeagP+Qb4sTp4RoFUzSDfMQf2rKCAdp72ewD7R8llL2a5bRaQoz?=
 =?us-ascii?Q?Ya0hbGy1NT4pJAEDYCFFtQFyCxOVyARN21zhodEeBdy2DILtrfL9tDc+G1/+?=
 =?us-ascii?Q?XZE9L9lFC7tv1vHqS9z31JPPIlY2i98fArASBmN8/j9DkDX++d/skYYMbGse?=
 =?us-ascii?Q?mQkGr4tU2aKrQKAhTJ6e7IUkgM4J24VUiUMpHx3OjgguXAtgYcwQ5435Imhg?=
 =?us-ascii?Q?7dVLyM5AqoWKEdEEqzzVOfmiZpcS9AOKrV4ZgrDMOy/yOjOSLbD5zuTfrssB?=
 =?us-ascii?Q?imgFVlW+9AR/rExV2vx5NUwjJE2ZYuU03UPmaFQ3GccpnH9/jBPNY2bBZj9S?=
 =?us-ascii?Q?QzAWG2jfLjRKfj5NZueD9KlAfZKNL8Hoa+Y9iC4PdkAMr1qxRVLBdd7/BCYQ?=
 =?us-ascii?Q?vgNqd54XNnsPCkJmwN4DQFXU4SYed/CGDp1C+jtFct4WMsdRw9wbxfc7B6QU?=
 =?us-ascii?Q?5Z+Qg8kAHD9t2/+QdXtc4qIUjr+nwgqyQTd5Cp3byvQE7uev1d6ag+zQi5E0?=
 =?us-ascii?Q?7XnWxEEUABbMcCKkmMMcYHihJuhIwFQ7vVhZmDOaUbta0uh/EueP7kGNBMdY?=
 =?us-ascii?Q?rA1t5VhAipV2C0oR4q20V/FV0lwVksXVPgc6Yo7DLl+2QF2K0yt3uyMOOqJL?=
 =?us-ascii?Q?1Yv+uMrnp/3piaArI/GSl9/WR9TZWLYk6G25KvvvqZpC69SP5GiDP/b0F4sW?=
 =?us-ascii?Q?bXy6OkH2TLv93nZXuWKBxwLlwl7aYDsvXJS9lDXez505l/QcJE7s71DobLlZ?=
 =?us-ascii?Q?rkRkVO4UH1Mm8V4PXodXHSgIs8x5DS7pDrB8N04GbcvAYLDXAtSxpO0q7kjU?=
 =?us-ascii?Q?p8kSWefpcRYoOyn/Apm5JcbaQ0BR2luRFTTek0OpCTshrIS+7kNUzu49aADi?=
 =?us-ascii?Q?7AESxQ9+GaukeDHn6iHVsTsV+M0Sv7N8eB1C7xi7lmdy2GEo5pBrhsY3sAXn?=
 =?us-ascii?Q?HQygXN5qUk+g1mnYfU7vlhQHXkz93850qx5iBvfBf2R0ZsP4iMKY/um8Et2C?=
 =?us-ascii?Q?cUY5pE60KoKHrQ1Lxb6f9Dc8w0Dq29H6arX2pI6ikjuqrNKwHwLLoQafXbQe?=
 =?us-ascii?Q?T7OjsZTGOS0p21NlENzfLus2jeHS5SHamp5xLG5brzd37u6X914dBm5MfzSl?=
 =?us-ascii?Q?+EHx19cP5qlrXrlpY3OoV4ZT/twXO/9whXbUaaJOb2au5xT/nuX9NRENvFS9?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Xiuvxni8YMdjQfBLvhjQMq2D4yMVAZNUj5xdYErkAdfpV4Udn1G/t0JdtJ08IJdnjUfmfdRz6W2lyryS9vQ5YOie3PHcAqL58cdTfL3ND3tAlASQtU8s4RNs7id1mqp4U8CKz22vRuTKFuw3fn1AdUaFo1oNnhPJt058uPIHfYZAJlGuJz1DFHsZwkgxr4fPv8ljjTgOAKdYDuxWc3CneSOG1LyssbEyKI5MHbsX0giLVRPKMxBvZH0/JwkGlodtmdqNuCG8IND4nWrTO5QWZdvdnEv0UELYIAr6QNiiwLLFj9w55RsmSrcLUJc2tJo6te85hVxrBv6zjFYaPfOdcCcMA6Xtscc5twomv1mmJivsJcJ1VasZpyMAfnL9dk6dFbcBbhZ3QoWxTmNQ4cFOdtNQXA2KPM938o0/EoXVmE+1KdG9Cg+4Vs4jFhfigAPuRQ1OXXRjxD5Zf2FRnV2sz6KDcX8Wb7JtRbG+2PiiuooOmOqHFUH4HjOmBxTwO+LsyKocQKSLat6L+rFVl7NrGHBDhLRy0kUmbAVuNwEf8JrW8iZ9o2zhFPxS0m597TVPfmwlcoY763xibUe/MmUc2oY1Vd9iJ6XNnQEZdQzCwn8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a9ecf64-e6e4-4f42-2cc9-08dd0317933f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 12:43:14.7637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0AFqo4qwR7+4a6dnf7VDhC+wPWv/guAkqLlxR1FcloYpFud/NewfBe1tWcMNBb+FXlCIzLDpzYNPFz/DVp1EUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_05,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411120102
X-Proofpoint-GUID: PpDx4cTViuOKmE7w29141I0ZQ5RH0JON
X-Proofpoint-ORIG-GUID: PpDx4cTViuOKmE7w29141I0ZQ5RH0JON

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.

For an attempt to atomic write to a region which has bad blocks, error
the write as we just cannot do this. It is unlikely to find devices which
support atomic writes and bad blocks.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8c7f5daa073a..a3936a67e1e8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1255,6 +1255,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	const enum req_op op = bio_op(bio);
 	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
+	const blk_opf_t do_atomic = bio->bi_opf & REQ_ATOMIC;
 	unsigned long flags;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
@@ -1273,7 +1274,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
 				   choose_data_offset(r10_bio, rdev));
 	mbio->bi_end_io	= raid10_end_write_request;
-	mbio->bi_opf = op | do_sync | do_fua;
+	mbio->bi_opf = op | do_sync | do_fua | do_atomic;
 	if (!replacement && test_bit(FailFast,
 				     &conf->mirrors[devnum].rdev->flags)
 			 && enough(conf, devnum))
@@ -1468,7 +1469,15 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 				continue;
 			}
 			if (is_bad) {
-				int good_sectors = first_bad - dev_sector;
+				int good_sectors;
+
+				if (bio->bi_opf & REQ_ATOMIC) {
+					/* We just cannot atomically write this ... */
+					error = -EFAULT;
+					goto err_handle;
+				}
+
+				good_sectors = first_bad - dev_sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
 			}
@@ -4025,6 +4034,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1

