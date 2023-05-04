Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694A8C77B7C
	for <linux-raid@archiver.kernel.org>; Thu,  4 May 2023 18:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjEDSCS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 May 2023 14:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEDSCR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 May 2023 14:02:17 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F7C40F3
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 11:02:16 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-b9a879cd49cso1129703276.0
        for <linux-raid@vger.kernel.org>; Thu, 04 May 2023 11:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683223335; x=1685815335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aq0Bvpn6unY5DV2HZnAl4mOyCjBo+2HTD4/UCXurhPM=;
        b=U/RcrSoktBaLKLMjosemTavWb/2J2yykEvL/FSJHV35Z95PnINl1ai90RMXkn/aO9S
         JDGyAsS3dg9w018EQlHei11wWAzF+FJoaiIAMW2MxTirv+Y/O63ktuWRe352C13RKVb+
         AqJQFOnVo8pMEqsRnijMLcyXgghRbKSIuW6HCW2/CQ0t9wz52/pGQhB7BU1qq/2pq6Tg
         H+8dmvmeZHZFZBiV1M7/5KXmY7EmT+f857yS9sQAzNYVAt3EDyN/eSUeh6gmnfGVj9jp
         r18qIM+Tlb9PqqPWpoK7G/0o/ua2EVv3vtePWOarWTA27/H469RZdvYeDJzIK+6ACr7/
         Yqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683223335; x=1685815335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Aq0Bvpn6unY5DV2HZnAl4mOyCjBo+2HTD4/UCXurhPM=;
        b=OSZ1sKiiwoNEXWwrJ+f3L7DTpLG8S3lAOwpmqPwERyO2oO+ExnG+Fv8El4GfnnfZSv
         WZdFaUq9RzR0jRhGm7l+JVopwJpLbA113qKG3uw8h7mCZoHzd1RnS8odxOlmlIGSpxAZ
         uosZZGDbaAOnDTSJqCBc92ji0qocbk1MG9hvFm5KcmiC5T+9bv0WQiP05vD1z9mNqMI/
         nArmwZ86aIEqtit018tG1ZaTI0tlByFyYjN2XnKD/RBlCM2TlNV2pFyhzYace86OxXks
         km7MLPoZtyRLeCORfombVJm7eBVNAze8UL5cByyzUprXTUMiTNgaA2lzKuI1PF9rpcG8
         4F5g==
X-Gm-Message-State: AC+VfDwZlvsmxyjnhPl+lvIH/jF6+lHS00ESa29Av4hV2Oilxh08bkJ0
        j5GtNWK/h9VkpQMtHFf03qELqtRPBbpIQu6isrA=
X-Google-Smtp-Source: ACHHUZ7kcVRB/9Mgcy1La1RXh9gXPy1PoUcqellqrAswZchSzGZvRQiD6ROoS4PsouEU1XXLswe5aNwDVvzWvNO9xqE=
X-Received: by 2002:a25:aa04:0:b0:b9e:887f:d09c with SMTP id
 s4-20020a25aa04000000b00b9e887fd09cmr893285ybi.18.1683223335177; Thu, 04 May
 2023 11:02:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com>
In-Reply-To: <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com>
From:   Jove <jovetoo@gmail.com>
Date:   Thu, 4 May 2023 20:02:04 +0200
Message-ID: <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Kuai,

the madm --assemble command also hangs in the kernel. It never completes.

root         142     112  1 19:01 tty1     00:00:00 mdadm --assemble
/dev/md0 /dev/ubdb /dev/ubdc /dev/ubdd /dev/ubde --backup-file
mdadm_raid6_backup.md0 --invalid-backup
root         145       2  0 19:01 ?        00:00:00 [md0_raid6]

[root@LXCNAME ~]# cat /proc/142/stack
[<0>] __switch_to+0x50/0x7f
[<0>] __schedule+0x39c/0x3dd
[<0>] schedule+0x78/0xb9
[<0>] mddev_suspend+0x10b/0x1e8
[<0>] suspend_lo_store+0x72/0xbb
[<0>] md_attr_store+0x6c/0x8d
[<0>] sysfs_kf_write+0x34/0x37
[<0>] kernfs_fop_write_iter+0x167/0x1d0
[<0>] new_sync_write+0x68/0xd8
[<0>] vfs_write+0xe7/0x12b
[<0>] ksys_write+0x6d/0xa6
[<0>] sys_write+0x10/0x12
[<0>] handle_syscall+0x81/0xb1
[<0>] userspace+0x3db/0x598
[<0>] fork_handler+0x94/0x96

