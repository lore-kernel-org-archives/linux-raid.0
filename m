Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EA119C569;
	Mon, 11 Nov 2024 11:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731324159; cv=fail; b=S3ViVkn9iMlWe34UM2JjMeOsb166u191bRoej+XHWsASqeW/mVsKa7TMoDNojUbeVPHE06j9LQYgDNTuGKFnmqf7EZIU74eVaw7LgI6gukufPFOPOQ9RoZo4so6YmU59vnsK8h9ZN1S3UZl4/+8Q4M601AoCxmDOUOtMLhHaXuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731324159; c=relaxed/simple;
	bh=YgIWu+gRho0DWVFHIS1ep9fWnuhXwjhXBFE6/KiX6ao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qhT6/vO1RSb3rrHORthpsx5c/360NQA9p0DYE2GgnV2VA5U5jEFN+STm9pg/FwUR3IDCLsyOG8+4N4GrEp95F19+1LIKdcyiPolUmnOSrhMijRs/6lvVgAnhdhh/0gJTy0SzKv09axjSzIWkeLql7kdbz0PfM4WYzE1+HKg1/RA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VOpxuRix; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FAPaUTxA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VOpxuRix";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FAPaUTxA"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9soPx026311;
	Mon, 11 Nov 2024 11:22:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=KhWjyQCIdgXhGu+NFJbChwjVKIMzf483Wrsdnuia4so=; b=
	VOpxuRixgDabr6AE24E0Sm5ULwlO130rilyMdm+tV6Ezdq3X+bm0/IaBL0LMhpTU
	dE0C1omdr25cidxN3/NLe21DzJXt/4RSlsuAP9Z2kxhPt2pkvlF9+/o1PQplhU6O
	MSheSVHWovieci+jfebn+MwF8hlEs22IA9K/5y1esS6snAo1sgWoaNBpyGYMriQs
	Lj5Gf9Kzrxaw3W0fSTzZ1CNRSqa5/cOpjQtMoon58xiOFF4lOyXP1xAfW2ldGo03
	/LgJEtEr1bwRhD+H0TQa5RJwXf4ChLeQkK6bgsQ5nEOJDo2jeIsJMdNOmQhf9oFk
	/OHiyG5JBMzaFLFj1rCrig==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k5a75x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9eMTt025432;
	Mon, 11 Nov 2024 11:22:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx66tkug-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBmvqaixvvZ2CqMbxy+EnHK2Ulo9COHZsniwopY+cJPZ52yLRFb9sWG3oJip2aGL/uaQQ0CjDRlcvNfWNe+ogPHSf/5JBNohC9AX8g2xabuclqc3xbul+6x8xsvnHzUExs1wbVcrZ7y5Tc3wUrxIIHKwUvqiM6F/PNT6xSGfts6GGHmR0QxIRzKcYubBYy7UDj/9oFacrrz5qUsAbmkSwGTXIL7qKcmyPBlWDXas/uq7wnLiiKc9seBRH2CwaWWQRTizeShQDhWLNPC6L4YAeoPb6jMQcHK7la4mM3TlkbGID94lKcbk4WRP8/QPXK/cj0IlMo8PpghQM+JH15wUcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KhWjyQCIdgXhGu+NFJbChwjVKIMzf483Wrsdnuia4so=;
 b=TzoIh5J9qgu7FQ1GCyveffDsnc+01ajEgaFUo3wOGTKR0Dp7o+aF3zGxBEgi3t8Zq6owiytY4bwukAkcMU3wC2IhwxHZ756WN8CZA9iu+EnrzublixcrwZ3R/YS9/q9iGbjS6yHkHpdmlwJvJr9iMD1E6EMa28OnaCPVvo/rxg5iAwXN8kloffPg6LxKuGoYZaVy3zOOGcpdTtDyr1s25+bCngwbOtGAiAMaEW58jsGvIk3QFvGAuMTzNI0jMyAaC7VeTThF3yKzrL8JJT+sBqoskdKoGZIPRWicllORjEd9wmug0cJpBPuzZLRkEdx1g+B6xNj7Bu/UfKJh2bmamw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhWjyQCIdgXhGu+NFJbChwjVKIMzf483Wrsdnuia4so=;
 b=FAPaUTxATuneP4wksfDhDWOnDy4DT3y3IewhpY7GzdwOScKQiGjP6UOgu0jbPyCttBRYisCSCJXWqxeeSa4b4q+74NSyFZ+RVx2KBhfDwXl7ykTlm6bGkMSVXmL3eFyYT564IZMc5fDmczMi+AdVyrkjDXzTQQYapPdupIdqEfE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Mon, 11 Nov
 2024 11:22:14 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 11:22:14 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 4/6] md/raid0: Handle bio_split() errors
