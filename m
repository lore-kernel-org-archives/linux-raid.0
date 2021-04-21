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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BC9C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 21 Apr 2021 08:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 108DA61264
	for <linux-raid@archiver.kernel.org>; Wed, 21 Apr 2021 08:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhDUIPD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Apr 2021 04:15:03 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:57095 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234010AbhDUIPD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 21 Apr 2021 04:15:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618992869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=EfZndvpBBRdpRkxuCdGUrBu2FlJO1Np8LNZBhFMrB6c=;
        b=kRPs1AhoW8qgC8g2jrvhGH5E/ym0wpIF8bZ3wJc1cxw1uTP7l2hL4pW7YJUPttKKDjD6Is
        ldJVeZSc2wKmXTNu7egIZy67LG+qTCyGjonyz2LVBxlUnTlCej4krb2IQJsmpWWSbN8bKe
        flYYbWqooFspvQP4X5J6kiwO+aG/g/Q=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2052.outbound.protection.outlook.com [104.47.8.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-utbAYfesMQ-iSeCHXfyS7g-1; Wed, 21 Apr 2021 10:14:28 +0200
X-MC-Unique: utbAYfesMQ-iSeCHXfyS7g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgVTDDEJEnMncSPi4Wxmatq3Mnj/B89RtcJMiNb2BQxNK0+Pnn0x+yeAQqUQoqh3S7e29bzuOBHjVzwRYHmwZyf+1I22h/0RDIPjhXbn+Fasj7csiyXv4DC8z6Mbg9pQ7OVx+6yBMTFHEb0feAbV8ypnSwzHfmO3pWEgY0PMqRy4h1mBHeCNdg2AwY2tAx0qaG2swie0O0bgNDXb1NaGfw7x2vf6Ud/1oixcoEQFtjQFVdUnHaWWalfIcP6iTMohiO5PX2lZjmmuKF28gPmo6Ol6zSxL0fJWFNEPD62hIctt+igHFtB2ow6ATFQRoPJDSJxieCwQEDYoixdnOn8W3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfZndvpBBRdpRkxuCdGUrBu2FlJO1Np8LNZBhFMrB6c=;
 b=e1CPbXIHRvCf2vUarK/D2kxyx6AT29Evv6+X39xDqk+x0Jh213UKCRH2Q8Xg9uW0An5QDyQIX5KAtezFtw4GyTHZnx3E+ilm+rrs389SAWpA+uRLbXVm8NbfgpErvGsp+82W+2f6E1rWxNL3loVWjvNOOavxRE8u536gYF6vNpSj4iDJGrFQa953VVa+LF41Xfj3pBDaD+BUQ3c0bI6iEjqUVsjQms5xRdfXGJLQw+7mDu3L4iZqMgb6GNs8I08S6Zru0NCFpqyMmOG/BEEvoDV+BrxTMcdcyYshCLjJA1lEjxUtnMzZAwmRp1C6RPWxO/i9BoMvx+kJZUkVIMJS9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBAPR04MB7462.eurprd04.prod.outlook.com (2603:10a6:10:1a0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.19; Wed, 21 Apr 2021 08:14:26 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc%3]) with mapi id 15.20.4042.025; Wed, 21 Apr 2021
 08:14:26 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Heming Zhao <heming.zhao@suse.com>, ghe@suse.com,
        lidong.zhong@suse.com, xni@redhat.com, colyli@suse.com
