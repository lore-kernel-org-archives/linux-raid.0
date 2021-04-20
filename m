Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4528AC433B4
	for <linux-raid@archiver.kernel.org>; Tue, 20 Apr 2021 07:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 002D561354
	for <linux-raid@archiver.kernel.org>; Tue, 20 Apr 2021 07:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhDTHl0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Apr 2021 03:41:26 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:20724 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229504AbhDTHlZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 20 Apr 2021 03:41:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618904453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/gd8zfIX8goiebDNIAqRekkM86u63kprl3m52GOxn+8=;
        b=kgsa6ll2ZcWeRJUadVM6JaMK6odH1eZzc5qMWdXhUxOCRJBpCwsQoUtH3R4IDOcxetRA4v
        re+3/M9i67No3s7LCSNxukEi5dgy6lkFyuud4H5TOtLei8kbpemyXNOB/wdTdc7AJKAm4W
        ZX2f9ha4mCzH7ndHQqYRYE7+x2HzhSk=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2173.outbound.protection.outlook.com [104.47.17.173])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-TLZqW_wGOhi0iqa6Q8ekqA-1; Tue, 20 Apr 2021 09:40:52 +0200
X-MC-Unique: TLZqW_wGOhi0iqa6Q8ekqA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nN7V/oLvqSBonS51tzsysDEwkv13okKzUbuNxYoRliDA0rpBIyosl8iCeWbJoYZBt30ZmpIAlfvQVrtTdFzucN/joQc3WxLU9MWK+pKfj6WrPCe4NAkOMiNz/Zs61ldDgTKteh5c4t5CXs8qwhelBFQUezHgJgWLJkt4WuipovB6JFV8zJdSJrUqCcuzVKRZd8DwqG9d9Bq57d/+Kxtb8RxoBslhygvUSXz49lINXWxyqyUJfHgC6N0v31ylmZGu7LwdyJVy18WD+jWvr4KMGtbKGoP0cTuomuB7KjuVakDHbZ7KVB3w6YH1IHEewlUnRymSk5uvnhn6E+Cgvn+aJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gd8zfIX8goiebDNIAqRekkM86u63kprl3m52GOxn+8=;
 b=LjpRDX2eNI9W79v1sKvoGs+gV8bIlJFEnSffuhJt8UGehBGh4+ruluEeIt25GJmyOtpIsIJoc1C8djcJ2sApjPSAooqetkrXE6+W2/B/l4f6xel1mKgj8YBJz+q5xxm8AxgToDUCVL47nMGeOoE7CznzvxtbkzAY+Bc9jiTxYuXxVXuQ4pJD884k12FDZ75SY6lkqaQpm4zMCIwFpqYv+EfHiG7PEHznPhcZhwMQLlafA1A3LQJNVHR3TrkSc6hOOr8X+mJyjo0Rr6BETQEtVPWNrhUU5XQpiKuBZoPxps70KaLxeVRcthiEQZr/R4wKSwjt7DzF5gVEvfkg3fvmJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBBPR04MB7818.eurprd04.prod.outlook.com (2603:10a6:10:1f2::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.19; Tue, 20 Apr 2021 07:40:50 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc%3]) with mapi id 15.20.4042.023; Tue, 20 Apr 2021
 07:40:50 +0000
Subject: Re: [PATCH v2] md-cluster: fix use-after-free issue when removing
 rdev
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     ghe@suse.com, lidong.zhong@suse.com, xni@redhat.com,
        colyli@suse.com
