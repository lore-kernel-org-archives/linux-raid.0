Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2952BC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  1 Apr 2022 02:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243994AbiDACPp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Mar 2022 22:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243988AbiDACPo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Mar 2022 22:15:44 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF1641F96
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 19:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648779233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ufr3JY1lB2dYO9XusjVf1Is8f8ZPWyOcfMxygEHy+Dk=;
        b=joYwsKoX3MjiGclX0YqoukmWRb5pVyOLXnisC/Wawz7IoSU2fwh06ZNhXZSsJ/ROZG+/67
        1arPP9WxG1WVlvYapsNEfLE2MSmtBJvj/AVFvamKWSbp4cffBcYO6LueEqwKf7y0SlFYut
        EcTIz0wbVg5Gjf1uLQtmLnO6jAxjwng=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-11-Z6VWBqzVOEe0P7OJ3dcLZA-1; Fri, 01 Apr 2022 04:13:52 +0200
X-MC-Unique: Z6VWBqzVOEe0P7OJ3dcLZA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UiKzripfIuNLzc+0ZBCgi3F0H+tlh2GnAAowHGhJ5GIgGhtMqRUEJtkfMTtsIF+nO8QOzN//g6t7a8nVP53KPH412aotdmcX7qikIHzixfatcQA4PE8H1I6AAyJq3v5kuc/4s/IcqMperSfn2qlm3pR3tMeBO/MYtdltnH5V9+FRQ2fTczepeBDXLbGNfAqeQWiw0kym1073qIyyYJpcSddOHRiX3h/T00VHXyJG/XHIO8r7MqKIpP/JQ0u8ew0ifW0eQkhnzEkYtQANy/5FevegrEYnbR3WYYW/1okeKPTUI4xuEbSOcvKHtMsnIC+67tOhnis4d7GSnTKeV/j+DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pEEmRbe2xzCJa9DlwL9jSIgseT+hfGXi48Jap2RL88I=;
 b=RPEWKI4jMjcDlD/1VacsiKSY+oEf6ce1yylsQWWYL2bxYTy6qsbEnMmzprODK2kFgwJj2U6X5d6S5qJo1v+YYWBMTOh7zXmqYvGYva/xq1bZhE/ky/YqHKN1Mdvr3ZUOT1FJgZKWMb4FlH5whEP8/4sjvC7iFHOEnHYNDX6gXC0Rd/ZObQj8T2Y/OlIlWGvOgo7GQfUMvLFyH/ZhWNNOKw3VfHIwSJshSIe+hkZilFzM6p92RdFssLKrMYcUu38N/QUV7oEslq3pWr/2LCstA69AgVbWji8GTQUTf4YuNiz7Tmv2NgyO7J3qmD4ifIndXXVemCffOrMwzPbi3hWZsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6857.eurprd04.prod.outlook.com (2603:10a6:10:114::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.25; Fri, 1 Apr 2022 02:13:51 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5123.025; Fri, 1 Apr 2022
 02:13:51 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@linux.dev
CC:     Heming Zhao <heming.zhao@suse.com>, xni@redhat.com,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v4 1/2] md/bitmap: don't set sb values if can't pass sanity check
Date:   Fri,  1 Apr 2022 10:13:16 +0800
Message-ID: <20220401021317.4046-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220401021317.4046-1-heming.zhao@suse.com>
References: <20220401021317.4046-1-heming.zhao@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: TY2PR01CA0018.jpnprd01.prod.outlook.com
 (2603:1096:404:a::30) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f55a8b61-8f56-4704-9037-08da138541bd