Date: Mon, 11 Nov 2024 11:21:48 +0000
Message-Id: <20241111112150.3756529-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241111112150.3756529-1-john.g.garry@oracle.com>
References: <20241111112150.3756529-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0026.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::39) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: 4809d5aa-750d-4f7f-17c6-08dd02431796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kax0i7Uy1z7vfeJ+rUw4yakoxrdUxY0/AqzlRMQHdCo7PYFp64OzBDhVKvV7?=
 =?us-ascii?Q?Oa9ELlNYQ17QxpybK69QWfZ/pwWLflVReBRoxaPOpQ2bYYlk+Bl+FE7N+APd?=
 =?us-ascii?Q?SAbG0k7pgNN5PvkoG9w8HCdPE5imc1Px3Aq5y41Q6a2V81BTaXRg42okgHys?=
 =?us-ascii?Q?tpChrD4I0w0yVv8WHvTeQSm/OwE2HeDneCi6SEi0azw42jG55c27cd/bgeXQ?=
 =?us-ascii?Q?JoFPa3NU2fCjLNmf15zAkEaUvtJWIfienPI9HhSVlkBKzjVWnws4OyMRRMIM?=
 =?us-ascii?Q?WHeIthR7ndOUCwlZCXI1i6M6pfFJiSnyXKIkSTrRiS7wOKZM39yaI3ztLiKo?=
 =?us-ascii?Q?4bxPqnyB6wxGjbkrNKNg0b4jHJpWgnUMqV/Y9XpubInj5w4u9er4BmfEU0PB?=
 =?us-ascii?Q?0GPs7hNiJO26jB6dTvwGeNn3qoB5Q+5bYB0SISwacftGMBU8Wo/PdL0eL8SD?=
 =?us-ascii?Q?j5pTIKAjmbxl6WK6+P77ugBKW+EZh80uV8cX2vhJMkx48hMzsnf9WOMmLxfy?=
 =?us-ascii?Q?Z1JCcvhU5RsrKfIQoD4hREmLLjTaYfIHvd8BptYq3ylcKfmnoVaJerS/4L04?=
 =?us-ascii?Q?3TxQGYn3klRA9NInAl7ElNJFew9pIWmRirDrwLDSbh9foTHoUZymWhlwth/p?=
 =?us-ascii?Q?rr0lCCjAqj6x+yzgH2ZlMqTHRul2eVMkXkmLW5a6786/LH0fIrlJUZBNnEI2?=
 =?us-ascii?Q?Fsu2mS7tCa9/vfhktI9YWSu8zMC+fc432KhwCYrFxMFranC9JU+UQ9BAeGdp?=
 =?us-ascii?Q?zhIPeQ3i2jxFQfVTZFpsiBojYuv0GRRqNA2NREQSV3siSOmSB46LAT3kvcf+?=
 =?us-ascii?Q?bi+QBH0Cw2TAkChLRhL+T8UDO/a0BsWpNn4v20Gk6mvYZQDCPSkTSoiobrUQ?=
 =?us-ascii?Q?Y7l4Wy8OLAtO4R3dt9vclz5NbTzk/9vUMq/1xp8/O3J+PbxqsjNLFZu2QU2Z?=
 =?us-ascii?Q?O6eg5lGiPJscYLW9TVBlOXv4CqvCg9GPCau9zmtqA/D5d1uNDWJaw1FaGOie?=
 =?us-ascii?Q?0J6m7qr5pgschZti8sdY1tS+ZdQQX5sHrZQkihw5K2bl343pmxGlKJeo2rrK?=
 =?us-ascii?Q?+1R9Y/a+3ATy3Msja71y7NGxWQvtqwcEhKPWqNKeHISTloVWN4GwBurHf0GJ?=
 =?us-ascii?Q?fTY1WYjUQB79zuGcgiOy0uhoXkYRu8CdHI5ujkBETuwKzVSTCjyWppISLovV?=
 =?us-ascii?Q?H1Phkwkce6S8d3d8CxDpIqAyl/ROSoaJe2ordi/+Gn9qMXXJBjk8MJFh+WeK?=
 =?us-ascii?Q?D47oBaxKNcbTbpD0lTSV3lLlrX+/EbA/8ZWShNiVcQ8+843NAXy8iWypAQs+?=
 =?us-ascii?Q?4pI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CcBF2jlEzfsGCt1DBaveE62T8pnQZ4bH8BLnwV2BCW5QG0DLqKyxpwdWdT0X?=
 =?us-ascii?Q?R380ETWwwhvXbGD2qPDyhXTR+wA0EVQtUOiIAhdxUsU6bcht5WWUaYx3bA/p?=
 =?us-ascii?Q?84FGNrgSvfREfz6kZNgMsyvx8dZ7kb2LNOD00EmnpU7IvLWwPwy1spl8p/Zh?=
 =?us-ascii?Q?gAe012Tb3WtPDZRpN1nh5oppVL770nd01pkkaK1ezpaCSIWSGiAfhPD6yJfY?=
 =?us-ascii?Q?GHbdnEBc3hhVWAWWXX4StXHk0b8sZpkalO6mUT7RiFGzHpv6MFWJNCDyXdHb?=
 =?us-ascii?Q?TlBmpoh6cgtnVnWtKLna1mvWa9ApPiisMTUPzDiGUVFfrk1OceuMnxn4RAzV?=
 =?us-ascii?Q?eBchJCiXcPq0Pnrzwd07jMB+x1PxhWVNTi8ZhTkmWABA9rwQ+arxIGEfC58x?=
 =?us-ascii?Q?xavIqKop2Z9dxDVRmMT50qa2y9L/MuPotvr/+vusozqjGUmVp4NVeHKuaw7V?=
 =?us-ascii?Q?7dD4oxNfwWGnpA6X+UvHhg1EqeNsnv61TSclaUScus8wIGlyqtYKjVP+h4Ul?=
 =?us-ascii?Q?ycmBMa+WGoHMFwa49bM42IM4+dvMTJb6v0GMvDr81ayDLD9fzXWxu8MMN49Y?=
 =?us-ascii?Q?GzHaKyWsjyDsjt2MEBH7EEN4Ja1urMH8nbnExKO5pEnE5Y3WeiLrq4j8lDn5?=
 =?us-ascii?Q?8Ex+UpQzn1oXz7+7d9Kk87Ef+aQrgrHKqAukbg5A8ur+TeweDZJjR/lsBs+2?=
 =?us-ascii?Q?2OmO8yF3GtlGmMYsu9+61KTURrLRcXY7A7yVLYqKmZMDTV/Gu/SQw3Q2muUl?=
 =?us-ascii?Q?AcZ0W19FcV4I7jqGuKbtOIu2yZdHhA6t/Hw5RKS/yKjwJJzYjstxMwVcIcZF?=
 =?us-ascii?Q?3OKypoC7ZJ0MqReeFwM8wVU9qCqQkbH+3NsvLUrRhDHodWL7h7YWNx7W0sPh?=
 =?us-ascii?Q?Ec//HJTwHgxvvG3BDzYIVBtrBgAKibLSwnAek1m42egkLYX7ZSyPGkWVssY9?=
 =?us-ascii?Q?3zCCRLD7aXEfEezNoFQ4AVTx4Rd/MYAhiukb8aW0xzTyO0nq9vbsHkZ4JNzS?=
 =?us-ascii?Q?iaekCtCqnd4LNiO1QBP5U/A+1MIH+rlarDyNbpxLf+8BzHVAewIlQ0blhKZK?=
 =?us-ascii?Q?PmPZJnCtVPlGsR2JOzXsw6Wuf1Rli6ZEevkRNgp521dRWr4yYdgtpEXVQSBC?=
 =?us-ascii?Q?DujrdjRfYrgyPjhzkAl7aMKWawZkQkq0+znvg7dq6rWCVmKGxZVuPE3pE7s6?=
 =?us-ascii?Q?PL08so5YQOENb2+lLbRBv0eyRAP0+HxTFLyDMHz57yvNaU8gCobGt++bH0k0?=
 =?us-ascii?Q?9qp1HPibM4qmwfhFJpBWKf1I0Us4IrXFLcxuYgFh/cKvMuzvDMtBLSMhXxrv?=
 =?us-ascii?Q?wle5iAbUbAYBRRzwCskxQdOwFRVD2ONb6u7Hke67Lx/RcDwveDJLErFtA71e?=
 =?us-ascii?Q?Y7S3dAgjGU00xU6owkcualFp4AUCLE6zFv3MAqYg/OtzdUjaiXV/a1Zdl/ew?=
 =?us-ascii?Q?1Z+hL0W/Si2fb4/MaqlymHmlQye2G1gMWG4e9aCjcOlOQkfimQ+GlLSbixDK?=
 =?us-ascii?Q?LIl/QmmNupDiAMRKzsRNfjgG2sMbvqqOcJ9SE+g6g/4fy2KEezKdX6FGeZPQ?=
 =?us-ascii?Q?cVByLjg9iBvAAEybmDIOGoM3RThXN9aVlgaGa1w4dfaV2nnEmSuotNrObqrH?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iHCY/c8JUJQhkAIOC1ArtkLD9jcZdwb4yZyuhDulFVpC0m7TWtwJQjxGHAnqxwR+6KpPn4fVTBKUA4vr/5qF7d2UihfExi6epPohK2We3OxpkimrI7M0JmWSYnE/Byq8fdjnkPwKRjenaGRuHsw19scJvdLIKP9riA/8sggvN2iyDFPdzok7fGHD+GLX5Wb5sMCdX4q4hREiM/kzbD3KsQ+hbwJnKqrjAKtCUg9T32Ho9MLL4e/8Pxrso88FaDu70B5BwuzdtneWhOT5RXv8sfxL/KH/yEqondW7zHk2dS6riMRGS/HmKxrtE07gzgrfARbIXFHVadAmz8aUu6MtrORJd0CN+75XRfLpIlvO2SsIFol31zd+qBeyPb0Gn83p7NghzdXH9/+VuyAuep+VOgpCIQYQV7Ozz7wHWRTK76F2SQneC8GW8WsgsMfZ+kKg4LeIVByZcD8Cf/0Wr90lfQ2dLgbewBm4zqOJHvktw/3MhrNjMKiYJyFZTseYmrtfHmYP8V+87Pw5835Mdh+bM537syN0ruGMCdrYZmBlYNvmok+Lox1nPYlkOhqdvw+ilgdIeE//H6OfhlE4IyhyvJu371pXcZd7Thea5DQtidg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4809d5aa-750d-4f7f-17c6-08dd02431796
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 11:22:13.9476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVXEvTWXeR2+WEhlGakkwDWFa/nRlu8BQ2a4h4HpHrRFLOKhytI01bRGozGk+rKYkCIH1lw/KeqBXQp2S6JmFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-11_08,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411110095
X-Proofpoint-ORIG-GUID: 0lsFeLWACn_5L37U37hdH3sSjtfrR0DL
X-Proofpoint-GUID: 0lsFeLWACn_5L37U37hdH3sSjtfrR0DL

Add proper bio_split() error handling. For any error, set bi_status, end
the bio, and return.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 32d587524778..baaf5f8b80ae 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -466,6 +466,12 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 		struct bio *split = bio_split(bio,
 			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
 			&mddev->bio_set);
+
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -608,6 +614,12 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 	if (sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
 					      &mddev->bio_set);
+
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return true;
+		}
 		bio_chain(split, bio);
 		raid0_map_submit_bio(mddev, bio);
 		bio = split;
-- 
2.31.1

