Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FB3C43217
	for <linux-raid@archiver.kernel.org>; Mon, 28 Nov 2022 14:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiK1OY1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Nov 2022 09:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiK1OY0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Nov 2022 09:24:26 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA2A65F5
        for <linux-raid@vger.kernel.org>; Mon, 28 Nov 2022 06:24:25 -0800 (PST)
Received: from [73.207.192.158] (port=55536 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1ozf3Y-0004U6-HE
        for linux-raid@vger.kernel.org;
        Mon, 28 Nov 2022 08:24:24 -0600
Date:   Mon, 28 Nov 2022 14:24:22 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: md RAID0 can be grown (was "Re: how do i fix these RAID5 arrays?")
Message-ID: <20221128142422.GM19721@jpo>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
 <20221125132259.GG19721@jpo>
 <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
 <20221125194932.GK19721@jpo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125194932.GK19721@jpo>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www18.qth.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - justpickone.org
X-Get-Message-Sender-Via: www18.qth.com: authenticated_id: dmail@justpickone.org
X-Authenticated-Sender: www18.qth.com: dmail@justpickone.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, all --

...and then David T-G home said...
% 
% ...and then Roger Heflin said...
% % You may not be able to grow with either linear and/or raid0 under mdadm.
% 
...
% What do you think of
% 
%   mdadm -A --update=devicesize /dev/md50
% 
% as discussed in
% 
%   https://serverfault.com/questions/1068788/how-to-change-size-of-raid0-software-array-by-resizing-partition
% 
% recently?

It looks like this works.  Read on for more future plans, but here's how
growing worked out.

First, you'll recall, I added the new slices to each RAID5 array and then
fixed them so that they're all working again.  Thank you, everyone :-)

Second, all I had to do was stop the array and reassemble, and md noticed
like a champ.  Awesome!

  diskfarm:~ # mdadm -D /dev/md50
  /dev/md50:
  ...
          Raid Level : raid0
          Array Size : 19526301696 (18.19 TiB 19.99 TB)
  ...
  diskfarm:~ # mdadm -S /dev/md50
  mdadm: stopped /dev/md50
  diskfarm:~ # mdadm -A --update=devicesize /dev/md50
  mdadm: /dev/md50 has been started with 6 drives.
  diskfarm:~ # mdadm -D /dev/md50
  /dev/md50:
  ...
          Raid Level : raid0
          Array Size : 29289848832 (27.28 TiB 29.99 TB)
  ...

Next I had to resize the partition to use the more space now
available.

  diskfarm:~ # parted /dev/md50
  ...
  (parted) u s p free
  Model: Linux Software RAID Array (md)
  Disk /dev/md50: 58579697664s
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags:
  
  Number  Start         End           Size          File system  Name         Flags
          34s           6143s         6110s         Free Space
   1      6144s         39052597247s  39052591104s  xfs          10Traid50md
          39052597248s  58579697630s  19527100383s  Free Space
  
  (parted) rm 1
  (parted) mkpart pri xfs 6144s 100%
  (parted) name 1 10Traid50md
  (parted) p free
  Model: Linux Software RAID Array (md)
  Disk /dev/md50: 58579697664s
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags:
  
  Number  Start         End           Size          File system  Name         Flags
          34s           6143s         6110s         Free Space
   1      6144s         58579691519s  58579685376s  xfs          10Traid50md
          58579691520s  58579697630s  6111s         Free Space
  
  (parted) q
  
  diskfarm:~ # parted /dev/md50 p free
  Model: Linux Software RAID Array (md)
  Disk /dev/md50: 30.0TB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags:
  
  Number  Start   End     Size    File system  Name         Flags
          17.4kB  3146kB  3128kB  Free Space
   1      3146kB  30.0TB  30.0TB  xfs          10Traid50md
          30.0TB  30.0TB  3129kB  Free Space

Finally, I had to grow the XFS filesystem.  That was simple enough,
although it's supposed to be done with the volume mounted, which just
felt ... wrong :-)

  diskfarm:~ # df -kh /mnt/10Traid50md/
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/md50p1      19T   19T   95G 100% /mnt/10Traid50md
  diskfarm:~ # xfs_growfs -n /mnt/10Traid50md
  meta-data=/dev/md50p1            isize=512    agcount=32, agsize=152549248 blks
           =                       sectsz=4096  attr=2, projid32bit=1
           =                       crc=1        finobt=1, sparse=0, rmapbt=0
           =                       reflink=0
  data     =                       bsize=4096   blocks=4881573888, imaxpct=5
           =                       sunit=128    swidth=768 blks
  naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
  log      =internal log           bsize=4096   blocks=521728, version=2
           =                       sectsz=4096  sunit=1 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  diskfarm:~ # xfs_growfs /mnt/10Traid50md
  meta-data=/dev/md50p1            isize=512    agcount=32, agsize=152549248 blks
           =                       sectsz=4096  attr=2, projid32bit=1
           =                       crc=1        finobt=1, sparse=0, rmapbt=0
           =                       reflink=0
  data     =                       bsize=4096   blocks=4881573888, imaxpct=5
           =                       sunit=128    swidth=768 blks
  naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
  log      =internal log           bsize=4096   blocks=521728, version=2
           =                       sectsz=4096  sunit=1 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  data blocks changed from 4881573888 to 7322460672
  diskfarm:~ # df -kh /mnt/10Traid50md
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/md50p1      28T   19T  9.2T  67% /mnt/10Traid50md

