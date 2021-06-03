Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3E4C47082
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 13:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD5556136E
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 13:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFCN4u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Jun 2021 09:56:50 -0400
Received: from mail-he1eur02hn2224.outbound.protection.outlook.com ([52.100.9.224]:37289
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229738AbhFCN4u (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 3 Jun 2021 09:56:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZOVwYo5LC/Zy0Xgd5jUJWwOPxhDvZlW4xZ67ROWS95DRbvtN4EGMxeY5vh6NtzCYPyLFGz+iXWPSKeqXYDLhMxytlIfIAQRaonleKn0fMqAGjlp4TxOhBA7x5BJONb1M0LBhmS5Njbf9VwTEZTjDo4/4CohMDIren4yNnEh5eLx0nCX9x/dxcCryzupgNEInuzwXhTmqVDkY6HJhV3XuSE6doV+8ajLcGqKkj7hazLsty57Egr7gPhVpE5Uv1/u1f5f1P4B2u1fd+leHaJLVpGsiCFZ8wmnE4f0LaIFraHXgulhV3j725qoQ1wRPbCRQ0ZZY6W/NQZezL1+mg/hoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+OEzyaoiVzysapU84n9oLW1wViuDQpckqujLs8PrjU=;
 b=gqjMdRmafMVjNy4BZtBEMAs31CdTfyTomSLLmP83aDsqoZ8dAxDbyWqllbOcuVn6J6wVVwWCiXNseXvAveq2n/JN/FkMaQTF5UTzmRnE4ugyXZgMIGR05XSf0xBcGWKkoUUsRJ2qKbOTwGQPJxWPFW33VAVprFx0a/hcm6+hRAzrHWD1pWVTSQtOEZBCZZqQcW/Jr5XWk1Y66qngubqIGQdhZWH1WT69B7SK7Sbf8WVkEIUfTRkD1AqRFPQet226G/cnL1VkD3kpwLkPG3DTL7vJqDkKT7IVSGtA62fs/OhhumweE6Bbf9zLfKS2qVo6aKpB994qpnDzk/h5OVWUkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=storing.io; dmarc=pass; dkim=pass header.d=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+OEzyaoiVzysapU84n9oLW1wViuDQpckqujLs8PrjU=;
 b=IQZ5rbO/r4R/3gJJTCSoycFv0/wPStit4ZOJrd1nKxYZ++3aPOSGWZ+kVrz6C+qF5rLr7ql8sZBlARhAvO7SgwdQ52S+NJy2MaO79GQ8NrQaxtc2i/nnrP8CmhawMA7NIIWT+EiswCkOCKyeupax60bnlyvY00uOMbVzxFYWz8CfPdaS2hOmpQ6PdxWygeYbsrtTJOi8QjCx/0nP/j/BTCFmUugaAHI3yjscCpjBEItnCxu9E4sdZ3EAaUjfxi8sI6qIaWDzownN1x+MC9/mAX64kLXunxk5ILEzwTJ3aWi8ZQzT6TBXzXUl7dV+CUVIRnebDM+X56mP2X3kqaIHrA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM6PR04MB6136.eurprd04.prod.outlook.com (2603:10a6:20b:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Thu, 3 Jun
 2021 13:55:00 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16%6]) with mapi id 15.20.4195.023; Thu, 3 Jun 2021
 13:55:00 +0000
From:   <gal.ofri@storing.io>
To:     linux-raid@vger.kernel.org
Cc:     Gal Ofri <gal.ofri@storing.io>, Song Liu <song@kernel.org>,
        Neil Brown <neilb@suse.de>
Subject: [PATCH] md/raid5: reduce lock contention in read_one_chunk()
Date:   Thu,  3 Jun 2021 16:54:25 +0300
Message-Id: <20210603135425.152570-1-gal.ofri@storing.io>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [199.203.113.198]
X-ClientProxiedBy: MR2P264CA0065.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:31::29) To AS8PR04MB7992.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (199.203.113.198) by MR2P264CA0065.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:31::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 3 Jun 2021 13:54:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44abfd3b-2b95-420a-e340-08d926972dca
X-MS-TrafficTypeDiagnostic: AM6PR04MB6136:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB6136D75A918A0118B304FA33FE3C9@AM6PR04MB6136.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 2
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xsuzIiakHLsvHuZ8I5oUZm76h+AjzrWrkCb/1uo6PepLJW1xZ/VI/WIRDPzJE987udWksIhleTk4xc1Hhp3QktxEXdO/N3aMqmRJwNUKxJO8NFc2FWaXEic8dhs9bqHbflohzocGFnHs6SllsxrcZI5+kz9d7jlbCJBARlWHSkZ53q8O/FSo/SsfK2vvPiHQ1OED/arZKJLZe/tnzRjUiG8+uwHyUkqd4sVn4NdxRPSyfvEBr88Yl/a78HX0mIIF+4hSQFD+uAqn3Orunr1PZQCqOSPZHQ06ZrTP8b/jx3pe7bGN4JI68ZLYm2HF+1ys4svfZsIxllVlQzWyTwLXZ7oogSbM9LfcyvWyvNGgdk6PUuUhx6LSk7edZWQogyY+imMxcb85aOMg8RxyeHZKu+VtSxCxt3AucZDfBo9tCkvbXma79mR8iKdN3xfD7iEXwyVCoAN8YYg9I1j5AXrKrLMBOIueCvLg3u0exUKBC8SdFpi5qszS7c2pa00nR4NusJxUFhqGFmg5XLpmHEp6N0KRs7oUSpfongoxjeL7EfpIiojvQgC6PqlCTgHmWjKtuQ53dfMzEl8IRybM9ZKRoCtBhsuFYd2sGByeUSdE5HwVvL7pCU4AvSEXFBTG13gaVdeowemkYrH1vB4IPg58yzBqdrFGnhDpQRSOOcZ0yiZxVTIs/3OKFFPU/vp6FNpcYMv5QQZimRft7ChdqQL83dMm3SvkXwSYl2OyQphs3MgkHY95P8dLsVrtxFrCF59Rodr3h/49xg+TrLZ4PdWW6Lndyf50f6dRuE+r+1MNR+PzgDyESNDnlkP3McVWv1a7/S48f7Gmu7dkC/hViztS7Qk+1QpfgxmHHVQxlwDTEPkD3Ym0Gr8RR0xqlD6rxzMp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:6;SRV:;IPV:NLI;SFV:SPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(396003)(376002)(136003)(366004)(39830400003)(346002)(38100700002)(38350700002)(6916009)(2906002)(66556008)(66476007)(9686003)(6512007)(6486002)(36756003)(186003)(6666004)(54906003)(4326008)(8676002)(5660300002)(8936002)(52116002)(43032003)(956004)(66946007)(26005)(16526019)(42882007)(478600001)(83380400001)(316002)(1076003)(1557600010);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?i+YlhfdG3CHNDHTCKLdCtcKMWzE3l1bXbMA71/j9hfS93p53OJs7SF0cCvej?=
 =?us-ascii?Q?yoYzk9BI+kQav6bnsYpplo6afofbViZzUB+CP6dUujfYkwK6uIBF8EIwRdco?=
 =?us-ascii?Q?nCHOaq64DxUSBPc9POMb2YQ2TmvrcN4F6wLaq+2jEtAl0sr9GAmiOCqTkJHC?=
 =?us-ascii?Q?UtctuXr+agd0WcE3vLeeTSeeANRqlRD462Aydz2Z2oMPwquYL1xmuaqERcmp?=
 =?us-ascii?Q?hk7lFghYuHu0hpVYeubtCGEKw588clrRWZ9YgRsIn/sAopyEdJAubg9AbYPB?=
 =?us-ascii?Q?ibUg7/8KQr+xy7DN8LTW9j0iYDV/JWGuKrD47LOUTytApYHma+1du4GVh9Qp?=
 =?us-ascii?Q?OLCTEg+Vkmin7rwatoVIK+xBcehG4bTU1ugJQgNn/Yl0ale1rRJDwoeiaz4g?=
 =?us-ascii?Q?DZmI+Rxm1i6/W4SQn9/61opJEvdmkrppIo2Xwnubrp75Eca8K1NMHbM4nAA8?=
 =?us-ascii?Q?OVSsmEmK4MnrxEG+caUA1xFzTqVmT9n4A/UZmUY78QaZ+yioTpX8hOsXQmTf?=
 =?us-ascii?Q?0+FBmd2qAuUo0/aMhdC073rOoGavREMVwDUKJDVOHNyJ6hCTU3rka2H0ebCk?=
 =?us-ascii?Q?ymGTvFI91rvSLrzwMXl4knabKIr3oTalEqfjjpDyLXxgLn5qHPojuHsHYvXM?=
 =?us-ascii?Q?lbFutu3ETiVZNZQutPXPht7J++lIfIUKem6cvFcDqwOGrjahGplSuphp5qk4?=
 =?us-ascii?Q?2FMeiVTB2VTDBqwR8fIK+c4P6cfYREXCnef69tFRGAnOb/QnOpNzpzBd6WqU?=
 =?us-ascii?Q?7aeLcULXdwl3AfVr6Z+K9YPfVm54HnZDCfGsQGpKt4Us/ILDSw6RiB36XJB3?=
 =?us-ascii?Q?CMJs/UvU0jRdXOzibAfjwvPwX+jnRgl3AydJaGpYzQ1TOOvihs/7kf0HU54f?=
 =?us-ascii?Q?Iwp55x7QGXDP9cGd7hDq0eAjGjOU8gN6UTUL2fFliFwDHkIqDZAp7XA+eub3?=
 =?us-ascii?Q?52/vhf8bf04TVUK8gUAGyPKhW1ckaUXa0tDX0zK6N5JYhYguTkDIS3aG3pC/?=
 =?us-ascii?Q?wb0M/5GALY5lTaKLK+O3DYH9y4qlD05j0P0XJDch8L0rDbYpQw+JQwFjs0xK?=
 =?us-ascii?Q?puTNC1827ewEdgM16hU04wqkfHUwjkVZnOuoStz+ooJsbhIbWZ74BcvO1WVm?=
 =?us-ascii?Q?meafMfnE5+7MIPjx5RkCZUz48kZF4PoHTLjxUCeBbyrL5a4ur6JVyELU4Pgo?=
 =?us-ascii?Q?FCceWQ/0M1n4GIA59zfGNPtmuO1TCIwfZS/x+x048Fd9u3McnBD6K3MaFiJe?=
 =?us-ascii?Q?IcpjHHT7BjF0d5yY+9PYEoh6WRBVVBM/VNJr7/Lse8s4r8wq1W8K7f0PD1XM?=
 =?us-ascii?Q?mLwpRkXLHvnl7T23PtVooKKg?=
