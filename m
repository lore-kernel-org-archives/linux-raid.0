From: Albert Pauw <albert.pauw@gmail.com>
Subject: mdadm ddf questions
Date: Sat, 19 Feb 2011 12:13:08 +0100
Message-ID: <4D5FA5C4.8030803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  I have dabbed a bit with the standard raid1/raid5 sets and am just 
diving into this whole ddf container stuff,
and see how I can fail, remove and add a disk.

Here is what I have, Fedora 14, five 1GB Sata disks (they are virtual 
disks under VirtualBox but it all seems
to work well under the standard raid stuff. For mdadm I am using the 
latest git version, with version nr 3.1.4.

I created a ddf container:

mdadm -C /dev/md/container -e ddf -l container -n 5 /dev/sd[b-f]

I now create a raid 5 set in this container:

mdadm -C /dev/md1 -l raid5 -n 5 /dev/md/container

This all seems to work, I also noticed that after a stop and start of 
both the container and the raidset,
the container has been renamed to /dev/md/ddf0 which points to /dev/md127.

I now fail one disk in the  raidset:

mdadm -f /dev/md1 /dev/sdc

I noticed that it is removed from the md1 raidset, and marked 
online,failed in the container. So far so
good. When I now stop the md1 array and start it again, it will be back 
again with all 5 disks, clean, no failure
although in the container the disk is marked failed. I then remove it 
from the container:

mdadm -r /dev/md127 /dev/sdc

I clean the disk with mdadm --zero-superblock /dev/sdc and add it again.

But how do I add this disk again to the md1 raidset?

I see in the container that /dev/sdc is back, with status 
"active/Online, Failed" and a new disk is added
with no device file and status "Global-Spare/Online".

I am confused now.

So my question: how do I replace a faulty disk in a raidset, which is in 
a ddf container?

Thanks and bare with me, I am relatively new to all this.

Albert
