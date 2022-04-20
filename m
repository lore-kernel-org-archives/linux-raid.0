Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B8EC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 20 Apr 2022 09:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351042AbiDTJFJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Apr 2022 05:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350942AbiDTJFI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Apr 2022 05:05:08 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F58DF2B
        for <linux-raid@vger.kernel.org>; Wed, 20 Apr 2022 02:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1650445339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2ziwhbRBWFn6n7fjDkLkdIBol+fdyih3ni/QYdWcnp8=;
        b=ZDkWMN8ST2LrQl1BuRKKhUVlT99gXaqHCU3ihmYqq8/PIbHn7Glfye015W/QgY7HKvDrCx
        erm7jUfHjHzR+y4jaXjA9KzxF9Pom5kK2wNdak/hb+zTakp2vBSbrjodwEE7ogDX1z8ISf
        YXW+OJPcSPwBM3stZyyxT116Z89C8+E=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-19-RncHhBFmOhu2Iiah2d6GXw-1; Wed, 20 Apr 2022 11:02:18 +0200
X-MC-Unique: RncHhBFmOhu2Iiah2d6GXw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heR+3aYirL1yuEpDL5lczR7ygMfhEeMMpEMr23YMWJMiid71637ltxlXFBVqnYv9B+ziyK5Sq1GnB3vWtQHypx6zcqjHL+pHhEnmCPYVEHWDpyzUJHiNkxnPzg1+6deutm8eJcdssj9ZNCN9UkYyvb7IQbkrUZk8BFaTkQP/glWcqhC6v+Xl5vsMaGOp0eL5KDA90UtBh0qNvL0/pUeQ7AQVxzbMFQI9GIAdis/sKjpAefPyj21xBF7cYvAby2QPLtaBImu7m+yMuBMYnzzCONdKqFvMPa6GEb8tZBalZAaTn8xxD8yAzkeXtZgQIfVkCL0+PJa35h6Nzl4GDAmyTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ziwhbRBWFn6n7fjDkLkdIBol+fdyih3ni/QYdWcnp8=;
 b=hW1HCdzTwYhmdIiRw7SI28SAzNYA3OWTzVuJ9jfF5Ky2svzwYKhLh8hJtFJRLFh9t8BYhWnIaogq1aGkzbUNXSaQLpMf8fJHpgD+a21TjTd+/8E4Igda3NrUQRWOQKHRnCM/FNu0CKdrvkBHj7XUqFAuzYIqaWyNwnDhyhYkmEbPIhiziMV9+oErVJ+//zzUj9MN3WnvzUIFmFUBRwa9OcdDRcw3TWrw4NN6vvRcQIIGjLOG28MPCU866hSV70DFHXDCAR5L/1X/HYWdlOHd7aN1UHV3xG5G8y92LuBgXOpaREYHH88ryrjGU7idUp89GABv8/ofJ+ckkyOTiBxUeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 PAXPR04MB8541.eurprd04.prod.outlook.com (2603:10a6:102:214::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 20 Apr
 2022 09:02:17 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::6901:fd4a:e4f9:7688]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::6901:fd4a:e4f9:7688%7]) with mapi id 15.20.5164.025; Wed, 20 Apr 2022
 09:02:17 +0000
Date:   Wed, 20 Apr 2022 17:02:01 +0800
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Cc:     colyli@suse.de
Subject: Re: [PATCH resend] mdadm/super1: restore commit 45a87c2f31335 to fix
 clustered slot issue
