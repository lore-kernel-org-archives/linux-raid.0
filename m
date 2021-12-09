Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DD9C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 18:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhLISli (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:41:38 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25470 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhLISlW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 13:41:22 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9HnBYJ019878;
        Thu, 9 Dec 2021 18:37:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=JIQQw7vPay2yOTGtxHqBlTUKEbMZpTN/WxtWylkrqr8=;
 b=ZN5OjEN70JyqcvtWq77dYaquq9EtrFYiKFArTLwF7f572v3TAY5NuakCsSdskelfW4gv
 loBajuUm0GO/vRIJg4mojRLjbTc4tlCOr9lyFzliUKABIaew7xf0fQTNVBSbnU65f+Vj
 1ihgRi6m3+LIwBxvqY29JihnVnPoXonvbCcVPFx0syfLa2WTapWL0aDv7sp0rxLmPRkK
 u+fSilncLsOF8KySP/dwRSFJ6H5VkCKkLngdubDk6nj+a3UFeuESf8MSTP/P4GYMNfdL
 YZqdy0+SUnuWzG8J7F269fKPzgJNrh6v09QuaVhKk/clMgBy0vFeCyLu3HctskwKwys2 dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctu96uy6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:37:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B9IZjU2147572;
        Thu, 9 Dec 2021 18:37:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3030.oracle.com with ESMTP id 3csc4wk9fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:37:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBwIkf2+Qg10aMyEdDVp2dzdkGsexsRHHt3Uztmatpvmni7PB8ixvWf4vzzTAhfIh0wLaf3zfKAshHYXCPnBC7KJM9HELBVjbT76n+Rsq3wW2HkrIEyzuohHNHrKwIiaKvphMNu9txWe+8scvRiLnq/P9T3oYzAhI+w76Z0BkK5tKF0cGlM9Qla3gFyhL7XAA1TsMY36Rel/hjf0mJ+UcVwqY9FR5RMmuIJCxkopAPbcqmamaec5nXaaHwrW7kNEVZNTs9meabFNz9Vk8wdq+tiPxcapcmKX73HIowZjVkU/RPNDGYWiciVvzE8AdISxjabfYvupuGJui+0LUygAjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIQQw7vPay2yOTGtxHqBlTUKEbMZpTN/WxtWylkrqr8=;
 b=h3nf97MiVtbbJK7gmq9jx2VXY8miYlfEcXMYXZcPVeHJMeDeCfZ88WfFeyJsd/zsaco2SYK1oi/9Tsd58mtrDpHWdHcZ0fTQSQ4MFv4wQULi1CQ8HFWGAQPrlDXp1mHyhBP9uyTVW10an6pAyxPI5z7vWvrZN3NRvu+iBc21Pd+3cHup2pE5halYoati8+jkvsz1X5BobHNem0ucB4YaNhDLKHoQcoxyCohEDGRrpupa8wtwQX10JCqBCu3AG8I/6f63TGwYTmx+uLQKBVDOld0lsnl8eQql9ahWaTJ98m90ghQ4LXcP0lNqAye36iSxsY74neylxvz++A12leZz0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIQQw7vPay2yOTGtxHqBlTUKEbMZpTN/WxtWylkrqr8=;
 b=lspj6mJsuWl2Is/v9FXI9ARr9a0NQeXAYvaFMecDfo/SynOovdNsY9BGMlH1vXr+zP3plDbIqPwFGAlRqqWybaurwxglXwoyOBpHj7FeKJV5Srz4FgRWkxrRGJmR83Xr21vT42p2LZ1vA1F3HGk+Otx/uEqpzoVZuad7GSePd5Q=
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1655.namprd10.prod.outlook.com (2603:10b6:910:7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 18:37:44 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be%3]) with mapi id 15.20.4755.025; Thu, 9 Dec 2021
 18:37:44 +0000
Date:   Thu, 9 Dec 2021 18:37:40 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 4/6] test: clear the superblock at every iteration in
 02lineargrow
