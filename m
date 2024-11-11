Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A8019C561;
	Mon, 11 Nov 2024 11:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731324159; cv=fail; b=iJvhCYgMF+V3L64ScGSHrzfyrFV6CzlHV7jMypV1p51sQyiy5S+TjsoZ+uw40lB6m4AxsFCKqkLg5e28OP2tyZgiDeQmK6YSWDyKEg1ytmUm5rUKjLD3xvaWZXojUXTL/KhODklJ7exk2jMvEXCzCULkQ+2iOqgMyJysX4oCuUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731324159; c=relaxed/simple;
	bh=nzsCz5XEEpm86cJNR+kao2AMFvFvM0fEOkIS+JBMN5Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jv8ZbuHFR5lbfGy64Ao5vCK+JkwCZVo9UIu2feV5A/YwKAB9JAjueHwzyv/CVE7pddqU27Nsv5iTw7HLMrh8cVqmW/y6eONuRe5XlbsQnb8Q8z1Wnj45NqtW4DlpPmvD37Ar4H08adIfkI6ZJi11+lbelp5JLP/aM9SZmgXyhHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PPMHz45L; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XrfjzLOh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PPMHz45L";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XrfjzLOh"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9smoN002344;
	Mon, 11 Nov 2024 11:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ChAfyyuIaKBf4ykPWgO7t1wJJxxpAdlnX/Jyw4MXPC8=; b=
	PPMHz45LC0zjPspB01QBLfKP8eWHc5hiJvWeVzAJLS7365axNT9YyQIbwD4g4PtU
	Ap3Rdc5WC3UyT3XLpuMKfZas+pPjyzKdsw87jYY5uREo5lZzaRp6X2g7Ib+OFndL
	jb5Tfr/bGY0HRrapmtWaHWU4FQOjxIalc/c8lG1+qnPcHriXz5BaaAlmyS6dM/2n
	A8S1cG6l67onjKnF+U9XmtbUYL3I1a+uBROr98YGrG4D/Y1V0kxpdtqbJ//1ycnW
	eVwbVvtxtFFvFlsNgJPY73tEAkifnXXycpUMRS81AJhqpF9EZMvKvSzpSe5e0kQO
	vRIZcoPYxvUfQF7cqAcNog==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0hej7as-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ABB0JNp023621;
	Mon, 11 Nov 2024 11:22:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2046.outbound.protection.outlook.com [104.47.55.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx66ntxy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HrcX6jVLU4MZ2fcN+03U8Fnjy08L8u0mNIxLK1lJ2A47x3iz0G/MKxjrya98qUWAbL8xlMorlKn3TzVhB5At5C83bMLctUI3rGPWNS8FNAsoX4nsuEuTL2JjzbCmYrFddlLMartfqR26gUgJYo4kOjY7y48uUMLiqeDZRFaun0iigUiRpB67YirwltawpOlWVvMkkAgBxZDjkX4U3SD0c9+QCaq6ZaPIeGGcrfvq6vKXuoG2JxSxnmA5Gzv1mP1BQhTd9BBiPdViTU7d2ekZr6TGVPtg5/meeF8ETRtCLuiPPJ6CLPHDBZxj6yYK8KuEunVOqBRyJhamz4noQulZaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ChAfyyuIaKBf4ykPWgO7t1wJJxxpAdlnX/Jyw4MXPC8=;
 b=UrY0tDuc7xcrBoxDZ0/NgA2NUFwpgPJ96H00oMOSBUxljEblYcjJ56vNFyE5EgDzk5ouZPY8xg9JZmAkE/l+M7Oo0hfgAX98MQNPe6D6ijZybCUtwZiXMdtFoFPRTmAec4wh1z9GeAhJo91cr7C7f1xPXIdO26zEflPypTyRcz/UD8MCVqC4rN3UTxN+KE/H7Q0hxMbrNI6oilVlVFdVhf7tUClsJsODs0K4BpcdBe+7AIfxp5jwmo5ODsir+36pcgiDnktdRKGcupK01dWCx9DZAJdG/zpwLBmLOnxzXmxYBFNRkbhl1ksoJ19MrR9QQJxNUOlY/N3Wn69cz14xQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChAfyyuIaKBf4ykPWgO7t1wJJxxpAdlnX/Jyw4MXPC8=;
 b=XrfjzLOhE1QAAre5ieEljzWlX1cgvdp0i/Gq7NtUJ1TCV8Jm/5GQClMG5ZK+mQd5R/XKWy0RIHGEzN7MdvvqgGEJpLxX4o53e2zLrToLOR7pYUl2Dk9lNSDtYIKNNQtTRIwnHAgYuEzcYgOQTmnrwaXqJ73WiZeynFWI6+YBKBA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Mon, 11 Nov
 2024 11:22:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 11:22:10 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 1/6] block: Rework bio_split() return value
