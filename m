From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Problems after extending partition
Date: Thu, 30 Aug 2012 17:48:31 -0700
Message-ID: <504009DF.4070408@biostat.ucsf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

/dev/md1 was RAID 1 built from hda3 and hdb3.  After increasing the 
partition size of hd[ab]3, md1 could not be assembled.  I think I 
understand why and have a solution, but I would appreciate it if someone 
could check it.  This is with 0.90 format on Debian Lenny with the 
partitions in raid auto-detect mode.  hda and hdb are virtual disks 
inside a kvm VM; it would be time-consuming to rebuild it from scratch.

The final wrinkle is that when I brought the VM up and dm1 was not 
constructed one of the partitions was used anyway, so they are now out 
of sync.

Analysis: Growing the partitions meant that the mdadm superblocks were 
not at the expected offset from the end of the partitions, and so they 
weren't recognized as part of the array.

Solution:  (step 3 is the crucial one)
1. Shut down the VM; call it the target VM.
2. Mount the disks onto a rescue VM (running squeeze) as sdb and sdc.
3. mdadm --create /dev/md1 --UUID=xxxxx --level=mirror --raid-devices=2 
/dev/sdb3 missing --spare-devices=1 /dev/sdc3.
UUID taken from the target VM.
4. wait for it to sync.
5. maybe do some kind of command to say the raid no longer has a spare.  
It might be
mdadm --grow /dev/md3 --spare-devices=0
6. Shut the rescue VM and start the target VM.

Does it matter if I call the device /dev/md1 in step 3?  It is known as 
that in the target VM.

Thanks for any help.
Ross Boylan
