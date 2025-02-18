Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FC817A30E
	for <linux-raid@vger.kernel.org>; Tue, 18 Feb 2025 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739904522; cv=fail; b=LGx1GP7O5gZKx2d869ra7LMVT4VQlTT5PJxaqh/OPgWT0IeMTgy73ewMe5yYaODpL0gcpgbW4Z3cjBqXLiKVlPxgN6Iv0nGz5HE66oyGS1bmNc3ByBMrTanXnGO3NUST2k8C37BDNmksj+zelTtk88FGEbggeBwFQPzQFICOY98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739904522; c=relaxed/simple;
	bh=PuxybArihveo83GQ0rQYNResj364FR4+WVzf0/+1qts=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=AouD1cBN4y0wz9EkbqUWRxbpGViw8nC3YqxZeqpcMkSG/IhokZyhHd9Ct3o/9Z4YhAIMU2HdtXrxL1jqqiYrIkfPuwnR1qqVJvLqxwlQhUcf5KZH99M7jYaTmLuw0aIeh8Xt93ClCgrTQWjrddQdjMn96p1cbBMYY8V60HXQqoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B10wlciX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cCE24J01; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B10wlciX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cCE24J01"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IIfaSJ030412;
	Tue, 18 Feb 2025 18:48:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=/hJ36/OGrDvmoGfy
	TZCD7JN2Y8EhAjQ2v4AegfT2GN8=; b=B10wlciXqLYixgVuFq50bK6/TS5FKleZ
	WW2UV0z8DgFa+58IbkUHHT6UrKXrQMCbswZlxs5J0XALl80GTJ/XWia9yggtrTyC
	Y9oU8f1uNp1USSGecm0pK6VznjqrDKda8/JMUMrvhq9FNvvkH/3QuvCYRWZEn9H4
	6epNgRlz1sg6/6A3rKYpcamHvfHx4up/dx/l5ti8ONrnq4lafkx2NlcjbGVUwGWx
	IxiCMd8udm7mgI7h4IQcBJCm1jAbuRQHFxoEzk8MyH3wcZRhfxh/AFpm61jSP3qj
	QP3mrh8/nP0RnbwxwaihDxB/FSk4Om/3NFiYk7RWzSPzFUJ8f0j9UQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44thuaf8mb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 18:48:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51IIA9Tk036607;
	Tue, 18 Feb 2025 18:48:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2046.outbound.protection.outlook.com [104.47.55.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44thc9e1pn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 18:48:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NMvAU7Kp1OQdR2Qy6cYW7kVtwG3ajHeKVBp3wNriy35uA+0oP8zLg0+aUAM1VzI17GHvFJUwu/D+38RVfnIbjYab4j1+ab3ursGmSGTG2ahOVH0f9/yH5lzcVrCvmSpHKZTpMyBu9vJi+UZc9WQVJ5U5lvgaD/2i/mFKNi/IRvTuVP3UFY2ZUWsuYMR2JbxKytDV7LE6e1FCPbihXGIKXJWc2pWwE0ZmMiNyH7MvXbpQoc0mVT5LeqyL1yu7lwlCE8vSMy8f32Ku4XvYcQNmGwkNWihwnzE2C9caWInTfr/67SgrERzVuHVvm0rWfRcz6qVZDAq1tHS/913YSpa8vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hJ36/OGrDvmoGfyTZCD7JN2Y8EhAjQ2v4AegfT2GN8=;
 b=HNgeY71hstidMUvdglntWOU8Bkd0T9VTKt4+lMn02H88WFidheOv9iN17iFFU1PqwZ1m0UQrHOiWs0NdviUAJ0QEBWfdfi8ZqmHkfhTAiLWiNqtxQPnfmheR6f69mAAH+/plEadaVi4Je9afS33Aq5ZXsjT4uaxY+LPSmGUyJH9QurhwO4QSbNqBt2MXz5gFAJRRRTNFBgrrCiE5d8DvBDkoSERwIX0EFNm1ERBCC4Y0RjTyZtHOnhdLRPf0DH/UjBYgM/E7QuiyXOPbdJbb/qi5dXOlrXj48F3eYY70//hH83OC/W9jV744fFxsGQPK7ueBCPLpSyYBIXpknuBHwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hJ36/OGrDvmoGfyTZCD7JN2Y8EhAjQ2v4AegfT2GN8=;
 b=cCE24J01bFzgPRuQneI3cbVqbDWfHiBebgQYMc+pQcJkrJ0um7iVthbDhRxWPpNYUYO2L7LfOFtRlaQAS142gp73Uwsfzpr6DFUgs9vmjD3gpHF7/QAVyvo6GTc5YDq4wJUX2x2olOcoFMknHXE8AUBgWQM4UODcVZvLCPJP9OY=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by PH7PR10MB6508.namprd10.prod.outlook.com (2603:10b6:510:203::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.16; Tue, 18 Feb
 2025 18:48:31 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::a472:6f6e:39dc:d127]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::a472:6f6e:39dc:d127%4]) with mapi id 15.20.8445.008; Tue, 18 Feb 2025
 18:48:31 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: mtkaczyk@kernel.org, blazej.kucman@linux.intel.com
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, song@kernel.org,
        xni@redhat.com, yukuai@kernel.org, junxiao.bi@oracle.com
