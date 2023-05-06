Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68D6C77B73
	for <linux-raid@archiver.kernel.org>; Sat,  6 May 2023 13:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbjEFNUJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 May 2023 09:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbjEFNUI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 May 2023 09:20:08 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64A41CFE2
        for <linux-raid@vger.kernel.org>; Sat,  6 May 2023 06:20:05 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f13d8f74abso3192936e87.0
        for <linux-raid@vger.kernel.org>; Sat, 06 May 2023 06:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683379204; x=1685971204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKhYq8svbq3xJ9Vx63+lX5GDF5YOMWUYiVxY71vhCTA=;
        b=krWL65QILYIn9vu+3Zg9i5p3l2nuHkl0kxF6i2GcaDrXVYe1HK2jsmTx5XlCZ951J3
         /riswTiTF8ZzPC99rwD63anL78r+68gyNXnZlJY7S0AxjzkIOmAyoQ0sospTtzm65A1e
         LP7YlkgU8DjEob32WPRLEqXt8xR+1njCOz9Qq5xJUNQz+Y+4j4Y5X7z8m3dZexk6IUDU
         Az6H0CTfgXeQYpYCmPVjq8etvTKOMr1GmDbIsTOtNYdKnr0lcIhPzwdsDWk9HYhVKKwW
         k6iTXS8hfyeopy6g36bgO8VaYgmnD5rpsSDXb2fZZnjdz3ZzGaSVE4yRHSbtfQsLKxzs
         JHnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683379204; x=1685971204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tKhYq8svbq3xJ9Vx63+lX5GDF5YOMWUYiVxY71vhCTA=;
        b=P/BVXoW2mCEB2Ox4Zh7I64+hrgwMfUTGHyNVeHkaDAK2udrXK/hheI7NTvs2AA8DJG
         J4oxrTxckEwVoEG+lQGalMFewAyOvHFJuttM56GTi7O3sBdU2apJuQI+w5CwKykseCeT
         5cE7Jxg69rgMehjJZl1C8K1dOpd1f794HCxCrbqYzXs2VlP5F/TFeIcJriJFPtNVeVW/
         joox5M+I8Jv2tD3Y8YA0jMTNCsqbiBzDMDO0xEdYFRAIDh5DNfLu9ysIyEIOllbirYUk
         hl6HRRp483j3O338ZrD2wdYQO5mKiACckfiwip0lylFjthQje0/nUrZQwCYLbfHn7HVZ
         8NNQ==
X-Gm-Message-State: AC+VfDyycAUBEaVhfF4A8g3akremmUbxSi/9YszvaH0krmpGmHbfUTDx
        Y645jGQ/pSlcJEHpjbdJOv2dPTIUHgmYvXPxin4=
X-Google-Smtp-Source: ACHHUZ7lGe3VuC41hUJAArbboGPGNCxqjUDnqxRxO6D/jfLU1eLgGH1LNo3/huUWy1Z78/mALj8WFxbFSZTUvsjMX3Q=
X-Received: by 2002:ac2:457b:0:b0:4f1:80cf:6194 with SMTP id
 k27-20020ac2457b000000b004f180cf6194mr460830lfm.64.1683379203783; Sat, 06 May
 2023 06:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAO2ABipzbw6QL5eNa44CQHjiVa-LTvS696Mh9QaTw+qsUKFUCw@mail.gmail.com>
 <6fcbab2f-8211-774a-7aa9-883ed5d74168@huaweicloud.com>
In-Reply-To: <6fcbab2f-8211-774a-7aa9-883ed5d74168@huaweicloud.com>
From:   David Gilmour <dgilmour76@gmail.com>
Date:   Sat, 6 May 2023 07:19:50 -0600
Message-ID: <CAO2ABiq5bB0cD7c+cS1Vw2PqSZNadyXUgonfEH6Gwsz8d9OiTQ@mail.gmail.com>
Subject: Re: mdadm grow raid 5 to 6 failure (crash)
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From what I can tell it does look very similar. I stopped the
systemd-udevd service and renamed it to systemd-udevd.bak. My system
still hung on the assemble command. I'm not savvy enough to decode the
details here but does the "mddev_suspend.part.0+0xdf/0x150" line in
the process stack output suggest the same i/o block the other post
indicates?

