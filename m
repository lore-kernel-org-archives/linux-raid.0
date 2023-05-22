Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592E1C7EE2D
	for <linux-raid@archiver.kernel.org>; Tue, 23 May 2023 00:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbjEWAk2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 May 2023 20:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbjEWAKw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 22 May 2023 20:10:52 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA4D2102
        for <linux-raid@vger.kernel.org>; Mon, 22 May 2023 16:50:13 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-33550237f6fso1526845ab.3
        for <linux-raid@vger.kernel.org>; Mon, 22 May 2023 16:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684799413; x=1687391413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8HUX5qFRj570KVtloJTuSEa/8SKBFI9o3yUmk9oA5Q=;
        b=fv1EgaBuLm7yKFOSY4MjWbQmcErC/5NmNWfCrR5oCy5U4mVJqT2QeQAKZQM0bmEUKD
         cSxlfbF3AL/8hi1HyuSefWa/dsGewcn72sAICnmW/hhlW8g/xk23LGnnT2ckS74K/XFc
         ROq54+uRavGhH2YbTgLcAnMQqDzp13XZgUtsQPGagvpZfD/JrQpB4S+ThmJVbH/aJnZX
         +EU7wGu0wcNkVtRv2NQUhfm0PRUjcxsgQOGTh6sJG6btvsPkSSrSIkBg+4dIGxVqDt2Z
         0ErPQyC5Zz3WLJTy7C6EBmeR89ZMOZnspB4j+FMC9R7x8JRrJgJfaQBl3oONOJT8HfJu
         0BHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684799413; x=1687391413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w8HUX5qFRj570KVtloJTuSEa/8SKBFI9o3yUmk9oA5Q=;
        b=ayPm6XERS/J6bHQOyfUyBCPfxqt1XW3rjYTm/0Ji+AXWBI4IExCWu4/4imPs1W/PVI
         WFkHMBsugKktnPHpOof28PIPtH9lJtKolI9FrtI+OYy1B142gUPWeF9gOx0CU0qKic+h
         dS0Ft7ZaiidNa67bI9DTahBQ0TsXok07EG2Try4lcsrhdRWoCQECoU+GWCyf27U6FwEo
         3yX/qQtCnFBkvSXCG7epki11GoC38ErUrM0AxdNk+ROrD0FYo0p014E4XrlGB7TPk8dj
         yxwzuIeAm2oaBXemwrJtKhGsKpQ/IzHVOmyYzEVQX7Sw1xYUrgTQZs5yZT44YVnLac+N
         QM/A==
X-Gm-Message-State: AC+VfDycPf2vACFzCoSHG3Jhb2N2EKkM058togwQ9sgIFM/uZfz6s8UR
        vdvi5VnSXbdDurBUYMFmzzE/LTsEFNZ6Yo1qRh4=
X-Google-Smtp-Source: ACHHUZ6IsMzCHJVASOptZo/uGdZaJLXKXWPnMqzgMHyzoa4fRmBky24hCMxFP6hCBwHCw77F3wh25EhWUe56hkUohyE=
X-Received: by 2002:a92:cb06:0:b0:331:f812:63a6 with SMTP id
 s6-20020a92cb06000000b00331f81263a6mr8972568ilo.14.1684799412924; Mon, 22 May
 2023 16:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <60563747e11acd6757b20ba19006fcdcff5df519.camel@electrons.cloud>
 <96524acc-504d-6a07-85a0-0b56a9e2f2d7@youngman.org.uk> <9b22d5ce-5f1b-0fc8-acdc-02c2e8cefa55@huaweicloud.com>
 <b18cfe9f6f8e44285aa4ab4300e0c0e1b863fe08.camel@electrons.cloud>
 <a78c4551-defb-d531-3b5e-372889158f28@huaweicloud.com> <3f3fd288e33cccdae32e3f26943218c773589849.camel@electrons.cloud>
In-Reply-To: <3f3fd288e33cccdae32e3f26943218c773589849.camel@electrons.cloud>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Mon, 22 May 2023 18:50:01 -0500
Message-ID: <CAAMCDedzs2mi7TGrOUKkSDPVqOQvq+j2JMa3WOtzOtwt7324Jw@mail.gmail.com>
Subject: Re: RAID5 Phantom Drive Appeared while Reshaping Four Drive Array (HARDLOCK)
To:     raid@electrons.cloud
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, Wol <antlists@youngman.org.uk>,
        linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Given what the array is reporting I would doubt that is going to fix
anything.    The array being in the middle of a reshape makes it
likely that neither n or n-1 is the right raid config for at least 1/2
of the data, so it is likely the filesystem will be completely broken.

Right now the array reports it is a 5 disk array, and the array data
says it was going from 4 disks to 5.

