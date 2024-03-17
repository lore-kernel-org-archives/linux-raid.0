Received: from bsmtp3.bon.at (bsmtp3.bon.at [213.33.87.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009A61AACA
	for <linux-raid@vger.kernel.org>; Sun, 17 Mar 2024 10:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.33.87.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710671470; cv=none; b=A/feRrwMIeahxiYgAIzDHMgrZJjhykNeitE6xx0GZ035k2WYDz5kaSef7gx6houqXrOfCq1pL4EJwEp5XCEhuFQYWu5RB3zHzrSUtaxnoATiGdDZlqGFF1Lfx6nRBeMNF0PMFhDfaqO9jmO7p+L1rOOIbbwkRjEZuDccxhCqfg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710671470; c=relaxed/simple;
	bh=jnqbiIeefv3PYKItRy0U3wqcm32bKV8tJ8Xs8RmlDw0=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=O1VsVpaDSGulJC+BWUUH2Yanrj+AwBaqmgg5sY/bmKGic77Amiz+88cOGekiXKsucJUpWpvmOz1eiqmbup7NMs7IVAVn6ahonGF8jVVkDlqHkz8unsixS3aUo1LcqbmN0iYKrZ9jjZJHaAx/ZscRISoivY76UvC5BvKLzJVoD1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=reinelt.co.at; spf=pass smtp.mailfrom=reinelt.co.at; arc=none smtp.client-ip=213.33.87.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=reinelt.co.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=reinelt.co.at
Received: from artus.reinelt.local (unknown [91.113.221.42])
	by bsmtp3.bon.at (Postfix) with ESMTPSA id 4TyDm96cjcz5tl9
	for <linux-raid@vger.kernel.org>; Sun, 17 Mar 2024 11:31:05 +0100 (CET)
Message-ID: <a0b4ad1c053bd2be00a962ff769955ac6c3da6cd.camel@reinelt.co.at>
Subject: heavy IO on nearly idle RAID1
From: Michael Reinelt <michael@reinelt.co.at>
To: linux-raid@vger.kernel.org
Date: Sun, 17 Mar 2024 11:31:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hallo all,

I have a very strange behaviour on my RAID-1 array with Kernel 6.6.13.
Kernel 6.1.76 and earlier do not show this symptoms, but I *think* I
have seen it on any 6.5 Kernel (I am not sure)

the array contains my /home, and consists of an internal NVME drive, a
internal SATA device, and an external USB drive.

even if the array is (neraly) idle, I see very heave I/O on the
external USB drive, which makes the system more or less unusable.

artus:~ # iostat -p sda,sdb,nvme0n1,md0,md1 -y 5
Linux 6.6.13+bpo-amd64 (artus) 	2024-03-17 	_x86_64_	(12 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,12    0,00    0,15    0,45    0,00   99,28

Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read   =
 kB_wrtn    kB_dscd
md0               2,20         0,00         8,80         0,00          0   =
      44          0
md1               0,00         0,00         0,00         0,00          0   =
       0          0
nvme0n1           8,00         0,00        39,10         0,00          0   =
     195          0
nvme0n1p1         0,00         0,00         0,00         0,00          0   =
       0          0
nvme0n1p2         4,40         0,00        29,60         0,00          0   =
     148          0
nvme0n1p3         3,60         0,00         9,50         0,00          0   =
      47          0
nvme0n1p4         0,00         0,00         0,00         0,00          0   =
       0          0
sda               3,80         0,00         9,50         0,00          0   =
      47          0
sda1              3,80         0,00         9,50         0,00          0   =
      47          0
sda2              0,00         0,00         0,00         0,00          0   =
       0          0
sdb              54,20         0,00     26223,10         0,00          0   =
  131115          0
sdb1             54,20         0,00     26223,10         0,00          0   =
  131115          0
sdb2              0,00         0,00         0,00         0,00          0   =
       0          0


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,20    0,00    0,12    0,37    0,00   99,32

Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read   =
 kB_wrtn    kB_dscd
md0               0,20         0,00         0,80         0,00          0   =
       4          0
md1               0,00         0,00         0,00         0,00          0   =
       0          0
nvme0n1           1,60         0,00         3,70         0,00          0   =
      18          0
nvme0n1p1         0,00         0,00         0,00         0,00          0   =
       0          0
nvme0n1p2         0,40         0,00         2,40         0,00          0   =
      12          0
nvme0n1p3         1,20         0,00         1,30         0,00          0   =
       6          0
nvme0n1p4         0,00         0,00         0,00         0,00          0   =
       0          0
sda               1,20         0,00         1,30         0,00          0   =
       6          0
sda1              1,20         0,00         1,30         0,00          0   =
       6          0
sda2              0,00         0,00         0,00         0,00          0   =
       0          0
sdb              39,00         0,00     19661,50         0,00          0   =
   98307          0
sdb1             39,00         0,00     19661,50         0,00          0   =
   98307          0
sdb2              0,00         0,00         0,00         0,00          0   =
       0          0

I am sure that there is no rebuild or check at the moment... and I have
no idea WTF is going on here... sometimes the write rate goes up to
>100 MB/sec

when I check with iotop, i can see similar high write rates, but no
process or thread responsible for it.


Some more information:

artus:~ # uname -a
Linux artus 6.6.13+bpo-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.6.13-1~bpo12+1=
 (2024-02-15) x86_64 GNU/Linux

artus:~ # mdadm --version
mdadm - v4.2 - 2021-12-30 - Debian 4.2-5

artus:~ # cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4=
] [raid10]=20
md1 : active raid1 sda2[2](W) sdb2[4]
      1919826944 blocks super 1.2 [2/2] [UU]
      bitmap: 0/15 pages [0KB], 65536KB chunk

md0 : active raid1 sda1[5](W) nvme0n1p3[3] sdb1[4](W)
      33520640 blocks super 1.2 [3/3] [UUU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>

note: I see similar behaviour on /dev/md1 which is a quite large device
containing virtual machines

artus:~ # smartctl -H -i -l scterc /dev/sda
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-6.6.13+bpo-amd64] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Samsung based SSDs
Device Model:     Samsung SSD 870 EVO 2TB
Serial Number:    S6P4NF0W307661D
LU WWN Device Id: 5 002538 f43329aaa
Firmware Version: SVT02B6Q
User Capacity:    2.000.398.934.016 bytes [2,00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
TRIM Command:     Available, deterministic, zeroed
Device is:        In smartctl database 7.3/5319
ATA Version is:   ACS-4 T13/BSR INCITS 529 revision 5
SATA Version is:  SATA 3.3, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Mar 17 11:06:23 2024 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

artus:~ # smartctl -d sat,auto -H -i -l scterc /dev/sdb
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-6.6.13+bpo-amd64] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Vendor:               Samsung
Product:              PSSD T7
Revision:             0
Compliance:           SPC-4
User Capacity:        2.000.398.934.016 bytes [2,00 TB]
Logical block size:   512 bytes
LU is fully provisioned
Rotation Rate:        Solid State Device
Logical Unit id:      0x5000000000000001
Serial number:        K611523T0SNDT5S
Device type:          disk
Local Time is:        Sun Mar 17 11:13:59 2024 CET
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Disabled or Not Supported

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Health Status: OK


artus:~ # smartctl -H -i -l scterc /dev/nvme0n1
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-6.6.13+bpo-amd64] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Number:                       TS512GMTE400S
Serial Number:                      I216681028
Firmware Version:                   V0804S3
PCI Vendor/Subsystem ID:            0x1d79
IEEE OUI Identifier:                0x7c3548
Controller ID:                      1
NVMe Version:                       1.3
Number of Namespaces:               1
Namespace 1 Size/Capacity:          512.110.190.592 [512 GB]
Namespace 1 Formatted LBA Size:     512
Namespace 1 IEEE EUI-64:            7c3548 52255b6444
Local Time is:                      Sun Mar 17 11:08:56 2024 CET

=3D=3D=3D START OF SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED


artus:~ # mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : f6189e48:e5dadfbd:8a7a9239:c6074410
           Name : any:home
  Creation Time : Fri Nov 15 07:07:21 2019
     Raid Level : raid1
   Raid Devices : 3

 Avail Dev Size : 67041280 sectors (31.97 GiB 34.33 GB)
     Array Size : 33520640 KiB (31.97 GiB 34.33 GB)
    Data Offset : 67584 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D67504 sectors, after=3D0 sectors
          State : clean
    Device UUID : 9023e389:b12c69be:abd226c2:fceba209

Internal Bitmap : 8 sectors from superblock
          Flags : write-mostly
    Update Time : Sun Mar 17 11:15:22 2024
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : 7958e05b - correct
         Events : 864895


   Device Role : Active device 2
   Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D rep=
lacing)