Message-ID: <20211209183740.GA22521@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SJ0PR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:a03:333::29) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
Received: from oracle.com (209.17.40.39) by SJ0PR03CA0114.namprd03.prod.outlook.com (2603:10b6:a03:333::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Thu, 9 Dec 2021 18:37:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f94da065-fc08-459d-7b3b-08d9bb42fd2a
X-MS-TrafficTypeDiagnostic: CY4PR10MB1655:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB16555F09444E2CD0E62ABF35FD709@CY4PR10MB1655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QV40oL5Da7uzoBp4cdxLPe/zv72aU+WCuTHbrUjOafdA+068GFAp9hMpqDVloChQud/2ArUdm+UqkRZRJB86z3Lterp4eCo9G6MsPV5JHq0OiUnqn+VfyZHgD7a4NcxfgqKeIAhUEeGCngDK1nQO0pjX9AqknCJOjprDzhf1FnL+sb7bTNKZ6JP7saSDd+9MioSLa7TCPR+yNAX69C/2vO3xaQy0Pufl5OfoyxEViK5vo9NukbEOiOVARztaIjXPKF3M47HmvcQWdeKnbNcDOXz67yxCF7ODxRROvVWpGnBFABkEET6uhAC8uMWzp1fh9Hyk38aFvq0b3Z2pvtLCSeulFjLN5GfRooZqS/o//YJN4SKFMrEntDr0KqW93Y9AmvQPOC5CfvfImw16uLPF2B/80MkVHvva0QHxyjXh84ZkghIM4dK0MEg9UN7VP2PiHSwQ+cC11bwph0LUIgyAqKgacqfmrLJeRBGu6qhimEfR47WUgmLi/rf38nzDt4DFW71ah75/ko6yzHEcFvatxGkhss57NTs/thUrdZKZ1hsy9aIiej8culvaMxIMZSPfiTDT2x9ErLsigdZeHujGBwLcD2qJ2UTdD89icN7eTadHYePHLckrY76NLzzer6YNBy89m0+YJfMPlHK7mSwoNZrGXqx6FzV5qVdDCU+qFp1RL3YjBHtCNgMFX7bpSt5A0YjUdMowlPot0OzMrupzMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(66946007)(316002)(33656002)(86362001)(38350700002)(36756003)(8886007)(8936002)(8676002)(7696005)(5660300002)(52116002)(38100700002)(26005)(508600001)(2616005)(956004)(6916009)(4326008)(4744005)(2906002)(1076003)(44832011)(55016003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z/FAMustMy3yZXagGFdGjscjE/n0H69wiQMbxF1Bh2ES7Pt9Kr3ekWvFq8JP?=
 =?us-ascii?Q?bVpzJJlAxiQ99Znkv9V0VI0iMohGrxyDM/yhxHtd3X8ghZkzzztoRfuxCnbE?=
 =?us-ascii?Q?q9A6h4SF5PrjQdLo0ZRzJc80oBPEno0YrNa8PDUP1xHEhlbcpTjdbfR8WEPi?=
 =?us-ascii?Q?5qKvNEhRcjQge/Mx5r5n8jX3TG8M5t1NxvqmqNNsJWNILaNUFMzzlyFcNqmj?=
 =?us-ascii?Q?7lwmkBIBM52FFkgTXfimhweM8zCVzUzUVuElteae448F01MQaMn5htzuIlfl?=
 =?us-ascii?Q?NYitoVOqDSHREkyboR0VoQ7Q0oFAOpV60wg/kbzL5WVeCDFZnVlL6/0r1PPq?=
 =?us-ascii?Q?PZPdimh3f8DtykqsgCnFP7neZjWIHU3qiTL6yhAe3OFGOAfoRCOtYkWR2JaW?=
 =?us-ascii?Q?hvxEPTo8+jC4DF1ODxs7BJijgY3OzP7AnEu+P5oPlRwWa1C7M3tJnJ5NK0Sh?=
 =?us-ascii?Q?MHZYydZNnAyqjXPB0W5y59YS4hxuAv4MpMG5ppef+B5Pp5l4pQz2qD3Tb7NH?=
 =?us-ascii?Q?OV2/VgKX6ocAFEc3tIbvMlF3E8jSH4wAFWJhY5sxH8Jglbn2efNuVbvIUJ8K?=
 =?us-ascii?Q?opqFrRorudEopt/4NSnGa/rzIewR/c04u1LPsHZ+XMm7aD7HXup7mM8outJz?=
 =?us-ascii?Q?xhoyrucOjW/Vo+xFlNhpOrIE5RDI9hCiLpM4tmxrOk1WnyDzT2YVjux+bM3/?=
 =?us-ascii?Q?iBP3WAojXWNcVthB2lAB8AJWbQhzEpnCS3+peqg6WLfY1V4nKqxnh22rVUpN?=
 =?us-ascii?Q?E9xCUT2qB5KpHl9+sEJK55mzy2L+DYdnoEzZHnGFpyH05GIMsCBrPi58cbML?=
 =?us-ascii?Q?M8dlznK7+ATIQfUCd15t2McYCjcnht0RGOFUU2XSWYVtuulg585gMjw73Ffi?=
 =?us-ascii?Q?5T+ch/6NmiRJ+esK0Jl8YZlFFV4LzouNfmE9xAe63hgzSrDGA2nJSqVNERa9?=
 =?us-ascii?Q?nS5WrUshjFIluTC+RZBmt3LwsUBMVxOUA+HWlk19cR9e4qMi/UWwTMP4lBFr?=
 =?us-ascii?Q?YE7EADVu/t5msJ1F9AxR72k9wfrItuKiKUVJFGWpxBN/3lm0YyBZ92j4xUoA?=
 =?us-ascii?Q?2V9fEpXswIuVywNmA2noKbxpoJtiB78ci6MQbJq1CrUtMqyWi6saJPrVSQRs?=
 =?us-ascii?Q?68X2q6Azw2dRoY2MoXAsYdgSrCXotYbDCiYuhNul9RFkpDZ+/SnbaNGoAa5w?=
 =?us-ascii?Q?uQzygp9a2ZnfC/SWrVAPihXys8CXnzn6+r/hJkoMIVu/5z4jkfKcMlhM7x4C?=
 =?us-ascii?Q?pqSROr5xlX1ylPderUis+a2gEcNH+TEf4CV9sS2XclBnn+Sjn2T/uvVCULNM?=
 =?us-ascii?Q?StQWQ9OAlbVmYuljTg0ommdnEmHDL6WyqzwEAM7dR+lJHtnPoKNXz2tkZQTa?=
 =?us-ascii?Q?GGme2R371BR2Bd4twREdpYMC2/ul6j0L9JDp/5+K038EvbkaI1F1pSxVUxmB?=
 =?us-ascii?Q?nu24lUvb771ZR0oL8DMRFMFIOQUh0vZY6jYNK1+VUa7EGYSl1wYo7fD75Jwh?=
 =?us-ascii?Q?Rn0xb5Rgsr2v5Y/TGQe8ihaQHXHIgriNjhGZbyulpA+3qjzMXLG3E5YU3Xs+?=
 =?us-ascii?Q?kpXOtGHCaWcJrxuLxudHVotHKxQVU8iOvVz2tGpGDu7MXe+6eeAXMe2wX9Px?=
 =?us-ascii?Q?AbNoLrL0Zqjry8DTaENq9JI/Tidf15SsudDiiH7ZQ53AAG+mIug+wS2CJi6p?=
 =?us-ascii?Q?xPWXX/kt2HXu6K2Ykv39yLU+iabcF6yv+H9IG3KGmT4ZUKnYzEJ4vPC1bElO?=
 =?us-ascii?Q?fVfbFqbtpQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f94da065-fc08-459d-7b3b-08d9bb42fd2a
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 18:37:44.0228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 311ysSfG5pBjkfzlgyt93B2wLI5OlpIZnxCUXiUIIwquhkZCCQpSBLOqCcraASEtDmOuSMPo4BrCgUNYcYiOboJQ7rxK+wynNmuNZ6ff4QLLutrm5sDiwbgLGo+0M+rU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1655
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090097
X-Proofpoint-GUID: V7g2w2jgmebQeMj_MzxR_-xx8X8PlPyQ
X-Proofpoint-ORIG-GUID: V7g2w2jgmebQeMj_MzxR_-xx8X8PlPyQ
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This fixes 02lineargrow test as prior metadata causes --add operation
to misbehave.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 tests/02lineargrow | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/02lineargrow b/tests/02lineargrow
index e05c219d113a..595bf9f20802 100644
--- a/tests/02lineargrow
+++ b/tests/02lineargrow
@@ -20,4 +20,6 @@ do
   testdev $md0 3 $sz 1
 
   mdadm -S $md0
+  mdadm --zero /dev/loop2
+  mdadm --zero /dev/loop3
 done
-- 
1.8.3.1

