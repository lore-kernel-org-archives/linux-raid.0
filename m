From: Dominique <dcouot@hotmail.com>
Subject: mdadm - level change from raid 1 to raid 5
Date: Fri, 30 Sep 2011 20:31:37 +0200
Message-ID: <BLU0-SMTP4116DC38F2741F78CA7020C9F70@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Using Ubuntu 11.10 server , I am testing RAID level changes through 
MDADM. The objective is to migrate RAID 1 (1+ HDD) environment to RAID 5 
(3+ HDD) without data loss.
In order to make as simple as possible, I started in a VM environment 
(Virtual Box).

Initial Setup:
U11.10 + 2 HDD (20GB) in Raid 1 -> no problem
The setup is made with 3 RAID 1 partition on each disk (swap (2GB), boot 
(500MB), and root (17,5GB)). I understand that this will allow to 
eventually grow to a RAID 5 configuration (in Ubuntu) and maintain boot 
on a RAID construct (swap and boot would remain on RAID 1, while root 
would migrate to RAID 5).

Increment number of disks:
add 3 HDD to the setup -> no problem
increase the RAID 1 from 2 HDD to 5 HDD -> no problem, all disks added 
and synchronized

root@ubuntu:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md2 : active raid1 sda3[0] sde3[4] sdb3[1] sdc3[2] sdd3[3]
       18528184 blocks super 1.2 [5/5] [UUUUU]

md1 : active raid1 sda2[0] sde2[4] sdb2[1] sdd2[3] sdc2[2]
       488436 blocks super 1.2 [5/5] [UUUUU]

md0 : active raid1 sdb1[1] sde1[4] sda1[0] sdc1[2] sdd1[3]
       1950708 blocks super 1.2 [5/5] [UUUUU]


Change Level:
That's where the problem occurs:
I initially tried 3 different approaches for md2 (the root partition)

     1. Normal boot

     mdadm /dev/md2 --grow --level=5

     Not working: 'Could not set level to raid 5'. I suppose this is 
because the partition is in use. Makes sense.

     2. Boot from the recovery mode in the grub menu

     mdadm /dev/md2 --grow --level=5

     Not working: 'Could not set level to raid 5'. Not seing the point 
of the recovery mode if you cannot make modification...

     3. Boot from the 11.10 CD in rescue mode
     I elected not to use a root file system to make the necessary 
changes, and elected the shell from the installer environment.
     No md is currently available
     mdadm --assemble --scan
     This adds my 3 md, but with a naming convention a bit different 
than usual:

     mdadm: /dev/md/2 has been started with 5 drives
     mdadm: /dev/md/1 has been started with 5 drives
     mdadm: /dev/md/0 has been started with 5 drives

     md/[012] instead of md[012]

     mdadm /dev/md/2 --grow --level=5

     or

     mdadm /dev/md2 --grow --level=5

     results in the same message 'Could not set level to raid 5'.

     So what am I doing wrong with mdadm ? From the manpage and 
developper's page, level changes are possible with a simple instruction 
(with the right version of mdadm of course -hence ubuntu 11.10). But it 
just does not work.

I finally tried a fourth and completely different approach:

     mdadm /dev/md2 --stop
     mdadm --create --raid-devices=5 --level=5 /dev/md2 /dev/sda3 
/dev/sdb3 /dev/sdc3 /dev/sdd3 /dev/sde3

     after the warning about /dev/sd[12345] being part of a raid1 array, 
it allows to create the raid5 and started it.

     cat /proc/mdstat

     md2 is being build

     mdadm -D /dev/md2

     same info

After waiting for the raid5 to be rebuild, I decided to restart normally 
the VM... And that's when, I got an unexpected surprise: cannot boot, 
boot in initramfs. Looks like it cannot find the md with the root in it.

I googled around but could not find what I missed. I now understand that 
the fstab (and/or the initramfs image) needed to be updated with the new 
UUID created but could not figure out how to do it from the CD recovery 
console (as the fstab points to the one used by the live CD console), 
and in the case of the busybox showing up with initramfs, I could not 
locate an editor to try to make changes in it either.

I am relatively sure I did not destroy the content of the root... just 
moved it to a different partition that I can no longer access. While 
trying to mount the new md device, by name does not work (md2 seem to 
still point to the old raid1). Should I have created the raid device 
under a different name ?

Not sure what to update to either as md name keep on changing... 
md125,md126,md127, or U11:0, U11:1, U11:2. (U11 being the name of the 
server). Why are raid name changing all the time?

I am convinced I must be missing a simple step, but cannot figure it out 
so far.
Any help is welcome at this stage.

Dom
