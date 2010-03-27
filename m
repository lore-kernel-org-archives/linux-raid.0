From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: metadata 1.2
Date: Sat, 27 Mar 2010 02:31:35 -0700
Message-ID: <4877c76c1003270231j58767878w77886a1226fa33a2@mail.gmail.com>
References: <20100326194352.GA2474@lazy.lzy>
	 <4877c76c1003261849k9219c1eq7e8ebde088b619df@mail.gmail.com>
	 <20100327091658.GA2333@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100327091658.GA2333@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 27, 2010 at 2:16 AM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi,
>
>> Even grub 'legacy' 0.9x can perform in the following configuration:
>>
>> Several whole device in a RAID-1 units which are partitioned via som=
e
>> other means internally. =A0Grub can map the package it needs to load=
 in
>> to memory as a series of absolute block locations and embed that
>> information within even the normal boot-loader area, or boot-loader
>> area and 1/2 more sectors with ease.
>>
>> This may be more difficult with raid-10 or raid-0 sets, and
>> considerably more difficult with raid-456 (grub would not have
>> redundancy at it's level of operation, but you could use an external
>> system and still effect data /recovery/ at which point it'd then
>> work...); however I see no reason it would be technically impossible=
,
>> though I don't expect it to have been a current usage consideration.
>
> well, I just tried grub2, but it seems the raid.mod
> is a bit bigger than 5K, so it is not possible to put
> it in the 4K left.
> Not to mention LVM on RAID, which makes, in lvm.mod
> and raid.mod, more or less 12K.
> Actually, grub-install itself complains that the
> embedding is not possible.
>
> The "default" core.img of grub2 is around about 28K,
> which is a little bit less than the 32K normal
> partiniong leaves between the MBR and the actual data.
>
> Bottom line is that, it seems to me, it is impossible
> to have a partionless system with RAID, let's say, 5.
> I wondered why 4K?
>
> So, would it be better to have a metadata 1.3 with a 32K
> offset for the superblock, so there could be enough space
> for something like grub2?
>
> Actually, I would like to propose metadata 2.0, or
> dual RAID, where the superblock is located somewhere
> in the disk(s), the space before will have one type
> of RAID and the space after possibly another type.
> The use case will be: RAID-1 before, RAID-x after, so
> a clever bootmanager could sit in the space before,
> the system will be partionless, the hot-plug add,
> which seems a topic, will be by far easier and we
> will get rid off the legacy partioning thing (LVM
> or mdp will do the trick).
>
>> Oh, it's also possible to chainload, so the 1.2 format offers the sa=
me
>> benefits on partitions if you need to operate within the constraints
>> of other existing boot-loaders.
>
> Wouldn't this still require partions somewhere?
>
> bye,
>
> --
>
> piergiorgio
>

I forget the commands, but the key thing for grub2 is stuffing all of
the modules you need in to a single loadable image, and invoking the
grub2 install command to embed THAT image.  It's then supposed to
deduce the blocks on disk that the image occupies and load it.  That
should work for raid1 and cases where the image is on a single real
device.  I don't know how it would cope with possibly bios-shuffled
real devices though.  I suspect supporting that wouldn't be worth it.

In any event, the 4k offset code is still useful for raid 1 arrays,
and supporting secondary MBR points that can be chained by grub/other
bootloaders when combined with partitioning.  It MAY also work if you
create the file just right and it's either beneath the chunk size, or
structured in such a way that it's duplicated (redundantly) across all
of the data devices; however even then you'd need to examine the raw
device and map out the parity block; it should wind up as two load
segments though.  Such support is just one potential solution, not
something I'd expect to exist at this moment.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
