Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E406DC4332F
	for <linux-raid@archiver.kernel.org>; Tue,  7 Nov 2023 21:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343974AbjKGVY5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 16:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234348AbjKGVYz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 16:24:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F16D79
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 13:24:53 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7LJfR2029174;
        Tue, 7 Nov 2023 21:24:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=wfli5XOfzlDWPWB6GeF08TdoKhfQ3TBdMxjur9F2rwI=;
 b=tvqW8uu8ooQCmY2NMB+gwQDpqX9Z4lgFcFMkhqRUBhgHOOSJpbb0hB/KLw6xWnQSvmPu
 awstdPHDe81Y6LQIEyrzbCSmOIzldwR6Ubof8/U/j+KWBCx8JJNAeroajAzvbv9nisUc
 lkivUw/Q+jLGb7hIp7bYkdq1PK73GcjJXy11KgCzalgpDU2Wp6YHwESsIH5p4jQ7ZcN9
 yxpzXlosGweYf+cIe+xyY2V/hbirTYmTXnS0iO4EGHwf+8zetTLHmwOp2fCRIxFnh8nM
 HQxKUaqXPEz8YNUSiwSvsiTMPjJyAVouYd65D7/ohs1zisV+yX3Ap/IIUilA2jpaTTKt DQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w23008s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 21:24:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7LIjIk000336;
        Tue, 7 Nov 2023 21:24:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1v86tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 21:24:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qw0lBGgH6FHyhRw/n85DUzOdFBdCe7kGYeU9H1IhsFl/vp431bqJYGnvv5k2ibctjWmReDKMmfVbdZdHwufNS5HTmRsymHgt2NrtxCOpTeiauiwDTLX6E7EQe4RhdZyeZhciThL6O6yI6bj9fJuDBMOmid2eXL0xGx9CIGM9D7T1tI6uuIt4uFnbFNDwswkpq4aD5+LRMJ6MSkD8kzksEWPGuZMebPpbAXKHBDhR1EcS7n0a0ZseajZx4QSjGo4zWv/n8y7OTwJr9W7NTOdG8HRzUV6bUchk7mdIcMyBklyZ4Hcw1QzYqU4H8LDReZxUw98XTQffuDia4noIQA9tng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfli5XOfzlDWPWB6GeF08TdoKhfQ3TBdMxjur9F2rwI=;
 b=BPfSYSzD5FQDpf/F7M15ZHpAQXeeEP8cARjXaFthgZK3lC5YU0ktCih6QjLb+nyFF400svRrMMuT4DW5+2+pTL0XsQYu8oAPeFDigVo6Q8xwhx3u//k8uL5xxp0xDNm6+l/NJ3C5ucWUMO0JMTT/wyquRssv9xHrsY8BvLvpim6H1dtwZh69ZvbNkX6Zq2GFprs3g69HVkTELIHdaKyn2qwi0FlbyoB2iUHj4O+m3WB0i1WVkQUtLlY6hMrh4/cAnnnDD1ACL2lcIvxG9iplqAGMoSC9OiYHZ4gAVvVWsQsEDp6JLaZnhZ4EYuPEBk9BCWWCMrQhgf3SGmkPh1aLXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfli5XOfzlDWPWB6GeF08TdoKhfQ3TBdMxjur9F2rwI=;
 b=mV+xN8DbsezLnKHf1BeFDb9LOHwrk348wlgiRfuhnTOQaoy3I8VK4LZHVbvPyt/QS2hKIvZQTIYJdjaZGvehx62EzVzqH5bazdATVapX8BYH4rxY+AV4a3G/H0ZW9NE4XRf2wS1/Jwdpt/YRT6Vok+6vzrtsykPzD/FrhXmFfw4=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by SA1PR10MB6366.namprd10.prod.outlook.com (2603:10b6:806:256::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 21:24:20 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 21:24:20 +0000
From:   Junxiao Bi <junxiao.bi@oracle.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com, yukuai1@huaweicloud.com,
        junxiao.bi@oracle.com
Subject: [PATCH V2 1/2] md: bypass block throttle for superblock update
Date:   Tue,  7 Nov 2023 13:24:11 -0800
Message-Id: <20231107212412.51470-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::21) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|SA1PR10MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: 284a43e7-6e78-4ebe-7813-08dbdfd7e7b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aDn/BSZhcxasICip3GYp+Y7pv2yKs4j+56tfMLWx90wiuAqJmtKWVt/bLc3yobVefJVcgPiH9fsKC5XLohYo9omcue2/8UMCmzScKRKB0Cx3pAn26S+SaXJHA53xGM+oe76B48nx2b5xx5sOIu94ExAbPbhlLkBXAdZOrRJuxpV7Ihra53xGZmhrJKsif0yH+UCk/6JHeGMbwVuVBPgRpIb6TBHLrSMf2MBpvLjQUPJts7+/2bKp5noaqsR6Re9R4Y4oAvZVmmNgEAvPs1vu9SHJoh549EwB8sX7fna/HcteK/lhhLyd0U7D2R722nVuYE6UXpNxBf/UjRQmWpzozF5/d6pddzPS+0I0kPBXDVNp5Yxa73xgJMok/kDAYJQMxbbP+Q1XRd4sxMzFRnD1zPbjv6pn02laHrVi8f2kX0BnbEJRTgcqqQrsGbvZdyjWzevZOF6ph9S1QVZTP5X1iF9gWlFLrae0HYQvkw0CknFKIWhsnjpfRQ/m4qXlTEXAeX9swdQip7hOsdUEPI92zI8WujfPgmW+n06UklstB13VxUnFrJQpjImFgcFautXG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(346002)(376002)(366004)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(2906002)(5660300002)(86362001)(8936002)(316002)(6916009)(66946007)(66556008)(66476007)(4326008)(44832011)(8676002)(36756003)(41300700001)(1076003)(26005)(107886003)(2616005)(83380400001)(6666004)(6512007)(6506007)(38100700002)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gdJ2LjIIIuRNVebC6YaNW6zBvh7KtAU9SAVprwRvg7jmYrIgI/0+eqB9rPp9?=
 =?us-ascii?Q?sujzEgW5/CCFKlQ77U1tdZn5BowP1GYcjA7NZZcPJ7UW8yCGn+gaR5rNSxHg?=
 =?us-ascii?Q?FaypZ+GfzFrJDgXniD3Z5yWYggyN3UlUPJoExbjIGeHydKdr2YWoB9TyrB5w?=
 =?us-ascii?Q?Tb/J5hA4L84WI198ecedz4Or2I0zeeaJ3xN+LODVQ5rn2OeAT0PpeZpsX5JX?=
 =?us-ascii?Q?kM6LTeQXSbE1FFaoNcW/fNQRtVV37TJnSBDidQSbhrYS9we6A0Mydm1WHdF2?=
 =?us-ascii?Q?DiUEVjLP9MMYDgtYG03Qm51iU7C33PFEZ3aj1wLqKjox9jRXAAoz0F3HShtw?=
 =?us-ascii?Q?y8mcZmvBVYuoRleaeZUwsg9WUVTtlAVnnYr7j/p5dTf2vrvMD0Zfv+RNlXIS?=
 =?us-ascii?Q?1vev2AHixKuVQbqlp16BnmgW5yIEqmKtR8glZG+SCEoEOFpjwXf1TPE8sPNt?=
 =?us-ascii?Q?FbfhoUJPcBKpv7LBLel7qBZwtMPjvgCes+Arx5RAcav23Xc4jY6aQ+xAQKZK?=
 =?us-ascii?Q?KJm/A+JnTRaNyIQglQ5knN1MaTutzhhS/SOGhqE19TavMeFz0kPSNlEmEbTf?=
 =?us-ascii?Q?M94t1wqm/gYVn5P8NtGU+yCVvfAgSVGZkqGcQZBjqOQSn6TUFrFxBT8THLwW?=
 =?us-ascii?Q?Fg55PVVWJ0KKvzqHFCP4FTAWY5ujn7YjnnllWY5Xo/FTxYkKg2uuflOAagjf?=
 =?us-ascii?Q?sJ/x4a/rHVty95JuMiISr3afAcPu4XdyVY3jXbJ/B2a91XAHQemdZgMhsaAg?=
 =?us-ascii?Q?sn+y1hofMTjK2dx5mw0Gr6CrYfu+GomOJM3qZUUEuUFRN8Jl9e+/pdY++SPG?=
 =?us-ascii?Q?WN5WXgsluPMNk+kRvcGU9isQkgBANhFwCPfLVd0tSLVsknYHKGk/pEemg3FY?=
 =?us-ascii?Q?1urVymxvni7pVNDSgzYyopzlo+IlcAngdlSbIkhKFqoXcEcC3pEI+q40wGPA?=
 =?us-ascii?Q?8Hu9xOo/V8amTnhShPEC0H64S0eclWuAHrqVwHHGyjEdzxQ3ym0SH9QzldQp?=
 =?us-ascii?Q?xV1aSmgsyBY3dMs/fk9yTonSdvyQKhbsvbb9QSw2v0dVcntbSLBMuQm91yKy?=
 =?us-ascii?Q?xoqWLc/o++lWp428YFdDJyMdNQjqzibg6DhAO86lLQNPh9CRIQTQ8oIGfPIJ?=
 =?us-ascii?Q?3i5PBmn9LX/yq0RalxetR1skwjWlfwxGIPMqOAae3Z1jD5i/uEsVj807vuVi?=
 =?us-ascii?Q?C52aZBMyj1h06iu3No97U5eMB2oLt1wjwtTozV7QUrmLgqUC/LAVBsISf/0A?=
 =?us-ascii?Q?b7U6/CHAf/btqW6jre+UwxsZ6k6U59wG9FXG21pcHo9MmRTXWPJ/SmLF4tTT?=
 =?us-ascii?Q?Ot6VQOTJFyIbEe5eWTx8Wm/AlV4rcc9JZ5j2ECmhQqE8JXDB7/5u36I2rvzk?=
 =?us-ascii?Q?bWUg3mmkAhiOybs+9CloNEujxoKo1+j5A2qusa/TmKtERzsrzw27BNcrZOOg?=
 =?us-ascii?Q?G1TZcdYMClbBFqZtI6lQ8m9Q8nlbeScFgjGfeDh+wXU3IXteKTGVvL5iCfmI?=
 =?us-ascii?Q?M+R7w253KsNjzAwgsbU6qTl4H1a6uksmNDR3wir75nOOcrRr2gnRH4uirI8p?=
 =?us-ascii?Q?SJGespgMBML1zBrwnnrsbiQILUvj2Ew3xJ7cyDU0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: O74NwmCkz4LJfF/50d5kJ4Fp2syDAAplEzDl+LkzwVhWG1s6S8n6xIhvkz7qJiV9OxvmyMVsgW3U50Y8L/mjU2reXVAA+U09RiC4IjpZfJ/qbOZirO8w4RTCr4vTJpk6mRoweV2tM5Bf8ismPdhQJLg7mTTU3hptlJuO3TAEafEcW5M9z+SFDNRaFw4zK4XJSG/gbJXx93ekwA0hy/b58ihxSFvjk9AfctZKwmgRFpfbVD9778rKXptVNhwiGlXezw3CNXjzf/4pG0PVZlyC2QdxNHg3KQczLUOW4erYKlJO2h2o4NeOi+SSCwzOE6m1cMzH9uQQT6EvAkvv1Nvneh9CQtM9/fU3Tqa2/Uw+tpsyPGh+Cr0jPj4BrRSxFv+oaTtb7S1744SKqvojjc0VD+qkY9AVRCjkF86K/kx0GhN8lx4LgRdliwifv1OLTMyKh3a7gRhKUQVosyf1pe+GU+Ct+GWg4IwhG+pV0Decjpns/GqrT6DOT5Y77fcfIbTtBAYxpuu+gsJikrJoRF7EO+b7hm+8YD7GYQTB6gPKOUWwtRltNFVAZvm5+9rprx61Vdo81jIFeqBeal1HH7tl35TD2QOkog3lZ/MtqkHhIHzVzc7V+o4cAFEqx9VCtRikXLZApyIud0b2Rfj4Y07OePAz2OU+H8vYjNsZjl5twHPIyEBwtf3AsksV0aNZb9cdA1WvIsAeShi+s558A+noKySbht6QhpoVjnLpplm2yQsDS0TTGVV1s56PpO7owmTFTqSonR5OzjjyAZWWQgWjnlqqBLMHYuDYEFatLk1EKNQ0XameoQTe1w741PyD7FqUF1MrEyWuuQiDr5NvD965rt2XZQdU24LhOUUPtxy3jZlAkfBzmTIKSnHnQbvmvM6T
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 284a43e7-6e78-4ebe-7813-08dbdfd7e7b3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 21:24:20.3709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /FXwg2b5pfEkeIX/NmdGv7+WICsP5LocAsZ1URgjNW9VJwfNUcPUEBVQxVpZE/Ew7jYGFBNC8O8IV3u9xm7p+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6366
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_13,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311070177
X-Proofpoint-GUID: rJfst3WGdPzuRJhvDCyfqDN5SeeEKmyj
X-Proofpoint-ORIG-GUID: rJfst3WGdPzuRJhvDCyfqDN5SeeEKmyj
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
introduced a hung bug and will be reverted in next patch, since the issue
that commit is fixing is due to md superblock write is throttled by wbt,
to fix it, we can have superblock write bypass block layer throttle.

Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
Suggested-by: Yu Kuai <yukuai1@huaweicloud.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 v2 <- v1:
 - swap the order of the patch
 - small tweak of the patch log

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

