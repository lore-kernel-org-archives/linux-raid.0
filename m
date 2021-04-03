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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5853C433B4
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 03:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9728D611AE
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 03:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhDCDBv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Apr 2021 23:01:51 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:49620 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231256AbhDCDBt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Apr 2021 23:01:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617418906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=sKGc7xEk9PBPhLFKOpn9UM2M7+9qegprIYPQC49kn50=;
        b=TPHRG4+2hFS5z4uInLdyT2X42pORqarFryr9JnQY99/ZZB0jHfeBmB9O0++AW5Uk8luY0l
        GifaAdhqMKmzI3F+3wweDTC1g9le48gLiYXoCf3NVvGURZKn5TooBkiTGD2hYSi4SlBbIh
        90q3PJtD0a99wYAoc2wWuGY36Z2lxw0=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2050.outbound.protection.outlook.com [104.47.13.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-ot75l8bkMzGBs0b8VXPxqg-1; Sat, 03 Apr 2021 05:01:45 +0200
X-MC-Unique: ot75l8bkMzGBs0b8VXPxqg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLmt6MOxjazipOGIRqmVO2WcLGMYqkhp1shSGDY8KJ6y5Bjx8KN/dyLSOME1FS9w+kMe4tOg5vY+1R+ZlXCCI6xErCgh3Kyl0stQe5LzsiYWZM/3ehttsn5Q28PTW+Wptw+NqgtyjBPgOMxm5c6yhmJHZHeFkn4N4nGhb89fx0My42BSGIyxyW2DcG7Spds9ABqRIM0BmPRs3/o7LRsqCr9co6pGhJMJhlLNuNFrlJEY9SS9gz6eBDa0sEEOH/bdep73fhpbzUXJSut2vzPFq0Dwkz241YhSYykLfjFObHZX1//rcsYCHeby3vcddN5s0xff6BOYZQSTcGUtf8+RPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKGc7xEk9PBPhLFKOpn9UM2M7+9qegprIYPQC49kn50=;
 b=O0VpKCKRO8d7SkLj+pNEgJbpQ4ef5iHaBxKiibm2vgvxil/6obhBwyF9W3OjqtK+zt1WAMR3qznIBPt4BZ446F5FOWYvPv6jGh7Oihz6i0Zc2mMPeJWVLgFPYENci5tnFSzf5R2MPVuOJrqFEL6IApio7ihpkOPSmmBCuZcQ0r0jFPSExdcQAvEvIndb5+OXCsQHv6S0lRQn1B3yFS952U4LcAw0Yrsx07LvufBrDtGe8+ZeKDnV3JawRiH0a48CnUdyNT2bhmZwxISucL8LD/eG/zDz0Iqbe6YU1gIMoX1H9nNYLkWhVoCmjY35ss6IBt+54NpY9ZlTAWnWMjevRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR0401MB2631.eurprd04.prod.outlook.com (2603:10a6:4:32::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Sat, 3 Apr 2021 03:01:42 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.029; Sat, 3 Apr 2021
 03:01:41 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org, hch@lst.de
Cc:     Zhao Heming <heming.zhao@suse.com>, guoqing.jiang@cloud.ionos.com,
        lidong.zhong@suse.com, xni@redhat.com, neilb@suse.de,
        colyli@suse.com
Subject: [PATCH] md: md_open returns -EBUSY when entering racing area
Date:   Sat,  3 Apr 2021 11:01:25 +0800
Message-Id: <1617418885-23423-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.134.184]
X-ClientProxiedBy: HKAPR03CA0015.apcprd03.prod.outlook.com
 (2603:1096:203:c8::20) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.184) by HKAPR03CA0015.apcprd03.prod.outlook.com (2603:1096:203:c8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Sat, 3 Apr 2021 03:01:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec01cd69-7a7f-4ea0-f5fc-08d8f64cce7d
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2631:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB263197F805607943C091A95E97799@DB6PR0401MB2631.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +IZ6Z4jbsNZDgcIDoAIyNq1a+fTpu+nqIT1LedgiexyHimZPanjtLDNYrm4ReHl06UwL420BKrRVmtfz5eLURGXfJl76U+FRDmy6Sx5xwTWEBDBjcSLs5VU6GxL9B53qZGr/7g00HokH3OxGVqrxJ+mSjIiBdGnX5YHT+Y3KDUL7RaxtFvCn00cdKcvG2e1dKkdH4L4cKfQ0q6w15oHjiRl7JQS59BvaaY5QyN+XkoQ+8jLae2IwZ3cNN6sgEBHyUDQWgng+xHIMki+yZvpbGLQ6izxEO6RkatVuxI+jWbVQ9rYgdsiQGgliZZoiaAp44Ge0wEUq9SSMEAbUi1RL/cHKZx6YJ9fRYgE28XPNRq3al36cqybbMcKeiUd410ZAfb5hhp8S6ZGbKg2JV2h8sq9PoHSDvGlqRiQV5HDQQxu1seABHIsUrqjqwpSAeFTbLy9bMvYZJH6crFw6pQAMmP3qUlBNE/vPqQ6GnY6Whd4SYngfLaqNQKWQDsaxrteqTS3d9kmucf0exKNrxe5P5Oqxz2d4sURtNzfuXOAoG4M+OFtLH4F+4uvntSvDn8QYhN7qUZUuBK1Kt0CxXYCKL4d5x09nZG5ECGVjLaM+agCLV6WeilEeB+v2iufBWv/BXL+MApo5QqrHDuV5ixIjnd1ryDTuLf8jGNT4XHLCmFLNkgsvN1GLLTnXeRW2cDwC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(8676002)(6512007)(8886007)(4326008)(6666004)(52116002)(86362001)(316002)(5660300002)(26005)(107886003)(6486002)(83380400001)(2906002)(66476007)(66946007)(36756003)(186003)(38100700001)(16526019)(66556008)(6506007)(2616005)(478600001)(8936002)(956004)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lrg1fdIKT4FntL1z2hC1qnVVSKqbxAaK9kGeJmgkc6q2SFwnK4zRnVwB7RSF?=
 =?us-ascii?Q?qRT3Gm5dtfmqendrb9pWn7u8B46udh3ESlTnDEIT83RMLrz8JHcgoDA7RR0m?=
 =?us-ascii?Q?C5GQGE5shiXf7EG4eFCSx8K38BtOcGfDyGYtsn09yn/co0pNQpBKAna2GgHM?=
 =?us-ascii?Q?QA2lEcGsh49AI2p5bFxHqJ4B+lAFKKkLg3STiRiGPhMZmapofwJJ2HWEd1ej?=
 =?us-ascii?Q?M8EppI0QzqrqTUP6TVSMEV11sWJqhmSmG+/LyIKRAg4JZRFXiSNp07x1z5wn?=
 =?us-ascii?Q?2kJhXcU/qcVWFMQcUyMwF6ZJETmCABY0d9qpdUR6g1vHeC9Vd/XnmZKhOEZC?=
 =?us-ascii?Q?OHEVPikN3/FrCV9H+A3K/J+e8HrrKS2iQH7UUjzLe/bHwYUmFuRMOpb+bBF7?=
 =?us-ascii?Q?4QhXyGmxkS76XJXmOPwccRf81BprF0AZYxA9M4AbZPD5QYb3HRffxmAmmFEf?=
 =?us-ascii?Q?/eYPZBjWhchbYiWtQnBtEM/SW6UKrkS6rhYwZXn7rj/HSQyfhgPHWHTfnOA4?=
 =?us-ascii?Q?Qa658SAMSBI8TrHiRf7271gD25olWCPggUiZRzDZ+tj78zH19hvbYDY7h52m?=
 =?us-ascii?Q?q/h1IF012P9kxyeN87BZ/pYzJ8UIfavffbj/CunsokiVLjvK1sApqN8OgLzO?=
 =?us-ascii?Q?SNG1WH6XvMtb5iVM+LwyWOi9It96k82qx27IC5bd64IHJTuetFYxjVIqHxmZ?=
 =?us-ascii?Q?xCoMa9eFK445pmz6X9XvYQDQF9ZBatzksG6+3P5cM7ylnWDQoA+X248lfymI?=
 =?us-ascii?Q?NsAOiRn8rionpqQg3oBNxQNs+B2yhFVo77OPEfDgcbKHuoCuUfULcC7ljTyv?=
 =?us-ascii?Q?JYjIQzOnWuOrkCWqiJwdlK/ILui1oYCsjZNjR0dnUvZeCxJSo7WaH+PWK8fq?=
 =?us-ascii?Q?3Xd63z+KDL551UjcvzsQP2CxKCvGcSZLVXibOq1efoDxWqTYLYaZ1Cq/t/3p?=
 =?us-ascii?Q?Zt4VYOdNjY9/AQaSRH9fHXzoCcD1ahyPHlDtTAY1zf67T1MzG6dExwCac3aN?=
 =?us-ascii?Q?qpVXX/n2ONGmPmHFAvprK47DK4Bo/+Joi5nGQtkSwKlJR8nvHZ0bCrbyH87t?=
 =?us-ascii?Q?ybzDNkaB2dmkSpw/fHjhhqQ0dvHYvtIKfEagrnQa1duL8tncZvV3HUhP7RHt?=
 =?us-ascii?Q?5a1pK3y8FoNYlBUMSBuk6L3LHX1N+97XbxqAOCP87JgQ4OGWtFNPIalx7WHT?=
 =?us-ascii?Q?p/ApEkcdCiWunLMArgCP6fj27vxQwq5BkzIbQKPyAHeL/Tl2I3ViYAbNgS8L?=
 =?us-ascii?Q?xRrLMIWf3GEbmO4edmdzrLMsWiKw6VUdXCOlCE9ynj1HMOUvwLQZAy7tL47M?=
 =?us-ascii?Q?XKHlXL9oWScWuUSQvo/9hahF?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec01cd69-7a7f-4ea0-f5fc-08d8f64cce7d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 03:01:41.8781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQkK/uA5zou/uPx8TjzxFliIJKr30xf2XJDA2pmk47DXnI9zIDQ3aL6Ge/xnCNn2SFLvcwWxIaV+gJqsDD9jTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2631
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

commit d3374825ce57 ("md: make devices disappear when they are no longer
needed.") introduced protection between mddev creating & removing. The
md_open shouldn't create mddev when all_mddevs list doesn't contain
mddev. With currently code logic, there will be very easy to trigger
soft lockup in non-preempt env.

This patch changes md_open returning from -ERESTARTSYS to -EBUSY, which
will break the infinitely retry when md_open enter racing area.

This patch is partly fix soft lockup issue, full fix needs mddev_find
is split into two functions: mddev_find & mddev_find_or_alloc. And
md_open should call new mddev_find (it only does searching job).

For more detail, please refer with Christoph's "split mddev_find" patch
in later commits.

*** env ***
kvm-qemu VM 2C1G with 2 iscsi luns
kernel should be non-preempt

*** script ***

about trigger every time with below script

```
1  node1="mdcluster1"
2  node2="mdcluster2"
3
4  mdadm -Ss
5  ssh ${node2} "mdadm -Ss"
6  wipefs -a /dev/sda /dev/sdb
7  mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda \
   /dev/sdb --assume-clean
8
9  for i in {1..10}; do
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
 drivers/md/md.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21da0c48f6c2..917365fc9c47 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7821,8 +7821,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 		/* Wait until bdev->bd_disk is definitely gone */
 		if (work_pending(&mddev->del_work))
 			flush_workqueue(md_misc_wq);
-		/* Then retry the open from the top */
-		return -ERESTARTSYS;
+		return -EBUSY;
 	}
 	BUG_ON(mddev != bdev->bd_disk->private_data);
 
-- 
2.30.0