References: <1617867855-17481-1-git-send-email-heming.zhao@suse.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <2e5bb08d-cd6e-7e2a-5934-586999b26a02@suse.com>
Date:   Tue, 20 Apr 2021 15:40:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <1617867855-17481-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.130.223]
X-ClientProxiedBy: HKAPR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:203:d0::24) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.130.223) by HKAPR04CA0014.apcprd04.prod.outlook.com (2603:1096:203:d0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 07:40:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df3d30f6-4279-49d2-8d4c-08d903cf9ea9
X-MS-TrafficTypeDiagnostic: DBBPR04MB7818:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB7818BD0DFDDFB4E91B2DB09F97489@DBBPR04MB7818.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:785;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDazYR6bWBx/rTP3GTi+EMHR1Y47a2DYBCI/rw6E1kNk+uNevLAMSddxKq77eF7r8HtNhp3xrVMiQYwKbOahN31y7gdZ3ey1JObX1nyLTRzZt+ib8pYrYyVCpI4uyheS0CBXHx+TKcCjq4T3d8mE6tCs6QHDSDQpN7niF2DtexjbCCLeyd+7uU3kR5aT4E5Lb3ARDRfs6o1zkYCbFHhswp0gCz1uSd7audn3/xR5Xn6qkNfs70zusJkGebr4An1CkdliVYsQoqL5iINyzpVfuUM5yb7upDYpROLQiVaElri/1rz7oz+zfsn20qXMFrQLTY+QiXF9XR8+dJwVGCTm51ujbQzjCoLmzOfJPs+qCMYLbg1Q6kRq5gspP6M+A4RcfAdolmikwZNkJ/AiSvvtr+vwbL0/LJGmF/a4FfFL87sLcmz9Km3nDRE8A+X42/5zke3n93anBZx30KZEp5Zwn+To2jH4+cPGiwoyRyZsFdD3ize0Q02g+NsMUsRbDZfubiNT1yIvDFNBpuUWxss5FwlTQNrIxJG1U1u0v60ppm4+vuW9KyslCr/+SiLivv+K4a2XXufIuMe44Hjt18UkImQ7sVBngV62F6JGtAHM0Ej4HCSZyqmIxPA8+4vzR0MqOoOI5ssCRWRi93gJN7s5rQ05j72iqTpNWdWcF+jaQ+SeCblJOPHq4aYpwQTwcF/VZVPLbkzndLsJrQ4dmQAdx+dvev81QTkAV+Ii4FUQt6yrGN6sx060fq7Of48uAQfs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(366004)(346002)(66946007)(8886007)(66556008)(83380400001)(6666004)(2616005)(107886003)(478600001)(66476007)(5660300002)(956004)(6486002)(26005)(4326008)(6512007)(52116002)(38100700002)(186003)(38350700002)(16526019)(31686004)(8936002)(31696002)(53546011)(86362001)(8676002)(6506007)(316002)(2906002)(36756003)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OElMNFczNFlTVkZpRWxZeHRrU0t2c20wejBIU0RhRnRyNEJ5THpXSVJ3Rjhj?=
 =?utf-8?B?SVpRd0JoeEJDVlRaWFh6NFNVRlJDQXRMck5zUVZ4Rk40czlCN095WndzbHds?=
 =?utf-8?B?Y3ZndTU5T0ZwbG5CVHRKZFl4SVZ5OE5FMS9aK3dxZXcvdHpHVDUrekU1SWNt?=
 =?utf-8?B?bzhRMGJZSStEYXVKaTlobFVjVVZPcG5PTkhoV2pZZmtlMnh0Tis2eW5nc0FV?=
 =?utf-8?B?akhQMDJoRURCQk5FSE5XeVN4TEYwVGpBNjNLSEtXTjdncksxTExkcm5MK3Qv?=
 =?utf-8?B?R3NuMndGTzR5K0VYVkppMXYveFVsSXVDR0tHM2llZy9kcHQ3bGZITXN3cHhv?=
 =?utf-8?B?anhSSVJUd21zNFpjYTdJMXl1ZU5iZ0JqbXVyNzFRbTRBMW4yMTk4ZVFSQ1J3?=
 =?utf-8?B?Q1VsVjM2SGh0d0FSUjlxRWREalc0TVlCOWpMaGJHMjVuUHNrZSs3VU5uZDZR?=
 =?utf-8?B?ZzF4aUR6YWQwQW9XRnlIY0h5NE1SclpXbmNNemVZeUIzVTdLUTB2Mk1wK1Zk?=
 =?utf-8?B?VlVITk1RZ1VoSy91R0U3RVlhbkJRTW5WTHVjR29DdEF0ZXFqRUtVemp2bFVX?=
 =?utf-8?B?Snlkblg1ZDE3enZGMDRGbGY0TFFkK01VWE1Mdy9NRTBYcDdPZFVCRm5ZaTVU?=
 =?utf-8?B?Wi9STTcyMlRUYXVpVHk4cGgyTDBTOVUzSnFzRjI0djUrd0VueFAxRzRYcjNN?=
 =?utf-8?B?V0FFUGt2cXhYdmlNQ2djNHJBY256czZ6SkFTb2JHb2luNWwrYkJCWXM4aGJG?=
 =?utf-8?B?Rkw3NGxQMmJoa2tRSlRVeDZsaDgwU1NXcWtkNnNBMWxBNEFPOGlONzMyWjBq?=
 =?utf-8?B?U013Z3dLZnZ1UzdrQUtIT3ZTWkxsZ01KbEVkN09lVWdoaktmN2hMY2k1SGJE?=
 =?utf-8?B?YU51RkdSTDlWSjZRWGlEUVVTN012bTlCSHd2NUU5MFFYVE5ud2IrTTdPVWxN?=
 =?utf-8?B?NGxxMlFqdDdCTkFNYmwraitFejRnaE9wVG5paVhCT1M1cDI4Z2RPNmRNWVRm?=
 =?utf-8?B?RXNMRy9rSTdRQ1pCc1VMNGo5bGd1NDNJZ0pZeTl1blVOT0tuYnNNQXZjeENv?=
 =?utf-8?B?Q0R0YnBqa3Zsdy82YXVQZWRJZFA3djlqODM0RXBOUWtMOXoxaXliSE1tRkwx?=
 =?utf-8?B?eFFER3VSOXMrVmVLWE9NMmo1Z3BKTmhjcGs0TXVGZTFmcHRNcjA0U1ZuY1Bl?=
 =?utf-8?B?S1ZKbCtOclQ4eDZlb3dSKzhhNlNIMU05dVE4ZlRnR2t4YkVFd0pjMGJSUWpK?=
 =?utf-8?B?YjRJTkdHUzFuem9uVlhmdXJIdjBPdkxuYjBQMkFCa1pZWnNRV0syWjJGNU5X?=
 =?utf-8?B?THhRRnJoMU1MZ3hvajNxN2paK1BGUEVFaTdRRFlZMmY0czlvQTZXbllsSlVq?=
 =?utf-8?B?aWpLS3c0S3V0VzRzcjZRanlySlVyaEFCR21nTVBJLzk0dlk5N1A0b3RYdW9J?=
 =?utf-8?B?VlFFbVM0TlFhR2RGcnRnMnR3SVlML3o0eXBIdEtmT3lTemVpQTZnRUp0WW5x?=
 =?utf-8?B?ODl0K2F2bjBHUmw3YmdIUmM0WFJnOE1lQ2R5dnBpK3J6blU1NjJXL3lZcVp4?=
 =?utf-8?B?TS9WdlVaMnB0NGJuY1dTaWF3WFplYkdPTXFHTmF0UVlPcmpsTGFMYUF6S29a?=
 =?utf-8?B?SFkwK1UxKzB4SFpYV1p2d29HcEU2cTZxU2FUb2o4RThBRHVFTFdCQ2ZGVnNZ?=
 =?utf-8?B?bGZkckpyRmZRM3A3YXJWS1B0Y3NKQmVSbU1XdmhUYkZWOGhQVndxa3pZUnZs?=
 =?utf-8?Q?qMthghsRAM7hE9WPBTIlZzzOHTSysP1E4Ua4TLc?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df3d30f6-4279-49d2-8d4c-08d903cf9ea9
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 07:40:50.7099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Yh/o4IOhNH0tFOOcmMYAI/z5MB19zvSYx4UaHf2dLldRsq7tRalcpMyVVrdS5R4bOMDRr5j1HadkasrLZDm7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7818
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Song,

It looks you missed this patch, or some places still need to review?

Thanks,
Heming

On 4/8/21 3:44 PM, Heming Zhao wrote:
> md_kick_rdev_from_array will remove rdev, so we should
> use rdev_for_each_safe to search list.
> 
> How to trigger:
> 
> env: Two nodes on kvm-qemu x86_64 VMs (2C2G with 2 iscsi luns).
> 
> ```
> node2=192.168.0.3
> 
> for i in {1..20}; do
>      echo ==== $i `date` ====;
> 
>      mdadm -Ss && ssh ${node2} "mdadm -Ss"
>      wipefs -a /dev/sda /dev/sdb
> 
>      mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l 1 /dev/sda \
>         /dev/sdb --assume-clean
>      ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
>      mdadm --wait /dev/md0
>      ssh ${node2} "mdadm --wait /dev/md0"
> 
>      mdadm --manage /dev/md0 --fail /dev/sda --remove /dev/sda
>      sleep 1
> done
> ```
> 
> Crash stack:
> 
> ```
> stack segment: 0000 [#1] SMP
> ... ...
> RIP: 0010:md_check_recovery+0x1e8/0x570 [md_mod]
> ... ...
> RSP: 0018:ffffb149807a7d68 EFLAGS: 00010207
> RAX: 0000000000000000 RBX: ffff9d494c180800 RCX: ffff9d490fc01e50
> RDX: fffff047c0ed8308 RSI: 0000000000000246 RDI: 0000000000000246
> RBP: 6b6b6b6b6b6b6b6b R08: ffff9d490fc01e40 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
> R13: ffff9d494c180818 R14: ffff9d493399ef38 R15: ffff9d4933a1d800
> FS:  0000000000000000(0000) GS:ffff9d494f700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe68cab9010 CR3: 000000004c6be001 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   raid1d+0x5c/0xd40 [raid1]
>   ? finish_task_switch+0x75/0x2a0
>   ? lock_timer_base+0x67/0x80
>   ? try_to_del_timer_sync+0x4d/0x80
>   ? del_timer_sync+0x41/0x50
>   ? schedule_timeout+0x254/0x2d0
>   ? md_start_sync+0xe0/0xe0 [md_mod]
>   ? md_thread+0x127/0x160 [md_mod]
>   md_thread+0x127/0x160 [md_mod]
>   ? wait_woken+0x80/0x80
>   kthread+0x10d/0x130
>   ? kthread_park+0xa0/0xa0
>   ret_from_fork+0x1f/0x40
> ```
> 
> v2:
> - modify commit comments
>    - add env info for test script
>    - add 'Fixes' filed
> v1:
> - create patch
> ---
> Fixes: dbb64f8635f5d ("md-cluster: Fix adding of new disk with new
> reload code")
> Fixes: 659b254fa7392 ("md-cluster: remove a disk asynchronously from
> cluster environment")
> Reviewed-by: Gang He <ghe@suse.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   drivers/md/md.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 21da0c48f6c2..9892c13cdfc8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9251,11 +9251,11 @@ void md_check_recovery(struct mddev *mddev)
>   		}
>   
>   		if (mddev_is_clustered(mddev)) {
> -			struct md_rdev *rdev;
> +			struct md_rdev *rdev, *tmp;
>   			/* kick the device if another node issued a
>   			 * remove disk.
>   			 */
> -			rdev_for_each(rdev, mddev) {
> +			rdev_for_each_safe(rdev, tmp, mddev) {
>   				if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
>   						rdev->raid_disk < 0)
>   					md_kick_rdev_from_array(rdev);
> @@ -9569,7 +9569,7 @@ static int __init md_init(void)
>   static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
>   {
>   	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
> -	struct md_rdev *rdev2;
> +	struct md_rdev *rdev2, *tmp;
>   	int role, ret;
>   	char b[BDEVNAME_SIZE];
>   
> @@ -9586,7 +9586,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
>   	}
>   
>   	/* Check for change of roles in the active devices */
> -	rdev_for_each(rdev2, mddev) {
> +	rdev_for_each_safe(rdev2, tmp, mddev) {
>   		if (test_bit(Faulty, &rdev2->flags))
>   			continue;
>   
> 

