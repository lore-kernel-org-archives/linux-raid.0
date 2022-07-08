Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9FDC43334
	for <linux-raid@archiver.kernel.org>; Fri,  8 Jul 2022 05:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbiGHFmG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Jul 2022 01:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiGHFmA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Jul 2022 01:42:00 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF54B6257;
        Thu,  7 Jul 2022 22:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=3lzXW6qPtXhFeu2P9jaQ+m4mcBJQg8NEszfW+aPdopc=; b=pKJSk7J/mBEW8xdHWutGVehOFY
        p0qp/idvfZYuedVhcUBizLhFJLkM5fGCdHAiq+Llz9gHNg5cgsr709b6FeSEf2zwZmDyrbcYIPind
        9xjkIIYALhNlEiVViU8PUThjk8I6o5kDZuJhlsu9rEF0mSPw2xTjOdrCzgqrtJf/fOeoOl0F6bQ1H
        GBDzAlpip1xt6NHwFAUP0i/jY9RI5IF/1+XsJyUuwabLFulKcGeNw7tRroaeAQLop/9SjtJQpU0R5
        lD8ylOoFYvN/UIy3DI1Y0tWFHCCEWItqu03+LS4kMqb/vx4ad/4+y6DiZIFzH+3Y01/MHzPOpLIoF
        c3uo4EMA==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1o9gkK-009IZv-Lk; Thu, 07 Jul 2022 23:41:45 -0600
Message-ID: <72a5bf2e-cd56-a85c-2b99-cb8729a66fed@deltatee.com>
Date:   Thu, 7 Jul 2022 23:41:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk
Cc:     shinichiro.kawasaki@wdc.com, dan.j.williams@intel.com,
        yukuai3@huawei.com, ming.lei@redhat.com,
        linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>
References: <20220614074827.458955-1-hch@lst.de>
 <20220614074827.458955-5-hch@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220614074827.458955-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: hch@lst.de, axboe@kernel.dk, shinichiro.kawasaki@wdc.com, dan.j.williams@intel.com, yukuai3@huawei.com, ming.lei@redhat.com, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: REGRESSION: [PATCH 4/4] block: freeze the queue earlier in
 del_gendisk
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On 2022-06-14 01:48, Christoph Hellwig wrote:
> Freeze the queue earlier in del_gendisk so that the state does not
> change while we remove debugfs and sysfs files.
> 
> Ming mentioned that being able to observer request in debugfs might
> be useful while the queue is being frozen in del_gendisk, which is
> made possible by this change.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'm not really sure why this is yet, but this patch in rc4 causes some
random failures with mdadm tests.

It seems the 11spare-migration tests starts failing roughly every other
run because the block device is not quite cleaned up after mdadm --stop
by the time the next mdadm --create commands starts, or rather there
appears to be a race now between the newly created device and the one
being cleaned up. This results in an infrequent sysfs panic with a
duplicate filename error (see the end of this email).

I managed to bisect this and found a09b314005f3a09 to be the problematic
commit.

Reverting seems to fix it.

Thanks,

Logan

