From: Justin Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: bad block remapping
Date: Thu, 23 May 2002 14:02:20 -1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CED830C.1010504@cfht.hawaii.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have philosophical question about the RAID software.

In a redundant array, in the situation where a small number of blocks on 
a disk fail during or before a read request it appears that the software 
will down the disk and put the array into degraded mode. This is fine 
since the disk has returned an unrecoverable error. However, at that 
moment in time the RAID software knows from other array elements what 
the contents of those blocks should be, and if it were to try to rewrite 
the blocks, most disks would then have the opportunity to remap the bad 
blocks with spares and continue normal operation. Logically, the disk 
has no chance to remap the blocks if the software only issues read 
requests for them, it doesn't know what the data on the blocks should 
have been, but the RAID software does.

This would be useful since if the software degrades an array because of 
a disk which could have been repaired on the fly the array's data may be 
seriously jeopardized in the event of a second disk failure.

The same thing essentially happens when a failed disk is simply readded 
to an array: the data is rewritten to the device, any bad blocks are 
automatically remapped by the disk because the disk is receiving only 
write requests (which can be recovered) and voila! The array works fine 
again. Only problem with this is that it involves time during which 
another disk could fail, user intervention, and even if a spare disk is 
defined, a resync during which the array is vulnerable to total failure 
due to a second disk failing.

I have personally been in multiple situations where I have lost 
important data on large level 5 arrays due to multiple disk failures 
where at least one of the failed disks was able to map out bad blocks 
(in subsequent post-mortem testing by issuing writes to the device) and 
resume normal operation, at least for a while. If the RAID software 
could have done that and issued a warning rather than degrading the 
array I would not have lost any data.

I can think of a few arguments against such a technique which I should 
probably also present:

The RAID software should be device independent, and rewriting blocks 
after read errors would constitute a hack to accommodate the way most 
hard disks work. This is true but it could also be an option flagged in 
the array configuration or in the kernel source. I think the vast 
majority of RAID users are using hard disks and I can't think of a 
different kind of block device that would suffer from attempting to 
rewrite damaged blocks. Yes, I suppose it's still a hack but heck, it's 
a hack that could save data.

When a disk starts loosing blocks it's usually starting to fail anyway, 
even if it can be temporarily recovered. I think if anything like this 
existed it should log visible messages if it ever has to help a disk 
remap bad blocks which would be a good warning that a disk is starting 
to fail. Besides, a disk is usually doing this kind of remapping anyway 
during writes which we get no notification of.

So if this is a bad idea would someone take a moment to tell me why?

-Kanoa

