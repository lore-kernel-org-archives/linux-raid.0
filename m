Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10424C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 31 Mar 2021 22:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBDB061007
	for <linux-raid@archiver.kernel.org>; Wed, 31 Mar 2021 22:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhCaWrY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 Mar 2021 18:47:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229615AbhCaWqx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 31 Mar 2021 18:46:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 080716105A
        for <linux-raid@vger.kernel.org>; Wed, 31 Mar 2021 22:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617230813;
        bh=4zLCtxfqiUFZMFCBdFeixYhM1JihcMifJ4xQFLBwlyk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JknXECu7SSa9geUIjKxpd/7ZuMTQUCxDNFWd5lZ2jWwPtvhI0ttzY3ZW3rwXXMOpE
         xNq3zU8w9/fIW5Xg00f6VfFsOPaUVbnDWzURbRDfdGSF3VEYlRqwZsk8m1PM2+3T9x
         GK5iX5ac0vjK5U2iQWS0ZsCVswgRSUneHMjGv5v1FoTD3js/MYJg+y80lNUdyFkaVW
         8vG+Z1mcvj6UQH5fSGkYNtCOK7Xr23vyOG5PH3qcVO0KSDb8dSMF2KDwIud1BbekDK
         wlbjOFADvqOjwl/7ML7pLLCY4KV58umYEGCZcRB3MIW2LydM6DHNUGG3CXUpk5wBtL
         HE+PXA1L65/PA==
Received: by mail-lf1-f54.google.com with SMTP id g8so31429089lfv.12
        for <linux-raid@vger.kernel.org>; Wed, 31 Mar 2021 15:46:52 -0700 (PDT)
X-Gm-Message-State: AOAM532+cEavr9z4h2yOb8QImU6b5/lSY8+ysGJCgnFh30J/7flDEQdi
        SEaTsUkZuV2TuvdApIY3ftHvXvBnqI2J3qNx6II=
X-Google-Smtp-Source: ABdhPJwrKCVXHQllyfgUnMlxADlFMw46pwvtJpIkOjiSJ9zHRsxv5Dax4IvCFGn68ONrcuMu4oiMkl+dh/+izcuzko4=
X-Received: by 2002:a05:6512:3582:: with SMTP id m2mr3530682lfr.10.1617230811346;
 Wed, 31 Mar 2021 15:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <1617090209-18648-1-git-send-email-heming.zhao@suse.com>
