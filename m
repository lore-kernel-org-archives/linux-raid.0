Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3F0C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 31 Mar 2022 07:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiCaHIu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Mar 2022 03:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiCaHIr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Mar 2022 03:08:47 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47651EF5D3
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 00:06:59 -0700 (PDT)
Subject: Re: [PATCH v3] md/bitmap: don't set sb values if can't pass sanity
 check
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648710417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qk+WFsZZV7sJRVC+KglWC/sFu6op/YF8IshH0GPsRzc=;
        b=Ufu8n++/tRXfINx4tim1Z4U7PBtPX79jdFqCrL4dUoqpr2JA2elArXSLrVBK/9x1la5mnu
        iHCbK+FbHxZfTKT/exi+4cmNRtUcl5TVkHIhswK8GqhHvo5o5I6AwlaMIKurACFFDhOhHG
        IUVsOSJGtHyiBPf4ntzh/TM+JPUKnqw=
To:     Heming Zhao <heming.zhao@suse.com>, linux-raid@vger.kernel.org,
        song@kernel.org
Cc:     xni@redhat.com, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20220330102827.2593-1-heming.zhao@suse.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <8c4070a6-1e40-261c-35d2-00078a1cf1f5@linux.dev>
Date:   Thu, 31 Mar 2022 15:06:50 +0800
MIME-Version: 1.0
In-Reply-To: <20220330102827.2593-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 3/30/22 6:28 PM, Heming Zhao wrote:
> If bitmap area contains invalid data, kernel will crash then mdadm
> triggers "Segmentation fault".
> This is cluster-md speical bug. In non-clustered env, mdadm will
> handle broken metadata case. In clustered array, only kernel space
> handles bitmap slot info. But even this bug only happened in clustered
> env, current sanity check is wrong, the code should be changed.
>
> How to trigger: (faulty injection)
>
> dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sda
> dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sdb
> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
> mdadm -Ss
> echo aaa > magic.txt
>   == below modifying slot 2 bitmap data ==
> dd if=magic.txt of=/dev/sda seek=16384 bs=1 count=3 <== destroy magic
> dd if=/dev/zero of=/dev/sda seek=16436 bs=1 count=4 <== ZERO chunksize
> mdadm -A /dev/md0 /dev/sda /dev/sdb
>   == kernel crashes. mdadm outputs "Segmentation fault" ==
>
> Crash log:
>
> kernel: md: md0 stopped.
> kernel: md/raid1:md0: not clean -- starting background reconstruction
> kernel: md/raid1:md0: active with 2 out of 2 mirrors
> kernel: dlm: ... ...
> kernel: md-cluster: Joined cluster 44810aba-38bb-e6b8-daca-bc97a0b254aa slot 1
> kernel: md0: invalid bitmap file superblock: bad magic
> kernel: md_bitmap_copy_from_slot can't get bitmap from slot 2
> kernel: md-cluster: Could not gather bitmaps from slot 2
> kernel: divide error: 0000 [#1] SMP NOPTI
> kernel: CPU: 0 PID: 1603 Comm: mdadm Not tainted 5.14.6-1-default
> kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
> kernel: RIP: 0010:md_bitmap_create+0x1d1/0x850 [md_mod]
> kernel: RSP: 0018:ffffc22ac0843ba0 EFLAGS: 00010246
> kernel: ... ...
> kernel: Call Trace:
> kernel:  ? dlm_lock_sync+0xd0/0xd0 [md_cluster 77fe..7a0]
> kernel:  md_bitmap_copy_from_slot+0x2c/0x290 [md_mod 24ea..d3a]
> kernel:  load_bitmaps+0xec/0x210 [md_cluster 77fe..7a0]
> kernel:  md_bitmap_load+0x81/0x1e0 [md_mod 24ea..d3a]
> kernel:  do_md_run+0x30/0x100 [md_mod 24ea..d3a]
> kernel:  md_ioctl+0x1290/0x15a0 [md_mod 24ea....d3a]
> kernel:  ? mddev_unlock+0xaa/0x130 [md_mod 24ea..d3a]
> kernel:  ? blkdev_ioctl+0xb1/0x2b0
> kernel:  block_ioctl+0x3b/0x40
> kernel:  __x64_sys_ioctl+0x7f/0xb0
> kernel:  do_syscall_64+0x59/0x80
> kernel:  ? exit_to_user_mode_prepare+0x1ab/0x230
> kernel:  ? syscall_exit_to_user_mode+0x18/0x40
> kernel:  ? do_syscall_64+0x69/0x80
> kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
> kernel: RIP: 0033:0x7f4a15fa722b
> kernel: ... ...
> kernel: ---[ end trace 8afa7612f559c868 ]---
> kernel: RIP: 0010:md_bitmap_create+0x1d1/0x850 [md_mod]

l *md_bitmap_create+0x1d1
0x3a81 is in md_bitmap_create (drivers/md/md-bitmap.c:609).
604     re_read:
605             /* If cluster_slot is set, the cluster is setup */
606             if (bitmap->cluster_slot >= 0) {
607                     sector_t bm_blocks = 
bitmap->mddev->resync_max_sectors;
608
609                     bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks,
610 (bitmap->mddev->bitmap_info.chunksize >> 9));

Please add something to header like "because the chunksize is zero, which
caused the kernel crash".

> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
> v3: * fixed "uninitialized symbol" error which reported by kbuild robot.
> v2: * revise commit log
>        - change mdadm "FPE" error to "Segmentation fault" error
>          ("FPE" belongs to another issue)
>        - add kernel crash log
>      * modify a comment style to follow code rule
>      * change strlcpy to strscpy for strlcpy is marked as deprecated in
>        Documentation/process/deprecated.rst
>        - note: strlcpy() still exists in md.c & md-cluster.c
> ---
>   drivers/md/md-bitmap.c | 46 ++++++++++++++++++++++--------------------
>   1 file changed, 24 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index bfd6026d7809..c198a83c9361 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -639,14 +639,6 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>   	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
>   	write_behind = le32_to_cpu(sb->write_behind);
>   	sectors_reserved = le32_to_cpu(sb->sectors_reserved);
> -	/* Setup nodes/clustername only if bitmap version is
> -	 * cluster-compatible
> -	 */
> -	if (sb->version == cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
> -		nodes = le32_to_cpu(sb->nodes);
> -		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
> -				sb->cluster_name, 64);
> -	}
>   
>   	/* verify that the bitmap-specific fields are valid */
>   	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
> @@ -668,6 +660,16 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>   		goto out;
>   	}
>   
> +	/*
> +	 * Setup nodes/clustername only if bitmap version is
> +	 * cluster-compatible
> +	 */
> +	if (sb->version == cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
> +		nodes = le32_to_cpu(sb->nodes);
> +		strscpy(bitmap->mddev->bitmap_info.cluster_name,
> +				sb->cluster_name, 64);
> +	}
> +
>   	/* keep the array size field of the bitmap superblock up to date */
>   	sb->sync_size = cpu_to_le64(bitmap->mddev->resync_max_sectors);
>   
> @@ -695,14 +697,14 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>   	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
>   		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
>   	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
> -	strlcpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);
> +	strscpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);