Subject: [PATCH V2] mdmon: imsm: fix metadata corruption when managing new array
Date: Tue, 18 Feb 2025 10:48:31 -0800
Message-Id: <20250218184831.19694-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0037.namprd08.prod.outlook.com
 (2603:10b6:a03:117::14) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|PH7PR10MB6508:EE_
X-MS-Office365-Filtering-Correlation-Id: 35873058-85b6-49b1-6e09-08dd504cd751
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dr43Rz1Og7Q7iQz1sVwN+E52nwZbd7THdSqo2On9y8h46VUSX+vAERINWsoV?=
 =?us-ascii?Q?tX7FU9zoX3X/DjqShYAGfI9i2EFteXMXXpmWxMAY9OeXkD7yDGxO6NKygVz6?=
 =?us-ascii?Q?JW7vjknMSFHRYCy0x+Cg/2ysIoUsTwVJru1mA3eFvl7WUsKsWQgNoVmRh56K?=
 =?us-ascii?Q?XRixm8yXpokHaOUHjxLZpd8YYhTUbymc0KHSOImGj9Lhc6Iq24DuueoDTMtX?=
 =?us-ascii?Q?AKn/qkTPqo9rsv5mFYP6trCfJNrPIYlR8HxTwDbpQWhVD9+8eG0lOV1rn4vB?=
 =?us-ascii?Q?oZj0PlV4xcG1Bjq2EQTyxs51nzB4txXhFMA5qJwON15ztevQd+NKRjXC39dE?=
 =?us-ascii?Q?7mGJoHidZlBW1ba1WFAsSfl2Mn0tlEfvAXXQgXXMMw+cxonpLNAiUFkalx2T?=
 =?us-ascii?Q?RcUpTgFyjdG2dzoaCzWxEbyYi+kXtRrstjykedNXV2ZxcnTSWtU5jHAwR7fY?=
 =?us-ascii?Q?OAcJrexNBADFRdrBiqjZtk4gO375h2WEwtQFtJsSs7Rkc4XxM2A77d50keEp?=
 =?us-ascii?Q?8Zms1Y2/FbpEMPVmXkmvRJ5h7yfmhePhQz7HjI3J6Y7Y+RBzM43BpqB2+gn2?=
 =?us-ascii?Q?lqwignAV0DZ9XnqqFtMjWwfGdkXyQ/0QBhU67yhbnHgzTV+zTiDHUfbbh6Z6?=
 =?us-ascii?Q?seAo4wr+Qywt+U89QHjJTcmt4Iz8p+CNgpRRz9v/LDzSzD/0r28TMt0NJcKR?=
 =?us-ascii?Q?3kuVybF+XGRKm9Ey5kDn9/KDxUGh1lZ7GxnsMbuw9tMYIZDUJ72F9xRnN5NS?=
 =?us-ascii?Q?2H/SmtUbqSL0t3KY6AOc9a/TlBqEVP7ex3+KbSaIhIVnh0YUAYL9wbp4tSj4?=
 =?us-ascii?Q?uYWFVPimP0BXOICyhNm9zhz5VQkfT4MbAGefbj5gcTb8TzBUCA+B31iGXMZV?=
 =?us-ascii?Q?m5QPnEfa+ViKbl3RRq6DHTSHRsINnFXuJVep0wCwmWdt7v6DE6YqHMoLKvEL?=
 =?us-ascii?Q?yv6AUymhG1jXaTnEFcLdNtbs4n1lBaHFKeSJJFJOWwqzA3Zea3jUP1Ffkfg2?=
 =?us-ascii?Q?7PC1c0P+zqiXwqdvRVhg8tK2rE4kjif2zlk85jaSt+X4lZh7KHGilvcIuMpI?=
 =?us-ascii?Q?H/Z9/odVX1liRgyFegVd+NxTMxiNhJqgr87h6JHr3sHA7+JyjaflKl7tAcDC?=
 =?us-ascii?Q?RNlGSvaPAEUYUCfOiRkBC/xC1DlJFaBR8s4kMKZJCJf1zlZuh/lBUPbaD0m5?=
 =?us-ascii?Q?wPO+7JOXm7bKS1etIHhSXUCPOJffIk9rONQtdVnXyDLWxDxdAwmnITjBA6DM?=
 =?us-ascii?Q?cVRKx6MH+jGTgTDukzauxIcLdEgcd6+PmS3c6iXatPTWUVEaNX1nJgZyxk1K?=
 =?us-ascii?Q?ow9NvyEnXNQ+2SKoCTZySCFNDhhcQSygmjhJheX1WI5poLKRpuK/3lYFgYE9?=
 =?us-ascii?Q?ryGTv5sNLzvXHin3iNb2O3OmjYI+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3SxWw1+gh0pOGtPEv03jz7ApFHREnBJSVkWxwf7VeHDYJMeTwWqcgcDneRPk?=
 =?us-ascii?Q?7BEy8nJa/0da/W9En8ZUi3Wcp6GKHKYa7bQPNpxfbrPAcu8aRhCMbYnol6vh?=
 =?us-ascii?Q?xZ4k+GBNiXthM3Yauykwoo0xWmh7PnGrbZRbdCLoFYXvaDIIf/BeXrG3Ho/E?=
 =?us-ascii?Q?Ees/b7W2zkJl72HQ+S9FhNGjo2Ll89XyXV6c5DBtgeTCLwoyla2eRMpF/p0P?=
 =?us-ascii?Q?NRA4/JHJifGXlby7RS8TB2uG9pzSOQTZZTbz30hR2uE5g2H2H3RfavNov8dg?=
 =?us-ascii?Q?BnaTGIkGY3qrioM9cccRDQQKUSrSDhVl5gKUjvJsJS3tw3YFCGYKJI0uLDWU?=
 =?us-ascii?Q?VucwPsS8hODJ3ducSw6/0foCjRLgn6onHWbO3i4Oh21ANEmu9hNiM0xmLKOw?=
 =?us-ascii?Q?XnqFhkrjMDgFp7m57BKM9TwVu6hel3+cleX459KAVt1Gz4oHtQqc59uofI8Y?=
 =?us-ascii?Q?3sw6/+ofyhspyjVgyJruyRM8iAWOQ5mserupsb9XMgtdIG6gwJcEGhTgv6ie?=
 =?us-ascii?Q?ekgD1W84oYFn5uutZviyRvhWyJyIQQrh7O+IC3K8aNXaD0/+fG0HdwQo5OFU?=
 =?us-ascii?Q?B0Uetdw5J93IQ5fsf141OxYLVRUKQJK3KZd4e1zJBL724zgq7qVlfcq/VUUI?=
 =?us-ascii?Q?JqSUqvMKTA1wK8mSSMtD7Vkl4iywKXOpmeeLm4BM1bTN73Jloqythv40mlBM?=
 =?us-ascii?Q?pfU7S1ND2Rr3tvI4y1ssSL+NTTyQbugyyexzcbQ0jDLBBn/pZxhqcXcf9/co?=
 =?us-ascii?Q?Da7tJehI3HzuHQnr93eAzp7/UYNvQ01WvwesCayoT4hfaGfKYA1qloU5OoU1?=
 =?us-ascii?Q?UTX/sRgdr33vBDk5vKvKhUZGhm/ilgYvni5+kHDNUT8u9wPohty/C/yzZHBY?=
 =?us-ascii?Q?tqEUY+j36zFtINjykQ7YBUlPUH8QbjjWXLIr0LQzRKVhAkmeNACvMI1YvPhM?=
 =?us-ascii?Q?V+jjleD6Z8YfefewxgHno0pi/u++9SMgxnu/iCI/58wYcw27RkX00rZZjMhL?=
 =?us-ascii?Q?iG7JdQn0r5PLhKONGjHP/VtX3nNxuPQK63C18fFJIeZeS2YVa+4zhrNluWoe?=
 =?us-ascii?Q?6gse3pHmStP5NLIsH8EbhV8jCFNkEb/I/Tv8HAWzB9ViycVpuKvmCReWabgN?=
 =?us-ascii?Q?Y+wQcuxLWUBmAjOasZQR2ZMj1ad2rDQTwLjn0pVbYwvasAY30AuC27afmRyI?=
 =?us-ascii?Q?1r3mje5ilqSCzl+GEPAqJDNK7zD0x0j4y0CZJK2F5ANcAY0P1p0sY28iLc9L?=
 =?us-ascii?Q?4SClwrZLJsKpsTTe473Y4QqsUc6Revh2lAN1ZCAZPdCrs+Wp56yXrCljwO0Z?=
 =?us-ascii?Q?b4QFNxaxwyNBMSjRDBB0qyQ/uuEmWqyQAsv1ng21AWwqrmat5JYAMEXFXeGc?=
 =?us-ascii?Q?hOzoSY/293DzEyyieesc+ygDlc7RKrQWGr9ZCk/SCnKP5/Zas8wNnQdH3zf3?=
 =?us-ascii?Q?/VfWYQ4uBO10tOaaT3CUazzkc6kUhZmosrUfLg517eGMvyqXpuCEM+T7Keg9?=
 =?us-ascii?Q?XZKOA7UrvcIWpsKw5fpIRQy7U4R8guy1QcmDSK2bpX4c/QWBudk7BPKuZCX0?=
 =?us-ascii?Q?qiDpk0kT0Lr9iwj0bTo+tXxmfE6yTfc4RpBXiPYNEOeh6PZFBdxy0AjTmX4N?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pZ5fMkEsNqUevltpqgKRXNoJTHLdfxdnhvFcKKUdr3l3YIcgjMUgVNTY0Dkpg6cSzVi30+GXjeJnD371QQrhS0/CNZB+23yM9n8yi/TxD+ofk3/SKg96mCyekr9x/MB5C9+J5G6OfZei/f+dap3WKumxHto+bIIY+hSDqzM/miZCtNfQpNeW40ydfLrfXmR0+R34yZqRV7JRjrqK6AollEAjdrFXbVTexr/CO+agoShV2b+n+ywctYkGuuthvYXEmUdM6GycBw0m6sT4M0mQIN+h8spF4AK3bXL7xPC3JmI1xJJO14/RvgG2vxkb1FQvh2bLMIH8b6gxN7Pssaj1RL8bSt3WpgkdaXSRQpvR9OFtIRNMHj0KPbTsYPmt4bNXOLSs3WTCOgJVs8lUfum6yN2+REYhZ8rXbucWsL35NaSklPHbinMVkAJbjCwy9zkJHRNQMHL2S2+k1gLls5tZx2r9j/FU1x76wzanl2vsjlm8/cX3yYVKDes3YTGNrMbNKNs59AFgnC0H4vy9fPvx6vCWybP3aGUJwq4k8px7BUBYGFgtqIdme3vHoHg+E3ItbIhHzntwtJpak0JA4g8YLB8KduOKRJhVk9FKEkHe6l4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35873058-85b6-49b1-6e09-08dd504cd751
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 18:48:31.8105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 06QNvdt8Qp0aTpehRdeTFG6O8JcpNR9rNJ9wngxxRrKHHfpDRA+2TiAfidBQaKh2MRXto2FCwBgWoW1MPgv8jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6508
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_09,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502180131
X-Proofpoint-GUID: 9lAdxvWyaZuzrxlKx-59QrQFovm92v8E
X-Proofpoint-ORIG-GUID: 9lAdxvWyaZuzrxlKx-59QrQFovm92v8E