Message-ID: <20220420090201.m3f7fvg6amnps2jv@c73>
References: <20220405141848.1439-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405141848.1439-1-heming.zhao@suse.com>
X-ClientProxiedBy: TY2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:404:56::28) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad00ce3f-4567-4a73-ad2c-08da22ac7818
X-MS-TrafficTypeDiagnostic: PAXPR04MB8541:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB854117E2410624DC207B3B9297F59@PAXPR04MB8541.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E3ZhXApwSmV9iyKJcIw9eHXz1344JfzqL0JNNabvaxQa48gMaEQQwVvPW/WeaFC+2UB7AlNzc89DTR/cC77exfC8D8aDAJH04bOXXq8+7t8xhp2XEFmpHFaHzyEZ8J5CuSXf5V/LZ6PzTuIKv617kM6kMS0bkpK4Vn5UJfACaqKmhK7xveB2yQ6gP8rJfT2uv5ANWgjsoRGDGOAGYPQ8d/ZDAZjLNsnk6PHqJx+//Qkt9mEwSY9Vmhz/mFc6h0noLbK3w0utj8LDKWLu51d22yrORIKRMy594ohn2G6NQTh/UaSx9IDjzK884Mx1GjChj/dGsJVcOEGarJZmXi2X4qkzRQefxoddRnjwNQIurBnvbcTfuadyWb+ASHiGnTk87aSj9mbkfiZb4E2T+lgISe9UlNyjw99V5KtyLn66xwT1R0E67g5imRE7d2nFjjVaHOoqW/m2Rip71zxjSwBHl+MhENrPgd6yLdynwo5IcjhDhVbcUBpOVRyl/qh+vvlNd7/tGP31mJuN2+tNikROMB0XHtZV1Zo3qIpYyi7U77fVZOPPp7TtHharPH9s4W+xPEtrm7psPAPEH+5sz3tJrHulGEMf2C2I3Bl4mDJYF8S4qmqYYIw+tDH5kYBFipd0i8QmAJNvyDN8NC7DB6p+XA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38100700002)(6666004)(26005)(186003)(86362001)(6506007)(66476007)(44832011)(1076003)(6512007)(2906002)(9686003)(33716001)(8676002)(4326008)(8936002)(83380400001)(508600001)(6486002)(66556008)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L2jDEaVadePDgwkoyhza90N/d+4l3felUAGnbTgQS/hAh2YdILZepf86VdS9?=
 =?us-ascii?Q?0yyi74Pgcc7BP/CXxYnJSlfUSdhTB2uT6k1bfsscQAYrz2Ek+K1GceECK8KL?=
 =?us-ascii?Q?2wugKCAfb9LgoaCxrBYEp97vE1cK579aVg2vgDPxlxmApWKjoRjRoBm6ulk3?=
 =?us-ascii?Q?H3mP6aTCz34V4XnKyAL7ktfWk3BXwNVQqYiM//5WBvWjhZv4Z85CvFoqcs1q?=
 =?us-ascii?Q?nARoy+60gQ1EquGB3fEibUyaSlz3Hy8uHFTvl80O1T64Np9C+Pfb70M9kni6?=
 =?us-ascii?Q?q0HXxcwxdYrb4x07s+X8lmtoFYGB8lzrkAh/1CHVZz001W6UJK1mBuMx5PFs?=
 =?us-ascii?Q?X2mesdqGKFNc4ngEtZkTQjPuaHlaeargin5A2RYikmTv/UmbAnrkrozredYJ?=
 =?us-ascii?Q?AyPkHr5I6illZrxviuddZeSQKuzb96lLzqybbU77ik4XoREwCgogpB0fWuCt?=
 =?us-ascii?Q?73gGY9GWJcm+evdmVju/cWHs7hBNwVS0N9syUVRle2CVdmpNwChPy84ftZld?=
 =?us-ascii?Q?1jgxgTvRSELWYRi6w0+4O7q4h08QJ9a9LA2iOiY4Udtc1PIM4aOr2F0sZ90g?=
 =?us-ascii?Q?l/kxIwDdsPxj3cyG761yOcmZxsIopNwQDWYgjW7w+EALAN4gcn3h4uHP5tL8?=
 =?us-ascii?Q?zu4OL3L1y5dlGA6I0+HyVhSBYaWRk25Cu7xZ5yqJC4Rsq1arxy6yI6lDL31n?=
 =?us-ascii?Q?jZwic3LNruE3uw/0Th0DZ7CkJS2ROk6nUDG9dbd9M27P4RGu63WtqM6PaP4w?=
 =?us-ascii?Q?Lp+xHHjaekdvrZJAqTljfvnJ4NKRSePPZHEpeXpomWC6kYcklb7Ke7TWbs0L?=
 =?us-ascii?Q?NR4wnxXFDbdJ0Yj6LgQaXmvnMZjlnE9B/HML6qwb+/BUyWSGmJmEEV+VpASa?=
 =?us-ascii?Q?RZYBlWiFOYVVkH4W6A3L6MVrIPLA+IJqRG8lbWfWvHF1M1HfSpALqqasu8UX?=
 =?us-ascii?Q?0defq1kF7JP7Y+jLgE9VhYcIix2snLHjWEHporE4fihmTwRti+Q1VwCj2pQc?=
 =?us-ascii?Q?STuWo7QeWuruQ45nCI22jlUDrwdiM303gkL2P9ajvQ5CBIsg/gMfE8KeJxHd?=
 =?us-ascii?Q?oxt34ioNd5GPeSvxeBk94Kc4ktksYQwuFAQbTM1nPPZcRKUWavXMn1Vli8Ir?=
 =?us-ascii?Q?rdnFJP0zj50mNo6oCMJLj+W/p8xwheEJZGSEhiqdBIOPKur0kzKN7e3Tnjsj?=
 =?us-ascii?Q?/WTM1Qrh/fSsevgbgdW4OIPjMiFerXAnv/ntzRjmRvRKe/GTzgJCyjqQAmfi?=
 =?us-ascii?Q?ldhGNA4+j7ZOFNQI2bYM3hgb9rxvrpjH7w5wrDFFctnMXFlouxMhNseuKNBc?=
 =?us-ascii?Q?0zde8puoWISpBG+Nh0V5oXZFx8w94xGeOcCPDOQVOydTvsFcOWLATKW1O0ZH?=
 =?us-ascii?Q?y7Gdkjfv9b2bZAUT/iDnUwOQgFKdtUIW3rkc/xces1BLVAuG1MhPgvLPrtoz?=
 =?us-ascii?Q?5NlPKdYITlbQHRlSpLMLILG/okvyz437qO4hV9YmZEbrzRcoGDil+fgnx/VS?=
 =?us-ascii?Q?BTRsmFxRiY+afc1Sy1pBqHKW0UjVLaSCh0JuA+6M4sTnqfFWPUImA37UhNnS?=
 =?us-ascii?Q?LwCkepsLdK4xSIHFd2t25v2/n04oDlgyaKLtIvUusBffyPPGsKRtQTiGb3tC?=
 =?us-ascii?Q?uNtt1Mf93TaF3vs/2kDV0/jpQ2KzdbnLEm/vp1foBWqEvFCy13yL/8yvtJVA?=
 =?us-ascii?Q?cEMiMp6BE3gLikyBYMGNURpBkmUMMqVxgNCFp3+MYYGwEYuDl9hjqhOQFhd5?=
 =?us-ascii?Q?3d6XYTpjow=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad00ce3f-4567-4a73-ad2c-08da22ac7818
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 09:02:17.2355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SP79tMbipjk7p/bvXbIjWuLqlzyRSkopegfiY1KhdnbOGlmNCUvjFz1cW2sDLAS3o67UulmvdeBDiPVsooEBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8541
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Jes,

