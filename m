Received: from www18.qth.com (www18.qth.com [69.16.238.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBC1231C96
	for <linux-raid@vger.kernel.org>; Sat,  5 Oct 2024 01:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=69.16.238.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728092980; cv=none; b=Xqoc4k3eYv8h9ry6h1yrVqsOKMuknO/MR8wha8I7Hva27F455/SB1NnJubrycyxrvSaGdnwkA/tRWxdkrMajvY1fXA5EWO00qBADJhi0r90fePbNgCpfTHoBwbQoYalSrrJjKkusE/tX36fTchdtOJKpXtcOtLgXfcB/m4pecgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728092980; c=relaxed/simple;
	bh=GG9Rv3XA60dZ1hVbN57Y0P6n/33iTWepziaSu4BJZ3E=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FP62bu2D+BqOZ7S9C4Gp+B331tCgwEy5eAE5EAzvGsufZccTujHSSkRPvwHTuEDbWslh/P/hffQU/A+VGJ6DVTb4LXnrmO7AyGQrQhJSlG2H7fOSqV/p7w4gSD9cU9uu/9tsd7B1cpOxNEPs6Mly86fzUrGaEqy74NrCzNsnx7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=justpickone.org; spf=pass smtp.mailfrom=justpickone.org; arc=none smtp.client-ip=69.16.238.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=justpickone.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justpickone.org
Received: from [73.207.192.158] (port=53288 helo=jpo)
	by www18.qth.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <davidtg-robot@justpickone.org>)
	id 1swtgW-00000003k9P-2iPS
	for linux-raid@vger.kernel.org;
	Fri, 04 Oct 2024 20:34:13 -0500
Date: Sat, 5 Oct 2024 01:34:11 +0000
From: David T-G <davidtg-robot@justpickone.org>
To: Linux RAID list <linux-raid@vger.kernel.org>
Subject: is this grown raid5 array using all of [each of] the disks?
Message-ID: <20241005013411.GZ27882@jpo>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Hi, all --

I finally have a chance to circle back around to this and see if my
Raid-5 arrays are actually using all of the 6ea slices given to them
after a grow operation.  I kinda think they aren't :-( I've grown these
successfully before, and this looks like it's happy, but ... it isn't
convincing :-)/2

Here is the info for md53, one of 6 arrays that are striped together to
create md50, the large array with the filesystem.


  diskfarm:~ # head -8 /proc/mdstat
  Personalities : [raid1] [raid6] [raid5] [raid4] [linear]
  md53 : active raid5 sdb53[0] sdf53[5] sdk53[6] sdl53[4] sdd53[3] sdc53[7]
        8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
        bitmap: 0/13 pages [0KB], 65536KB chunk
  
  md50 : active linear md53[2] md56[5] md51[0] md55[4] md52[1] md54[3]
        29289848832 blocks super 1.2 0k rounding
  

  diskfarm:~ # mdadm -Q /dev/md53
  /dev/md53: 7.58TiB raid5 6 devices, 0 spares. Use mdadm --detail for more detail.
  /dev/md53: device 2 in 6 device active linear /dev/md/50.  Use mdadm --examine for more detail.
  

  diskfarm:~ # mdadm -D /dev/md53
  /dev/md53: 
             Version : 1.2
       Creation Time : Thu Nov  4 00:47:09 2021
          Raid Level : raid5
          Array Size : 8136309760 (7.58 TiB 8.33 TB)
       Used Dev Size : 1627261952 (1551.88 GiB 1666.32 GB)
        Raid Devices : 6
       Total Devices : 6
         Persistence : Superblock is persistent
  
       Intent Bitmap : Internal
  
         Update Time : Sat Oct  5 01:01:47 2024
               State : clean
      Active Devices : 6
     Working Devices : 6
      Failed Devices : 0
       Spare Devices : 0
  
              Layout : left-symmetric
          Chunk Size : 512K
  
  Consistency Policy : bitmap
  
                Name : diskfarm:53  (local to host diskfarm)
                UUID : b2cb87a1:bdf1adc5:e915ada9:1ce428ec
              Events : 62760
  
      Number   Major   Minor   RaidDevice State
         0     259        4        0      active sync   /dev/sdb53
         7     259       11        1      active sync   /dev/sdc53
         3     259       18        2      active sync   /dev/sdd53
         4     259       41        3      active sync   /dev/sdl53
         6     259       33        4      active sync   /dev/sdk53
         5     259       25        5      active sync   /dev/sdf53
  

  diskfarm:~ # mdadm -E /dev/md53
  /dev/md53:
            Magic : a92b4efc
          Version : 1.2
      Feature Map : 0x0
       Array UUID : f75bac01:29abcd5d:1d99ffb3:4654bf27
             Name : diskfarm:10Traid50md  (local to host diskfarm)
    Creation Time : Wed Nov 30 04:20:11 2022
       Raid Level : linear
     Raid Devices : 6
  
   Avail Dev Size : 9763282944 sectors (4.55 TiB 5.00 TB)
    Used Dev Size : 0 sectors
      Data Offset : 264192 sectors
     Super Offset : 8 sectors
     Unused Space : before=264112 sectors, after=6509072384 sectors
            State : clean
      Device UUID : 79cae87d:0eedaca5:584179b2:11f58388
  
      Update Time : Wed Nov 30 04:20:11 2022
    Bad Block Log : 512 entries available at offset 8 sectors
         Checksum : 45f65bb8 - correct
           Events : 0
  
         Rounding : 0K
  
     Device Role : Active device 2
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

Here also is the info for a single disk as a sample:

  diskfarm:~ # parted /dev/sdb u GiB p free
  Model: ATA TOSHIBA HDWR11A (scsi)
  Disk /dev/sdb: 9314GiB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags: 
  
  Number  Start    End      Size     File system  Name                  Flags
          0.00GiB  0.00GiB  0.00GiB  Free Space
  51      0.00GiB  1552GiB  1552GiB               Raid5-1               lvm
  52      1552GiB  3104GiB  1552GiB               Raid5-2               lvm
  53      3104GiB  4656GiB  1552GiB               Raid5-3               lvm
  54      4656GiB  6208GiB  1552GiB               Raid5-4               lvm
  55      6208GiB  7760GiB  1552GiB               Raid5-5               lvm
  56      7760GiB  9312GiB  1552GiB               Raid5-6               lvm
  128     9312GiB  9314GiB  2.00GiB  ext3         ToshA000-HQFBKG-ext3
  
  diskfarm:~ # 

In the end, md50 is only 23T

  diskfarm:~ # parted /dev/md50 u TiB p free
  Model: Linux Software RAID Array (md)
  Disk /dev/md50: 27.3TiB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags: 
  
  Number  Start    End      Size     File system  Name         Flags
	  0.00TiB  0.00TiB  0.00TiB  Free Space
   1      0.00TiB  27.3TiB  27.3TiB  xfs          10Traid50md
	  27.3TiB  27.3TiB  0.00TiB  Free Space
  
  diskfarm:~ # 

and not the ~46T I expect and so I'm stuck.

I see that md53 is arrayed across sd{b,c,d,l,k,f}53 and is 7.58TiB,
which is good (1552GiB * 5 = 7760GiB = 7.57TiB).  The "Avail Devi Size"
is only 4.55TiB, and since 1552 * 3 = 4656 (+ 1 for RAID), it feels
like we have only 4 of the 6 devs actually being used.  Or are they
all being used but incompletely and the --grow operation didn't work?
I just am not confident I'm parsing the output correctly to know where
to go next.

Coaching, tips, and instruction welcomed :-)


Thanks in advance & have a great weekend!

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

