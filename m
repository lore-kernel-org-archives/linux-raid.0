Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D9A1F7792;
	Tue, 12 Nov 2024 12:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731415420; cv=fail; b=iBAToblf1Cv6c4P9Km8suHTvsGacxpCix2mmT/Z8os0kHb8wdIVhFwRsNwGNemPlj87XRQtnHJHnlHcR3gccUYVt/Y9qs3dlaQhOpe3+PBNB+2HTBqycoeobG9zrsqN4f040yQzQDoJGvF8uzg+5j/j+j7kPKusmYyWJTaPRUFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731415420; c=relaxed/simple;
	bh=vc1zd6xqSuDoOgpqU7t7YHAsIM8s/yREPcDQu5N7kvc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pZxsYZWxonBy2rqeXK/iu2JlKsTSkz0o/Xp74FEXArlnkWSV5l1I9ShRJEnawO/bbAVf7dRYHsv0J6ToDf0MbmgAkWQLH3Zi/MV2gCf9he1D5u6CLwrWViE9ObMfXYDr90K1saX+GIaUuyjuQkeB8lCw87qjCvOtkMPxA6Fx624=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kCAduph8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=z9RHnzSq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kCAduph8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="z9RHnzSq"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCfjO5017463;
	Tue, 12 Nov 2024 12:43:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=oaRzKFZjn1tQC+YTnJoTkVX7wlS4OwXrz97b7bCItqE=; b=
	kCAduph8M6ozdWL3qMzzbKRlIFYAFId4dqYVCCBa+w2wWNapESf+8bQmM9/PyvCk
	K9za9y4LXjy12Pnl6dATYJlZVkuT7XrYgDcTonhGtO8UjDWfmjsnnXtGSFLWFWoq
	1spBB726IXeTHTp3WWnyx5h9cCVW8iesU4qN7/JdkVm4VCJ+8Jd8Ap9T1GSuEh9c
	hu6VT/vJBS48/7sQ4HR6xA4hyNS1NOBQ2YKEeoXc9X65WlhGSlPixvt7gAUIJ6C3
	JxSQKa2M21Kx4Wr/uIUYhNPC0cs7oUUFr7Ol64UWijFPPxYIweJ4D2Axj/O+ba5K
	hPiQDI4YLPVUq1QoW9MvOQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0mbc8fx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCX4Gc005677;
	Tue, 12 Nov 2024 12:43:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx6825sj-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ospleb4Owlvx9QtXoi1AgIZhWpL+KZCLrXD9GXA8e1gDzqhVR75DKdWBK8TsvlFN1pr3eSbFZkEQlyHSE/tn0WaAGtC9xgoU8yykHK5tN5264Jss3vTQL45E0Igy1QaDxegJiBZwlpjj89BTPfV4VegGl6iZ3rJgxF25E+tMjJnRVLdtHc7JbtTuNQaU0Jrb8LQohxnyHifTEWdW+2FGzH1S2f6SCpLKtZDHEn3ZWPRk2IMYCyDYULtlT/L55FrbkqI/svPlFqfX39FK3clDcTADN5qbx/dS8O8xX0SX3LeWoysQ5k5+8jwVcIUwJLZ6MvAJ//8hEK+PE764C4z/Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oaRzKFZjn1tQC+YTnJoTkVX7wlS4OwXrz97b7bCItqE=;
 b=emy8zKDHpJs8g6aqOdzdU7/OGAb5MuXsT1LvdjfWrTH3EYfXp5UU1HSWkiGgIn0o7DkhxRcp6Y3OGjhooFsBDCQ0LLbiTtYqTJc0ZlhyXVRdpJ+OA+YIerfeAmhEutCWndralillpiwSYkNc25+eThd2ahM8B9GpnIzdVrDHs8gvDWVEhnCbFuIzP+6iGHo3RdgUm/ugtxySdfJdgp5GUPlE5AD2xjxdlXouH898WhtLT+QYN9DrjFC7+DcRyd9U1YVT1Bd+3e0aLpm89STQTF+yewaW5cOAmRIgPyTJc10XudwprFLo/yLtkgLOnWjCOubYkC7ahOvCVAo0A3osmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaRzKFZjn1tQC+YTnJoTkVX7wlS4OwXrz97b7bCItqE=;
 b=z9RHnzSqwIe6zU4NOYUNMuMAjAFiqf6nr4VWWXGBMnTqP8t1pAHkeltUw8nHwNqPQ9xn26b4GG+L00iYvih3rWRGzhJYWiWmcfC5T18ARDdfVk1txKHXcukpqToor4VAhJ5ycWjNRsVqyzkTbk7M5ZWLDTE97rzDh2cOO0RiI6o=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYXPR10MB7974.namprd10.prod.outlook.com (2603:10b6:930:da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Tue, 12 Nov
 2024 12:43:15 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 12:43:13 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 4/5] md/raid1: Atomic write support
