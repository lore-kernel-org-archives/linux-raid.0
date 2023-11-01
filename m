Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2181AC4332F
	for <linux-raid@archiver.kernel.org>; Wed,  1 Nov 2023 23:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345578AbjKAXCc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Nov 2023 19:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbjKAXCb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Nov 2023 19:02:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D260A6
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 16:02:28 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A1Mi9hC023087;
        Wed, 1 Nov 2023 23:02:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=/z/xuPfqOk7hCH2yJW+em1J2qInZrQGRvyCpAP2mS2M=;
 b=kywZb0aaZXFa2Fse3gLLkRyUWT97T6k3iv5MNzqV/fLPMy+j031bN3SEwXHjivoGBi3y
 OkZl8vg3U545AU2AXDfrU7M4vEvK00Xg3uAZsrSQFOwkyWbAYxP4fsMuiw9LQzg4Y2Hh
 jm7qIxZeu1Rp440ieRa6iXvgZ/gG/24XFfS0t3GQ59ncjRbd5+Rz1j0wMO51Udt0hM/N
 BjoFrQvr9+intokml4eAYSVMxfZlNbSSnuqdSzWaL8MKhz2zkp8ntvrK87vQE7UzP9bx
 J0XXiESxB1g6x9v8Iyukvd2wmCKuESzPAQ460Ccmp0CEdBQGW2dpsPdUtFWOmwSFVJ2q mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0tbdrpdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Nov 2023 23:02:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A1MAu9l020132;
        Wed, 1 Nov 2023 23:02:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rr7s892-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Nov 2023 23:02:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQsOhN17CqlChy16yXFCsBcYAJRxL2U8agy+wUfblPCXW/UjAuw6V3TsemLclaCz+ao+fp0q8wTFbkzqoeZHB7pTnRqPRLH3B3fS6qZCKzqY6GZviwVEBKsAOlCilZZF/CA2xWIQQebUxX7j4q/f9aNontsvjFo0dtBuZ3/yvGZwoDBKtAbe7ix9tt2sYUVHeOaYaSI0ILPWZnoLufeqNbVT1SQU85YUTPeKG5OP2fjIp9yqOpWp/jStKv00lNU5pW5OBJqHjEOuUDVJTyg4y6FFzYjm+CoR7W8Y0YAZVlSAdhhnLADVuF/BoOekjF8hiij94Gtm6PaibfEvzqFfOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/z/xuPfqOk7hCH2yJW+em1J2qInZrQGRvyCpAP2mS2M=;
 b=HHzqIxpfCUpqTf8xWGyHLp8JgKrWzHO++YREi9JSQiF2u6c1dcsR40XjpxS1FrbhxlOBoxYpTa8odq26WPTHMdeD6atU5lWYFRTgX/zNBHkGlqR0A08fxCRjdvzQv/4n5MwifN2+Ef31fFQOFIapveomQ7FbJ+EZUFfEgKx+U9yTaTEXbBfJmy5CG/9kSmMCz2Y6NtiMuiaqxPvPxDYPDc3PNcG6cuh1ioAHYrvmcBr/4JrJdpHUKZDRxd4Qq+O3l2rBHgN67gf+3B9LiXiWjk/p8PVJqc2PtSDlG5oDZE5odpngSdi3AzozdQUmE1Z/2o5Y9g9DDnkGuqMWs1e6LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/z/xuPfqOk7hCH2yJW+em1J2qInZrQGRvyCpAP2mS2M=;
 b=D3we+XicqvjO3K9xZ9D3nJ/mh8xgkx0kQmz8GwapWrtMzJJYMfsCP7lXEXcqnzlqfUWpSiy6+FA2MoTSW6GQKeKczubcAuA0sPI62X7/e1G0WtSV17A26zmsC8953NSuCyo6tZDxnVjZvdyF59RwDIwp8bmzHwUx3TnLN2gX3l8=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by CY5PR10MB5963.namprd10.prod.outlook.com (2603:10b6:930:2c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Wed, 1 Nov
 2023 23:02:16 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f%3]) with mapi id 15.20.6907.032; Wed, 1 Nov 2023
 23:02:15 +0000
