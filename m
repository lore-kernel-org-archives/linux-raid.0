Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A03C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 01:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbiDFB2D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446795AbiDEPpJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Apr 2022 11:45:09 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59684644E9
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 07:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649168345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FwnDyAtPWTyiJePpJ+2W37Pyf2/wW3XgfO6QP8yKFZo=;
        b=OZOKLSDhRFinZaPeZEfFMFNnSMigH1B0nJsKoBRGNv065+RSq2Y8MJKrtzIwsWVt7M8ojA
        oHCTnzHkyPWvKWMWiS8dIJx8KIR4pcxH5cRTHbivQRuXY1ZaXS1Bg5bbLBu9ouSAGg24QV
        jQijqdVTXLHAT1R4lrcPXaRxXWqyrAo=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2059.outbound.protection.outlook.com [104.47.0.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-18-OJkwou3eOSOF4QGprKEJvg-1; Tue, 05 Apr 2022 16:19:04 +0200
X-MC-Unique: OJkwou3eOSOF4QGprKEJvg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fovXg9FHbjpp3hUnMyJByC3Mjg6nbQtmDJKsR70oB9OHOaOwZLp2tQdrWJ87pZQ2zcYmWMvkZ2ByvZmuukg8FGF9kNp8eO+2tWOd2T8yI1R0WpsSjTHlJ8Bp1snoGg/xyLIBrh08FC26MHBWYMjGqrmkkUDMBsJMoI50W49rIXr2K0RZ/RuUGMvCXuqFqlbP7z//llX1IGlSKT3Fm7SsU217p86DXiWm4W9oPO4wUYzcTmJs3CdZ0cEGfoAbMF67PANPvZoGWiZ4kKrgo2mifOnN7CoctAokldi0SfMzfSlmE1VqLCATQEr1PUvdwH79LO1utFu7x996wIQ/jqnwpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=39uH3L2Pfdd2883e3ZwFbSHqOqvRHpBaKYKu6w7RvNM=;
 b=Dlw1xw++SvI8eKTNWbZ+bPU9Jj5F7GRPWudRjUNTD+e/Qi32jMBZ1UKCbLWc18d2HxymKcN2tbnPf7Gi7edMEYaS7S8QhjUxEoKT0gWv0Xil6RqTM9TRZVQZvmrN3Fc3BuQdmUcRRVAbkNiWNRBJb4IQlm2E1EE7B3ceukHkH8edQFa3RIdRL9PrdM7JDHxXpeSr1ecfY1PsFIzvQIDvZwyaYNg/dQE8nbmn4QU91Z8+19VUOdcxSO+dr1PRa+wxWmIvE2sLD07c/jMneTxJ/gkoZ0I5CZp0bAvMKl45u23rLquffq3DgyR4rD/kCRhnvxnCSHLg4mQIlU/3eE84uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR0402MB2869.eurprd04.prod.outlook.com (2603:10a6:4:95::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 14:19:00 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 14:19:00 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org
CC:     Heming Zhao <heming.zhao@suse.com>, colyli@suse.de
Subject: [PATCH resend] mdadm/super1: restore commit 45a87c2f31335 to fix clustered slot issue
Date:   Tue,  5 Apr 2022 22:18:48 +0800
Message-ID: <20220405141848.1439-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0017.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::22) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45d5e029-120d-4d55-9942-08da170f3a61
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2869:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2869BECB2F91C30FDB9DD66997E49@DB6PR0402MB2869.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oAT672+WVKgNM5yW5xmWX11/yLep1ikVcL8Ow1WPUVtkpyiC7sSqy9nmhRWgi7s0C9mINNljYtTJ0Tpiv5KKFvKDlUyahMwZ9x5mnyBN5a4HQcz3ltVpA9Vfd0Fzg3rk9OGYdhVkglfwCjGZw0u5r9g/FPYHbvMa2YM1s08TroEioHlU23XrFGrtraxTUglOdRg/XPusQuP4Z2pMGMyQQRIJqJrccxIoMihNhpH15nN8LAltRuKLqLe3004WUbnRltgSXEKKqNdvCFJRdzcQhgPuTVhStVCHYv37h+yuqZ2xfnlmETTE08CM7sLd25vLnXRP3ccISE+r4vM3RkjKD0j/zOpdgjheu2m8E21dYxAJqaX/ZINqnCbkWs4NYKmKOjXa6U0vzKwuYGiNcB+7ECx7Qmwp35nB7q3Vc+vKPZhhnck2O/4uRwXqsmB5vKNXLdxAgep6Lk+2M36rp0kTx/yJ5uajIh+9tWr32AugKJiUxXX2f5TiRgwSHoXLj0+g2jKlYD/C2Tfo8NcyAuIcXCjx81/4WYzNSoSOXAIlAEOU9V2ZCpoww2fvXRPg95V0WFzgNrGmpiLaHtnIowZ4FUAQva3bDeYNN7UOP4q0MT3KHqpD0+650tWCgEw3NnVoEIj2S9h28h8x6lDQzFlZTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(26005)(316002)(2616005)(2906002)(86362001)(6666004)(6506007)(6512007)(36756003)(1076003)(186003)(8936002)(5660300002)(44832011)(66476007)(508600001)(66946007)(8676002)(66556008)(4326008)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FrXhHnNDZT5R3BjvwDljdudpJKh2l8UxQjJJ7DlFFENZXD3/lwlC6sjpPevC?=
 =?us-ascii?Q?HC86lQgdFakNqXw7yC8FsWS1F1J1BXPxJHP9rqSslIl9+WLhst1/WZ3/S2zY?=
 =?us-ascii?Q?TbIj/+PQLMSMgTWaBBsK2+lPd6tF8NMCKfymgoAezVK001mC6I/bangDtVq1?=
 =?us-ascii?Q?Wc8czXEA9Q9LveVEbk7T4B/lfuQmxPWwGnWcPtBq7fLrCleS8H0me2Gu6/yl?=
 =?us-ascii?Q?USAVVg9AlF27o7xI3PTH7n7XE7sT3us8NqTW7O0Wi0S63vAQqW6xn4aNKRxl?=
 =?us-ascii?Q?ZqvYcw9wLmRvX/YHYfWArbWUGXFFTipG7gj5l1yuefDQHLVcBLEQwNgqNAVs?=
 =?us-ascii?Q?vVicchDitLi5V8lsmNkg/55uBJSPRkQ2o7XnB/A6BLTzjSL9GVTmKlsBcmsj?=
 =?us-ascii?Q?E/XY/NuQtK7hCQACu5/lidhQaM31itJV5xSmKzt9cHuJ0mN8EEIjdkNK/yFV?=
 =?us-ascii?Q?qV2UbWdxpC6zHDCTvXY28INiKj7+wmEFukMPlr3/1/LIJG48FIYnOPA+qPx5?=
 =?us-ascii?Q?0zFVzwgYmKuuZRod3sAzLvvxhBhhbds4Sq7B6KVMPqLtRssCpXXrqxaF1Emd?=
 =?us-ascii?Q?YQi1FZJBHauf7pqp+t5t1BjkRJ9Nvw0y4mrx7d1aTfco9c37D8OkFRfBH8zO?=
 =?us-ascii?Q?HNGKh5i64gRbWavuuwWau7t9A8WYWOihCxN0vpv1LlwJthvR0enpvIImehTZ?=
 =?us-ascii?Q?1Fx0QMrb6isDRyy8nmPB85oZy+4trv9+0wcN6fR5+sPu/jMBK+4sHvQURx4r?=
 =?us-ascii?Q?vUhrrdzSYAD+rV1LPyc5C0uLNpGLGt192MrFraIEfUayGrPoDMBz7lAdDmC7?=
 =?us-ascii?Q?ln86+HF3B+0Emnen3Dzg4Gt6udTeShc4WjrQDoXtn6REDI7/tIbc9+HXcw6I?=
 =?us-ascii?Q?A5Bopd2/z4cyu/SLOo1wDbsZ1rW9gc3Bk+i7Bl/NFlSm6RmzUZuYfLsO192e?=
 =?us-ascii?Q?ZsvHFXh/TuwmbFcbleGcHpPhJHooGtPIPyPaOXYmBAouXKMrTjetxpjVEi1X?=
 =?us-ascii?Q?oxXuk46mpW6HUg0paxhs63Hr/5jJHF4fphqDJZ3t0rIDhsW4oNmeLO03JW7k?=
 =?us-ascii?Q?KJ+AzymSNAjs0Sk8LtOgatX6KxXfdXVJboCtFGO6kQtez6OrxUI+DrZYLAQq?=
 =?us-ascii?Q?ihInYNJ8wwLGuAkvzSExoP0gJeulg+NQ2uINVSUq9eE7XFR53wSUQWHVg1Pi?=
 =?us-ascii?Q?TMdmGNjgy3JhvvBQkmjdLwcXETKgriR5gLxoqxddLQ3la+Ve1ZvScXqL65BJ?=
 =?us-ascii?Q?xuwa4ab0k8eCWFYas9beDhepQaQHMyAFXH61mEhvZjF98iw21C71F0iQVce8?=
 =?us-ascii?Q?udGOgIzA5YPXqibsUKWWI6hR0q/+XciZxIjvVhrqaV/zSFjlAHbZQC7604zE?=
 =?us-ascii?Q?pqKCc+9pQraCATYv01WZtCvgZyH+7Ml+i0f1v98/6fD7pjuluGMBIHsZAv3R?=
 =?us-ascii?Q?VrMpeQUgwlQgT4AtAIV42FdAD3y3ShCwMGWJ7Z9PZqxFbk0Mr1ejQ7pNwM8W?=
 =?us-ascii?Q?am+c49OvXOjpUwOpiqtGEMGz7RUVEkgCLMA4gE1rSejFRlvzRMlxR2JWQ1+f?=
 =?us-ascii?Q?jm0r7fSYcf9sDocQQ16s3gNC2zgEGYFr5wO2xAiLUKW/MQ1brVv2LxuyaQDK?=
 =?us-ascii?Q?m6WH7X36UGMDcJqKVSZxANshtCBc9f+1qS67iRX8G6vIQ1FzSJjCQO6sg4kW?=
 =?us-ascii?Q?UqTedu72s3fkiTN4z2KjTcUFdXmVsINKf9zNP8YPKq9sh+Z1eHDv7AVORqFg?=
 =?us-ascii?Q?tNw2mqaFTQ=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d5e029-120d-4d55-9942-08da170f3a61
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 14:19:00.0894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3iQYN02S2wDUk9VBfXlyQUFhmykVgPqcZtoG3HrJ4vse3JPh74tGpCmIyUj6hyTOSQdSgZ57FL0nXgc/gZcLsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2869
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

Acked-by: Coly Li <colyli@suse.de>
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

