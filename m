Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27943C77B7F
	for <linux-raid@archiver.kernel.org>; Mon,  8 May 2023 08:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjEHI2H (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 May 2023 04:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbjEHI2E (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 May 2023 04:28:04 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2C112C
        for <linux-raid@vger.kernel.org>; Mon,  8 May 2023 01:28:00 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2ac831bb762so40545441fa.3
        for <linux-raid@vger.kernel.org>; Mon, 08 May 2023 01:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683534479; x=1686126479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H1oeO2pd42SaTlO8voMHYHpjRICAEVbD/puFsqMg9bU=;
        b=TcnmrLCr3820sp9Q4dE6hXy9zrWtZ+6ExeelIMH2Ni/nUPTdqqB5Y9mN/CgG4uBJj9
         KIQt2EIFNBKqm3k1DbuqL78UhQSd/2fmDhPITgv2ZJm3H7aAOTJWW1U8LbuUZpZvBNtm
         Ht08PlZP+SPKw6H8Ckt8qWXCq2zflRUC9o+EwxIXm7Xm1PunKWD9Zf5ag/SlYVtjzP1P
         Dkm9lfsJjgGaBk4rNVifJX0e3UexN2PSs1mNjHy1IG145s8ZbKYQhExdvnFgAsyNy7Lx
         iO1ivu4GCcP5Tblmh5jn//2cH36tmy8WXdYdNoLk/+zv9Iv6bGmqP5aABqVNE64JWfVv
         DTtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683534479; x=1686126479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H1oeO2pd42SaTlO8voMHYHpjRICAEVbD/puFsqMg9bU=;
        b=FuxYA5713Wf9bdFaeANL6V2dTgsgaV5GQ05mX6pZ50dIuo+XS+TjbJbZn+j+ysQvMz
         SqqlLs9AMvQ8D5afX4p59JcODaaSfQ9Crv8QkHe6k1UKQvcN9AvZsosnpKZ56RXIyYq8
         FCrZ0SS+hEQME3BZmWCUvxlXin2h9+UozAP3pNoUflVeQzE4YPfOVzYN0XBvHdyuy+j7
         Fwy/3ZADH4sdJ4Mi3DmGV5WO31IZQwvW4RIZ1kg4875Ze/7cS7kNOHhhOSiXAlc6TXzT
         yLajmVwka/ROu76gt4JmTZYFvFEq08a7zPtR9TnevpmFvVJTB4fByPEbPdxPdeH4pFlJ
         crjQ==
X-Gm-Message-State: AC+VfDyrowf56bFulip5TkWGuuS/qvxQHnpbAXDtRh2fU6qWri+MQn+4
        Y5mugoTpdANml655PMDiC/NEkYgkrHv8Eh76BUg=
X-Google-Smtp-Source: ACHHUZ4aV2EZeLdINqNTbBDkTHqFaQpTOhBz6oDQHMUtEcNyblex/aukVR57n6vTF760+Fx7guULB6oPvju1Uuahpuc=
X-Received: by 2002:a2e:9e45:0:b0:2ac:7764:aa4 with SMTP id
 g5-20020a2e9e45000000b002ac77640aa4mr2801239ljk.10.1683534478421; Mon, 08 May
 2023 01:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAO2ABipzbw6QL5eNa44CQHjiVa-LTvS696Mh9QaTw+qsUKFUCw@mail.gmail.com>
 <6fcbab2f-8211-774a-7aa9-883ed5d74168@huaweicloud.com> <CAO2ABiq5bB0cD7c+cS1Vw2PqSZNadyXUgonfEH6Gwsz8d9OiTQ@mail.gmail.com>
 <04036a22-c0b0-8ca1-0220-a531c47a1e25@huaweicloud.com> <CAO2ABioUC9Wy=7FaPAP+AUmd5S-Xanj2d9JJYkqU4BL8DxW5Bg@mail.gmail.com>
 <b1252ee9-4309-a1a9-d2c4-3e278a3e70b6@huaweicloud.com> <CAO2ABioXHT9c4qPx5S4dKsMZLyE0xLGBzST5tSTu8YPmX4FxYQ@mail.gmail.com>
 <51a28406-f850-5f4e-1d2d-87c06df75a9d@huaweicloud.com>
In-Reply-To: <51a28406-f850-5f4e-1d2d-87c06df75a9d@huaweicloud.com>
From:   David Gilmour <dgilmour76@gmail.com>
Date:   Mon, 8 May 2023 02:27:44 -0600
Message-ID: <CAO2ABiqEoi4iB__b7KdYu_jQqmeB8joh5xurHNeXj9583mcjjA@mail.gmail.com>
Subject: Re: mdadm grow raid 5 to 6 failure (crash)
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This seems to be kicked off somehow from the mdadm assemble command.
There is no additional mdadm process before I run the assemble command
but there is after:

#ps -elf | grep " D "
0 S root        3993    3953  0  80   0 - 55416 pipe_r 02:18 pts/1
00:00:00 grep --color=3Dauto  D

#mdadm --assemble --verbose --backup-file=3D/root/mdadm5-6_backup_md127
--invalid-backup /dev/md127 /dev/sda /dev/sdh /dev/sdg /dev/sdc
/dev/sde /dev/sdf --force
mdadm: looking for devices for /dev/md127
mdadm: /dev/sda is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdh is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sdg is identified as a member of /dev/md127, slot 2.
mdadm: /dev/sdc is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sde is identified as a member of /dev/md127, slot 4.
mdadm: /dev/sdf is identified as a member of /dev/md127, slot 5.
mdadm: /dev/md127 has an active reshape - checking if critical section
needs to be restored
mdadm: No backup metadata on /root/mdadm5-6_backup_md127
mdadm: Failed to find backup of critical section
mdadm: continuing without restoring backup
mdadm: added /dev/sdh to /dev/md127 as 1
mdadm: added /dev/sdg to /dev/md127 as 2
mdadm: added /dev/sdc to /dev/md127 as 3
mdadm: added /dev/sde to /dev/md127 as 4
mdadm: added /dev/sdf to /dev/md127 as 5 (possibly out of date)
mdadm: added /dev/sda to /dev/md127 as 0
<hangs here>

#Then in a separate terminal:
#ps -elf | grep " D "
1 D root        1249       1  0  80   0 -   936 wait_w 02:15 ?
00:00:00 /sbin/mdadm --monitor --scan --syslog -f
--pid-file=3D/run/mdadm/mdadm.pid
4 D root        4086    4038  0  80   0 -   953 mddev_ 02:22 pts/2
00:00:00 mdadm --assemble --verbose
--backup-file=3D/root/mdadm5-6_backup_md127 --invalid-backup /dev/md127
/dev/sda /dev/sdh /dev/sdg /dev/sdc /dev/sde /dev/sdf --force
0 S root        4102    3869  0  80   0 - 55449 pipe_r 02:25 pts/0
00:00:00 grep --color=3Dauto  D



On Mon, May 8, 2023 at 1:56=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2023/05/08 15:43, David Gilmour =E5=86=99=E9=81=93:
> > Two mdadm processes show up:
> >
> > #ps -elf | grep " D "
> > 1 D root        1251       1  0  80   0 -   936 wait_w 00:28 ?
> > 00:00:00 /sbin/mdadm --monitor --scan --syslog -f
> > --pid-file=3D/run/mdadm/mdadm.pid
>
> So this is the one accessing the array, can you stop this before
> assemble?
>
> Thanks,
> Kuai
> > 4 D root        4130    4091  0  80   0 -   953 mddev_ 01:33 pts/1
> > 00:00:00 mdadm --assemble --verbose
> > --backup-file=3D/root/mdadm5-6_backup_md127 --invalid-backup /dev/md127
> > /dev/sda /dev/sdh /dev/sdg /dev/sdc /dev/sde /dev/sdf --force
> >
> > Process 1251 (mdadm) has a raid5_make_request descriptor in it:
> >
> > #cat /proc/1251/stack
> > [<0>] wait_woken+0x50/0x70
> > [<0>] raid5_make_request+0x2cb/0x3e0 [raid456]
> > [<0>] md_handle_request+0x135/0x1e0
> > [<0>] __submit_bio+0x89/0x130
> > [<0>] __submit_bio_noacct+0x81/0x1f0
> > [<0>] submit_bh_wbc+0x11e/0x140
> > [<0>] block_read_full_folio+0x1d5/0x290
> > [<0>] filemap_read_folio+0x43/0x300
> > [<0>] do_read_cache_folio+0x112/0x3f0
> > [<0>] read_cache_page+0x15/0x90
> > [<0>] read_part_sector+0x3a/0x160
> > [<0>] read_lba+0xff/0x260
> > [<0>] is_gpt_valid.part.0+0x66/0x3d0
> > [<0>] find_valid_gpt.constprop.0+0x20e/0x540
> > [<0>] efi_partition+0x80/0x390
> > [<0>] check_partition+0x103/0x1d0
> > [<0>] bdev_disk_changed.part.0+0xb5/0x200
> > [<0>] blkdev_get_whole+0x7a/0x90
> > [<0>] blkdev_get_by_dev.part.0+0x13b/0x300
> > [<0>] blkdev_open+0x4c/0x90
> > [<0>] do_dentry_open+0x14f/0x380
> > [<0>] do_open+0x21a/0x3d0
> > [<0>] path_openat+0x10f/0x2b0
> > [<0>] do_filp_open+0xb2/0x160
> > [<0>] do_sys_openat2+0x9a/0x160
> > [<0>] __x64_sys_openat+0x53/0xa0
> > [<0>] do_syscall_64+0x5c/0x90
> > [<0>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > #cat /proc/4130/stack
> > [<0>] mddev_suspend.part.0+0xdf/0x150
> > [<0>] suspend_lo_store+0xc5/0xf0
> > [<0>] md_attr_store+0x83/0xf0
> > [<0>] kernfs_fop_write_iter+0x124/0x1b0
> > [<0>] new_sync_write+0xff/0x190
> > [<0>] vfs_write+0x1ef/0x280
> > [<0>] ksys_write+0x5f/0xe0
> > [<0>] do_syscall_64+0x5c/0x90
> > [<0>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> >
> > On Mon, May 8, 2023 at 1:08=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com=
> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2023/05/08 13:54, David Gilmour =E5=86=99=E9=81=93:
> >>> I'm not sure what I'm looking for here but here is the output of the
> >>> inflight file immediately after the mdadm assemble hangs. Does this
> >>> indicate something accessing the array?
> >>>
> >>> #cat /sys/block/md127/inflight
> >>>          1        0
> >>>
> >>
> >> Yes, something is accessing the array. Do you try to grep all the task
> >> that is "D" state?
> >>
> >> ps -elf | grep " D "
> >>
> >> Is there any task stuck in raid5_make_request?
> >>
> >> cat /proc/$pid/stack
> >>
> >>> Also attached is an strace of my mdadm command that hung in case that
> >>> reveals something relevant:
> >>> strace mdadm --assemble --verbose
> >>> --backup-file=3D/root/mdadm5-6_backup_md127 --invalid-backup /dev/md1=
27
> >>> /dev/sda /dev/sdh /dev/sdg /dev/sdc /dev/sde /dev/sdf --force 2>&1 |
> >>> tee mdadm_strace_output.txt
> >>
> >> I don't think this will be helpful, mdadm is unlikely the task that
> >> is accessing the array.
> >>
> >> Thanks,
> >> Kuai
> >>>
> >>>
> >>>
> >>>
> >>>
> >>> On Sun, May 7, 2023 at 7:23=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.c=
om> wrote:
> >>>>
> >>>> Hi,
> >>>>
> >>>> =E5=9C=A8 2023/05/06 21:19, David Gilmour =E5=86=99=E9=81=93:
> >>>>> >From what I can tell it does look very similar. I stopped the
> >>>>> systemd-udevd service and renamed it to systemd-udevd.bak. My syste=
m
> >>>>> still hung on the assemble command. I'm not savvy enough to decode =
the
> >>>>> details here but does the "mddev_suspend.part.0+0xdf/0x150" line in
> >>>>> the process stack output suggest the same i/o block the other post
> >>>>> indicates?
> >>>>>
> >>>>> =C3=97 systemd-udevd.service - Rule-based Manager for Device Events=
 and Files
> >>>>>         Loaded: loaded (/usr/lib/systemd/system/systemd-udevd.servi=
ce; static)
> >>>>>         Active: failed (Result: exit-code) since Sat 2023-05-06 06:=
59:11
> >>>>> MDT; 1min 27s ago
> >>>>>       Duration: 1d 20h 16min 29.633s
> >>>>> TriggeredBy: =C3=97 systemd-udevd-kernel.socket
> >>>>>                 =C3=97 systemd-udevd-control.socket
> >>>>>           Docs: man:systemd-udevd.service(8)
> >>>>>                 man:udev(7)
> >>>>>        Process: 27440 ExecStart=3D/usr/lib/systemd/systemd-udevd
> >>>>> (code=3Dexited, status=3D203/EXEC)
> >>>>>       Main PID: 27440 (code=3Dexited, status=3D203/EXEC)
> >>>>>            CPU: 5ms
> >>>>>
> >>>>> ----------------------
> >>>>> #mdadm --assemble --verbose --backup-file=3D/root/mdadm5-6_backup_m=
d127
> >>>>> --invalid-backup /dev/md127 /dev/sda /dev/sdh /dev/sdg /dev/sdc
> >>>>> /dev/sdb /dev/sdf --force
> >>>>> mdadm: looking for devices for /dev/md127
> >>>>> mdadm: /dev/sda is identified as a member of /dev/md127, slot 0.
> >>>>> mdadm: /dev/sdh is identified as a member of /dev/md127, slot 1.
> >>>>> mdadm: /dev/sdg is identified as a member of /dev/md127, slot 2.
> >>>>> mdadm: /dev/sdc is identified as a member of /dev/md127, slot 3.
> >>>>> mdadm: /dev/sdb is identified as a member of /dev/md127, slot 4.
> >>>>> mdadm: /dev/sdf is identified as a member of /dev/md127, slot 5.
> >>>>> mdadm: /dev/md127 has an active reshape - checking if critical sect=
ion
> >>>>> needs to be restored
> >>>>> mdadm: No backup metadata on /root/mdadm5-6_backup_md127
> >>>>> mdadm: Failed to find backup of critical section
> >>>>> mdadm: continuing without restoring backup
> >>>>> mdadm: added /dev/sdh to /dev/md127 as 1
> >>>>> mdadm: added /dev/sdg to /dev/md127 as 2
> >>>>> mdadm: added /dev/sdc to /dev/md127 as 3
> >>>>> mdadm: added /dev/sdb to /dev/md127 as 4
> >>>>> mdadm: added /dev/sdf to /dev/md127 as 5 (possibly out of date)
> >>>>> mdadm: added /dev/sda to /dev/md127 as 0
> >>>>>
> >>>>> #hangs indefinitely at this point in the output
> >>>>>
> >>>>> ------------------------------------------
> >>>>>
> >>>>>
> >>>>> root       27454  0.0  0.0   3812  2656 pts/1    D+   07:00   0:00
> >>>>> mdadm --assemble --verbose --backup-file=3D/root/mdadm5-6_backup_md=
127
> >>>>> --invalid-backup /dev/md127 /dev/sda /dev/sdh /dev/sdg /dev/sdc
> >>>>> /dev/sdb /dev/sdf --force
> >>>>> root       27457  0.0  0.0      0     0 ?        S    07:00   0:00 =
[md127_raid6]
> >>>>>
> >>>>> #cat /proc/27454/stack
> >>>>> [<0>] mddev_suspend.part.0+0xdf/0x150
> >>>>> [<0>] suspend_lo_store+0xc5/0xf0
> >>>>> [<0>] md_attr_store+0x83/0xf0
> >>>>> [<0>] kernfs_fop_write_iter+0x124/0x1b0
> >>>>> [<0>] new_sync_write+0xff/0x190
> >>>>> [<0>] vfs_write+0x1ef/0x280
> >>>>> [<0>] ksys_write+0x5f/0xe0
> >>>>> [<0>] do_syscall_64+0x5c/0x90
> >>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >>>>>
> >>>>> #cat /proc/27457/stack
> >>>>> [<0>] md_thread+0x122/0x160
> >>>>> [<0>] kthread+0xe0/0x100
> >>>>> [<0>] ret_from_fork+0x22/0x30
> >>>>>
> >>>>
> >>>> Is there any thread stuck at raid5_make_request? something like belo=
w:
> >>>>
> >>>> Apr 23 19:17:22 atom kernel: task:systemd-udevd   state:D stack:    =
0
> >>>> pid: 8121 ppid:   706 flags:0x00000006
> >>>> Apr 23 19:17:22 atom kernel: Call Trace:
> >>>> Apr 23 19:17:22 atom kernel:  <TASK>
> >>>> Apr 23 19:17:22 atom kernel:  __schedule+0x20a/0x550
> >>>> Apr 23 19:17:22 atom kernel:  schedule+0x5a/0xc0
> >>>> Apr 23 19:17:22 atom kernel:  schedule_timeout+0x11f/0x160
> >>>> Apr 23 19:17:22 atom kernel:  ? make_stripe_request+0x284/0x490 [rai=
d456]
> >>>> Apr 23 19:17:22 atom kernel:  wait_woken+0x50/0x70
> >>>> Apr 23 19:17:22 atom kernel:  raid5_make_request+0x2cb/0x3e0 [raid45=
6]
> >>>> Apr 23 19:17:22 atom kernel:  ? sched_show_numa+0xf0/0xf0
> >>>> Apr 23 19:17:22 atom kernel:  md_handle_request+0x132/0x1e0
> >>>> Apr 23 19:17:22 atom kernel:  ? do_mpage_readpage+0x282/0x6b0
> >>>> Apr 23 19:17:22 atom kernel:  __submit_bio+0x86/0x130
> >>>> Apr 23 19:17:22 atom kernel:  __submit_bio_noacct+0x81/0x1f0
> >>>> Apr 23 19:17:22 atom kernel:  mpage_readahead+0x15c/0x1d0
> >>>> Apr 23 19:17:22 atom kernel:  ? blkdev_write_begin+0x20/0x20
> >>>> Apr 23 19:17:22 atom kernel:  read_pages+0x58/0x2f0
> >>>> Apr 23 19:17:22 atom kernel:  page_cache_ra_unbounded+0x137/0x180
> >>>> Apr 23 19:17:22 atom kernel:  force_page_cache_ra+0xc5/0xf0
> >>>> Apr 23 19:17:22 atom kernel:  filemap_get_pages+0xe4/0x350
> >>>> Apr 23 19:17:22 atom kernel:  filemap_read+0xbe/0x3c0
> >>>> Apr 23 19:17:22 atom kernel:  ? make_kgid+0x13/0x20
> >>>> Apr 23 19:17:22 atom kernel:  ? deactivate_locked_super+0x90/0xa0
> >>>> Apr 23 19:17:22 atom kernel:  blkdev_read_iter+0xaf/0x170
> >>>> Apr 23 19:17:22 atom kernel:  new_sync_read+0xf9/0x180
> >>>> Apr 23 19:17:22 atom kernel:  vfs_read+0x13c/0x190
> >>>> Apr 23 19:17:22 atom kernel:  ksys_read+0x5f/0xe0
> >>>> Apr 23 19:17:22 atom kernel:  do_syscall_64+0x59/0x90
> >>>>
> >>>> By the way, cat /sys/block/mdxx/inflight can prove this as well.
> >>>>
> >>>> If this is the case, can you find out who is accessing the array?
> >>>>
> >>>> Thanks,
> >>>> Kuai
> >>>>
> >>
> > .
> >
>
