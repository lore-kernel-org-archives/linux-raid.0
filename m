From: Rich West <Rich.West@wesmo.com>
Subject: Linux RAID - Moving array from one system to another
Date: Fri, 02 Jan 2004 11:36:25 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FF59E09.6000403@wesmo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm attempting a full system upgrade and, after a couple of attempts and 
quick back-outs, I figured I would break down and ask.. I was unable to 
find anything via Google regarding this, so here goes:

Scenerio is:
o I have an older server running Linux Software RAID-5 across 5 disks 
that are all housed in an external case (including the root drive which 
is not part of the RAID-5 array)
o The server is running quite happily, but the OS (a RH 6.1 system that 
has been upgraded throught the years to RH 8)  is in need of an upgrade.
o We obtained a 1U Dell with hardware raid which we loaded the OS on the 
root mirror.
o The 1U unit also has an onboard Adaptec SCSI card (outside of the 
megaraid card).
o We want to migrate over to the 1U server

What were were thinking was that we could shutdown the old server, 
disconnect the extrenal SCSI case, plug it in to the new server, and 
boot it with the hopes that the OS would recognize the RAID partition.  
Unfortunately, that did not happen.  It did see the drives, but did not 
autodetect the RAID-5 array.

We tried mdadm --assemble /dev/md0 /dev/sda1 /dev/sdc1 /dev/sdd1 
/dev/sde1 /dev/sdf1.  It appeared to work as we were able to mount the 
drive, but any access to the array resulted in the OS freezing as it 
marked all of the drives as failed.

With the new system, because of the arrangement, the drive letters all 
got re-adjusted compared to the old server.

Is there a way to do what I am looking for, or should I just move the 
case over to the new machine and re-create the RAID-5 array.  Then, 
restore (from tape) the contents of the array?  I'm pretty much at that 
point, but I just wanted to see if moving the array was even feasible. :)

-Rich

