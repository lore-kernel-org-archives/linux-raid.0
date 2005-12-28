From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: raid1: All my data completely vanished into the void
Date: Wed, 28 Dec 2005 17:44:12 +1100
Message-ID: <87ek3xsoub.fsf@rimspace.net>
References: <200512280030.51387.mlaks@verizon.net>
	<E1ErULq-0007Nu-5l@highlab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sebastian Kuzminsky <seb@highlab.com> writes:
> Mitchell Laks <mlaks@verizon.net> wrote:
>> What does doing
>> 
>> mdadm -Cv -n2 -l1 /dev/md0 /dev/sda /dev/sdb
>> 
>> do to the partition tables??? 
>> (And why can I still access the data if I messed up the partitions??? very 
>> odd).
>> Can you point me at an explanation of the effects of what I did?
>
> I'd expect that command to overwrite the partition table with the
> MD metadata, or at least put the partition table at risk of being
> overwritten later.

Nope: the MD metadata lives at the end of the disk, not the start, so
your partition table would still be there when the filesystem wrote over
the first block of the disk...

...and, if the partition table lived through that, I guess the
filesystem doesn't use (or respects) that block itself.

           Daniel

