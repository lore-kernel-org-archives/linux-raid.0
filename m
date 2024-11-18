Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD0417BB32;
	Mon, 18 Nov 2024 10:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731927049; cv=fail; b=esQSZ8AOgzMAPZlK9Sxgh1a8JKUmQHMXQg5tXBuFTEVZrD53t+kdmaiZ1IKMhgd052vwuf+i0FBMpnFsBae+5zNIljPI7B4FUjCwrbRIuOC3Y6dqolNy2r4yeKu0Ad8rJ/iZog69fmcfUjYuASFUg5RmblhB0hC4zRBW7jbZE+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731927049; c=relaxed/simple;
	bh=6lX2erZ2vew7P5ixlBsygICxhF4seH6u5d5DzWd5tc4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Ilkx3zAtrbS4FuQyBMSzpEUBN2UvBKYh2u+lfAMBaNdWcGfunaV8C9AIjQyrxDE0QKrhY9SdjBNkkB9qmxMNMw5YQfySsjXw52XtlDqXDYa6nmPkw+fILMEw3JtmlsOgKl97e91JmunWpvzFrNV//eIr0HesSiSvwL0Ofc7NwtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gi3kmaQK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=K6NxA5VF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gi3kmaQK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="K6NxA5VF"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AI8QWhQ004571;
	Mon, 18 Nov 2024 10:50:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=ZYkLzdbCJJ0rINxD
	RobVTNQol9D9pYaN2eFneNMqf2M=; b=Gi3kmaQKlnDvYV+QE0HA1ZYNSyR4AneP
	VxqeJDlyMA/ok7PFpeL2iGe0PN+ccRnPXqhhwRkwc+d3Eh0ykuRMXho3mu4llbUS
	qVfjas9b5Hq7NmDSYawmJCvH0cLsl4umrJLKILNUse8vDvKF5vq5WHHxhEGgsrSE
	jYyrSNHC3Lik5zS8hSZcJ16cfcfTaQ17OCNlcn8bYjuJbbCAbzmQPLZX8o3BDSio
	rXQ9tXKv/7F4127+ZxgLYc4KaBHapREUWjy6NUihQ6TACHxXRrAxR8u3mNKQFJJE
	tacLQ1BRTpjmwILvyzkSbyYq2RvmjQSXonakmrvi4qO3IU7J+tJNAg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xkebtd1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AIAk1YG039918;
	Mon, 18 Nov 2024 10:50:33 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu6w85f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bSakL1Mm9G4lI5LDDnIouUKmU90Ow+Bqx83ZlNv+2QwLfBrhxwMJiPgm5MNsmJrIs9WDHwKz/Bx16zwO1iep3hwyvYZX5oNcwvN1wBk4TVaPExKpMb1Z6siNpfOv9zvZRWzdZUfH9fI0NUrvu6KvOGqz54oqZuR5RNjVJmGCi9GoW+X/NY/11lBF38CUjZ9aKAdFOXZ0OLa8XtBLrlCH8h2kNH3QlBuYN+vknt9MPLjVh+PMvh7uenFeC01DV8YVEBqjWZl1J3zS8qU47rRnelZvw6JNt1GOk7TlDVZ0g/LbwSqFMaBveYRrs+5YrdIsIUspC1plawc//QVQL8UjiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYkLzdbCJJ0rINxDRobVTNQol9D9pYaN2eFneNMqf2M=;
 b=qs1BdbRbwGmxsrepIBcd2SPtVHtX8sQAZ13/W2EhuXmjhYiXO0y7ddOWhOxQkfdY0YkIrMZnU8xr/+PA+uDEAOrOXOT8wawvpVjKA+gR1AOQ8aCUxDF+yXs7wrdIZiyBP98hQvWe6+I/MGQcaxI0i4yy8XGkc05XG+33Cs6bD7gmKvy1qDZF5kH1MJu927JQgJ1jQk2E44vGAU0KSV3LJwPVXQWUXMzrFafrDGAZK4O6Mgn7Eomz2ZD/hzXxP/UjBeS/YX97GnSxs/LIFSQFGGiWPabqu3EUs/frFprcsu6I+/+inJSP+Bt7MG5i52+J1u0nxhqrpIQkHgZh9+rHwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYkLzdbCJJ0rINxDRobVTNQol9D9pYaN2eFneNMqf2M=;
 b=K6NxA5VF5HpqawD/O2bRW3KPyWBz4ESonZ8iSu6mTmO23WdNlvpRaWUfiEyf9kiBcua5xJlFxRE738Lm30drThRthKgGtquwvDhZ9zg0DX0r66hKA22rsg9pOeM6/7cKh4JJLdFQU31aUSjJrEdRbsPu/t+8Y2Ix+HVB1y+oSF8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6812.namprd10.prod.outlook.com (2603:10b6:610:14b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Mon, 18 Nov
 2024 10:50:30 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8158.019; Mon, 18 Nov 2024
 10:50:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 0/5] RAID 0/1/10 atomic write support
