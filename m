Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1CDC47095
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 11:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E44E461107
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 11:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhFGLKD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Jun 2021 07:10:03 -0400
Received: from mail-db8eur05hn2205.outbound.protection.outlook.com ([52.100.20.205]:56545
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230483AbhFGLKB (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 7 Jun 2021 07:10:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oT+xXHgB3KLwQXKNrgIL9x91jh4shEzZEkhqqGVMyhXqpr6shqg+LiHm00FTrNI6pBxGAdqJRd7Ubc/sO/PVqxH2GSjVQA+kkdNZKRhjwsP8ioIJ6JJ318fBjPRoQbJdDlM6Amiv3fKp00Pq2dtmX4tgP9u96VoyVJ3KjpmD8x6RDevwQvVWz38JIWReiFJjSbyZ6sc0E9liYe6IS8FZEc0zKjRksRqwswQ+uXu9tTTSk2q3AS2zsDTluA5aGNeXs71CxkjeYtOC6XZkPqiD7j8gNTkv0F751BXmsQbQGkS8ep1pXkgQrv/qOMiXqM4zFSbjSxCX1r+0H0/NWhvwgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbIiJjlAm882gJJpSA9m857xmBSLPZ3W5MVLPV4VrcY=;
 b=Mv6eoYHCHyr3EKocuxpBUsCGPdl0kOnnA4KyEBlxZU1A8NRD8V5h+mKzFeMCUiLA1m0qMFuvft3yzEtJi0tsgbANxGaHxLLa6OB8cmZE2wOXSOnO/89nR9F6TEzC/Fh+WR5IcrE/qwrMi9r3I2PR/916aW1VSVxWBN1rK241W67OiHO7fMmR6dT1Oys4eTRMSM5vcv9FFCnpxLx0nziazYlHlUDlisDXAod04FlPwvk51PbC/zR84maRr/6Qu9d1UbK+2vcWP4FeRCbitFkEwmTHS/sHQ16nPBFAqQHtxhPntvNDuaXZctkt9Gl6MrQrNwhaM5qgu3koMqhF0g+0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=storing.io; dmarc=pass; dkim=pass header.d=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbIiJjlAm882gJJpSA9m857xmBSLPZ3W5MVLPV4VrcY=;
 b=aJ2mtH9McwrA5X488QC3BtmrWdvZhp4GGukTLcLn2DnGjUOFp4S+fgAIMgF/o6CLw55xOmGIdfQIGI/28s1S2eRU7YyGxX88RKEuM82WR3ijHDqDCerEKLTUznEl8H2RyielSV65O5K/Iya8792ZIPvhWZw/PNuAgtqi/qc9gTlr2GnuaT9pZnaqn338BuJFYQWfi/PSK1HPTgupcuGHnxzWW72Yum47QClrCcgrAHEefmOffq2gMt5vJvyvvT+PAtLYGDH1KvZ4/0MGX8Sk88QRJQ4DalQGyIr14bFIwdz1P8X4xsOvdbpOkAjpI/ms1e04f57Hjh1NW0d7zHuY2A==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM5PR0401MB2659.eurprd04.prod.outlook.com (2603:10a6:203:35::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Mon, 7 Jun
 2021 11:08:08 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 11:08:07 +0000
From:   <gal.ofri@storing.io>
To:     linux-raid@vger.kernel.org
Cc:     Gal Ofri <gal.ofri@storing.io>, Song Liu <song@kernel.org>,
        Neil Brown <neilb@suse.de>
Subject: [PATCH v2] md/raid5: avoid device_lock in read_one_chunk()
Date:   Mon,  7 Jun 2021 14:07:03 +0300
Message-Id: <20210607110702.660443-1-gal.ofri@storing.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <162302508816.16225.936948442459930625@noble.neil.brown.name>
References: <162302508816.16225.936948442459930625@noble.neil.brown.name>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [199.203.113.198]
X-ClientProxiedBy: VI1P194CA0010.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::20) To AS8PR04MB7992.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (199.203.113.198) by VI1P194CA0010.EURP194.PROD.OUTLOOK.COM (2603:10a6:800:be::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Mon, 7 Jun 2021 11:08:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 616edd57-9246-486a-c0ad-08d929a487a0
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2659:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0401MB2659A8C415CA77E0020230F7FE389@AM5PR0401MB2659.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 2
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cf5YUXt/CrQHvs5n8c+CVNrl48VXTF/eqJJAcyTN8JEEzZ6Uj0DVAXiRCGCu8Znp6SUpsotV8ybhboOeRAPf3MbjHu+802k5XHo0IvXlrTJYv0jrRa9XU8aB3/UhwJmh1ZNaSeL3ksrIxKTyq5/ytL+k3GJoM9+ZE/d5gFXXEaA9D12N0iqVMbBi8dnFO1iiohRJXhCD72UgwsRQN396356C6rUqzNc2ootzQXGstPXO1We02EdlIVpNrkvYNhJoVxAeBhRQG2fKOPem7u5mrkLVDk0Y6dK0k5o8Hkdx2Pn069xr+jMR65iJThPedDKzMAKtehthh9g7EzujO2s9Vee4VU4ZCn9070/ub/C3IwIAgcUBUC2/42jlvBX5lQtvEn0bB5UM3+RKWR0agPgdjnIu3dTCkGbyhSZyNonQBqlUVd79+CDO/d8RStO2iKqPuqC+0yfdc0tzRe/lmAuw3Isl9z/Bmx9XRkrfshE0roWX7Kvxr6ZBZj/JVOJQ94OE6B3Gy/2PpHzLZKeSgg4NUxFroOMaatEZspVuYAssrI79oEeEcD/7FRRB3XSuDkTlPRFlxKWjmAlAz+heT3FHMjsIzllNNCeVXTzKOKMdPgrNCyY5rs34H8Xp7B50fRNhXSwvkGs6k031i++DE8jFwiAFCzKHjpYCAH59GeQsZn5egp51zDiKEvuttv7weS9YQYSYma2t5CEz0wxI8HekFyVxgpcTm1VDd870g/zx7Yp6Eb0IOBsPphJqkUr3HifJMcNxuGTHf1sfDlD5BP+jTXWahHpJstMDEfFvm6dZLHPhToxgxyTesdynAEuPSbsBNbcRwuejbbInGDr8vo3qCG885RPeqXBcPGRblfblDdQvlrXInvwUCUrf6GA+HqNN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:6;SRV:;IPV:NLI;SFV:SPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(396003)(39830400003)(346002)(136003)(376002)(42882007)(6512007)(1076003)(9686003)(38350700002)(38100700002)(8936002)(186003)(956004)(2906002)(6916009)(43032003)(83380400001)(478600001)(52116002)(54906003)(36756003)(316002)(8676002)(26005)(66556008)(66946007)(4326008)(66476007)(6666004)(5660300002)(6486002)(16526019)(1557600010);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6JKBeG7dmPZA0PzFrc25O1VmgPvZLyYI40E7gJdbqiAUfqMQnl7SBpizlq0l?=
 =?us-ascii?Q?FVe1QehfaLyOZeyd6X3jPj0SvhEfOl3Jo3tMy+X83jzHvCG9wGIroMAP8x1D?=
 =?us-ascii?Q?B999JiovU4Ve/Bx6I7lqRi4NyueGeidWmhyFWBrcSoKPUeXh5YAY/yBLQWWf?=
 =?us-ascii?Q?q2ZAyuzKwIZI3FshhKHFqOtSxc1Y/4cH+dPTXioUT4Wsm/cxhoRv3KQ5J6Eq?=
 =?us-ascii?Q?rfU8yvlhynTnmOjbVqluPTLmmmfAdg7Pp5eh/CEn0Kf1S8cpZuJvjNfgnpJB?=
 =?us-ascii?Q?s2BgM+7gBgnkpJpP+iS7g4L0J6VCr+9fbpvDgcyxmJt4UGwJl40dkXq+mz2f?=
 =?us-ascii?Q?5wEjV90AGbDpiVnR5KrAFbacRQbYITQWAwVjQ3HNkzA03x/YnIBwueTwji2L?=
 =?us-ascii?Q?QVOthqQx8YGeL4YxomWzaQyiC0XOWYgmzwGZc3LG7SXzn1ED4EHmVTedWmxJ?=
 =?us-ascii?Q?+E+Cy5Gz3eLgi0ACWN6Hbkhj3f2kUQw7n76uQ+TBR/FPNECt14e6furJJL8Q?=
 =?us-ascii?Q?i84nD0zKLbht8g/wW4qJEq//evMmGHBZbga4BSue+GRw1hq6xWO/Db9Zj6ND?=
 =?us-ascii?Q?iVSJtAZkDn/heKtI+1rsm2+oEZBkldR9dCiK1t2sc8HGta2wjgIvyXxvakzA?=
 =?us-ascii?Q?kdrg+5fZxQwiRRjDKheyZWybSW+XpkuMiYpgi9oznOLaubt7by4b3sUdMmF9?=
 =?us-ascii?Q?HhVk/jnpTC4sjvgmxvRLNy1WBbozxpjweRCMj440u86e6ogLtFij3me8/v5u?=
 =?us-ascii?Q?HSn7gZ2PK2RIVDrddQKj1gIK0CgqB40u96n1uri4uors42Rt8+9izuuOk4wj?=
 =?us-ascii?Q?ewNLe4+RqzaMoEPdLObDhLaLWWGQJNkboSZtTQwskFMd91Ww+g4ogH8X5MJ9?=
 =?us-ascii?Q?6uWeu0QEu2u92QV82XMdy9oK/I8Ln2Qu1hUZ+Bv7C7VxivNgdgEDw9uURujh?=
 =?us-ascii?Q?/HVivgDayDAIkbbMPe7YFt8qMaYMlz1PEv4MLKayR9Ugz1cBn8l4FbIiVq3i?=
 =?us-ascii?Q?iuSUioatDHztE5HaP9NyAJwdhnQxyol46lznDCUfln2oKD81hQqnWojQjXCU?=
 =?us-ascii?Q?c5m+7HzJ7CTT23+T5g+XRtfwPu6KzMSqVQ9kLXKvqWnBamffr2lWZi+fUKUe?=
 =?us-ascii?Q?jOD9TV45EHr9TxT32BU1X4AhRLcbbATt2ZNkvXOnPlc4vb7NQ+P+aKgWddph?=
 =?us-ascii?Q?nNgCu2c3jue4CKrtgMfI7PZ0HpXxfRAbybUlas7HoX8e/tQ6xEEhZMu0aDRD?=
 =?us-ascii?Q?8XmA9i8CaWUdP4jahKCYhiVubK9PQHMqhpB/rKk93yoz0eoftZV2iaTWY+1m?=
 =?us-ascii?Q?+MGCCO4s73kFCLT4Tg0ySrYr?=
X-OriginatorOrg: storing.io
X-MS-Exchange-CrossTenant-Network-Message-Id: 616edd57-9246-486a-c0ad-08d929a487a0
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 11:08:07.9337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ne6MTyG7xy5w6jUDoRi93+/6qfoxIUXNBfOO5bsbAaM7rE1DOrXQr5Z5Is8sSIkurRyTGdv/N7fdnRlddadzRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2659
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Gal Ofri <gal.ofri@storing.io>

There is a lock contention on device_lock in read_one_chunk().
device_lock is taken to sync conf->active_aligned_reads and
conf->quiesce.
read_one_chunk() takes the lock, then waits for quiesce=0 (resumed)
before incrementing active_aligned_reads.
raid5_quiesce() takes the lock, sets quiesce=2 (in-progress), then waits
for active_aligned_reads to be zero before setting quiesce=1
(suspended).

Introduce a fast (lockless) path in read_one_chunk(): activate aligned
read without taking device_lock.  In case quiesce starts while
activating the aligned-read in fast path, deactivate it and revert to
old behavior (take device_lock and wait for quiesce to finish).

Add smp store/load in raid5_quiesce()/read_one_chunk() respectively to
gaurantee that read_one_chunk() does not miss an ongoing quiesce.

My setups:
1. 8 local nvme drives (each up to 250k iops).
2. 8 ram disks (brd).

Each setup with raid6 (6+2), 1024 io threads on a 96 cpu-cores (48 per
socket) system. Record both iops and cpu spent on this contention with
rand-read-4k. Record bw with sequential-read-128k.  Note: in most cases
cpu is still busy but due to "new" bottlenecks.

nvme:
              | iops           | cpu  | bw
-----------------------------------------------
without patch | 1.6M           | ~50% | 5.5GB/s
with patch    | 2M (throttled) | 0%   | 16GB/s (throttled)

ram (brd):
              | iops           | cpu  | bw
-----------------------------------------------
without patch | 2M             | ~80% | 24GB/s
with patch    | 4M             | 0%   | 55GB/s

CC: Song Liu <song@kernel.org>
CC: Neil Brown <neilb@suse.de>
Signed-off-by: Gal Ofri <gal.ofri@storing.io>
---
* tested with kcsan & lockdep; no new errors.
* tested mixed io (70% read) with data verification (vdbench -v)
while repeatedly changing group_thread_cnt (enter/exit quiesce).
* thank you Neil for guiding me through this patch.
---
 drivers/md/raid5.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7d4ff8a5c55e..f64259f044fd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5396,6 +5396,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 	struct md_rdev *rdev;
 	sector_t sector, end_sector, first_bad;
 	int bad_sectors, dd_idx;
+	bool did_inc;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
 		pr_debug("%s: non aligned\n", __func__);
@@ -5443,11 +5444,24 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 	/* No reshape active, so we can trust rdev->data_offset */
 	align_bio->bi_iter.bi_sector += rdev->data_offset;
 
-	spin_lock_irq(&conf->device_lock);
-	wait_event_lock_irq(conf->wait_for_quiescent, conf->quiesce == 0,
-			    conf->device_lock);
-	atomic_inc(&conf->active_aligned_reads);
-	spin_unlock_irq(&conf->device_lock);
+	did_inc = false;
+	if (conf->quiesce == 0) {
+		atomic_inc(&conf->active_aligned_reads);
+		did_inc = true;
+	}
+	/* need a memory barrier to detect the race with raid5_quiesce() */
+	if (!did_inc || smp_load_acquire(&conf->quiesce) != 0) {
+		/* quiesce is in progress, so we need to undo io activation and wait
+		 * for it to finish
+		 */
+		if (did_inc && atomic_dec_and_test(&conf->active_aligned_reads))
+			wake_up(&conf->wait_for_quiescent);
+		spin_lock_irq(&conf->device_lock);
+		wait_event_lock_irq(conf->wait_for_quiescent, conf->quiesce == 0,
+				    conf->device_lock);
+		atomic_inc(&conf->active_aligned_reads);
+		spin_unlock_irq(&conf->device_lock);
+	}
 
 	if (mddev->gendisk)
 		trace_block_bio_remap(align_bio, disk_devt(mddev->gendisk),
@@ -8334,7 +8348,10 @@ static void raid5_quiesce(struct mddev *mddev, int quiesce)
 		 * active stripes can drain
 		 */
 		r5c_flush_cache(conf, INT_MAX);
-		conf->quiesce = 2;
+		/* need a memory barrier to make sure read_one_chunk() sees
+		 * quiesce started and reverts to slow (locked) path.
+		 */
+		smp_store_release(&conf->quiesce, 2);
 		wait_event_cmd(conf->wait_for_quiescent,
 				    atomic_read(&conf->active_stripes) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
-- 
2.25.1