Et voila, we have more free space.  Yay.

So this works in theory, but ... there's that linear question :-/


% 
...
% % so here is roughly how to do it (commands may not be exact)> and assuming
% % your devices are /dev/md5[0123]
% % 
% % PV == physical volume (a disk or md raid device generally).
% % VG == volume group (a group of PV).
% % LV == logical volume (a block device inside a vg made up of part of a PV or
% % several PVs).
% % 
% % pvcreate /dev/md5[0123]
% % vgcreate bigvg /dev/md5[0123]
% % lvcreate -L <size> -n mylv bigvg
[snip]

Thanks again, and I do plan to read up on LVM.  For now, though, I'm
thinkin' I'll rebuild under md in linear mode.  Stealing from my RAID10
subthread (where I owe similar tests), I tried pulling 128MiB to 8GiB of
data from a single RAID5 slice versus the big RAID0 stripe

  diskfarm:~ # for D in 52 50 ; do for C in 128 256 512 ; do for S in 1M 4M 16M ; do CMD="dd if=/dev/md$D of=/dev/null bs=$S count=$C iflag=direct" ; echo "## $CMD" ; $CMD 2>&1 | egrep -v records ; done ; done ; done
  ## dd if=/dev/md52 of=/dev/null bs=1M count=128 iflag=direct
  134217728 bytes (134 MB, 128 MiB) copied, 1.20121 s, 112 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=4M count=128 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 1.82563 s, 294 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=16M count=128 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 9.03782 s, 238 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=1M count=256 iflag=direct
  268435456 bytes (268 MB, 256 MiB) copied, 2.6694 s, 101 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=4M count=256 iflag=direct
  1073741824 bytes (1.1 GB, 1.0 GiB) copied, 3.72331 s, 288 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=16M count=256 iflag=direct
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 13.6094 s, 316 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=1M count=512 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 6.39903 s, 83.9 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=4M count=512 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 7.45123 s, 288 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=16M count=512 iflag=direct
  8589934592 bytes (8.6 GB, 8.0 GiB) copied, 28.1189 s, 305 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=1M count=128 iflag=direct
  134217728 bytes (134 MB, 128 MiB) copied, 3.74023 s, 35.9 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=4M count=128 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 9.96306 s, 53.9 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=16M count=128 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 19.994 s, 107 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=1M count=256 iflag=direct
  268435456 bytes (268 MB, 256 MiB) copied, 7.25855 s, 37.0 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=4M count=256 iflag=direct
  1073741824 bytes (1.1 GB, 1.0 GiB) copied, 18.9692 s, 56.6 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=16M count=256 iflag=direct
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 40.2443 s, 107 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=1M count=512 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 14.1076 s, 38.1 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=4M count=512 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 38.6795 s, 55.5 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=16M count=512 iflag=direct
  8589934592 bytes (8.6 GB, 8.0 GiB) copied, 81.4364 s, 105 MB/s

and as expected the difference

  RAID5 / RAID0 performance
  (speedup)
  
          1M        4M       16M
      +---------+---------+---------+
  128 | 112/036 | 294/054 | 238/107 |
      | (3.1)   | (5.4)   | (2.2)   |
      +---------+---------+---------+
  256 | 101/037 | 288/057 | 316/107 |
      | (2.7)   | (5.0)   | (3.0)   |
      +---------+---------+---------+
  512 | 084/038 | 288/056 | 305/105 |
      | (2.2)   | (5.1)   | (2.9)   |
      +---------+---------+---------+

is significant.  So, yeah, I'll be wiping and rebuilding md50 as a
straight linear.  Watch for more test results when that's done :-)
Fingers crossed that I get much better results; if not, maybe it'll
be time to switch to LVM after all.


Thanks again to all & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

