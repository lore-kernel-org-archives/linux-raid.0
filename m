From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: metadata 1.2
Date: Sat, 27 Mar 2010 10:16:58 +0100
Message-ID: <20100327091658.GA2333@lazy.lzy>
References: <20100326194352.GA2474@lazy.lzy>
 <4877c76c1003261849k9219c1eq7e8ebde088b619df@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4877c76c1003261849k9219c1eq7e8ebde088b619df@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> Even grub 'legacy' 0.9x can perform in the following configuration:
> 
> Several whole device in a RAID-1 units which are partitioned via some
> other means internally.  Grub can map the package it needs to load in
> to memory as a series of absolute block locations and embed that
> information within even the normal boot-loader area, or boot-loader
> area and 1/2 more sectors with ease.
> 
> This may be more difficult with raid-10 or raid-0 sets, and
> considerably more difficult with raid-456 (grub would not have
> redundancy at it's level of operation, but you could use an external
> system and still effect data /recovery/ at which point it'd then
> work...); however I see no reason it would be technically impossible,
> though I don't expect it to have been a current usage consideration.

well, I just tried grub2, but it seems the raid.mod
is a bit bigger than 5K, so it is not possible to put
it in the 4K left.
Not to mention LVM on RAID, which makes, in lvm.mod
and raid.mod, more or less 12K.
Actually, grub-install itself complains that the
embedding is not possible.

The "default" core.img of grub2 is around about 28K,
which is a little bit less than the 32K normal
partiniong leaves between the MBR and the actual data.

Bottom line is that, it seems to me, it is impossible
to have a partionless system with RAID, let's say, 5.
I wondered why 4K?

So, would it be better to have a metadata 1.3 with a 32K
offset for the superblock, so there could be enough space
for something like grub2?

Actually, I would like to propose metadata 2.0, or
dual RAID, where the superblock is located somewhere
in the disk(s), the space before will have one type
of RAID and the space after possibly another type.
The use case will be: RAID-1 before, RAID-x after, so
a clever bootmanager could sit in the space before,
the system will be partionless, the hot-plug add,
which seems a topic, will be by far easier and we
will get rid off the legacy partioning thing (LVM
or mdp will do the trick).

> Oh, it's also possible to chainload, so the 1.2 format offers the same
> benefits on partitions if you need to operate within the constraints
> of other existing boot-loaders.

Wouldn't this still require partions somewhere?

bye,

-- 

piergiorgio