X-OriginatorOrg: storing.io
X-MS-Exchange-CrossTenant-Network-Message-Id: 44abfd3b-2b95-420a-e340-08d926972dca
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 13:55:00.1686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pIAD5LjITDKHlePAUmK/mjEt2kskk8enES3JvDQ9toqOIfo47n+KHWv9BCWbXGZT34TmUXP/2PmymY7NO7vjIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6136
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Gal Ofri <gal.ofri@storing.io>

There is a lock contention on device_lock in read_one_chunk().
device_lock is taken to sync conf->active_aligned_reads and conf->quiesce.
read_one_chunk() takes the lock, then waits for quiesce=0 (resumed) before
incrementing active_aligned_reads.
raid5_quiesce() takes the lock, sets quiesce=2 (in-progress), then waits
for active_aligned_reads to be zero before setting quiesce=1 (suspended).

Introduce a new rwlock for read_one_chunk() and raid5_quiesce().
device_lock is not needed to protect concurrent access to
active_aligned_reads (already atomic), so replace it with a read lock.
In order to retain the sync of conf->active_aligned_reads with
conf->quiesce, take write-lock in raid5_quiesce(). This way we still drain
active io before quiescent, and prevent new io activation in quiescent.

raid5_quiesce() uses un/lock_all_device_hash_locks_irq() for locking.
We cannot remove device_lock from there, so rename
un/lock_all_device_hash_locks_irq() to un/lock_all_quiesce_locks_irq().

