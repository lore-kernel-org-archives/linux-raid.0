Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E73F522A;
	Thu, 31 Jul 2025 05:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753938100; cv=fail; b=Beld0dIzRM8u2+spAo9XIjdg2F49A+hV6nNui/RE+OIng5TmNgjU3ijGW1Kw8V2uvzDNxtFVGOnvQ5dc57OA290FigYciWTRw5dvH/9tJkFpITMUmS1wmsrZ5OSXvXlH6JbSnAqRmtrdVydp1qnsH/lsI+0r1izD9F8DvYlDpxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753938100; c=relaxed/simple;
	bh=koVPKjiERuUxpn5U1aGp0kgi8VLPjRaAzU/Zbpc1f/0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=KV7p3BluDfX1o+NzXt3FrUDBQrGIKzMCur/H5VXkOjG909Ly4vsSWKr6kN3jxXZhYDM5WcA14CZAy9Ny3r0gkSXEowKHOE2xKy1qcTodpLu16E/qiHktY2bZ9LQ3X/l5kIdn3mwt1vhL5NPolHAkmxVG/8gXHiZfCji5QLRHFyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nEPu/TKO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DAVoxslM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nEPu/TKO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DAVoxslM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2gV2Z002663;
	Thu, 31 Jul 2025 05:01:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TYqnnL/S0DuJ5bbzQX
	/I7hpegOtpOUEc7+czbB6DX0M=; b=nEPu/TKO2X2Bs3wigQXS3aAjOBTPL1qMl/
	6Gq+8h8LQtSBGvw8TukJG/JsXGAvhmjQKrXDknK89cT45TBCAJtSPZyWh4TG3Oix
	uC4nmnv9YP178MpBkofY5eUtrR8128sdEJZqyh0oOt4kZInFSqGUQdYPW7t4WtHB
	QkMSFG/znfssgO6sP4x33JWHQaH/8ED05ndWVZch9vXRdDjpN2V6/XgBlpQbdeWq
	rECWJdO3CuJmSl8tJPlYdZxKErVuY6ouVpocnrqC4CE+11HcrmqwJXbpxvYB9o41
	FiCgfWjhU0SEnxDD0U1iSfWcpZ62uYiXvmRCnBab2BQ4BZnIfApw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q2e3hu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 05:01:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V4ftLL020947;
	Thu, 31 Jul 2025 05:01:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjb8eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 05:01:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BBD03nzh+35GmWNrN+eXgZGoYFLihFjzGiuQjSazP94S/ftal0pblvgzb7WBugUHzDBfjqA75LVcj49q9Q1FrXxI6ApP3s9t2jLf0/WKn78bTplBOtK6drfolWim1jeBmdnnr0ZVrNatKi/QNeH8B7ajS6VFBypReWzTM95FABNikAN6palzcyNrrAt66zCMG9J/WakYVxFXzdMx7p5gPSnkKBP5X+UlzuYo8ydnV1ijrl19uVocp+RBIoDIVpNr3F6ahmKmvuyPRy4Yuvl3O0DGNQhcZdGOYsRo3uFjXVguUCy9sIyztHQmTSHZDHrl0iR7H9sqm+mozK80ImWO7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TYqnnL/S0DuJ5bbzQX/I7hpegOtpOUEc7+czbB6DX0M=;
 b=QQAPqiRH2ROYNkIXNHVhs3WKlTQVe61ku7CvjL1Kbf9TScWcPJK3DtKbf8nVEgTZMKQKE6hcm9Z7CawvgFPFTkljpp2eKt+E8jLUTo37q1dsfJN2t0JYX89rLlZYNMF7+DYqgyRHexVHx6zK/V0PqAx5XL4g7ZN4ZtsE+GCT5Dui/fOjW6FTSQ60UmUfwCZHrvYoIJ2AJ8u1pcVNvnDPCdgBREKhTI9D21P5CkT5xFLdUxPYSt98IMxCNlzK5mJtR7gpJWITNdpuQzTe4frk2b6Li7j5oudoPJf6IgH6v6f2Y4DvwS5Pcu7TAQ7NMkT0ThnVOUYxHdNIKUMmrgL5cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYqnnL/S0DuJ5bbzQX/I7hpegOtpOUEc7+czbB6DX0M=;
 b=DAVoxslMFjka9IEaivjvMTeGm/hLSqMuh827pGsUc3n5+m9LprX5GSHJepmE0J3xjtly+fMX9bn+I+zgN2UY7eBqReUyS/KiCLw6vbBF0NWn6MbDU4G5yV9bRDz8XfpsECvKalSEZAFQwDOISlrh0/x/ZDveMuARpJy0TdvE3Rg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH8PR10MB6623.namprd10.prod.outlook.com (2603:10b6:510:221::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Thu, 31 Jul
 2025 05:01:08 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 05:01:07 +0000
To: linan666@huaweicloud.com
Cc: <song@kernel.org>, <yukuai3@huawei.com>, <martin.petersen@oracle.com>,
        <hare@suse.de>, <axboe@kernel.dk>, <linux-raid@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bvanassche@acm.org>,
        <hch@infradead.org>, <filipe.c.maia@gmail.com>, <yangerkun@huawei.com>,
        <yi.zhang@huawei.com>
Subject: Re: [PATCH v2 3/3] md: Fix the return value of mddev_stack_new_rdev
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250719083119.1068811-4-linan666@huaweicloud.com> (linan's
	message of "Sat, 19 Jul 2025 16:31:19 +0800")
Organization: Oracle Corporation
Message-ID: <yq1bjp1ge13.fsf@ca-mkp.ca.oracle.com>
References: <20250719083119.1068811-1-linan666@huaweicloud.com>
	<20250719083119.1068811-4-linan666@huaweicloud.com>
Date: Thu, 31 Jul 2025 01:01:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH8PR10MB6623:EE_
X-MS-Office365-Filtering-Correlation-Id: ed9995dd-4b4a-41b1-2e79-08ddcfef4288
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tu8cDLPGSlULbpyIHfWI/FhtwNYQ0bEBchEOb6AsfGQg9qeOMH71EIRIM1zH?=
 =?us-ascii?Q?jRwy0GrQproJHvhnVKEBz869wzvuHZ+whYD6ZsEH3YHOfZASiGNyV7lwTG8S?=
 =?us-ascii?Q?4noeF3mdAYfyqtqawTs0bdKtBwoRNe+HW8e6rq/0RDE+IG0BGp/QzBcfHb+/?=
 =?us-ascii?Q?trtO1cQsaTHtL3WO3BFNqwGPR+BMhi2zDBv+PLJwPka05uP2VbyxPFNjKSep?=
 =?us-ascii?Q?VOraCdqSxCuHLDrlpRBv5xbAUNJ1iAfAUPxzQewCVIg3rpMJVhFsVI3uBAGy?=
 =?us-ascii?Q?yDttxWL/TLcVeI9thALT4ECkPv+zuGhAPTofB7O4Iy+8lNzyuZLBydTuvnLl?=
 =?us-ascii?Q?fWgUqiSYzpXlmx41MPvWEa+gntdMYiL6rX7wk4NKWDPegLT1Z2ik/M3wGXeN?=
 =?us-ascii?Q?Ysoq3F7qGzAduw2LS2UL+Ccs99/rdW/lvwLOfOE8XJUNgFSCp/pwUQF5qE1f?=
 =?us-ascii?Q?xsF/EMOiedCZwP8t/zGsRnDOQbdORs9xqZc+LI0LI8jKojQDHACvg5BD6/Bl?=
 =?us-ascii?Q?yskuFnxbj53k4p/C0WH+pIgLcSbQCzaAJR4zstnVvoPeUxMcB9JyJ1Ktc0pF?=
 =?us-ascii?Q?v/q4ryc63Gjwn4QrnjVv5n1OmxTbRVzypt81ymHEZcLsFMfH3e5IPpl45nu9?=
 =?us-ascii?Q?uhdUBlJFouotOB7VeWwrDnVTWoMd6wfXFgS+nz4otqhAFyjqaWyxEd89Aq+z?=
 =?us-ascii?Q?l3x9jzxjIhiB4rBoFUnH62L5qUf9Uym2KE0ualuNW0w01Qhzp1TMiNneeOyS?=
 =?us-ascii?Q?aesgC4aKqSVh25pe3/AbpbYS55gsXu2AQQ/p2IRQ4SEQ1aCDDIASAhrQYyWl?=
 =?us-ascii?Q?RbsLAN5r3eWCzJFjcoc9ptM2Y+UXRp+7u7JPs1s7hIvATpkLajYlcMXhbDRL?=
 =?us-ascii?Q?qbZj5SgYa9U9/3tvZ1sDYG14YGPA7xQhy7UrqCVNmW40S7ZETzDI3mRDM6gN?=
 =?us-ascii?Q?67H1jQd2njlRy87qNqY++9iBM3/TAJ8roIhLgue6rjrDnvgyFEdo8KilStm1?=
 =?us-ascii?Q?Fbv1taZWGR6WdysOBpMEMY4R2u7LCjAXkJzUEw737FsGeuoDd9+vDt4Er+bc?=
 =?us-ascii?Q?ylMBR7m7PYUpYB1SiyJoFc6WxCmerO0siw6077Kp6G0d0nZ0dz5uBf7/I1/c?=
 =?us-ascii?Q?wIsgwnn+LXWEQlleLj8JnWMIS3ZvkxitEEgI5l29KX2OPAQY3tvdG7ZY0I6U?=
 =?us-ascii?Q?V/otcXv9oTF+WS8B3zQMifBqdAua1lIg1L0/wWOalcOm+VzDCVqY/bNZetA8?=
 =?us-ascii?Q?+kHqeSdT6GZL7eRE17w3PUWvSSnYjuYXm3L+wR22bcKmI4GxCe++7C4T6WfR?=
 =?us-ascii?Q?stgpOWZZPLvH4Mcj35kGUo2DiyssRFtKtFnzFNB8IDrLRmegilO/c9PqzJ6A?=
 =?us-ascii?Q?bRdcGJlajl4lGTQdGIQRGDZ3L24w5VsRFjZjHQQ26tYKkLFS8tpPEmgBC7y6?=
 =?us-ascii?Q?pBOsFPM3lQM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xkYKp5YBZb7/r8beDAY865T4lgYIlYNnvEEG59c1xsSyg0ZGQJ5WdnOY0keX?=
 =?us-ascii?Q?tg89LJBGqGB29PogW9+n4wjLsa9Pmh0SzNk6RCxRXPfKYmhAVO1glL9NU+Ka?=
 =?us-ascii?Q?c3zHRigx3w1eTrB69YzlHGFJJgqiApjLotx96ZZiEmpQXS3plda/wlBeIFa4?=
 =?us-ascii?Q?7KqRSbBZVHJDMGSRULLsorm3qCq/j5geYL44OCb3qYdKRWnN5Mt8Bse6XTez?=
 =?us-ascii?Q?V6gVDxv98jwJ0OdBs6O8WLbSpAwZ8OreP9QQJWHKqRaOY/BACSs9H64JHtkI?=
 =?us-ascii?Q?fM0RzlRbysD3bPam3O5pgP5h6J1xZI1tf8zwNRxlQ1ocUHH0TvyjqAkMWcoK?=
 =?us-ascii?Q?VnOfjpCXPvDtGeF4Gtit42a2IJMErwe/1rs6Q3G0ttWeccXgsxaNknHMXjqT?=
 =?us-ascii?Q?z6pWGvPVNjK3azjvaNnyi8AJGYr2lDVbKLwP28idWIrQySuHyy+n0rNxjL4V?=
 =?us-ascii?Q?phj1KswJgP868NLX58zyKQXit3i2MDNbmCcFqKLz9fH1gGT3bEa9lrUJzXex?=
 =?us-ascii?Q?A/YIyCwDS2ZG1qbWr45Yx7nx8ozDaRY7yaBLRqX5iqVg51/aBacslan9mRUc?=
 =?us-ascii?Q?+25c7Sgfsq7wA9d3hivy6odDLAHS1Xgp3wwW1DyotsEum7sg0cziVnQxRfwb?=
 =?us-ascii?Q?1TRrs2uKTW+/fPCjx9BHyczfN1hqaZiajnuo1jTIo5IQ+z5YuWpc3AvRQXS4?=
 =?us-ascii?Q?XFUB6O79BE4ag2S1WirwKS0U717S/74yRMZZJ0GjyJoZobUL+eVroRbBDhzj?=
 =?us-ascii?Q?Fknvo1ACpDbmHbEBd2TrLlB0SYZUG8E84F7EtsJvI7oBpaQsEgudik7kx1Qr?=
 =?us-ascii?Q?8L0MAJJV4cgNoKRcOMRFqmNzc+FRmzDV+9wCr2XRHoPxs0OsmBvSLMF7XVFq?=
 =?us-ascii?Q?CwqPqk1XRgAWPb2ZFmUeAkuA5eOE1bA4qf04HWzaO0Wnr41yAdf6594XUwHH?=
 =?us-ascii?Q?OW2EgwjzYau1gZmP3aRDVC2B1EQL90273Hz+8lOM3JccNjr0u51dIk/C4Y6l?=
 =?us-ascii?Q?fxb0a+dyUiC5Adr5CSaSI+Iln2f+ZRheNt1i/Gd+PE6Bow+Wg6vtN6ZNr2QJ?=
 =?us-ascii?Q?u2N+pUbvuyDHSow1Nh9zwYUSoRngn6FDWUIITusbD4vLIUKlKcCdtqOl/aRI?=
 =?us-ascii?Q?5W6c0fZe5qJQ8s9EaxB8dwSB7Kb9x5gkofT/NeGTRTcNn0sGibS81wLbwk9X?=
 =?us-ascii?Q?AXyAcpzFznQWDU85ta51a3dsnjzVRCnc5DCf6XzRCsoh/MhpWf/Z4ptRykz2?=
 =?us-ascii?Q?QV5ceMI/xCJmPSbGaJFhEdsVYhVTByxD3z3JZ3w1fCFT1HxraX3dTAK74DXP?=
 =?us-ascii?Q?4ViWT6f2ArkaCHrhAlOLWW4jG9TpHCwvKIKhKzSibo72gvuJIRx/ykrq35OG?=
 =?us-ascii?Q?iRRvV675ArXkD6u1kV/SOsVFwyBbZuZjuVjlqNdx6F7+eS3Kk3YB64EsKYF8?=
 =?us-ascii?Q?DTKlHW3eD5PaSxC6kPWwMSGRHjD9ABb4XJTvEBg09fG1XQpZIT4awnLiDXHz?=
 =?us-ascii?Q?9rZnDwxxRFaemo6+enN9tGhdp/UWX3n7t5paH5A1MaikL0lqwgPSQnQoIWzH?=
 =?us-ascii?Q?UWWCUPAZHFymkcS5WcLjQv2+0t/BbIJi9HYwuLGWyjLeSBOHg0QpoybdKnBX?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jKs3Vzxow9O5cHKOBn9AmpgU+HkN0npJ9BnGCTA6xaWsS15pP0tUFoSRWAWtlCg/sasXKQAzHPXmr0txAS5DCEbsizdZCz3IUBXMuBWB9VLD26wC6A5GZ3WJbUvMprtXptwmuVCeniiXO89hqsk7Q6UC5bI2ZDrOsCwIPGS9jHtZQXQ8ChtqSmRPz5Y1FWbZ4z+ASfxAxx2WXk+slxp2b/lqrCsHXnLeX2MOz4bnSqrGgUDRt9vyn8IGv9AceidC53JimMgY8SeojMEewSDqJAdsJVtCqpDC1piOWob9yEGcqB/WcJnhCxofGAWbUi3u1/DBuluprrOQDjD0XQS7FMm9847EvcHaqQjtyEOyTWE7wD7TgyE2peTVvueB7xXLlOLL2kMgGba14sbM8PotCYc5KBZf9XrWEwg4sxqxAHpB52deyir907eKYqXoobcoYU2lcbFuEuSooTW+VmiXC3z0FqQWnSOAPntnRcAXkirxptRqlt9BXc8dXD2BD98hSBDgo8yYxJ+n+dI1LdsW2fhraykLU4PpJWPRpw+hveW10NxxVczzk5hsllWmjDArfGRtNFGvm/MAUsMBN6/ezmg49QHUUZkDaZ28+F5TXRY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9995dd-4b4a-41b1-2e79-08ddcfef4288
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 05:01:07.8170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2SwXHJ4Gp/hIHdB+NOgq+sQvvui9eGeJpMkjXKMe/0PjYMiYk9KRZw9/YwIY5HYkLcBqVNgD4n+538CShlCLvaG/yTR69rdDz04U2ZXKRq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6623
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310032
X-Proofpoint-GUID: 5C5cx_Xg2Au5fkM3sKWBcbPjj3Yaw1Xs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAzMyBTYWx0ZWRfX9zPduuuoFr/A
 C1kL9tleMrCJsXuHob0CAEqiC4dCOXInDIMg7T8RUiZ5QiI0u0eOsx0Eha9NvvBRKlJulNIVzo5
 MT4ur5E5sJsB9D5N8tK8pJvsVe27ICLL7Q/SaRNpEK7rC7f/Vxfmcm0zYmN7KEtJ/LdX/0Cqyd9
 ee8pEYB3QuHc33IeDPi6EsdHJAVY+UbuuOmUytc66rrvZh8pkwqo7X3RxZNcfzHt4attbQB2i9v
 zII1Bpo5C8/TJauRijSs5OwBFeHle1NAVBGaMjpG1M4E8KJJXOHzbWePE4gP1xlmGXiXCdscErs
 SBf1KI0oy2G0DkmS9FEy9/YhP4NMIOuYzEIbbsRxr2tTI5D8wdMdcC5AzBPVUPtLcK3ieG1umOA
 Hv110zS0ED2gmIZt20dzl0HROszDgYMcG5gLdc/bPHmeJNKBTrlaW28ha9Xi7nmUww+bDHXa
X-Proofpoint-ORIG-GUID: 5C5cx_Xg2Au5fkM3sKWBcbPjj3Yaw1Xs
X-Authority-Analysis: v=2.4 cv=A+5sP7WG c=1 sm=1 tr=0 ts=688af897 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=wEZtvNZLBWxk4Rl50ngA:9 cc=ntf awl=host:12071


> In mddev_stack_new_rdev(), if the integrity profile check fails, it
> returns -ENXIO, which means "No such device or address". This is
> inaccurate and can mislead users. Change it to return -EINVAL.

> Fixes: c6e56cf6b2e7 ("block: move integrity information into queue_limits")

Returning -ENXIO predates the above commit by many, many years. Changing
the return value might break applications which rely on the original
behavior.

In case of a stacking failure, an appropriate message is logged and the
function returns an errno. How is that misleading?

-- 
Martin K. Petersen
