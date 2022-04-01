Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FBAC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  1 Apr 2022 06:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245333AbiDAGUq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Apr 2022 02:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbiDAGUp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Apr 2022 02:20:45 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E72654C
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 23:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648793933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XeJbGwB0MuL3pJ7T41bZs3nAZ3G8AN4YcuGPMtXq15s=;
        b=BB4MZhwHRmcVftq/UndYTFwearVk8QS/fwkqlnC80i6ctMWqEgpehFJX6cPfj9wqXLXgGf
        uxuXVJ2cmjz/3agQb+KCt+N7Q4WJfwon8PPfpBCyu6GJkXBevwmmdr0Z3Y6wmpzvwzeO2S
        6aPktBiOXstF6WE648da48p9R1Q52p4=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2057.outbound.protection.outlook.com [104.47.2.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-13-3NL609QTOCifoK_I25tNnA-1; Fri, 01 Apr 2022 08:18:52 +0200
X-MC-Unique: 3NL609QTOCifoK_I25tNnA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfDV21hzw/5F18omQZEUOXf9kPpMQEyVXT16zxgAFeeJVcBvN2VMS5xlL45l5uRSnG9qG4Jp6ZkjDqULpTjtkxZY+2y67UNwAhPUu8rbPB28oz329vkEzIi2QnB7O1m2zCvEvfmbdOTJoL4aZsMS3gxtcl/5nFj1yLDykyWAxqRU91MHeyfEfUT68taA1MqlLbruVeYfgeNcbyHsJWw4qfDwWLUES+RvpWlYhXUPpVd0/XUxuEMc3MbMoaPg5EpFMhOdX+MNZLxv6rYYbBsqMwMXFTd103L2aZsEf+u+9r/VdDl1hpEE4fV2ou3SSsighEItV8BQKK+AV+I0jKLFsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ozV0OuH1wbmRyX8DtWkFbPryIuQMBwooRzH3VDAvdE=;
 b=YL1vkSHir8HwFVSRWcJzA/kExJBQgqUo9oxwXYDpZv/Ca6/QzzP1H4Qa88kYqhtHWUTcyut5r893UBO2BTU9DzQz/FjT4/gY2dZBz0ZN9HrFoAh3eMHXoHcrsVSSLV+QaABmd2tqGy86lmxUHKkkjhIz1j8403NL01y1jT+8mxLYk43wf2dMp7qhE3RR9meqHM0Wlhl39zzicLNusPF3U8n5hlKP8XwmlWFGD/2EuQ9lgqAwQnpD3ckO88a0ezbHq7670Tw6jjnbZbYFK+Ak6tgypsUM4c+uQXMIJIp7wEuK4C8fmH1a9b4cknHjtvqKgA747mTm49kPfxPgoO+arg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 VI1PR04MB6784.eurprd04.prod.outlook.com (2603:10a6:803:13e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.25; Fri, 1 Apr
 2022 06:18:51 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5123.025; Fri, 1 Apr 2022
 06:18:51 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org
CC:     Heming Zhao <heming.zhao@suse.com>
Subject: [PATCH] mdadm/super1: restore commit 45a87c2f31335 to fix clustered slot issue
Date:   Fri,  1 Apr 2022 14:18:40 +0800
Message-ID: <20220401061840.2067-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0025.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::11) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 059c9e57-e5d8-4b07-3da0-08da13a77d5a
X-MS-TrafficTypeDiagnostic: VI1PR04MB6784:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB67844B39C306D1EBC3336AA597E09@VI1PR04MB6784.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uBCP+9Xn15vPn8p4U7Xf/LxXhRF9df8Pq+8EUAha8mC0m8+H3c78EkpNPa7NHlWqtZEHZuAm2iRrCoYqUP/Bso4lAJT0twRhV9RWcOeGkNWnrtmVvhwoCvPdQmQhM5p7demSoHNdU+mBUqGYb8BpIm2crTgKxHMs0BKpKwQZ1bQ5nPbpqJaI45RMrvlPx0UVmHYDMGGapnnsS3ng34qIHdaDQaLX6Ct8L9xAfpT7rLENVZJkiOCnNGIKBBldUYHk3XiWaRIu11DLYHovdwRMKMcTxnjFOCpHw9fgi0rGEQtkMMqO5jK64fhve6In/0YKoNKB8lDKHncNw6CgsvEd/Dq1S3aQUxda83nFB/PVn3vYPSPohGunsoSYQnJ7FIdSFqT1A4bkW3n86eqPWI110w7e5L9X+eDhc3yq5DHxTFftknelYXpP/8E9y0JHTwPx3l41E1yguOKFlGR/EiGm54m6kD2qnbc4r2JzBNV0eUcPs4RbPFDV3V+Hh5dB9+kX2CNEZqEAMPLlFG2IcSOyo6WCt6rjguVbP6kHlKACwTxNqm24a11MQNzbk+yfV887A1Y7Rauw7OKYjR6Y2FgMaqY78VClrqcLrrMQqy/QoYoTW7a2inGURJ6xqfWFVgwME1iKAZyTz3GGITuKjGXASg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66476007)(66556008)(186003)(26005)(4326008)(66946007)(2906002)(8936002)(36756003)(316002)(508600001)(6486002)(86362001)(2616005)(107886003)(1076003)(38100700002)(44832011)(83380400001)(5660300002)(6506007)(6512007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cZOPlIrEQXgf/eQuQgqgdOM8qdoRRxxbhsI77YWognXzwREh/S7vk7Dffxp6?=
 =?us-ascii?Q?YaDBawTTTo8K1O5OPZc3/ZgtuI9mMhzLKzhFY55Mm0M7DRKVBLH4X6wb2L4c?=
 =?us-ascii?Q?qVjwO/imnCNAPJJ9/r4fxalz5Tbe6Vrn3qclLZhlCc8zw7cDgBR8PKv/y6dr?=
 =?us-ascii?Q?9Pg3b9ZvgqElVED3NUmGfsjFcyNNlB5JO+p0ko0G0meI2GpX0+pPPYcf+DJ8?=
 =?us-ascii?Q?SHuxqsoL6R6/ztO2ppM2RoS7zhw2zmxdpAy8Lg+8mZdFJI8+ExgeNw0N82IN?=
 =?us-ascii?Q?ZCSXKn9EEgueqltskM3wBYMgNYwgmMq70rru+Hu40X4SQz//FFuZMBziWCE3?=
 =?us-ascii?Q?jH0MTCn4Fqus6J2adxnLqsfbERZiTVmLDh6N37mB4qcxudFTwcgcAxr1MJ3t?=
 =?us-ascii?Q?5aRa76GCil33MZun+O1AJLKzOFn2wJ8edO0tlc7X207kkiVVkrnFUol/g9Vx?=
 =?us-ascii?Q?yMQJeyzg8WiaTXKacxOrWY1MY8CqvXyBa9bzPJV4LSisP7TuWHng8M39MkTn?=
 =?us-ascii?Q?jk5ND5U/ScUt8hXrS9g1n+YtnCtOa1/W9YNrGrBxS6oHLdTxoMlsRCAQ+Fo1?=
 =?us-ascii?Q?SlasC2kqBl7Z+4Il2dWOSLlNfqQM9WbnAXPg31TnxzhoTucquB5+s0Q6/sQ7?=
 =?us-ascii?Q?0NX0K8gDFfuySLoxbSJmmmC0zkHc6c5LhNlMhozdMe24UBFWMUUQmYmwkAPF?=
 =?us-ascii?Q?beZQmJ+KtuzSpfWXs3JUVOtCB/SWHUfOPe3PABfleViaGvJdNKGqXJOGbF2W?=
 =?us-ascii?Q?ssfcqCvV3twh3tCRG0AMp/7nq9V01LxzG+dmMno4ReDmTn+GvAdrYQGL4zXD?=
 =?us-ascii?Q?8IzW5PJqxnvC/RlU4PRqIOrxfyAK/18pLf25b2clZq3q/RqErz4b0dDJlzTr?=
 =?us-ascii?Q?NZn2ZmklRmvopw6KpuqpFTcvl3uUnSxmFE64yWfKE0jzjm0dkgy/Xx5xj25g?=
 =?us-ascii?Q?uTMaLYtx39ogS0k1igUvumid4ZwrHeClkcYDAwI9d/bP9aaq0sK4RnCsh3XZ?=
 =?us-ascii?Q?UsknB8NxgXnf3KME8Q0YLJeEecQ0IFiZs2SaAb9Y7xHydS26587d5IZIZWS3?=
 =?us-ascii?Q?TiRp1zGmGPIIXl5YkNGYE3UQn+5jaa/wxyIlulghiDL6FixCplo4qemlv3BD?=
 =?us-ascii?Q?kcksNr5EtCbvDZCoW/uXeh6aksr1qmjBf3KhRe42qyHv49Yf4j4kOo4GXQZA?=
 =?us-ascii?Q?qacj0dxA8EH/5Rm7DyRRImI97CBBZj24l+emmJxa2yj1zsVp/UU4ZphjRDcd?=
 =?us-ascii?Q?r8kEewu64k8Mxbx7UMpt2QSRWMG8pihpmetqJwG5FlZWDjcc208NkfSMb5Tx?=
 =?us-ascii?Q?O6IFfg7pgEa5Z5x1u5eyG1N/2ozA8uoZBiQM7qEVltfbF2loV4YXpS073xRH?=
 =?us-ascii?Q?ILZcac8Z3wDN4lOJfuKfIHa1MkM7chqppC+GI222RG6lcwNVWCDlfCgNHll0?=
 =?us-ascii?Q?jgegOFgUMLylsLinTDDtdTxJSMZJLQyfZ/e8691rUkja5Qk7T34VLsYnrxbd?=
 =?us-ascii?Q?EFjh1WWNVsk24IWej5dVW5oVc9Cn+2NzRqBoYQDYzrLPuFuU1YswFUos5czf?=
 =?us-ascii?Q?N75dxoPfVJAJr89pGjVXqbScxfs2dZyGr1VA6s+fD2MkR49m0ogjiNg4/DsZ?=
 =?us-ascii?Q?8ZZHdQ62NhIlZk4SbbIuTYENWAMQAHgJ1GwsuLl3Z/48HV6yOVzyDYTAMRNj?=
 =?us-ascii?Q?5UEhVZUMYtC4L6hds5+yaUHLbpBNy8+oo3ppIZRglDsjjnKWgTjECxdvB+CU?=
 =?us-ascii?Q?H6bQgPddlQ=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 059c9e57-e5d8-4b07-3da0-08da13a77d5a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 06:18:51.1128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4LnzCiLps50NrDONuGB0/pf5fhAhQvuQKkfqRmwZcjQCZ/+J+D9k9/1M5mHyny70GeILWMxDm5h9MDLkwr4kLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6784
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Commit 9d67f6496c71 ("mdadm:check the nodes when operate clustered
array") modified assignment logic for st->nodes in write_bitmap1(),
which introduced bitmap slot issue:

load_super1 didn't set up supertype.nodes, which made spare disk only
have one slot info. Then it triggered kernel md_bitmap_load_sb to get
wrong bitmap slot data.

For fixing this issue, there are two methods:

1> revert the related code of commit 9d67f6496c71. and restore the code
   from former commit 45a87c2f31335 ("super1: add more checks for
   NodeNumUpdate option").
   st->nodes value would be 0 & 1 under current code logic. i.e.
   When adding a spare disk, there is no place to init st->nodes, and
   the value is ZERO.

2> keep 9d67f6496c71, add additional ->nodes handling in load_super1(),
   let load_super1 to set st->nodes when bitmap is BITMAP_MAJOR_CLUSTERED.
   Under current mdadm code logic, load_super1 will be called many
   times, any new code in load_super1 will cost mdadm running more time.
   And more reason is I prefer as much as possible to limit clustered
   code spreading in every corner.

So I used method <1> to fix this issue.

How to trigger:

dd if=3D/dev/zero bs=3D1M count=3D1 oflag=3Ddirect of=3D/dev/sda
dd if=3D/dev/zero bs=3D1M count=3D1 oflag=3Ddirect of=3D/dev/sdb
dd if=3D/dev/zero bs=3D1M count=3D1 oflag=3Ddirect of=3D/dev/sdc
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
mdadm -a /dev/md0 /dev/sdc
mdadm /dev/md0 --fail /dev/sda
mdadm /dev/md0 --remove /dev/sda
mdadm -Ss
mdadm -A /dev/md0 /dev/sdb /dev/sdc

the output of current "mdadm -X /dev/sdc":
(there should be (by default) 4 slot info for correct output)
```
        Filename : /dev/sdc
           Magic : 6d746962
         Version : 5
            UUID : a74642f8:a6b1fba8:58e1f8db:cfe7b082
          Events : 29
  Events Cleared : 0
           State : OK
       Chunksize : 64 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 306176 (299.00 MiB 313.52 MB)
          Bitmap : 5 bits (chunks), 5 dirty (100.0%)
```

And mdadm later operations will trigger kernel output error message:
(triggered by "mdadm -A /dev/md0 /dev/sdb /dev/sdc")
```
kernel: md0: invalid bitmap file superblock: bad magic
kernel: md_bitmap_copy_from_slot can't get bitmap from slot 1
kernel: md-cluster: Could not gather bitmaps from slot 1
kernel: md0: invalid bitmap file superblock: bad magic
kernel: md_bitmap_copy_from_slot can't get bitmap from slot 2
kernel: md-cluster: Could not gather bitmaps from slot 2
kernel: md0: invalid bitmap file superblock: bad magic
kernel: md_bitmap_copy_from_slot can't get bitmap from slot 3
kernel: md-cluster: Could not gather bitmaps from slot 3
kernel: md-cluster: failed to gather all resyn infos
kernel: md0: detected capacity change from 0 to 612352
```

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 super1.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index a12a5bc847b9..f08d4f831319 100644
--- a/super1.c
+++ b/super1.c
@@ -2674,7 +2674,17 @@ static int write_bitmap1(struct supertype *st, int f=
d, enum bitmap_update update
 		}
=20
 		if (bms->version =3D=3D BITMAP_MAJOR_CLUSTERED) {
-			if (__cpu_to_le32(st->nodes) < bms->nodes) {
+			if (st->nodes =3D=3D 1) {
+				/* the parameter for nodes is not valid */
+				pr_err("Warning: cluster-md at least needs two nodes\n");
+				return -EINVAL;
+			} else if (st->nodes =3D=3D 0) {
+				/*
+				 * parameter "--nodes" is not specified, (eg, add a disk to
+				 * clustered raid)
+				 */
+				break;
+			} else if (__cpu_to_le32(st->nodes) < bms->nodes) {
 				/*
 				 * Since the nodes num is not increased, no
 				 * need to check the space enough or not,
--=20
2.33.0