In-Reply-To: <1617090209-18648-1-git-send-email-heming.zhao@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 31 Mar 2021 15:46:40 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5HPP8kqR8LKhLHESbLnrmXu5Qrkub6kW0kQNofrHi6kQ@mail.gmail.com>
Message-ID: <CAPhsuW5HPP8kqR8LKhLHESbLnrmXu5Qrkub6kW0kQNofrHi6kQ@mail.gmail.com>
Subject: Re: [PATCH] md: don't create mddev in md_open
To:     Zhao Heming <heming.zhao@suse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Mar 30, 2021 at 12:43 AM Zhao Heming <heming.zhao@suse.com> wrote:
>
> commit d3374825ce57 ("md: make devices disappear when they are no longer
> needed.") introduced protection between mddev creating & removing. The
> md_open shouldn't create mddev when all_mddevs list doesn't contain
> mddev. With currently code logic, there will be very easy to trigger
> soft lockup in non-preempt env.
>
> *** env ***
> kvm-qemu VM 2C1G with 2 iscsi luns
> kernel should be non-preempt
>
> *** script ***
>
> about trigger 1 time with 10 tests
>
> ```
> 1  node1="15sp3-mdcluster1"
> 2  node2="15sp3-mdcluster2"
> 3
> 4  mdadm -Ss
> 5  ssh ${node2} "mdadm -Ss"
> 6  wipefs -a /dev/sda /dev/sdb
> 7  mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda \
>    /dev/sdb --assume-clean
> 8
> 9  for i in {1..100}; do
> 10    echo ==== $i ====;
> 11
> 12    echo "test  ...."
> 13    ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
> 14    sleep 1
> 15
> 16    echo "clean  ....."
> 17    ssh ${node2} "mdadm -Ss"
> 18 done
> ```
>
> I use mdcluster env to trigger soft lockup, but it isn't mdcluster
> speical bug. To stop md array in mdcluster env will do more jobs than
> non-cluster array, which will leave enough time/gap to allow kernel to
> run md_open.
>
> *** stack ***
>
> ```
> PID: 2831   TASK: ffff8dd7223b5040  CPU: 0   COMMAND: "mdadm"
>  #0 [ffffa15d00a13b90] __schedule at ffffffffb8f1935f
>  #1 [ffffa15d00a13ba8] exact_lock at ffffffffb8a4a66d
>  #2 [ffffa15d00a13bb0] kobj_lookup at ffffffffb8c62fe3
>  #3 [ffffa15d00a13c28] __blkdev_get at ffffffffb89273b9
>  #4 [ffffa15d00a13c98] blkdev_get at ffffffffb8927964
>  #5 [ffffa15d00a13cb0] do_dentry_open at ffffffffb88dc4b4
>  #6 [ffffa15d00a13ce0] path_openat at ffffffffb88f0ccc
>  #7 [ffffa15d00a13db8] do_filp_open at ffffffffb88f32bb
>  #8 [ffffa15d00a13ee0] do_sys_open at ffffffffb88ddc7d
>  #9 [ffffa15d00a13f38] do_syscall_64 at ffffffffb86053cb
>     ffffffffb900008c
>
> or:
> [  884.226509]  mddev_put+0x1c/0xe0 [md_mod]
> [  884.226515]  md_open+0x3c/0xe0 [md_mod]
> [  884.226518]  __blkdev_get+0x30d/0x710
> [  884.226520]  ? bd_acquire+0xd0/0xd0
> [  884.226522]  blkdev_get+0x14/0x30
> [  884.226524]  do_dentry_open+0x204/0x3a0
> [  884.226531]  path_openat+0x2fc/0x1520
> [  884.226534]  ? seq_printf+0x4e/0x70
> [  884.226536]  do_filp_open+0x9b/0x110
> [  884.226542]  ? md_release+0x20/0x20 [md_mod]
> [  884.226543]  ? seq_read+0x1d8/0x3e0
> [  884.226545]  ? kmem_cache_alloc+0x18a/0x270
> [  884.226547]  ? do_sys_open+0x1bd/0x260
> [  884.226548]  do_sys_open+0x1bd/0x260
> [  884.226551]  do_syscall_64+0x5b/0x1e0
> [  884.226554]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> ```
>
> *** rootcause ***
>
> "mdadm -A" (or other array assemble commands) will start a daemon "mdadm
> --monitor" by default. When "mdadm -Ss" is running, the stop action will
> wakeup "mdadm --monitor". The "--monitor" daemon will immediately get
> info from /proc/mdstat. This time mddev in kernel still exist, so
> /proc/mdstat still show md device, which makes "mdadm --monitor" to open
> /dev/md0.
>
> The previously "mdadm -Ss" is removing action, the "mdadm --monitor"
> open action will trigger md_open which is creating action. Racing is
> happening.
>
> ```
> <thread 1>: "mdadm -Ss"
> md_release
>   mddev_put deletes mddev from all_mddevs
>   queue_work for mddev_delayed_delete
>   at this time, "/dev/md0" is still available for opening
>
> <thread 2>: "mdadm --monitor ..."
> md_open
>  + mddev_find can't find mddev of /dev/md0, and create a new mddev and
>  |    return.
>  + trigger "if (mddev->gendisk != bdev->bd_disk)" and return
>       -ERESTARTSYS.
> ```
>
> In non-preempt kernel, <thread 2> is occupying on current CPU. and
> mddev_delayed_delete which was created in <thread 1> also can't be
> schedule.
>
> In preempt kernel, it can also trigger above racing. But kernel doesn't
> allow one thread running on a CPU all the time. after <thread 2> running
> some time, the later "mdadm -A" (refer above script line 13) will call
> md_alloc to alloc a new gendisk for mddev. it will break md_open
> statement "if (mddev->gendisk != bdev->bd_disk)" and return 0 to caller,
> the soft lockup is broken.
>
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
>  drivers/md/md.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 21da0c48f6c2..730d8570ad6d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -734,7 +734,7 @@ void mddev_init(struct mddev *mddev)
>  }
>  EXPORT_SYMBOL_GPL(mddev_init);
>
> -static struct mddev *mddev_find(dev_t unit)
> +static struct mddev *mddev_find(dev_t unit, bool create)

"create" is added but never used? Wrong version?

Thanks,
Song


>  {
>         struct mddev *mddev, *new = NULL;
>
> @@ -5644,7 +5644,7 @@ static int md_alloc(dev_t dev, char *name)
>          * writing to /sys/module/md_mod/parameters/new_array.
>          */
>         static DEFINE_MUTEX(disks_mutex);
> -       struct mddev *mddev = mddev_find(dev);
> +       struct mddev *mddev = mddev_find(dev, true);
>         struct gendisk *disk;
>         int partitioned;
>         int shift;
> @@ -6523,7 +6523,7 @@ static void autorun_devices(int part)
>                 }
>
>                 md_probe(dev);
> -               mddev = mddev_find(dev);
> +               mddev = mddev_find(dev, true);
>                 if (!mddev || !mddev->gendisk) {
>                         if (mddev)
>                                 mddev_put(mddev);
> @@ -7807,7 +7807,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
>          * Succeed if we can lock the mddev, which confirms that
>          * it isn't being stopped right now.
>          */
> -       struct mddev *mddev = mddev_find(bdev->bd_dev);
> +       struct mddev *mddev = mddev_find(bdev->bd_dev, false);
>         int err;
>
>         if (!mddev)
> --
> 2.30.0
>
