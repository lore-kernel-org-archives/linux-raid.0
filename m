Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A27FC4332F
	for <linux-raid@archiver.kernel.org>; Tue,  7 Nov 2023 17:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbjKGR6C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 12:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbjKGR6B (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 12:58:01 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56388F
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 09:57:58 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7GeWUi007243;
        Tue, 7 Nov 2023 17:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=ZefF1sdElYTvv/+IKpkRGhYbnsbKj3YPa9tpw4M2dwU=;
 b=Aqxzczt51rGhLsajDMbYGsB9ev0wg2rQ40Y7pp3DhAGm4FK+yvKSK7S1VrJRg646jKob
 0DiMcfr5jDVPkS6Kyk/Soek/a5zQHSEwbSPwKeqCJsoAtsuatITAF36tHb7RGC2LyClS
 8Th+u8HgguWThvSQJtLSeR4aKwEHMavLSC1chzgjrNHkNra/voa6iB50ruooJ6LsS4Ta
 9GjFDLcICoo2cdUNz0dMuVA1v4sI5AkR3A1mVGtgD451WtrXn6bW7xKTF/S6U/g0G9LP
 CYF7DSDBmBqzJSJCS9Dir8c3RgQ3QHyA+gDFnPf0nMMaNQTOQkJIu0FTc76eS8Wh6Qi0 8A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cj2xs47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 17:57:44 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7HhJ3D038278;
        Tue, 7 Nov 2023 17:57:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdeb1t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 17:57:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbsW6GbhRIaAKoCYMY4TwjEE6+c6um0q+d8FWYFXzpUxVL6c2PRNFCPZzWm3NvUzt4oC83P4CrC/du7oyvN7SHqy8NF1pXYnl6nE+nm9lU5T2PcLGa7YWDdSjSRQKIpO/r1BPSOuc6SoGG4mUV2uO16//yly0wSxsQQG2O6RsbA+QAwmuTH9fe2YaqzrDWXrsUizuIs06Ph6hFYcbFP87XKAmviFI4PmZDKGLDwcXjTt2rWNZrZCCnUyVaYNpmCow2XrkgkJc+re8oF6J5MIZSIAyPI0WuP40/BJADAV0QejmkEZzasGll3+1IPbe7e2hHEijjR9MpxSV6t1YVRgfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZefF1sdElYTvv/+IKpkRGhYbnsbKj3YPa9tpw4M2dwU=;
 b=BUIhTv0csL3rfT+d1kaW7bn8/Jn6UblmevI22YtJJPPC3ojU5A81thubxYEuOh5KCEWnIijM6HIqsP3++QOPpglGtPDS70/v+4tz4UU8f7pMdXgkERQBIFd3WXP5+HDysbgLZDz3e/B9HdQg3HLL0h8RV9GiKkNeLzEq64mPtS/3nvUqssOZu/F8XWDns08Jad/9pTPg3ckBsyGVTyOF+w1UnMNGlvFH1VsyaKfzDj7hm9eKG8v6nF8Woq6aNj4dIW3seKicj8Y+hL2ktxLm2oNe67guirwbGb5Qu2n6aPuud3TckFJMWwjU1U4tVXN7FHP0Q6v/jPCVSiMGp3N8mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZefF1sdElYTvv/+IKpkRGhYbnsbKj3YPa9tpw4M2dwU=;
 b=EGPjx44MbLQrIrwGYjuRMRv274RYCKLvads3Xu0/pqzrM89Tk3F3q74nfs95pGeJX7j3NkZ0Y3RrH2EmNVJGPKjtGNN2CgquD6CvD6j9yV+nwDb+JDaAgluE0we/d7ibuYmw4kUnAHk2NopGhVOo4v7njVfJtviW+9Z31BvBX1I=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by DS0PR10MB6918.namprd10.prod.outlook.com (2603:10b6:8:136::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 17:57:40 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 17:57:40 +0000
From:   Junxiao Bi <junxiao.bi@oracle.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com, yukuai1@huaweicloud.com,
        junxiao.bi@oracle.com
Subject: [PATCH 2/2] md: bypass block throttle for superblock update
Date:   Tue,  7 Nov 2023 09:57:36 -0800
Message-Id: <20231107175736.47522-2-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <20231107175736.47522-1-junxiao.bi@oracle.com>
References: <20231107175736.47522-1-junxiao.bi@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::27) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|DS0PR10MB6918:EE_
X-MS-Office365-Filtering-Correlation-Id: c9bb68d6-3f0c-4eae-8d7b-08dbdfbb089d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GE+ABzEuEwGas57vjrA2PO61lvLpr9gNfg4r+ocTkiopRrJYkvWY/kFpuHHEsCe83T+G+l3Arkdnhpcd1o8Qc00RrN6NJo/kV/NyX91tqMCRrF6t77+0PIScIhbiayTEwU/CP2bwAdNDPzIRJ4lg60q22gDYdvpFwqjQVOoq9e69pZCsnRNJj/it8geu2ehbMBTYATNAKBmEDJXkQMe+b832vNUDhhbmGzELpuXAoR3VUPOpoN81yAJglsAYqyeeiveyTzRnzibg69tnowYhdRr38cjngAUzTvtKb4bnfLIgtGaRdjbI7Totdt+5i5X3DcMlGPs9AtjXrtBPhQ2GyCsTix223FlSQXKaRSV1NO93kDqaE2IHcLhoWYy6/htl9hhyx9PoeIYP8taz8vZxh2ZfARb1+ijMTM5m+TnsxROmjjIDGV4AoNAHFC/X/YdZpCjIrYe5IgGDeENVVb8MA8lNUZuJRA8Oz/pCKAtMnfbkwocVaQ9bmyK77t7NfifLpH9Gd7EXeC4xVmnen+doqvcfCqSSYuByE2l4lgsGlx3D65C22QWlNwXQL0zgolvt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(396003)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(38100700002)(6506007)(41300700001)(6666004)(66946007)(6512007)(4326008)(66556008)(6916009)(2906002)(66476007)(316002)(8936002)(44832011)(8676002)(6486002)(5660300002)(36756003)(478600001)(1076003)(107886003)(2616005)(83380400001)(26005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sVRsIGyyOg8WSJWZn9FZ6c5PvAGMdW+7ZFz0B0+hzSsFdedXGXhClXgOGI4A?=
 =?us-ascii?Q?oa2moC2lBw3DCZpbBV3OjnRJRJz4M0PrlkapEo5JovIeia5NWKHTXLLbAarV?=
 =?us-ascii?Q?oTXosFj907tQP2Cjo+MTUlil4lkPnBFcLP6U0haGN3cb32ju2Vrq5zMDpN4m?=
 =?us-ascii?Q?yEgX5G9S1ag/Du8g72UhQ1ReZDtTfIjL2ZLfHX6AThK4Kxhk4c4LDrcofkAe?=
 =?us-ascii?Q?Ta3P4Aqp64JeCZ0Ptk4JMMcbwhyFSyztbUbu+Cfsh0V8YZTQ5YWY6o1vHKv+?=
 =?us-ascii?Q?AWB2EA6ZnyLU5B9s2ddYCGSSnlUirKLlBzkvzLL35il7RpkIBeR7NhhgMeru?=
 =?us-ascii?Q?hMiKm9VPxpp8p0Fu2dTl3EGAD2Xt4s5J+qGxLwCwXS7QF+Mu28yB/hOETSdM?=
 =?us-ascii?Q?VGt7jUMU722NP6ETBJKJjBTzlK4M0a4wN/ebLRVsEi7WSvpUM9DM0bPemg0i?=
 =?us-ascii?Q?3qtaf8ZyY2RarNcWayKKHeF5Ry229ihp9NJAmgUoqbaIphLeISmI/krg6UvP?=
 =?us-ascii?Q?wTlwQITVhcyD7Rqd7BPO3vNx/lqDRi2iHYT1n27NJ8tA+BnTFy3OFiuB5Uxp?=
 =?us-ascii?Q?dAKfqweJ4m8X+cMcVxceJ2w7uVwsVBa7bjp0AxUc1xPjrODECjKjElpY+DSG?=
 =?us-ascii?Q?0GqMAjpq+DB+jkSO6+w1XHtWJqPsbLuMKLWZQBzC/UvErnDwFPqK1OYdqXHl?=
 =?us-ascii?Q?ZkfHF19BO7JXpgpna83nJkAS9r3IkcuPcEiKQF8A3msOnTd2tpwCrqsIYKqL?=
 =?us-ascii?Q?wynZX+VmvFmfEqAw1olK5ELGnL+wvJjmOcikY1gBnB63nPlctCUE61HMOx4h?=
 =?us-ascii?Q?CymOPWf9N8uZk1yVCv6z0oPCy1kieWd4r3EGQ6/vXtivVqfYFR7pOaZr9quP?=
 =?us-ascii?Q?UP73bWx+69NgwjKr+7Lm2CkK1rGSYezjswv4VHMKgIM7xHdQyTC6CBoI+FiY?=
 =?us-ascii?Q?pb5ibZWR3RqCwYN3oOXC/BwA6pKES4diPd5r94+BEMyrIz6vuh6F7o4oWyzc?=
 =?us-ascii?Q?+rlfY6yBzM2KGlxCzWSH2SifqsRyP8YjbJp3I6tLzhDcA4PZBzp7Mv38Qh4r?=
 =?us-ascii?Q?M0cDWW+cto8maP0q4TaH8cbq1PRcqj1AIrOQivmJpNKipJWdsmuR/fxAbHGp?=
 =?us-ascii?Q?ZmPM+7dACj8sXONSfbGAbrYCIwrubItAeBQG8jt+bkkHn4JLxT0qU/VI972h?=
 =?us-ascii?Q?mViZQnThZ4PPZabLxMzdZBJvNTQxfRq4fnpk4TpKLbrMcxAlHwdspU3AXnrA?=
 =?us-ascii?Q?OxLacwuv1F0fIsrwQgSOFJRkxt7OlwOsSGQ2hqI0bENxvQecs+SqEafvOv8W?=
 =?us-ascii?Q?W4SZMXGFgAYyRZu0kqCGiizFrZMEAmFIdQzABcSRYDB0FNkflzFCrKjbEApj?=
 =?us-ascii?Q?K99ke+BahSG4lyGV0v9VtqBgPHtCb7bC1EZhjfNX1KgDC6OZrvPjpLhGh6dp?=
 =?us-ascii?Q?dM7wA+26wxnLWX+L2bR7FtFwdXN2yL8GxXL7pBCdfX7kP4h+aKtHhdWV5JKF?=
 =?us-ascii?Q?ewHhlAZpVGl+pqMKrUFEVe/TmhIwRUbRTAEz7wJAe9P9tOcgV3pEAEnLVyAt?=
 =?us-ascii?Q?c/aos2OD7OEMO1LVfEmVAYo7lljAeiJoIHBOatDd?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JnF9WJTBvKiP6F7F5tuAzU5Qg+8PLmr9I5LAQ/72GygQZ+anvBqBC3i4WBzlCIy2RduMf9cAjyC1d0y9ftSV/Vnx2c1d2KKXZbBxVq7EAD4KQEv/AaE7SWsNa61TZFsiGz5L/n6L1IvGjRwvV5QECE2A/qF9g/5ulOHmtqKENhspzNZJDWZxAoBJ/ShQG9uTgvG4ZBL+MYxreUaGBFsP4TnmKA8uAhBmAp7UL30dwYIXURml7eRVwr6vReE0ZTt7qTFM//JlIdI1Gu/Mhm3crEr5mbwulIzSja8BtAUspdao4SqIcrJ2kewGEGVtbGtU1FCw1dJs/d2SJJrZC9ZXpbPVYaMo+98ZqNieSdMeu1c7+rX17o0qzecKsqGV9JwNGLWhZKNyjXyLiW8EyX+w34elyHurlVoDLk1c/DjEIicF9d8/hPmArDV6wrpj+nwMLiK/3zhrXBbfyLpAzK6sdBVQip5UHjya9oX0GDsGQELsPzq760Q/Gb7k96oyg2YlzTx1uQWRrW41j2/TGkrjZlnNtvt1b++oTzMq919QtFecZTGZ20kSpBWlkg6FsjmxRVAaL0qiowUjwF7YY8aox39/Foqt4rldsmVQluzWWUEco8t5UeQQ1tf760YC+Z7PiC/3tFH9oZ4KgR0oKiew3AZ88iHIOK8UHOgQIgsu/gvxn82jqrd+JFZbLkdRg/5CQqy52ZoNthpLlPkOI2pidjpd3wj6KcJkl04JoPa8J8P+jcYuzOb77x0DHUDSt+cXizbb/ab/o43M/gFlXbL7pXssCVHQitNeXg5XGufhlLABUsBZOKdnHY3sGBL0xn5KHYwen99vlkk34QpqNuzoZfbpV3vEXhOVzBFFKS9+dW37075u61sV1JDEypZfQ9yM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9bb68d6-3f0c-4eae-8d7b-08dbdfbb089d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 17:57:40.0938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+EmymOWJFvISqfNI6ajGJLZIlycTmuY/w6L/CGzWAim54LdAa5q96WPAwZXRONIesR8AWd2W0GlyUerSuEnIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6918
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_09,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070148
X-Proofpoint-ORIG-GUID: Yez0SrG8ORBPt0nBOOpHTivMBN358PdD
X-Proofpoint-GUID: Yez0SrG8ORBPt0nBOOpHTivMBN358PdD
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
introduced a hung bug and got reverted in last patch, since the issue
that commit is fixing is due to md superblock write is throttled by wbt,
to fix it, we can have superblock write bypass block layer throttle.

Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
Suggested-by: Yu Kuai <yukuai1@huaweicloud.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 drivers/md/md.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4ee4593c874a..7a5a22097365 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1013,9 +1013,10 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 		return;
 
 	bio = bio_alloc_bioset(rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev,
-			       1,
-			       REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA,
-			       GFP_NOIO, &mddev->sync_set);
+			      1,
+			      REQ_OP_WRITE | REQ_SYNC | REQ_IDLE | REQ_META
+				  | REQ_PREFLUSH | REQ_FUA,
+			      GFP_NOIO, &mddev->sync_set);
 
 	atomic_inc(&rdev->nr_pending);
 
-- 
2.39.3 (Apple Git-145)

