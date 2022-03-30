Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55DA4C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 30 Mar 2022 10:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245372AbiC3Kam (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Mar 2022 06:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243864AbiC3Kal (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Mar 2022 06:30:41 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFBA29C86
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 03:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648636133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Wkfm8uPCj0zQZ6USUGrHd7cSq/qIPzU/4HXKRCMBLeU=;
        b=ZOnF6x118TJD/gnGtrUIJzvEUe0WeqKGLJS7NpSKdh7OvJbrIlLCulU6w8YRyGXnY6h7cJ
        oX3ZaKHTz9v/9aHYKRBoLg5rUdu17rY3X0HejbBahZxFtXkHJukxliXwb6dofzUnIO0zC+
        3/Klbe7oGO28Gd0JwMeC8e5LoA7zHLc=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2057.outbound.protection.outlook.com [104.47.13.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-19-tCyVtZK7O-uIFGqqiZ_1cw-1; Wed, 30 Mar 2022 12:28:43 +0200
X-MC-Unique: tCyVtZK7O-uIFGqqiZ_1cw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCFpebiov0VuaM6i6QKGmML4JmUoeGq22+0EUVhyNSzlrVHJ71E32sTXYUgGVlRB+pXERgHCqBGMWTknNF8kz68lN9QL1Oys2M7TuRVghphSv7UL2C1NNDGTelqYDy/VQFrN6RT3qrDnxxJLG6BjRAs0b8Q5hJMdBM/qAu24bVxENUpRxtSWJzoiUMYtkvTWf52W4gWiHC3MCOyXAkRG1mdhHl+F4152eKtQzdCOi6QmIjlyZx7VRDAxz0D0FQRtEJYv3ohlmMkxXSO7y2hUl5yzhf522cTx4xSF6xebXDaoWuUyndwMEgkDFqyGYXYrR5VMY2AQsRA5Li9GHIv2aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RiCup2i00DJxkDYojNOW+GhGZrVIy9WJJ5TZLNebT3U=;
 b=cc4F7wdJEXCmuAX2iq6NB3/7rVuQKURs8CXrHha4zOtCyFwqhMc9MBjGEu615dnJoB1EvrsWGJFQCoqCUMVoMLOswuORlj9XKBJpOe6+fA/IyMo69FDUkFQBLqBJt51kOzFPA6Wj0+rQrz8RlsXPkeAYwyf07WJzl2DfLA0R3vH2vaGdouEZojlSP85Xznq1FT8MOIbNhl0JdOP4ArfFK5M6llsBuvzQpeOZVYPEDhuIL6m5Vsj3jxNFPvOfogMB9577v9AsgRyNeDfcKhgR1ruxrvS4NC4Bo594KsIkLM7FtAQfjoKYOi1nnUPThrQ8hUN4MoaZM3JdNFOz0F0T4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 AM0PR04MB5892.eurprd04.prod.outlook.com (2603:10a6:208:133::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.16; Wed, 30 Mar
 2022 10:28:42 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 10:28:42 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@linux.dev
CC:     Heming Zhao <heming.zhao@suse.com>, xni@redhat.com,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v3] md/bitmap: don't set sb values if can't pass sanity check
Date:   Wed, 30 Mar 2022 18:28:27 +0800
Message-ID: <20220330102827.2593-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0001.apcprd04.prod.outlook.com
 (2603:1096:404:f6::13) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a5a8c5c-3d33-487a-8ae8-08da12380f62
X-MS-TrafficTypeDiagnostic: AM0PR04MB5892:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB58926C3BD2D7AF8057C52B8C971F9@AM0PR04MB5892.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sveOO+ZUTLAzhlTVOkpeQdPAliquRufCqI5iXxyc96MEPHgIMu6Ybc8heATVInT86qI8XfTqV2/IbLGPYUdX+0k3plPMwjUENIsNyVzZQL5vpjxyk/UwpCRVDkLIiUgqf7wGOZFnGZ4IwF5VLpXNf4mQNt/bvRPOhAIxb4pjOIPqUvxZmRXl8Q9KYeIfAAXUOx3WSotgwjLJY3+/7TgmZakCYbibIl3PhGIGO7Joj2WVDTWbcFJcD54ihStF0YnXu6cX1oM8hdjyGqUM7B63QtBZZdKPnXW34VKHw76oapHTT3sl0zlSNIIc1AvtpfuobMEROaYUk+BmnGQW47BI4GSbYGicXOY/xHwi+nC77QyZtd5KJ7e9nMRKevt7otrSsWT2K2F1FLPUNOycaP9KmsE/MzpBvScl1HCxfWGdCTz8bB/HYWGBa071qNmXasc40uhvp9zZaEoydr1otSCXl0wHLthuMZncKs3nfLlNNJgR9uU2vW2cgEAnw6Aj2RTyKNAgkC3JS4Hh8w7tpW4ZFYt1JlCC25OFE0RgnA88Xg4yCX4HJN2YNlNTQP5iQyPuGndk7YvixurG+Qj0tuLDDlx9fbf+5qTVcLAJz4rRDSYjXc6FSDbSb5LuGdAn+4RlhxDZ64V9e+E8Ai1FEP2XCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(5660300002)(86362001)(44832011)(8676002)(66476007)(6486002)(66946007)(2906002)(8936002)(4326008)(36756003)(316002)(186003)(54906003)(6512007)(2616005)(38100700002)(6506007)(6666004)(26005)(1076003)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jaUCgCE2pZxx5NPTduTf/9pPrYkZAnnCVRlz00Xx43XI9UBseVbDLZAh+e3G?=
 =?us-ascii?Q?yNVrg9cqkxRA0KVAEfcCKqufc78vVe03HXAlmkPKOx7uwhcTthp6K7tN9Ijv?=
 =?us-ascii?Q?45y0Qa6kQFpcms0bLwiCfM0UnrSDYSRIZTKPuUup0MgpKF6GJebACLQc7w+l?=
 =?us-ascii?Q?LMc62vRlZJ73Hk1uQa+DZCFpPFBdoYZbwg2wV/krkjX2qQrEgAPhLa8SRL+v?=
 =?us-ascii?Q?9J9WKBbyZrZTHrNn5gHybqOaKmtIw0mfc0YXNfFPHGiwquNINq94v2rAHZK2?=
 =?us-ascii?Q?cKjsKGOWBqAHLfVRNO7NtNcbs8+kXPx4L5nR+UEwoq6e31rucxhuVodJKIVu?=
 =?us-ascii?Q?6ONqk44RkdjASXTjjwy0LpjM80GmmhvoDZ9X+e5v+x0LD087ZcCuT3F+eDFj?=
 =?us-ascii?Q?0QIDPIXtf4kyveakHn/p40JBMDjq4St1/XLw+WLlSlExW8rYxT2CfzMBJH1v?=
 =?us-ascii?Q?4cwN/rmsuUea8B7XGwA33Riv2Iug6rJfCGodIl6Bf1ATQ5uPr+wPGUjH7XcU?=
 =?us-ascii?Q?KtnKscbkaZFlpHTb0X9INFE0ha23nEq0jMLWZw0jA5OSSyd9ARbOQFlksPZo?=
 =?us-ascii?Q?HN6tlxx0fLUHzeWnjdXu6uSnFepCDPUfIlrKpN/GEz2HVQ6tEKgpR0jE2a6P?=
 =?us-ascii?Q?zxmLIz3PuA5buMI+a5L/cgx0MJbO1/hHrWGzswbalDgRp/1IcAdo5dOblgiR?=
 =?us-ascii?Q?0FThLLlUL+1kTganitc6Zh+nwHwIdCIeWYonm1k/kpQET0M/p1S6fFKEev+4?=
 =?us-ascii?Q?ldWadcy00tRIwTGwowKN8Haf1NUbTqPx+grR/4+U3gpdsF+JEXQTwk4/fzMt?=
 =?us-ascii?Q?aNuLESvJjxl5Z4QswuyU4ZsZdbWqIMNPdTf61MzUbWJF+CG7T7lp8nw4Q2Ok?=
 =?us-ascii?Q?ramLG6+nO7EP3W2luKGIDuxL2P8CxH3xVRKvcjdlejPl8V4L680tjNcCDM90?=
 =?us-ascii?Q?ERmodUJfe0B0u87w6SKTduxQQBhx52hVc0lzAFJ5XnV9a2vXdDH5EZXEZkk+?=
 =?us-ascii?Q?PKaOQYTe2dJRAbcH9bu+RI9qQ0xkyfwk16Y6Mb3RL0LCRHzkVAbxKP0F/ypK?=
 =?us-ascii?Q?F+XgmBHhnTh8fOSCFkM9y/xFHx7qYXH0Mge0k568Mj1j012Lab/JcJ4T20ks?=
 =?us-ascii?Q?A+Qo2rP1b9Foh59T1OOiMZsjaEvpY/DyyalTgFbu6cuj5pTiE8SzOhRvZwJ1?=
 =?us-ascii?Q?CniUpczoK7Cq6UjVK9tqH725Qv4b71nCjg3V+Wse26y6qEZGISY70lAHsvLO?=
 =?us-ascii?Q?FA2aec/+hVS9sRosRHK39xuUUkerhgga7qxm1fSaD1YCzxxz4p2mX687RQII?=
 =?us-ascii?Q?XidCm9oaBi3e43X+dst9W7RA1G8YkEJK3HZChD8+F9594grxT1CzYdCPAzec?=
 =?us-ascii?Q?mhgGWoTWybtgKjElosOmM0IOkzuNuPx3bMfuekUmgDiyxTLeDB63kyKJmFHF?=
 =?us-ascii?Q?+W5aVf2C+YF9LS+Acy6QOSVYcwBCx06RNQjk/uKl/+DEYU1wBVpqPqd8T8jy?=
 =?us-ascii?Q?7muIz2q7Ahhyh81khG2tqHQT1AYNW47TQ92ydHVJoRXjlrpSYbW8pnGjGvFl?=
 =?us-ascii?Q?pYZuVprfmpq6ah7GdOCHlmovgJgBU8MoZYlmiG6nDPGxQu1/5+rMBL7bQs1f?=
 =?us-ascii?Q?gJ0QhkS4YpYm0LJfN/qsW+MSOgV3wBIAW2vP6/5x0AMymzvrEItF7gRgGd0i?=
 =?us-ascii?Q?0ALoLbwBLCOa+Awo9i1UnSa6zMGZFkQjTAafInG8q0RChj1yoa+VEzTr7dG8?=
 =?us-ascii?Q?Rdagp5XZYw=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5a8c5c-3d33-487a-8ae8-08da12380f62
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 10:28:42.0680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6R+2jW7EM6XWTdCdMB8v3sL7VtmVAbeFXSgWjuloCpFX2qSldTqu3AuL/pl4iDC5R0hM8XWb1mp1e+zPxBcBYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5892
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
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v3: * fixed "uninitialized symbol" error which reported by kbuild robot.
v2: * revise commit log
      - change mdadm "FPE" error to "Segmentation fault" error
        ("FPE" belongs to another issue)
      - add kernel crash log
    * modify a comment style to follow code rule
    * change strlcpy to strscpy for strlcpy is marked as deprecated in
      Documentation/process/deprecated.rst
      - note: strlcpy() still exists in md.c & md-cluster.c
---
 drivers/md/md-bitmap.c | 46 ++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bfd6026d7809..c198a83c9361 100644
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
+		strscpy(bitmap->mddev->bitmap_info.cluster_name,
+				sb->cluster_name, 64);
+	}
+
 	/* keep the array size field of the bitmap superblock up to date */
 	sb->sync_size =3D cpu_to_le64(bitmap->mddev->resync_max_sectors);
=20
@@ -695,14 +697,14 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	if (le32_to_cpu(sb->version) =3D=3D BITMAP_MAJOR_HOSTENDIAN)
 		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
 	bitmap->events_cleared =3D le64_to_cpu(sb->events_cleared);
-	strlcpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);
+	strscpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);
 	err =3D 0;
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

