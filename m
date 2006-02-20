From: Bryan Wann <bryan@datafoundry.com>
Subject: Avoiding resync of RAID1 during creation
Date: Mon, 20 Feb 2006 09:55:09 -0600
Message-ID: <43F9E65D.6040402@datafoundry.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

With FC2, when installing a fresh new system we would create a RAID10 
array by creating several RAID1s, then adding all of those to a RAID0 
array.  To make the RAID1 devices, we'd use the command:
   /sbin/mkraid --really-force --dangerous-no-resync /dev/mdX

Then we'd set up the RAID0 and mke2fs our filesystems on top of it. 
This worked well for us, never had any problems later.  As soon as the 
kickstart was finished, the system was ready to go.

Now with FC4, raidtools is gone and I'm left with mdadm tools.  As far 
as I can tell, mdadm has nothing resembling --dangerous-no-resync.  I've 
updated my kickstart to use mdadm instead of mkraid using:

   /sbin/mdadm --create /dev/md4 --force --run --level=1 --chunk=256 \
   --raid-disks=2 --spare-devices=0 /dev/sda5 /dev/sde5

This causes all of the newly created RAID1 devices to start syncing.  On 
a system with many large disks and RAID1 arrays, syncing takes a 
considerably long time.

Is there any way to avoid the sync after creation when using mdadm like 
I could with mkraid?

The compelling argument I've read in the archives indicates this would 
run counter to ensuring both partitions were completely clean at a block 
level.  I would think creation of the filesystem on top of the array 
would ensure they're clean, at least on that level for all intents and 
purposes.


--bryan