What was the command you used to add the 4th disk?     No one is sure
based on what you are saying how exactly the array got into this
state.   The data being shown disagrees with what you are reporting,
and given that no one knows what actually happened.

On Mon, May 22, 2023 at 3:18=E2=80=AFPM raid <raid@electrons.cloud> wrote:
>
> Hi
>
> Thanks for your time so far ! Final questions before I rebuild this RAID =
from scratch.
>
> BTW I created detailed notes when I created this array (as I have for eig=
ht other RAIDs that I maintain).
>     These notes may be applicable later... Here's why.
>
> Do you think that Zero'ing the drives (as is done for initial drive prep)=
 and then recreating the
> RAID5 using the initial settings (originally three drives, NOW four drive=
s) could possibly offer
> a greater chance to recover files? As in, more complete file recovery if =
the striping aligns
> correctly? Technically, I've had to write off the files that aren't curre=
ntly backed up.
>
> However, I'm still willing to make an attempt if you think the idea above=
 might yield something
> better than one or two stripes of data per file?
>
> And/Or any other tips for this final attempt? Setting ReadOnly if possibl=
e?
>
> Thanks Again
> SA
>
> ---
> Detailed Notes:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   2021.10.26 0200P NEW RAID MD480 (48TB) 3x 1600GB HITACHI
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D PREPARATION =3D=3D
>
> watch -c -d -n 1 cat /proc/mdstat  ############## OPEN A TERMINAL AND MON=
ITOR STATUS ##
>
> sudo lsblk && sudo blkid  ########################################### VER=
IFY DEVICES ##
>
> sudo umount /MEGARAID                         # Unmount if filesystem is =
mounted
> sudo mdadm --stop /dev/md480                  # Stop the RAID/md480 devic=
e
> sudo mdadm --zero-superblock /dev/sd[cdf]1    # Zero  the   superblock(s)=
  on
>                                               #      all members of the a=
rray
> sudo mdadm --remove /dev/md480                # Remove the RAID/md480
>
> Edit  ########################################## OPTIONAL FINALIZE PERMAN=
ENT REMOVAL ##
> /etc/fstab
> /etc/mdadm/mdadm.conf
> Removing referrences to the mounting and the definition of the RAID/MD480=
 device(s)
> NOTE: Some fstab CFG settings allow skipping devices when unavailable at =
boot. (nofail)
>
> sudo update-initramfs -uv       # -uv  update ; verbose  ########### RESE=
T INITRAMFS ##
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D CREATE RAID & ADD FILESYSTEM =3D=
=3D
>   MEGARAID 2021.10.26 0200P
> ##############  RAID5 ARRAY MD480 32TB (32,001,527,644,160 bytes) Availab=
le (3x16TB) ##
>
> sudo mdadm --create --verbose /dev/md480 --level=3D5 --raid-devices=3D3 -=
-uuid=3D2021102502005a7a5a7abeefcafebabe
> /dev/sd[cdf]1
>
> 31,251,491,840 BLOCKS CREATED IN ~20 HOURS
>
> ############################################################  CREATE FILE=
SYSTEM EXT4 ##
>  -v VERBOSE
>  -L DISK LABEL
>  -U UUID FORMATTED AS 8CHARS-4CHARS-4CHARS-4CHARS-12CHARS
>  -m OVERFLOW PROTECTION PERCENTAGE IE. .025 OF 24,576GB IS ~615MB FREE IS=
 CONSIDERED FULL
>  -b BLOCK SIZE 1/4 OF STRIDE=3D OFFERS BEST OVERALL PERFORMANCE
>  -E STRIDE=3D MULTIPLE OF 8
>     STRIPE-WIDTH=3D STRIDE X 2
>
> sudo mkfs.ext4 -v -L MEGARAID    -U 20211028-0500-5a7a-5a7a-beefcafebabe =
-m .025 -b 4096 -E stride=3D32,stripe-width=3D64
> /dev/md480
>
> sudo mkdir  /MEGARAID  ; sudo chown adminx:adminx -R /MEGARAID
>
> ##############################################################  SET CORRE=
CT HOMEHOST ##
>
> sudo umount /MEGARAID
> sudo mdadm --stop /dev/md480
> sudo mdadm --assemble --update=3Dhomehost --homehost=3DGRANDSLAM /dev/md4=
80 /dev/sd[cdf]1
> sudo blkid
>
> /dev/sdc1: UUID=3D"20211025-0200-5a7a-5a7a-beefcafebabe"
>            UUID_SUB=3D"8f0835db-3ea2-4540-2ab4-232d6203d1b7"
>            LABEL=3D"GRANDSLAM:480" TYPE=3D"linux_raid_member"
>            PARTLABEL=3D"HIT*16TB*001*RAID5"
>            PARTUUID=3D"3b68fe63-35d0-404d-912e-dfe1127f109b"
>
> /dev/sdd1: UUID=3D"20211025-0200-5a7a-5a7a-beefcafebabe"
>            UUID_SUB=3D"b4660f49-867b-9f1e-ecad-0acec7119c37"
>            LABEL=3D"GRANDSLAM:480" TYPE=3D"linux_raid_member"
>            PARTLABEL=3D"HIT*16TB*002*RAID5"
>            PARTUUID=3D"32c50f4f-f6ce-4309-b8e4-facdb6e05ba8"
>
> /dev/sdf1: UUID=3D"20211025-0200-5a7a-5a7a-beefcafebabe"
>            UUID_SUB=3D"79a3dff4-c53f-9071-f9c1-c262403fbc10"
>            LABEL=3D"GRANDSLAM:480" TYPE=3D"linux_raid_member"
>            PARTLABEL=3D"HIT*16TB*003*RAID5"
>            PARTUUID=3D"7ec27f96-2275-4e09-9013-ac056f11ebfb"
>
> /dev/md480: LABEL=3D"MEGARAID" UUID=3D"20211028-0500-5a7a-5a7a-beefcafeba=
be" TYPE=3D"ext4"
>
> ############################################################### ENTRY FOR=
 /ETC/FSTAB ##