From:   Junxiao Bi <junxiao.bi@oracle.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com, junxiao.bi@oracle.com
Subject: [RFC] md/raid5: fix hung by MD_SB_CHANGE_PENDING
Date:   Wed,  1 Nov 2023 16:02:14 -0700
Message-Id: <20231101230214.57190-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0208.namprd05.prod.outlook.com
 (2603:10b6:a03:330::33) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|CY5PR10MB5963:EE_
X-MS-Office365-Filtering-Correlation-Id: ff1cd2f9-a654-41dd-d25e-08dbdb2e9723
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13T6nPSEHtMOZD2Km9YX4Lo9tpHEyAXNox1SfhLXrZmtwd3ucYD2FQwrmWink5ynRAmQ75L+81/3nS9eePA3vtnAXKapIPlx4wxY0GvyJnzJqUBdJJx/3Lju0xJ3Sx6wltGMe6uzeS+msXIPTgmtiOgCEud1D2/gqcoACBebSdCUvn1xB6MEHVAl2Hw5DK4uuMhHhxFKGhTggseODkXddkaZ75+gkWPbL9oC79Lb/juIRzpJQT7y9vnzI6xQmWVbKH0eCGdU4RU/gARQR3HKcVGw0wvVmESxPkelWib+x7KG7jL0PaKUsHUjLYQEgiUXRL/tLCzpmBgX4DdiBdYRbbW1IrFGmuypOBTs/NzzCiMqNQtHRH80Uorn780x7kuOZ7zWcvmWbbHkySVidbrkcckTufjyOG8SbHEsozCAmlGSwYmg3QInQ36cBAkzKVefwEPVPA46bD8pc2Qd7wb3s5ZfZEPipnM2GwmWz3+5tfl7GavXfmFVGh8NHWnBHFhsi6rwZYiXiJceoTSadsvgScM9zQxZAVIHhNOaldZtEz5p0zPA/Eiz3l8XsUp9a25w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(396003)(346002)(39860400002)(136003)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(6512007)(6506007)(26005)(1076003)(38100700002)(316002)(36756003)(86362001)(478600001)(2906002)(6486002)(8936002)(83380400001)(2616005)(107886003)(66946007)(8676002)(66476007)(6916009)(66556008)(4326008)(44832011)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NucWVmPnvI/J4lIBNkv1A0EFNpcnGIBtWoJ2729Shsc6hms4MkFPQb6iC96D?=
 =?us-ascii?Q?tNAwgP7XqFCRR5DhU/RxGECx+m7q9qAoi/LSX8sUs5j5u32wlTGIBCpV8S+Y?=
 =?us-ascii?Q?/5m5uhshIAKNzuKlVv9Xd/Yq1fuxO7SyfREOFR8O2L0409g61A/SUYRLVC16?=
 =?us-ascii?Q?9HW1VX/im1vcN+eIZncJNe1Tr7MWz0kYPcgmhltiXj/57s+ucJ6Ricf9Zm3u?=
 =?us-ascii?Q?C+dlAtcaXnMNHrtqk1ws4uU8qhmMcoKVS0jpcBjp4jrxS2Fn//EkioyoCP68?=
 =?us-ascii?Q?1Hpl2vKaWh3ALNH9lJec6eYGqi4QSKCu4ydaG62u5k5rqRQrujp92DOVmDzI?=
 =?us-ascii?Q?fd+G1PFlJ/EqvSCa29j4j67zDp3ETEDA+NRX8XKBOq0bIYxsmFSsep4jfbiC?=
 =?us-ascii?Q?hrwdJ2Ob9GEj4JmVZsvD8nwCBTZMeYpmxlUMWWgPvEnn20wqbck8kMQECKNC?=
 =?us-ascii?Q?1soTMOGjIK9Ua8duPWrrD2K5wIi0/RHtQk6PF48eGcMDlFiVJQ+rzCy7Clpt?=
 =?us-ascii?Q?Bmj1fVz//vOpIUdh8qDmjCVI85Yd27DGcUcSMM2pHCCHNq69F5VPy+cTA3kf?=
 =?us-ascii?Q?okFm2PR1qOpqm9VQjsdraT5hn+2jjWdjPUB5ewmRCM3u1pyp85kWEj6dEsx1?=
 =?us-ascii?Q?SYcTqvhTYryscC+WHCR3M5uxs9DbPfklGdHcUrhwl7n3oh2QYCzNx+dY7/So?=
 =?us-ascii?Q?CZYOwzTmH9db34wTerBDY/i9a6hTZoJfC8ZzhGbLW6JOMtY7ofSBUsGxyQGo?=
 =?us-ascii?Q?DgYBe6Ec6RjIAiZuug9ZXy5WZ4J6vNhpxG0pDMyRyEcAFD8/U3own/TuJviA?=
 =?us-ascii?Q?lbqOfWr3StNy9LoTJMv49rBLmERsxS8F+0LtFdjS2nCXVAPX/JwUppvk+MI0?=
 =?us-ascii?Q?xeoNW93qBQ/T9UmvDK/va3KEruH92GIh/NqkBnWQ/eee84cX6mlVADaT4rnY?=
 =?us-ascii?Q?HWQ8chv5G9Y9/Ky2pzPHWmcp4OkwONxZ1fImnZlj3Y7cxrAC35G8N7aguJy0?=
 =?us-ascii?Q?po5UtUiXI6A6Nz4JlxNcoCOJJDvQ9QWPDIBcNlJ4970fIuL6MNcV6ME2w/9o?=
 =?us-ascii?Q?0u8xoWKgSpSks2ADinYXPC4p+OVymkP9P7hh9Wjo0rHhw/Xo0/XyI2wH5IiF?=
 =?us-ascii?Q?mU6z/R05kPfbbGDmwqd3QJXopvDvotF8Zyio65opZzu4EPVEC6oSjc/iDN8j?=
 =?us-ascii?Q?n+gQ9gLSUHYA71qt1NfZnf1QxgXO7pXpxSy8+r88wDbtzhNcQjDb54A9nU99?=
 =?us-ascii?Q?9HfzPBjjlJRBNetHja3/Yd/+RtOnrpOY4bl9F7BnKkT2PxHKN9VJG+RIH57F?=
 =?us-ascii?Q?0T4odRC+VB8OZFg9OYPwiSO7mJgO/4VF3xyfWmz5Ear5UfAgBHW6T2rADR0u?=
 =?us-ascii?Q?8830p/EavZr6he0Q1Z6NNW6gtR8o3iLQUFo0+jLvmKJBV/9aW75DhdN0bisK?=
 =?us-ascii?Q?0QwgHowegjW+ZRZMdr18fjKCiIWQLwtWwaud03AsASjiNK8Sihjl7BE1DmCR?=
 =?us-ascii?Q?4d+JXT8mYp3SuNbdam+mB3Vtxpukd3tT9wG8ASxfXljkSK32wMrhIY/dXyOL?=
 =?us-ascii?Q?aVhV0dexH5FsDRkLD7Zb6zRfj2tGsNPTehJDsKv5?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: IqL74x9icNAACI3nw9k6yB7bcQexyZd3hd79Sfdo37T7lGsdEHqRPByhML0G1Reo7YmWa5leVELwE5p3fZMOfOwrQpz3Q5cTlBjqvOjI+7ZvtSNeugAZKJmaD4DefE4jhg1vIkRm1SDsqv5MqnhWZjDdNoQ5azcdXZiSVPx7nZpg4HOYPFqNO43RozISpyDDIHwZqAsRD98B9ffoQ56Ux+jR3pi9njijYHDSg65VV5xfGr/rgbNyV18E04V4vaezkE2j4miuyNRn8b5w35pvGCCklT+8y5yD+lCg/QjWOon7W0HxYnKYEiX4DknpB/xa8WuI/W9xdmEXZ8ek/iChFM1dFTCcsTns2MdTS7MAKDlf5AlHKsJrTI2I5zK9GSp85dXiamEgmPn3zEppM2rnBimsDYpX8xFrciV0tkfjOWAU4gVqneAdh+cAR2Sz+o8fE2hoWpeGTcJ7aA6BxyEvEEzJSFGClapJfACSXo0JIZTgLMzkkzDQ5d+K2CV47pbe/+1ZcXH6uG9u70RBbtIURpygt1g7bklct4rMlV25hjJ2bknDQpis4fFKNDv6aatzobF7kIUQrYanlPXluPGETAPhrc3o/cIXj8IL823y1Z0b0Gt2PKXs6zRPVlcUNnQ5MyMcreXYnlzsI1l88e5DquGEWviQ4TFjdqh3XdyYDWJ5gYnyNwDE9f0RfoRJ6PjDNLRHxtbHf2umlmg7K4Xnz3PgCry89/0YX9DMTieYPjtU5mMgePvdGoWnFH/Mz7uJHOdENR9by1OMoebr9SAXSGXoZmGpENjqll7spMIEA3I9PKnco4UBSqBW11T9eunGsXt49wnmhhj3pwupQaw3zQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff1cd2f9-a654-41dd-d25e-08dbdb2e9723
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2023 23:02:15.5434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urSp5yMLo/fXpV32FG281fnx+cLO9D+MnBZjMWdSTCIS/XFRmT0X+BS4Hm6KqftMyCCOanAuC6PeqyAb9CWqWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-01_21,2023-11-01_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311010171
X-Proofpoint-GUID: t4mFnIwBpXcNCAsKMG3o7EWIYPLnVP4e
X-Proofpoint-ORIG-GUID: t4mFnIwBpXcNCAsKMG3o7EWIYPLnVP4e
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks like there is a race between md_write_start() and raid5d() which
can cause deadlock. Run into this issue while raid_check is running.

 md_write_start:                                                                        raid5d:
 if (mddev->safemode == 1)
     mddev->safemode = 0;
 /* sync_checkers is always 0 when writes_pending is in per-cpu mode */
 if (mddev->in_sync || mddev->sync_checkers) {
     spin_lock(&mddev->lock);
     if (mddev->in_sync) {
         mddev->in_sync = 0;
         set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
         set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
                                                                                        >>> running before md_write_start wake up it
                                                                                        if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
                                                                                              spin_unlock_irq(&conf->device_lock);
                                                                                              md_check_recovery(mddev);
                                                                                              spin_lock_irq(&conf->device_lock);

                                                                                              /*
                                                                                               * Waiting on MD_SB_CHANGE_PENDING below may deadlock
                                                                                               * seeing md_check_recovery() is needed to clear
                                                                                               * the flag when using mdmon.
                                                                                               */
                                                                                              continue;
                                                                                         }

                                                                                         wait_event_lock_irq(mddev->sb_wait,     >>>>>>>>>>> hung
                                                                                             !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
                                                                                             conf->device_lock);
         md_wakeup_thread(mddev->thread);
         did_change = 1;
     }
     spin_unlock(&mddev->lock);
 }

 ...

 wait_event(mddev->sb_wait,    >>>>>>>>>> hung
    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
    mddev->suspended);

commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
introduced this issue, since it want to a reschedule for flushing blk_plug,
let do it explicitly to address that issue.

Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 block/blk-core.c   | 1 +
 drivers/md/raid5.c | 9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9d51e9894ece..bc8757a78477 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1149,6 +1149,7 @@ void __blk_flush_plug(struct blk_plug *plug, bool from_schedule)
 	if (unlikely(!rq_list_empty(plug->cached_rq)))
 		blk_mq_free_plug_rqs(plug);
 }
+EXPORT_SYMBOL(__blk_flush_plug);
 
 /**
  * blk_finish_plug - mark the end of a batch of submitted I/O
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 284cd71bcc68..25ec82f2813f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6850,11 +6850,12 @@ static void raid5d(struct md_thread *thread)
 			 * the flag when using mdmon.
 			 */
 			continue;
+		} else {
+			spin_unlock_irq(&conf->device_lock);
+			blk_flush_plug(current);
+			cond_resched();
+			spin_lock_irq(&conf->device_lock);
 		}
-
-		wait_event_lock_irq(mddev->sb_wait,
-			!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
-			conf->device_lock);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
-- 
2.39.3 (Apple Git-145)

