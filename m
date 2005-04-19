From: Luca Berra <bluca@comedia.it>
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 09:15:15 +0200
Message-ID: <20050419071514.GB29247@percy.comedia.it>
References: <1113853825.1483.34.camel@debian> <426414A5.3020706@dgreaves.com> <1113865936.1483.73.camel@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1113865936.1483.73.camel@debian>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 19, 2005 at 01:12:16AM +0200, tmp wrote:
>mdadm.conf may be considered as the replacement for raidtab. When mdadm
>starts it consults this file and starts the raid arrays correspondingly.
>This leads to the following:
yes, and no
mdadm does not need a configuration, but the config file helps.
check
http://cvs.mandrakesoft.com/cgi-bin/cvsweb.cgi/SPECS/mdadm/raidtabtomdadm.sh
for a script to convert from an existing raidtab to mdadm.conf

>a) If mdadm starts the arrays, how can I then boot from a RAID device
>(mdadm isn't started upon boot)?
>I don't quite get which parts of the RAID system are controled by the
>kernel and which parts are controled by mdadm.
the best choice is having an initrd containing mdassemble (part of
mdadm) and the configuration file.
the second to best choice is using the kernel command line to assemble
the raid array.
the last chance is using FD partition and in-kernel autodetect.

>b) Whenever I replace disks, the runtime configuration changes. I assume
>that I should manually edit mdadm.conf in order to make corespond to
>reality?
no, the mdadm configuration file only contains information on how to
identify the raid components, not their status. if you only use the UUID
to identify the array you will be able to find it whatever you do to it.

>> >2) The new disk has to be manually partitioned before beeing used in the
>> >array.
>> no it doesn't. You could use the whole disk (/dev/hdb).
>> In general, AFAIK, partitions are better as they allow automatic 
>> assembly at boot.
>
>Is it correct that I can use whole disks (/dev/hdb) only if I make a
>partitionable array and thus creates the partitions UPON the raid
>mechanism?
no, you can use a whole disk as a whole disk, there is no law that you
have to partition it. usually you do because it is easier to manage, but
you could use LVM instead of partitions.

>As far as I can see, partitionable arrays makes disk replacements easier
>as you can just replace the disk and let the RAID software take care of
>syncing the new disk with existing partitioning. Is that correct?
layering the partitions above the raid array is easier to manage.
>You say I can't boot from such a partitionable raid array. Is that
>correctly understood?
why not?

>Can I "grow" a partitionable raid array if I replace the existing disks
>with larger ones later? 
yes, you will have free (non partitioned) space at the end.

>Would you prefer manual partitioned disks, even though disk replacements
>are a bit more difficult?
YMMV

>I guess that mdadm automatically writes persistent superblocks to all
>disks?
unless you tell it not to, when creating an array with mdadm it writes a
persistent superblock.

>> >3) Must all partition types be 0xFD? What happens if they are not?
>> no
>> They won't be autodetected by the _kernel_
>
>OK, so it is generally a good idea to always set the partition types to
>0xFD, I guess.
many people find it easier to understand if raid partitions are set to
0XFD. kernel autodetection is broken and should not be relied upon.

>> >4) I guess the partitions itself doesn't have to be formated as the
>> >filesystem is on the RAID-level. Is that correct?
>> compulsory!
>
>I meant, the /dev/mdX has to be formatted, not the individual
>partitions. Still right?
compulsory! if you do anything on the individual components you'll damage data.

>> >5) Removing a disk requires that I do a "mdadm -r" on all the partitions
>> >that is involved in a RAID array. I attempt to by a hot-swap capable
>> >controler, so what happens if I just pull out the disk without this
>> >manual removal command?
>> as far as md is concerned the disk disappeared.
>> I _think_ this is just like mdadm -r.
i think it will be marked faulty, not removed.

>So I could actually just pull out the disk, insert a new one and do a
>"mdadm -a /dev/mdX /dev/sdY"?
>The RAID system won't detect the newly inserted disk itself?
no, think of it as flexibility. if you want you can build something
using the "hotplug" subsystem.

...
>Are there some HOWTO out there, that is up-to-date and is based on RAID
>usage with mdadm and kernel 2.6 instead of raidtools and kernel 2.2/2.4?
>I can't possibly be the only one with these newbie questions. :-)
one last word:
never trust howtos (they should be called howidid), they have the
tendency to apply to the author configuration, not yours.
general documentation is far more accurate.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
