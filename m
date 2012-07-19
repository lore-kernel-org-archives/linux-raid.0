From: Zhang Jiejing <b33651@freescale.com>
Subject: Question about how to migrate raid0 to raid5
Date: Thu, 19 Jul 2012 15:11:06 +0800
Message-ID: <5007B30A.8070709@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  Hi Neil Brown,

Sorry for interrupt you.

I'm using linux md raid0 in my server, and it's working very good unless 
it's outof space recently.
Thanks for you good job.

I have two question about linux md,
1. the first one maybe a common one:
     I install my server /home dir as RAID-0 for speed, this server is 
usually to code build and development, but recently I need add a 2TB HDD 
to this md, and I found add disk on RAID-0 is not supported, but I found 
there will maybe a way to convert my RAID-0 to RAID-5, and then add 
other disk on the RAID-5  (I don't covert it back).

I sow some patch about md takeover:
like
md/raid4: permit raid0 takeover
md: Fix dev_sectors on takeover from raid0 to raid4/5

But I'm a newbie about linux md, can you give a some guide about how to 
do this or it was not supported ?

My kernel version: Linux  2.6.38-15-server #64-Ubuntu SMP Fri Jul 6 
19:08:52 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

mdadm - v3.1.4 - 31st August 2010


2. the second question is about radi0.c : create_strip_zones() function,
this function will scan mddev->disks  and check them EQUAL size or not, 
can you give me some guide about where this disks passed to this mddev ?

The reason I ask this question is, I add a new HD, and partition two 
"Linux raid autodetect" partition on this disk, but I don't know how to 
add this disk to md1.

So I type:
  mdadm --add /dev/md1 /dev/sdc
and report -EINVAL error.

I first tough is I caused by my partition not right, so I partition my 
sdc to 2 partition, with partition type is "Linux raid autodetect".

and found also failed, so I did some google, and found RAID-0 don't 
support add disk online.

After did a ubuntu "do-release-upgrade", and reboot, I found kernel will 
check /dev/sdc, looking at sdc, and then failed to create the zone.

After remove the HD in BIOS, I can success mount the md1 again, so my 
question is do I need do some mdadm command to remove the /dev/sdc in my 
md1 (maybe it record the device node in some where ?)


Thanks for you advance.

-- 
BR,
Jiejing


