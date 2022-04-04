Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1461C48BE6
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 21:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358671AbiDDV1X (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379510AbiDDRT2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 13:19:28 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305A313F77
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 10:17:32 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-e1e5e8d9faso6174568fac.4
        for <linux-raid@vger.kernel.org>; Mon, 04 Apr 2022 10:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=382yYDw6O3X8d0Bx3kqMLxpjxhqH2KpWPzjQIecl8zk=;
        b=Kp5jiu7WiNj3c5x4oD+ttzqCg3kOXBgs5BM72kiVC4ixF0Jj54yTJzCr+1lMAtGn9r
         /a7k2GcWkmBkwkwsaHoBE6mykdZv8knDdktaX3f2HHLPUQxZ0LKK+NxbVzt4DaiWYOQk
         lIBPyr0qXuPdMbYDaogCY2HhHShu8QI+Qd4uSbxZw4/h6S0gDDS5XfC53JAebJO+gyq0
         hD93Ec2Nga7E0nCLpfvX6ZfHl4IGAcw5PmIbX3FD6WDuqgL57x415UE4aqxTaVWb/89W
         nQzigAE+PW+xiumbCqplM8DVdQzqFWGD1O43LPtY6RB4GWU+y23QTIXPYZ8IhFZUrE4E
         EXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=382yYDw6O3X8d0Bx3kqMLxpjxhqH2KpWPzjQIecl8zk=;
        b=UYbQcIRcqsUNTOgL5cXyXRcJbmjPZiAW8WfCizca8/q0AYJGUjfCarDQgnjRrNjncq
         54D/IxUsI6vCsMNAezUh/EO68p5eQqongKv+UdfdVvdgZsvc2jy4MDyy7UqjYbizKkxS
         4vLIMF2l5eoJbp6pFDzyIWx5tSbhsTTwizhG9xp1aEnixBLuImUREuwG9CZXCcl6llxO
         Sllq/Ah6SEHLNDMtvMmi+Pc9Ar5FA3CB6Bs4WXFWGxV7Jl9OaZ0q8OG70FiXKltCsvIk
         6fQiW6cPQ2tyL0T5epWm5Onyva+rXDOcar2xt1Apgo95iUe3Z0oOzQXNiav3SW9pqexq
         IHHQ==
X-Gm-Message-State: AOAM533sIBxDK57/sVPZswRZ98GcaM0iCft4HrNdABO/8zxBrvyZDLBa
        Xj+OhxQPi53athNQG1dCgUInDY0+0yys+inBZQ==
X-Google-Smtp-Source: ABdhPJxz4qjA5mCSDb+y+p4CXd+mmuU6qPQKp2/G9ZobGDB+FTc7og/ynaTIDcJ0UwOQQ2t+bjUAY0lrwpW2X4667/g=
X-Received: by 2002:a05:6870:33a5:b0:dd:f6e6:7837 with SMTP id
 w37-20020a05687033a500b000ddf6e67837mr113419oae.154.1649092650400; Mon, 04
 Apr 2022 10:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <CANDfL1au6kdEkR3bmLAHTdGV-Rb==8Jy1ZnwNFjvjNq7drC1XA@mail.gmail.com>
 <586e0a78-e04e-0e9e-36bd-2b35d179f659@youngman.org.uk>
In-Reply-To: <586e0a78-e04e-0e9e-36bd-2b35d179f659@youngman.org.uk>
From:   Jorge Nunes <jorgebnunes@gmail.com>
Date:   Mon, 4 Apr 2022 18:17:19 +0100
Message-ID: <CANDfL1YjJLtzzSw59KH8G7eEna+DEVW9uUS2A0xYL7DuJCsrgQ@mail.gmail.com>
Subject: Re: RAID 1 to RAID 5 failure
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Wol,

Thank you for your answer. I'll wait as you suggested.

Best,
Jorge

Wols Lists <antlists@youngman.org.uk> escreveu no dia segunda,
4/04/2022 =C3=A0(s) 17:42:
>
> On 04/04/2022 16:19, Jorge Nunes wrote:
> > Hi everyone.
> > Probably this isn't the forum to post this, but I can't get true
> > valuable help on this:
>
> This is exactly the correct forum ...
> >
> > I have a NAS which is capable of having a RAID with four disks with
> > armbian debian bullseye. I used it for a long time with only two, sda
> > and sdd on RAID 1 - they are WD30EFRX. Now, I bought two more WD30EFRX
> > (refurbished) and my idea was to add them to have a RAID 5 array.
> > These were the steps I've made:
> >
> > Didn't do a backup :-(
> >
> > Unmount everything:
> > ```
> > $ sudo umount /srv/dev-disk-by-uuid-d1430a9e-6461-481b-9765-86e18e517cf=
c
> >
> > $ sudo umount -f /dev/md0
> > ```
> > Stopped the array:
> > ```
> > $ sudo mdadm --stop /dev/md0
> > ```
> >
> > Change the array to a RAID 5 with only the existing disks:
> > ```
> > $ sudo mdadm --create /dev/md0 -a yes -l 5 -n 2 /dev/sda /dev/sdd
> > ```
> > I made a mistake here and used the whole disks instead of the
> > /dev/sd[ad]1 partitions and MDADM warned me that /dev/sdd had a
> > partition and it would be overridden... I pressed 'Y' to continue...
> > :-(
> > It took a long time to complete without any errors.
>
> You made an even bigger error here - and I'm very sorry but it was
> probably fatal :-(
>
> If sda and sdd were your original disks, you created a NEW array, with
> different geometry. This will probably have trashed your data.
> >
> > Then I added the two new disks /dev/sdb and /dev/sdc to the array:
> > ```
> > $ sudo mdadm --add /dev/md0 /dev/sdb
> > $ sudo mdadm --add /dev/md0 /dev/sdc
> > ```
> > And did a grow to use the four disks:
> > ```
> > $ sudo mdadm --grow /dev/md0 --raid-disk=3D4
> > ```
> And if the first mistake wasn't fatal, this probably was.
>
> > During this process a reshape was performed like this
> > ```
> > Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
> > [raid4] [raid10]
> > md0 : active raid5 sdc[4] sdb[3] sdd[2] sda[0]
> >        2930134016 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/=
4] [UUUU]
> >        [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>..]  res=
hape =3D 90.1% (2640502272/2930134016)
> > finish=3D64.3min speed=3D75044K/sec
> >        bitmap: 0/22 pages [0KB], 65536KB chunk
> > ```
> > ```
> > $ sudo mdadm -D /dev/md0
> >
> > /dev/md0:
> >             Version : 1.2
> >       Creation Time : Fri Mar 11 16:10:02 2022
> >          Raid Level : raid5
> >          Array Size : 2930134016 (2794.39 GiB 3000.46 GB)
> >       Used Dev Size : 2930134016 (2794.39 GiB 3000.46 GB)
> >        Raid Devices : 4
> >       Total Devices : 4
> >         Persistence : Superblock is persistent
> >
> >       Intent Bitmap : Internal
> >
> >         Update Time : Sat Mar 12 20:20:14 2022
> >               State : clean, reshaping
> >      Active Devices : 4
> >     Working Devices : 4
> >      Failed Devices : 0
> >       Spare Devices : 0
> >
> >              Layout : left-symmetric
> >          Chunk Size : 512K
> >
> > Consistency Policy : bitmap
> >
> >      Reshape Status : 97% complete
> >       Delta Devices : 2, (2->4)
> >
> >                Name : helios4:0  (local to host helios4)
> >                UUID : 8e1ac1a8:8eabc3de:c01c8976:0be5bf6c
> >              Events : 12037
> >
> >      Number   Major   Minor   RaidDevice State
> >         0       8        0        0      active sync   /dev/sda
> >         2       8       48        1      active sync   /dev/sdd
> >         4       8       32        2      active sync   /dev/sdc
> >         3       8       16        3      active sync   /dev/sdb
> > ```
> >
> > When this looooooong process has completed without errors, I did a e2fs=
ck
> > ```
> > $ sudo e2fsck /dev/md0
> > ```
> > And... it gave this info:
> > ```
> > e2fsck 1.46.2 (28-Feb-2021)
> > ext2fs_open2: Bad magic number in super-block
> > e2fsck: Superblock invalid, trying backup blocks...
> > e2fsck: Bad magic number in super-block while trying to open /dev/md0
> >
> > The superblock could not be read or does not describe a valid ext2/ext3=
/ext4
> > filesystem.  If the device is valid and it really contains an ext2/ext3=
/ext4
> > filesystem (and not swap or ufs or something else), then the superblock
> > is corrupt, and you might try running e2fsck with an alternate superblo=
ck:
> >      e2fsck -b 8193 <device>
> > or
> >      e2fsck -b 32768 <device>
> > ```
> > At this point I realized that I've made some mistakes during this proce=
ss...
> > Googled for the problem and I think the disks in the array are somehow
> > order 'reversed' judging from this post:
> > https://forum.qnap.com/viewtopic.php?t=3D125534
> >
> > So, the partition is 'gone' and when I try to assemble the array now,
> > I have this info:
> > ```
> > $ sudo mdadm --assemble --scan -v
> >
> > mdadm: /dev/sdd is identified as a member of /dev/md/0, slot 1.
> > mdadm: /dev/sdb is identified as a member of /dev/md/0, slot 3.
> > mdadm: /dev/sdc is identified as a member of /dev/md/0, slot 2.
> > mdadm: /dev/sda is identified as a member of /dev/md/0, slot 0.
> > mdadm: added /dev/sdd to /dev/md/0 as 1
> > mdadm: added /dev/sdc to /dev/md/0 as 2
> > mdadm: added /dev/sdb to /dev/md/0 as 3
> > mdadm: added /dev/sda to /dev/md/0 as 0
> > mdadm: /dev/md/0 has been started with 4 drives.
> >
> > $ dmesg
> >
> > [143605.261894] md/raid:md0: device sda operational as raid disk 0
> > [143605.261909] md/raid:md0: device sdb operational as raid disk 3
> > [143605.261919] md/raid:md0: device sdc operational as raid disk 2
> > [143605.261927] md/raid:md0: device sdd operational as raid disk 1
> > [143605.267400] md/raid:md0: raid level 5 active with 4 out of 4
> > devices, algorithm 2
> > [143605.792653] md0: detected capacity change from 0 to 17580804096
> >
> > $ cat /proc/mdstat
> >
> > Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
> > [raid4] [raid10]
> > md0 : active (auto-read-only) raid5 sda[0] sdb[3] sdc[4] sdd[2]
> >        8790402048 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/=
4] [UUUU]
> >        bitmap: 0/22 pages [0KB], 65536KB chunk
> >
> >
> > $ sudo mdadm -D /dev/md0
> >
> > /dev/md0:
> >             Version : 1.2
> >       Creation Time : Fri Mar 11 16:10:02 2022
> >          Raid Level : raid5
> >          Array Size : 8790402048 (8383.18 GiB 9001.37 GB)
> >       Used Dev Size : 2930134016 (2794.39 GiB 3000.46 GB)
> >        Raid Devices : 4
> >       Total Devices : 4
> >         Persistence : Superblock is persistent
> >
> >       Intent Bitmap : Internal
> >
> >         Update Time : Sat Mar 12 21:24:59 2022
> >               State : clean
> >      Active Devices : 4
> >     Working Devices : 4
> >      Failed Devices : 0
> >       Spare Devices : 0
> >
> >              Layout : left-symmetric
> >          Chunk Size : 512K
> >
> > Consistency Policy : bitmap
> >
> >                Name : helios4:0  (local to host helios4)
> >                UUID : 8e1ac1a8:8eabc3de:c01c8976:0be5bf6c
> >              Events : 12124
> >
> >      Number   Major   Minor   RaidDevice State
> >         0       8        0        0      active sync   /dev/sda
> >         2       8       48        1      active sync   /dev/sdd
> >         4       8       32        2      active sync   /dev/sdc
> >         3       8       16        3      active sync   /dev/sdb
> > ```
> >
> > The array mounts but there is no superblock.
> >
> > At this stage, I did a photorec to try to recover my valuable data
> > (mainly family photos):
>
> This I am afraid is probably your best bet.
> > ```
> > $ sudo photorec /log /d ~/k/RAID_REC/ /dev/md0
> > ```
> > I just recovered a lot of them but others are corrupted because on the
> > photorec recovering process (sector by sector) it increments the
> > sector count as time passes but then the counter is 'reset' to a lower
> > value (my suspicion that the disks are scrambled in the array) and it
> > recovers some files again (some are equal).
>
> No they're not scrambled. The raid spreads blocks across the individual
> disks. You're running photorec over the md. Try running it over the
> individual disks, sda,sdb,sdc,sdd. You might get a different set of
> pictures back.> Best,
>  >
>  > Jorge
>
> >
> > So, my question is: Is there a chance to redo the array correctly
> > without losing the information inside? Is it possible to recover the
> > 'lost' partition that existed on RAID 1 to be able to do a convenient
> > backup? Or the only chance is to have a correct disk alignment inside
> > the array to be able to use photorec to recover the files correctly?
> >
> > I appreciate your help.
> > Thanks!
> >
> I've cc'd the guys most likely to be able to help, but I think they'll
> give you the same answer I have, sorry.
>
> Your only hope is probably to convert it back to the original two-disk
> raid 5, then it is *likely* that your original mirror will be in place.
> If you then recreate the original partition, I'm *hoping* this will give
> you your original mirror back in a broken state. From which you can
> might be able to recover.
>
> But I seriously suggest DON'T DO ANYTHING that writes to the disk until
> the experts chime in. You've trashed your raid, don't make it any worse.
>
> Wol
