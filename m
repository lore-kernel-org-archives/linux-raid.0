Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EFFC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 12:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1765A61AA7
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 12:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbhKQM0J (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Nov 2021 07:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhKQM0I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 Nov 2021 07:26:08 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3347EC061570
        for <linux-raid@vger.kernel.org>; Wed, 17 Nov 2021 04:23:10 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y12so10155521eda.12
        for <linux-raid@vger.kernel.org>; Wed, 17 Nov 2021 04:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=IY/j7CSJhwpqGk4C1A0P/0DSKuN/W0GAifp3QN4NFUE=;
        b=DADRnhlhjUsleiNrUgWHxsooyZFHbfg2MqmsEKx0lTsVwKTt69Rreu3id0CVoKXokQ
         a5r7cdwuXIs8XznN9zsus5MfwmIxBaZ4oZhnOvSksY9d/8m9nPH9U66iT8gzIjxNnIN1
         OttICIkBIm0mWuLTPHTnY1QhH+FiteKkoUR8MaKPJ1q2j3u6dDaBD+9BSQB878rXXfYg
         E+9BmVG0iDelIYQ7ytVCU9Kq+amw56/x0/BIEma7axX6u6kntru90eam9JQUiE3sh99d
         W08/tn4NE3yWn/PZm4o3vkBl3IqffMbkPuBDM5p8Le0xbvIXearypgQIlulnkHYzVxM1
         Ihzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IY/j7CSJhwpqGk4C1A0P/0DSKuN/W0GAifp3QN4NFUE=;
        b=n/Yh4DIrrGmRf3zFQaEBT8qRYy3r9EuI6l7FzO41ddXcCZblqZfCHQ3J1Q0uIpSkrj
         HT4V1aMWFslDbTZc5ljr6vIh7C2+u35elOPyeC+UAeZ+hzMPHx7HwU7NqK4P7rLJWhqn
         4VdGVA1qpV7BKZgYoT8PntVAMloqmLRiFYIOWGnct1TWtPIC0/f/PBF7dAWAMb7Av8L2
         I3hHdGNcP+93UaSthjqq3+xXeLE/P2NuRETebn6+T8RTkTWn1CP0KvDxZ+HU0hBO3mgK
         NF92dwoztzNWomBX/JILix2tw6zv518iBItgiuegyNWC797Ohg/rL4A85ZgEDMo986YX
         801g==
X-Gm-Message-State: AOAM5308kidTe2yCVh44z7Z0CKCdnzWoShTZGjtrJ1Kkw6XtyxUJDBOy
        2+Pj+WLJd4xRUP+fIwVzeBY/Nam64CcChs+9QcTaTyrL7Q==
X-Google-Smtp-Source: ABdhPJy5JNwJQFccxyLr8T4wQu2wYRo/K/DgxPgjzR9qJyyhQCC+6qXVzw4AoTvjqeyZxS+3F+erpH1UgLeU9wugpuc=
X-Received: by 2002:a05:6402:524b:: with SMTP id t11mr22492355edd.98.1637151788363;
 Wed, 17 Nov 2021 04:23:08 -0800 (PST)
MIME-Version: 1.0
From:   Martin Thoma <thomamartin1985@googlemail.com>
Date:   Wed, 17 Nov 2021 13:22:56 +0100
Message-ID: <CAFPgooeJrvrNQcOQXUD82oc52rgB3DvH=JFzDVDMnfc+gs7nDg@mail.gmail.com>
Subject: Failed Raid 5 - one Disk possibly Out of date - 2nd disk damaged
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi All,

i have a Raid 5 with 6 - 3 TB Devices. After a powerfailure raid
didn't assemble automaticcaly so i force assembled it with

mdadm --assemble --force --verbose /dev/md0 /dev/sd[abcdej]1

root@nas:~# mdadm --assemble --force --verbose /dev/md0 /dev/sd[abcdej]1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdj1 is identified as a member of /dev/md0, slot 1.
mdadm: forcing event count in /dev/sde1(3) from 101607 upto 101616
mdadm: forcing event count in /dev/sdc1(4) from 101607 upto 101616
mdadm: forcing event count in /dev/sdb1(5) from 101607 upto 101616
mdadm: clearing FAULTY flag for device 4 in /dev/md0 for /dev/sde1
mdadm: clearing FAULTY flag for device 2 in /dev/md0 for /dev/sdc1
mdadm: clearing FAULTY flag for device 1 in /dev/md0 for /dev/sdb1
mdadm: Marking array /dev/md0 as 'clean'
mdadm: added /dev/sdd1 to /dev/md0 as 0 (possibly out of date)
mdadm: added /dev/sda1 to /dev/md0 as 2
mdadm: added /dev/sde1 to /dev/md0 as 3
mdadm: added /dev/sdc1 to /dev/md0 as 4
mdadm: added /dev/sdb1 to /dev/md0 as 5
mdadm: added /dev/sdj1 to /dev/md0 as 1
mdadm: /dev/md0 assembled from 5 drives - not enough to start the array.

So /dev/sdd1 was considered , when i ran the command again the raid
assembled without sdd1

When i tried Reading Data after a while it stopped (propably when the
data was on /dev/sdc

dmesg showed this:
[  368.433658] sd 8:0:0:1: [sdc] tag#0 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  368.433664] sd 8:0:0:1: [sdc] tag#0 Sense Key : Medium Error [current]
[  368.433669] sd 8:0:0:1: [sdc] tag#0 Add. Sense: Unrecovered read error
[  368.433675] sd 8:0:0:1: [sdc] tag#0 CDB: Read(16) 88 00 00 00 00 00
00 08 81 d8 00 00 00 08 00 00
[  368.433679] blk_update_request: critical medium error, dev sdc, sector 557528
[  368.433689] raid5_end_read_request: 77 callbacks suppressed
[  368.433692] md/raid:md0: read error not correctable (sector 555480 on sdc1).
[  375.944254] sd 8:0:0:1: [sdc] tag#0 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE

and the Raided stopped again.

How can i force to assemble the raid including /dev/sdd1 and not
include /dev/sdc (because that drive is possibly damaged now)?
With a mdadm --create --assume-clean .. command?

I'm using  mdadm/zesty-updates,now 3.4-4ubuntu0.1 amd64 [installed] on
Linux version 4.10.0-21-generic (buildd@lgw01-12) (gcc version 6.3.0
20170406 (Ubuntu 6.3.0-12ubuntu2) )

Regards and thanks in advance

Few other Ouputs:
mdadm --examine /dev/sd[abcdej]1 |  egrep 'Event|/dev/sd'
/dev/sda1:
         Events : 101616
/dev/sdb1:
         Events : 101616
/dev/sdc1:
         Events : 101616
/dev/sdd1:
         Events : 101607
/dev/sde1:
         Events : 101616
/dev/sdj1:
         Events : 101616

 mdadm --examine /dev/sd[abcdej]1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 8f33f56c:efd27830:4ac273aa:94b79171
           Name : htpc:0
  Creation Time : Thu Jan 16 20:36:01 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 14650667520 (13971.97 GiB 15002.28 GB)
  Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1024 sectors
          State : clean
    Device UUID : e41b2a30:94a9fa78:9b8e021d:ddb50b84

    Update Time : Wed Nov 17 11:47:36 2021
       Checksum : 7f1551a8 - correct
         Events : 101616

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : .AA... ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 8f33f56c:efd27830:4ac273aa:94b79171
           Name : htpc:0
  Creation Time : Thu Jan 16 20:36:01 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 14650667520 (13971.97 GiB 15002.28 GB)
  Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1024 sectors
          State : clean
    Device UUID : d32f3e56:ab5c727d:53de3db9:e0bfadee

    Update Time : Wed Nov 17 11:47:19 2021
       Checksum : b08f725a - correct
         Events : 101616

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 8f33f56c:efd27830:4ac273aa:94b79171
           Name : htpc:0
  Creation Time : Thu Jan 16 20:36:01 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 14650667520 (13971.97 GiB 15002.28 GB)
  Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1024 sectors
          State : clean
    Device UUID : 23fc5428:02411e8f:ad843649:d8addbd0

    Update Time : Wed Nov 17 11:47:19 2021
       Checksum : 678b755 - correct
         Events : 101616

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x2
     Array UUID : 8f33f56c:efd27830:4ac273aa:94b79171
           Name : htpc:0
  Creation Time : Thu Jan 16 20:36:01 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 14650667520 (13971.97 GiB 15002.28 GB)
  Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
Recovery Offset : 0 sectors
   Unused Space : before=262056 sectors, after=1024 sectors
          State : clean
    Device UUID : 09baa98d:5456baf2:925a9555:5b650e7f

    Update Time : Wed Nov 17 11:47:19 2021
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 8a031835 - correct
         Events : 101607

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 8f33f56c:efd27830:4ac273aa:94b79171
           Name : htpc:0
  Creation Time : Thu Jan 16 20:36:01 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 14650667520 (13971.97 GiB 15002.28 GB)
  Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=1024 sectors
          State : clean
    Device UUID : bb060f08:741f38fd:6006b07e:f0a9c992

    Update Time : Wed Nov 17 11:47:19 2021
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 4bbc1e74 - correct
         Events : 101616

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 8f33f56c:efd27830:4ac273aa:94b79171
           Name : htpc:0
  Creation Time : Thu Jan 16 20:36:01 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 14650667520 (13971.97 GiB 15002.28 GB)
  Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1024 sectors
          State : clean
    Device UUID : d5227db1:d9bde1c4:7b0fe2f1:4eccbbf0

    Update Time : Wed Nov 17 11:47:36 2021
       Checksum : 8df1042c - correct
         Events : 101616

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : .AAAAA ('A' == active, '.' == missing, 'R' == replacing)