Date: Tue, 12 Nov 2024 12:42:55 +0000
Message-Id: <20241112124256.4106435-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241112124256.4106435-1-john.g.garry@oracle.com>
References: <20241112124256.4106435-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0450.namprd03.prod.outlook.com
 (2603:10b6:408:113::35) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYXPR10MB7974:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ac977ff-eb07-496e-fce8-08dd03179266
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/rCAjSI1TgjPnD8Fx63Fl3nLLhvo+R5GY6/Hhf/s0omUk1DZnErr1FLLhG0E?=
 =?us-ascii?Q?l3XbaxfFeTiDtCEQkaXE5x4QuGUSnF3rP4UA14KTABW/IQxIwf74dtkBmREZ?=
 =?us-ascii?Q?xFz5onAX7YHRx2ZVbmm7st9XHVOLq6BG2+Hu1NjmfRCorqeVxe6SHusSmcf4?=
 =?us-ascii?Q?WdiFhYGRHAg8agS6Gos9oIYfYiJqWy4zGYyNVoEnz9HZ79sw9MLkWui18xyk?=
 =?us-ascii?Q?G9J6NvZRhrCWnTM47V8jsIPMnjxO7JRsdYuIN9oALbMeC3hdh3/hvIDUVSbV?=
 =?us-ascii?Q?MG/YQqtdT7l8VeaIt5yjZpPDS2HQi3/usxIge9EkB40nzJNno90WqqV30Vft?=
 =?us-ascii?Q?wrsWvAtM//HBHSgaXIZtgFmDEVM/OA1dK/2CiZkF0j6EpVLljXmOhVKzObuH?=
 =?us-ascii?Q?ZLXudVOFXAZZdv3B4urIPR0Z+U9hNok6tg35RDen8DQvsmDF6D6XGobrYlPj?=
 =?us-ascii?Q?h9uDw2ccCfYZpkLwx7XJqiY87QbFpGTh/0yZNPFM1qYa+juhgSQRCuOetM+Q?=
 =?us-ascii?Q?qvtnlzym6NH+EgZmdZJFIwGuvxii7MRCChts0fX/Ho7ULBBtBskJONfXInKQ?=
 =?us-ascii?Q?Gk3ySMtGyZvmPv8wJmgYF2z/WgnPCHAVm62D7U5Jt8zVdXWUp7npLvDxVCZd?=
 =?us-ascii?Q?x2748RKjXaV6ShfxJnKBbhLru4u+es+lPyH8HddOASFPNudNKtaoebPmL1iY?=
 =?us-ascii?Q?gtnqMGkgzwYpyogyTR2aTfC4jZZVG8EYPbdbCW7rP6RihQUZwAZj4rQrNpNZ?=
 =?us-ascii?Q?HSFu6XtJ7PbAjkWQMqvCxAYkie/Z/s6H9O5bnWgEXbRzUm2HoMiWnA0syI8J?=
 =?us-ascii?Q?dvco/JK/4hWqztZ1bp9oksEr+m6/whWA6aYTlOrAtUnJrRnwqAguON2VJrZC?=
 =?us-ascii?Q?Oq0y0izFR/xOlaTDEkZRJOQ4YLJOucrSRLejv7oEHTjV1UPzOIR+xGwBKj94?=
 =?us-ascii?Q?trTcrkXN/SB+/vq9TfoIcyo8LZWp3tFNZPrc6+672sjGEnnddQDWoi66LTb6?=
 =?us-ascii?Q?eSuCzIREmHND80LhdJ3kqlAgzjAMCz9wQ+f29mHqh0/X22FvRvsaXJnCCaz7?=
 =?us-ascii?Q?RldHBmxHFcccMDr1DSb9nwzzBxgK4u3cWSmftOB0FQoVY6nUqhzLLWZHYJMz?=
 =?us-ascii?Q?ZPVds7obGkKjGiZloPcQBu2SxRawuyDTTtBSivF0gI4CI+mSRbdAgLa2nuxI?=
 =?us-ascii?Q?RuKrqEMYfhmKFrKU/fNbGSFotuEkRrbUJLTzPDiiYVLW4m151OjSD7xzrudr?=
 =?us-ascii?Q?jYMKAD4rS/TtTl2blSR9DJ3OFJ31IEYBEndwrNR5fI5eNoB39YWe+Lx90I0I?=
 =?us-ascii?Q?aSdgJDfN5DigvDByN/M38Jza?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y0mMU3x8p6u0ISZ9pXY8Ae0e+8zqNpPN7VnL1na1RffjKnGZ/HbwRXFP1Vd2?=
 =?us-ascii?Q?IhP9hXU7P6HVr3tKyyhENAqPxEYD4pGFmqTK8modt6tpIzDhq6B1Pc26pvk8?=
 =?us-ascii?Q?9cdXxAt39hDuu6HpEFGHNTq8nkJ9d221nSg0/NhbUM7iSXxFiBVXFp9uemN5?=
 =?us-ascii?Q?Kax6pxha0ug/qZ6XUzpyJJZ324qDcB8/84FVVAHKwwJkhV33uJwBW8pD1Qhs?=
 =?us-ascii?Q?HcH/aYdeov0sMA5iNc6SeX+MfdaCHu7BuCRI91YYxrgrhXMbCn0eNHgoqWEC?=
 =?us-ascii?Q?v/HKOOuV+whskW0WmyThOG0Fpaw9lGPSg0OH4tlEJodHl6shsNArFWcEnXKy?=
 =?us-ascii?Q?nsyOjEWpReYD4WqyIVnKyA5S1mB/S4Di8O4Q+JjcFlOlVe5pkT7dMgGm0Fo7?=
 =?us-ascii?Q?WU1UU+oUV3KCauNGFv35pL2ZLjjo8/Op8Krb9Z0XQWuHUUysA44w/CMKoQqJ?=
 =?us-ascii?Q?D7BdKcYeAtukxYtFPM+Adm3VegpR4ojTRUDnbWrC3Cekx/CaXqUHXaOjLIDi?=
 =?us-ascii?Q?yh1esKvSDo0v11TdfW10QquRFscphmFZV6MqtTB23EIgeFcmuBkKFPcipzo8?=
 =?us-ascii?Q?dbiUd2eFMwMBzrzGyLRFiwZY+yWrNdS2iRDl0Sj9Uk0I/6FeJqJdHKBdVFKI?=
 =?us-ascii?Q?Cf6MKOXTQPxkLU1xpOjTurmZxWqhSgwmrYFWEjeLKeq9oZM29urTlfb/bmfV?=
 =?us-ascii?Q?rWV/LCpzWXoVcOQyTwikkKq1fX587isGOj3D1iUG4Rb4ySR2qHGMEMO2/2S1?=
 =?us-ascii?Q?cWZ0ths9/DnF5sItz/rMc5OzGRAqbzfxd+JrltmJaf4Z3H9YQsnanP8Vz+Yv?=
 =?us-ascii?Q?B82uBSTh75BBVTAfQlBLNgEYqgeDTCN6Hi0hEIoBn4ODPqKMUei78TZfhHBM?=
 =?us-ascii?Q?H2R8ycGLF0ngoiIERRfFeiIGZFKo7ZZIDeXdD611CApmUtPZG5Lkz4CJs4AC?=
 =?us-ascii?Q?YknuUraaDs/tHCUxXipD6lH7Q6SVHRwmEsOiQfr9hIVACtIV2ziSEvYMQxYc?=
 =?us-ascii?Q?mZI7lM3ss4AtjKbAUrCvtybmxVvDJ32Wm27q9BcaKPTYD0vXHzTdlWVef8/k?=
 =?us-ascii?Q?beyv/1HGUYB+GKjKzaDwwT+mXXoukEU/vf3VJNJqKJQ6lRbYJpyWNwj1xJX2?=
 =?us-ascii?Q?AC+w2WOr/Gp54N09on48agkh0j6MxpIWajypZeoxUMTbQjkqqzNtHy8Bt2oz?=
 =?us-ascii?Q?9E9dPmxDKb0zU7S5qUxLC6suZgR6okj8RuEv9zGHG4ZJJ4Rq5UJ9mWVrnz2K?=
 =?us-ascii?Q?JhOfLSeP56Mruk7yUwDFwnQb1OckWIEAVD0ehV4/Xjd3aDog7Tr9JbF4UBm/?=
 =?us-ascii?Q?vHGa3xsPyEKCm6x3c9o/7VEbHUcwnuy7ygZJF6+cqj0tk62rM5PX5p/bpFgl?=
 =?us-ascii?Q?xIQwRHoP7Z6I6p7/D9YwNeltN9gJWIHfxD3h8fWDi1c2KfjjJL4hRtvK8/uk?=
 =?us-ascii?Q?tntd+4id2HyRL8U7CgZmy2Mq104DYLvajnJBOrN2NT80c5pf155/LLeppPHA?=
 =?us-ascii?Q?JyxJgZvzAzefpkY6toC6bT9pPBZd4Q1c63m80zOKnIoncB6PzHXW9kDnToyr?=
 =?us-ascii?Q?NY8fVqn+hpSSc7XugE91Xz4j89IZ/Xkf7FGlN8IYc5XvI1CjbV7UhkLIO1RS?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dPH0SQisurWxQhqVK3gYVZhIOluMAcbzlrbQBZTs3L7fLJgS3IAqlY/kAAl6kpugQGv5wiXJnoHZ3bMEyJCeD2HEGLfeD9hWwXX0X9bYKBbEzcTh3Zg14Pc71/B/hPPTHQd1q8kwMCEPrmF3dAD0jvUdirnQohZ/lVK2dwfEN05k5xEG7DAiixUs7iLhVocmAFpXWYPjJ+naPtt4JRbXZb/r7OyOyo6ILnM+hHUOulX6YKX4q8qunE1kcwIEeZ9ipgSzhQ/yZo+exebALWurroCFIlx0XYyAtgpSg1k9LB9N+E7gBG0WJ9SHO5ae9vf2TkDvcdug1Gcg9kTcSEa4snXC0+Ch5BXnpb1o/yFd/8DN6uyGQ4jt/UdQQTcoW1YBb0k2Z5I92gR5WFgGrMHRmDhbifTXTYHMdsE8aw7Ql2qgNUcEGgPo9CpMPd260IP9nyqtqz2hdNa1ANoUYpuy3pG/Zn0e7VPxuiq8rrFhl9Ac6InFp5BakIm/OjDp1aZBMV99hSFe4NA5UWgHJFXNawf6KFJ9AA3G/1Ztx/GopPD4IDrdiAsQlpv//taKbvwLGFtd9V5OrI18Z44km5DIHHQSHFwcGrMcOMNMGuqUwck=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac977ff-eb07-496e-fce8-08dd03179266
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 12:43:13.2743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1iU3qnNmD5VAaYJT/isdopuzxmabpLH5MhPrTw2L8pJcxPCu7xAjAK/2xh0d+SYRyQUvt/W/ASLeNliWTFulzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_05,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411120102
X-Proofpoint-GUID: By9QGEQKJ-_UNziqKOkStnh2eTOzVxZC
X-Proofpoint-ORIG-GUID: By9QGEQKJ-_UNziqKOkStnh2eTOzVxZC

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.

For an attempt to atomic write to a region which has bad blocks, error
the write as we just cannot do this. It is unlikely to find devices which
support atomic writes and bad blocks.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid1.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a5adf08ee174..cd44b4bebf49 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1571,7 +1571,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				continue;
 			}
 			if (is_bad) {
-				int good_sectors = first_bad - r1_bio->sector;
+				int good_sectors;
+
+				if (bio->bi_opf & REQ_ATOMIC) {
+					/* We just cannot atomically write this ... */
+					error = -EFAULT;
+					goto err_handle;
+				}
+
+				good_sectors = first_bad - r1_bio->sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
 			}
@@ -1657,7 +1665,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_opf = bio_op(bio) | (bio->bi_opf & (REQ_SYNC | REQ_FUA));
+		mbio->bi_opf = bio_op(bio) |
+			(bio->bi_opf & (REQ_SYNC | REQ_FUA | REQ_ATOMIC));
 		if (test_bit(FailFast, &rdev->flags) &&
 		    !test_bit(WriteMostly, &rdev->flags) &&
 		    conf->raid_disks - mddev->degraded > 1)
@@ -3224,6 +3233,7 @@ static int raid1_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1

