Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3044CC77B75
	for <linux-raid@archiver.kernel.org>; Mon,  8 May 2023 05:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjEHF6G (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 May 2023 01:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjEHF6F (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 May 2023 01:58:05 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D9C4ED7
        for <linux-raid@vger.kernel.org>; Sun,  7 May 2023 22:58:03 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2ac78bb48eeso45615011fa.1
        for <linux-raid@vger.kernel.org>; Sun, 07 May 2023 22:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683525481; x=1686117481;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7PLqN44UqqyacKy3NgHD+TPUXKn6Z2/BQj2JZG0ou1s=;
        b=o7535DtTsXvwzyIL58K1qqT4LvALJBq0UoK0U8Gs3AcYgolDDTCnSeVfbsT0mLJ6n3
         i9d9ro08L8qfkFe2EBDXazGFCtF6mOuWNUWEuae9sAR3q+CDnfhXuay5nPkWmS8P9uNe
         eNGXzPQDu/IBcdYnOVHJBniYVyOrlg+JocMqCgkSWbSTQUItkY/uCQklJhB+NwyXtUzE
         eYSVIuT+Mf5cWo158yXqQ4VGSZMuVz7JVh2aWQkkVcm4q03AcQRx5Qm7bhyvC8Gi5oUg
         vVkGsaxTBM/hBIKKYYZV5EuigWUcaIjq3r1CBQr3HvF059IU9NuF5lM8VOF3aYo24Nfn
         P0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683525481; x=1686117481;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7PLqN44UqqyacKy3NgHD+TPUXKn6Z2/BQj2JZG0ou1s=;
        b=fxPDENAwfZ9OaY74PNx8i18LHNW/Bt+pJxK5NvWT4USw2sGDxR6Jnz1FT+n8nC3Mwx
         hd0WzSTMbiWOndajNcFW3nLTD7YQbJtWCsq6XvnEhJCNWbN3yUdhs1IAUb9OW318SiAb
         asvK9u25rTalk99ttnLNcEbYYH+gpvJbTTvYAvCkEQ/f9fyysBce0s8ypuqJbaL+tAgk
         +q8GJ7ERqvnf5ccmwbmvBTV82T+kMTlFtkAKmRpeAfxj13L3+OYNzojPtItj/u2m1DUC
         MsbEEyH1YF+/G2Is7E9Ckp5yterWYWCYkJp6SLR3tjnDA7FWG1Pzi+2x58baG+xpTBgn
         IuRA==
X-Gm-Message-State: AC+VfDwHV23q4gj/zRA91AfAqhBE3Qh77Z2Jt7MnX5bsaDqV3sWr+R6+
        w9akdtk9nWjj+Tx02deqkceht9Ik+HdqbJdiz24=
X-Google-Smtp-Source: ACHHUZ6wywu4oOcpfLuE5fgCq8WgZGDXRNVRL/TVqemj+HCGfOIw9K2RJV6hObl+a76TxF5U7uvKe8HtH/6IPhV0RP0=
X-Received: by 2002:a2e:87c7:0:b0:2ab:51ce:649d with SMTP id
 v7-20020a2e87c7000000b002ab51ce649dmr2381604ljj.37.1683525480135; Sun, 07 May
 2023 22:58:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAO2ABipzbw6QL5eNa44CQHjiVa-LTvS696Mh9QaTw+qsUKFUCw@mail.gmail.com>
 <6fcbab2f-8211-774a-7aa9-883ed5d74168@huaweicloud.com> <CAO2ABiq5bB0cD7c+cS1Vw2PqSZNadyXUgonfEH6Gwsz8d9OiTQ@mail.gmail.com>
 <04036a22-c0b0-8ca1-0220-a531c47a1e25@huaweicloud.com>
In-Reply-To: <04036a22-c0b0-8ca1-0220-a531c47a1e25@huaweicloud.com>
From:   David Gilmour <dgilmour76@gmail.com>
Date:   Sun, 7 May 2023 23:57:46 -0600
Message-ID: <CAO2ABipZP1-A8aT+=qLoSrA7CUQB7RStSqxnmX8NWwcj-ABBRQ@mail.gmail.com>
Subject: Re: mdadm grow raid 5 to 6 failure (crash)
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: multipart/mixed; boundary="00000000000036d5db05fb2852d3"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--00000000000036d5db05fb2852d3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm not sure what I'm looking for here but here is the output of the
inflight file immediately after the mdadm assemble hangs. Does this
indicate something accessing the array?

#cat /sys/block/md127/inflight
       1        0

Also attached is an strace of my mdadm command that hung in case that
reveals something relevant:
strace mdadm --assemble --verbose
--backup-file=3D/root/mdadm5-6_backup_md127 --invalid-backup /dev/md127
/dev/sda /dev/sdh /dev/sdg /dev/sdc /dev/sde /dev/sdf --force 2>&1 |
tee mdadm_strace_output.txt

On Sun, May 7, 2023 at 7:23=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2023/05/06 21:19, David Gilmour =E5=86=99=E9=81=93:
> >>From what I can tell it does look very similar. I stopped the
> > systemd-udevd service and renamed it to systemd-udevd.bak. My system
> > still hung on the assemble command. I'm not savvy enough to decode the
> > details here but does the "mddev_suspend.part.0+0xdf/0x150" line in
> > the process stack output suggest the same i/o block the other post
> > indicates?
> >
> > =C3=97 systemd-udevd.service - Rule-based Manager for Device Events and=
 Files
> >       Loaded: loaded (/usr/lib/systemd/system/systemd-udevd.service; st=
atic)
> >       Active: failed (Result: exit-code) since Sat 2023-05-06 06:59:11
> > MDT; 1min 27s ago
> >     Duration: 1d 20h 16min 29.633s
> > TriggeredBy: =C3=97 systemd-udevd-kernel.socket
> >               =C3=97 systemd-udevd-control.socket
> >         Docs: man:systemd-udevd.service(8)
> >               man:udev(7)
> >      Process: 27440 ExecStart=3D/usr/lib/systemd/systemd-udevd
> > (code=3Dexited, status=3D203/EXEC)
> >     Main PID: 27440 (code=3Dexited, status=3D203/EXEC)
> >          CPU: 5ms
> >
> > ----------------------
> > #mdadm --assemble --verbose --backup-file=3D/root/mdadm5-6_backup_md127
> > --invalid-backup /dev/md127 /dev/sda /dev/sdh /dev/sdg /dev/sdc
> > /dev/sdb /dev/sdf --force
> > mdadm: looking for devices for /dev/md127
> > mdadm: /dev/sda is identified as a member of /dev/md127, slot 0.
> > mdadm: /dev/sdh is identified as a member of /dev/md127, slot 1.
> > mdadm: /dev/sdg is identified as a member of /dev/md127, slot 2.
> > mdadm: /dev/sdc is identified as a member of /dev/md127, slot 3.
> > mdadm: /dev/sdb is identified as a member of /dev/md127, slot 4.
> > mdadm: /dev/sdf is identified as a member of /dev/md127, slot 5.
> > mdadm: /dev/md127 has an active reshape - checking if critical section
> > needs to be restored
> > mdadm: No backup metadata on /root/mdadm5-6_backup_md127
> > mdadm: Failed to find backup of critical section
> > mdadm: continuing without restoring backup
> > mdadm: added /dev/sdh to /dev/md127 as 1
> > mdadm: added /dev/sdg to /dev/md127 as 2
> > mdadm: added /dev/sdc to /dev/md127 as 3
> > mdadm: added /dev/sdb to /dev/md127 as 4
> > mdadm: added /dev/sdf to /dev/md127 as 5 (possibly out of date)
> > mdadm: added /dev/sda to /dev/md127 as 0
> >
> > #hangs indefinitely at this point in the output
> >
> > ------------------------------------------
> >
> >
> > root       27454  0.0  0.0   3812  2656 pts/1    D+   07:00   0:00
> > mdadm --assemble --verbose --backup-file=3D/root/mdadm5-6_backup_md127
> > --invalid-backup /dev/md127 /dev/sda /dev/sdh /dev/sdg /dev/sdc
> > /dev/sdb /dev/sdf --force
> > root       27457  0.0  0.0      0     0 ?        S    07:00   0:00 [md1=
27_raid6]
> >
> > #cat /proc/27454/stack
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
> > #cat /proc/27457/stack
> > [<0>] md_thread+0x122/0x160
> > [<0>] kthread+0xe0/0x100
> > [<0>] ret_from_fork+0x22/0x30
> >
>
> Is there any thread stuck at raid5_make_request? something like below:
>
> Apr 23 19:17:22 atom kernel: task:systemd-udevd   state:D stack:    0
> pid: 8121 ppid:   706 flags:0x00000006
> Apr 23 19:17:22 atom kernel: Call Trace:
> Apr 23 19:17:22 atom kernel:  <TASK>
> Apr 23 19:17:22 atom kernel:  __schedule+0x20a/0x550
> Apr 23 19:17:22 atom kernel:  schedule+0x5a/0xc0
> Apr 23 19:17:22 atom kernel:  schedule_timeout+0x11f/0x160
> Apr 23 19:17:22 atom kernel:  ? make_stripe_request+0x284/0x490 [raid456]
> Apr 23 19:17:22 atom kernel:  wait_woken+0x50/0x70
> Apr 23 19:17:22 atom kernel:  raid5_make_request+0x2cb/0x3e0 [raid456]
> Apr 23 19:17:22 atom kernel:  ? sched_show_numa+0xf0/0xf0
> Apr 23 19:17:22 atom kernel:  md_handle_request+0x132/0x1e0
> Apr 23 19:17:22 atom kernel:  ? do_mpage_readpage+0x282/0x6b0
> Apr 23 19:17:22 atom kernel:  __submit_bio+0x86/0x130
> Apr 23 19:17:22 atom kernel:  __submit_bio_noacct+0x81/0x1f0
> Apr 23 19:17:22 atom kernel:  mpage_readahead+0x15c/0x1d0
> Apr 23 19:17:22 atom kernel:  ? blkdev_write_begin+0x20/0x20
> Apr 23 19:17:22 atom kernel:  read_pages+0x58/0x2f0
> Apr 23 19:17:22 atom kernel:  page_cache_ra_unbounded+0x137/0x180
> Apr 23 19:17:22 atom kernel:  force_page_cache_ra+0xc5/0xf0
> Apr 23 19:17:22 atom kernel:  filemap_get_pages+0xe4/0x350
> Apr 23 19:17:22 atom kernel:  filemap_read+0xbe/0x3c0
> Apr 23 19:17:22 atom kernel:  ? make_kgid+0x13/0x20
> Apr 23 19:17:22 atom kernel:  ? deactivate_locked_super+0x90/0xa0
> Apr 23 19:17:22 atom kernel:  blkdev_read_iter+0xaf/0x170
> Apr 23 19:17:22 atom kernel:  new_sync_read+0xf9/0x180
> Apr 23 19:17:22 atom kernel:  vfs_read+0x13c/0x190
> Apr 23 19:17:22 atom kernel:  ksys_read+0x5f/0xe0
> Apr 23 19:17:22 atom kernel:  do_syscall_64+0x59/0x90
>
> By the way, cat /sys/block/mdxx/inflight can prove this as well.
>
> If this is the case, can you find out who is accessing the array?
>
> Thanks,
> Kuai
>

--00000000000036d5db05fb2852d3
Content-Type: application/x-zip-compressed; name="mdadm_strace_output.zip"
Content-Disposition: attachment; filename="mdadm_strace_output.zip"
Content-Transfer-Encoding: base64
Content-ID: <f_lheflb4o0>
X-Attachment-Id: f_lheflb4o0

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
E2DmYzusYcbBzGY97EZ6oEYZCzMr5kMrYKZve+jNkLvol+lFGqrXu3bAL1nF7hvuTuZ1VI2NU+Z1
uAnzOr5OXjr3TPumPZnK9GMe0Od8N75MPbaMH18mjS0Txpd5NbZMHF/m5dgy5bllhvV6d6tvUtO7
m/5Fleo3+82LvtEmfIt59ugQcvfRvdtPDr+fPHr68O5hFXmlPifqn6qi1SHw7BPsvVKTHvN+mmbP
hN15cH+0beWxbWPp74dDhb++zOfq736uHpAbV5w2X4qijWRLtmRLtmRLtmRLtmRLtmRLtmRLtmRL
tmRLtmRLtmRLtmRLtmRLtmRLtmR/YmcOBAAAAACA/F8bIcD7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f2JkDAQAAAAAg/9dGCPB+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/32/szIEAAAAAAJD/ayMEeL/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/vN3bmQAAAAAAAyP+1EQK83+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/cbO3MgAAAAAADk/9oIAd7v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+42dORAA
AAAAAPJ/bYQA7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9xs4cCAAAAAAA+b82
QoD3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X5jZw4EAAAAAID8XxshwPv9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v7EzBwIAAAAAQP6vjRDg/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f2JkDAQAAAAAg/9dGCPB+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/32/szIEAAAAAAJD/ayMEeL/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/vN3bmQAAAAAAAyP+1EQK83+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/cbO3MgAAAAAADk/9oIAd7v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+42dORAA
AAAAAPJ/bYQA7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9xs4cCAAAAAAA+b82
QoD3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X5jZw4EAAAAAID8XxshwPv9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v7EzBwIAAAAAQP6vjRDg/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f2JkDAQAAAAAg/9dGCPB+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/32/szIEAAAAAAJD/ayMEeL/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/vN3bmQAAAAAAAyP+1EQK83+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/cbO3MgAAAAAADk/9oIAd7v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+42dORAA
AAAAAPJ/bYQA7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9xs4cCAAAAAAA+b82
QoD3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X5jZw4EAAAAAID8XxshwPv9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v7EzBwIAAAAAQP6vjRDg/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f2JkDAQAAAAAg/9dGCPB+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/32/szIEAAAAAAJD/ayMEeL/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/vN3bmQAAAAAAAyP+1EQK83+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/cbO3MgAAAAAADk/9oIAd7v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+42dORAA
AAAAAPJ/bYQA7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9xs4cCAAAAAAA+b82
QoD3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X5jZw4EAAAAAID8XxshwPv9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v7EzBwIAAAAAQP6vjRDg/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f2JkDAQAAAAAg/9dGCPB+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/32/szIEAAAAAAJD/ayMEeL/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/vN3bmQAAAAAAAyP+1EQK83+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/cbO3MgAAAAAADk/9oIAd7v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+42dORAA
AAAAAPJ/bYQA7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9xs4cCAAAAAAA+b82
QoD3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X5jZw4EAAAAAID8XxshwPv9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v7EzBwIAAAAAQP6vjRDg/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f2JkDAQAAAAAg/9dGCPB+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/32/szIEAAAAAAJD/ayMEeL/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/vN3bmQAAAAAAAyP+1EQK83+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/cbO3MgAAAAAADk/9oIAd7v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+
v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+42dORAA
AAAAAPJ/bYQA7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/
3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9xs4cCAAAAAAA+b82
QoD3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X5jZw4EAAAAAID8XxshwPv9fr/f
7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v7EzBwIAAAAAQP6vjRDg/X6/3+/3+/1+v9/v
9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3
+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7
/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f7/f7/X6/3+/3+/1+v9/v9/v9
fr/f7/f7/X6/3+/3+/1+v9/v9/v9fr/f2p+blQQCKArA+55CWikI8+PY6FIyIwgFEcTVYONI0uRI
Y5A9feOqTUi1/u7irg7fvYfNZrPZbDabzWaz2Ww2m81ms9lsNpvNZrPZbDabzWaz2Ww2m81ms9ls
NpvNZrPZbDabzWaz2Ww2m81ms9lsNpvNZrPZbDabzWaz2Ww2m81ms9lsNpvNZrPZbDabzWaz2Ww2
m81ms9lsNpvNZrPZbDabzWaz2Ww2m81ms9lsNpvNZrPZbDabzWaz2Ww2m81ms/9pb+vTPm/sTuvi
NOnwqjoU+/WxPVpkk/Htcty8E9SnOngqq/wleN1EcdrsIKiPb7tDkeXr/LnI6t1ncd1tzbLlfDZ9
XJ3PfjeKGyIK47QJJJ2fryZXeVnV5+xvPtxV+bFsJ93W/d0iG83no1X2MJ3Muq3wI91ui2gQ53F/
E3b+VOe9boKbrKwu9hjGca+XxmHvZtBP0rQ/CM+1ouEXUEsBAj8AFAAAAAgAGL2nViRpdqXiXQAA
uygxABcAJAAAAAAAAAAgAAAAAAAAAG1kYWRtX3N0cmFjZV9vdXRwdXQudHh0CgAgAAAAAAABABgA
gNmVo2+B2QEAAAAAAAAAAAAAAAAAAAAAUEsFBgAAAAABAAEAaQAAABdeAAAAAA==
--00000000000036d5db05fb2852d3--
