Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2A6198E61;
	Thu, 31 Oct 2024 09:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730368797; cv=fail; b=QBpvopwzPkKTjUGUfEzKj8/xzpxqcIMxnwzS48O/3wNHqy5sdsNk30Wi5g8NGPJwwTYtGNtgXGA84SEcewLRBRgWE7x2lf8yC4AH/cN94H3Os547asvONr1q2ynT+HoyI86mubU+wLcnH+giz6P3+3va7XHsYHBO9PBf7oeipz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730368797; c=relaxed/simple;
	bh=kH/HFZgWYsjWb0U4X3ikVcIN3HXatozJV19MZnWxdpY=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=p+A1gwcbBTFwCYadO5ab893paut586ed1kCqo9gGurlZYz5nfnn+9a3r54iay04glvczYYKPnaXPInj1ranotHV9AHpRR5R+EMKkKZr+kDX8CQf0nfggiQzUBT1hK3fhluza9ew1JBUXN72I/Rvd/D8Qi57gQ984O06uQ3AE/Gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W8cjyKtE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KsygdnpZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W8cjyKtE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KsygdnpZ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V8uF6Y018249;
	Thu, 31 Oct 2024 09:59:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=6p6zvuCwuQwetvuC
	U3pRBrMrpoVNVFC2Hl8o4gQ+dZk=; b=W8cjyKtEO92jhQH71bMncOvfOocicE+j
	3zw4SsKiEkxm1ToMQPvk0pBF5Pp6A1nVSKMURigRjewgo/q4OT+dop9eo/+mVNFx
	heGcWm3qS9QTTff5lQEuug3R4iPkrrOAHxN5n+2KAjF3boh8P19z/OJ1A9agomh9
	f2umFUyHWMqKDfH/g7rvu4LO6dL9NvUD+feObL8OHFx4XIqkqphwfxIQDMw6GXbI
	vPptM3kv15uefSXYWx6EAp9UquDeERK0SdynlGok3/c7nzPFvicQHvbBd9mQgD/L
	/qFZwL8MoMOdB6XvpWHoZRi9NCK8KGhrh32FhWMkvEQTubvUEcwjfg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grdp9wq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49V81xtO010074;
	Thu, 31 Oct 2024 09:59:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2043.outbound.protection.outlook.com [104.47.70.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hn90ct53-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=du4dwuQya5zA1AWRKs5fZwjslvDbJp6tbVo1wRcrabySvlseZ+G5jon9TdnUiudsspiiDmmuCCrMS3xBf85AqRXmRzAB/zc/xoVbZKiBweSirAo/lm5OXLDucrYovqhSHxXx+2ytY6V3GmtCno9ca0n4d7KUN3rogSQHc+aOrZ7Jktqo432rRVc0zUS2e/TxoXZVmFqwNFakBpoNYLqqKCmgq67t3xnWnV15Z5y7zI0jrqoeX06jVL7bjrKAPRwkSKxjcrgrPtFbg+IHyev/NPFLyEfkbGQLjs0ftrbVz2NlI1MPrvtWZ1KxSGWfHMgQHFbhutcF60P6zIHNyqpVcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6p6zvuCwuQwetvuCU3pRBrMrpoVNVFC2Hl8o4gQ+dZk=;
 b=qzunVK0gMvnls0deC9RDip9HfRIVzJETxZCKFjNvbcMndXeAYqC/in8T26N2b1jHrMnvyqFMzMQ9kI3V7VQpFPJg15u4YOE25it/e3w+1WNvenZfpu8+s9XM0At/1rzGxeBEHo/4WDtSdGXGgDaB4oX6YvgD4/43NE1wbkwNsWUazpNKopNgPUU+qQjMbVMvrbMLj+jT5dCflBSoD7lBhqcxyTiI2HXtliajZedQvTqY1f7+fLjO8hHOKysT66hCUeILc3Vl1erI/b8vZXMOFQdP5g711VGmKtgVUqGVxDffUPkAnJMGdI1FXpPdjchBbFYkbdwSGU/jIzjjQ9l2AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6p6zvuCwuQwetvuCU3pRBrMrpoVNVFC2Hl8o4gQ+dZk=;
 b=KsygdnpZHLSVoMeSt5xJ2nhBlVLzFGLn9pz6+j+p0JuF6CNmOFPaKn5/T+qs63dp7q247R1z3ODbCQ6+JQumOlqPA8Qe7CofMaNHxvE41oIeBK/gp/s0cBKEtIcEgmb9V/Lw1Vo4n1mcNImiTDEHdVDJpP1NpZFHsd8Ufocix90=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4708.namprd10.prod.outlook.com (2603:10b6:303:90::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.22; Thu, 31 Oct
 2024 09:59:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 09:59:28 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 0/6] bio_split() error handling rework
Date: Thu, 31 Oct 2024 09:59:12 +0000
Message-Id: <20241031095918.99964-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:208:52c::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4708:EE_
X-MS-Office365-Filtering-Correlation-Id: ac962c44-23e8-4f44-bba8-08dcf992b54a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I1nas1r35KWNLe7LKJX5yhbKSgp9nbKRnqRwdUuSDRQpv5cUZGiDoU4O9A/s?=
 =?us-ascii?Q?0f9Xor4JnXUMzOwziUzFyyq1cwxIWEztAkOzodxdjx78lM/DoPpUI+R4tVBm?=
 =?us-ascii?Q?WP/q2TFq6hAC9JDmtFbrGfkKpZUQemZ7rYOktowC+89JVo+klLmhd0Q6a6on?=
 =?us-ascii?Q?liHLkH5cDgwTSZMXABMHJ4jJrhPVr3kCZfsoSZkDDv4s3zQHKK2TrkYkP337?=
 =?us-ascii?Q?jiPGNCgF0aZZewGlkxFWzQaaH2Liv4bGdwdMfN98aATiO7btivOTzJm5F5vK?=
 =?us-ascii?Q?HKmszmP2Rsa9Qcby0DyM7/GHUdHibT5NsjBjB0BGba34qFQ68S1mWF+wci2v?=
 =?us-ascii?Q?oO+TCKDhJJ2+3YhbIzs7RQM+zcjw+f0IyfQB4QMaJpTwQIMOed61XnlLfpE9?=
 =?us-ascii?Q?tb1xxzzibZcrxY+EyHFkGRIeA3iL14GKNPfD/ps15vgcC3Y3mSzjF5YVb2lW?=
 =?us-ascii?Q?nADO79d5X7Vl0F5F2J3McQhZvkjqJvBrEsOanoDKPlEyBCkCJfX+ooc/bigL?=
 =?us-ascii?Q?TsNHQamuDy0DikkMajYl+KZ0mr/iPeXw/vwF12UXCzxcP1UnrKeuUm/pFbx+?=
 =?us-ascii?Q?U8VmhR6GPiOFK5PdS4FqGgRO3a4Q/fyAw/oZsbeptZB5gM3/NM9fE0vgZSpl?=
 =?us-ascii?Q?Vm1NFpK3boGxhJfCeElnAz70UYkqQwO2VWvMiq4gPPUJCt0MJRhZb7+AzRab?=
 =?us-ascii?Q?duNdLINFwA4Xgmii6VgBXn5lIZrmea8BFdBQj/ZU/jjSNoyMqdI1R4/nI9BL?=
 =?us-ascii?Q?I+eubBi8sRWQADdBqB1jFJHfYVg+oCLaIx4yFsCl9bGevriSHhxpgWfTy1lg?=
 =?us-ascii?Q?gyhG8/gg+HlydzypBJJT9JCdl66eVn/Vu5DRjLLGuFkPOezoxcQTufEwRuzB?=
 =?us-ascii?Q?VRR//H4Je2xOivsCc3zHO65Mc20a223asN9/8bzztwd2Mb1gydaMoV2VYLFM?=
 =?us-ascii?Q?n+HUIMpTp29q8z+0FnZ3aKW4Xynz1l1BfEH8gxPHE2X6vAdssuV7kaIj9xKx?=
 =?us-ascii?Q?wBZMWyT8lMBNh2vRY/R56xJHbgTPhP/mYXbK1Z5OhlN0Gus/hEZgGBPrzaKD?=
 =?us-ascii?Q?l8IxHQHM7NhE63fhWj9T5lBQCJ+87TyATQ0+pFniSPSV5+rFS3ubrJORrOwp?=
 =?us-ascii?Q?I/vP+zSGk36IIp4QV/VTXjFHL/o9yztZ+z1Obxhul0ZFlAT+4Bx4lEhXUs9J?=
 =?us-ascii?Q?fV92vcIFJegNtGXe43bGVTI/buwcjAnKKON/shz2CT0XflG5us2EqS+KHzCg?=
 =?us-ascii?Q?2i5usRWVVeS6ynrcxicPLlWW3XSiH8181CjwUJcR2qEThnKaIh3wFRgdgW3o?=
 =?us-ascii?Q?ixOdcS8Ts1rnvhngVFwAawYu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ijc9KBTeIgMcwiYpP9K67flmetjzYl9qXG1jaNLzIoxyqQmzxSl9GWolgB2g?=
 =?us-ascii?Q?UV1qBTrgvg68jMYTQjzfc62u6/zT9LifjIfihBrN7p6Lnh7yT8z1vFDb3hDf?=
 =?us-ascii?Q?yijWrIaoNJTsV7ueEkV24usM2PZvVhDOjxWMsTpzImfwqWIf4ssxsAW62ul1?=
 =?us-ascii?Q?e59A2l0o0toopo2q8jn/Oy9w3dUk3YauZsoV6Rd6Cj4wJX1N46DY9kPhkQZr?=
 =?us-ascii?Q?4T9rDtMZATsezD9a0xEAnOXN8DEQFUltVWJ8r4Z5AjyiocBWnwva/sPXFmcb?=
 =?us-ascii?Q?20jJkYOKVTbDDsIrsWVhpC/l5T/xvLxa4Gp6ICbk5CbRNXJ6WPjC96LSwEh0?=
 =?us-ascii?Q?h0AB3I9WOx0QnRyZvsd6ho7Cij8fsOMqPVITlmn0TBpPGgXEw2YCbvNjp2TC?=
 =?us-ascii?Q?VJ9FlFC3ingonLiHbkm2ru8xxBq1WK9C0so38RC+7tHpvEmP23ZKL7nkEUYF?=
 =?us-ascii?Q?Wq7hvGJO0kIHAgFUB/HGLugl8I+qWuW1+uSQMSpEeFDyLl1uf/hMEKqclkpJ?=
 =?us-ascii?Q?Kues/N7DxpvWwGYHM4LBFJYV2kndkPrH77ZkOnJq7eXlgNwqeXDFp3iNhVq5?=
 =?us-ascii?Q?UN2cIVSom81k6lM9VWcNV/jJq4j6zi54SJ63FWhb2kWyEbEKq356daprJ4KW?=
 =?us-ascii?Q?pHyGniUOOTEMt2zbAR1hvohYau4j4/iL6h3b4BlRmmakqnADn0Wn0YPBBT2T?=
 =?us-ascii?Q?vTu7LC+jZBEr6caCrznkOAvBHFzSnVzjG3N+C4Wjxbnl6nJuOazzH/1uDo0s?=
 =?us-ascii?Q?v2jVU4IM77poK/kBYTCmpPpHRooma0sjGAMoQpCunalssWBIbXdwnYYjMIUw?=
 =?us-ascii?Q?14nNnDAB/mDfOo/D4bNaz4FZNpSEFW2rS34NbKRQI3Aq9RSn/G76yuF3bcqI?=
 =?us-ascii?Q?FvuhIubWH2cM9X+E/ClyZUq9QUPGYsX5c6Z4Fk4l7Q0L6UZ6a2er3ueeO2A0?=
 =?us-ascii?Q?CO5/4A2KL3u37lleE6QuJ2lZdP9dax7c8htPY6NXmyOAuYQtvJTXXN7Uv1jW?=
 =?us-ascii?Q?4TzknAntcpOv/etRXFJfOJDmS5kr60+xdq0zGq42ZiWnY09Kq/SPHBxwSQsq?=
 =?us-ascii?Q?H7Yt2nd9pn9sYaIuvz9PIPQA7Not7u8gZFoYG18x21nr8hO82AbBcaBqOWyA?=
 =?us-ascii?Q?T268h7QG3feUpvVa4/dDrR4ialkMT9iJsFBVpgIDgme/1Cd2d3cBZwWshhp2?=
 =?us-ascii?Q?NfmRwSHO5EVe79NuXAUYb8KZQqN0vVkubgdDk9DfuwaEnys2XdYaod3O1LwQ?=
 =?us-ascii?Q?7n+pvocpCdccqTb0XU6X47CtATzySDNlxpve6k/xBCsw8dAis2sWVzdijyXT?=
 =?us-ascii?Q?Jvh2sNr4PCrylRFIXc6j93MWFGogDUKd0xhIUYHodSwK+hsgIP+RCGzNaQnm?=
 =?us-ascii?Q?n8eC8PtJE+VJZb8WAB5iBWeCSLnMRRsgAsgWSK3BWw0v6um63IvAZhNklmy4?=
 =?us-ascii?Q?deFFJEODBhYNeljwyUn2xGyRakC7ClkMC6RB6gEMBxcxe6FUjTUXBh3rUQfm?=
 =?us-ascii?Q?+gji2Em9CzncXjMLvrT2m2geLWWi1rgzUmvi2OUBy05e38OsFqxD9fwANtT3?=
 =?us-ascii?Q?eJSLSvh5v1rHKssI3GYvyTQz36/nMQCg7uHVgaMYyv1MLPyVNr4Gy7jJrtoQ?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gI3mj7bTItXxhoOt0TiOPtzklXFSfEmJ4vS+z5dnrVlYQK25eeW0Ym2XpPecATHshnKpbS7eeh5L62MTCSvoknxrb7pmAI0+Wk4Nfeep6DRz58W8usmfkezAdQH86VvreqvlYv+58BXEp4LgHQtDzwVqvrS7uzGuaAFWOSqFP/Cx/CPyRf19pyvEc3lZv1MBIimnGnTKOplwRcR6+fQ3DS7e/cNfOFnQlBOilDiKiVSBnYxuFtZKK9kh3HRrNOuyCQa5BH3yE8XHTeFquRNToJSH1A0q9IPMddLVxJXx0KWyLBe22DMM2ZaGjJLrO30ccud/LpihbuG8eivDyAe+NFBXVP6q7xbmPq9yi1dzBGG7uK6/tAJzpu05YCaxzMukeDgemaL8ihTHpI+Qom+4OJpVpG5HEHfRMfD8XDmPITMipCLpqHi643d1kZXeP68t1k6g6WdRK5XvagwSW3dvNy97Bd8Y36qEwkWUwRrmJWx7Sop4wFQrYDReb/4aRKzC1I7pDAg6/irQ6JBN76CKmcw+E/Is8mnDwP2cPlkj9CbIfFex5Pd44AwKb2Wl3wJ/pRCfkHrDAJkfpgZ1MnBOODwNE+RtnoZbVlwtPrEpuiI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac962c44-23e8-4f44-bba8-08dcf992b54a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 09:59:28.3140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eNjY5aarGsKXZwanr9QYOKEocH+ih9CbhaebZLbdn1vBIfcWIrAWuu6Sp0uElr7hjiFBOmOD9qEzaGDSluE/uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-31_01,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410310075
X-Proofpoint-ORIG-GUID: TjESwjearFWxhmq77eSvVVH5aaq6DR01
X-Proofpoint-GUID: TjESwjearFWxhmq77eSvVVH5aaq6DR01

bio_split() error handling could be improved as follows:
- Instead of returning NULL for an error - which is vague - return a
  PTR_ERR, which may hint what went wrong.
- Remove BUG_ON() calls - which are generally not preferred - and instead
  WARN and pass an error code back to the caller. Many callers of
  bio_split() don't check the return code. As such, for an error we would
  be getting a crash still from an invalid pointer dereference.

Most bio_split() callers don't check the return value. However, it could
be argued the bio_split() calls should not fail. So far I have just
fixed up the md RAID code to handle these errors, as that is my interest
now.

The motivator for this series was initial md RAID atomic write support in
https://lore.kernel.org/linux-block/20241030094912.3960234-1-john.g.garry@oracle.com/T/#m5859ee900de8e6554d5bb027c0558f0147c32df8

There I wanted to ensure that we don't split an atomic write bio, and it
made more sense to handle this in bio_split() (instead of the bio_split()
caller).

Based on 133008e84b99 (block/for-6.13/block) blk-integrity: remove
seed for user mapped buffers

Changes since v2:
- Drop "block: Use BLK_STS_OK in bio_init()" change (Christoph)
- Use proper rdev indexing in raid10_write_request() (Kuai)
- Decrement rdev nr_pending in raid1 read error path (Kuai)
- Add RB tags from Christoph, Johannes, and Kuai (thanks!)

Changes since RFC:
- proper handling to end the raid bio in all cases, and also pass back
  proper error code (Kuai)
- Add WARN_ON_ERROR in bio_split() (Johannes, Christoph)
- Add small patch to use BLK_STS_OK in bio_init()
- Change bio_submit_split() error path (Christoph)

John Garry (6):
  block: Rework bio_split() return value
  block: Error an attempt to split an atomic write in bio_split()
  block: Handle bio_split() errors in bio_submit_split()
  md/raid0: Handle bio_split() errors
  md/raid1: Handle bio_split() errors
  md/raid10: Handle bio_split() errors

 block/bio.c                 | 14 +++++++----
 block/blk-crypto-fallback.c |  2 +-
 block/blk-merge.c           | 15 ++++++++----
 drivers/md/raid0.c          | 12 ++++++++++
 drivers/md/raid1.c          | 33 ++++++++++++++++++++++++--
 drivers/md/raid10.c         | 47 ++++++++++++++++++++++++++++++++++++-
 6 files changed, 110 insertions(+), 13 deletions(-)

-- 
2.31.1