X-MS-TrafficTypeDiagnostic: DB8PR04MB6857:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB68570E9E309A639CDACDE80097E09@DB8PR04MB6857.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UYLRJ+f/CXXRj2SUaAh3lCoWjhyCs37P8wxgTclHuhn0ARH+wSChtr0UerbZpM6VNVW0uVd6PkfiYBh2qKknU/AT5tG12oz3LYHwbzfbX8dBjAqowKppf+NBOX9/Iq96GMn4x1ZSy11sajIGTUsnphPC3SAxPcg3A46DgjSQrUf4rIj8WY12ByvRkEZOo7VtPxQCG18a1DxKxHAc0dblFzg3dHzPrC1WFvrpaTI/c3sIMye/ahi3DubyBx41KtSo4gkSvc5BiQEc1ggCLQ7hYcM+5B0G9zlYBcJAw+mt8eWgqVrQJ2fSVRtrH5lyGoH6zDVHkc5Nymefb+mGSWaBtUphF9d8GLa1gnUdlfOchFYGrAtr8kgYC5MJKjcZVKSZ4l6qINOTUBZRnS6V0OkEQFz2qxeUWpeEv20D1hjqhr0w8Gtk1X4dj0s7C0QAVwPt4tPQl+hkR7XcghNjg7RaDqnr4nvNL2HXLImtUC1UCAZkQH/Fh1BneJEYASi7zNbVC/XJaobESWnnJ1PhwRX7U/BWy3LoVAkqZC7Czyph2SZnk08edYfpPd/kgebEHiCUxFFBx8k1XAhn/dO0NpKK58rFv0TlUj8Z02OezkHUDLX/oQkgN3pNkJR9Hr0jbpRWO9syAyNkebk4n+BkEEB/8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(2906002)(36756003)(6666004)(6486002)(44832011)(6506007)(5660300002)(8936002)(4326008)(54906003)(66946007)(83380400001)(6512007)(66556008)(508600001)(8676002)(66476007)(1076003)(316002)(186003)(26005)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rIQhM+TlKoLol1aOUsVAs1WXjoM7JsWZIHl0FDHqPsRsevk55MLrYGPPhHv+?=
 =?us-ascii?Q?gyD+5tlcrHAWBJMxuKZqEf5Rer82IUBjzgxkgLJhcnOAqgHBO+y/1+YK43BA?=
 =?us-ascii?Q?nZeD9mwkf7GMVNJ2k2qQt7pWKXu51VY5gDs69XETjaMJb3+1RHtRbYYb6dkZ?=
 =?us-ascii?Q?1H62r6wpEAN4dfuoEu0kxlQ0kx9fTtCqw5QwgAKY2GljpB1cK6lrfc9Vhlfp?=
 =?us-ascii?Q?vZfZ4uM1a13kcHhAdu0v/hq1LI4PPH5xE/Znrkk/3cAjmHLDcvnKdvkW7wMN?=
 =?us-ascii?Q?vKpQF9g1Wr9YPjlTi5n+5l0Ijk7qr9DzDd1MijZj/8qMusb2i7VJzGI8tH4b?=
 =?us-ascii?Q?wFcu5O8vZVLANW9sn5k0PrJHlpIdVsGYVikXryakzizlkrRh0T+Bd8tm38E3?=
 =?us-ascii?Q?kws14Jv/P45Aepzn+5iTX+u4FcNYYuJ59Wg73XHk0FGckN3Ou89s2J8gSntV?=
 =?us-ascii?Q?IJliNim+DIhZAspWfhrO5fGGYSONTlGg2zoqjn7xLsuA/RzgkaGZVFpVtO+E?=
 =?us-ascii?Q?Ki1iRjed74LneyCO2xVFv8UK19SYl2TvIhCZq9UkGOcyLxHqWXByUUUt40yk?=
 =?us-ascii?Q?9bNVktV1R2mGEJc90wJQHExjuTyALCX7uwoET9oQHuTCeboSDacR/23Biv9J?=
 =?us-ascii?Q?h5bsyNEhpAKY2afq9EHpUR9OxeQA9LRENlouRDVp0YzML6+uBMS4c3nHDHqs?=
 =?us-ascii?Q?9FtaZ83SKR9qcIwFsx/rYlxweY5Ybm3RN9ha7og5QQH4Pg6eZ8WqaEAc1NlI?=
 =?us-ascii?Q?Pt0d/eQLxTlvLOIb6cAbynBQUM7Hu1sna8ih7EM1hrkC8FxPA0cux4dZZ6vD?=
 =?us-ascii?Q?fsrKXjgSpJTOUFBCdeHkswHWTZf8u357CGYiQCxrfS2GER/L+bC9NxzNDtsn?=
 =?us-ascii?Q?feZdwYxNM/Obk5SheIkMlggmNNHK8sexNVcqBMhf2ZlF5WATKUlPzbvDnsOa?=
 =?us-ascii?Q?14vpAuhzvPYKL4w03KwnLcn2qnv83qaswvTBAxROK4u26CQ5mZUEkg236shZ?=
 =?us-ascii?Q?GmyQRQgDbSpnktf8LkHNQRdslUouWKQb6eZTQu2sKndrdWQdcU7Bt8Vri4o6?=
 =?us-ascii?Q?BFH1JaRbIBlg+rQHoPnVBqurYqliv6cMIx9bbfKH5mop9Bi578+okDJRVMhS?=
 =?us-ascii?Q?cyZJ+VVnXzlgPHEo2XAaTi4fZ6059XTHuGg66tuXV/jn09DZdG3JgqespEW8?=
 =?us-ascii?Q?Xp24Zr1bnUalLt07+lS4tLZYkoSOYmft8rSJt0/5gVf78DaIBMzvgJYgr3VC?=
 =?us-ascii?Q?1RnaaSEvghQpKmojyxCGY2hDhPHfpAkC1cge4coWUUOXFL900XhJCUO57XHz?=
 =?us-ascii?Q?PoQt7cHjSsK/c/PwLr9tydflOnehMPPRPkxfj08Uylh0auDnr6cj26RtN0M+?=
 =?us-ascii?Q?7+rIGUuPnC0G5RdcIRjSJkmYHEEHwBXfgNn8ZxlgJWtGM3IGLREF1Wn2+K1X?=
 =?us-ascii?Q?MuTldV81fEZChu4f6EqTsXUykYCOvY1+0v2ZmS/cWEp3jrDFuB5S0rXRKSrU?=
 =?us-ascii?Q?+HFNtEoIut/5cTVaLNkGy4B4MTnnL6+DGU+cN5AQnlKJecdP8xUx5kk1Sue3?=
 =?us-ascii?Q?lC7O+6PxC8VSpPh9qt33kIAqxqK1/visn18ResdWSFYghw9UAWPE1E+ksW0R?=
 =?us-ascii?Q?jKBlCBKvK6Sd8Wkh9XBEB5XLwVf+ttNJdy7E1YSHhymK3jUXwgsvZfGNOGi0?=
 =?us-ascii?Q?0NN9seXjHirMeXNRuilNLKp6Ysn7b9/GHHNlm9C14zdB80XTL3EU95zT7dTq?=
 =?us-ascii?Q?rHjglnjdDA=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f55a8b61-8f56-4704-9037-08da138541bd
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 02:13:51.6801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1+6h+LCv4mgyDqTpXqS8Bw0OcYJzVJMBdbGd18lwgBqSfYtSeAXF66NR9emYCCy45WRX2n1t4P8vXGHFkaUjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6857
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If bitmap area contains invalid data, kernel will crash then mdadm
triggers "Segmentation fault".
This is cluster-md speical bug. In non-clustered env, mdadm will
handle broken metadata case. In clustered array, only kernel space
handles bitmap slot info. But even this bug only happened in clustered
env, current sanity check is wrong, the code should be changed.

