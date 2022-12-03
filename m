Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF7FC352A1
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 05:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiLCFlt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 00:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiLCFls (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 00:41:48 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666CD7F884
        for <linux-raid@vger.kernel.org>; Fri,  2 Dec 2022 21:41:47 -0800 (PST)
Received: from [73.207.192.158] (port=34130 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1p1LHW-0004Bl-PM
        for linux-raid@vger.kernel.org;
        Fri, 02 Dec 2022 23:41:46 -0600
Date:   Sat, 3 Dec 2022 05:41:45 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: md RAID0 can be grown
Message-ID: <20221203054145.GQ19721@jpo>
Reply-To: Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
 <20221125132259.GG19721@jpo>
 <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
 <20221125194932.GK19721@jpo>
 <20221128142422.GM19721@jpo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128142422.GM19721@jpo>
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
...
%
% Thanks again, and I do plan to read up on LVM.  For now, though, I'm
% thinkin' I'll rebuild under md in linear mode.  Stealing from my RAID10

Rebuilding seems to have been straightforward.  Yay.

  diskfarm:~ # mdadm --verbose --create /dev/md50 --homehost=diskfarm --name=10Traid50md --level=linear --raid-devices=6 --symlinks=yes /dev/md/5[123456]
  mdadm: /dev/md/51 appears to be part of a raid array:
	 level=linear devices=6 ctime=Wed Nov 30 04:17:52 2022
  mdadm: /dev/md/52 appears to be part of a raid array:
	 level=linear devices=6 ctime=Wed Nov 30 04:17:52 2022
  mdadm: /dev/md/53 appears to be part of a raid array:
	 level=linear devices=6 ctime=Wed Nov 30 04:17:52 2022
  mdadm: /dev/md/54 appears to be part of a raid array:
	 level=linear devices=6 ctime=Wed Nov 30 04:17:52 2022
  mdadm: /dev/md/55 appears to be part of a raid array:
	 level=linear devices=6 ctime=Wed Nov 30 04:17:52 2022
  mdadm: /dev/md/56 appears to be part of a raid array:
	 level=linear devices=6 ctime=Wed Nov 30 04:17:52 2022
  Continue creating array? y
  mdadm: Defaulting to version 1.2 metadata
  mdadm: array /dev/md50 started.

  diskfarm:~ # mdadm -D /dev/md50
  /dev/md50:
	     Version : 1.2
       Creation Time : Wed Nov 30 04:20:11 2022
	  Raid Level : linear
	  Array Size : 29289848832 (27.28 TiB 29.99 TB)
	Raid Devices : 6
       Total Devices : 6
	 Persistence : Superblock is persistent

	 Update Time : Wed Nov 30 04:20:11 2022
	       State : clean
      Active Devices : 6
     Working Devices : 6
      Failed Devices : 0
       Spare Devices : 0

	    Rounding : 0K

  Consistency Policy : none

		Name : diskfarm:10Traid50md  (local to host diskfarm)
		UUID : f75bac01:29abcd5d:1d99ffb3:4654bf27
	      Events : 0

      Number   Major   Minor   RaidDevice State
	 0       9       51        0      active sync   /dev/md/51
	 1       9       52        1      active sync   /dev/md/52
	 2       9       53        2      active sync   /dev/md/53
	 3       9       54        3      active sync   /dev/md/54
	 4       9       55        4      active sync   /dev/md/55
	 5       9       56        5      active sync   /dev/md/56

Great so far.  The fun part is that apparently the partition table was still
valid:

  diskfarm:~ # parted /dev/md50
  GNU Parted 3.2
  Using /dev/md50
  Welcome to GNU Parted! Type 'help' to view a list of commands.
  (parted) p
  Model: Linux Software RAID Array (md)
  Disk /dev/md50: 30.0TB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags:
  															
  Number  Start   End     Size    File system  Name         Flags
   1      3146kB  30.0TB  30.0TB               10Traid50md

  (parted) q

The filesystem didn't still exist, though.  THAT would have been a huge
surprise :-)

  diskfarm:~ # mount /mnt/10Traid50md
  mount: /mnt/10Traid50md: can't find LABEL=10Traid50md.
  diskfarm:~ # ls -goh /dev/disk/by*/* | egrep '10T|md50'
  lrwxrwxrwx 1 10 Nov 30 04:18 /dev/disk/by-id/md-name-diskfarm:10Traid50 -> ../../md50
  lrwxrwxrwx 1 12 Nov 30 04:18 /dev/disk/by-id/md-name-diskfarm:10Traid50-part1 -> ../../md50p1
  lrwxrwxrwx 1 10 Nov 30 04:18 /dev/disk/by-id/md-uuid-3a6fa2d0:071dfffe:bf2e0884:ab29a3ac -> ../../md50
  lrwxrwxrwx 1 12 Nov 30 04:18 /dev/disk/by-id/md-uuid-3a6fa2d0:071dfffe:bf2e0884:ab29a3ac-part1 -> ../../md50p1
  lrwxrwxrwx 1 12 Nov  5 21:30 /dev/disk/by-label/10Tr50-vfat -> ../../sdk128
  lrwxrwxrwx 1 12 Nov  5 21:30 /dev/disk/by-label/10Tr50md-xfs -> ../../sdd128
  lrwxrwxrwx 1 12 Nov  5 21:30 /dev/disk/by-label/10Traid50md-ext3 -> ../../sdb128
  lrwxrwxrwx 1 12 Nov  5 21:30 /dev/disk/by-label/10Traid50md-reis -> ../../sdc128
  lrwxrwxrwx 1 10 Nov  5 21:30 /dev/disk/by-label/WD10Tusb3 -> ../../sdo1
  lrwxrwxrwx 1 10 Nov  5 21:30 /dev/disk/by-partlabel/WD10Tusb3 -> ../../sdo1

  diskfarm:~ # mkfs.xfs -L 10Traid50md /dev/md50p1
  meta-data=/dev/md50p1            isize=512    agcount=32, agsize=228827008 blks
	   =                       sectsz=4096  attr=2, projid32bit=1
	   =                       crc=1        finobt=1, sparse=0, rmapbt=0
	   =                       reflink=0
  data     =                       bsize=4096   blocks=7322460672, imaxpct=5
	   =                       sunit=128    swidth=384 blks
  naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
  log      =internal log           bsize=4096   blocks=521728, version=2
	   =                       sectsz=4096  sunit=1 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0

  diskfarm:~ # df -kh !$
  df -kh /mnt/10Traid50md
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/md50p1      28T   28G   28T   1% /mnt/10Traid50md

Then it was time to hurry up and copy content back from the external
disks to the array to guard against drive failure.  Fast forward a couple
of days ...

% subthread (where I owe similar tests), I tried pulling 128MiB to 8GiB of
% data from a single RAID5 slice versus the big RAID0 stripe
%
%   diskfarm:~ # for D in 52 50 ; do for C in 128 256 512 ; do for S in 1M 4M 16M ; do CMD="dd if=/dev/md$D of=/dev/null bs=$S count=$C iflag=direct" ; echo "## $CMD" ; $CMD 2>&1 | egrep -v records ; done ; done ; done
%   ## dd if=/dev/md52 of=/dev/null bs=1M count=128 iflag=direct
%   134217728 bytes (134 MB, 128 MiB) copied, 1.20121 s, 112 MB/s
%   ## dd if=/dev/md52 of=/dev/null bs=4M count=128 iflag=direct
%   536870912 bytes (537 MB, 512 MiB) copied, 1.82563 s, 294 MB/s
%   ## dd if=/dev/md52 of=/dev/null bs=16M count=128 iflag=direct
%   2147483648 bytes (2.1 GB, 2.0 GiB) copied, 9.03782 s, 238 MB/s
%   ## dd if=/dev/md52 of=/dev/null bs=1M count=256 iflag=direct
%   268435456 bytes (268 MB, 256 MiB) copied, 2.6694 s, 101 MB/s
%   ## dd if=/dev/md52 of=/dev/null bs=4M count=256 iflag=direct
%   1073741824 bytes (1.1 GB, 1.0 GiB) copied, 3.72331 s, 288 MB/s
%   ## dd if=/dev/md52 of=/dev/null bs=16M count=256 iflag=direct
%   4294967296 bytes (4.3 GB, 4.0 GiB) copied, 13.6094 s, 316 MB/s
%   ## dd if=/dev/md52 of=/dev/null bs=1M count=512 iflag=direct
%   536870912 bytes (537 MB, 512 MiB) copied, 6.39903 s, 83.9 MB/s
%   ## dd if=/dev/md52 of=/dev/null bs=4M count=512 iflag=direct
%   2147483648 bytes (2.1 GB, 2.0 GiB) copied, 7.45123 s, 288 MB/s
%   ## dd if=/dev/md52 of=/dev/null bs=16M count=512 iflag=direct
%   8589934592 bytes (8.6 GB, 8.0 GiB) copied, 28.1189 s, 305 MB/s
%   ## dd if=/dev/md50 of=/dev/null bs=1M count=128 iflag=direct
%   134217728 bytes (134 MB, 128 MiB) copied, 3.74023 s, 35.9 MB/s
%   ## dd if=/dev/md50 of=/dev/null bs=4M count=128 iflag=direct
%   536870912 bytes (537 MB, 512 MiB) copied, 9.96306 s, 53.9 MB/s
%   ## dd if=/dev/md50 of=/dev/null bs=16M count=128 iflag=direct
%   2147483648 bytes (2.1 GB, 2.0 GiB) copied, 19.994 s, 107 MB/s
%   ## dd if=/dev/md50 of=/dev/null bs=1M count=256 iflag=direct
%   268435456 bytes (268 MB, 256 MiB) copied, 7.25855 s, 37.0 MB/s
%   ## dd if=/dev/md50 of=/dev/null bs=4M count=256 iflag=direct
%   1073741824 bytes (1.1 GB, 1.0 GiB) copied, 18.9692 s, 56.6 MB/s
%   ## dd if=/dev/md50 of=/dev/null bs=16M count=256 iflag=direct
%   4294967296 bytes (4.3 GB, 4.0 GiB) copied, 40.2443 s, 107 MB/s
%   ## dd if=/dev/md50 of=/dev/null bs=1M count=512 iflag=direct
%   536870912 bytes (537 MB, 512 MiB) copied, 14.1076 s, 38.1 MB/s
%   ## dd if=/dev/md50 of=/dev/null bs=4M count=512 iflag=direct
%   2147483648 bytes (2.1 GB, 2.0 GiB) copied, 38.6795 s, 55.5 MB/s
%   ## dd if=/dev/md50 of=/dev/null bs=16M count=512 iflag=direct
%   8589934592 bytes (8.6 GB, 8.0 GiB) copied, 81.4364 s, 105 MB/s

Time to run dd tests.  Curiously, my md52 performance changed, in some
cases significantly!  What gives?!?

  diskfarm:~ # for D in 52 50 ; do for C in 128 256 512 ; do for S in 1M 4M 16M ; do CMD="dd if=/dev/md$D of=/dev/null bs=$S count=$C iflag=direct" ; echo "## $CMD" ; $CMD 2>&1 | egrep -v records ; done ; done ; done
  ## dd if=/dev/md52 of=/dev/null bs=1M count=128 iflag=direct
  134217728 bytes (134 MB, 128 MiB) copied, 2.37693 s, 56.5 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=4M count=128 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 1.72798 s, 311 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=16M count=128 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 6.6545 s, 323 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=1M count=256 iflag=direct
  268435456 bytes (268 MB, 256 MiB) copied, 2.45847 s, 109 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=4M count=256 iflag=direct
  1073741824 bytes (1.1 GB, 1.0 GiB) copied, 3.1646 s, 339 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=16M count=256 iflag=direct
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 14.8199 s, 290 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=1M count=512 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 4.32777 s, 124 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=4M count=512 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 8.55706 s, 251 MB/s
  ## dd if=/dev/md52 of=/dev/null bs=16M count=512 iflag=direct
  8589934592 bytes (8.6 GB, 8.0 GiB) copied, 31.9199 s, 269 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=1M count=128 iflag=direct
  134217728 bytes (134 MB, 128 MiB) copied, 0.718462 s, 187 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=4M count=128 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 1.48336 s, 362 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=16M count=128 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 6.07036 s, 354 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=1M count=256 iflag=direct
  268435456 bytes (268 MB, 256 MiB) copied, 1.28401 s, 209 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=4M count=256 iflag=direct
  1073741824 bytes (1.1 GB, 1.0 GiB) copied, 3.07217 s, 350 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=16M count=256 iflag=direct
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 11.4026 s, 377 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=1M count=512 iflag=direct
  536870912 bytes (537 MB, 512 MiB) copied, 2.7174 s, 198 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=4M count=512 iflag=direct
  2147483648 bytes (2.1 GB, 2.0 GiB) copied, 6.22232 s, 345 MB/s
  ## dd if=/dev/md50 of=/dev/null bs=16M count=512 iflag=direct
  8589934592 bytes (8.6 GB, 8.0 GiB) copied, 22.6482 s, 379 MB/s

I didn't alter anything in the RAID5 arrays; I only deleted the striped
RAID0 and created a linear RAID0 the same way.  Although I was in normal
multi-user mode for the tests, the system was basically quiet ...


%
% and as expected the difference
%
%   RAID5 / RAID0 performance
%   (speedup)
%
%           1M        4M       16M
%       +---------+---------+---------+
%   128 | 112/036 | 294/054 | 238/107 |
%       | (3.1)   | (5.4)   | (2.2)   |
%       +---------+---------+---------+
%   256 | 101/037 | 288/057 | 316/107 |
%       | (2.7)   | (5.0)   | (3.0)   |
%       +---------+---------+---------+
%   512 | 084/038 | 288/056 | 305/105 |
%       | (2.2)   | (5.1)   | (2.9)   |
%       +---------+---------+---------+

The new chart

  RAID5 / RAID0 performance
  (speedup)

          1M        4M       16M
      +---------+---------+---------+
  128 |  57/187 | 311/362 | 323/354 |
      | (.32)   | (.85)   | (.91)   |
      +---------+---------+---------+
  256 | 109/209 | 339/350 | 290/377 |
      | (.52)   | (.96)   | (.76)   |
      +---------+---------+---------+
  512 | 124/198 | 251/345 | 269/379 |
      | (.62)   | (.72)   | (.70)   |
      +---------+---------+---------+

shows happier results (reading from the RAID0 is *faster* than from a
RAID5), but I don't know how much I trust the results, not least because
they're all over the place nor because it shouldn't be possible to speed
up faster than reading straight from the RAID5 slice.


%
% is significant.  So, yeah, I'll be wiping and rebuilding md50 as a
% straight linear.  Watch for more test results when that's done :-)

Ta daaaa!  And it may all be meaningless *sigh*


% Fingers crossed that I get much better results; if not, maybe it'll
% be time to switch to LVM after all.

Still planning to read ... :-)


Thanks again & HANN

:-D
--
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