[root@LXCNAME ~]# cat /proc/145/stack
[<0>] __switch_to+0x50/0x7f
[<0>] __schedule+0x39c/0x3dd
[<0>] schedule+0x78/0xb9
[<0>] schedule_timeout+0xd2/0xfb
[<0>] md_thread+0x12c/0x18a
[<0>] kthread+0x11d/0x122
[<0>] new_thread_handler+0x81/0xb2

I have had one case in which mdadm didn't hang and in which the
reshape continued. Sadly, I was using sparse overlay files and the
filesystem could not handle the full 4x 4TB. I had to terminate the
reshape.

Best regards,

    Johan

On Thu, May 4, 2023 at 1:41=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2023/04/24 3:09, Jove =E5=86=99=E9=81=93:
> > Hi,
> >
> > I've added two drives to my raid5 array and tried to migrate
> > it to raid6 with the following command:
> >
> > mdadm --grow /dev/md0 --raid-devices 4 --level 6
> > --backup-file=3D/root/mdadm_raid6_backup.md
> >
> > This may have been my first mistake, as there are only 5
> > drives. it should have been --raid-devices 3, I think.
> >
> > As soon as I started this grow, the filesystems went
> > unavailable. All processes trying to access files on it hung.
> > I searched the web which said a reboot during a rebuild
> > was not problematic if things shut down cleanly, so I
> > rebooted. The reboot hung too. The drive activity
> > continued so I let it run overnight. I did wake up to a
> > rebooted system in emergency mode as it could not
> > mount all the partitions on the raid array.
> >
> > The OS tried to reassemble the array and succeeded.
> > However the udev processes that try to create the dev
> > entries hang.
> >
> > I went back to Google and found out how i could reboot
> > my system without this automatic assemble.
> > I tried reassembling the array with:
> >
> > mdadm --verbose --assemble --backup-file mdadm_raid6_backup.md0 /dev/md=
0
> >
> > This failed with:
> > No backup metadata on mdadm_raid6_backup.md0
> > Failed to find final backup of critical section.
> > Failed to restore critical section for reshape, sorry.
> >
> >   I tried again wtih:
> >
> > mdadm --verbose --assemble --backup-file mdadm_raid6_backup.md0
> > --invalid-backup /dev/md0
> >
> > Rhis said in addition to the lines above:
> >
> > continuying without restoring backup
> >
> > This seemed to have succeeded in reassembling the
> > array but it also hangs indefinitely.
> >
> > /proc/mdstat now shows:
> >
> > md0 : active (read-only) raid6 sdc1[0] sde[4](S) sdf[5] sdd1[3] sdg1[1]
> >        7813771264 blocks super 1.2 level 6, 512k chunk, algorithm 18 [4=
/3] [UUU_]
> >        bitmap: 1/30 pages [4KB], 65536KB chunk
>
> Read only can't continue reshape progress, see details in
> md_check_recovery(), reshape can only start if md_is_rdwr(mddev) pass.
> Do you know why this array is read-only?
>
> >
> > Again the udev processes trying to access this device hung indefinitely
> >
> > Eventually, the kernel dumps this in my journal:
> >
> > Apr 23 19:17:22 atom kernel: task:systemd-udevd   state:D stack:    0
> > pid: 8121 ppid:   706 flags:0x00000006
> > Apr 23 19:17:22 atom kernel: Call Trace:
> > Apr 23 19:17:22 atom kernel:  <TASK>
> > Apr 23 19:17:22 atom kernel:  __schedule+0x20a/0x550
> > Apr 23 19:17:22 atom kernel:  schedule+0x5a/0xc0
> > Apr 23 19:17:22 atom kernel:  schedule_timeout+0x11f/0x160
> > Apr 23 19:17:22 atom kernel:  ? make_stripe_request+0x284/0x490 [raid45=
6]
> > Apr 23 19:17:22 atom kernel:  wait_woken+0x50/0x70
>
> Looks like this normal io is waiting for reshape to be done, that's why
> it hanged indefinitely.
>
> This really is a kernel bug, perhaps it can be bypassed if reshape can
> be done, hopefully automatically if this array can be read/write. Noted
> never echo reshape to sync_action, this will corrupt data in your case.
>
> Thanks,
> Kuai
>