When manager thread detects new array, it will invoke manage_new().
For imsm array, it will further invoke imsm_open_new(). Since
commit bbab0940fa75("imsm: write bad block log on metadata sync"),
it preallocates bad block log when opening the array, that requires
increasing the mpb buffer size.
For that, imsm_open_new() invokes function imsm_update_metadata_locally(),
which first uses imsm_prepare_update() to allocate a larger mpb buffer
and store it at "mpb->next_buf", and then invoke imsm_process_update()
to copy the content from current mpb buffer "mpb->buf" to "mpb->next_buf",
and then free the current mpb buffer and set the new buffer as current.

There is a small race window, when monitor thread is syncing metadata,
it gets current buffer pointer in imsm_sync_metadata()->write_super_imsm(),
but before flushing the buffer to disk, manager thread does above switching
buffer which frees current buffer, then monitor thread will run into
use-after-free issue and could cause on-disk metadata corruption.
If system keeps running, further metadata update could fix the corruption,
because after switching buffer, the new buffer will contain good metadata,
but if panic/power cycle happens while disk metadata is corrupted,
the system will run into bootup failure if array is used as root,
otherwise the array can not be assembled after boot if not used as root.

This issue will not happen for imsm array with only one member array,
because the memory array has not be opened yet, monitor thread will not
do any metadata updates.
This can happen for imsm array with at lease two member array, in the
following two scenarios:
1. Restarting mdmon process with at least two member array
This will happen during system boot up or user restart mdmon after mdadm
upgrade
2. Adding new member array to exist imsm array with at least one member
array.

