From: Steve Byan <smb@egenera.com>
Subject: Re: NCQ general question
Date: Fri, 3 Mar 2006 16:55:10 -0500
Message-ID: <C6838977-5411-400F-9548-2F22598DC2AE@egenera.com>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com> <440561CB.30201@yahoo.de> <4405A656.1030602@rtr.ca> <20060301135547.GV4816@suse.de>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060301135547.GV4816@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mark Lord <liml@rtr.ca>, Gentoopower <gentoopower@yahoo.de>, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids


On Mar 1, 2006, at 8:55 AM, Jens Axboe wrote:

> On Wed, Mar 01 2006, Mark Lord wrote:
>> NCQ vs. TCQ:  NCQ has a much more efficient low-level protocol,
>> making the host-side (controller, operating-system) quite a bit
>> simpler than with NCQ.
>
> Or in laymens terms - TCQ sucks and NCQ doesn't :-)
> NCQ has many more advantages than TCQ, apart from both a more  
> efficient
> low level protocol and ease of implementation. TCQ basically just  
> allows
> the drive to do some reordering, it still serializes everything and
> requires too many interrupts.

The problem with TCQ is that the host can't disconnect on writes  
after sending the data to the drive but before receiving the status.  
The host can only disconnect between sending the command and moving  
the data. Consequently TCQ is useless for writes, which is where you  
really need it. It works OK for reads. TCQ was really invented as a  
way to allow CD-ROM drives to play nice on the same ATA bus as disks.

The reason you need write queuing is for data integrity reasons, not  
for performance. ATA disks effectively get command-queuing on writes  
even without TCQ and NCQ - they simply park the data in a volatile  
RAM cache, tell the host that the data is saved on persistent  
storage, and then asynchronously write the queued data to the  
physical media. The drive reorders those writes and will gather  
sequential writes.

However, note that all filesystems that make even a pretense of  
trying to maintain filesystem integrity after a power failure (note  
that the Windows NT implementation of FAT32 does not attempt to  
maintain filesystem integrity after a power failure) depend on  
knowing when data makes it to persistent storage, so they can order  
their writes correctly. ATA disk write caching breaks this guarantee.  
To restore filesystem integrity on a careful-write filesystem like  
most unix filesystems, you have to disable write-caching in the  
drive. This causes such a drastic loss of performance (you basically  
get only one sequential write per disk revolution), that you must  
then implement command-queuing to allow the drive to gather  
sequential writes to make the system usable.

As an alternative, if you have a journalling filesystem, you can  
leave the disk cache enabled but selectively write-through your  
metadata using force-unit-access (FUA).

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