Date: Mon, 11 Nov 2024 11:21:45 +0000
Message-Id: <20241111112150.3756529-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241111112150.3756529-1-john.g.garry@oracle.com>
References: <20241111112150.3756529-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0012.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d2e7749-a8a6-48f7-5718-08dd02431573
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OGzzXL5p422WznqPiLePla9ot70Mjib7Kk04UhbYGsCGy8Aavkle1iibXz2k?=
 =?us-ascii?Q?3HFlv64SpXJY5f4sfwL/O0daT8HAUAo8o6KUWVa4zNWG8sgHtke8Q6xDfqKN?=
 =?us-ascii?Q?6hrXZWQZykbXU0zyEV89FsYq+LTWQ6NwVi9Y9O64a2vpVU1uVm9PTSduigeF?=
 =?us-ascii?Q?zs+Vtpc3zLTKkRr5jd4b8SJjxB7k2pBNvyHc5WaBxF8kegIcP6Motj7M6fwC?=
 =?us-ascii?Q?J155ImoFxJVXBE+Da98YdAsSrfZFi6Gje6lnKXDv4uNnTVtvaYKAGl228oAD?=
 =?us-ascii?Q?s9h1mPDMj7ofgTz0qYcTrvTwARHrF3AA6u4kBJrK2veHDSfaQBGm+lUD3WpP?=
 =?us-ascii?Q?eWgo2vWxkM8ofci2XwIs2k+N5oK1wqA2i30MtGTU9jKjJMY7ZbFrZgxOfwVJ?=
 =?us-ascii?Q?a+G/+h3LSQhSX3HnJSQM1McMXEQCNC5S0oaX3e7f7QlyQ34O8kUklGE+wVo1?=
 =?us-ascii?Q?WoKlRYFFGq+gPE5iGtxBwWU7pAsmF0grO+Gbbw5aF0eVWBAMNTmzqMd0Etsw?=
 =?us-ascii?Q?SbhbnyXvDlbxvL7fql5sPRRyp9bFtURp3FjNKNh1V394pXjCVmpCQ1exz/Vx?=
 =?us-ascii?Q?8T8Hdi8wb2UCsFwSy/GBHQd0pSTW5LjwGwDGeMzvGa7VW6OSF8yw8CS0eMk+?=
 =?us-ascii?Q?tDE/WciAHQOIi6svCjD8jj4cV0iApHomOaEmbzLRAC4cVzw+UdnOa3HtJj0i?=
 =?us-ascii?Q?7VGi7dMIihYj60iDZHCpe7o7ZsCS2I3h8Mzmy52Qy5CcN+oZp5y6dOpFjd3R?=
 =?us-ascii?Q?mtYTAPn6elajDz5ATmM9puPhWQqWnz65S5xs5HyWaa6SJRnMkBbUawSo8bTj?=
 =?us-ascii?Q?QD3Gki27PFakX9nTzXTVhkCLMNw4hHSql3YCrjeYzLgd/O5eJFoFjbsz4QJr?=
 =?us-ascii?Q?UFgeCmOAdmRVs44Wke62xUUebuMyfnfo1oP/y43AqBbko4YH3POwFBaV7C76?=
 =?us-ascii?Q?DdKhhKJ2axO0NGS3+9+TEzZdqckKkPjiU/P7wLNWpqZH/42ZyGNajyshoGlM?=
 =?us-ascii?Q?VYkuyjg4S+TD2EbBm+cJRcyqnvUfRxphq2VG/udulxFbZkr2dPlOVfZhkXx2?=
 =?us-ascii?Q?CEXW6MiAlTdDNZTT7oyKu/H0sNUAgs+Tse0YRP84D4qMC775DJ7oorVBmlaE?=
 =?us-ascii?Q?gEXjIu/SIQ4a+UkyIc+oyVCStj8X3t8a6mnaSeOxGGjF2csFRycuv7HH/QxB?=
 =?us-ascii?Q?6HhkNd4Jh6mYio8SxesuLUJSROVEZcLB028s0cOqFs1SMZsMtP127qUJTPp+?=
 =?us-ascii?Q?O+PjfY5ZBgWa7PJg59/kerimpWy/bDdhTqoON5Pi93qNA0UJ1ZInpfdPOppy?=
 =?us-ascii?Q?2Da0KrhQocTiVYrgizfKWYVC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5IhyUntmjc2ywRHmMQ7CKZuwI8I+6Lk3DavQ+Bhl0sbIjtTc5EpLWcsD42Oa?=
 =?us-ascii?Q?5FeiSZLms9Ymh9fkaebU4z2MCB8dFxT4KXJw63rl4+felIsJcoZQzuuB513M?=
 =?us-ascii?Q?y2CO4ZO1+6pR5XrQBOFwZ+bsojqAUh7wTaIFt3/Ld4O+YfYzuT6ceHnUt7iy?=
 =?us-ascii?Q?JN8HTHmgg26NYu34wEGUOOjs1F4pqfrhfjXznk3e8zpe3B0PxjFfl3cCD3YA?=
 =?us-ascii?Q?cno4HA2Wvv7twzmTmE199Wlpugsdu24321N+iuh1t2zhKMDYVPTB9CQBP7Mk?=
 =?us-ascii?Q?vVBiMnKU6+vF3kR/vPCPupDACG0yHTwjF6G2Sk8e4YsA7h4xK6qWOOh6vvb0?=
 =?us-ascii?Q?/xOrVf4gcysZyVzbMX8l0BPxc8a2w4DqfOhojHTAT2pPyS6Uroj0jcyR1YFA?=
 =?us-ascii?Q?tn/skTORq0lTUxVz72BDn9gpc6q63yLpjyUAgX8W0vT8ngVKEi0Q6AMtJErP?=
 =?us-ascii?Q?UOF48g12tu9yAw0I7VwgIarLs1GrT7TxwSppBwrZVmemsIp0Uiw1C+m1z74z?=
 =?us-ascii?Q?mXVHL9mFtv6VL82uneqFghiL3pWwV/HK9gVwlsUwtKYszS4BMcutPcMpyaPH?=
 =?us-ascii?Q?Q3vm9moultQ4IE8csIKw4WmgH8CGPxQ7s5zp0KkEYiJin4DGwm5FZsGlTbxr?=
 =?us-ascii?Q?xc0s1AeyaM3+M78wQsPgiTpf1btiEwgFJ8ibUFH+Q0cUh5XwIGCkcPseOh2F?=
 =?us-ascii?Q?Wl/OTEoONivY4ZpBP/FIhj5Mf+5U5owtkyU+4QBL70xXwot5d37MdcqkS5jc?=
 =?us-ascii?Q?XLxVKTqE89QH20jR6TcjT4Wk7/U1T9dr0N9wDObpYKNSxWm5CxDyWg7mglit?=
 =?us-ascii?Q?rqrn6CWMVY+Bp0LfE86aX4TRFw7P1ifavDkaU59qvonMT1mpixpvXd5OMAc0?=
 =?us-ascii?Q?ATUD4EZctbZHvVMOPaXbuHJyOJPPVlgvVCVvsnaACD7qjIEfUN7WAvV2wIn+?=
 =?us-ascii?Q?enCA8RZFfoWocMfIMpuAmN+qVNYEtapkEaqtAufSWaRl2l8I5eVEu2tfoxAu?=
 =?us-ascii?Q?XgigEoGUluDZ7V4YNcZeVYar0nx6pSrnhtiupuIdRpRNzUBqRd2bGG7RA8aH?=
 =?us-ascii?Q?1qGTH5VhoYA2jSQPKVtLC1Fbj90visAlyQsVb+Edr632dJQCGTeSJkttI2Mq?=
 =?us-ascii?Q?sps0NH+rLutpc6tq/L9F+8euT3qnh+0GZghqRLeJh4TOqdG/TOIK/vj+4L5v?=
 =?us-ascii?Q?7dk4ds3ETZvOLAI3FKbQDAlTnU/EmB5P+YwUKfLiO87Has4msNSgGuWPJNBe?=
 =?us-ascii?Q?rj0WPkS0OcqNbSqwCdqhYdqIA/HEBfJ8QCE1OFhJp4EJHlyVeYsvezI2ivGV?=
 =?us-ascii?Q?VreB8O/ToZU2l4TeAjJZr68GH/bomZd0FxeluyB3bDtCCFLs+sNlAFvp1yXA?=
 =?us-ascii?Q?ZYh8n+6ZEcFeBln39qCVhuKYgGSknZzQbKdJiOaFbwwvx6nCgpeCkqfH3vqU?=
 =?us-ascii?Q?hWpYJv8q1bC9x4wiQmhoVc53i1mww/0Xnvnr6rY8gQe6fuaTTZdsxOLhNg/Z?=
 =?us-ascii?Q?5jYjA3EwaDKP+xmQ7BOtq//BMwsb7UQvbwMcFLG2KmvMXk1rbbwWWmJlZ8Xx?=
 =?us-ascii?Q?DlshGyWIefKiiDEkxVI/IzsfnxKr9qFaorUBTK0rv5YR/Ee9ts2E2zUBjkkY?=
 =?us-ascii?Q?kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aF6KTgxY0Lv0/0h0E8LO5EsUgjQrfYIchULe2kFF15yeLAQ49etpmyWLzJlY3uodgY0Uxca4tXSmfKCaOGqAkX6Eko79rfytmKXmh4prNOztuwLt9SPqkRWgm6gtpj07/8OjSDlXYuNWIJDsnD0Q5lIMw3Ji4fYvCgEvKvIWQrtYKc7mdI1OAwMePCiJFt9S1W7ZNddhG5AIbsYgKC7gAzKCEhSWzcQW+1mw7uVtOxnTG/9JqXwiNZjwtIFw3Jg3cMUzEjgkoAMHByzv4HiGl6tc+9sh/ZaRMUg7c+JLPshthM/k5d8YPybnfNqs8zMwoDQZtqJwtFsXMnDHQSy0Zt4La5cE5BgKsNuNuBUgLzm7LaGX6wRYSsVXGQEc9Eh+jIVHV8Xnt74bPaR7phT1JQ+OY+j1xgZLcJYxxG65DilKdLNqW/tZrdwa6dgVbJxeoLeeKyfzelnQJXd82skoJJ5duaaIAQ21OyUq4E5TacwFzY2T9DPEtvoQZ2h83rPxLHcrJWCH+Tz0h/nkN2mx8Ob5vc1UOE88CHTePWIAMBB8iVkSjw2N6KIEZMz0YPWLtjXXXL84OsWk4/9NvIHLeCq8uT7DQvQd1bBN1PcZg5E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d2e7749-a8a6-48f7-5718-08dd02431573
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 11:22:10.3714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cKxcdodmECnG9tr6cz66G3KGy21n3Ei9eB0GozMY54a2/yr9l5kGSXIjtSLb0kHaueDGBATSDrxLWLuy0S56w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-11_08,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411110095
X-Proofpoint-ORIG-GUID: SswmFGv3ZnmsErlecFOTs0mQmN_FZ2T7
X-Proofpoint-GUID: SswmFGv3ZnmsErlecFOTs0mQmN_FZ2T7