=C3=97 systemd-udevd.service - Rule-based Manager for Device Events and Fil=
es
     Loaded: loaded (/usr/lib/systemd/system/systemd-udevd.service; static)
     Active: failed (Result: exit-code) since Sat 2023-05-06 06:59:11
MDT; 1min 27s ago
   Duration: 1d 20h 16min 29.633s
TriggeredBy: =C3=97 systemd-udevd-kernel.socket
             =C3=97 systemd-udevd-control.socket
       Docs: man:systemd-udevd.service(8)
             man:udev(7)
    Process: 27440 ExecStart=3D/usr/lib/systemd/systemd-udevd
(code=3Dexited, status=3D203/EXEC)
   Main PID: 27440 (code=3Dexited, status=3D203/EXEC)
        CPU: 5ms

----------------------
#mdadm --assemble --verbose --backup-file=3D/root/mdadm5-6_backup_md127
--invalid-backup /dev/md127 /dev/sda /dev/sdh /dev/sdg /dev/sdc
/dev/sdb /dev/sdf --force
mdadm: looking for devices for /dev/md127
mdadm: /dev/sda is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdh is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sdg is identified as a member of /dev/md127, slot 2.
mdadm: /dev/sdc is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sdb is identified as a member of /dev/md127, slot 4.
mdadm: /dev/sdf is identified as a member of /dev/md127, slot 5.
mdadm: /dev/md127 has an active reshape - checking if critical section
needs to be restored
mdadm: No backup metadata on /root/mdadm5-6_backup_md127
mdadm: Failed to find backup of critical section
mdadm: continuing without restoring backup
mdadm: added /dev/sdh to /dev/md127 as 1
mdadm: added /dev/sdg to /dev/md127 as 2
mdadm: added /dev/sdc to /dev/md127 as 3
mdadm: added /dev/sdb to /dev/md127 as 4
mdadm: added /dev/sdf to /dev/md127 as 5 (possibly out of date)
mdadm: added /dev/sda to /dev/md127 as 0

#hangs indefinitely at this point in the output

------------------------------------------


root       27454  0.0  0.0   3812  2656 pts/1    D+   07:00   0:00
mdadm --assemble --verbose --backup-file=3D/root/mdadm5-6_backup_md127
--invalid-backup /dev/md127 /dev/sda /dev/sdh /dev/sdg /dev/sdc
/dev/sdb /dev/sdf --force
root       27457  0.0  0.0      0     0 ?        S    07:00   0:00 [md127_r=
aid6]