To fix this, delay the switching buffer operation to monitor thread.

Fixes: bbab0940fa75("imsm: write bad block log on metadata sync")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
v2 <- v1:
 - address code style in manage_new()
 - make lines of git log not over 75 characters

 managemon.c   | 10 ++++++++--
 super-intel.c | 14 +++++++++++---
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/managemon.c b/managemon.c
index d79813282457..74b64bfc9613 100644
--- a/managemon.c
+++ b/managemon.c
@@ -721,11 +721,12 @@ static void manage_new(struct mdstat_ent *mdstat,
 	 * the monitor.
 	 */
 
+	struct metadata_update *update = NULL;
 	struct active_array *new = NULL;
 	struct mdinfo *mdi = NULL, *di;
-	int i, inst;
-	int failed = 0;
 	char buf[SYSFS_MAX_BUF_SIZE];
+	int failed = 0;
+	int i, inst;
 
 	/* check if array is ready to be monitored */
 	if (!mdstat->active || !mdstat->level)
@@ -824,9 +825,14 @@ static void manage_new(struct mdstat_ent *mdstat,
 	/* if everything checks out tell the metadata handler we want to
 	 * manage this instance
 	 */
+	container->update_tail = &update;
 	if (!aa_ready(new) || container->ss->open_new(container, new, inst) < 0) {
+		container->update_tail = NULL;
 		goto error;
 	} else {
+		if (update)
+			queue_metadata_update(update);
+		container->update_tail = NULL;
 		replace_array(container, victim, new);
 		if (failed) {
 			new->check_degraded = 1;
diff --git a/super-intel.c b/super-intel.c
index cab841980830..4988eef191da 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8467,12 +8467,15 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev,
 	return failed;
 }
 
+static int imsm_prepare_update(struct supertype *st,
+			       struct metadata_update *update);
 static int imsm_open_new(struct supertype *c, struct active_array *a,
 			 int inst)
 {
 	struct intel_super *super = c->sb;
 	struct imsm_super *mpb = super->anchor;
-	struct imsm_update_prealloc_bb_mem u;
+	struct imsm_update_prealloc_bb_mem *u;
+	struct metadata_update mu;
 
 	if (inst >= mpb->num_raid_devs) {
 		pr_err("subarry index %d, out of range\n", inst);
@@ -8482,8 +8485,13 @@ static int imsm_open_new(struct supertype *c, struct active_array *a,
 	dprintf("imsm: open_new %d\n", inst);
 	a->info.container_member = inst;
 
-	u.type = update_prealloc_badblocks_mem;
-	imsm_update_metadata_locally(c, &u, sizeof(u));
+	u = xmalloc(sizeof(*u));
+	u->type = update_prealloc_badblocks_mem;
+	mu.len = sizeof(*u);
+	mu.buf = (char *)u;
+	imsm_prepare_update(c, &mu);
+	if (c->update_tail)
+		append_metadata_update(c, u, sizeof(*u));
 
 	return 0;
 }
-- 
2.39.5 (Apple Git-154)