>
> /dev/md480              /MEGARAID               ext4            nofail,no=
atime,nodiratime,relatime,errors=3Dremount-ro
> 0               2
>
> #################################################### ENTRY FOR /ETC/MDADM=
/MDADM.CONF ##
>
> ARRAY /dev/md480 metadata=3D1.2 name=3DGRANDSLAM:480 UUID=3D20211025:0200=
5a7a:5a7abeef:cafebabe
>
> #########################################################################=
##############
>
> sudo update-initramfs -uv       # -uv  update ; verbose
> sudo mount -a
> sudo chown adminx:adminx -R /MEGARAID
>
> ############################################################### END 2021.=
10.28 0545A ##
>
>
>
>
>
>
> On Mon, 2023-05-22 at 15:51 +0800, Yu Kuai wrote:
> > Hi,
> >
> > =E5=9C=A8 2023/05/22 14:56, raid =E5=86=99=E9=81=93:
> > > Hi,
> > > Thanks for the guidance as the current state has at least changed som=
ewhat.
> > >
> > > BTW Sorry about Life getting in the way of tech. =3D) Reason for my d=
elayed response.
> > >
> > > -sudo mdadm -I /dev/sdc1
> > > mdadm: /dev/sdc1 attached to /dev/md480, not enough to start (1).
> > > -sudo mdadm -D /dev/md480
> > > /dev/md480:
> > >             Version : 1.2
> > >          Raid Level : raid0
> > >       Total Devices : 1
> > >         Persistence : Superblock is persistent
> > >
> > >               State : inactive
> > >     Working Devices : 1
> > >
> > >       Delta Devices : 1, (-1->0)
> > >           New Level : raid5
> > >          New Layout : left-symmetric
> > >       New Chunksize : 512K
> > >
> > >                Name : GRANDSLAM:480
> > >                UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > >              Events : 78714
> > >
> > >      Number   Major   Minor   RaidDevice
> > >
> > >         -       8       33        -        /dev/sdc1
> > > -sudo mdadm -I /dev/sdd1
> > > mdadm: /dev/sdd1 attached to /dev/md480, not enough to start (2).
> > > -sudo mdadm -D /dev/md480
> > > /dev/md480:
> > >             Version : 1.2
> > >          Raid Level : raid0
> > >       Total Devices : 2
> > >         Persistence : Superblock is persistent
> > >
> > >               State : inactive
> > >     Working Devices : 2
> > >
> > >       Delta Devices : 1, (-1->0)
> > >           New Level : raid5
> > >          New Layout : left-symmetric
> > >       New Chunksize : 512K
> > >
> > >                Name : GRANDSLAM:480
> > >                UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > >              Events : 78714
> > >
> > >      Number   Major   Minor   RaidDevice
> > >
> > >         -       8       49        -        /dev/sdd1
> > >         -       8       33        -        /dev/sdc1
> > > -sudo mdadm -I /dev/sde1
> > > mdadm: /dev/sde1 attached to /dev/md480, not enough to start (2).
> > > -sudo mdadm -D /dev/md480
> > > /dev/md480:
> > >             Version : 1.2
> > >          Raid Level : raid0
> > >       Total Devices : 3
> > >         Persistence : Superblock is persistent
> > >
> > >               State : inactive
> > >     Working Devices : 3
> > >
> > >       Delta Devices : 1, (-1->0)
> > >           New Level : raid5
> > >          New Layout : left-symmetric
> > >       New Chunksize : 512K
> > >
> > >                Name : GRANDSLAM:480
> > >                UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > >              Events : 78712
> > >
> > >      Number   Major   Minor   RaidDevice
> > >
> > >         -       8       65        -        /dev/sde1
> > >         -       8       49        -        /dev/sdd1
> > >         -       8       33        -        /dev/sdc1
> > > -sudo mdadm -I /dev/sdf1
> > > mdadm: /dev/sdf1 attached to /dev/md480, not enough to start (3).
> > > -sudo mdadm -D /dev/md480
> > > /dev/md480:
> > >             Version : 1.2
> > >          Raid Level : raid0
> > >       Total Devices : 4
> > >         Persistence : Superblock is persistent
> > >
> > >               State : inactive
> > >     Working Devices : 4
> > >
> > >       Delta Devices : 1, (-1->0)
> > >           New Level : raid5
> > >          New Layout : left-symmetric
> > >       New Chunksize : 512K
> > >
> > >                Name : GRANDSLAM:480
> > >                UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > >              Events : 78714
> > >
> > >      Number   Major   Minor   RaidDevice
> > >
> > >         -       8       81        -        /dev/sdf1
> > >         -       8       65        -        /dev/sde1
> > >         -       8       49        -        /dev/sdd1
> > >         -       8       33        -        /dev/sdc1
> > > -sudo mdadm -R /dev/md480
> > > mdadm: failed to start array /dev/md480: Input/output error
> > > ---
> > > NOTE: Of additional interest...
> > > ---
> > > -sudo mdadm -D /dev/md480
> > > /dev/md480:
> > >             Version : 1.2
> > >       Creation Time : Tue Oct 26 14:06:53 2021
> > >          Raid Level : raid5
> > >       Used Dev Size : 18446744073709551615
> > >        Raid Devices : 5
> > >       Total Devices : 3
> > >         Persistence : Superblock is persistent
> > >
> > >         Update Time : Thu May  4 14:39:03 2023
> > >               State : active, FAILED, Not Started
> > >      Active Devices : 3
> > >     Working Devices : 3
> > >      Failed Devices : 0
> > >       Spare Devices : 0
> > >
> > >              Layout : left-symmetric
> > >          Chunk Size : 512K
> > >
> > > Consistency Policy : unknown
> > >
> > >       Delta Devices : 1, (4->5)
> > >
> > >                Name : GRANDSLAM:480
> > >                UUID : 20211025:02005a7a:5a7abeef:cafebabe
> > >              Events : 78714
> > >
> > >      Number   Major   Minor   RaidDevice State
> > >         -       0        0        0      removed
> > >         -       0        0        1      removed
> > >         -       0        0        2      removed
> > >         -       0        0        3      removed
> > >         -       0        0        4      removed
> > >
> > >         -       8       81        3      sync   /dev/sdf1
> > >         -       8       49        1      sync   /dev/sdd1
> > >         -       8       33        0      sync   /dev/sdc1
> >
> > So the reason that this array can't start is that /dev/sde1 is not
> > recognized as RaidDevice 2, and there are two RaidDevice missing for
> > a raid5.
> >
> > Sadly I have no idea to workaroud this, sb metadate seems to be broken.
> >
> > Thanks,
> > Kuai
> > > ---
> > > -watch -c -d -n 1 cat /proc/mdstat
> > > ---
> > > Every 1.0s: cat /proc/mdstat                                         =
            OAK2023: Mon May 22 01:48:24 2023
