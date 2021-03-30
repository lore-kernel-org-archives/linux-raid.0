Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D0BC433E0
	for <linux-raid@archiver.kernel.org>; Tue, 30 Mar 2021 07:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9667261969
	for <linux-raid@archiver.kernel.org>; Tue, 30 Mar 2021 07:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhC3HoM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 Mar 2021 03:44:12 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:57588 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230223AbhC3Hn4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 30 Mar 2021 03:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617090235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=LJCPpVP9Zw8tg546oeCTr1AKJRmx3xIoU2Z+JIn+DGQ=;
        b=dPaVA4G3NY2tKIweOPBFAJD4AQ6SZbgECpxWZNdEFf8sJF/IsDr6rG8VOMVjxdRZGdqM0a
        OAcpyoQS9HaxqkaawcAp2Wwbpw5Qh2rC7YxDfCY84DD7ABrqPALERzOOSqFXfzdEtIbVTc
        9WXFS7j+f9eDebBw+Zg/P827ZSSsfJ4=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2057.outbound.protection.outlook.com [104.47.0.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-NAP1OzQkNDOBVisq3jzepg-1; Tue, 30 Mar 2021 09:43:54 +0200
X-MC-Unique: NAP1OzQkNDOBVisq3jzepg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IbS7VKTIoLhytiNBRCLwwEiuAvyHW4ZEfoVN+zhKW2Z7SM3PU0F48efAacs3XsU58RZ4BIq5em+odqisjiL5iK7xibg+F9Wig02CmAdTWv1PPG/ylmUzo3SA215pN2SJ5WGi6o8sXOOlcDQZp9Lj1/EeGuyTiMSubncxBWtpvfCUkRYjz1enOIIk5F+4GxxsHtUeriAMIPSh1XwsglTwnHePnqqDJmrxOTNXMHJk8808Odgx5I08txGfcH71G38Y3Iw3JxffUfydqkjYuvxtK0m2is3TDBEBzZ7lJBa+efhNG783IadhgL0DmRfELaFe1rSMva3M/MrGlTIbU7b8Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJCPpVP9Zw8tg546oeCTr1AKJRmx3xIoU2Z+JIn+DGQ=;
 b=co8LDyaJwQEAkU/+rdR5mnTJiD4GchwqogHmxZUKGz3neCb0UsJ+cubi6pBzoK2ADfdib5Dsv4uUuh1l5zlAqfH8eEy3oXhCswT0QiPPSIwx1x+bpi0lWhWhjmaNp+RCKI5h32XIMlJJAhgeSKIIgSU9Ti1XyCCi54NAF5WjOFYwZU/ZBnzlM7DW8NRcGxJhxpB1Q9n/q5fTl4tGgLipErksG/3zRHKLTFP9xQKQ75ZdaDnzb5n+4GFhz6isIwTtkEQgEWJcQ2aP7orvZyptRJ1ZvR9ZefqgmiLGKziTEf/U0MMkcNH0CeBOVgJrllnwuVtB0CwJrafKM6NaTyWxSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBAPR04MB7270.eurprd04.prod.outlook.com (2603:10a6:10:1af::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.26; Tue, 30 Mar 2021 07:43:52 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 07:43:52 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Zhao Heming <heming.zhao@suse.com>, guoqing.jiang@cloud.ionos.com,
        lidong.zhong@suse.com, xni@redhat.com, neilb@suse.de,
        colyli@suse.com
Subject: [PATCH] md: don't create mddev in md_open
Date:   Tue, 30 Mar 2021 15:43:29 +0800
Message-Id: <1617090209-18648-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.128.150]
X-ClientProxiedBy: HK0PR01CA0060.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::24) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.128.150) by HK0PR01CA0060.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 07:43:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d3aeb89-0b54-491e-c82c-08d8f34f9025
X-MS-TrafficTypeDiagnostic: DBAPR04MB7270:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7270839077EBBD3789F7E33D977D9@DBAPR04MB7270.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BN4413xiFTtzzi3/WoX2cGT/S0xSbxKl/svRgIpiCkOfjV96lKxhoaRM/x30Kzsj4f53ju/RvZypeTT7RFSe3NMRi6rg+JboEb+MIfEu0qvBjDKiMyQOj+hgCaXINTbZ4kc8LdF9wCLnNYqc5Ub2XdvHm7N268zRf/GUc+cm85cvPrRlmvqdx73LroYdzReDp3d6fAPoaI40DbFc2/uMgdgz8AsbRmbvHKlNrNbIKq6stY2TZr9mz9pNgmvQPL75qYgctBWuu+60a5e37wOBClUPWF0W0nlwSMFro5AXMg+5NWwWC2v/3OUw553yhqRcfaPj5nPGewYopqkUh0WhNsY8AYN0AbXbkuGRbpvraJeQo6Ukww28QYoNDeYfdr3LLQoH0BJEDoq10xayhuew/29xVbp7YGSLEwDLUhEMG7IOlQSuP6SOQANN4I4xXZFDZq43oiWjAtdLmH5Q+pv/JDqTeCm9voZiVIJKPwpf6iph4jOC7pJ1SWapMaU++QifQ94orEfJHUit8KzR8uHb0ecc9nMccGyxNK74QTGzOk2XDodbjJo89RhdjLsTBoEBEr7HavIb2i9KIUU2tqnNjK/Wlxr7JsY6rG8CBavpc9qOzrTatYtDDj6/KgfLcuL/+sAmXrexTiG9Kcns6h6kTFAMnDbESfZW8XS3PEW49nz+PbwCwmcgK/RCR+pGymDM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(366004)(39850400004)(346002)(4326008)(52116002)(83380400001)(6506007)(478600001)(6512007)(8936002)(107886003)(2906002)(66946007)(36756003)(38100700001)(16526019)(186003)(316002)(6666004)(5660300002)(2616005)(956004)(8886007)(8676002)(6486002)(26005)(66476007)(86362001)(66556008)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tvpxRgOw1LAzrJziNRrEWKILKRBcMu4//S9YxE9OChAc/iuoijVPhW0eRtKB?=
 =?us-ascii?Q?oZbdkfii8C1kl+4Rj21q7pl6sfHQMVDm2EK34MOI5iIMPFOknTGOx6Ru5c41?=
 =?us-ascii?Q?lXye2oAEUjV/RIlO5pqqHBsdsc9Qqr6qoaDaied0Pogi90+IbWL+Cmn3NdDA?=
 =?us-ascii?Q?HJ6DYF7n1HSH0ouuTGt5HkNnGyQrIoYcD4wNyJFM44jo7n2L3aKhhplxMdnA?=
 =?us-ascii?Q?BB+4bXMgbWIDznDIRAOdar+G61oXd+bM5uPKuezXCW/VASIrI0nqVrY1OUjv?=
 =?us-ascii?Q?BLG5oXsu/J7HofIDEB+mjMBcJ3FnUZNnk2Y8YAoq0A9I76z13H3M+9d7hmVZ?=
 =?us-ascii?Q?1iDDzUKGFwwvvR9kHTCGVBLsr3K7wvcY/4zHbRa3RfXufMCsAd7MRLKnQGzd?=
 =?us-ascii?Q?73On6n+OipG/A6BQvfgGRT+hGpPtLcNoshHUEKd+kzmxS6Vt2cWaazUVJYog?=
 =?us-ascii?Q?/MEArpzY1zPDyft9tSz2lEMiy9iym9sRP+KII//G+Rlvfj7EwuHkRZdGaW4N?=
 =?us-ascii?Q?RnSMfIgOnLpXLFOwuhLSRKfVhzFlsCB0wJti3Lax7sAouvB9IlkDWjiOXnk8?=
 =?us-ascii?Q?NNPgGNKeucQbreyLhLXfjsQeRgKW+PlK1bJQWzBFh03SOBWCHRmHPJlHCHbN?=
 =?us-ascii?Q?ty9HBHfCaYzBmSVZY+WgiPCWu+15hbG9U8Zyk2CLoi0hh/jo+tCakborA8hk?=
 =?us-ascii?Q?I8YDDZBfOg6SbHiEQ1Tu3eDXYE3VX/FgGA2m6IWnYuI7T8RzbEaKE7zIMHJr?=
 =?us-ascii?Q?f43yzm7SgFCzJK/zUbedjEt1yT3Y7mZskS6uvqN26M9shiBDKe5Ffu+5zFeW?=
 =?us-ascii?Q?0s6e5qh5src9uz0BAj+AcVWxg50FlH+97QoEdKtrublkHlkXSUsWYDYdeqry?=
 =?us-ascii?Q?7mn8y2lZEMc2KJSYjZ4Ghp0xfWJZw5JgArOQ4YiIyOjEy7uix6ZczSY48T2L?=
 =?us-ascii?Q?/0zb/96tjUq6QHMWZu06/CnwGzOeDqsqeJd88z51yCNbUXc0SB6Ty3EQZtgf?=
 =?us-ascii?Q?muclUYQzsClMNHhp7C+DNAW4deMPhRkimrnMThtsyZJUI8qSDECAD4JnFI4o?=
 =?us-ascii?Q?D0vVZP0uAKsTWESpz/lwdh4lehAtt0EpfAcZWWxMYF+W4VmWymyYy/KUwDw4?=
 =?us-ascii?Q?WOQaPiLx0LBucxd8Iy66YMzKnHMtN7puG0Jwu3tpCZ/XBglEuphr1EH4HUvB?=
 =?us-ascii?Q?Km7Crp6vwTDHBkL4gwxfRiDXondl9bmKTZIkGhheKTJVl8e+sQkpXWJqbCsT?=
 =?us-ascii?Q?D9Xc6PzjcFpWH+YXgd1bUq53tejiSJWMGJ4zqYtvHo5O61RI662OsxjLu+zK?=
 =?us-ascii?Q?aRcbPBh2ErHwQnmpgx/V5dfO?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3aeb89-0b54-491e-c82c-08d8f34f9025
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 07:43:52.0925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kkt9F2NFV80GCE18hZEZTnm8OHstoR+S5DWdZH2swTx26drE6hUaoPqnmt2Yktb8i+lwH1O8lAsiczfE7EtKZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7270
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

