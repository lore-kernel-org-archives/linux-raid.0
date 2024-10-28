Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5392215E5B8;
	Mon, 28 Oct 2024 15:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730129285; cv=fail; b=XjARmuRp95XcSnkdUQg68VU22OtY6cOVtl7S+Opgxhg08A2PXSbPDa1Ekn7tyoaVdU8XYVefqhxQsO90AOwP/EbMVfAdeSgmRQlXiyyOU5SS1QSSnlb07GNfPmQcIGYqriOpIyxKZpTmAgtCELPYgUyiIs8SY8R1cFUdI5PGSAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730129285; c=relaxed/simple;
	bh=WOytXhGw2l8zmHcugBBzMEkDHojRhg4cYilZsy1hGVA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A1z1VUTjPhSybmDeg9cZwGLWnRbTerlqiV1NAjRtR7IJIM30ouqmNR+FC2bYv1IcIObRQ5P3TvooQtFyC44dkowgLhe5HMpYo0uUNfQSIV+Z0IXz3DDQ2Y5K8lr5q0GK0m/L+ZVxLbrbVc2KdSMHXuM2chZ4Hp2bKNcnV8h84mg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C6cjIEIs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Qm6GYEOL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C6cjIEIs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Qm6GYEOL"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEtaJN007132;
	Mon, 28 Oct 2024 15:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=cAJEcTdLmcQaI2cuNpR/9hiKCLKV1sOWvUvBSVSEV6E=; b=
	C6cjIEIsJz762/tKRDdTFPNZDiLDHAvgV/Ziox1s6dETtzeirCzR53Zta4M3yaKy
	hHFmWz8x53dOwcksOARn/5Yx4wp82SxmK4ulvJrO+1V3jzeWtkrgQ0/rSz0fbsds
	03WovXCGcA6BZ/UmHVFuVAlsl1PVGlYstrKZeL/vQPJG7kz79TGqWMzOY46JDs+p
	Qi+i4K4VyylMSj2aedJ5BKA4CeHfH2Di8wDge4Cvsxl1nnJXUoz14OFxZNkjPrkC
	lL6KibdMU6mR/vpMcUhKIzc6+Quva+j5ANEExEiz+HPLbJpXbgqp1h53fwsh+Wrb
	9rFRNiSrWRpkCHpG+8HnTg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgmb730-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49SF0FsI040424;
	Mon, 28 Oct 2024 15:27:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hnamj91q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cdzYs4nILQoyE9GDxu+L/aUHboMGiYu8LMU/zPSG7JYb/dMw380AoJzHcP0c2MCoAVglcAh/gpkqG9BKtgZGIDgF8JNXzYCFZuIyyJeMalqUvu544+C2FJt0PzJUqpgq4ogsaEUQmtDszWPDyPsW7J0VA2hoNI/2dawkkV91VjRWXnHtgbVsez7VJaRtxzCzVWvABn6SZEckty1UMpl3rKsVhyEzm+ZWBIrmRyApdp1B/2PuH8AP936TIt3eDeWl8LfCL9SSXW+wc6RmPhD+krdUVrg7Go79KOu7GbfeI6uCb7RVlbJBcF6YNyuUbCd0SBVu0ZLOeO+yp5iO76QQuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAJEcTdLmcQaI2cuNpR/9hiKCLKV1sOWvUvBSVSEV6E=;
 b=MQ4HfmptVUgdLxBGWeYB7FIZCmH6TlRkK8pDgSih6V6/XX/nkoZGMzDyzWNjEVnM50KuJ8OSOkDh86sNixODNbPJ21cLaRKBG3hhrwB6hKVARFL6NtFfZYpQ4wE5Nm9L6wxdFFXxOxEqrz+pD+twvreBepH5PSSbghIKDCM8Mc+oBuSrE7X/HMaw3C9oFTfUpgqvcQ6IlIwmEPiet47HtRZDIlrVqprBRcHgidKXhd1HmC619U/VL3R3JIdeHRtI9TcFlug9bm63vK/k3qazfsZOOPcTbfdmn2fl/TOUny3khhMY2PhfX/uKrE4elFghmMm6P8xnkcqWo7xdlfthUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAJEcTdLmcQaI2cuNpR/9hiKCLKV1sOWvUvBSVSEV6E=;
 b=Qm6GYEOLQYUmWDxXkIxUEo5jRRdOk+w5exKjtudMJfgu9K7qIPXirJDU8ctknSG5WnMUe3eQrOsNb1Y8+D4Mjz/Mpiw4QOm6qJL4LwkT/k3bZZnemB/cT4Nqdm+fA1e0vZ4yRPkRZkoYJtqueDlANXjJvx3Hc6xstzUUuV5n7A4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4170.namprd10.prod.outlook.com (2603:10b6:5:213::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Mon, 28 Oct
 2024 15:27:47 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Mon, 28 Oct 2024
 15:27:47 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 2/7] block: Rework bio_split() return value
