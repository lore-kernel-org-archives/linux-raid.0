From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Is there a drive error "retry" parameter?
Date: Wed, 15 Jun 2005 02:46:03 +0400
Message-ID: <42AF5E2B.3010908@tls.msk.ru>
References: <200505021224.35396.mlaks@verizon.net> <429F2458.6070404@update.fsix.com> <429F3ED5.4020005@tls.msk.ru> <42AF51CD.7050102@update.fsix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AF51CD.7050102@update.fsix.com>
Sender: linux-raid-owner@vger.kernel.org
To: cknowlton@science.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Knowlton wrote:
> Hi Michael,
> 
> Michael Tokarev wrote:
[]

> Maybe you can help me clarify some other misconceptions I have.  For 
> instance, I had heard that with most modern hard disks, when they run 
> into a bad sector, they will map around that sector, and copy the data 
> to another place on the disk.  Do you know if this is true?  If so, how 
> does this impact RAID? (ie, Is RAID benefited by this, or does it 
> override it?)

There are two types of *read* failure possible.

One is when a drive, by its own, probably after several retries,
is finally able to read that bad block.  In that case, it will be
able to reallocate said block to some other place, without losing
any data.

And another type is when the drive can not recover whatever data
has been written to that block.  In that case, the drive, obviously,
is unable to reallocate that block, at least automatically, without
losing some data, and it should NOT reallocate the block without
telling to the operating system.

Unfortunately, the latter kind of failure occurs more often than
the former.  And the drive - at least fair one - has no other
choice but return some "read error" to the OS in that case,
and leaving the block alone, in case the OS will not react
properly (which is "properly"?) and will try to read the same
block again after a while.

So, to answer your first question, it's both yes and no.  Yes,
most drives do have such an ability, in particular, all SCSI
drives I know supports read-error relocation.  And no, because
in most cases the drive can't recover the bad block anyway,
so there's nothing to reallocate.

Ofcourse such reallocation - again, fair one, where drive will
not silently zero-fill the missin bits while relocating -- helps
both raid (software or hardware, does not matter) and any other
subsystem which is using it (it does not really matter if it's
raid or something else), in a transparent way.

(For completness: there's another reallocation feature supporting
by most drives - write-error relocation, when a drive relocates
bad block on *write* error, because it knows which data should be
there.  A block that was unreadable may become good again after
re-write, either "just because", after refreshing its pieces,
it is now in cleaner state, or because the write-error relocation
mechanism in the drive did its work.  That's why re-writing
a drive with bad blocks often results in a good drive, and often
that good state persists; it's more or less normal for a drive
to develop one or two bad blocks during its lifetime and reallocate
them.)

>>> Is there a "retry" parameter that can be set in the kernel parameters,
>>> or else in the code itself to prolong the existence of a drive in an
>>> array before it is considered dirty?
>>
>> There's no such parameter currently.  But there was several discussions
>> about how to make raid code more robust - in particular, in case of
>> read error, raid code may keep the errored drive in the array and mark
>> it dirty only in case of write error.
>>
> That would be nice.  Do you know if anyone has done any work toward such 
> a fix?

Looks like this is a "FAQ #1" candidate for linux softraid ;)
I tried to do just that myself, with a help from Peter T. Breuer.
The code even worked here on a test machine for some time.
But it's umm.. quite a bit ugly, and Neil is going to slightly
different direction (which I for one don't like much - the
persistent bitmaps stuff, -- I think simpler approach is better).

>>> If so, I would like to increase it in my environment, because it seems
>>> like I'm losing drives in my array that are often still quite stable.
>>
>> I think you have to provide some more information.  Kernel logging tells
>> alot of details about what exactly happening and what the raid code is
>> doing as a result of that.
>>
> Unfortunately, I don't have the logs handy, but I'll post something next 
> time I see it.   I built several RAID servers for some customers over a 
> year ago, and they have reported drive failures.  We have replaced these 
> and when we tested the old drives they were still in fairly good 
> condition.  So for the last little while, I have just reinserted the 
> drive back into the array, and it usually doesn't cause any trouble 
> again (though occasionally a different drive will fail).  If there is a 
> way to keep the drive in the array a little longer,  when a read error 
> is detected, it would really help!

If memory serves me right, you mentioned *several* drives goes off
all at once.  This is not a bad sector on one drive, it's something
else like bad cabling or power supplies, whatever.

Speaking of drives and bad sectors -- see above.  On SCSI drives
there's a way to see all the relocations (scsiinfo utility for
example).

And yes indeed, it'd be nice to keep the drive in the array in case
of read error, and only kick it off on write errors - huge step in
the right direction.

/mjt
