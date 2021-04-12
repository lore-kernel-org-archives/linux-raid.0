Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAC9C433B4
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 06:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C2C061042
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 06:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhDLGGg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 02:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhDLGGf (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 12 Apr 2021 02:06:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE1FF61042
        for <linux-raid@vger.kernel.org>; Mon, 12 Apr 2021 06:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618207577;
        bh=btMne0D6J+4C2vjM0HxZtiifE1vnIJjBsUJKagkN+cM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=izGXbHeqAltA8pqvM0Mb/Vp45V2ig+0rXQMnLUMf9eruBEG7N64xzxWOw+A7GmXoR
         3jPQuTv8T8keDKH9W5/El/DxjpLj39shs7fj5mipqwuiHdVhLFqvYkLVCcP0tV/VcN
         Dge/0O9opGdLCuybtPR5GpnvFmzF9dlFKgC2PnBK0cFjD4Ib37CzBwjnSgMjJUv3Qx
         2F74leNPSA7vPhAuWa1mOVLbXekaOzkQEUjKCT8dE4G3qV+jM26mVXFdTOUgZf1Qt4
         4djROqGvX8XtGEX072QXRLpIl2dzP8stBlgA8wZ2gN2N3cKJWmTjMBI/z3onLyVMl5
         Z1uAKyTqEQYOQ==
Received: by mail-lf1-f41.google.com with SMTP id v140so19480062lfa.4
        for <linux-raid@vger.kernel.org>; Sun, 11 Apr 2021 23:06:16 -0700 (PDT)
X-Gm-Message-State: AOAM531WnCad2T2xVu3tGkwCKITCRU4IJn/U6vutz5zDPzc2OVumPiSN
        Lj1BwrLXEOlo1kcnS3cQXL0yyI39YLZBP76B/FU=
X-Google-Smtp-Source: ABdhPJz3OUlGAkWtHlzCHgUcluZpNxM3B5wbWDlpiHCBBvSpTSXb8nFfv2Y6zAmifz6C7X/IETqxEnwnesk4jzTHKhY=
X-Received: by 2002:a05:6512:3582:: with SMTP id m2mr18464419lfr.10.1618207575127;
 Sun, 11 Apr 2021 23:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210408213917.GA3986@oracle.com> <ba0f4827-83ae-b7e2-2230-5f4afca2538a@suse.com>
 <CY4PR10MB20077F9F84680DC1C0CAE281FD729@CY4PR10MB2007.namprd10.prod.outlook.com>
 <2becafd0-7df7-7a79-8478-b8246f353c9b@suse.com>
In-Reply-To: <2becafd0-7df7-7a79-8478-b8246f353c9b@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 11 Apr 2021 23:06:03 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4S-FERHGfj6ENC3K70+9tMsupWVmc9yhLoLWB6qX0jMA@mail.gmail.com>
Message-ID: <CAPhsuW4S-FERHGfj6ENC3K70+9tMsupWVmc9yhLoLWB6qX0jMA@mail.gmail.com>
Subject: Re: [PATCH] md/bitmap: wait for bitmap writes to complete during the
 tear down sequence
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>
Cc:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "lidong.zhong@suse.com" <lidong.zhong@suse.com>,
        "xni@redhat.com" <xni@redhat.com>,
        "colyli@suse.com" <colyli@suse.com>,
        Martin Petersen <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Apr 11, 2021 at 2:04 AM heming.zhao@suse.com
<heming.zhao@suse.com> wrote:
>
> On 4/11/21 5:35 AM, Sudhakar Panneerselvam wrote:
> >> Hello Sudhakar,
> >>
> >> First, let's discuss with master branch kernel.
> >>
> >> What command or action stands for "tear down" ?
> >>   From your description, it very like ioctl STOP_ARRAY.
> >> Your crash was related with super_written, which is the callback for
> >> updating array sb, not bitmap sb. in md_update_sb() there is a sync
> >> point md_super_wait(), which will guarantee all sb bios finished succe=
ssfully.
> >>
> >> for your patch, do you check md_bitmap_free, which already done the yo=
ur patch's job.
> >>
> >> the call flow:
> >> ```
> >> do_md_stop //by STOP_ARRAY
> >>    + __md_stop_writes()
> >>    |  md_bitmap_flush
> >>    |  md_update_sb
> >>    |   + md_super_write
> >>    |   |  bio->bi_end_io =3D super_written
> >>    |   + md_super_wait(mddev) //wait for all bios done
> >>    + __md_stop(mddev)
> >>    |  md_bitmap_destroy(mddev);
> >>    |   + md_bitmap_free //see below
> >>    + ...
> >>
> >> md_bitmap_free
> >> {
> >>      ...
> >>       //do your patch job.
> >>       /* Shouldn't be needed - but just in case.... */
> >>       wait_event(bitmap->write_wait,
> >>              atomic_read(&bitmap->pending_writes) =3D=3D 0);
> >>      ...
> >> }
> >> ```
> >>
> >> Would you share more analysis or test results for your patch?
> >
> > Hello Heming,
> >
> > Please find more details about our system configuration and the detaile=
d
> > sequence that led to the crash.
> >
> > We have a RAID1 configured on an external imsm container. /proc/mdstat =
output
> > looks like this:
> >
> > ***
> > md24 : active raid1 sdb[1] sda[0]
> >        141557760 blocks super external:/md127/0 [2/2] [UU]
> >        bitmap: 1/2 pages [4KB], 65536KB chunk
> >
> > md127 : inactive sdb[1](S) sda[0](S)
> >        10402 blocks super external:imsm
> > ***
> >
> > All our system partition is laid out on top of the above RAID1 device a=
s
> > shown below.
> >
> > ***
> > /dev/md24p5 on / type xfs (rw,relatime,attr2,inode64,noquota)
> > /dev/md24p1 on /boot type xfs (rw,nodev,relatime,attr2,inode64,noquota)
> > /dev/md24p15 on /home type xfs (rw,nodev,relatime,attr2,inode64,noquota=
)
> > /dev/md24p12 on /var type xfs (rw,nodev,relatime,attr2,inode64,noquota)
> > /dev/md24p16 on /tmp type xfs (rw,nodev,relatime,attr2,inode64,noquota)
> > /dev/md24p11 on /var/log type xfs (rw,nodev,relatime,attr2,inode64,noqu=
ota)
> > /dev/md24p14 on /var/log/audit type xfs (rw,nodev,relatime,attr2,inode6=
4,noquota)
> > ***
> >
> > In such a configuration, the kernel panic described in this patch occur=
s
> > during the "shutdown" of the server. Since the system partition is laid=
 out on
> > the RAID1, there could be write I/Os going to the RAID device as part o=
f system
> > log and filesystem activity that typically occur during the shutdown.
> >
> >  From the core dump, I see that, after filesystems are unmounted and ki=
lling all
> > other userspace processes, "mdmon" thread initiates the "stop" on the m=
d device.
> >
> > ***
> > COMMAND: "mdmon"
> >     TASK: ffff8ff2b1663c80  [THREAD_INFO: ffff8ff2b1663c80]
> >      CPU: 30
> >    STATE: TASK_UNINTERRUPTIBLE
> > crash> bt
> > PID: 7390   TASK: ffff8ff2b1663c80  CPU: 30  COMMAND: "mdmon"
> >   #0 [ffffb99d4eacba30] __schedule at ffffffff91884acc
> >   #1 [ffffb99d4eacbad0] schedule at ffffffff918850e6
> >   #2 [ffffb99d4eacbae8] schedule_timeout at ffffffff91889616
> >   #3 [ffffb99d4eacbb78] wait_for_completion at ffffffff91885d1b
> >   #4 [ffffb99d4eacbbe0] __wait_rcu_gp at ffffffff9110c123
> >   #5 [ffffb99d4eacbc28] synchronize_sched at ffffffff9111008e
> >   #6 [ffffb99d4eacbc78] unbind_rdev_from_array at ffffffff9169640f
> >   #7 [ffffb99d4eacbcc0] do_md_stop at ffffffff9169f163
> >   #8 [ffffb99d4eacbd58] array_state_store at ffffffff9169f644
> >   #9 [ffffb99d4eacbd90] md_attr_store at ffffffff9169b71e
> > #10 [ffffb99d4eacbdc8] sysfs_kf_write at ffffffff91320edf
> > #11 [ffffb99d4eacbdd8] kernfs_fop_write at ffffffff913203c4
> > #12 [ffffb99d4eacbe18] __vfs_write at ffffffff9128fcfa
> > #13 [ffffb99d4eacbea0] vfs_write at ffffffff9128ffd2
> > #14 [ffffb99d4eacbee0] sys_write at ffffffff9129025c
> > #15 [ffffb99d4eacbf28] do_syscall_64 at ffffffff91003a39
> > #16 [ffffb99d4eacbf50] entry_SYSCALL_64_after_hwframe at ffffffff91a001=
b1
> >      RIP: 00007ff3bfc846fd  RSP: 00007ff3bf8a6cf0  RFLAGS: 00000293
> >      RAX: ffffffffffffffda  RBX: 000055e257ef0941  RCX: 00007ff3bfc846f=
d
> >      RDX: 0000000000000005  RSI: 000055e257ef0941  RDI: 000000000000001=
0
> >      RBP: 0000000000000010   R8: 0000000000000001   R9: 000000000000000=
0
> >      R10: 00000000ffffff01  R11: 0000000000000293  R12: 000000000000000=
1
> >      R13: 0000000000000000  R14: 0000000000000001  R15: 000000000000000=
0
> >      ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b
> > crash>
> > ***
> >
> > While handling the "md" stop in the kernel, the code sequence based on =
the
> > above md configuration is
> >
> > do_md_stop
> >   + __md_stop_writes
> >   | + md_bitmap_flush
> >   | | + md_bitmap_daemon_work
> >   | | | + md_bitmap_wait_writes()
> >   | | | | (This wait is for bitmap writes that happened up until now an=
d to avoid
> >   | | | |  overlapping with the new bitmap writes.)
> >   | | | | (wait flag is set to zero for async writes to bitmap.)
> >   | | | + write_page()
> >   | | | | | (For external bitmap, bitmap->storage.file is NULL, hence e=
nds up
> >   | | | | |  calling write_sb_page())
> >   | | | | + write_sb_page()
> >   | | | | | + md_super_write()
> >   | | | | | | (Since the wait flag is false, the bitmap write is submit=
ted
> >   | | | | | |  without waiting for it to complete.)
> >   | | | | | | + mddev->pending_writes is incremented, then the IO is su=
bmitted
> >   | | | | | |   and the call returns without waiting
> >   | | + md_bitmap_update_sb() - (This call simply returns because
> >   | | | | "bitmap->mddev->bitmap_info.external" is true for external bi=
tmaps)
> >   | + md_update_sb() - (This won't be called as the call is conditional=
 and the
> >   | | | | | | condition evaluates to false in my setup(see below for cr=
ash info)
> >   + __md_stop
> >   | + md_bitmap_destroy
> >   | | + md_bitmap_free
> >   | | | + wait_event(bitmap->write_wait,
> >   | | | |            atomic_read(&bitmap->pending_writes) =3D=3D 0);
> >   | | | | bitmap->pending_writes is zero, but the mddev->pending_writes=
 is 1,
> >   | | | | so this call returns immediately.
> >   | md detachment continues while there is pending mddev I/O cauing NUL=
L pointer
> >   | derefence when the I/O callback, super_written is called.
> >
> > ***
> >          crash> struct mddev.bitmap_info.external 0xffff8ffb62f13800
> >                  bitmap_info.external =3D 1,
> >          crash> struct mddev.in_sync 0xffff8ffb62f13800
> >                  in_sync =3D 1
> >          crash> struct mddev.sb_flags 0xffff8ffb62f13800
> >                  sb_flags =3D 0
> >          crash> struct mddev.ro 0xffff8ffb62f13800
> >                  ro =3D 0
> >          crash> struct mddev.cluster_info 0xffff8ffb62f13800
> >                  cluster_info =3D 0x0
> >          crash>
> > ***
> >
> > Please review and let me know your thoughts.
> >
>
> Hello
>
> On previous mail, I was wrong to assume the array mddev->bitmap_info.exte=
rnal is 0. So my analysis was not suite for your case.
>
> Now we understand your env, which is related with IMSM & external bitmap,=
 and I have a little knowledge about this field. May need to add more peopl=
e in the cc list.
>
> Just from code logic, your analysis is reasonable.
> The key of the crash is why md layer didn't do the waiting job for bitmap=
 bios. There have wait points in md_bitmap_daemon_work, write_sb_page, md_b=
itmap_update_sb & md_update_sb. But in your scenario there all didn't take =
effect. At last md_bitmap_free do the additional wait bitmap->pending_write=
s but not mddev->pending_writes. the crash is triggered.
>
> In my opinion, using a special wait is more clear than calling general md=
_bitmap_wait_writes(). the md_bitmap_wait_writes makes people feel bitmap m=
odule does repetitive clean job.
>
> My idea like:
> ```
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 200c5d0f08bf..ea6fa5a2cb6b 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1723,6 +1723,8 @@ void md_bitmap_flush(struct mddev *mddev)
>          bitmap->daemon_lastrun -=3D sleep;
>          md_bitmap_daemon_work(mddev);
>          md_bitmap_update_sb(bitmap);
> +       if (mddev->bitmap_info.external)
> +               md_super_wait(mddev);
>   }
>
>   /*
> @@ -1746,6 +1748,7 @@ void md_bitmap_free(struct bitmap *bitmap)
>          /* Shouldn't be needed - but just in case.... */
>          wait_event(bitmap->write_wait,
>                     atomic_read(&bitmap->pending_writes) =3D=3D 0);
> +       wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)=3D=
=3D0);
>
>          /* release the bitmap file  */
>          md_bitmap_file_unmap(&bitmap->storage);
> ```

I like Heming's version better.

Hi Sudhakar,

Are you able to reproduce the issue? If so, could you please verify
that Heming's
change fixes the issue?

Thanks,
Song