> > >
> > > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]
> > > md480 : inactive sdf1[4] sdd1[1] sdc1[0]
> > >        46877239294 blocks super 1.2
> > >
> > > unused devices: <none>
> > > ---
> > > Hopeful that is some progress towards an array start? It's definately=
 unexpected output to me.
> > > I/O Error starting md480
> > >
> > > Thanks!
> > > SA
> > >
> > > On Thu, 2023-05-18 at 11:15 +0800, Yu Kuai wrote:
> > >
> > > > I have no idle why other disk shows that device 2 is missing, and w=
hat
> > > > is device 4.
> > > >
> > > > Anyway, can you try the following?
> > > >
> > > > mdadm -I /dev/sdc1
> > > > mdadm -D /dev/mdxxx
> > > >
> > > > mdadm -I /dev/sdd1
> > > > mdadm -D /dev/mdxxx
> > > >
> > > > mdadm -I /dev/sde1
> > > > mdadm -D /dev/mdxxx
> > > >
> > > > mdadm -I /dev/sdf1
> > > > mdadm -D /dev/mdxxx
> > > >
> > > > If above works well, you can try:
> > > >
> > > > mdadm -R /dev/mdxxx, and see if the array can be started.
> > > >
> > > > Thanks,
> > > > Kuai
> > >
> > >
> > >
> > > .
> > >
>