My setups:
1. 8 local nvme drives (each up to 250k iops).
2. 8 ram disks (brd).

Each setup with raid6 (6+2) with group_thread_cnt=8, 1024 io threads on a
96 cpu-cores (48 per socket) system. Record both iops and cpu spent on this
contention with rand-read-4k. Record bw with sequential-read-128k.
Note: in most cases cpu is still busy but due to "new" bottlenecks.

nvme:
              | iops           | cpu  | bw
-----------------------------------------------
without patch | 1.6M           | ~50% | 5.5GB/s
with patch    | 2M (throttled) | <10% | 5.5GB/s

ram (brd):
              | iops           | cpu  | bw
-----------------------------------------------
without patch | 2M             | ~80% | 24GB/s
with patch    | 3.9M           | <10% | 50GB/s

CC: Song Liu <song@kernel.org>
CC: Neil Brown <neilb@suse.de>
Signed-off-by: Gal Ofri <gal.ofri@storing.io>
---
* Should I break the patch into two commits (renaming the function and
the rest of the patch)?
* Note: I tried to use a simple spinlock rather than a rwlock, but contention
remains this way.
---
 drivers/md/raid5.c | 31 ++++++++++++++++++-------------
 drivers/md/raid5.h |  1 +
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7d4ff8a5c55e..afc32350a3f8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -90,18 +90,20 @@ static inline void unlock_device_hash_lock(struct r5conf *conf, int hash)
 	spin_unlock_irq(conf->hash_locks + hash);
 }
 
