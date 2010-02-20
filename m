From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why does one get mismatches?
Date: Sat, 20 Feb 2010 05:23:04 +0100
Message-ID: <87ocjkzgbb.fsf@frosties.localdomain>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
	<4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown>
	<4B684087.50001@tmr.com> <20100211161444.7a0ea7bb@notabene.brown>
	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
	<4B7B0D45.7040801@tmr.com>
	<6db64f7872286165ac1fd3436e9d6476@localhost>
	<20100218100547.7aecdc34@notabene.brown>
	<20100219151809.GB4995@lazy.lzy>
	<20100220090208.06c1130f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100220090208.06c1130f@notabene.brown> (Neil Brown's message of
	"Sat, 20 Feb 2010 09:02:08 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Fri, 19 Feb 2010 16:18:09 +0100
> Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:
>
>> Hi,
>> 
>> > When memory changes between being written to one device and to another, this
>> > does not cause corruption, only inconsistency.   Either the block will be
>> > written again consistently soon, or it will never be read.
>> 
>> well, is this for sure?
>> I mean, by design of the md subsystem.
>> 
>> Or it is like that because we trust the filesystem?
>
> It is because we trust the filesystem.
>
>> 
>> And why it is like that? Why not to use the good old
>> readers-writer mechanism to make sure all blocks are
>> the same, when they're are written (namely lock).
>
> md is not in a position to lock the page - there is simply no way it can stop
> the filesystem from changing it.
> The only thing it could do would be to make a copy, then write the copy out.
> This would incur a performance cost.
>
>> 
>> It seems to me, maybe I'm wrong, not a so safe design.
>
> I think you are wrong.

No, he is right. The safe design is to copy or at least copy-on-write
the page. Maybe this could be configurable so people can choose between
really safe and fast.

>> I assume, it should not be possible to cause this
>> situation, unless there is a crash or a bug in the
>> md layer.
>
> I'm not sure what situation you are referring to...
>
>> 
>> What if a new filesystem will write a block, changing
>> on the fly, i.e. during RAID-1 writes, and then, later,
>> reading this block again?
>> 
>> It will get, maybe, not the correct data.
>
> This is correct.  However it would be equally correct if you were talking
> about s normal disk drive rather than a RAID1 pair.
> If the filesystem changes the page (or allows it to change) while a write is
> pending, then it cannot know what actual data was written.  So it must write
> the block out again before it ever reads it in.
> RAID1 is no different to any other device in this respect.
>
>
>> 
>> In other words, would it be better, for the md layer,
>> to be robust against these kind of threats?
>>
>
> Possibly, but at what cost?
> There are two ways that I can imagine to 'solve' this issue.
>
> 1/ always copy the page before writing.  This would incur a significant
>   overhead, both in the complexity of pre-allocation memory and in the
>   delay taken to perform the copy.  And it would very rarely be actually
>   needed.
> 2/ Have the filesystem protect the page from changes while it is being
>    written.  This is quite possible for the filesystem to do (while it
>    is impossible for md to do).  There could be some performance
>    cost with memory-mapped pages as they would need to be unmapped,
>    but there would be no significant cost for reads, writes, and filesystem
>    metadata operations.
>    Further, any filesystem that wants to make use of the integrity checks
>    that newer drives provide (where the filesystem provides a 'checksum' for
>    the block which gets passed all the way down and written to storage, and
>    returned on a read) will need to do this anyway.  So it is likely the in
>    the near future all significant filesystems will provide all the
>    guarantees md needs or order to simply do nothing different.
>
> So my feeling is that md is doing the best thing already.
>
> I believe 'swap' will always be an issue as unmapping swap pages during write
> could be a serious performance cost.  It might be that the best thing to do
> with swap is to somehow mark the area of an array used for swap as "don't
> care" so md never bothers to resync it, and never reports inconsistencies
> there, as they really are not an issue.
>
> NeilBrown

Or one could turn on the copy/copy-on-write mode at least during the
test.

I'm also not convinced performance of swap is an issue. Swap speed is
already many magnitudes lower than real memory making any relevant use
of swap prohibitive. I certainly would not care one bit or another if
swapping gets 50% slower. I do care about not having a mismatch count
though.

MfG
        Goswin