Instead of returning an inconclusive value of NULL for an error in calling
bio_split(), return a ERR_PTR() always.

Also remove the BUG_ON() calls, and WARN_ON_ONCE() instead. Indeed, since
almost all callers don't check the return code from bio_split(), we'll
crash anyway (for those failures).

Fix up the only user which checks bio_split() return code today (directly
or indirectly), blk_crypto_fallback_split_bio_if_needed(). The md/bcache
code does check the return code in cached_dev_cache_miss() ->
bio_next_split() -> bio_split(), but only to see if there was a split, so
there would be no change in behaviour here (when returning a ERR_PTR()).

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bio.c                 | 10 ++++++----
 block/blk-crypto-fallback.c |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index daceb0a5c1d7..948b22825510 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1665,16 +1665,18 @@ struct bio *bio_split(struct bio *bio, int sectors,
 {
 	struct bio *split;
 
-	BUG_ON(sectors <= 0);
-	BUG_ON(sectors >= bio_sectors(bio));
+	if (WARN_ON_ONCE(sectors <= 0))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(sectors >= bio_sectors(bio)))
+		return ERR_PTR(-EINVAL);
 
 	/* Zone append commands cannot be split */
 	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	split = bio_alloc_clone(bio->bi_bdev, bio, gfp, bs);
 	if (!split)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	split->bi_iter.bi_size = sectors << 9;
 
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index b1e7415f8439..29a205482617 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -226,7 +226,7 @@ static bool blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
 
 		split_bio = bio_split(bio, num_sectors, GFP_NOIO,
 				      &crypto_bio_split);
-		if (!split_bio) {
+		if (IS_ERR(split_bio)) {
 			bio->bi_status = BLK_STS_RESOURCE;
 			return false;
 		}
-- 
2.31.1