-static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
+static inline void lock_all_quiesce_locks_irq(struct r5conf *conf)
 {
 	int i;
 	spin_lock_irq(conf->hash_locks);
 	for (i = 1; i < NR_STRIPE_HASH_LOCKS; i++)
 		spin_lock_nest_lock(conf->hash_locks + i, conf->hash_locks);
 	spin_lock(&conf->device_lock);
+	write_lock(&conf->aligned_reads_lock);
 }
 
-static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
+static inline void unlock_all_quiesce_locks_irq(struct r5conf *conf)
 {
 	int i;
+	write_unlock(&conf->aligned_reads_lock);
 	spin_unlock(&conf->device_lock);
 	for (i = NR_STRIPE_HASH_LOCKS - 1; i; i--)
 		spin_unlock(conf->hash_locks + i);
@@ -5443,11 +5445,13 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 	/* No reshape active, so we can trust rdev->data_offset */
 	align_bio->bi_iter.bi_sector += rdev->data_offset;
 
-	spin_lock_irq(&conf->device_lock);
-	wait_event_lock_irq(conf->wait_for_quiescent, conf->quiesce == 0,
-			    conf->device_lock);
+	/* Ensure that active_aligned_reads and quiesce are synced */
+	read_lock_irq(&conf->aligned_reads_lock);
+	wait_event_cmd(conf->wait_for_quiescent, conf->quiesce == 0,
+			read_unlock_irq(&conf->aligned_reads_lock),
+			read_lock_irq(&conf->aligned_reads_lock));
 	atomic_inc(&conf->active_aligned_reads);
-	spin_unlock_irq(&conf->device_lock);
+	read_unlock_irq(&conf->aligned_reads_lock);
 
 	if (mddev->gendisk)
 		trace_block_bio_remap(align_bio, disk_devt(mddev->gendisk),
@@ -7198,6 +7202,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	} else
 		goto abort;
 	spin_lock_init(&conf->device_lock);
+	rwlock_init(&conf->aligned_reads_lock);
 	seqcount_spinlock_init(&conf->gen_lock, &conf->device_lock);
 	mutex_init(&conf->cache_size_mutex);
 	init_waitqueue_head(&conf->wait_for_quiescent);
@@ -7255,7 +7260,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	/* We init hash_locks[0] separately to that it can be used
 	 * as the reference lock in the spin_lock_nest_lock() call
-	 * in lock_all_device_hash_locks_irq in order to convince
+	 * in lock_all_quiesce_locks_irq in order to convince
 	 * lockdep that we know what we are doing.
 	 */
 	spin_lock_init(conf->hash_locks);
@@ -8329,7 +8334,7 @@ static void raid5_quiesce(struct mddev *mddev, int quiesce)
 
 	if (quiesce) {
 		/* stop all writes */
-		lock_all_device_hash_locks_irq(conf);
+		lock_all_quiesce_locks_irq(conf);
 		/* '2' tells resync/reshape to pause so that all
 		 * active stripes can drain
 		 */
@@ -8338,19 +8343,19 @@ static void raid5_quiesce(struct mddev *mddev, int quiesce)
 		wait_event_cmd(conf->wait_for_quiescent,
 				    atomic_read(&conf->active_stripes) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
-				    unlock_all_device_hash_locks_irq(conf),
-				    lock_all_device_hash_locks_irq(conf));
+				    unlock_all_quiesce_locks_irq(conf),
+				    lock_all_quiesce_locks_irq(conf));
 		conf->quiesce = 1;
-		unlock_all_device_hash_locks_irq(conf);
+		unlock_all_quiesce_locks_irq(conf);
 		/* allow reshape to continue */
 		wake_up(&conf->wait_for_overlap);
 	} else {
 		/* re-enable writes */
-		lock_all_device_hash_locks_irq(conf);
+		lock_all_quiesce_locks_irq(conf);
 		conf->quiesce = 0;
 		wake_up(&conf->wait_for_quiescent);
 		wake_up(&conf->wait_for_overlap);
-		unlock_all_device_hash_locks_irq(conf);
+		unlock_all_quiesce_locks_irq(conf);
 	}
 	log_quiesce(conf, quiesce);
 }
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 5c05acf20e1f..16ccd9e64e6a 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -610,6 +610,7 @@ struct r5conf {
 	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
 	atomic_t		preread_active_stripes; /* stripes with scheduled io */
 	atomic_t		active_aligned_reads;
+	rwlock_t		aligned_reads_lock; /* protect active_aligned_reads from quiesce */
 	atomic_t		pending_full_writes; /* full write backlog */
 	int			bypass_count; /* bypassed prereads */
 	int			bypass_threshold; /* preread nice */
-- 
2.25.1