commit d3374825ce57 ("md: make devices disappear when they are no longer
needed.") introduced protection between mddev creating & removing. The
md_open shouldn't create mddev when all_mddevs list doesn't contain
mddev. With currently code logic, there will be very easy to trigger
soft lockup in non-preempt env.

*** env ***
kvm-qemu VM 2C1G with 2 iscsi luns
kernel should be non-preempt

*** script ***

about trigger 1 time with 10 tests

```
1  node1="15sp3-mdcluster1"
2  node2="15sp3-mdcluster2"
3
4  mdadm -Ss
5  ssh ${node2} "mdadm -Ss"
6  wipefs -a /dev/sda /dev/sdb
7  mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda \
   /dev/sdb --assume-clean
8
9  for i in {1..100}; do
10    echo ==== $i ====;
11
12    echo "test  ...."
13    ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
14    sleep 1
15
16    echo "clean  ....."
17    ssh ${node2} "mdadm -Ss"
18 done
```

I use mdcluster env to trigger soft lockup, but it isn't mdcluster
speical bug. To stop md array in mdcluster env will do more jobs than
non-cluster array, which will leave enough time/gap to allow kernel to
run md_open.

*** stack ***

```
PID: 2831   TASK: ffff8dd7223b5040  CPU: 0   COMMAND: "mdadm"
 #0 [ffffa15d00a13b90] __schedule at ffffffffb8f1935f
 #1 [ffffa15d00a13ba8] exact_lock at ffffffffb8a4a66d
 #2 [ffffa15d00a13bb0] kobj_lookup at ffffffffb8c62fe3
 #3 [ffffa15d00a13c28] __blkdev_get at ffffffffb89273b9
 #4 [ffffa15d00a13c98] blkdev_get at ffffffffb8927964
 #5 [ffffa15d00a13cb0] do_dentry_open at ffffffffb88dc4b4
 #6 [ffffa15d00a13ce0] path_openat at ffffffffb88f0ccc
 #7 [ffffa15d00a13db8] do_filp_open at ffffffffb88f32bb
 #8 [ffffa15d00a13ee0] do_sys_open at ffffffffb88ddc7d
 #9 [ffffa15d00a13f38] do_syscall_64 at ffffffffb86053cb
    ffffffffb900008c

or:
[  884.226509]  mddev_put+0x1c/0xe0 [md_mod]
[  884.226515]  md_open+0x3c/0xe0 [md_mod]
[  884.226518]  __blkdev_get+0x30d/0x710
[  884.226520]  ? bd_acquire+0xd0/0xd0
[  884.226522]  blkdev_get+0x14/0x30
[  884.226524]  do_dentry_open+0x204/0x3a0
[  884.226531]  path_openat+0x2fc/0x1520
[  884.226534]  ? seq_printf+0x4e/0x70
[  884.226536]  do_filp_open+0x9b/0x110
[  884.226542]  ? md_release+0x20/0x20 [md_mod]
[  884.226543]  ? seq_read+0x1d8/0x3e0
[  884.226545]  ? kmem_cache_alloc+0x18a/0x270
[  884.226547]  ? do_sys_open+0x1bd/0x260
[  884.226548]  do_sys_open+0x1bd/0x260
[  884.226551]  do_syscall_64+0x5b/0x1e0
[  884.226554]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
```

*** rootcause ***

"mdadm -A" (or other array assemble commands) will start a daemon "mdadm
--monitor" by default. When "mdadm -Ss" is running, the stop action will
wakeup "mdadm --monitor". The "--monitor" daemon will immediately get
info from /proc/mdstat. This time mddev in kernel still exist, so
/proc/mdstat still show md device, which makes "mdadm --monitor" to open
/dev/md0.

The previously "mdadm -Ss" is removing action, the "mdadm --monitor"
open action will trigger md_open which is creating action. Racing is
happening.

```
<thread 1>: "mdadm -Ss"
md_release
  mddev_put deletes mddev from all_mddevs
  queue_work for mddev_delayed_delete
  at this time, "/dev/md0" is still available for opening

<thread 2>: "mdadm --monitor ..."
md_open
 + mddev_find can't find mddev of /dev/md0, and create a new mddev and
 |    return.
 + trigger "if (mddev->gendisk != bdev->bd_disk)" and return
      -ERESTARTSYS.
```

In non-preempt kernel, <thread 2> is occupying on current CPU. and
mddev_delayed_delete which was created in <thread 1> also can't be
schedule.

In preempt kernel, it can also trigger above racing. But kernel doesn't
allow one thread running on a CPU all the time. after <thread 2> running
some time, the later "mdadm -A" (refer above script line 13) will call
md_alloc to alloc a new gendisk for mddev. it will break md_open
statement "if (mddev->gendisk != bdev->bd_disk)" and return 0 to caller,
the soft lockup is broken.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21da0c48f6c2..730d8570ad6d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -734,7 +734,7 @@ void mddev_init(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(mddev_init);
 
-static struct mddev *mddev_find(dev_t unit)
+static struct mddev *mddev_find(dev_t unit, bool create)
 {
 	struct mddev *mddev, *new = NULL;
 
@@ -5644,7 +5644,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * writing to /sys/module/md_mod/parameters/new_array.
 	 */
 	static DEFINE_MUTEX(disks_mutex);
-	struct mddev *mddev = mddev_find(dev);
+	struct mddev *mddev = mddev_find(dev, true);
 	struct gendisk *disk;
 	int partitioned;
 	int shift;
@@ -6523,7 +6523,7 @@ static void autorun_devices(int part)
 		}
 
 		md_probe(dev);
-		mddev = mddev_find(dev);
+		mddev = mddev_find(dev, true);
 		if (!mddev || !mddev->gendisk) {
 			if (mddev)
 				mddev_put(mddev);
@@ -7807,7 +7807,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	 * Succeed if we can lock the mddev, which confirms that
 	 * it isn't being stopped right now.
 	 */
-	struct mddev *mddev = mddev_find(bdev->bd_dev);
+	struct mddev *mddev = mddev_find(bdev->bd_dev, false);
 	int err;
 
 	if (!mddev)
-- 
2.30.0