> ---
>  block/genhd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index e0675772178b0..278227ba1d531 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -623,6 +623,7 @@ void del_gendisk(struct gendisk *disk)
>  	 * Prevent new I/O from crossing bio_queue_enter().
>  	 */
>  	blk_queue_start_drain(q);
> +	blk_mq_freeze_queue_wait(q);
>  
>  	if (!(disk->flags & GENHD_FL_HIDDEN)) {
>  		sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
> @@ -646,8 +647,6 @@ void del_gendisk(struct gendisk *disk)
>  	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
>  	device_del(disk_to_dev(disk));
>  
> -	blk_mq_freeze_queue_wait(q);
> -
>  	blk_throtl_cancel_bios(disk->queue);
>  
>  	blk_sync_queue(q);


[ 1026.373014] sysfs: cannot create duplicate filename
'/devices/virtual/block/md124'
[ 1026.374616] CPU: 1 PID: 11046 Comm: mdadm Not tainted
5.19.0-rc4-eid-vmlocalyes-dbg-00065-gff4ec5f79108 #2430
[ 1026.376546] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.14.0-2 04/01/2014
[ 1026.378000] Call Trace:
[ 1026.378461]  <TASK>
[ 1026.378867]  dump_stack_lvl+0x5a/0x74
[ 1026.379558]  dump_stack+0x10/0x12
[ 1026.380178]  sysfs_warn_dup.cold+0x17/0x27
[ 1026.380944]  sysfs_create_dir_ns+0x17d/0x190
[ 1026.381765]  ? sysfs_create_mount_point+0x80/0x80
[ 1026.382638]  ? __kasan_check_read+0x11/0x20
[ 1026.383401]  ? class_dir_child_ns_type+0x23/0x30
[ 1026.384267]  kobject_add_internal+0x145/0x460
[ 1026.385084]  kobject_add+0xf3/0x150
[ 1026.385733]  ? kset_create_and_add+0xe0/0xe0
[ 1026.386529]  ? __kasan_check_read+0x11/0x20
[ 1026.387306]  ? mutex_unlock+0x12/0x20
[ 1026.387986]  ? device_add+0x1da/0xf20
[ 1026.388676]  device_add+0x224/0xf20
[ 1026.389316]  ? kobject_set_name_vargs+0x95/0xb0
[ 1026.390163]  ? __fw_devlink_link_to_suppliers+0x180/0x180
[ 1026.391157]  ? sprintf+0xae/0xe0
[ 1026.391784]  device_add_disk+0x1b8/0x5f0
[ 1026.392520]  md_alloc+0x4c9/0x800
[ 1026.393131]  ? __kasan_check_read+0x11/0x20
[ 1026.393921]  md_probe+0x24/0x30
[ 1026.394506]  blk_request_module+0x9a/0x100
[ 1026.395268]  blkdev_get_no_open+0x66/0xa0
[ 1026.395993]  blkdev_get_by_dev.part.0+0x24/0x570
[ 1026.396854]  ? devcgroup_check_permission+0xed/0x240
[ 1026.397770]  blkdev_get_by_dev+0x51/0x60
[ 1026.398497]  blkdev_open+0xa4/0x140
[ 1026.399146]  do_dentry_open+0x2a7/0x6e0
[ 1026.399854]  ? blkdev_close+0x50/0x50
[ 1026.400546]  vfs_open+0x58/0x60
[ 1026.401125]  path_openat+0x77e/0x13f0
[ 1026.401830]  ? lookup_open.isra.0+0xaf0/0xaf0
[ 1026.402615]  ? kvm_sched_clock_read+0x18/0x40
[ 1026.403441]  ? sched_autogroup_detach+0x20/0x20
[ 1026.404267]  ? __this_cpu_preempt_check+0x13/0x20
[ 1026.405141]  do_filp_open+0x154/0x280
[ 1026.405833]  ? may_open_dev+0x60/0x60
[ 1026.406558]  ? __kasan_check_read+0x11/0x20
[ 1026.407302]  ? do_raw_spin_unlock+0x98/0x100
[ 1026.408067]  ? alloc_fd+0x183/0x340
[ 1026.408718]  do_sys_openat2+0x119/0x2c0
[ 1026.409437]  ? kmem_cache_free+0x156/0x690
[ 1026.410167]  ? dput+0x29/0x750
[ 1026.410730]  ? build_open_flags+0x280/0x280
[ 1026.411607]  ? putname+0x7c/0x90
[ 1026.412164]  __x64_sys_openat+0xe7/0x160
[ 1026.412919]  ? __ia32_compat_sys_open+0x130/0x130
[ 1026.413630]  ? syscall_enter_from_user_mode+0x21/0x60
[ 1026.414271]  ? lockdep_hardirqs_on+0x82/0x110
[ 1026.414828]  ? trace_hardirqs_on+0x3d/0x100
[ 1026.415376]  do_syscall_64+0x3b/0x90
[ 1026.415837]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 1026.416473] RIP: 0033:0x7fab048f3be7
[ 1026.416938] Code: 25 00 00 41 00 3d 00 00 41 00 74 47 64 8b 04 25 18
00 00 00 85 c0 75 6b 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f
05 <48> 3d 00 f0 ff ff 0f 87 95 00 00 00 48 8b 4c 24 28 64 48 2b 0c 25
[ 1026.419219] RSP: 002b:00007ffc3c3d7ae0 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[ 1026.420162] RAX: ffffffffffffffda RBX: 00000000000003e8 RCX:
00007fab048f3be7
[ 1026.421045] RDX: 0000000000004082 RSI: 00007ffc3c3d7b70 RDI:
00000000ffffff9c
[ 1026.421928] RBP: 00007ffc3c3d7b70 R08: 0000000000000000 R09:
00007ffc3c3d79f0
[ 1026.422809] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000004082
[ 1026.423696] R13: 0000000000000009 R14: 00007ffc3c3d7b68 R15:
0000556054ddd970
[ 1026.424608]  </TASK>
[ 1026.424982] kobject_add_internal failed for md124 with -EEXIST, don't
try to register things with the same name in the same directory.