Date: Mon, 28 Oct 2024 15:27:25 +0000
Message-Id: <20241028152730.3377030-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241028152730.3377030-1-john.g.garry@oracle.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:40::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: c38979e1-eee2-4110-38a8-08dcf765135c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z/RtGmrplEDTR/ZELPdBhEAOivbQKTuPKXCzzlMwauZUFQQbOXY7m+PbsN97?=
 =?us-ascii?Q?z29Ie9ZpODGDjjH5vx046aQ3PG9qrwDHyL5PfAbt+LhLirZAjIt8OHHkvLKW?=
 =?us-ascii?Q?9GDo1DN3IAmWjc+xBujHlQuj8gD2ECcTq6/azpuyPzFjY0jZaBQDNdKLpglk?=
 =?us-ascii?Q?NMIjkeU7DMj346GxEVp4CRb7Uuz98i7OsX/X6QkLbSOxbnLcd+v8uD6+80ea?=
 =?us-ascii?Q?1La97+arWBN7dxtwO0THqX95jPAmHXyQtjybZl9wsla/gga9VSvABBdlP+Lf?=
 =?us-ascii?Q?qy3IXchvZPVMWiW8sqCfseH07sGAvt85i8f+LQfzzkeGwJqk0OZrse9iIwNg?=
 =?us-ascii?Q?q2CSMXLX0skBnMBf+nN2S9aA01RJiBGaVw+ImeDbsz4Z4X39OqSE9G9sR5Yw?=
 =?us-ascii?Q?ocT8nrNFeeYFxKU0uoTzrxNogUnqT2eIi5feG5CzHwlo401G+H6glWsmAIjy?=
 =?us-ascii?Q?2ezTUtJRbgWGxRS3xwlC4HFKsq8csq8Hlboil65vKbjrOpQYY9jNEOmA2dWh?=
 =?us-ascii?Q?NN21FKWsI6q9InTqsK+4LtJhtNtYc2hI4KbAQfYThYoGs9izd/lck/TlF35n?=
 =?us-ascii?Q?F7ItcHY2gmj3FFglxgGxozfiFwdA4fl7P2VfuNUcZFkhDRcmm0aeg/lWsGrf?=
 =?us-ascii?Q?U+ICCU3zolSPAZySakoTAdvL9z44HLxBYhu6HoWA7nt09CTtCdBfniEvZJfH?=
 =?us-ascii?Q?5wg8o/i/94jzxwRBxQ6U/sYsAuPdFpHSsXHwoMMCjDt0e+8KH9itETzD2pPZ?=
 =?us-ascii?Q?LbWIszjoZK9Qz4b0oVS4rc5/tE2WAURYhIK8Iov+Q581QOV135THnjqzZYFQ?=
 =?us-ascii?Q?uKZawJ36nHx+ljQon9wRpAD44mccO2sk+UAbv2wmqXW38ao415sZ4GvMrf1F?=
 =?us-ascii?Q?XZZH9EjSGC5N6t9PLUuJI/UEAha6r11R+r4QMWeq96uQI5KxlpOkr+rCEPJW?=
 =?us-ascii?Q?KvyxWWM0PALpCPUbIDugEzs3xoWwirZAAbqAAkb8GUJqGh5i/RItSkEOYFex?=
 =?us-ascii?Q?vUT3Icb/6jPmNIgWcZ0pRKTD8Ekj1PbqK4xqzdLftO6OP8XcNOEQJLLZ7VYn?=
 =?us-ascii?Q?AQL8kT5vv+g8oxFUigW780zWqbn6qAjQOosk+LGZJNubDzQHInwpLHxJv+/d?=
 =?us-ascii?Q?M7GeJwsWJRzaAMVsO/3DrKf8TjRtCG41TrlQeG6OlvDoj0sZ2f1Hx11uhAbw?=
 =?us-ascii?Q?IYSAZBkL/E5FzvGg0ldYEFl7svhDQH/mH7EqSdFfQNLPPZ8Si9xwHAJIyf+A?=
 =?us-ascii?Q?8rzj0ImsQXwY7LJ7qMf7YOMmIuhGp3pUuVWVgTcNJuotpQV2tsEe7YaD1Ujv?=
 =?us-ascii?Q?VdRAtpegz6q8aN73S2+5HFsl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5u+q2AIuBF+x5E8KvQ35dRdgs8uHpgGdBmpqnYQaBSIjM1go4u5WA0y3fXXM?=
 =?us-ascii?Q?n3NbYj9Yyx8YAZbbH2zJW0GR68d5EMH0vAcoONycycAzQ3Xe3vbDqooDsU/T?=
 =?us-ascii?Q?pqmq+Aj5TTwXaC38bhkvm3cO+5ibtTwssFezaOsyeUuSVFAIAaN5ZpDpwmHT?=
 =?us-ascii?Q?/zUL7J1mxeOGEHl3dkNM/AZ4DNEagWu3hvFi+2rlPj/NFDUyC5dkWUgv+wAw?=
 =?us-ascii?Q?7RN2Zt1JpY2Cqq+iehibTFP5jLWz+QMJL6p3etAJGhoVWw4L/sSHGtpoEIAJ?=
 =?us-ascii?Q?TLJ7olW7XpoemItjwnhEeafJDpoMIcVuAI6de7YJYYyFtQF/10z4vvKYE0hc?=
 =?us-ascii?Q?aGYPIUpODEjE726OYkrYyqq0aI6jPHK7AUjOeehzZH1dDA9xUY/8gG8auqt+?=
 =?us-ascii?Q?5XE9NYrWGpvqSmTkjMLRjF+bd4y/zBpCHOLNzQ+CiCJGjIno4zWhvwBJ3Zcg?=
 =?us-ascii?Q?jsS1YWScM6Kn6B68ZUr4aE92J68OgCCnnzZ1d+sdOEOigdGlu2wDUNdl60wa?=
 =?us-ascii?Q?Cn2H+XQvtnpTS2l8HFfnqXfVqCAKZD1jjRxZUgqSdvmXuapn4ZnYg6Jh86go?=
 =?us-ascii?Q?jU8N6sZ5F4QcqHvL00hzt29msCKqVdMm94nts4dsdfjKOOTcLMNb3tCOt0FE?=
 =?us-ascii?Q?UAjy3q4fIRM0EZvj7WX48MwiA1d+RWSKWyuQ9uN2fzh5DMm0KSaEMImq+cUH?=
 =?us-ascii?Q?QhRSxXHEUDMfkvp1eJivi4Xb1UCz9sj8o73A0UU/dl0RhgZx7sOxF6vFLgrK?=
 =?us-ascii?Q?1vjTua3CUupTDFYMxv+8mHiuZ9etunD62y8vkmm4I4//nP0757IlOnMayPHL?=
 =?us-ascii?Q?nj95taikLi03bhcIxyLXrN+LPXZJJvBsdlB2yN11UgBZI7XdFdgX7GY/6q7a?=
 =?us-ascii?Q?qoUaON4zeJ3nC8nOBE5BCXZ+1UwmyOqkjiKROJjomBEVilUDpnagRomu+6BU?=
 =?us-ascii?Q?Arpx5XQkLTFsRFDdhS4g+VQcVeEl2rWSbEasIUZ5dDR+ICFQLrZbPkuCHboW?=
 =?us-ascii?Q?Ytvl4ZzQRZYANogSbpAXJFsrRPuPO9oBw5qEBalv82H4C0O5WQSlE49cwk6+?=
 =?us-ascii?Q?ji3zXerFDL95e6qcGV0clXWT/ee6RR4v2SGN3xXhGnZefSsR+/omeA+04xRX?=
 =?us-ascii?Q?rb4SuykjRpRiHShkM3bCLNiMf2jKrDaLe0QzQYiUJqyR24+PdbqpoCTsC2Fh?=
 =?us-ascii?Q?TZ/XM4ou3DQCxB2lpc8qnpPM2sZ43tedyvB0BXNyhdbBP7ubT7fS91nRw97z?=
 =?us-ascii?Q?kqqhBLeRkJOmAape/6jbLxoB1ko+Yj+XJkjWuZrHBqKx7JjjdYkOtRvyVKJU?=
 =?us-ascii?Q?R1/jK28mUakSdOtDbV79UwDJ7a/9Pa+rKPCdOgMIvmXhQs3f3ZTVY/FLu1ib?=
 =?us-ascii?Q?hj8d/w6cir+qZc7Y9GN4A7F4uVY8EfJxw+vRCYaJhuO1sV33XnX7ueFQbtaK?=
 =?us-ascii?Q?m5OJ841jcXCkYopgeaE5rHrbowSQi1fnPXj3SC/yxNmESrJLZqG6PGhMnslf?=
 =?us-ascii?Q?6CV3MMAa275cSgdOLOI/8GULPrD3Y48Tjm22JU/rivMMyBqAihtFNmN34G0M?=
 =?us-ascii?Q?sB1s8ZKc8H+5jBCfZptzYc98JNiHSRRs6rBs+aJ40rsZteQRnKw99Gy7F8U5?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4F2t0MdWTQXxQegc083ljCSazqkt+oequpZ92DJQ2LyxjF4iNNc8kLvmVrlHl+x+3x0V1Czd2L3VMel6QPCuHw2TW/gD0m71J7YsEEJjp0KSxzqNCUIxA3Yv9pipjZkT2Ib1p0T3PbuPTdE2eObtrr/HkW2sQQAJeLNtDXyLtBD5LzqYrX2u9B40vhRXbU6cbM/WAoZIyWDgPR3fWzHdOEuvtd4yxK6QV19DHOJuoXaq9479dyjBPOVRvr7JguKZ240C51UUgpXnu2w15pDpk9rlf5L6BCsxe9ZcA4YYtdCJfBKS3BKbBanlipze6RcqkHAJNt3b6k8yMfd4pPZNxcBP6NDGnDm8xMSXHjS59t+2/Ugap1JR+kRGOVqOscms39vZU5omodwB//jwo2rwOR8De9IhFX6Gtrj9osE2pPTChN8gAwigQS/CMG8JPTGSYHoxtL5NY8eb96jZ+X3Uh7Z/OsbahePWBfwPpWUE4uH8wVEUbaoYPtLbsGHg3yAS02xaxBcOEY8UAu9odZ/JEOKLruuRmXlpgaIp8TtBqbtR8asra10xPFzpdVk2AFgCB8yTqc3g83H6gWPF2DipCA20fReDWlpZ/O10Vy8qyuc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38979e1-eee2-4110-38a8-08dcf765135c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 15:27:46.9838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rc7qxweWkgJnL64I1aP5GVGtlk0buuNMpLobUJppNdOMVc8N9e8aKszfkKfzdAOtjoqFXAOJFru1OAv9W36dJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4170
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-28_04,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410280123
X-Proofpoint-GUID: HehrSHNuv8mG4JQ9gaTY45Ii5e5uJtly
X-Proofpoint-ORIG-GUID: HehrSHNuv8mG4JQ9gaTY45Ii5e5uJtly

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

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bio.c                 | 10 ++++++----
 block/blk-crypto-fallback.c |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4cc33ee68640..42cac7c46e55 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1740,16 +1740,18 @@ struct bio *bio_split(struct bio *bio, int sectors,
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

