From: Dave Dmytriw - NetCetera <daved@netcetera-solutions.com>
Subject: I have managed to pickle my RAID 1 install after a disk crash
Date: Sun, 19 Sep 2004 08:08:10 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <414D92CA.2060903@netcetera-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I recently had the mis-fortune of a disk failure, luckily the disk was 
part of a RAID1 setup, so nothing was lost - yet...I should mention that 
I am mirroring /boot/, swap and / , and am using mdadm.

I had thought that I had setup grub correctlly to allow booting off of 
either disk, but did not test it - my bad. So when I replaced the drive 
- hda- I thought that the sytem would boot off of hdd and then go 
through the process of rebuilding the array with the new drive. But the 
system would not boot. I tried various things, BIOS settings, etc, but 
the Grub splash screen would not appear when I tried to boot off of hdd.

I swapped cables - and drive jumpers - so that my previous hdd was now 
hda and then sucessfully re-booted the system. So far so good. Not sure 
why the disk would boot as hda and not hdd - maybe a BIOS issue with my 
motherboard even though it does allow specifying IDE 0-4 as boot devices.

So I had the sytem up and running - in a RAID degraded state - and 
started woking on bringing the RAID 1 scenario back. I partioned the 
replacement drive, now hdd and all looked well. It didn't look like I 
could simply add the drive to the array as cat /proc/mdstat implied to 
me that the first disk in the array had failed and I was worried about 
copying the contents of the second drive - which mdadm thought was good 
- over the drive that actually had the good stuff on it. I tried various 
other things with mdadm, like stoopping and re-creating the raid 
devices, etc, but to no success - probably user eror.

So now I am not sure how to proceed.

cat /proc/mdstat yeilds this:

Code:
lucky root # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath]
read_ahead 1024 sectors
md3 : active raid1 ide/host0/bus0/target0/lun0/part3[1]
       12377984 blocks [2/1] [_U]

md1 : active raid1 ide/host0/bus1/target1/lun0/part1[1]
       64128 blocks [2/1] [_U]

md2 : active raid1 ide/host0/bus1/target1/lun0/part2[1]
       248896 blocks [2/1] [_U]

unused devices: <none>


Which implies to me that things are very messed up. I think this because 
of the following snippets:

Code:
md3 : active raid1 ide/host0/bus0/target0/lun0/part3[1]
       12377984 blocks [2/1] [_U]

and

Code:
md1 : active raid1 ide/host0/bus1/target1/lun0/part1[1]
       64128 blocks [2/1] [_U]


different busses and targets - so different disks are active....

I spent some time seraching around and came to the conclusion that my 
RAID config is definitely borked.

I am thinking that the best thing for me to do now is to deactivate RAID 
completely, then come back and do a complete RAID re-config with my 
disks the way they are. But, I can't find a way to stop/delete the meta 
devices so that I can start from scratch. I am running on my /dev/hdax 
config with no /dev/mdx devices mounted.

Any thoughts ?

Thanx.
-- 
Dave Dmytriw
Principal, NetCetera Solutions Inc.
Calgary, AB
403-703-1399
daved@netcetera-solutions.com
http://www.netcetera-solutions.com

