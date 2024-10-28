Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5396F1D7E5F;
	Mon, 28 Oct 2024 15:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730129285; cv=fail; b=AzH1tp+yf/frTUadbBrP7ub8o+KDb31tx6T2SJabOf6UddqOltYixRYTrPjpVOeDolFtU1JZBFnPOKlgdbRjIsz1Ru54UI8woQ5/CsxHuQwNNGgGFZ5PDbLzpLp41Sw/cbX/c5wE5b8/7a7AdGztBOi2cMKgXU3McPmSu0kubQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730129285; c=relaxed/simple;
	bh=/4omSu4YaAMpctlgfIn9gujW/VBkrN8GppceQWZl39g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hsHk61JsmBvGP4qip5b7G49r1gNz5M41Ve+r+yd/wLPDv69Yqw+R0nsvxKCSxlyGN3aJwHZp13Jq7Uevb5VAbxlBOPekRBJepuUW1MS79zjdJ0xdU1YJWSTdo/ejCqaqcE+eNlQulJBXKWeO7XGfo+lGrwY1wiUtG31t2J92HdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E9sMpdBD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LApqyeeV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E9sMpdBD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LApqyeeV"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEu6O7030117;
	Mon, 28 Oct 2024 15:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=og8QgRIQ+tfdEcc8RIfmH1HHOLcNejdMCU4XsdgeyAU=; b=
	E9sMpdBD1mSyiyhCTxhzUQ4PvyKQ2SW05J1emIMQgGUWuajQ5SKrHxzncTODScTe
	131Q3R/xjEGsXIR+k58NlFGqZDvnrJyRqTdo5r6kQvuCx8+bMiHOIWhcDyggC1Qh
	CBHEdbW0OwRrOJ77s/xE1SmNzBifxpn+SxNOIMWzsk7xHg/7Rn5uB/VQOs4O1Egq
	kifHrLnbby/YcBiU2ZVWv1gcF9W6oONDeVjnFkc4sI0Ud2SSMl3cOufiyrM/Ea22
	lWZBnPyUzZWPg9GiAJ/L6+GKK6Fgbyf7tdrsrTUBrhjUDCCkN7yu2cbCifBlqCUi
	IyTGOiQIeYKGY9hjUNjZYw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc1u5a3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49SExQoJ008380;
	Mon, 28 Oct 2024 15:27:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hne82en1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cn8YkPPvaeeU2E3endDiDg7WbylE5/YlpX+2CWnS29FOv0RD1VG37mJpBKCmZkmIV8sv9ifBB+bqvkcAdRka5aSGywreU7Jo8rwPUYS471twpTry/3vyYpooV4sdRseHtDgyhbbeJdXrzyBFxmgaRsetXIwvsdh8XoxBrQwaugz0pEHbtP4Wv7Y9vQ9ew/GGKiomviF7rGixDvyenTheRkzGGfqi2gj7fznhh610jA51zxMJZMS1Y4He+kyx5aM/2++brXjOpJEHz3y7vx6kx5eNo09Nl4m6VlDMum8VzdERCmEKCSAEpeB2KgyiG5ZSwvnMGdMDHqlFH7OPUatkeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=og8QgRIQ+tfdEcc8RIfmH1HHOLcNejdMCU4XsdgeyAU=;
 b=yiPSPh5VAzQAES4NP99UkUFcQDp3oLuUo7j0BixNIQI9Os2ShMmRE+xK8VfO1NYsedlE5oE4LsWiMqhVa5hsrZ3yO28HiOrlyacyqZNXvI8zpiWFMHOe3n74PrZf1dHCgVVbHfMVgG1TynlzhPrynEgPVYiXKpFsx4voCqbxPwXg7CPtQUTr/wXFXL/AoTvVO+dqph7LT9hSYdxWQY2magblanWkFI6PNew/lJEvtph/a3HK7I7xa+r4CBi4RPL3W2Z1xe4oKZR2gyZYpoz2ClDfW7sZQhX85zVcoRXWmm7xKKLMHqazxUurl59RFgTQVXuQM/m9EPpzxd1LCFgfKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=og8QgRIQ+tfdEcc8RIfmH1HHOLcNejdMCU4XsdgeyAU=;
 b=LApqyeeVWnQlWoa34q3/cv1xPmZd2jc7m1acgfKZ65Nor+uORyE574KNr+99PmU7mQABnnxk6ZRIc54jigcYOl9JN0W1QGWCe3ZnCKsI9CWRTYoUH0aZ/UZggRh0pco9LqRG8pjA1W3LiAviLsmQ63MMhO34C/YXszHWmLApKSA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4170.namprd10.prod.outlook.com (2603:10b6:5:213::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Mon, 28 Oct
 2024 15:27:45 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Mon, 28 Oct 2024
 15:27:45 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 1/7] block: Use BLK_STS_OK in bio_init()
