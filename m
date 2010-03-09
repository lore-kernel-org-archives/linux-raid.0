From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Fast failing a disk.
Date: Tue, 09 Mar 2010 15:29:16 +0000
Message-ID: <4B96694C.5000602@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everyone,

In case of a RAID 5 on a few disks, with a disk pulled from the 
enclosure at some stage, we get a disk failure.

If doing only reads on the RAID 5 array, the time it takes between the 
actual physical removal of the disk and the disk being failed by md is 
about 4 seconds on my system.

I am trying, using scripting, to speed up this 4 seconds.

The problem being that it takes 4 seconds to fail a disk because we 
probably need that much time to determine for sure that the disk has 
really failed or is really gone, I am using the LSI SAS MPT Fusion 
driver to detect when the physical disk phy has gone offline (which 
happens in near real time), and from there, I send a "./mdadm --fail 
/dev/md/dX /dev/sdX" command to mdadm immediately after detecting this 
failure.

This is therefore much much much faster than waiting for all the 
timeouts present in sd/md.

It is non dangerous too since when a disk phy has gone offline, it is 
physically offline, no need to use any timeouts or retry.

All the above work fine and would solve my problem of speeding up the 
failing of a disk except that when I send the --fail command immediately 
after the disk has been removed from the enclosure, the md array seems 
to loop into a "resync" mode instead of reconfiguring itself as a 
degraded array.

Here is a copy of dmesg showing the phenomenon:

[  744.631035] ioc2 Event: 0xf
[  745.452060] ioc2 Event: SAS_DISCOVERY
[  745.465349] ioc2: Phy 13 Handle a sas addr: 0x50015b22300009e0 is now 
offline
[  745.485209] ioc2 Event: SAS_DISCOVERY
[  745.693492] raid5: Disk failure on sdg2, disabling device.
[  745.693497] raid5: Operation continuing on 4 devices.
[  745.718787] md: recovery of RAID array md_d0
[  745.723047] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  745.728862] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  745.738402] md: using 2048k window, over a total of 9429760 blocks.
[  745.744655] md: resuming recovery of md_d0 from checkpoint.
[  745.756660] md: md_d0: recovery done.
[  745.761900] RAID5 conf printout:
[  745.765148]  --- rd:5 wd:4
[  745.767855]  disk 0, o:1, dev:sdd2
[  745.771243]  disk 1, o:1, dev:sda2
[  745.774634]  disk 2, o:1, dev:sdc2
[  745.778029]  disk 3, o:0, dev:sdg2
[  745.781424]  disk 4, o:1, dev:sdb2
[  745.799202] md: recovery of RAID array md_d0
[  745.803460] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  745.809275] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  745.818814] md: using 2048k window, over a total of 9429760 blocks.
[  745.825066] md: resuming recovery of md_d0 from checkpoint.
[  745.837066] md: md_d0: recovery done.
[  745.842872] RAID5 conf printout:
[  745.846187]  --- rd:5 wd:4
[  745.848890]  disk 0, o:1, dev:sdd2
[  745.852281]  disk 1, o:1, dev:sda2
[  745.855673]  disk 2, o:1, dev:sdc2
[  745.859064]  disk 3, o:0, dev:sdg2
[  745.862459]  disk 4, o:1, dev:sdb2
[  745.919801] md: recovery of RAID array md_d0
[  745.924090] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  745.929949] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  745.939491] md: using 2048k window, over a total of 9429760 blocks.
[  745.945742] md: resuming recovery of md_d0 from checkpoint.
[  745.957745] md: md_d0: recovery done.
[  746.149794] RAID5 conf printout:
[  746.153051]  --- rd:5 wd:4
[  746.155752]  disk 0, o:1, dev:sdd2
[  746.159151]  disk 1, o:1, dev:sda2
[  746.162543]  disk 2, o:1, dev:sdc2
[  746.165939]  disk 3, o:0, dev:sdg2
[  746.169334]  disk 4, o:1, dev:sdb2
[  746.369081] md: cannot remove active disk sdg2 from md_d0 ...
[  746.374866] md: recovery of RAID array md_d0
[  746.379129] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  746.384949] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  746.394489] md: using 2048k window, over a total of 9429760 blocks.
[  746.400794] md: resuming recovery of md_d0 from checkpoint.
[  746.412814] md: md_d0: recovery done.
[  746.436268] md: cannot remove active disk sdg2 from md_d0 ...
[  746.491071] RAID5 conf printout:
[  746.494321]  --- rd:5 wd:4
[  746.497027]  disk 0, o:1, dev:sdd2
[  746.500420]  disk 1, o:1, dev:sda2
[  746.503811]  disk 2, o:1, dev:sdc2
[  746.507202]  disk 3, o:0, dev:sdg2
[  746.510598]  disk 4, o:1, dev:sdb2
[  746.594835] md: recovery of RAID array md_d0
[  746.599097] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  746.604915] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  746.614453] md: using 2048k window, over a total of 9429760 blocks.
[  746.620698] md: resuming recovery of md_d0 from checkpoint.
[  746.632689] md: md_d0: recovery done.
[  746.683892] RAID5 conf printout:
[  746.687118]  --- rd:5 wd:4
[  746.689825]  disk 0, o:1, dev:sdd2
[  746.693224]  disk 1, o:1, dev:sda2
[  746.696617]  disk 2, o:1, dev:sdc2
[  746.700012]  disk 3, o:0, dev:sdg2
[  746.703404]  disk 4, o:1, dev:sdb2
[  746.733530] md: recovery of RAID array md_d0
[  746.737820] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  746.743635] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  746.753171] md: using 2048k window, over a total of 9429760 blocks.
[  746.759419] md: resuming recovery of md_d0 from checkpoint.
[  746.771432] md: md_d0: recovery done.
[  746.821801] RAID5 conf printout:
[  746.825049]  --- rd:5 wd:4
[  746.827754]  disk 0, o:1, dev:sdd2
[  746.831150]  disk 1, o:1, dev:sda2
[  746.834545]  disk 2, o:1, dev:sdc2
[  746.837940]  disk 3, o:0, dev:sdg2
[  746.841336]  disk 4, o:1, dev:sdb2
[  746.853983] md: recovery of RAID array md_d0
[  746.858270] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  746.864088] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  746.873627] md: using 2048k window, over a total of 9429760 blocks.
[  746.879872] md: resuming recovery of md_d0 from checkpoint.
[  746.891885] md: md_d0: recovery done.
[  746.942047] RAID5 conf printout:
[  746.945301]  --- rd:5 wd:4
[  746.948008]  disk 0, o:1, dev:sdd2
[  746.951398]  disk 1, o:1, dev:sda2
[  746.954788]  disk 2, o:1, dev:sdc2
[  746.958183]  disk 3, o:0, dev:sdg2
[  746.961579]  disk 4, o:1, dev:sdb2
[  746.974231] md: recovery of RAID array md_d0
[  746.978521] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  746.984339] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  746.993887] md: using 2048k window, over a total of 9429760 blocks.
[  747.000136] md: resuming recovery of md_d0 from checkpoint.
[  747.012149] md: md_d0: recovery done.
[  747.062726] RAID5 conf printout:
[  747.065976]  --- rd:5 wd:4
[  747.068683]  disk 0, o:1, dev:sdd2
[  747.072075]  disk 1, o:1, dev:sda2
[  747.075468]  disk 2, o:1, dev:sdc2
[  747.078859]  disk 3, o:0, dev:sdg2
[  747.082253]  disk 4, o:1, dev:sdb2
[  747.202204] md: recovery of RAID array md_d0
[  747.206499] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  747.212317] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  747.221855] md: using 2048k window, over a total of 9429760 blocks.
[  747.228107] md: resuming recovery of md_d0 from checkpoint.
[  747.240122] md: md_d0: recovery done.
[  747.291282] RAID5 conf printout:
[  747.294530]  --- rd:5 wd:4
[  747.297238]  disk 0, o:1, dev:sdd2
[  747.300636]  disk 1, o:1, dev:sda2
[  747.304026]  disk 2, o:1, dev:sdc2
[  747.307418]  disk 3, o:0, dev:sdg2


... This continues until precisely 4 seconds, the same time it takes if 
not sending the command to fail the disk before md does it 
automatically, at which point the sd device is kicked out and the array 
becomes degraded, or too many IO errors are detected by md and the same 
fate happens.

On the other hand, the interesting point is that trying to do the above 
while also doing read IOs but without physically pulling a disk (just 
using --fail on a disk that is present, healthy, and running the read 
IOs too), everything works fine.

It seems that if you decide to send a --fail command to a disk that is 
currently in the sd or md path for error checking and/or recovery, the 
fail command will not be ignored but will instead trigger an endless 
loop of recoveries (in the above case, the recoveries are very fast 
since we are running read only IOs), and will succeed once the normal 
error checking has completed and decided to expell or kick the device out.

Would anybody know what it causing this, and if there is a way around it?

The command used to create the RAID is the following:

"mdadm --create -vvv --force --run --metadata=1.2 /dev/md/d0 --level=5 
--size=9429760 --chunk=64 --name=test_01 -n5 --bitmap=internal 
--bitmap-chunk=4096 --layout=ls /dev/sdd2 /dev/sda2 /dev/sdc2 /dev/sdg2 
/dev/sdb2"

Thank you very much in advance!

Ben.