I feel we don't need copy cluster_name twice, pls double check and send 
additional
patch to remove one "strscpy(*cluster_name* )" if my feeling is correct.

>   	err = 0;
>   
>   out:
>   	kunmap_atomic(sb);
> -	/* Assigning chunksize is required for "re_read" */
> -	bitmap->mddev->bitmap_info.chunksize = chunksize;
>   	if (err == 0 && nodes && (bitmap->cluster_slot < 0)) {
> +		/* Assigning chunksize is required for "re_read" */
> +		bitmap->mddev->bitmap_info.chunksize = chunksize;
>   		err = md_setup_cluster(bitmap->mddev, nodes);
>   		if (err) {
>   			pr_warn("%s: Could not setup cluster service (%d)\n",
> @@ -713,18 +715,18 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>   		goto re_read;
>   	}
>   
> -
>   out_no_sb:
> -	if (test_bit(BITMAP_STALE, &bitmap->flags))
> -		bitmap->events_cleared = bitmap->mddev->events;
> -	bitmap->mddev->bitmap_info.chunksize = chunksize;
> -	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
> -	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
> -	bitmap->mddev->bitmap_info.nodes = nodes;
> -	if (bitmap->mddev->bitmap_info.space == 0 ||
> -	    bitmap->mddev->bitmap_info.space > sectors_reserved)
> -		bitmap->mddev->bitmap_info.space = sectors_reserved;
> -	if (err) {
> +	if (err == 0) {
> +		if (test_bit(BITMAP_STALE, &bitmap->flags))
> +			bitmap->events_cleared = bitmap->mddev->events;
> +		bitmap->mddev->bitmap_info.chunksize = chunksize;
> +		bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
> +		bitmap->mddev->bitmap_info.max_write_behind = write_behind;
> +		bitmap->mddev->bitmap_info.nodes = nodes;
> +		if (bitmap->mddev->bitmap_info.space == 0 ||
> +			bitmap->mddev->bitmap_info.space > sectors_reserved)
> +			bitmap->mddev->bitmap_info.space = sectors_reserved;
> +	} else {
>   		md_bitmap_print_sb(bitmap);
>   		if (bitmap->cluster_slot < 0)
>   			md_cluster_stop(bitmap->mddev);

Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>

Thanks,
Guoqing