Date: Mon, 28 Oct 2024 15:27:24 +0000
Message-Id: <20241028152730.3377030-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241028152730.3377030-1-john.g.garry@oracle.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:40::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: 2451c86b-7690-4e2c-466d-08dcf7651230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1YGyraYuje2lQZLJIsB/rQ54OgiM7M6kTnbWMoOQlV66NLzBgbJM2ik6IWAG?=
 =?us-ascii?Q?nhZd301z4Vic5v0OA6Wvh5LKVEbSipTzuiJjTFH6JZDtQBhIrYSS7Hnp6xnU?=
 =?us-ascii?Q?3WpdFTea5bTSA4xpOckVWoefXD93zX58Lzu6GjUj3S96QqdgxU/CUugjoBO/?=
 =?us-ascii?Q?/1uZKmWsSiTtBdE/woPeqbfS+Okn+DYyi7xjDIeVRdo+tGVCFqbsiSmDPVm8?=
 =?us-ascii?Q?dJYQD9SKtoUk9Ua+3AoP6IstQWyx2GDTt8OG2W/1+IvOupeC3C02TnP8XrOl?=
 =?us-ascii?Q?6uV6Y/9h2QjtgtgNnCjJ1ehvlasBC8sKeguPhLAhpG0OlLtpsuoyKkJSELwR?=
 =?us-ascii?Q?KSw/SZeDdDC5i+8HLbAQXJo2amXIfaFYOtewU9yn9TZT2bMoJ5/98h1Y4wCW?=
 =?us-ascii?Q?aKDSpFLxfV3i3I4RkS5F7jYR2+1gN54wB1TsOzYdHZM0GAyZ5UY4iZ2sJLB7?=
 =?us-ascii?Q?oFGq4LWd1QlsU+eoa1VItMYcRJl9E2V90zf6tbRMBzAHESS1JBPj/y3C9Rsl?=
 =?us-ascii?Q?nUL7PUsEtvGoznD3OX/+tliICtvI3MRrJn7M/p6OjAQ8v2sqHJeUX+g+S3+N?=
 =?us-ascii?Q?p79/8nJ/7RX0HveU7fjrq20zbJqDxc6EneQI2/u1ChKJtlurDW8pxCT0fYCV?=
 =?us-ascii?Q?bBxlTDmT89iq0up01t1hiOhLyvEvbi9ITag6kr1IfvrtTq0sJ9yRkDpUJdoF?=
 =?us-ascii?Q?2wORPNXIPdQR+mVvwGHxIYwgofcMzyPDXt4N+4x1JR1cPqHq4pcG5XWRMj31?=
 =?us-ascii?Q?P21J2JHJRo+90vaHqR8HHvaXqtpOfBzvnD3s/wU2v7KpDexzVFw3++ZcUD2s?=
 =?us-ascii?Q?lGEIBMCZLsv6t9TcigbJxG8UMdr2zwDplC6PhgoXGyGG4KO4w7jLs3RTsz8B?=
 =?us-ascii?Q?IA6ScSCzsAtnDKuc8S9u4fBBCdA8S+R9oKc1p2Y886x25OugNco66z8vnkEz?=
 =?us-ascii?Q?lLtmeb8iLesqR2GNmBa0Nccu09/7rSL+NfKFt//qNOsz6bJfZbx1Kmk2dqJ6?=
 =?us-ascii?Q?irSFxDi4ZYClGfE+Dt5XkjzzYZcUCU1+buIbfig3QyEVLywUNRiQk2X/zlOR?=
 =?us-ascii?Q?4WZFLwP45+8SOHxR6o17UF7WmSS4VLLNYYRRB755aRs/7UDGoLqQDlbqqyj1?=
 =?us-ascii?Q?9V0UqodDfuZNdAkPD0sLVvF5ykhYQGwXLrH0p+w+Ror7p97rjNww92h0sdjM?=
 =?us-ascii?Q?Lk2GR1mPx2y0YwAmcWZbcY63IY/3n9jozfnkiNZLLExoxNZFsPDQ7SNu9o9T?=
 =?us-ascii?Q?2ChfuY7blLxf+DpoWzwzipwH2EatD3lssdEz5qmxceUCyU/3PYqNC8zlTnaS?=
 =?us-ascii?Q?zvy4aU6wqLf9c/xpY09gsO2Y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G1u3wJluU/vU6Z2ZrN8xA+F4krIvkcJWSYWrYKtJS6BnjcuyjuN7OXzLJRix?=
 =?us-ascii?Q?SO7k8Kve72QX+9dd12YhwWnF+v6zzZfD6h/GA9CVNA+R+FRQzntrg7TBoQLH?=
 =?us-ascii?Q?G0Fti6cR6xgiWlBrwTmmdIO5LTlYud0D2PyuU6zZ4vCdPBe4KIEumAdzzB80?=
 =?us-ascii?Q?EC/4ziC7hbFVTeRnZCuzLcwUwCznuHwbNXgouNJkhoqkxj7Oy9l9xHdKDIjO?=
 =?us-ascii?Q?7z6hNe7tTQP50TYnKgupyR5xvsLBMBpFpSJmK6txRwYpSyEpEMfvP7KUl8XB?=
 =?us-ascii?Q?UCAyUksFqPvkTIDLv3Wr80Tnhq/qpxDUAD4ugPCtS31p47lYuPcoXT27Q8LY?=
 =?us-ascii?Q?s4/JXQK0FH2mXB3jJjVQupqvM1t9+xbFbeRxsbYanCSvyXIWPQNdsw56Op01?=
 =?us-ascii?Q?sHtigDCpGYS1uMVKIz659YLSAKxJgQNAzTtjPxBF/vjaCblh1M1OILrfMSz3?=
 =?us-ascii?Q?HCvi25ULgP3cy3ma+a0Cq6mA2GYYlexoQve2IwH9oQXSb3THHQjFLo+XG4VB?=
 =?us-ascii?Q?IFzFfRw3m11FlgGqmvoLqQzIlq21zfSU8HzYjiJ2t3eVXxJ5+CRPov4MqR+g?=
 =?us-ascii?Q?TQSZzkAqS1FTjyYBM/HzJ9vBjO+6UGZRBQEkYj0dUeCjP9ZuzqRimjTKFzoj?=
 =?us-ascii?Q?wDcEItSpraRdMwRU5LIsKdaXCu9FX1vZA5awG8yv5KK3AHpMibJk34PfZ+5P?=
 =?us-ascii?Q?M+ViAXYRQp25/YoeWbfS+nz7KKMG2jnmOlj8wv7hEjegmv7k9NvbNpFRseE8?=
 =?us-ascii?Q?+Bv22Cfl8JqZg+KlB0qjHnw6jXVZ7f4omdlFZcPccVOvn/L/hfZzXOQsd8Nb?=
 =?us-ascii?Q?TigdPPybm9MZuC7WZWO/l5rdeaZ+D1xh32iM7s358+ExOA0ehUl/fOJjaaIh?=
 =?us-ascii?Q?z9q7IPlc5GRp+jTAqX9or8jP0qNNsjOgk/cTg2eoHIPj7C19reQ1m5TM9qF9?=
 =?us-ascii?Q?ibExRJi6Xes0cJ8mIker9//JrqQvYhuqAClLAY+/rgQsXCeyB/8U8FwYLq+A?=
 =?us-ascii?Q?C4LTYM1+skDBFCGUNaPl6EHpu4kGf6gTH2sS9CbWi+KUMsAwyphhsqJQknwO?=
 =?us-ascii?Q?sKH87gKfgH45MSMVzx3wt/bI2P0NFJ1vd6ez0maH6URFdE7lMQyR9oUhLdhI?=
 =?us-ascii?Q?m+7Tkt6c+rfDS5YpQoHLgXto0P0dO1kbEryf4SzkVKfJJZWS1UvhOvaBo7Vf?=
 =?us-ascii?Q?s2l37r3C+6l1Dsv75RMGgFqkznRbR7llVKoLUZYM1adcoT63bphv2dDaRQLb?=
 =?us-ascii?Q?URa71MX+DMFzDeth5IqxWvK3mWiWeDCSKaFcfTPDEDyflgFHjEsALbtPcI4y?=
 =?us-ascii?Q?nj3lolcTytBPE6/w2EH0FfcU4I8WLtT9vEa9n+jFtwhsoWYOW7q4V8PLDvgQ?=
 =?us-ascii?Q?pb3JA5ntGacrjbNqvuORC2kKmcwax2tFwKHamH6+QvgoCPBDlbxYqAAGF8q0?=
 =?us-ascii?Q?YWxzOj2MbiKYG4ZW/TWYYeir+34hRVFYtoxhA5seM3yd3xQa6uMsnxFXFXP+?=
 =?us-ascii?Q?VmmWM6RPAAvgTCK7eaifsraMZwnpTI8lEUGRLbPOXQ3Y6c7k+u0nVmrgvZs5?=
 =?us-ascii?Q?Bjd2D9YGiRch0d2TCFtaDh3WtssNVLuuEL744NPlOZrrM8AivR4fvv9M/dX8?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jaVSgbKcA11ieTBAlzI9nAcjqvHTXEJSin5szwbnqfPTSwSpyk1PekdVJTswsiHTcX9mtR61lz4Gzkabvm5YlNcVMbbZs7kF8mBSfjHPymzPx4UB/oQnJ4TcpHoYLc8QeindMYV0wLwpACPiW5j4HZmEjeqCR8j45vaBGiDOaTB8JTKcyok8uLG56lMITl9HoJPkIZ2Htv+6JBr8t6mKy9kIKI8IrqkKxoCTeX6btbikkhzBlpQ0AQGQnU0pHPBFDyhetuXV6ZSpcLGICBDvm+1O0m1c7fkqa7ciyjMyb399oqKh6AK/e83YQbdaL5MrMQG8XXdJ6p4U3e4bbp/M89OOTB2r82MR4e568oYE0aHMZJqH3uIMMxZ+XmXjaAIMqBAk5ngzqVULuibWKkQFvMGvy8ZCEW2tZua05SBkM1YXRNZ+fsSMUJX8dJEZBP26kc0cVFfngQAgHUnZz0j5opoNuqciRa9MNMRYUjcVhcTrRzQbMm32MJm3jaIWtu6vlVhVfIl7XUwywd095KA3Hu2tPIT1hXFsMJYMFI9S1q0V8kdJkceM5UGQWSL5eDaSI3OqinqqDIJVfROVXyknjRqEGTNVphR1EtxcGZbfSKA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2451c86b-7690-4e2c-466d-08dcf7651230
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 15:27:44.9789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drukg7IkUA/I/Za3XWgBu1EHWQTxzTJQLKeW3+WaZPoxJaIgpKh1aMQbe2zvs/eBbr6U0WWgY/wp/5C8tek/vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4170
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-28_04,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410280123
X-Proofpoint-GUID: 0HPY0vj0JDkqoD5WDb2gbmbjqDxbjJoI
X-Proofpoint-ORIG-GUID: 0HPY0vj0JDkqoD5WDb2gbmbjqDxbjJoI

Use the proper blk_status_t value to init the bi_status.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 95e2ee14cea2..4cc33ee68640 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -251,7 +251,7 @@ void bio_init(struct bio *bio, struct block_device *bdev, struct bio_vec *table,
 	bio->bi_flags = 0;
 	bio->bi_ioprio = 0;
 	bio->bi_write_hint = 0;
-	bio->bi_status = 0;
+	bio->bi_status = BLK_STS_OK;
 	bio->bi_iter.bi_sector = 0;
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_idx = 0;
-- 
2.31.1