How to trigger: (faulty injection)

dd if=3D/dev/zero bs=3D1M count=3D1 oflag=3Ddirect of=3D/dev/sda
dd if=3D/dev/zero bs=3D1M count=3D1 oflag=3Ddirect of=3D/dev/sdb
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
mdadm -Ss
echo aaa > magic.txt
 =3D=3D below modifying slot 2 bitmap data =3D=3D
dd if=3Dmagic.txt of=3D/dev/sda seek=3D16384 bs=3D1 count=3D3 <=3D=3D destr=
oy magic
dd if=3D/dev/zero of=3D/dev/sda seek=3D16436 bs=3D1 count=3D4 <=3D=3D ZERO =
chunksize
mdadm -A /dev/md0 /dev/sda /dev/sdb
 =3D=3D kernel crashes. mdadm outputs "Segmentation fault" =3D=3D

Reason of kernel crash:

In md_bitmap_read_sb (called by md_bitmap_create), bad bitmap magic didn't
block chunksize assignment, and zero value made DIV_ROUND_UP_SECTOR_T()
trigger "divide error".

Crash log:

kernel: md: md0 stopped.
kernel: md/raid1:md0: not clean -- starting background reconstruction
kernel: md/raid1:md0: active with 2 out of 2 mirrors
kernel: dlm: ... ...
kernel: md-cluster: Joined cluster 44810aba-38bb-e6b8-daca-bc97a0b254aa slo=
t 1
kernel: md0: invalid bitmap file superblock: bad magic
kernel: md_bitmap_copy_from_slot can't get bitmap from slot 2
kernel: md-cluster: Could not gather bitmaps from slot 2
kernel: divide error: 0000 [#1] SMP NOPTI
kernel: CPU: 0 PID: 1603 Comm: mdadm Not tainted 5.14.6-1-default
kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
kernel: RIP: 0010:md_bitmap_create+0x1d1/0x850 [md_mod]
kernel: RSP: 0018:ffffc22ac0843ba0 EFLAGS: 00010246
kernel: ... ...
kernel: Call Trace:
kernel:  ? dlm_lock_sync+0xd0/0xd0 [md_cluster 77fe..7a0]
kernel:  md_bitmap_copy_from_slot+0x2c/0x290 [md_mod 24ea..d3a]
kernel:  load_bitmaps+0xec/0x210 [md_cluster 77fe..7a0]
kernel:  md_bitmap_load+0x81/0x1e0 [md_mod 24ea..d3a]
kernel:  do_md_run+0x30/0x100 [md_mod 24ea..d3a]
kernel:  md_ioctl+0x1290/0x15a0 [md_mod 24ea....d3a]
kernel:  ? mddev_unlock+0xaa/0x130 [md_mod 24ea..d3a]
kernel:  ? blkdev_ioctl+0xb1/0x2b0
kernel:  block_ioctl+0x3b/0x40
kernel:  __x64_sys_ioctl+0x7f/0xb0
kernel:  do_syscall_64+0x59/0x80
kernel:  ? exit_to_user_mode_prepare+0x1ab/0x230
kernel:  ? syscall_exit_to_user_mode+0x18/0x40
kernel:  ? do_syscall_64+0x69/0x80
kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
kernel: RIP: 0033:0x7f4a15fa722b
kernel: ... ...
kernel: ---[ end trace 8afa7612f559c868 ]---
kernel: RIP: 0010:md_bitmap_create+0x1d1/0x850 [md_mod]

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 drivers/md/md-bitmap.c | 44 ++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bfd6026d7809..612460d2bdaf 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -639,14 +639,6 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	daemon_sleep =3D le32_to_cpu(sb->daemon_sleep) * HZ;
 	write_behind =3D le32_to_cpu(sb->write_behind);
 	sectors_reserved =3D le32_to_cpu(sb->sectors_reserved);
-	/* Setup nodes/clustername only if bitmap version is
-	 * cluster-compatible
-	 */
-	if (sb->version =3D=3D cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
-		nodes =3D le32_to_cpu(sb->nodes);
-		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
-				sb->cluster_name, 64);
-	}
=20
 	/* verify that the bitmap-specific fields are valid */
 	if (sb->magic !=3D cpu_to_le32(BITMAP_MAGIC))
