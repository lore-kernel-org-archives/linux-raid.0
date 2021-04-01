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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5AEC433ED
	for <linux-raid@archiver.kernel.org>; Thu,  1 Apr 2021 01:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 293016105A
	for <linux-raid@archiver.kernel.org>; Thu,  1 Apr 2021 01:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhDABfg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 Mar 2021 21:35:36 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:30978 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230385AbhDABfZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 31 Mar 2021 21:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617240924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=NU/142njraHvgAOjLKKh8uOQD1fqHXCB5Z3RP372ttc=;
        b=XLGRdsZ4hxgcb3i0pOlJsfdKemXs/bk1YvfON9xO0kWGLFd91Vf5uqxIdIoHjisihK7MSO
        NUxnCfaqFET8vgWtJCR/ZcaVmcEHDxSxatCWcg2+mExVbMbGfL/5QPNfB9O/vvKAcmrXv4
        reYOf+jtR4I90JJ1KACMyBiXw9+2syQ=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2169.outbound.protection.outlook.com [104.47.17.169])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-ejhCbi6LMECxbaTi_mwcpA-1; Thu, 01 Apr 2021 03:35:23 +0200
X-MC-Unique: ejhCbi6LMECxbaTi_mwcpA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZwPR3AExVzosLxX73q9GctHTPZtt9hsTTT+0JO4hk7gEkSecb5D1t+DWh/E7Iu89PDlGyCnetY4qddaLM2mDH0ccnvSK//vmp9VMqvVEZOP0bz93Xxkh5/oOeGmdj3F+JXLnczSb6wvRf78xDXJdgfISdiD//Ypiv+yvMPPDH1SiX2QwirDb8nFsIOqtsQzC/BdpOoxRXgK/ZNTkqfnnF8waC0limnY0B4EbNzgP/KuALEh+27XGjwErwkVBmDB0oOrzWvgJObvuMIfsP6soKeRIse5OkBUDC3gSIoGLkaXoe/UmgosiMT+/uGpHbr4YowJ5IkN4AM25tXrgFhasw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NU/142njraHvgAOjLKKh8uOQD1fqHXCB5Z3RP372ttc=;
 b=FOUImjmLScYnRljQ4PlRLBt9dtjhWechj73B9TL4H0+K8SWV5Lt+Pm81F6K89qa6BH1OCOPj2I9FOWbayQ+zn8qgnsuuAUb/VCmCURalgTGb6N4UaJZTocTfPiBpxgdnta41XJnKDZO91LuVKlm0Qu2DK2V53dFh9TJ7YLdQIFpplRGW9FQ2CxvNmRiSAPOAv1WCG9N5gYGAt289D3rrAwA74KKA80koXQEValJlxlvU1cOYvryzCkwYS07ZP9R6O1TmYzB8l9snDXNp15pDlrkX+ZhAYY2xHBQaEioFM/f/TAv6KZtfBcez2JFJ7nbJPXbqGOEqO0eFrWFe9EzOsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBAPR04MB7462.eurprd04.prod.outlook.com (2603:10a6:10:1a0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.28; Thu, 1 Apr 2021 01:35:20 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.027; Thu, 1 Apr 2021
 01:35:20 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Zhao Heming <heming.zhao@suse.com>, guoqing.jiang@cloud.ionos.com,
        lidong.zhong@suse.com, xni@redhat.com, neilb@suse.de,
        colyli@suse.com
Subject: [PATCH v2] md: don't create mddev in md_open
Date:   Thu,  1 Apr 2021 09:34:56 +0800
Message-Id: <1617240896-15343-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.134.184]
X-ClientProxiedBy: HK2PR04CA0080.apcprd04.prod.outlook.com
 (2603:1096:202:15::24) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.184) by HK2PR04CA0080.apcprd04.prod.outlook.com (2603:1096:202:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 01:35:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51f699b9-d32f-4faa-3202-08d8f4ae68a3
X-MS-TrafficTypeDiagnostic: DBAPR04MB7462:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7462DB488C721B93D7A60F9C977B9@DBAPR04MB7462.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C5m83823psj1wuPWHHUUQ49rNRoParRCkyCBy4t/IhmO6vA/WhDo5gdc/xItoJ+hTK5d+/8GNZaceq+YGVbHCm32rn7FEez/T+mUKedBCKBzHYHySCs1URLNYnU8xhDR53Vm9s0wlyljP9wKHquhvA3D0izk7W1f1dGCCvxfQmpch0oqWBf6UzmbjVXWRtsKMksl9vUSZ+QwIb101FF9tfzHTZ2BvNW74JXsbKHGf+gNL7Ih47dpETAFSbcW49o6OobKA1xUVd8nhSewugRfWQPuzr5WtZJolJWfi+vYeJv1DyETBW1QZl2JhUONljt0wVWwU7rrHCt72CmxECuW/061mhGJFcdHfQI/mkhiUUS9y2aSiMdS2vaAuZwt46/Gr+G72v/1pxK7jjUGIOCGSmLlODPLsfNiZe+yzHGWtNhWq0mIdwg/Ci7rYZAnIwvqHFUsIEyCG8DJ43gz/Mp56HCYMWUv+NANb3p/fOa6dAXw4zREphqAKRlwnt25O6PQL1lS2OvilNcmxgGD/gXBSD22XHhIGistw1S6wq5oYFqBAAhzRCDMvGrcHKcVXYK7MprDIVvztkVM70ozNtT4OHArycE3yUCyv2h33RvD7tPmD/ipSbKx1N4h/aCcpL3WdXcWGUNPJWtjLGCQv6i6LyNNXUToN5vFw8txRtAVa70xw/Ad1CqnjXqEYbznDj54
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(366004)(39860400002)(376002)(6506007)(8886007)(2616005)(956004)(8936002)(52116002)(4326008)(478600001)(316002)(38100700001)(8676002)(83380400001)(2906002)(6666004)(36756003)(26005)(6512007)(16526019)(186003)(6486002)(66556008)(66476007)(86362001)(66946007)(107886003)(5660300002)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CsSYxDLtd4cslfu5ElA5y0XIEykVTiUuKyIMDgIe3Gr9pCS+Q1JRYNwSf74U?=
 =?us-ascii?Q?IrjA0ONEWB4NGhur+GOemPA570QzWzYFX4f3q0MP8S+67TR3JmyvdS499CC3?=
 =?us-ascii?Q?5nvpve53sPFsDpKO6S3a3NxPGf56Ff+9kDlnS20R3Q5C1Mxx1HUC39kUCo1I?=
 =?us-ascii?Q?GGLzKc2gd6xxF2ahnnD/QPf0wsnB6vVGSO1e6acTyEKrBZkQwBbsoiCM/n4b?=
 =?us-ascii?Q?K1XnpotUVKwAD94lzC+emLXHi49bHV+/G//Ag72ZgKm3T4e9OepXzG4CmCfY?=
 =?us-ascii?Q?5ldLm2Z/Mb9P8XfAKKJj2tXtW1CWfuSumWGpneIYmAmxHiRYnmWECAP0y+2Z?=
 =?us-ascii?Q?3GawEnNeDtg6a765A1kk3aNImLSTmrnOf5nWjtnlBLZwjhIbhk+U64c8aGB5?=
 =?us-ascii?Q?aj5wgrYPA0NiLo0FKeCconwlixaScoj6Nr0ljKysYlEJsmTdqzO9LEmVWJYo?=
 =?us-ascii?Q?c4Zpkxwvubpwse7maclg+7SegNDClxrVS12vtPpVkRP0jiDn6jB8PgiaKLbO?=
 =?us-ascii?Q?DRGMB+o2bga7y4r0088W5iemh8XJaVTt3VsU235hTH0P6OeRodokDA1EVKVx?=
 =?us-ascii?Q?jVeC0SZaNw62zHv1GiC2rtjr4ekGIP3Dl35mtjRchxJXzrjAaiG4RvFH6yK9?=
 =?us-ascii?Q?1nUSD8nqQzeR5CcruLX2hgFDNkZBkz4/DHfsPC9sbeucsHKS6xv6XWMykEDP?=
 =?us-ascii?Q?m+Ho3JDv1odDGycWop8QeFjjXpUmrxTQbIH2xySKXCvTLIwCJq/UBEvzwWk5?=
 =?us-ascii?Q?vGDvbhsmQ+LBgpC16roA3C3AAvEfcNAvv4ou5sqcbQJtFk/AS/VLSzfViePv?=
 =?us-ascii?Q?Hi66IM25MPHBI8dToMctjFm5vn2bsnsgmoxj1KizJZyCnsVt5usJFkET+baA?=
 =?us-ascii?Q?cIqg8vQGJaPxmBPoeuqrFexEUCdFCwxhkpyHwNwwSncTlc+6W7hDfJUq9Mvm?=
 =?us-ascii?Q?qsCRwvgYkOS8aLUZHFOlsP9ru652I0BD//KsaeMGVP03qqSvq1XrCmOG26i/?=
 =?us-ascii?Q?r7+3zrpW2YdxEhtGJN/epnwK97d/Kye7Mu7i4YytL3g7G/8Rebj7CvN90hOX?=
 =?us-ascii?Q?WHNRVg7SOB/2QQdK/lVsvOA7XwHTNbHZQiZXtg0WJQ81dOmXkyxGXbS4J3uQ?=
 =?us-ascii?Q?E6mU71r607/Ng2rimzGlFrBhb/3GMSlHLqMJgies5eZ3vd4Oy0Y9psb+GT1g?=
 =?us-ascii?Q?RelBS/5VnQoStPRP1fZfjL646ndq34DxOWUAXAjx3DZj+uqANC2xUGc31HIv?=
 =?us-ascii?Q?NTrVO0enz1VJOcy0w7MWfE3Lznar0r/so2ZOszfo5wWyV+g1UfPwagN3HTeK?=
 =?us-ascii?Q?hQrsXEPWf3r5psJOzhpVjl/v?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f699b9-d32f-4faa-3202-08d8f4ae68a3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 01:35:20.0951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4TNsIAJJXzf0Ir3n0Oqc51k/ROehZcrhx9IZd9FHaEPH4TaDeKsbJ9a5hg26ykvtoDPuMOM1HiDUmGJ70uCIPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7462
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
v2:
- add missed code in mddev_find
- modify commit comment
  - remove SUSE product name in test script
  - soft lockup trigger time is incorrect, fix it. 
  - only leave one soft lockup stack
v1:
- create patch
---
 drivers/md/md.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21da0c48f6c2..fe6d9f6e3c3b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -734,7 +734,7 @@ void mddev_init(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(mddev_init);
 
-static struct mddev *mddev_find(dev_t unit)
+static struct mddev *mddev_find(dev_t unit, bool create)
 {
 	struct mddev *mddev, *new = NULL;
 
@@ -793,7 +793,8 @@ static struct mddev *mddev_find(dev_t unit)
 	}
 	spin_unlock(&all_mddevs_lock);
 
-	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	if (create)
+		new = kzalloc(sizeof(*new), GFP_KERNEL);
 	if (!new)
 		return NULL;
 
@@ -5644,7 +5645,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * writing to /sys/module/md_mod/parameters/new_array.
 	 */
 	static DEFINE_MUTEX(disks_mutex);
-	struct mddev *mddev = mddev_find(dev);
+	struct mddev *mddev = mddev_find(dev, true);
 	struct gendisk *disk;
 	int partitioned;
 	int shift;
@@ -6523,7 +6524,7 @@ static void autorun_devices(int part)
 		}
 
 		md_probe(dev);
-		mddev = mddev_find(dev);
+		mddev = mddev_find(dev, true);
 		if (!mddev || !mddev->gendisk) {
 			if (mddev)
 				mddev_put(mddev);
@@ -7807,7 +7808,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	 * Succeed if we can lock the mddev, which confirms that
 	 * it isn't being stopped right now.
 	 */
-	struct mddev *mddev = mddev_find(bdev->bd_dev);
+	struct mddev *mddev = mddev_find(bdev->bd_dev, false);
 	int err;
 
 	if (!mddev)
-- 
2.30.0

