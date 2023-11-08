Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6338C4167D
	for <linux-raid@archiver.kernel.org>; Wed,  8 Nov 2023 18:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbjKHSW6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Nov 2023 13:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjKHSW5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Nov 2023 13:22:57 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661E9172E
        for <linux-raid@vger.kernel.org>; Wed,  8 Nov 2023 10:22:55 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8GEkSP020441;
        Wed, 8 Nov 2023 18:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=hintziWaraovBz7j7z97q1HCcjUdgi7B/U/yQE570Pg=;
 b=w/FQsFAeI+cHfnFC/MeQHwHQJzaSLgwInjG9EETHmtQHTDARGuDo6IT0yqH42Si5nJUQ
 qjT5kjXLvKLtClmpD/0RZmOohWkbitaRtsPX0maWE0B1y0iIz5bH6u8DsX69aj3yE/sz
 59ZRfALvLYzVfXpP7rkz0ede4VA5x45M6/vyoT2lbQ/dgAsGV6c5bwlZgVpgvttuCCl3
 VkAsTfFCWkFT3apCV3CY2clzFAgQxjI4tpHu5quYRw9Cj4OCb6I1+P5NZS6tLCqNzBbX
 Yd8j+Rzr/Li3LC7AsLkKNa8Cub5YAtVqFf+h0rfCA04vRqFSMNZk4mWY8ASY3dd8fIIB Uw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w23j7vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Nov 2023 18:22:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8HUvb8000745;
        Wed, 8 Nov 2023 18:22:27 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1wp2hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Nov 2023 18:22:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hP8V8GxHif1D2h8QCdhSvmSso00X7ZB4wjfDpCybjVrvC9eI+N5onNM3IXS/5AmmuQoQvgOU4yEq9AYHajpTljdLssTRBnZVG9nXEE3j+5sOYkKDXxi8AfB80Vdr0r0AyMn+82MfauZFzefNvcPps9dXk92haIoHJG97IR/qhN4nXPyr3JLELb22La6fRI0PHboRvQxeZpa/QTNte29TIts6YIAjRKsdSy4RbEOb0nIAGc0AMUWkYHlpgwkMrSneRusScszwyuiqI1AwW926Vv2nzORymUjeCwnvaM8KWNXArbSNMD5F0+iaLlFa/iwgNFfhYP7XNoMsaU/WQCNhWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hintziWaraovBz7j7z97q1HCcjUdgi7B/U/yQE570Pg=;
 b=dzyuuBGYD1xhTdOZv4mqdbvQ6ujmzakpeszkyxg/PZ49Tf+6MGqz7MpWqioi6aKP8CBMgu2Puz+tODnHrstEw38RXSoAGvA6NVB3SPR4My7eAs5c3L/pi7jydwuZQEKf7xyfwo6PvYFQFAs0pQU/0KfjTpiSZJZoPeKfesAS+LxLhzG0mFmN3wReoK0UHtkZLKKmcETWfDvKiNvCxXZR+rRJqAk4BGAGXKhkXooPgRsa6fmsnD2TTI2Zt3GRp+I/KTIVdPaDcU3OUAVIi4izigY1Uqy4wwfNk7HyuDV+v1YZnL79Eb2oawfxYqD53CcOxxS6ShjGiI9SQoYodwUZ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hintziWaraovBz7j7z97q1HCcjUdgi7B/U/yQE570Pg=;
 b=DVKDRb3RRdAugg04M5jrFjdFDT2XJP3ed2kTdJQKE4S/tAkPS+kr4zjFpYqIQiEwo3zjVJ6jtBhcsNM8bt91HU0dCdu4k6m2Po9Vr0ZDbUd9xMdOtgLyA+Asgh32qtKApVtP5qyxOCyhohxQcUxAnNHpG3ZqzHEsyThRoIiA8O0=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by SJ0PR10MB4685.namprd10.prod.outlook.com (2603:10b6:a03:2df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Wed, 8 Nov
 2023 18:22:25 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f%3]) with mapi id 15.20.6954.028; Wed, 8 Nov 2023
 18:22:25 +0000
From:   Junxiao Bi <junxiao.bi@oracle.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com, yukuai1@huaweicloud.com,
        junxiao.bi@oracle.com
