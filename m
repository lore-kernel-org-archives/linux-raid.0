From: Dave Wreski <dave@guardiandigital.com>
Subject: Replacing failed disk in RAID1
Date: Sun, 17 Aug 2003 18:26:30 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F400116.1000608@guardiandigital.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I spent the last five or six hours working with a failed RAID1 array, 
and was able to get it up and running quite quickly after finding mdadm.

The part I don't understand is why raidhotadd didn't work as I expected. 
/dev/hda1 failed, so I replaced /dev/hda and rebooted. This marked hda 
in md0 and md1 as faulty.

After partitioning the new disk exactly as the old, and marking them as 
raid-autostart, raidhotadd reported:

md: invalid raid superblock magic on ide/host0/bus0/target0/lun0/part1
md: ide/host0/bus0/target0/lun0/part1 has invalid sb, not importing!
md: could not import ide/host0/bus0/target0/lun0/part1!
md: autostart ide/host0/bus0/target0/lun0/part1 failed!

Luckily I was able to use mdadm to find a list of available arrays and 
assemble them. I also tried raidsetfaulty, to no avail.

Also, my lilo.conf stated /dev/md0 (root partition) as its boot 
parameter, but after replacing hda, it would not boot. I had partitioned 
it the same as the defective disk. Changing the first boot disk to hdb 
resulting in "LI". Shouldn't both of these have worked?

What did I do wrong?

Thanks,
Dave

-- 
Dave Wreski                                 Guardian Digital, Inc.
(201) 934-9230                Pioneering.  Open Source.  Security.
dave@guardiandigital.com            http://www.guardiandigital.com