#cat /proc/27454/stack
[<0>] mddev_suspend.part.0+0xdf/0x150
[<0>] suspend_lo_store+0xc5/0xf0
[<0>] md_attr_store+0x83/0xf0
[<0>] kernfs_fop_write_iter+0x124/0x1b0
[<0>] new_sync_write+0xff/0x190
[<0>] vfs_write+0x1ef/0x280
[<0>] ksys_write+0x5f/0xe0
[<0>] do_syscall_64+0x5c/0x90
[<0>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

#cat /proc/27457/stack
[<0>] md_thread+0x122/0x160
[<0>] kthread+0xe0/0x100
[<0>] ret_from_fork+0x22/0x30


On Sat, May 6, 2023 at 2:36=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2023/05/06 11:29, David Gilmour =E5=86=99=E9=81=93:
> > Hi all, after exhausting all other sources I could find online I have
> > come here in the hopes that someone may have some guidance that will
> > save my data. While I have an offsite backup of the most critical data
> > I definitely would prefer to find some \ ANY way to recover my array
> > to recover ALL my data.
> >
> > Situation: I had a healthy raid 5 array made up of 5 - 8TB drives. I
> > had always wanted to increase redundancy by growing this to a raid 6
> > array. I finally decided to get another drive and kicked off the
> > process with the following commands
> >
> > mdadm --add /dev/md127 /dev/sde #adding the 6th 8TB drive as a spare
> > mdadm --grow /dev/md127 --level=3Draid6 --raid-devices=3D6
> > --backup-file=3D/root/mdadm5-6_backup_md127
> >
> > Reshape started and everything looked good but after about 10mins
> > something crashed and I started seeing messages about drives not
> > responding and the shape process slowly slowed down to 0kbps. I
> > rebooted and my drives would not assemble showing (ignore the changing
> > drive letters as they swap around on each reboot but I am verifying
> > the right disks are in play for each command):
> >
> > Personalities : [raid1]
> > md127 : inactive sdh[1](S) sdg[3](S) sdb[5](S) sda[6](S) sdf[7](S) sdc[=
4](S)
> >        46883373072 blocks super 1.2
> > md1 : active raid1 sde3[0] sdd3[1]
> >        1919958912 blocks super 1.0 [2/2] [UU]
> >        bitmap: 5/15 pages [20KB], 65536KB chunk
> > md0 : active raid1 sde1[3] sdd1[2]
> >        1047488 blocks super 1.0 [2/2] [UU]
> >
> > /dev/md127:
> >             Version : 1.2
> >          Raid Level : raid6
> >       Total Devices : 6
> >         Persistence : Superblock is persistent
> >               State : inactive
> >     Working Devices : 6
> >           New Level : raid6
> >          New Layout : left-symmetric
> >       New Chunksize : 512K
> >                Name : milhouse.wooky.org:0
> >                UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
> >              Events : 984922
> >      Number   Major   Minor   RaidDevice
> >         -       8       32        -        /dev/sdc
> >         -       8        0        -        /dev/sda
> >         -       8      112        -        /dev/sdh
> >         -       8       80        -        /dev/sdf
> >         -       8       16        -        /dev/sdb
> >         -       8       96        -        /dev/sdg
> >
> > First thing I tried was stopping and restarting the array pointing to
> > the backup file I had on another partition with:
> >
> > mdadm --stop /dev/md127
> > mdadm --assemble --verbose --backup-file /root/mdadm5-6_backup_md127
> > /dev/md127 /dev/sdc /dev/sda /dev/sdh /dev/sdf /dev/sdb /dev/sdg
> >
> > But I get this fun error:
> > mdadm: looking for devices for /dev/md127
> > mdadm: /dev/sdc is identified as a member of /dev/md127, slot 3.
> > mdadm: /dev/sda is identified as a member of /dev/md127, slot 0.
> > mdadm: /dev/sdh is identified as a member of /dev/md127, slot 1.
> > mdadm: /dev/sdf is identified as a member of /dev/md127, slot 5.
> > mdadm: /dev/sdb is identified as a member of /dev/md127, slot 4.
> > mdadm: /dev/sdg is identified as a member of /dev/md127, slot 2.
> > mdadm: /dev/md127 has an active reshape - checking if critical section
> > needs to be restored
> > mdadm: No backup metadata on /root/mdadm5-6_backup_md127
> > mdadm: Failed to find backup of critical section
> > mdadm: Failed to restore critical section for reshape, sorry.
> >
> > Beyond that here is a list of things I have tried thus far :
> >
> > mdadm --assemble --verbose --backup-file=3D/root/mdadm5-6_backup_md127
> > /dev/md127 /dev/sdc /dev/sda /dev/sdh /dev/sdf /dev/sdb /dev/sdg #with
> > and without the --force option
> > mdadm --assemble --verbose --invalid-backup
> > --backup-file=3D/root/mdadm5-6_backup_md127 /dev/md127 /dev/sdc /dev/sd=
a
> > /dev/sdh /dev/sdf /dev/sdb /dev/sdg #with and without the --force
> > option
> >
> > Oddly enough this command with the force option causes my system to han=
g
>
> You can check this thread:
>
> https://lore.kernel.org/all/CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJF=
SH__Nw@mail.gmail.com/
>
> If your hang is the same, before this bug if fixed, you can bypass this
> hang by don't access the array before assemble is done.
>
> Thanks,
> Kuai
> >
> > I created raid overlay files and tried just creating the array in
> > various ways, all of which assemble ok but none are mountable (bad fs,
> > superblock etc message)
> >
> > Tried recreating as a raid 6 with the same parameters as the grow
> > (with and without the 6th 8TB that was originally added:
> >
> > mdadm --create /dev/md127 --level=3D6 --chunk=3D512K --metadata=3D1.2
> > --layout left-symmetric --data-offset=3D262144s --raid-devices=3D6
> > /dev/mapper/sda /dev/mapper/sdh /dev/mapper/sdg /dev/mapper/sdc
> > /dev/mapper/sde --assume-clean --readonly
> >   mdadm --create /dev/md127 --level=3D6 --chunk=3D512K --metadata=3D1.2
> > --layout left-symmetric --data-offset=3D262144s --raid-devices=3D5
> > /dev/mapper/sda /dev/mapper/sdh /dev/mapper/sdg /dev/mapper/sdc
> > /dev/mapper/sde --assume-clean --readonly
> >
> > Tried recreating the original raid 5 array with the 6th member removed
> >
> >   mdadm --create /dev/md127 --level=3D5 --chunk=3D512K --metadata=3D1.2
> > --layout left-symmetric --data-offset=3D262144s --raid-devices=3D5
> > /dev/mapper/sdb /dev/mapper/sdh /dev/mapper/sdg /dev/mapper/sdc
> > /dev/mapper/sde --assume-clean --readonly
> >
> >
> > This is where I am at... one thing I am curious about is the various
> > array state messages in the following mdadm --examine output for each
> > of these drives. Some show "AAAAAA" and some (3) show drives missing
> > in array "A..AA.". Does it make sense to remove the ones the system
> > thinks are missing then re-add them to the array? Any risk to this? I
> > would imagine the assemble with the force option would of covered this
> > possibility but maybe I misunderstand something here.
> >
> > # mdadm --examine /dev/sdc
> > /dev/sdc:
> >            Magic : a92b4efc
> >          Version : 1.2
> >      Feature Map : 0x5
> >       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
> >             Name : milhouse.wooky.org:0
> >    Creation Time : Thu Sep  7 03:12:27 2017
> >       Raid Level : raid6
> >     Raid Devices : 6
> >   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
> >       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
> >    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
> >      Data Offset : 262144 sectors
> >     Super Offset : 8 sectors
> >     Unused Space : before=3D262056 sectors, after=3D688 sectors
> >            State : active
> >      Device UUID : 42809136:2f8a0b1d:d519e4cb:ffc4ebd8
> > Internal Bitmap : 8 sectors from superblock
> >    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
> >       New Layout : left-symmetric
> >      Update Time : Mon May  1 04:48:57 2023
> >    Bad Block Log : 512 entries available at offset 72 sectors
> >         Checksum : 31a0dcf6 - correct
> >           Events : 984922
> >           Layout : left-symmetric-6
> >       Chunk Size : 512K
> >     Device Role : Active device 3
> >     Array State : A..AA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D replacing)
> >
> > # mdadm --examine /dev/sda
> > /dev/sda:
> >            Magic : a92b4efc
> >          Version : 1.2
> >      Feature Map : 0x5
> >       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
> >             Name : milhouse.wooky.org:0
> >    Creation Time : Thu Sep  7 03:12:27 2017
> >       Raid Level : raid6
> >     Raid Devices : 6
> >   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
> >       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
> >    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
> >      Data Offset : 262144 sectors
> >     Super Offset : 8 sectors
> >     Unused Space : before=3D262056 sectors, after=3D688 sectors
> >            State : clean
> >      Device UUID : 49955753:d202b004:64d74e3f:56480d25
> > Internal Bitmap : 8 sectors from superblock
> >    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
> >       New Layout : left-symmetric
> >      Update Time : Mon May  1 04:48:57 2023
> >    Bad Block Log : 512 entries available at offset 72 sectors
> >         Checksum : f59eab84 - correct
> >           Events : 984922
> >           Layout : left-symmetric-6
> >       Chunk Size : 512K
> >     Device Role : Active device 0
> >     Array State : AAAAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D replacing)
> >
> > # mdadm --examine /dev/sdh
> > /dev/sdh:
> >            Magic : a92b4efc
> >          Version : 1.2
> >      Feature Map : 0x5
> >       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
> >             Name : milhouse.wooky.org:0
> >    Creation Time : Thu Sep  7 03:12:27 2017
> >       Raid Level : raid6
> >     Raid Devices : 6
> >   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
> >       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
> >    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
> >      Data Offset : 262144 sectors
> >     Super Offset : 8 sectors
> >     Unused Space : before=3D262056 sectors, after=3D688 sectors
> >            State : active
> >      Device UUID : c915a45d:f2cc52ba:629dbf61:4c85efe6
> > Internal Bitmap : 8 sectors from superblock
> >    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
> >       New Layout : left-symmetric
> >      Update Time : Mon May  1 04:47:53 2023
> >    Bad Block Log : 512 entries available at offset 72 sectors
> >         Checksum : 99e7f8d4 - correct
> >           Events : 984922
> >           Layout : left-symmetric-6
> >       Chunk Size : 512K
> >     Device Role : Active device 1
> >     Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D replacing)
> >
> > # mdadm --examine /dev/sdf
> > /dev/sdf:
> >            Magic : a92b4efc
> >          Version : 1.2
> >      Feature Map : 0x7
> >       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
> >             Name : milhouse.wooky.org:0
> >    Creation Time : Thu Sep  7 03:12:27 2017
> >       Raid Level : raid6
> >     Raid Devices : 6
> >   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
> >       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
> >    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
> >      Data Offset : 262144 sectors
> >     Super Offset : 8 sectors
> > Recovery Offset : 8012800 sectors
> >     Unused Space : before=3D262064 sectors, after=3D688 sectors
> >            State : active
> >      Device UUID : 75127e45:a31ad132:d8dba6bc:0282e2bc
> > Internal Bitmap : 8 sectors from superblock
> >    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
> >       New Layout : left-symmetric
> >      Update Time : Mon May  1 04:47:53 2023
> >    Bad Block Log : 512 entries available at offset 40 sectors
> >         Checksum : 2b94c243 - correct
> >           Events : 984920
> >           Layout : left-symmetric-6
> >       Chunk Size : 512K
> >     Device Role : Active device 5
> >     Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D replacing)
> >
> > # mdadm --examine /dev/sdb
> > /dev/sdb:
> >            Magic : a92b4efc
> >          Version : 1.2
> >      Feature Map : 0x5
> >       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
> >             Name : milhouse.wooky.org:0
> >    Creation Time : Thu Sep  7 03:12:27 2017
> >       Raid Level : raid6
> >     Raid Devices : 6
> >   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
> >       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
> >    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
> >      Data Offset : 262144 sectors
> >     Super Offset : 8 sectors
> >     Unused Space : before=3D262056 sectors, after=3D688 sectors
> >            State : active
> >      Device UUID : 61265e10:8333498a:177ef638:617442f8
> > Internal Bitmap : 8 sectors from superblock
> >    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
> >       New Layout : left-symmetric
> >      Update Time : Mon May  1 04:48:57 2023
> >    Bad Block Log : 512 entries available at offset 72 sectors
> >         Checksum : 51446d6 - correct
> >           Events : 984922
> >           Layout : left-symmetric-6
> >       Chunk Size : 512K
> >     Device Role : Active device 4
> >     Array State : A..AA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D replacing)
> >
> > # mdadm --examine /dev/sdg
> > /dev/sdg:
> >            Magic : a92b4efc
> >          Version : 1.2
> >      Feature Map : 0x5
> >       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
> >             Name : milhouse.wooky.org:0
> >    Creation Time : Thu Sep  7 03:12:27 2017
> >       Raid Level : raid6
> >     Raid Devices : 6
> >   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
> >       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
> >    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
> >      Data Offset : 262144 sectors
> >     Super Offset : 8 sectors
> >     Unused Space : before=3D262056 sectors, after=3D688 sectors
> >            State : active
> >      Device UUID : d064611f:a97d457f:141f9fcf:e6471bb8
> > Internal Bitmap : 8 sectors from superblock
> >    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
> >       New Layout : left-symmetric
> >      Update Time : Mon May  1 04:47:53 2023
> >    Bad Block Log : 512 entries available at offset 72 sectors
> >         Checksum : 5fa33ce0 - correct
> >           Events : 984922
> >           Layout : left-symmetric-6
> >       Chunk Size : 512K
> >     Device Role : Active device 2
> >     Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D replacing)
> > .
> >
>