@@ -668,6 +660,16 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 		goto out;
 	}
=20
+	/*
+	 * Setup nodes/clustername only if bitmap version is
+	 * cluster-compatible
+	 */
+	if (sb->version =3D=3D cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
+		nodes =3D le32_to_cpu(sb->nodes);
+		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
+				sb->cluster_name, 64);
+	}
+
 	/* keep the array size field of the bitmap superblock up to date */
 	sb->sync_size =3D cpu_to_le64(bitmap->mddev->resync_max_sectors);
=20
@@ -700,9 +702,9 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
=20
 out:
 	kunmap_atomic(sb);
-	/* Assigning chunksize is required for "re_read" */
-	bitmap->mddev->bitmap_info.chunksize =3D chunksize;
 	if (err =3D=3D 0 && nodes && (bitmap->cluster_slot < 0)) {
+		/* Assigning chunksize is required for "re_read" */
+		bitmap->mddev->bitmap_info.chunksize =3D chunksize;
 		err =3D md_setup_cluster(bitmap->mddev, nodes);
 		if (err) {
 			pr_warn("%s: Could not setup cluster service (%d)\n",
@@ -713,18 +715,18 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 		goto re_read;
 	}
=20
-
 out_no_sb:
-	if (test_bit(BITMAP_STALE, &bitmap->flags))
-		bitmap->events_cleared =3D bitmap->mddev->events;
-	bitmap->mddev->bitmap_info.chunksize =3D chunksize;
-	bitmap->mddev->bitmap_info.daemon_sleep =3D daemon_sleep;
-	bitmap->mddev->bitmap_info.max_write_behind =3D write_behind;
-	bitmap->mddev->bitmap_info.nodes =3D nodes;
-	if (bitmap->mddev->bitmap_info.space =3D=3D 0 ||
-	    bitmap->mddev->bitmap_info.space > sectors_reserved)
-		bitmap->mddev->bitmap_info.space =3D sectors_reserved;
-	if (err) {
+	if (err =3D=3D 0) {
+		if (test_bit(BITMAP_STALE, &bitmap->flags))
+			bitmap->events_cleared =3D bitmap->mddev->events;
+		bitmap->mddev->bitmap_info.chunksize =3D chunksize;
+		bitmap->mddev->bitmap_info.daemon_sleep =3D daemon_sleep;
+		bitmap->mddev->bitmap_info.max_write_behind =3D write_behind;
+		bitmap->mddev->bitmap_info.nodes =3D nodes;
+		if (bitmap->mddev->bitmap_info.space =3D=3D 0 ||
+			bitmap->mddev->bitmap_info.space > sectors_reserved)
+			bitmap->mddev->bitmap_info.space =3D sectors_reserved;
+	} else {
 		md_bitmap_print_sb(bitmap);
 		if (bitmap->cluster_slot < 0)
 			md_cluster_stop(bitmap->mddev);
--=20
2.34.1