Subject: [RESEND PATCH v2] md-cluster: fix use-after-free issue when removing rdev
Date:   Wed, 21 Apr 2021 16:14:11 +0800
Message-Id: <1618992851-4320-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.130.223]
X-ClientProxiedBy: HK2PR06CA0014.apcprd06.prod.outlook.com
 (2603:1096:202:2e::26) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.130.223) by HK2PR06CA0014.apcprd06.prod.outlook.com (2603:1096:202:2e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 08:14:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f10e9abc-3c75-4374-78b7-08d9049d7a64
X-MS-TrafficTypeDiagnostic: DBAPR04MB7462:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB74629FD9B863B065F6C1DF7A97479@DBAPR04MB7462.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cbrp1YfI7fJGbdWRmJnowzFBIhBm1qOs/TAuUAbUeLj4FI8FfQukmd1d3baHMWSEPFweg2hD2exeAlv52/aT4w3kb3iS0HyLkiJI3AwLMlvaKhBeGdCFX6LNt69WqRpUsvKslsk9clBFz8aKdF7tDBcqzueous3gW+gcVg1g9n5RYGKoFjzPm/n4VRHOHL0jUnvfoCL54/zrovRwRCL4HQo7GDcwCVOjjgz1oUSX269NAkSjfJaoCCy7MhFezhqW983gvZQyDjnRz5djdUCWAYZqVhfuDC6D/4nRPwEKMaTks8G20tmBmnR77jSYGwBlWjVAucvV47n8aB4EPDp7JiRxCsc9VAHqVm3N/0SsStyQ5SvhKY4qS5Fyc2K7GM4KfZiUc/2ZeHXCJH0vEhbu4Peo1LFKJkeMj3NLy4/0olLGcqDwX0QRby5LpVXjBszzXrdNQoD7bH6aSaCpVzmQD4BoJMnVcNsJ9CiINAxTFblogEgR73UbNUzjK24Fv1lFy7Rr3JQFI4HF/QJwLoi4sEhEk/GFaZqxCzhNQZCGsByBI8LsfLzje6DxVH9AW4e7F5MWG0cj7mQh16V97liaKdweTm6rZd3nhHxETC7HGjckNbTco7w6CsrBlKtSpq2wGZT91yTNLopY/qbF2AX/TkI7+q51ll3yA5Bxd2ey+yQNVmM0w6TXH/buU+rRSU18
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(136003)(366004)(396003)(83380400001)(38350700002)(6666004)(66476007)(66946007)(478600001)(6506007)(5660300002)(6512007)(38100700002)(36756003)(107886003)(8676002)(8886007)(956004)(6486002)(44832011)(26005)(86362001)(8936002)(2616005)(66556008)(4326008)(316002)(16526019)(52116002)(186003)(2906002)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zI6Hjve4jFBCAJ6k88OOv95t2dKHbaXWgDHh4FinP/Wx2y/pDBJHeEx3TMMF?=
 =?us-ascii?Q?3ALGsbZ6fgUS8UdmAnRBA1Hyg9HrJtyMpRDG23u8vQkwFxPlOJAAY7K8sYH+?=
 =?us-ascii?Q?ptctz32UJuqINVKcnTQHu77g8jM36ifGAqQ/649Xt6smFGXdfdHAHkIccO2U?=
 =?us-ascii?Q?ZwkZ9NW+IH8khhjkkd9b7qxzdz/vEAuvAcN112WbhTFJv5C1rmaMrLcD+1Yx?=
 =?us-ascii?Q?JO5b5p/DsVOej3/I1oWVXVIF+EtcjcGqDMSGeN89XgjemFGicl7bxxcv0iVV?=
 =?us-ascii?Q?bbagMeEecrBh8Y1NK30OoeAAsspCeN5sNiV7Q9BIHE7ti7YW4RXYvvHfTzDB?=
 =?us-ascii?Q?VBzK8W7VGePICMnnBUCu0Bk9z+dDHCoWK37XdWllhbjcY0SlejrDYcKU40km?=
 =?us-ascii?Q?pxiLI5TumO8+tlKulcRasyFWkQzmnR5X+JOrJYoGJUpVvZ8hnN5mHk8oBhm2?=
 =?us-ascii?Q?S9Q9P0/L1MozWdsgmgTdz6q6thTSeWsE6GH2Y3pXGbwNgzBPnQKCgRWzRXPC?=
 =?us-ascii?Q?rW95eKpPd31E8CVH+w5uj6BGFjEUH0xd7kZsuuKpxt9onjG2Jz93xP0qn2hX?=
 =?us-ascii?Q?7ub3oLslLxkB/AOlGvcWrhT3Ua19+1oigI5opCN7AxAuTNaHt4dPVmcxTnZa?=
 =?us-ascii?Q?IVt529+k3WQ4QYXSAkShpu/n2IeEEKm62GkBZ91sEkddx9XZNslg0IOkik8d?=
 =?us-ascii?Q?HE8cr3lCn+VSLYYbIFbmQ0nZhSyjYk6C3xZMs6knxxu2O25Tc0cgaXqH+fIa?=
 =?us-ascii?Q?lFakwQPZmuexWS85C+THPSuy10pLz3RNEOJiw08YP9AU18jrISCdYLJKH44u?=
 =?us-ascii?Q?kg5QyZ5P4u6oDJo4cHz1NvK+hwcfpqXeZvCFRV3lwYP09DdDeSj0PSCj4MiG?=
 =?us-ascii?Q?pq2V+uqCbGAl8k12EdFedNmVrWvaK/Y3yxHy/ENHmSm25VV76FlPspn6zoSF?=
 =?us-ascii?Q?NJ7dnUWEOeZlWZsiABx5vD3+YgnVej0peczoeA1CHy0KCPmyusUcWFXD5gTT?=
 =?us-ascii?Q?v/0/41vEV8vAZSD2g1RZgAcCftjWmG5EuHjkmzilWqeXapL0jy9pVE530+ZD?=
 =?us-ascii?Q?eOsS4n/ceIGRsBBUD1zK54gR5qALhNrMdltWmfIOJM97WJccpCJeZ9trtAHR?=
 =?us-ascii?Q?vzN0H4jbTKK8klgxsMMeIezDCONyourLUfgS/yJERsi7qmPgg5iuxHDAYmhr?=
 =?us-ascii?Q?noI+UiCaLZUP2MOyUM8nF7123SU0qVzjv2PAvtpv79tX9eDL7Dyhaa1grAD6?=
 =?us-ascii?Q?ixyfuaJiLDsiTD5mKq5dJnV2ZSoQT6mf2Pmb56MNA2i6nYgaEB4SoyLMpLJw?=
 =?us-ascii?Q?Jjb2kiitK4DkzdJN/lJOoXLA?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f10e9abc-3c75-4374-78b7-08d9049d7a64
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 08:14:26.2635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NYqrP32Bj7Qhsp+EZ7dTubCZ+dvVrDn1APqlZ4edafJS3pXyFH0xQ4qw/4aUxwwvLhVFCA9ZvvMUI6zfvRmXaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7462
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

md_kick_rdev_from_array will remove rdev, so we should
use rdev_for_each_safe to search list.

How to trigger:

env: Two nodes on kvm-qemu x86_64 VMs (2C2G with 2 iscsi luns).

```
node2=192.168.0.3

for i in {1..20}; do
    echo ==== $i `date` ====;

    mdadm -Ss && ssh ${node2} "mdadm -Ss"
    wipefs -a /dev/sda /dev/sdb

    mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l 1 /dev/sda \
       /dev/sdb --assume-clean
    ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
    mdadm --wait /dev/md0
    ssh ${node2} "mdadm --wait /dev/md0"

    mdadm --manage /dev/md0 --fail /dev/sda --remove /dev/sda
    sleep 1
done
```

Crash stack:

```
stack segment: 0000 [#1] SMP
... ...
RIP: 0010:md_check_recovery+0x1e8/0x570 [md_mod]
... ...
RSP: 0018:ffffb149807a7d68 EFLAGS: 00010207
RAX: 0000000000000000 RBX: ffff9d494c180800 RCX: ffff9d490fc01e50
RDX: fffff047c0ed8308 RSI: 0000000000000246 RDI: 0000000000000246
RBP: 6b6b6b6b6b6b6b6b R08: ffff9d490fc01e40 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: ffff9d494c180818 R14: ffff9d493399ef38 R15: ffff9d4933a1d800
FS:  0000000000000000(0000) GS:ffff9d494f700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe68cab9010 CR3: 000000004c6be001 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 raid1d+0x5c/0xd40 [raid1]
 ? finish_task_switch+0x75/0x2a0
 ? lock_timer_base+0x67/0x80
 ? try_to_del_timer_sync+0x4d/0x80
 ? del_timer_sync+0x41/0x50
 ? schedule_timeout+0x254/0x2d0
 ? md_start_sync+0xe0/0xe0 [md_mod]
 ? md_thread+0x127/0x160 [md_mod]
 md_thread+0x127/0x160 [md_mod]
 ? wait_woken+0x80/0x80
 kthread+0x10d/0x130
 ? kthread_park+0xa0/0xa0
 ret_from_fork+0x1f/0x40
```

Fixes: dbb64f8635f5d ("md-cluster: Fix adding of new disk with new
reload code")
Fixes: 659b254fa7392 ("md-cluster: remove a disk asynchronously from
cluster environment")
Reviewed-by: Gang He <ghe@suse.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v2:
- modify commit comments
  - add env info for test script 
  - add 'Fixes' filed
v1:
- create patch
---
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21da0c48f6c2..9892c13cdfc8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9251,11 +9251,11 @@ void md_check_recovery(struct mddev *mddev)
 		}
 
 		if (mddev_is_clustered(mddev)) {
-			struct md_rdev *rdev;
+			struct md_rdev *rdev, *tmp;
 			/* kick the device if another node issued a
 			 * remove disk.
 			 */
-			rdev_for_each(rdev, mddev) {
+			rdev_for_each_safe(rdev, tmp, mddev) {
 				if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
 						rdev->raid_disk < 0)
 					md_kick_rdev_from_array(rdev);
@@ -9569,7 +9569,7 @@ static int __init md_init(void)
 static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
-	struct md_rdev *rdev2;
+	struct md_rdev *rdev2, *tmp;
 	int role, ret;
 	char b[BDEVNAME_SIZE];
 
@@ -9586,7 +9586,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 	}
 
 	/* Check for change of roles in the active devices */
-	rdev_for_each(rdev2, mddev) {
+	rdev_for_each_safe(rdev2, tmp, mddev) {
 		if (test_bit(Faulty, &rdev2->flags))
 			continue;
 
-- 
2.30.0