Date: Mon, 18 Nov 2024 10:50:13 +0000
Message-Id: <20241118105018.1870052-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6812:EE_
X-MS-Office365-Filtering-Correlation-Id: 05385098-5eb3-4a2a-ed78-08dd07bed1f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z6gojxjJf+10eZ0ruXOSwSlTrnKUDnf/mnZfXHChPZzEqdBHmvx8Fm1jDtWX?=
 =?us-ascii?Q?Echhu0MtkvemBX/4E60K9Ga/vf7Ce+xSmvf2CY4rZygLwbui7BI//HsggB2S?=
 =?us-ascii?Q?Ol9q/q+3Pq4TPUy9g3RKOWZ7fiW9uHAgksD5mVeGQUyJXkejmBIlBXqQtsea?=
 =?us-ascii?Q?eZKeTjEwYp3QDsgtXoPKn0EWY+ZjPDsAt1Iizmpm4mupAXTKMwqUlu6x2bDs?=
 =?us-ascii?Q?uVTNvMdsS3BGYoPavCsssg8M5UoHS/SN0/FKgMVRreqnse8p24RJe5c9cu88?=
 =?us-ascii?Q?ELQy2DSvRVG/r0SMh+NKOKWjV6xn4Xq7IvQkeKY376yVsajSUhIUIqd0oeBx?=
 =?us-ascii?Q?3RLmOAz2JgDLQv1oPn2yaIXjtdcAQdfoK/b9lykeV1AusdbvJ75xOy0RwV3c?=
 =?us-ascii?Q?ww4WIcxUgMl7YikQDbxtN7DBXFj1b2sepgtCTRXAJVj17eFGRd6kl0FZmNIs?=
 =?us-ascii?Q?JIJv8s2qXx1U9VITG72Nu3v2nWHy1RZH5b2B2lb8/oZqe1BiKPhjehJvpZeJ?=
 =?us-ascii?Q?nD8v70bkoe3Oiixaj4Gpwlh5wuWhfW53KLTyCH228tXyN8XV2RHmEp0be47/?=
 =?us-ascii?Q?09DQw1hMSO54N3KCgc3CLF2D1ysnhiRNhJyopeYjv7HUCNS2ns0d+2UbOYkE?=
 =?us-ascii?Q?ZrbIUriybpihKvk+DYLPht3gaoy9yfs1ZWK+libaAwJZ8MaJxQkkR/2xuVJA?=
 =?us-ascii?Q?tZJsssEEJ/e75NW7rXV1TXhJ6BcOd4xaIwtcFrjH5TdjIWixu580fIOXIDhZ?=
 =?us-ascii?Q?ALG0a6fws2DuMhBYfbTrcuktj8FgldWYrkerqhtRitHko4vMoq1xIxiQUgA0?=
 =?us-ascii?Q?PnV1g+yCetcewnSBvz8YYLS2SPc+uE+aT5VmdjbRQb9+wTuF09wOgzP6d4tS?=
 =?us-ascii?Q?RNh2Smrof0EQui6tW5Gboh+7W+a83OVTGrs2/yBszyNjWnkjEUFu786qw3OY?=
 =?us-ascii?Q?ylt+GHa8gEX/mFTmSFeyRlF9xhjdOt6R59zSuwgnmDQBo86bPiwepjhTLLSg?=
 =?us-ascii?Q?ZR1ZoIx0X3l8GK/xv8WiTRoizagHBXDb4dI+8i+TrrCYBQI0yM/bQv95b3bU?=
 =?us-ascii?Q?Nt+YB4MXEy7DFK1+dR9/30A3Mvq5fL6oi8oO1n0nnFEk3ajNg34awMhWIsUi?=
 =?us-ascii?Q?zzXKlRZyTjRgyGMPjW20au0eTUck+RGe6VsgxZztq+zlbpEM/6KWRy+j5swV?=
 =?us-ascii?Q?c4sSq4AbrdVPpKfc7Qk9pbHJMgPghJcaBv154i+ojkMFchz85pCtpv8kDi+0?=
 =?us-ascii?Q?yieMcyfiPsuwDtgDxM1K8sdP4vp4UpHW0gxQW39AKthjLo7S9EQV81Pr1MdI?=
 =?us-ascii?Q?p7A1Do1/ph8G0fm/mdKUC1H7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PDgpxtjRrFDg6DhzHHdKjRYcjfg3MtuZjaBlPaV5+o2CSTvvHxqFmX9JOD3C?=
 =?us-ascii?Q?ClM2Rw4vRsW9eyKj4HAa56Z+EoF36+947BNZ+peyz/39bsMQc+mIEVThoZ8V?=
 =?us-ascii?Q?VGjkBPYf3owQwDdo64VJ6GZU4vy5G8Zvfwv7vllLYkw2eA+Qya7+U33Xnupp?=
 =?us-ascii?Q?ASGhMp+xK3SVf+UWiD/bWzOThp2MGnTMKaun9XXRlL1FCKa9cetNpyectU7Z?=
 =?us-ascii?Q?0JoQgC7segAR1TiApcuafbppcvo7cq4MIHCHCxPL7XHSQBep8Su78189r0cS?=
 =?us-ascii?Q?vzS6pKUOxkRnkwfs9NwPh8OHXPzFHvfidlgcmLm9NpgBDyLOuNVo1uq3enUW?=
 =?us-ascii?Q?FYSx1w2XPogZPinmGr1cTAvxdpnPWx+Ca+MqfVPoLaypO4f697b9Zm461lCc?=
 =?us-ascii?Q?jXW0nhQL30AePo/aGOEwMmKEkeDLS8GoFwjDtlFQCWOJ+bSJ4aTQjo8tPXVr?=
 =?us-ascii?Q?IMKJz8+peHIP1N2Dj3GoXO7u5ZrNfp3mE3YfvVMN5X4+6sA2xn62vZLZMOPP?=
 =?us-ascii?Q?2Bzi+XncB2ICqR3uzgxPK5McB3bCDm/56g8uzhL73eKsYdP9AGbFRCiWRf/K?=
 =?us-ascii?Q?zsGhaIVMCzetjAqpayyAHvoDgUwu5rl6s5lsOQ3z1URgL2rIlCR8avySetwa?=
 =?us-ascii?Q?1hQC3mUFUrkkqx4tKWX0ndt/sSSJ5Oc+RfUlFwy+8nPleQzD7KwZyLbd/eNI?=
 =?us-ascii?Q?GLNXtPAf1dEwwMUMbYzRH5hHVVswau5xCYkItmm+s9o9dEKhVTulV8BkST2K?=
 =?us-ascii?Q?DEWL4htEEsbqwxBsrRVT4Qikz6+1YbMS8qfNZIXsx27K9bjfnchWnmZrVSUZ?=
 =?us-ascii?Q?svA/KO5aXy0Mg5UnN+iV3xnaZuNK67UyKzrq2NTs7k8KGtZUNayUg6NLhkj0?=
 =?us-ascii?Q?0ZPNm4/U/09oGHDa4rpfF+4lVUSLCMuwhFkjlsl9RivF1hq4ncbygHOlhiAw?=
 =?us-ascii?Q?vY/W2OyTb9OLhDpeTxKia9rlKJtzc6leNnkgKxI43+j1ZuUnD6PGTdYTPI5V?=
 =?us-ascii?Q?aFNK/X7lpLJK+PRZtYdr5rdtvS2QORySaOOojX7RSIbc3LCapEXQa7bzLPSK?=
 =?us-ascii?Q?ceM3BcmDlkl/wr6l1qUTzIOgc3yqcY78w1SBiQ8oQYL/Oy6252lcZG7u/udf?=
 =?us-ascii?Q?Ck//6yOsxOtv+OCmUH1TuxOeRs8PmY+3o7SpPcTVrlgXWqPjaZPhCVei6eud?=
 =?us-ascii?Q?gFlhxtLZSIamQn9elX+KvR+QNiBpaH5trpclkKbI4LKIX7Avtm2mGrQD1xGy?=
 =?us-ascii?Q?fpNYbDQ5rojjMCcVX6xEy5xYu/oHvrTOahgsaES2Ti1WKH6t+vyEG7c3erDk?=
 =?us-ascii?Q?ZmgLnNl6eTDbzzV2SMiTX7IVn5+uxJt/Nj7o8JCWeeSZdW6T5zVFrXPfwIOt?=
 =?us-ascii?Q?Ep59p+L1ZRt2jqUymDicw2xXSoDhtUdBzFqywDgdMExWYu6jSFKi53eAE3wz?=
 =?us-ascii?Q?wtvIsBkv539asVK4bwgroz8gKenTUoRPh/KwkvLeyBxtnoXB4hqI7gAwT+YW?=
 =?us-ascii?Q?tqa7s7LboC66YQic+USPDqxiZxSLM4B5cXtLn8Dgk2rSorjGsX31AxD9wHEm?=
 =?us-ascii?Q?SH5HZ6kbklKuohQeojHQ3Q0Dn/Rykb53QYN+S1RLq3jFX+0qfuRusWdVmkng?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lahG/6yqtgZbqav6sKrtUynVSUkX9K+rm7SzGGeZnDSffNLMu3bzbeQ1V26XUe1wWpwqok1BomqJVYrAWySHak0Bpglzh+lxHQyBAgTZFBzRfwfTXHIjd6OMyfJ8Jgd/xo1EvuZ3ATpS6fgaLNc7NqwDrls2JrU3MocdbBB6w40kn7/DILFIWhx4bslvMy+5uH39i/1uVxNK8PbRp6qo1x2IlXk3RzAo/5tVoNCIHpGBi9gMTt1D7E3c2FBkcu20hUWpGw30qZ4wed77xA6/05Hyhbcylj06UHS6F0jWh9NbWCwgqn72jBYGZRu0gx1g0mhNx6pP+DnGNj0xL4x4KRZ+95JS6BSm4s/BlyRoOAdLk0XWWEbxuzeBl2+hKHN+422THyQaSrE9FRsDaBWoz+qk3EE9tBZnK8yqi82wDgoVu0XWvcZU1+89B4oGaGzrttwSXY3q9CUmk7oFJXji+6srd5O60HAPxYINJSjTC5WSHNreITJYc5Qh6T4xaXv4rbS4eCi0b/xaMoN8ghCll0Oivz9K3Hpn09i2UfGMGUC6wp8nIbeeZCSzEAqkB7qi9rmTZRQlK8Dhqm7jgsuvKpFmpNbCGUETHrLv4/FA/Uw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05385098-5eb3-4a2a-ed78-08dd07bed1f7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 10:50:30.5661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CitziEwEJNBomvKAW3r6/mduKYlDe1+mqBrsbgXO6Epzb8/HP2fuvJsef/fmuTCZDPBK5FumlKqqZirO8qQtfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-18_07,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=934 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411180089
