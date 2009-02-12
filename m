From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 21:40:12 +1100 (EST)
Message-ID: <3a947c3081cd563d233d923cac5738c8.squirrel@neil.brown.name>
References: <20090212031009.23983.14496.stgit@notabene.brown>
    <4993EEEC.2020901@lfarkas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4993EEEC.2020901@lfarkas.org>
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@lfarkas.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, February 12, 2009 8:42 pm, Farkas Levente wrote:
> NeilBrown wrote:
>> Hi,
>>  following is my current patch queue for 2.6.30, in case anyone would
>> like to review or otherwise comment.
>> They should show up in -next shortly.
>>
>> Probably the most interesting are the last few which provide support
>> for converting a raid1 into a raid5, and a raid5 into a raid6.
>> I plan to do some more work here so the code might change a bit before
>> final submission, as I work out how best ot factor the code.
>>
>> mdadm doesn't current support these conversions, but you can
>> simply
>>    echo raid5 > /sys/block/md0/md/level
>> to change a 2-drive raid1 into a raid5.  Similarly for 5->6
>
> any plan for non-raid to raid1 or anything else like in windows on can
> convert a normal partition into a mirrored one online.

No plan exactly, but I do think about it from time to time.

There are two problems with this, and solving just one of them
doesn't help you much.  So you really have to solve both at once,
which reduces the motivation towards either ....

One problem is the task of changing the implementation of the device
underneath the filesystem without the filesystem needing to care.

i.e. the filesystem opens block device 8,1 (/dev/sda1) and starts do
IO, then mdadm steps in and magically changes things so that /dev/sda1
is now on a raid1 array which happens to access the same data, but
through a different code path.
Figuring out exactly which data structure to install the redirection
and how to doing in a way that is guaranteed to be safe is non-trivial.

dm has a mechanism to change the implementation under a given dm
device, and md now has an mechanism to change the implementation
under a given md device.  But generalising that to 'any device' is
not entirely trivial.  Now that I have done it for md I'm in a better
position to understand how it might be done.

The other problem is where to store the metadata.  You need at least a
few bytes and realistically 1K of space on the devices that is free to
be used by md to record information about device state to allow arrays to
be assembled correctly.

One idea I had was to get the filesystem to allocate a block and make that
available to md, then md would copy the data from the last block of the
device into that block and redirect all IO request aim at the
last block so that really access the relocated block.  Then md puts
it's metadata in that last block.

This could work but is a little to error prone for my liking.  e.g.
if you fsck the device, you suddenly loose your guarantee that
the filesystem isn't going to write to that relocation block.

I think it could only work if mdadm can inspect the device and ensure
that the last block isn't part of any partition, or any active filesystem.
This is possible, but messy.

e.g. on my notebook which has a 250Gig drive whatever I used to partition
it (cfdisk?) insisted on using multiples of cylinders for partitions
(what an out-of-date concept!) and as the reported geometry is

Disk /dev/sda: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders

There are 5013 unused sectors at the end - plenty of room for
md to put some metadata.  But if someone else had used sfdisk,
I think they would find no spare space and be unhappy.

Maybe it is sufficient to support just those people who are
lucky enough to not be using the whole device...


So it might happen, but it is just a little to easy to stick this
one in the too-hard basket.

Thanks,
NeilBrown