ping...

I am not sure whether you are too busy to review my patch, or my mail
ate by anti-spam system.
This patch derived from a SUSE customer bug, it reverts incorrect code & make
cluster-md bitmap slot back to normal.

Thanks,
Heming 

On Tue, Apr 05, 2022 at 10:18:48PM +0800, Heming Zhao wrote:
> Commit 9d67f6496c71 ("mdadm:check the nodes when operate clustered
> array") modified assignment logic for st->nodes in write_bitmap1(),
> which introduced bitmap slot issue:
> 
> load_super1 didn't set up supertype.nodes, which made spare disk only
> have one slot info. Then it triggered kernel md_bitmap_load_sb to get
> wrong bitmap slot data.
> 
> For fixing this issue, there are two methods:
> 
> 1> revert the related code of commit 9d67f6496c71. and restore the code
>    from former commit 45a87c2f31335 ("super1: add more checks for
>    NodeNumUpdate option").
>    st->nodes value would be 0 & 1 under current code logic. i.e.
>    When adding a spare disk, there is no place to init st->nodes, and
>    the value is ZERO.
> 
> 2> keep 9d67f6496c71, add additional ->nodes handling in load_super1(),
>    let load_super1 to set st->nodes when bitmap is BITMAP_MAJOR_CLUSTERED.
>    Under current mdadm code logic, load_super1 will be called many
>    times, any new code in load_super1 will cost mdadm running more time.
>    And more reason is I prefer as much as possible to limit clustered
>    code spreading in every corner.
> 
> So I used method <1> to fix this issue.
> 
> How to trigger:
> 
> dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sda
> dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sdb
> dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sdc
> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
> mdadm -a /dev/md0 /dev/sdc
> mdadm /dev/md0 --fail /dev/sda
> mdadm /dev/md0 --remove /dev/sda
> mdadm -Ss
> mdadm -A /dev/md0 /dev/sdb /dev/sdc
> 
> the output of current "mdadm -X /dev/sdc":
> (there should be (by default) 4 slot info for correct output)
> ```
>         Filename : /dev/sdc
>            Magic : 6d746962
>          Version : 5
>             UUID : a74642f8:a6b1fba8:58e1f8db:cfe7b082
>           Events : 29
>   Events Cleared : 0
>            State : OK
>        Chunksize : 64 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 306176 (299.00 MiB 313.52 MB)
>           Bitmap : 5 bits (chunks), 5 dirty (100.0%)
> ```
> 
> And mdadm later operations will trigger kernel output error message:
> (triggered by "mdadm -A /dev/md0 /dev/sdb /dev/sdc")
> ```
> kernel: md0: invalid bitmap file superblock: bad magic
> kernel: md_bitmap_copy_from_slot can't get bitmap from slot 1
> kernel: md-cluster: Could not gather bitmaps from slot 1
> kernel: md0: invalid bitmap file superblock: bad magic
> kernel: md_bitmap_copy_from_slot can't get bitmap from slot 2
> kernel: md-cluster: Could not gather bitmaps from slot 2
> kernel: md0: invalid bitmap file superblock: bad magic
> kernel: md_bitmap_copy_from_slot can't get bitmap from slot 3
> kernel: md-cluster: Could not gather bitmaps from slot 3
> kernel: md-cluster: failed to gather all resyn infos
> kernel: md0: detected capacity change from 0 to 612352
> ```
> 
> Acked-by: Coly Li <colyli@suse.de>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  super1.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/super1.c b/super1.c
> index a12a5bc847b9..f08d4f831319 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2674,7 +2674,17 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
>  		}
>  
>  		if (bms->version == BITMAP_MAJOR_CLUSTERED) {
> -			if (__cpu_to_le32(st->nodes) < bms->nodes) {
> +			if (st->nodes == 1) {
> +				/* the parameter for nodes is not valid */
> +				pr_err("Warning: cluster-md at least needs two nodes\n");
> +				return -EINVAL;
> +			} else if (st->nodes == 0) {
> +				/*
> +				 * parameter "--nodes" is not specified, (eg, add a disk to
> +				 * clustered raid)
> +				 */
> +				break;
> +			} else if (__cpu_to_le32(st->nodes) < bms->nodes) {
>  				/*
>  				 * Since the nodes num is not increased, no
>  				 * need to check the space enough or not,
> -- 
> 2.33.0
> 