X-Proofpoint-GUID: tF7w68uP6QSv3LXZBF5WcNgvg0zdVeBb
X-Proofpoint-ORIG-GUID: tF7w68uP6QSv3LXZBF5WcNgvg0zdVeBb

This series introduces atomic write support for software RAID 0/1/10.

The main changes are to ensure that we can calculate the stacked device
request_queue limits appropriately for atomic writes. Fundamentally, if
some bottom does not support atomic writes, then atomic writes are not
supported for the top device. Furthermore, the atomic writes limits are
the lowest common supported limits from all bottom devices.

Flag BLK_FEAT_ATOMIC_WRITES_STACKED is introduced to enable atomic writes
for stacked devices selectively. This ensures that we can analyze and test
atomic writes support per individual md/dm personality (prior to
enabling).

Based on 88d47f629313 (block/for-6.13/block) Merge tag
'md-6.13-20241115' of https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux 
into for-6.13/block

Differences to v4:
- Add RB tags from Kuai (thanks!)
- Change error code for atomic write to BB (Song, Kuai)
- Add fuller comment about atomic write to BB (Kuai)

Differences to v3:
- Add RB tags from Christoph and Kuai (thanks!)
- Rebase

Differences to v2:
- Refactor blk_stack_atomic_writes_limits() (Christoph)
- Relocate RAID 1/10 BB check (Kuai)
- Add RB tag from Christoph (Thanks!)
- Set REQ_ATOMIC for RAID 1/10a

John Garry (5):
  block: Add extra checks in blk_validate_atomic_write_limits()
  block: Support atomic writes limits for stacked devices
  md/raid0: Atomic write support
  md/raid1: Atomic write support
  md/raid10: Atomic write support

 block/blk-settings.c   | 132 +++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid0.c     |   1 +
 drivers/md/raid1.c     |  20 ++++++-
 drivers/md/raid10.c    |  20 ++++++-
 include/linux/blkdev.h |   4 ++
 5 files changed, 173 insertions(+), 4 deletions(-)

-- 
2.31.1

