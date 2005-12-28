From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: raid1: All my data completely vanished into the void
Date: Wed, 28 Dec 2005 21:34:12 +1100
Message-ID: <87acelse6z.fsf@rimspace.net>
References: <200512280030.51387.mlaks@verizon.net>
	<E1ErULq-0007Nu-5l@highlab.com> <87ek3xsoub.fsf@rimspace.net>
	<doti2m$tu5$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk> writes:
> Daniel Pittman wrote:
>> Sebastian Kuzminsky <seb@highlab.com> writes:
>>> Mitchell Laks <mlaks@verizon.net> wrote:
>>>> What does doing
>>>>
>>>> mdadm -Cv -n2 -l1 /dev/md0 /dev/sda /dev/sdb
>>>>
>>>> do to the partition tables??? (And why can I still access the data
>>>> if I messed up the partitions??? very odd).
>>>> Can you point me at an explanation of the effects of what I did?
>>> I'd expect that command to overwrite the partition table with the
>>> MD metadata, or at least put the partition table at risk of being
>>> overwritten later.
>> Nope: the MD metadata lives at the end of the disk, not the start, so
>> your partition table would still be there when the filesystem wrote over
>> the first block of the disk...
>> ....and, if the partition table lived through that, I guess the
>> filesystem doesn't use (or respects) that block itself.
>
> ...but, just so as I understand, by using the whole disk (ie /dev/sda
> and not /dev/sda1, etc), you're telling md to make the whole disk
> available to your filesystem (or whatever), including the space normally
> used to store the partition table, and so any partition table that
> happens to be on the disk(s) is likely to be over-written.
>
> right?

Yeah, pretty much.  You lose around 128KB from the end of the disk, but
the MD device should start the data at sector zero, right where the
partition table is.

          Daniel

