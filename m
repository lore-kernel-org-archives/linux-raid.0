Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8904C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 29 Mar 2022 07:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiC2H3Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Mar 2022 03:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiC2H3X (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Mar 2022 03:29:23 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202562467F4
        for <linux-raid@vger.kernel.org>; Tue, 29 Mar 2022 00:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648538858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7vveOMS4F0+dz9t3J5uP+Y9dNBK+w8asdSHt9ejiIXQ=;
        b=WoNCQB0OWPa73AvSbJqfWcKfgkErriPJxm0BbMg8STxaTrPpmNDHFMA7DoSn8NaK+OvL07
        gjr+p0NiuQk9OLohmifI7w8IeYsVx/VfIP1as04jFW/SV4YBld2tVRmDY07mgDDetcYblS
        /KMYDehgbcuwVQcsrxaFCaK/81e+XoU=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2058.outbound.protection.outlook.com [104.47.12.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-9-HXE0WQw9OVyV0yfJDPgtLg-1; Tue, 29 Mar 2022 09:27:36 +0200
X-MC-Unique: HXE0WQw9OVyV0yfJDPgtLg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQmm5b9sVJUo1KMCvU+FI/Q2rFscX7SXohbqonUDeud9nnosVCmPpUuve3CQ5pjjhtYrhFCXrrXWg9w5I5cRtm3+lRvH4vWLBM3RXmvkl2RjmHfMetVDwXklgjqjk1i0C78LbZsQA+T2DqSjpCDbsYWGrHRiimMrib9elRPwaLA6h2LfnvoDJQtc+gSxzmTBoEu1jtkpiBvtIvNSEFnu+e+z9Ta5aPZTk1BmuT00hueeuBpABDODS3y32nw2VN5YgdrFmwIT+Ccm9eMeY0s0SrYPETDGo58hGy8GZ+swv0ArQFqveXgFsIaiaO9AaYgSZHeE+EOmdEHlK0ZuFApTaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAy8235hsDCiyjr+9bt37k3fMhNlNYYjwVny8eko8Gc=;
 b=hCPjJ5hrawUVtZr8EporfHzZR20uuzOiB4D8IWGD8v0UDV571PbhpbsCO2fMdpDwYAbTcGWXgX3CAP1406hkha0ab7GrSqH4UOJFJwCz2jLPT6IiV8ireAAuwFU01pjRAeMLlVERKYyAa8OeenzdPskBa3Gu4Dm1BtTEe1zO1ejCRQQ7kyd0ooFH/JIYAwmZvQrJnxxKvGO0nrciMuQWaAKw7yzy8vJvtoKWXjCv4OpodGVSLmPvCWo9AvH7tqemrqLYIcgxfjMVcqWVU237KMzhNS8NoVzFHQLjyX3Ku9B8IGSuEIRmEQeI/XvCO5zE0wHmABIBQeA55qFouHtfKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 VI1PR04MB4462.eurprd04.prod.outlook.com (2603:10a6:803:65::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.23; Tue, 29 Mar 2022 07:27:33 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5102.023; Tue, 29 Mar 2022
 07:27:33 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@linux.dev
CC:     Heming Zhao <heming.zhao@suse.com>, xni@redhat.com
Subject: [PATCH v2] md/bitmap: don't set sb values if can't pass sanity check
Date:   Tue, 29 Mar 2022 15:27:22 +0800
Message-ID: <20220329072722.1786-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:202:2e::19) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9169c869-f68c-4bf2-16f8-08da1155972a
X-MS-TrafficTypeDiagnostic: VI1PR04MB4462:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB4462F265BFA4FAC7895D7DD3971E9@VI1PR04MB4462.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aCTJb7Dujwft5xV6j4FHz5+IPfRfVUa45cQ1z7ErlcLv+bJWBpfQloFsYGMObePHOZahgZCdD3fS6F3xq24LIjuKE0UKCX2AOuqPbB2+EeckaWZi5yf3OSjpqfWeKgwCm3gys9S7a8JrHT5q7MrqXeletOSKh7f6oB/KAkGXGXYotqWEhpYZCUhGMUrYEGeRu0BtNUCRhnnoQrdckZpMoVwdq6qHlI8vwsLIPi72moUYzp/1XZGDFA6EQPAiZIc4F3pey1zHNLetNHSSsioOO9V/lzTt/Nj9eet2Y/BXNksInAKH4DLavXhjsecitiepCJZK548/bMOXlYXk32gioPOlIip7UwABOD/x8lHSpQ80uq4jr+dwvykEadD9dHpjPSxSBM4sMvSGUwtZzFxfrqfFsdp3+Krnf91VpXiLBpM3gefTF+gD0xXNz+rtSnEMi3XK3uAlNQLS18Ac5Ha7oUmHWg2LA6W71JzTZ/dxoZ7muUkrpukfV2Z0Jt1QCqAk4cDwmRKN+Mj3/5YJCLStqoJFQtVo040lC46p+fTT1iB50OShOVzGpChL+3jTXsDuf4QjdYXNeJeZmprXTiNlQ1U8LAiTK9GmDnm+Jz1Sr4M59Wn+sqbVEtSTpimNUZG/j2LYuivhAmaHenguOb/5KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(83380400001)(44832011)(5660300002)(8676002)(36756003)(4326008)(66476007)(66946007)(66556008)(186003)(6506007)(1076003)(6666004)(6512007)(6486002)(2616005)(26005)(8936002)(316002)(86362001)(508600001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IJn85X2KXhAXt4kQ/g1usIrFCbjpXwB/gYqcXFe002ZQf0N2JlhcfDeTZZSt?=
 =?us-ascii?Q?wqdwd/qANSCLas36KHK/OYCgeRL6LDJcJ3nUPpYL3hZi0pMzDjk9v/h7XrqQ?=
 =?us-ascii?Q?5JOm3VH5HSjPOdtfDjDjPRDvqugb9mQilF9TBe8rM89XCcDoFYs64NtxAicv?=
 =?us-ascii?Q?wOUU5eyUiF/nURLPNiqS66OQtcWcwOpBNlVhFeoLir3Um3niqmSgyCumn2gI?=
 =?us-ascii?Q?xZ5oSWn7EwuCZkcTk4QEI926RS65Ohy0RYgvIkkf8nN1Ffj0+GL/vGXj3SMv?=
 =?us-ascii?Q?QJb4Ku8r4PkqtHJpMdWCjPKvZZnDJPzRjuAyGZ9xXmMC0IoJ/pd2sdywWHP8?=
 =?us-ascii?Q?xJoe6BUFwf2F8z+K7zsMjtBB7KOjn8ysNTTFZNaIQnG8qsnXwUIjwIdqVZnt?=
 =?us-ascii?Q?3tDyfpLr1t+L36h0lsckizJ/9FBqt9JT78GinRLZLTM+Fxf/rx6FYqAYndj/?=
 =?us-ascii?Q?e8Ayaluy0HqrkNywFKLOzpCZZkptDbeyTnzUJQQqvZGEd5UvbEXsw+NWuDYg?=
 =?us-ascii?Q?QP6ZiiKCwk66SEoRBx/4JglIXpl9ek56t2adLgvvvCLPbD/NbF0j+ExAmpLs?=
 =?us-ascii?Q?eBF5pqGSzPzgUPovo2PR5/MHl2QvrxJsp7BHHdMs89WIczFoOHN/RHrOzd08?=
 =?us-ascii?Q?O9/zipBS3sedbd/grE2fY61ic8U2iYEp6SvNUbVe0apf47u9tBJeeYgI0vXJ?=
 =?us-ascii?Q?g/9Njsb8leW0202aN+7AGa6jFcZclMxMd50Rq0/hVmfKkvu2zdZpUZtqd1Mv?=
 =?us-ascii?Q?VrJlEQTzwZKpiAfbfib/eJxCbU9PYsW4rH0GLq6tDkw2GpoiZMM5V3F55TQM?=
 =?us-ascii?Q?sMMBDXdWOlNvmzuSQ+bYf2q6XPqX+U3APTagyRj7LGVLKdUhwBCgA3t5O+dY?=
 =?us-ascii?Q?2wVUlT6XZk4JiBp9KR+M+ZxZHpV/njc/Q3ezQ9G/Qn4zqC84fENdeWlagHGN?=
 =?us-ascii?Q?3aF8X55/eqAvcYi0R3KX0fuAYATgKJ6EEPARzwkS64UYOcA2AoqZRARgInQL?=
 =?us-ascii?Q?VWeozER1FzlfkfzyacEJiO++uvtr9krPOFfi1MFkNNAPoEa5/7Lbi7cvEpa/?=
 =?us-ascii?Q?EMg2QHnPtYSBBIA8QWEIsFStLsnIlG3hFgh/CGsPm8ufYjbHQYKePmogDZEJ?=
 =?us-ascii?Q?0ADKow2heLocJ+Bk5yqLtuGKJGQnuCGAywysroAhMZlkiyy/MDXuB+uXXpDF?=
 =?us-ascii?Q?Ilcz8M37+aOGh0UZc1LJgpse9vKfdrO0azCjh8Gs5n+Z2HSXW5GwETZ7iJbn?=
 =?us-ascii?Q?ignnWpmqq5qIt/ekpOBss07/92dif8ZhU4vZJLH0LatIGsf2NF39NQwFFW2i?=
 =?us-ascii?Q?bKjhO5W2YIbv8Togy3yuJdTX4ZthX4U31NRezh84YjBBq4czyvs1O6mLGyys?=
 =?us-ascii?Q?IUSzwD8MdGbZ9U1gb10nQaXcP4SHBBI6YRurFxn6jZIU8VJ9SmpD2dCz4Eyu?=
 =?us-ascii?Q?tSnd5xBlWbziAdnr5NFbCFUeZXtdadWLGSIhZDCoGNuz1HdHH+xcIpQdB/Cp?=
 =?us-ascii?Q?hzBJlxvnzSZvL8QXjXhFCjyRjxAQNnjXSoTejAxTRYbUmBI3IhsRntYYX62T?=
 =?us-ascii?Q?deijGu61H3ANUl1N3MkoJSzDNPZwetq9P5ZeM0j7FioaYn1+aW8zLNZyfc8+?=
 =?us-ascii?Q?p2PStpQ/7cktty2fIPhaGCLTrFyUJnKqmoFlTaLOM5lvAy+GMqUWEQqPraPM?=
 =?us-ascii?Q?UEp964Njpxvl/QvxisSo1P4LF6VaNsR9iXieE24comR0d4CBXZTKEj4j0FE2?=
 =?us-ascii?Q?/zOhL6QKCA=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9169c869-f68c-4bf2-16f8-08da1155972a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 07:27:33.4231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtOR2bvGZXjCyEdeXJOOGwt1iOsqN8SlEMoZ0rTb03G4rnvfM0FyA82MKZ10bF5rwS/c9S233lY+y+iVHlwG3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4462
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

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v2: * revise commit log
      - change mdadm "FPE" error to "Segmentation fault" error
        ("FPE" belongs to another issue)
      - add kernel crash log
    * modify a comment style to follow code rule
    * change strlcpy to strscpy for strlcpy is marked as deprecated in
      Documentation/process/deprecated.rst
      - note: strlcpy() still exists in md.c & md-cluster.c
---
 drivers/md/md-bitmap.c | 43 ++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bfd6026d7809..1e3ddc2619bd 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -635,19 +635,6 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	err =3D -EINVAL;
 	sb =3D kmap_atomic(sb_page);
=20
-	chunksize =3D le32_to_cpu(sb->chunksize);
-	daemon_sleep =3D le32_to_cpu(sb->daemon_sleep) * HZ;
-	write_behind =3D le32_to_cpu(sb->write_behind);
-	sectors_reserved =3D le32_to_cpu(sb->sectors_reserved);
-	/* Setup nodes/clustername only if bitmap version is
-	 * cluster-compatible
-	 */
-	if (sb->version =3D=3D cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
-		nodes =3D le32_to_cpu(sb->nodes);
-		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
-				sb->cluster_name, 64);
-	}
-
 	/* verify that the bitmap-specific fields are valid */
 	if (sb->magic !=3D cpu_to_le32(BITMAP_MAGIC))
 		reason =3D "bad magic";
@@ -668,6 +655,20 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 		goto out;
 	}
=20
+	chunksize =3D le32_to_cpu(sb->chunksize);
+	daemon_sleep =3D le32_to_cpu(sb->daemon_sleep) * HZ;
+	write_behind =3D le32_to_cpu(sb->write_behind);
+	sectors_reserved =3D le32_to_cpu(sb->sectors_reserved);
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
@@ -695,14 +696,14 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
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
@@ -717,10 +718,12 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 out_no_sb:
 	if (test_bit(BITMAP_STALE, &bitmap->flags))
 		bitmap->events_cleared =3D bitmap->mddev->events;
-	bitmap->mddev->bitmap_info.chunksize =3D chunksize;
-	bitmap->mddev->bitmap_info.daemon_sleep =3D daemon_sleep;
-	bitmap->mddev->bitmap_info.max_write_behind =3D write_behind;
-	bitmap->mddev->bitmap_info.nodes =3D nodes;
+	if (err =3D=3D 0) {
+		bitmap->mddev->bitmap_info.chunksize =3D chunksize;
+		bitmap->mddev->bitmap_info.daemon_sleep =3D daemon_sleep;
+		bitmap->mddev->bitmap_info.max_write_behind =3D write_behind;
+		bitmap->mddev->bitmap_info.nodes =3D nodes;
+	}
 	if (bitmap->mddev->bitmap_info.space =3D=3D 0 ||
 	    bitmap->mddev->bitmap_info.space > sectors_reserved)
 		bitmap->mddev->bitmap_info.space =3D sectors_reserved;
--=20
2.34.1

