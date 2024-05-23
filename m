Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C31013B7AC
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 11:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716464873; cv=none; b=Tp1c3qDth2MmMjzPNPf57g4djUATqWNoetInV0DHYtG87jpoqMpGEfLEhtMAQu9iDEbj5eO2aQ8EJrNmYLmsFne6NIWoMHoTZlYuDSikG1xheT5l7Yj89zXPzfYeZ6znetxpVM959f5hpSf38nFGmdw1+0lTL5EMPZEduGtgArM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716464873; c=relaxed/simple;
	bh=cv2U1k/JzbAO+FLBb1790UelKGbbvO+UCptBPdlghuU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZsfN9J2ptsZxrRNpjcOeTO+uFirYqVm8NQvTt8g1GpqOqLwaQQbZRtTAvV+CA+GzrcSDmApgexxeOOPXnWHLTHtaFqmYzrdUzcrOkacoOMYQLqI5D8a+vIaL3VJ7waMCQsP70a7xCMoUVTlBSSIksPPixzCOPHYCC7Tj37hodE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=radoeka.nl; spf=fail smtp.mailfrom=radoeka.nl; dkim=pass (1024-bit key) header.d=kpnmail.nl header.i=@kpnmail.nl header.b=MX2gt/Z4; arc=none smtp.client-ip=195.121.94.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=radoeka.nl
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=radoeka.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kpnmail.nl header.i=@kpnmail.nl header.b="MX2gt/Z4"
X-KPN-MessageId: 45a46e53-18fa-11ef-9240-005056999439
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 45a46e53-18fa-11ef-9240-005056999439;
	Thu, 23 May 2024 13:47:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kpnmail.nl; s=kpnmail01;
	h=content-type:mime-version:message-id:date:subject:to:from;
	bh=99MPxm5JXeL9WPn7gl6aoW7/dnx/8NC7pFOcqflDQGU=;
	b=MX2gt/Z4ga6Ar+vomOWbJ9oZsLYkNyQZoIxJtBwkQCP9OoltwU6py5HoLwr4TXFgL90DLHisTNuis
	 l/DmBMBbRWUX1D4SP22HOYGPaXlC2nOx9DpeAsaIXbSYdrXVTxQWhGuHK7mEIMuRq8V2jHZIaYR4Bt
	 b7vAxiFN0FY+Auc8=
X-KPN-MID: 33|FknX25hIMcyZuqw0Sd+ENLo1J0tRrYaPOI7ZuTXAdAmM59GdavTP0ZKsugBab0e
 nhn6RSlZIR35S1vsZxdieOmxmOC4zcDa/ac8Z3ArytEw=
X-KPN-VerifiedSender: No
X-CMASSUN: 33|v/m4MYtnY//864k7VnnWarrlGXySin1MRiSAqbVk5pnF5m/xJgEgaCX5o4HOObP
 94UStrXTnJoMf9BjZ+OoX1A==
Received: from selene.localnet (80-60-179-152.fixed.kpn.net [80.60.179.152])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 46398c9f-18fa-11ef-8b48-00505699b758;
	Thu, 23 May 2024 13:47:47 +0200 (CEST)
From: Richard <richard@radoeka.nl>
To: linux-raid@vger.kernel.org
Subject: RAID-1 not accessible after disk replacement
Date: Thu, 23 May 2024 13:47:47 +0200
Message-ID: <1910147.LkxdtWsSYb@selene>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hello,

I was reference to this mailinglist via the https://raid.wiki.kernel.org/
index.php/RAID_Recovery page, "Make sure to contact someone who's experienced 
in dealing with md RAID problems and failures - either someone you know in 
person, or, alternatively, the friendly and helpful folk linux-raid mailing 
list".


As I've a problem with an RAID-1 array after replacing a failed disk, I hope 
that you can help me to make it at least readable again.



Information about the RAID:

/dev/sda3 is the disk partition that has the data on it.
/dev/sdb6 is the new disk partition - no data on it.


Information of the involved RAID before the disk replacement:

/dev/md126:
           Version : 1.0
     Creation Time : Sat Apr 29 20:30:27 2017
        Raid Level : raid1
        Array Size : 247464768 (236.00 GiB 253.40 GB)
     Used Dev Size : 247464768 (236.00 GiB 253.40 GB)

I grew (--grow) the RAID to an smaller size as it was complaining about the 
size (no logging of that).
After the this action the RAID was functioning and fully accessible.

After reboot the RAID is not accessible anymore.

The actual data on the RAID is about 37GB.

After reboot it became md125.

[   23.872267] md/raid1:md125: active with 1 out of 2 mirrors
[   23.903300] md125: detected capacity change from 0 to 488636416
2024-05-23T12:13:29.708106+02:00 cloud kernel: [  632.338266][ T2913] EXT4-fs 
(md125): bad geometry: block count 6186598
4 exceeds size of device (61079552 blocks)


