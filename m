From: bernd@rhm.de
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 13:00:11 +0200 (MESZ)
Message-ID: <200504191100.NAA01462@node130.rhm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>Devid wrote:
>>>>
>>>> >5) Removing a disk requires that I do a "mdadm -r" on all the 
>>>> partitions
>>>> >that is involved in a RAID array. I attempt to by a hot-swap capable
>>>> >controler, so what happens if I just pull out the disk without this
>>>> >manual removal command?
>>>> as far as md is concerned the disk disappeared.
>>>> I _think_ this is just like mdadm -r.
>>
>> i think it will be marked faulty, not removed.
>>
>yep - you're right, I remember now.
>You have to mdadm -r remove it and re-add it once you restore the disk.

First you have to look if there are partitions on that disk to which no
data was written since the disk failed (this typically concerns the swap
partition). These partitions have to be marked faulty by hand using mdadm -f
before you can remove them with mdadm -r. If you have scsi-disks you have 
to use the following command to take it out off the kernel after removing 
a faulty disk:

echo "scsi remove-single-device h.c.i.l" >/proc/scsi/scsi

>>> So I could actually just pull out the disk, insert a new one and do a
>>> "mdadm -a /dev/mdX /dev/sdY"?
>>> The RAID system won't detect the newly inserted disk itself?
>
>or:
>no, it would be mighty strange if the raid subsystem just grabbed every
>new disk it saw...
>Think of what would happen when I insert my camera's compact flash card
>and it suddenly gets used as a hot spare <grin>

But if the new disk contains any RAID information and partitions on it
then after spinning it up with something like 
 
echo "scsi add-single-device h.c.i.l" >/proc/scsi/scsi
                                                      
the RAID system immediately tries to activate those incomming array(s).
We had this yesterday on a SuSE 9.3 system. So be carefull walking with
used disks from one system to another (this szenario is discussed actually
in a parallel thread under topic ... uuid...).
                                       
>> no, think of it as flexibility. if you want you can build something
>> using the "hotplug" subsystem.
                                 
We tried to build "something like a hotplug system" :-). Our hardware
supports this but in a ratio of 1:10 the kernel (actually 2.6.11-4) 
crashes when there is activity on that controller while spinning up the
new disk. We hoped the system would survive with the remaining (second)
controller and the part of the mirrors (RAID1) attached to it but it
fails in ca. 10% of our attempts. So till now we weren't lucky to build
up a system based on software-raid with no downtime in case of a disk 
failure. But may be this problem is more related to SCSI than to sw-raid...

Bernd Rieke
