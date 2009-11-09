From: "NeilBrown" <neilb@suse.de>
Subject: Re: mismatch_cnt again
Date: Tue, 10 Nov 2009 08:50:49 +1100
Message-ID: <df8de4eb79e2bf13d0e5c2c83cdc7cf1.squirrel@neil.brown.name>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>
    <4AF5268D.60900@eyal.emu.id.au>
    <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>
    <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>
    <87iqdlaujb.fsf@frosties.localdomain> <20091108160433.GA5338@lazy.lzy>
    <4AF85DCB.3030909@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF85DCB.3030909@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, November 10, 2009 5:22 am, Bill Davidsen wrote:
> Piergiorgio Sartor wrote:
>> Hi,
>>
>>
>>> But unless your drive firmware is broken the drive with only ever give
>>> the correct data or an error. Smart has a counter for blocks that have
>>> gone bad and will be fixed pending a write to them:
>>> Current_Pending_Sector.
>>>
>>> The only way the drive should be able to give you bad data is if
>>> multiple bits toggle in such a way that the ECC still fits.
>>>
>>
>> Not really, I've disks which are *perfect* in smart sense
>> and nevertheless I had mistmatch count.
>> This was a SW problem, I think now fixed, in RAID-10 code.
>>
>>
> IIRC there still is an error in raid-1 code, in that data is written to
> multiple drives without preventing modification of the memory between
> writes. As I understand Neil's explanation, this happens (a) when memory
> is being changed rapidly and frequently via memory mapped files, or (b)
> writing via O_DIRECT, or (c) when raid-1 is being used for swap. I'm not
> totally sure why the last one, but I have always seem mismatches on swap
> in a system which is actually swapping. What is more troubling is that
> if I do a hibernate, which writes to swap, and then force a boot from
> other media to a Live-CD, doing a check of the swap array occasionally
> shows a mismatch. That doesn't give me a secure feeling, although I have
> never had an issue in practice, I was just curious.

I don't think this is really an error in the RAID1 code.
The only thing that the RAID1 code could do differently is make a local
copy of the data and then write that to all of the devices (a bit like
RAID5 does so it can generate a parity block reliably).
Doing this would introduce a performance penalty with not real
benefit (the only benefit would be to stop long email threads about
mismatch_cnt :-)

You could possibly argue that it is a weakness in the interface to block
devices that the block device cannot ask for the buffer to be guaranteed
to be stable for the duration of the write, but as there is little real
need for that and it would probably be fairly hard to implement both
efficiently and generally.

A filesystem is well placed to do this sort of thing and it is quite
likely that BTRFS does something appropriate to ensure that the block
checksums it creates are reliable.
All the filesystem needs to do is forcibly unmap the page from any
process address space and make sure it doesn't get remapped or otherwise
modified until the write completes.

The (c) option is actually the most likely to cause inconsistencies.
If a page is modified while being written out to swap, the swap
system will effective forget that it ever tried to write it so
any inconsistency is likely to remain (but never be read, so there
is no problem).
With a filesystem, if the page is changed while being written, it is
very likely that the filesystem will try to write the page to the same
location again, thus fixing the inconsistency.

When suspend-to-disk writes to swap, it stops all changes from happening
and then writes the data and waits for it to complete, so you will never
find inconsistencies in blocks on swap that actually contain a
suspend-to-disk image.

NeilBrown



>
>> This means that, yes, there could be mismatches, without
>> any warning, from other sources than disks.
>> And these could be anywhere in the system.
>> I already mentioned, time ago, a cabling problem which was
>> leading to a similar result: wrong data on different disks,
>> without any warning or error from the HW layer.
>>
>> That is why it is important to know *where* the mismatch
>> occurs and, if possible, in which device component.
>> If it is an empty part of the FS, no problem, if it
>> belongs to a specific file, then it would be possible
>> to restore/recreate it.
>>
>> Of course, a tool will be needed telling which file is
>> using a certain block of the device.
>>
>
> There are tools which claim to do that, or list blocks used in a given
> file, which is not nearly as useful, but easier to do.
>
> --
> Bill Davidsen <davidsen@tmr.com>
>   "We can't solve today's problems by using the same thinking we
>    used in creating them." - Einstein
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