# mount /dev/md125 /srv
mount: /srv: wrong fs type, bad option, bad superblock on /dev/md125, missing 
codepage or helper program, or other error

# LANG=C fsck /dev/md125
fsck from util-linux 2.37.4
e2fsck 1.46.4 (18-Aug-2021)
The filesystem size (according to the superblock) is 61865984 blocks
The physical size of the device is 61079552 blocks
Either the superblock or the partition table is likely to be corrupt!

# cat /proc/mdstat
md125 : active raid1 sda3[2]
     244318208 blocks super 1.0 [2/1] [U_]
     bitmap: 1/2 pages [4KB], 65536KB chunk
mdadm --detail /dev/md125
/dev/md125:
          Version : 1.0
    Creation Time : Sat Apr 29 20:30:27 2017
       Raid Level : raid1
       Array Size : 244318208 (233.00 GiB 250.18 GB)
    Used Dev Size : 244318208 (233.00 GiB 250.18 GB)
     Raid Devices : 2
    Total Devices : 1
      Persistence : Superblock is persistent

    Intent Bitmap : Internal

      Update Time : Mon May 20 18:40:03 2024
            State : clean, degraded  
   Active Devices : 1
  Working Devices : 1
   Failed Devices : 0
    Spare Devices : 0

Consistency Policy : bitmap

             Name : any:srv
             UUID : d96112c1:4c249022:96b4488c:642e84a6
           Events : 576774

   Number   Major   Minor   RaidDevice State
      2       8        3        0      active sync   /dev/sda3
      -       0        0        1      removed

# LANG=C fdisk -l /dev/sda
Disk /dev/sda: 465.76 GiB, 500107862016 bytes, 976773168 sectors 
Disk model: WDC WD5000LPCX-2
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0xc28b197d
Apparaat   Op.     Begin     Einde  Sectoren Grootte ID Type 
/dev/sda3       46139392 891291647 845152256    403G fd Linux raidautodetectie


# LANG=C fdisk -l /dev/sdb
Disk /dev/sdb: 298.09 GiB, 320072933376 bytes, 625142448 sectors 
Disk model: WDC WD3200BUCT-6
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x975182e6
Device     Boot     Start       End   Sectors   Size Id Type 
/dev/sdb6       136321024 625142447 488821424 233.1G fd Linux raid autodetect

# mdadm --examine /dev/sda3
/dev/sda3:
         Magic : a92b4efc
       Version : 1.0
   Feature Map : 0x1
    Array UUID : d96112c1:4c249022:96b4488c:642e84a6
          Name : any:srv
 Creation Time : Sat Apr 29 20:30:27 2017
    Raid Level : raid1
  Raid Devices : 2

Avail Dev Size : 845151976 sectors (403.00 GiB 432.72 GB)
    Array Size : 244318208 KiB (233.00 GiB 250.18 GB)
 Used Dev Size : 488636416 sectors (233.00 GiB 250.18 GB)
  Super Offset : 845152240 sectors
  Unused Space : before=0 sectors, after=356515808 sectors
         State : clean
   Device UUID : d75cd979:3401034d:41932cc1:4c98b232

Internal Bitmap : -16 sectors from superblock
   Update Time : Mon May 20 18:40:03 2024
 Bad Block Log : 512 entries available at offset -8 sectors
      Checksum : f6864782 - correct
        Events : 576774


  Device Role : Active device 0
  Array State : A. ('A' == active, '.' == missing, 'R' == replacing)


# mdadm --examine /dev/sdb6
/dev/sdb6:
         Magic : a92b4efc
       Version : 1.0
   Feature Map : 0x1
    Array UUID : d96112c1:4c249022:96b4488c:642e84a6
          Name : any:srv
 Creation Time : Sat Apr 29 20:30:27 2017
    Raid Level : raid1
  Raid Devices : 2

Avail Dev Size : 488821392 sectors (233.09 GiB 250.28 GB)
    Array Size : 244318208 KiB (233.00 GiB 250.18 GB)
 Used Dev Size : 488636416 sectors (233.00 GiB 250.18 GB)
  Super Offset : 488821408 sectors
  Unused Space : before=0 sectors, after=184976 sectors
         State : clean
   Device UUID : c077a12d:9ba6c3a0:9c5749ba:600e9aef

Internal Bitmap : -16 sectors from superblock
   Update Time : Mon May 20 18:15:52 2024
 Bad Block Log : 512 entries available at offset -8 sectors
      Checksum : 899ae2ec - correct
        Events : 576771


  Device Role : Active device 1
  Array State : AA ('A' == active, '.' == missing, 'R' == replacing)


Is there anything that can be done, to access the data on /dev/sda3?



--
Thanks in advance,


Richard



