From: Tomas Agartz <tlund@nxs.se>
Subject: How to assemble 4-disk raid5 with one broken disk and one marked as
 spare by operator error?
Date: Sun, 8 Dec 2013 21:04:42 +0100 (CET)
Message-ID: <Pine.LNX.4.61.1312082056110.13787@envy.nxs.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After booting a server that had been powered off for some time, the 4-disk 
raid5 device was up and running in read-only mode with one disk missing. 
After a, in hindsight, hasty decision, "mdadm --manage --add /dev/md0 
/dev/sdd" was executed to re-add the missing device to the array.

At this time, all hell broke loose :) The first thing that happened was 
that sdd was added as a spare instead of re-added as expected. The second 
thing was that a different disk, sdb, was kicked from the array because of 
read/sata-bus errors. The root disk also bailed and the system had to be 
powercycled.

The real problem, from the start, was probably that sdb was bad all along, 
but from some reason sdd was the device missing from the array after the 
initial boot.

Trying to read data from sdb gives read errors and timeouts, but I was 
able to do "mdadm --examine" after resetting the sata port.

The current state is that, out of 4 disks two are good (sde and sdf), one 
is (in error) marked as a spare (sdd), and the fourth device is unusable 
(sdb).

What is the correct method do change the spare disk back to a data disk 
and try to restart the array with 3 out of 4 devices (sdd, sde and sdf)?

The device has never had a spare, so I think that sdd used to be "Active 
device 0" before this happened?

Possibly relevant data from mdadm --examine on the four devices:

sdb          State : clean
sdb         Events : 333560
sdb   Device Role : Active device 3
sdb   Array State : .AAA ('A' == active, '.' == missing)

sdd          State : clean
sdd         Events : 333562
sdd   Device Role : spare
sdd   Array State : .AA. ('A' == active, '.' == missing)

sde          State : clean
sde         Events : 333562
sde   Device Role : Active device 1
sde   Array State : .AA. ('A' == active, '.' == missing)

sdf          State : clean
sdf         Events : 333562
sdf   Device Role : Active device 2
sdf   Array State : .AA. ('A' == active, '.' == missing)

If no one else has any better suggestions, my best guess would be to: 
"mdadm --create /dev/md0 --level=5 --raid-devices=4 --assume-clean 
/dev/sdd /dev/sde /dev/sdf missing" (the device was created with default 
values, metadata 1.2, chunk size 512K, layout left-symmetric).

(Other crazy ideas involve editing the superblock of sdd and making it 
device 0 and then trying to start the array after that).

Best regards,
Tomas
