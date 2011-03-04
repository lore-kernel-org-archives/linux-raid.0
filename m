From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: mdadm ddf questions
Date: Fri, 04 Mar 2011 08:52:25 +0100
Message-ID: <4D709A39.9050804@gmail.com>
References: <4D5FA5C4.8030803@gmail.com> <20110303091155.3d43314a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110303091155.3d43314a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  Hi Neil,

thanks for your answers/fix, here are my findings/thoughts.

On 03/ 2/11 11:11 PM, NeilBrown wrote:
> This is not good.  I have created a fix and added it to my git tree: the
> 'master' branch of  git://neil.brown.name/mdadm
>
>
Yes, that fixed it, thanks.
>> although in the container the disk is marked failed. I then remove it
>> from the container:
>>
>> mdadm -r /dev/md127 /dev/sdc
>>
>> I clean the disk with mdadm --zero-superblock /dev/sdc and add it again.
>>
>> But how do I add this disk again to the md1 raidset?
> It should get added automatically.  'mdmon' runs in the background, notices
> this sort of thing.  I just experimented and it didn't quite work as I
> expected.  I'll have a closer look next week.

It looks like it has something to do with updating the physical disk 
list in the container.

mdadm -E /dev/md127 (the container) shows at the end the list of 
physical disks including
a RefNo (I assume a unique number created when the superblock was added 
to the disk) and
the device file. When I remove a disk from the container the entry stays 
in this list, but the device
file is removed. When I put another disk back at this same device file 
(say /dev/sdd) or zero the superblock (which
is effectively creating a new disk for mdadm) it puts back the device 
file in the original slot with the old
RefNo, and created a new entry in the list with the new RefNo but no 
device file, as that is used in the old slot.
Since the old slot was marked "active/Online, Failed" the disk is not 
used, while the new slot (with the new RefNo)
is marked "Global-Spare/Online", but no device file, and so cannot be used.

To sum it up, when I remove a disk from the containter, the slot for 
this disk in the containter is not removed,
only the device file, it should be removed completely. Otherwise it 
messes up all the rest.

Cheers,

Albert
