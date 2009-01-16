From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: RAID 5 Recovery Help Needed
Date: Fri, 16 Jan 2009 15:42:59 -0500
Message-ID: <4970F153.30106@scalableinformatics.com>
References: <4970E18C.2000100@mike01.com>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4970E18C.2000100@mike01.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Berger <lists@mike01.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Berger wrote:

> Created the array:
> # mdadm --create --verbose /dev/md0 --level=5 --chunk=128
> --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1

eek ... a RAID5 on 3 drives?

Did you do an

	mdadm --detail --scan > /etc/mdadm.conf

after this?

[...]

> At this point I used the newly created array for a few days without any
> issues at all.

... but did you update mdadm.conf as above?

[...]

> Now I tried to assemble the array manually using the following commands,
> all of which failed (note that I had never edited mdadm.conf).
> 
> # mdadm --assemble --scan

This generally requires an /etc/mdadm.conf (or similar 
/etc/mdadm/mdadm.conf)

> # mdadm --assemble --scan --uuid=3128da32:c5e4ff31:b43fc0e6:226924cf
> # mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1
> # mdadm --assemble -f /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1
> # mdadm --assemble --uuid=3128da32:c5e4ff31:b43fc0e6:226924cf /dev/md0
> /dev/sdb1 /dev/sdc1 /dev/sdd1

You can often (re)construct this file if you forget to create it with a 
little detective work ...

mdadm --examine /dev/sdb1

could be your friend.

[...]

> # fsck.ext4 -n /dev/md0
> 
> I get:
> 
> fsck.ext4: Superblock invalid, trying backup blocks...
> fsck.ext4: Bad magic number in super-block while trying to open /dev/md0
> 
> I've tried specifying the blocksize and specifying the superblock
> manually using  the backup superblocks from when I ran mkfs.ext4, but
> get the same result.  I haven't dared to run fsck without -n until I
> hear from someone more knowledged.
> 
> So, if anyone has any suggestions on how I can get md0 mounted or
> recover my data it would be much appreciated.

I am not completely sure, but I would bet that with the changes you have 
made, that this data may not be recoverable at this point.

Before you do anything else, I would definitely suggest creating the 
mdadm.conf file properly as noted above.

Joe

-- 
Joe Landman
Scalable Informatics LLC,
email: landman@scalableinformatics.com
web  : http://www.scalableinformatics.com
