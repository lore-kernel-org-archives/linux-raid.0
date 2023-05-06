Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22BC4C7EE21
	for <linux-raid@archiver.kernel.org>; Sat,  6 May 2023 03:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjEFD3v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 May 2023 23:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEFD3u (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 May 2023 23:29:50 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DE449C6
        for <linux-raid@vger.kernel.org>; Fri,  5 May 2023 20:29:48 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4efe9a98736so2892191e87.1
        for <linux-raid@vger.kernel.org>; Fri, 05 May 2023 20:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683343786; x=1685935786;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fAQXNzCGmdkPMnBg41hRapZvkbuMr8hxhgSu68aQh8A=;
        b=AOb66HL8yAqp0J2RBEolydRN8D+gMyLlC8VixPYXq9VYHXqBE69R7J0+/xJS3e5kKZ
         7Kkwbq2TwVB973Qn4P8exEUo01fz33QxowzSfkXYFhsbdeRhTHJPiJpj8owsXwhxwOf7
         58gylyToBaBYn36gDlF0UtGqFF89K9Z11wBAtXHzOCod4d9zf1VzHubUIqU8/PJVqTKL
         STEL7+DVO0Bvtu4R29f/K2+pQGdTd2PgDndUD5ICTaJVTEHXeGU4Oni5Zr2XF322FCuS
         B3ZJtRYH/SxRK4R1WnJhZLinA+2VFCFD0szk7CP0XLYV6i22RT1fjTDNGoyz9Ov6lIxP
         4L8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683343786; x=1685935786;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fAQXNzCGmdkPMnBg41hRapZvkbuMr8hxhgSu68aQh8A=;
        b=I1yQOnG2Hjm+WzDUdAB38sC+C6xHEIxwR+Nt23B3KNS+Z+RvOfiz0W1NE6og12gwqd
         EAaPZyxqrbPCUPZeoFc5sOD//0H5+eo8cH8pgHUv3Efa29ECxOybTMyJY1FgSxMcRcIn
         +0/yS7uejKbK3icHTt/+BAN/nruSWcWb8OwBsNiDjX/zIO1ToJwYEoI7Ld7a6HLoXbI4
         dghyY+iLkSa/Cqt9WX24r/aBUjevybc4Ms4IGkpdTaqaoaaDuknkb4y0oNxcJoqkMfbl
         EUsH7xnS7Zh7jdLMjhuRSQ4B5m/E0XReUSbBGkgkRobDfQ/w5K+i5/lJtSdnGHbvc90H
         LnyQ==
X-Gm-Message-State: AC+VfDzA9Xo8r+rTw0eAVdgWp+lSpcwQ+9aEP6+nq67ZM5wiS4olfdZD
        IKrVp1OITJfTO4Np3R2srq9DtwnYMnqlij8S0Rq+AxrnY+c=
X-Google-Smtp-Source: ACHHUZ4Vvgaq58R2Jn+KZrokysEYj/2OSQ6x8UIqQwREVp0CqXPIKLFoqUs85PF7hFhIK0KfxfXC6ShvhYRfwoV8o2E=
X-Received: by 2002:ac2:551e:0:b0:4ed:bf88:ce8d with SMTP id
 j30-20020ac2551e000000b004edbf88ce8dmr964788lfk.36.1683343785631; Fri, 05 May
 2023 20:29:45 -0700 (PDT)
MIME-Version: 1.0
From:   David Gilmour <dgilmour76@gmail.com>
Date:   Fri, 5 May 2023 21:29:33 -0600
Message-ID: <CAO2ABipzbw6QL5eNa44CQHjiVa-LTvS696Mh9QaTw+qsUKFUCw@mail.gmail.com>
Subject: mdadm grow raid 5 to 6 failure (crash)
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all, after exhausting all other sources I could find online I have
come here in the hopes that someone may have some guidance that will
save my data. While I have an offsite backup of the most critical data
I definitely would prefer to find some \ ANY way to recover my array
to recover ALL my data.

Situation: I had a healthy raid 5 array made up of 5 - 8TB drives. I
had always wanted to increase redundancy by growing this to a raid 6
array. I finally decided to get another drive and kicked off the
process with the following commands

mdadm --add /dev/md127 /dev/sde #adding the 6th 8TB drive as a spare
mdadm --grow /dev/md127 --level=raid6 --raid-devices=6
--backup-file=/root/mdadm5-6_backup_md127

Reshape started and everything looked good but after about 10mins
something crashed and I started seeing messages about drives not
responding and the shape process slowly slowed down to 0kbps. I
rebooted and my drives would not assemble showing (ignore the changing
drive letters as they swap around on each reboot but I am verifying
the right disks are in play for each command):

Personalities : [raid1]
md127 : inactive sdh[1](S) sdg[3](S) sdb[5](S) sda[6](S) sdf[7](S) sdc[4](S)
      46883373072 blocks super 1.2
md1 : active raid1 sde3[0] sdd3[1]
      1919958912 blocks super 1.0 [2/2] [UU]
      bitmap: 5/15 pages [20KB], 65536KB chunk
md0 : active raid1 sde1[3] sdd1[2]
      1047488 blocks super 1.0 [2/2] [UU]

/dev/md127:
           Version : 1.2
        Raid Level : raid6
     Total Devices : 6
       Persistence : Superblock is persistent
             State : inactive
   Working Devices : 6
         New Level : raid6
        New Layout : left-symmetric
     New Chunksize : 512K
              Name : milhouse.wooky.org:0
              UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
            Events : 984922
    Number   Major   Minor   RaidDevice
       -       8       32        -        /dev/sdc
       -       8        0        -        /dev/sda
       -       8      112        -        /dev/sdh
       -       8       80        -        /dev/sdf
       -       8       16        -        /dev/sdb
       -       8       96        -        /dev/sdg

First thing I tried was stopping and restarting the array pointing to
the backup file I had on another partition with:

mdadm --stop /dev/md127
mdadm --assemble --verbose --backup-file /root/mdadm5-6_backup_md127
/dev/md127 /dev/sdc /dev/sda /dev/sdh /dev/sdf /dev/sdb /dev/sdg

But I get this fun error:
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdc is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sda is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdh is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sdf is identified as a member of /dev/md127, slot 5.
mdadm: /dev/sdb is identified as a member of /dev/md127, slot 4.
mdadm: /dev/sdg is identified as a member of /dev/md127, slot 2.
mdadm: /dev/md127 has an active reshape - checking if critical section
needs to be restored
mdadm: No backup metadata on /root/mdadm5-6_backup_md127
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.

Beyond that here is a list of things I have tried thus far :

mdadm --assemble --verbose --backup-file=/root/mdadm5-6_backup_md127
/dev/md127 /dev/sdc /dev/sda /dev/sdh /dev/sdf /dev/sdb /dev/sdg #with
and without the --force option
mdadm --assemble --verbose --invalid-backup
--backup-file=/root/mdadm5-6_backup_md127 /dev/md127 /dev/sdc /dev/sda
/dev/sdh /dev/sdf /dev/sdb /dev/sdg #with and without the --force
option

Oddly enough this command with the force option causes my system to hang

I created raid overlay files and tried just creating the array in
various ways, all of which assemble ok but none are mountable (bad fs,
superblock etc message)

Tried recreating as a raid 6 with the same parameters as the grow
(with and without the 6th 8TB that was originally added:

mdadm --create /dev/md127 --level=6 --chunk=512K --metadata=1.2
--layout left-symmetric --data-offset=262144s --raid-devices=6
/dev/mapper/sda /dev/mapper/sdh /dev/mapper/sdg /dev/mapper/sdc
/dev/mapper/sde --assume-clean --readonly
 mdadm --create /dev/md127 --level=6 --chunk=512K --metadata=1.2
--layout left-symmetric --data-offset=262144s --raid-devices=5
/dev/mapper/sda /dev/mapper/sdh /dev/mapper/sdg /dev/mapper/sdc
/dev/mapper/sde --assume-clean --readonly

Tried recreating the original raid 5 array with the 6th member removed

 mdadm --create /dev/md127 --level=5 --chunk=512K --metadata=1.2
--layout left-symmetric --data-offset=262144s --raid-devices=5
/dev/mapper/sdb /dev/mapper/sdh /dev/mapper/sdg /dev/mapper/sdc
/dev/mapper/sde --assume-clean --readonly


This is where I am at... one thing I am curious about is the various
array state messages in the following mdadm --examine output for each
of these drives. Some show "AAAAAA" and some (3) show drives missing
in array "A..AA.". Does it make sense to remove the ones the system
thinks are missing then re-add them to the array? Any risk to this? I
would imagine the assemble with the force option would of covered this
possibility but maybe I misunderstand something here.

# mdadm --examine /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
           Name : milhouse.wooky.org:0
  Creation Time : Thu Sep  7 03:12:27 2017
     Raid Level : raid6
   Raid Devices : 6
 Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
     Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
  Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : active
    Device UUID : 42809136:2f8a0b1d:d519e4cb:ffc4ebd8
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
     New Layout : left-symmetric
    Update Time : Mon May  1 04:48:57 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 31a0dcf6 - correct
         Events : 984922
         Layout : left-symmetric-6
     Chunk Size : 512K
   Device Role : Active device 3
   Array State : A..AA. ('A' == active, '.' == missing, 'R' == replacing)

# mdadm --examine /dev/sda
/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
           Name : milhouse.wooky.org:0
  Creation Time : Thu Sep  7 03:12:27 2017
     Raid Level : raid6
   Raid Devices : 6
 Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
     Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
  Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 49955753:d202b004:64d74e3f:56480d25
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
     New Layout : left-symmetric
    Update Time : Mon May  1 04:48:57 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : f59eab84 - correct
         Events : 984922
         Layout : left-symmetric-6
     Chunk Size : 512K
   Device Role : Active device 0
   Array State : AAAAA. ('A' == active, '.' == missing, 'R' == replacing)

# mdadm --examine /dev/sdh
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
           Name : milhouse.wooky.org:0
  Creation Time : Thu Sep  7 03:12:27 2017
     Raid Level : raid6
   Raid Devices : 6
 Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
     Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
  Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : active
    Device UUID : c915a45d:f2cc52ba:629dbf61:4c85efe6
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
     New Layout : left-symmetric
    Update Time : Mon May  1 04:47:53 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 99e7f8d4 - correct
         Events : 984922
         Layout : left-symmetric-6
     Chunk Size : 512K
   Device Role : Active device 1
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

# mdadm --examine /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x7
     Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
           Name : milhouse.wooky.org:0
  Creation Time : Thu Sep  7 03:12:27 2017
     Raid Level : raid6
   Raid Devices : 6
 Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
     Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
  Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
Recovery Offset : 8012800 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : active
    Device UUID : 75127e45:a31ad132:d8dba6bc:0282e2bc
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
     New Layout : left-symmetric
    Update Time : Mon May  1 04:47:53 2023
  Bad Block Log : 512 entries available at offset 40 sectors
       Checksum : 2b94c243 - correct
         Events : 984920
         Layout : left-symmetric-6
     Chunk Size : 512K
   Device Role : Active device 5
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

# mdadm --examine /dev/sdb
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
           Name : milhouse.wooky.org:0
  Creation Time : Thu Sep  7 03:12:27 2017
     Raid Level : raid6
   Raid Devices : 6
 Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
     Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
  Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : active
    Device UUID : 61265e10:8333498a:177ef638:617442f8
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
     New Layout : left-symmetric
    Update Time : Mon May  1 04:48:57 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 51446d6 - correct
         Events : 984922
         Layout : left-symmetric-6
     Chunk Size : 512K
   Device Role : Active device 4
   Array State : A..AA. ('A' == active, '.' == missing, 'R' == replacing)

# mdadm --examine /dev/sdg
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
           Name : milhouse.wooky.org:0
  Creation Time : Thu Sep  7 03:12:27 2017
     Raid Level : raid6
   Raid Devices : 6
 Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
     Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
  Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : active
    Device UUID : d064611f:a97d457f:141f9fcf:e6471bb8
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
     New Layout : left-symmetric
    Update Time : Mon May  1 04:47:53 2023
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 5fa33ce0 - correct
         Events : 984922
         Layout : left-symmetric-6
     Chunk Size : 512K
   Device Role : Active device 2
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
