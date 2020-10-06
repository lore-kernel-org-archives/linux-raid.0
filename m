Return-Path: <SRS0=H5I/=DN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93C2C4363D
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 11:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E7F62080A
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 11:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tddE2KL5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgJFLFx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Oct 2020 07:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFLFw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Oct 2020 07:05:52 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78950C061755
        for <linux-raid@vger.kernel.org>; Tue,  6 Oct 2020 04:05:52 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id 5so5869151vsu.5
        for <linux-raid@vger.kernel.org>; Tue, 06 Oct 2020 04:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=GeOaFZK2TNcdB6S4K8fB5udFpgZmL4mWZ8hWybPBrkE=;
        b=tddE2KL5YTJvlhcEWeMBz5Fy0cACm6y4T2/vJqspywwFZRGEHHFw/TupzpvBQGEkLr
         aSTWJsYFfsn6wNg1oJgCj14OJ/w8YFdePfJq/fj9vj4XYJ3G8LauenS405Msmpc/BsPF
         2jRuSiCqr/qm2x6eyfEfNLyPcx3LDdmIivfBa4Rmo16fUt65S23GGyaHpFo1qsWa4euN
         sZi+Looy4dNZ6sy6hg6aWKFy7Dq2IoL3EASyhV/HXqus4QTBR+Fk/kbfwmDaOS9jFUYV
         OeMFuEMhC2e4JmA0GNi+FsZdxe/HtE7BJ9qZjpo0tIWsFfPda3mIGfZ2ThdGsjf7oGt+
         DAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GeOaFZK2TNcdB6S4K8fB5udFpgZmL4mWZ8hWybPBrkE=;
        b=XpjS6wd1pvPSmDWwbaNF72GMcsxjxe5ipgwhYZSZP2vEe5CEUy96BeN0CzxY/3icPw
         fBcoBCuhu22Dg5ndySgwvSExNhhxZYjZ8Eu8PvncR/NlSMukCzEJ8oo93IUH/9CpDfEE
         z803LBF3KlyGXbirM0KApxjbGHCG4TZRAjNAxEH1sSi5gXBs9zAfHhFG93v6En43NoSI
         dIh+/CvppqqZHmDTLKU8TAPjopPUJ0BKITL8q6kVF5h88otcTEiCTbHJJ2DuNxAAr0R4
         HYSvtu7f/M61Oam46+TaMmbqQ2lixjUuFq/BJpQuBBlTedcZBb9dmaZBAldLkDSnSHhG
         Fv2w==
X-Gm-Message-State: AOAM531gFLLXgZP5A408JIeqkJNvzbPYjkTfsVxeGiAfaFWtz+ih7udm
        u902UqkUleOTg2opO5XyT+Z095+voQzpSizb49kSUUrO/7g=
X-Google-Smtp-Source: ABdhPJx2FQrpeAffV7rOCAmSg0pkiPlncM/y8fIs7A0TungkiFZRTUL5L6VFQyT5at4XGElypa22GIW6UHDr64fmdFs=
X-Received: by 2002:a67:2d83:: with SMTP id t125mr2889707vst.41.1601982351043;
 Tue, 06 Oct 2020 04:05:51 -0700 (PDT)
MIME-Version: 1.0
From:   Kenneth Emerson <kenneth.emerson@gmail.com>
Date:   Tue, 6 Oct 2020 06:05:40 -0500
Message-ID: <CADzwnhXJBRuCNPsGhPHt-h1J3MU2HmH3_ZWkxW_auJ7FQyqJ0w@mail.gmail.com>
Subject: Need Help with Corrupted RAID6 Array
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It's been several years since I asked and received help on this list.
Once again, I find myself in a bind.  I have accidentally destroyed
one of my disks in a set of 5 4-TB drives set as RAID6. When I
rebooted 2 of the three arrays rebuilt correctly; however, the third
(largest and most important) would not assemble.  I thought, even
though I had lost one drive, I could rebuild the array by substituting
a new, partitioned drive but I cannot get the array to start.

Can anyone help me out, please?

Regards,

Ken Emerson


This is what I see with mdstat:

Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid1 sdc1[2] sde1[4] sdd1[3] sdb1[1]
      292800 blocks [5/4] [_UUUU]

md1 : active raid1 sdc2[4] sde2[1] sdd2[3] sdb2[2]
      292968384 blocks [5/4] [_UUUU]

md3 : inactive sdc4[9](S) sde4[4](S) sdd4[2](S) sdb4[3](S)
      10532388320 blocks super 1.0

All four drives are marked as spare (sda4 is the missing/destroyed partition).

If I assemble and force it to run, the drives are no longer spare but
even with a --force, the array will not go active:

root@MythTV:/home/ken# mdadm --assemble --run /dev/md3
root@MythTV:/home/ken# cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid1 sdc1[2] sde1[4] sdd1[3] sdb1[1]
      292800 blocks [5/4] [_UUUU]

md1 : active raid1 sdc2[4] sde2[1] sdd2[3] sdb2[2]
      292968384 blocks [5/4] [_UUUU]

md3 : inactive sdc4[9] sde4[4] sdd4[2] sdb4[3]
      10532388320 blocks super 1.0


The examination of each of the sdx4 drives:


root@MythTV:/home/ken# mdadm --examine /dev/sdb4
/dev/sdb4:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 2f327db6:af6ce8e0:954fbaa8:10e20661
           Name : mythtv:3
  Creation Time : Sun Dec  4 12:17:39 2011
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 5266194160 (2511.12 GiB 2696.29 GB)
     Array Size : 13165485120 (12555.59 GiB 13481.46 GB)
  Used Dev Size : 5266194048 (2511.12 GiB 2696.29 GB)
   Super Offset : 5266194416 sectors
   Unused Space : before=0 sectors, after=368 sectors
          State : clean
    Device UUID : 1e3e196e:fa8efa79:9fd6479e:2fd419ca

    Update Time : Mon Oct  5 14:47:48 2020
       Checksum : b3bdbb19 - correct
         Events : 812437

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

root@MythTV:/home/ken# mdadm --examine /dev/sdc4
/dev/sdc4:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 2f327db6:af6ce8e0:954fbaa8:10e20661
           Name : mythtv:3
  Creation Time : Sun Dec  4 12:17:39 2011
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 5266194160 (2511.12 GiB 2696.29 GB)
     Array Size : 13165485120 (12555.59 GiB 13481.46 GB)
  Used Dev Size : 5266194048 (2511.12 GiB 2696.29 GB)
   Super Offset : 5266194416 sectors
   Unused Space : before=0 sectors, after=368 sectors
          State : clean
    Device UUID : b5b6951e:16fe5bd2:9dfc0cdc:5baa05f3

    Update Time : Mon Oct  5 14:47:48 2020
       Checksum : 234c9efd - correct
         Events : 812437

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

root@MythTV:/home/ken# mdadm --examine /dev/sdd4
/dev/sdd4:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 2f327db6:af6ce8e0:954fbaa8:10e20661
           Name : mythtv:3
  Creation Time : Sun Dec  4 12:17:39 2011
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 5266194160 (2511.12 GiB 2696.29 GB)
     Array Size : 13165485120 (12555.59 GiB 13481.46 GB)
  Used Dev Size : 5266194048 (2511.12 GiB 2696.29 GB)
   Super Offset : 5266194416 sectors
   Unused Space : before=0 sectors, after=368 sectors
          State : clean
    Device UUID : 242bd7e8:b11ca61d:664f7083:589eb9fa

    Update Time : Mon Oct  5 14:47:48 2020
       Checksum : e7ef78c5 - correct
         Events : 812437

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

root@MythTV:/home/ken# mdadm --examine /dev/sde4
/dev/sde4:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 2f327db6:af6ce8e0:954fbaa8:10e20661
           Name : mythtv:3
  Creation Time : Sun Dec  4 12:17:39 2011
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 5266194160 (2511.12 GiB 2696.29 GB)
     Array Size : 13165485120 (12555.59 GiB 13481.46 GB)
  Used Dev Size : 5266194048 (2511.12 GiB 2696.29 GB)
   Super Offset : 5266194416 sectors
   Unused Space : before=0 sectors, after=368 sectors
          State : clean
    Device UUID : 6e95b4b2:0da02e12:d79162ff:77337ed8

    Update Time : Mon Oct  5 14:47:48 2020
       Checksum : c3dfe - correct
         Events : 812437

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 4
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

The mdadm.conf file:

root@MythTV:/home/ken# cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, using
# wildcards if desired.
#DEVICE partitions containers

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md0 UUID=230f126b:0d2a4439:c44c77eb:7ee19756
   spares=1
ARRAY /dev/md1 UUID=90f0aede:03a99d2a:bd811544:edcdae81
   spares=1
ARRAY /dev/md/2 metadata=1.0 UUID=ca0e0cc2:de96d489:d07fd26c:685aef08
name=mythtv:2
   spares=1
ARRAY /dev/md/3 metadata=1.0 UUID=2f327db6:af6ce8e0:954fbaa8:10e20661
name=mythtv:3

# This file was auto-generated on Sun, 09 Mar 2014 11:12:49 -0500
# by mkconf $Id$