Subject: [PATCH V3 1/2] md: bypass block throttle for superblock update
Date:   Wed,  8 Nov 2023 10:22:15 -0800
Message-Id: <20231108182216.73611-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:208:91::13) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|SJ0PR10MB4685:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b6f23b0-0ce2-4f74-d6e2-08dbe087a874
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uuni9Nt+3/ztbncBH4fCW3b0WIzzIn2YrZWJoM0kNpDaYx87NrXSmM44Wjyo/dYyKRyQZuQ0NLgdPWdIVWPBw1SgqSRBy5nVTynPpn+qejuKr+gYct7jl9RQNQMp4LMndrCsXvbaYOMVhSVP1yuQ1EkkFvIMyb3wRujY2mj9h7mJ1XJprJqnnCKoiWuwRCx0uPbqtx2XdApTC2Sh/hY9tR1kMvZXWSrlhiHDLk1wCvOdIY5qbUlPI5IuldH3bfDRQ+ZTv86xzauk0mygOrOsxqYQfd/kQOsB/F85y41TmkHqDxdTwZxmPg/GtOvGOftMAi/Pi5VRyprMDdkxIBb6of0/aQ0Z0cQ+ZQ9YJLo8FJ2tvQ+ouN3sD5/X/DgsyH+NVHwLhX+qm8DD40Z8vBHkNKn4bHD3Af5j5XSIiRcrpebccgdVYkNZPndW+sdtTrHvlUqII0UnIMD5CuYz7Sl1uvpIwCwLrsmdP08TmtCikdWvY7tj83930D2JZZaIN8QC97bXuNNDbThDDU48Yhr4c6T4tOYUb9t6a9BjJZ2ZtmoYKRZvM4+YcdVfZjROQcgD72Eij0GYG6BOWnzKal46IR1Djc7hHOJ3MFA1B4MQU8EaqkLJJGjHWTMNGUxFWCxB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(136003)(39860400002)(346002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(478600001)(44832011)(41300700001)(107886003)(6512007)(6506007)(2616005)(6486002)(6666004)(8936002)(8676002)(83380400001)(4326008)(316002)(66476007)(5660300002)(1076003)(66556008)(15650500001)(26005)(66946007)(6916009)(38100700002)(2906002)(86362001)(36756003)(46800400005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3eO9MY6BYpdQd9H/WZp/EafkUCTgeL+tVMTfvBJSCvf75DUEjbs6R+4EVMoo?=
 =?us-ascii?Q?HWN7v1DyJF9Xn6D0DlY+uhjCYyI2oJlx70LWGwWvMCgn5nvbsTB07Uvd49EX?=
 =?us-ascii?Q?qVqvDAGVd5MFNos2VrjMkDyQn517HjNCb73KqXFRUccrgdzPf49jQ6BXdvei?=
 =?us-ascii?Q?lsON1hJmJnlJMqgwiVZ4+C5BBgYGLhvbXlYyqOQVY2F3OWgavoBeVe+iJxs5?=
 =?us-ascii?Q?hDTm7Bbt/EJHwRzH6JhcjBOZ5vdNmDB4TcZQhY/OAyTaoaNYhoPLBFdJMRCM?=
 =?us-ascii?Q?yj2DxBjDLmeMW2av9DlnDsvFnqk92BluVq76iJHDs8+VVEuEVu9bijygHyb7?=
 =?us-ascii?Q?hkAKm+RK9aI79Amzpd9kPs+tQ9RYUI6SbCz8ch7gPHhbRyqO4zgFhn3jCnUR?=
 =?us-ascii?Q?1oqj/76c+Oam/N/srP6DpM3z8VlXzKQ+KGW19MLGJLjWRFvFyoeL/CuKa+LS?=
 =?us-ascii?Q?JOaXpcAoGozXO27/iz7WU7l4R3fWTQ+fatn2z952SByj+dXDucJ97cyJ1yu/?=
 =?us-ascii?Q?EnudS4D6Du1gEJ4arJHJbNRl5OnUkZa1rtb2ordUSWt+3W/zFZr0Pt+PALY9?=
 =?us-ascii?Q?C6WQNxQdDFJkL1TZtkvidhYPxhhgztIBHTqO48r/aaIGXBOO1HbtPWvPotKD?=
 =?us-ascii?Q?fcoDi5vX4Hr/t+joi2oziJO++uHD53ZiLCCl/4jJx2+yCADXfeiB8paKECvJ?=
 =?us-ascii?Q?V1Wfqiyye80qbWb2nrjxBQOF5qAi9GW5VATq1++WzTzA8kPpoL9W524SwM5U?=
 =?us-ascii?Q?ObKsZgRH4lzeiemhXLHido+ZOFFdgHv1OhjqWeBCL19qpbYsvAK90WQE83RU?=
 =?us-ascii?Q?RYkTwR+GggcKRmujPkAXAgUYpKyoFV8/buzLQUr888cpefTp+IgYOkdmwviB?=
 =?us-ascii?Q?B9/JW6MJWHwo3zndYCavTj/WOL5WZR+o5H2cs8DUfPWza3l4YZw+nS8w/IA7?=
 =?us-ascii?Q?/R7Ka4LS/Qus0FWHtDqc1+O+hN6OO7VrsSxWSwu7RH3hG4HnegjJHkU7lq05?=
 =?us-ascii?Q?XIeIxlvUvA4Z9+41HxdKAAeMe34UYOl8olkFShL3QA8ToNzXl98E4f9jzZ06?=
 =?us-ascii?Q?hYv8REr02RCcU2enmi+piRALLyRmWIAaey5hnF8E+SaVvW7Mt2Y5txIDUorJ?=
 =?us-ascii?Q?YO0ILRa3JyZKPNaWF/tZi2Rd2jaGTh2FMIAc5QDj4SPSotkq18nriPwvxr7E?=
 =?us-ascii?Q?zQiT62J4o/8fqZvm4g1UHeEoyEQQbTWI9SWRx5sJCdCLGoNMJmykDKG3gbeY?=
 =?us-ascii?Q?0VCnXo6S2Ve6dJGJIZnkeRoySfxZIio7Ppjcqpjfkkh16pcY7cUUPP5sKySy?=
 =?us-ascii?Q?O2gFdgnjcyfQQoZ+nggUixNP/mYyE/3HIEiCpAMD3kZBEuE3JaWom8wlpQbv?=
 =?us-ascii?Q?kNNuZEgkLjbbmivswCMR8gfNOIzxAOaGpHG1Dwm4mRWcxCRkyqcUjaWe4b52?=
 =?us-ascii?Q?paz4CBvyKSc/RQpkfaDbYnN1ASx9p6Asq7uCGi2Pe8C5tcUgjlN5fO4VGE6N?=
 =?us-ascii?Q?1r0aqqHE3QI6AfcZXaAKeorFHnmW7/d4aa1iM5F8I+o/AJr+9FMMPDNRSSGZ?=
 =?us-ascii?Q?hs5XqsUhNp19T8Tau77OiBU0gIaVv+SWF2yuMxIJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gd7pUbJrkcJxGiujoDfwMLDaXIYQoEV+7SOrSQTp+Bq3o+DN88KN0DTRj8TyZjMo3NjBABM89194KOM45AAajHkJjM9XbxoXS3JZqQY7iJrLI39BxeCbW0yeknFAjVyFI9BLma0SQBKK1pRyD7+AYCe5aqfXYk9eXXJZYuiCrNdM9SfIkUsJo/1RRibTM0Gqa6t2smSUavbF7K+pGghXkkUQayc/gthKSkZVgs+vfCq0+mzHRanIkCOwVXWa6z9iqatxcsZCXkFQ/pAHGpSYeQB+T/vrC/D5uZPKH28M5OWb0eXkfcABOCAASKZb9nOUarDYydBsmu71HlJmBExjqMwOEHId2aF6/cCvZ1u1MMFWIoxgP2y0zJz5EqhOcHCNMMAie5BzPVniHbOCyTOYgzIO7qTglmgDDGCVenNAgm7F5PWCIvsxW/aLQDaNavqx2FY0Dmcb93/G+5VXLqhz2cUiv67OuFEsT7Zb6aL0XPnPGAs32tqpBNej/WVKEcpbtSMrDrssfcg2XN0vF46d4NaOs7zT59qhdlLG2A39brKoZs63RPS1LMRbVYnaPynvZ3ILDhYfoiy7xB2lbw7v3CxHU+LZBMNWJRyU6wH9K/C86orTBYd3X0beBkFVPKObjyaQJNhkLUonMjGNsJ7a/m1WwiQ+7Hj0PzaEevEChThYUE6m/++OoTj6EzyHcFVe3WFB5Zs154S87Lp7BlSN7O1bGGfjPplCPwuVdzmzh9++f7kkxspbGqh3p1K4652DfjgGmE/+qK5pSVJaBfhUD6jZ00u/ZTuBKX2UyoRszOjCXCwq1fAgNYq8IOQpGhIyVth/XqBfxLGtqbui8IopTxexUpMomR9+vZ1GKKgJh9CV3gvpLqG89KoQueQhz5KJ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6f23b0-0ce2-4f74-d6e2-08dbe087a874
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 18:22:25.6564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DP1+h2ijSe/952p+PPEMDFKNsm9rYBc3CVp0tkxWCmSfzjFOn4/eloNGRSc8PehGdmLi/1fVxgmVvaRkb/uLwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4685
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_07,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080151
X-Proofpoint-ORIG-GUID: A2X3k0Te9MkhwPak9ZqNrrl6jxckjpCt
X-Proofpoint-GUID: A2X3k0Te9MkhwPak9ZqNrrl6jxckjpCt
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
introduced a hung bug and will be reverted in next patch, since the issue
that commit is fixing is due to md superblock write is throttled by wbt,
to fix it, we can have superblock write bypass block layer throttle.

Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
Suggested-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
---
 v3 <- v2:
 - update patch log

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

