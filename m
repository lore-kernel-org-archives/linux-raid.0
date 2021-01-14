Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC95C433E0
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jan 2021 22:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5E9323A5C
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jan 2021 22:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbhANW6e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Jan 2021 17:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbhANW6d (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Jan 2021 17:58:33 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEC6C061575
        for <linux-raid@vger.kernel.org>; Thu, 14 Jan 2021 14:57:53 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ga15so10671548ejb.4
        for <linux-raid@vger.kernel.org>; Thu, 14 Jan 2021 14:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=o5DhL6WE7avsJtvSxdN6auq0OdWRaTEG6M0xSvH88Cc=;
        b=cR6zZMLkxW3xk7IbLmS9t8pqA6B0sdqqeJgXEPAQBOcawv+Y76mkp0b4eetqn/Dil2
         Pt/hB/KuWNxfVPTIurIIGNXCE+ynx7zOtbSYtz2YsP51YjiP+phJbink22qrJgvbeCVl
         Lg9WgRktabZVUIH5+nWzoigbOa41fpzkR1+KvR2oLynz2CGbSW5lZ4dBtGkawd7yL/A2
         DE5/TC1m0TOaSpCHxRQRLL7mn2woDCB6sJsiKcfnlZLo4vM3GpVMd/x9qa9gsVLdN+UM
         Q84Ql/OpVNtiECwnu0aucFMxaeMOtuu5yNVFycqHauTAgNY7hy/rqghqWmk6akuu5IKY
         XAKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=o5DhL6WE7avsJtvSxdN6auq0OdWRaTEG6M0xSvH88Cc=;
        b=L7WVIoe64ZZKzkiYXdVX2l928K4oEwNApcc/mc1o9UxNtwnKllLdXW2aeTrSVxwZBB
         SMkhiBryrZPqaUhtzf/hjoBlAUN//PbI7d1t7IifDLVjbRKMsVJ6lsP8eEJzvu91+e+p
         a+nf1Qo/TU+wI1CmR9PkPCtDEjF3BBwVqjigErmyq9Z+k8wvpK6Drq2bAg+fL5GDOnJX
         UiuXuUIRBHb/Av0E2yCU5EBg56gF8oGZbINzv50nlNNBjXIYuK79or0ekWJrbKbQM9Z6
         oOSM0y6n9W1Ij8i+/4XQCu3u16VpOAEjOIZ7MkjsPUcCOpiIBaOzf6jbBp7+phVHs8OG
         xO3g==
X-Gm-Message-State: AOAM533Pl6qpaOC44Sor+H0tvM6qVluo+pjZXEjBGz7tgplQIuQMqsyu
        Yy5/0MI7sMJ6BNJLgCt+W9d8jJcag7viv0EMsFCqz+d4+Fo=
X-Google-Smtp-Source: ABdhPJx9haIzZpnr2CATpsQoBabvR8mq/4htNAtCVmc7x+21NuYXIG8ZZlWHAUYDOSIhdAoupHhA6Nw1JwAYesG9IE0=
X-Received: by 2002:a17:906:4348:: with SMTP id z8mr6934420ejm.371.1610665071854;
 Thu, 14 Jan 2021 14:57:51 -0800 (PST)
MIME-Version: 1.0
From:   Nathan Brown <nbrown.us@gmail.com>
Date:   Thu, 14 Jan 2021 16:57:40 -0600
Message-ID: <CAHikZs7DaOj4QAw0VcbidmdrP11pWE-NTcxXDJS=KW9rf0TY7Q@mail.gmail.com>
Subject: Self inflicted reshape catastrophe
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Scenario:

I had a 4 by 10TB raid 5 array and was adding 5 more disks and
reshaping it to a raid6. This was working just fine until I got a
little too aggressive with perf tuning and caused `mdadm` to
completely hang. I froze the rebuild and rebooted the server to wipe
away my tuning mess. The raid didn't automatically assemble so I did
`mdadm --assemble` but really screwed up and put the 5 new disks in a
different array. Not sure why the superblock on those disks didn't
stop `mdadm` from putting them into service but the end result was the
superblock on those 5 new drives got wiped. That array was missing a
disk so 4 went into spare and 1 went into service, I let that rebuild
complete as I figure I'd likely already lost any usable data there.

I now have 4 disks with proper looking superblocks, 4 disks with
garbage superblocks, and 1 disk sitting in an array that it shouldn't
be in. My primary concern is on assembling the 10TB disk array.

What I've done so far:

All this is done with an overlay to avoid modifying the disks any further.

`mdadm --assemble` if I provide all disks, it will refuse to start as
it hits the first of the new drives "superblock on ... doesn't match
others", `--force` has no effect. `--update=revert-reshape` changes
the `--examine` details but nothing happens since the other 5 drives
are absent.

`mdadm --assemble` again with all disks but the new disks super blocks
have been zero'd. Refuses once it hits the first of the new disks "No
super block found on ...", `--force` has no effect.

`mdadm --assemble` using only the 4 original disks, the md dev shows
up now but can't start. If I try to add any of the new disks I get
"Cannot get array info for /dev/md#", `--force` and super block
zeroing has no effect.

`mdadm --create` using all permutations of the new drives, I believe
know the order of the old ones. A handful of the 120 different
arrangements will allow me to see some of the files, but I do not know
how to move the reshape along in this state. Please note that 1 disk
position is using `missing`.

I believe my next best bet is to try and create an appropriate super
block and write them to each of the new disks to see if it will
assemble and continue the reshape. I wanted to get this lists
suggestions before I went down that path.

Thank you for your time.

Details:

`mdadm --version`
mdadm - v4.1 - 2018-10-01

`lsb_release -a`
Distributor ID: Ubuntu
Description: Ubuntu 20.04.1 LTS
Release: 20.04
Codename: focal

`uname -a`
Linux nas2 5.4.0-60-generic #67-Ubuntu SMP Tue Jan 5 18:31:36 UTC 2021
x86_64 x86_64 x86_64 GNU/Linux

`mdadm -E /dev/sdk1`
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : a6914f4a:14a64337:c3546c24:42930ff9
           Name : any:0
  Creation Time : Mon Dec 23 22:56:41 2019
     Raid Level : raid6
   Raid Devices : 9
 Avail Dev Size : 19532605440 (9313.87 GiB 10000.69 GB)
     Array Size : 68364119040 (65197.10 GiB 70004.86 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=0 sectors
          State : clean
    Device UUID : a247b8d7:6abdf354:8ca03a82:8681cf54
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 1922360832 (1833.31 GiB 1968.50 GB)
  Delta Devices : 4 (5->9)
     New Layout : left-symmetric
    Update Time : Thu Jan 14 02:02:24 2021
  Bad Block Log : 512 entries available at offset 48 sectors
       Checksum : 4229db98 - correct
         Events : 146894
         Layout : left-symmetric-6
     Chunk Size : 512K
   Device Role : Active device 0
   Array State : AAAA..A.A ('A' == active, '.' == missing, 'R' == replacing)

mdadm -E /dev/sdj1
`/dev/sdj1:`
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : a6914f4a:14a64337:c3546c24:42930ff9
           Name : any:0
  Creation Time : Mon Dec 23 22:56:41 2019
     Raid Level : raid6
   Raid Devices : 9
 Avail Dev Size : 19532605440 (9313.87 GiB 10000.69 GB)
     Array Size : 68364119040 (65197.10 GiB 70004.86 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=0 sectors
          State : clean
    Device UUID : 218773e0:f097e26a:10eb2032:8b0c5f2a
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 1922360832 (1833.31 GiB 1968.50 GB)
  Delta Devices : 4 (5->9)
     New Layout : left-symmetric
    Update Time : Thu Jan 14 02:02:24 2021
  Bad Block Log : 512 entries available at offset 48 sectors
       Checksum : e64ccb33 - correct
         Events : 146894
         Layout : left-symmetric-6
     Chunk Size : 512K
   Device Role : Active device 1
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

`mdadm -E /dev/sdh1`
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : a6914f4a:14a64337:c3546c24:42930ff9
           Name : any:0
  Creation Time : Mon Dec 23 22:56:41 2019
     Raid Level : raid6
   Raid Devices : 9
 Avail Dev Size : 19532605440 (9313.87 GiB 10000.69 GB)
     Array Size : 68364119040 (65197.10 GiB 70004.86 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=0 sectors
          State : clean
    Device UUID : e8062d92:654dc1e0:4e28b361:eb97ccc2
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 1922360832 (1833.31 GiB 1968.50 GB)
  Delta Devices : 4 (5->9)
     New Layout : left-symmetric
    Update Time : Thu Jan 14 02:02:24 2021
  Bad Block Log : 512 entries available at offset 48 sectors
       Checksum : d5e4c90f - correct
         Events : 146894
         Layout : left-symmetric-6
     Chunk Size : 512K
   Device Role : Active device 2
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

`mdadm -E /dev/sdi1`
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : a6914f4a:14a64337:c3546c24:42930ff9
           Name : any:0
  Creation Time : Mon Dec 23 22:56:41 2019
     Raid Level : raid6
   Raid Devices : 9
 Avail Dev Size : 19532605440 (9313.87 GiB 10000.69 GB)
     Array Size : 68364119040 (65197.10 GiB 70004.86 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=0 sectors
          State : clean
    Device UUID : f0612be8:dcf9d96b:1926ce52:484d9ab2
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 1922360832 (1833.31 GiB 1968.50 GB)
  Delta Devices : 4 (5->9)
     New Layout : left-symmetric
    Update Time : Thu Jan 14 02:02:24 2021
  Bad Block Log : 512 entries available at offset 48 sectors
       Checksum : 97e483b8 - correct
         Events : 146894
         Layout : left-symmetric-6
     Chunk Size : 512K
   Device Role : Active device 3
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

If assembled with only the 4 disks with appropriate super blocks I get
`mdadm --detail /dev/md0`
/dev/md0:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 4
       Persistence : Superblock is persistent
             State : inactive
   Working Devices : 4
     Delta Devices : 4, (-4->0)
         New Level : raid6
        New Layout : left-symmetric
     New Chunksize : 512K
              Name : any:0
              UUID : a6914f4a:14a64337:c3546c24:42930ff9
            Events : 146894
    Number   Major   Minor   RaidDevice
       -     253        7        -        /dev/dm-7
       -     253        5        -        /dev/dm-5
       -     253        6        -        /dev/dm-6
       -     253        4        -        /dev/dm-4