artus:~ # mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : f6189e48:e5dadfbd:8a7a9239:c6074410
           Name : any:home
  Creation Time : Fri Nov 15 07:07:21 2019
     Raid Level : raid1
   Raid Devices : 3

 Avail Dev Size : 67041280 sectors (31.97 GiB 34.33 GB)
     Array Size : 33520640 KiB (31.97 GiB 34.33 GB)
    Data Offset : 67584 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D67504 sectors, after=3D0 sectors
          State : clean
    Device UUID : a5a29aca:ebfaa7b1:c484660d:bb455305

Internal Bitmap : 8 sectors from superblock
          Flags : write-mostly
    Update Time : Sun Mar 17 11:15:34 2024
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : f43f398c - correct
         Events : 864895


   Device Role : Active device 1
   Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D rep=
lacing)


artus:~ # mdadm --examine /dev/nvme0n1p3
/dev/nvme0n1p3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : f6189e48:e5dadfbd:8a7a9239:c6074410
           Name : any:home
  Creation Time : Fri Nov 15 07:07:21 2019
     Raid Level : raid1
   Raid Devices : 3

 Avail Dev Size : 67041280 sectors (31.97 GiB 34.33 GB)
     Array Size : 33520640 KiB (31.97 GiB 34.33 GB)
    Data Offset : 67584 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D67504 sectors, after=3D0 sectors
          State : clean
    Device UUID : dae5b41c:8eaceaae:d65a1486:819723c1

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Mar 17 11:16:38 2024
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : 781a567b - correct
         Events : 864895


   Device Role : Active device 0
   Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D rep=
lacing)

artus:~ # mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Fri Nov 15 07:07:21 2019
        Raid Level : raid1
        Array Size : 33520640 (31.97 GiB 34.33 GB)
     Used Dev Size : 33520640 (31.97 GiB 34.33 GB)
      Raid Devices : 3
     Total Devices : 3
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Sun Mar 17 11:19:35 2024
             State : clean=20
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : bitmap

              Name : any:home
              UUID : f6189e48:e5dadfbd:8a7a9239:c6074410
            Events : 864895

    Number   Major   Minor   RaidDevice State
       3     259        3        0      active sync   /dev/nvme0n1p3
       4       8       17        1      active sync writemostly   /dev/sdb1
       5       8        1        2      active sync writemostly   /dev/sda1

Any hints?

If you need more information, please let me know.

sunny greetings from Austria, Michael


--=20
Michael Reinelt <michael@reinelt.co.at>
Ringsiedlung 75
A-8111 Gratwein-Stra=C3=9Fengel
+43 676 3079941
