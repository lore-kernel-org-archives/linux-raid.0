From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch checksum
Date: Thu, 6 Nov 2014 07:54:08 +0530
Message-ID: <CAK-d5daV0jixRD-0AhOjniWanhprLqZPxJ6F8X7ZiD0ROYE0Nw@mail.gmail.com>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
 <20141029200501.1f01269d@notabene.brown> <CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
 <CAK-d5dYm7tEY855w1CdkvPz22ukkg1DwGz_mQ_9-JRV0M=O6Rw@mail.gmail.com> <20141103165217.3bfd3d3e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141103165217.3bfd3d3e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Pls see below

On 3 November 2014 11:22, NeilBrown <neilb@suse.de> wrote:
> On Thu, 30 Oct 2014 20:30:40 +0530 Anshuman Aggarwal
> <anshuman.aggarwal@gmail.com> wrote:
>
>> Would chunksize==disksize work? Wouldn't that lead to the entire
>> parity be invalidated for any write to any of the disks (assuming md
>> operates at a chunk level)...also please see my reply below
>
> Operating at a chunk level would be a very poor design choice.  md/raid5
> operates in units of 1 page (4K).
>
>
>>
>> On 29 October 2014 14:55, Anshuman Aggarwal <anshuman.aggarwal@gmail.com> wrote:
>> > Right on most counts but please see comments below.
>> >
>> > On 29 October 2014 14:35, NeilBrown <neilb@suse.de> wrote:
>> >> Just to be sure I understand, you would have N + X devices.  Each of the N
>> >> devices contains an independent filesystem and could be accessed directly if
>> >> needed.  Each of the X devices contains some codes so that if at most X
>> >> devices in total died, you would still be able to recover all of the data.
>> >> If more than X devices failed, you would still get complete data from the
>> >> working devices.
>> >>
>> >> Every update would only write to the particular N device on which it is
>> >> relevant, and  all of the X devices.  So N needs to be quite a bit bigger
>> >> than X for the spin-down to be really worth it.
>> >>
>> >> Am I right so far?
>> >
>> > Perfectly right so far. I typically have a N to X ratio of 4 (4
>> > devices to 1 data) so spin down is totally worth it for data
>> > protection but more on that below.
>> >
>> >>
>> >> For some reason the writes to X are delayed...  I don't really understand
>> >> that part.
>> >
>> > This delay is basically designed around archival devices which are
>> > rarely read from and even more rarely written to. By delaying writes
>> > on 2 criteria ( designated cache buffer filling up or preset time
>> > duration from last write expiring) we can significantly reduce the
>> > writes on the parity device. This assumes that we are ok to lose a
>> > movie or two in case the parity disk is not totally up to date but are
>> > more interested in device longevity.
>> >
>> >>
>> >> Sounds like multi-parity RAID6 with no parity rotation and
>> >>   chunksize == devicesize
>> > RAID6 would present us with a joint device and currently only allows
>> > writes to that directly, yes? Any writes will be striped.
>
> If the chunksize equals the device size, then you need a very large write for
> it to be striped.
>
>> > In any case would md raid allow the underlying device to be written to
>> > directly? Also how would it know that the device has been written to
>> > and hence parity has to be updated? What about the superblock which
>> > the FS would not know about?
>
> No, you wouldn't write to the underlying device.  You would carefully
> partition the RAID5 so each partition aligns exactly with an underlying
> device.  Then write to the partition.

This is what I'm unclear about. Even with non rotating parity on RAID
5/6 is it possible to create md partitions such that the writes are
effectively not striped (within each partition) and that each
partition on the md device ends up writing only to that one device?
How is this managed? My understanding is that raid5/6 will stripe any
data blocks across all the devices making all of them spin up for each
read and write.




>
>> >
>> > Also except for the delayed checksum writing part which would be
>> > significant if one of the objectives is to reduce the amount of
>> > writes. Can we delay that in the code currently for RAID6? I
>> > understand the objective of RAID6 is to ensure data recovery and we
>> > are looking at a compromise in this case.
>
> "simple matter of programming"
> Of course there would be a limit to how much data can be buffered in memory
> before it has to be flushed out.
> If you are mostly storing movies, then they are probably too large to
> buffer.  Why not just write them out straight away?

Well, yeah if the buffer gets filled (such as by a movie) the parity
will get written pretty much write away (the main data drive gets
written to immediately anyways). The delay is to prevent parity drive
spin ups due to a small updates on any one of the drives in the array.
Maybe a small temp file created by a software etc.
>
> NeilBrown
>
>
>
>> >
>> > If feasible, this can be an enhancement to MD RAID as well where N
>> > devices are presented instead of a single joint device in case of
>> > raid6 (maybe the multi part device can be individual disks?)
>> >
>> > It will certainly solve my problem of where to store the metadata. I
>> > was currently hoping to just store it as a configuration file to be
>> > read by the initramfs since in this case worst case scenario the
>> > checksum goes out of sync and is rebuilt from scratch.
>> >
>> >>
>> >> I wouldn't use device-mapper myself, but you are unlikely to get an entirely
>> >> impartial opinion from me on that topic.
>> >
>> > I haven't hacked around the kernel internals much so far so will have
>> > to dig out that history. I will welcome any particular links/mail
>> > threads I should look at for guidance (with both yours and opposing
>> > points of view)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
