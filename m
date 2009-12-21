From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Typical RAID5 transfer speeds
Date: Mon, 21 Dec 2009 14:06:21 +0100
Message-ID: <87d428o4s2.fsf@frosties.localdomain>
References: <F7.42.01550.D172D2B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7.42.01550.D172D2B4@cdptpa-omtalb.mail.rr.com> (Leslie Rhorer's
	message of "Sat, 19 Dec 2009 13:18:50 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Leslie Rhorer" <lrhorer@satx.rr.com> writes:

>> On 19/12/2009 01:05, Bernd Schubert wrote:
>> > On Saturday 19 December 2009, Matt Tehonica wrote:
>> >> I have a 4 disk RAID5 using a 2048K chunk size and using XFS
>> >
>> > 4 disks is a bad idea. You should have 2^n data disks, but you have 2^1
>> + 1 =
>> > 3 data disks. As parity information are calculated in the power of two
>> and
>> > blocks are written in the power of two
>> 
>> Sorry, but where did you get that from? p = d1 xor d2 xor d3 has nothing
>> to do with powers of two, and I'm sure blocks are written whenever they
>> need to be, not in powers of two.
>
> 	Yeah, I was scratching my head over that one, too.  It sounded bogus
> to me, but I didn't want to open my mouth, so to speak, when I was unsure of
> myself.  Being far from expert in the matter, I can't be certain, but I
> surely can think of no reason why writes would occur in powers of two, or
> even be more efficient because of it.

But d1/2/3 and p are 2^n bytes large. So a stripe is 3*2^n byte while
the filesystem alignes its data to 2^m boundaries usualy.

So writes of 1/2/4/8/16/32/64 MB sequentially are more likely than
3/6/12/24/48 MB. Often a (large) write will have a partial stripe at
the start and end of the request.

>> > you probably have read operations,
>> > when you only want to write.
>> 
>> That will depend on how much data you're trying to write. With 3 data
>> discs and a 2M chunk size, writes in multiples of 6M won't need reads.

That assumes the filesystem puts a 6M sequential write to 6M
sequential blocks. I.e. is not fragmented. That never lasts long.

>> Writing a 25M file would therefore write 4 stripes and need to read to
>> do the last 1M. With 4 data discs, it'd be 8M multiples, and you'd write
>> 3 stripes and need a read to do the last 1M. No difference.
>
> 	I hadn't really considered this before, and I am curious.  Of course
> there is no reason for md to read a stripe marked as being in use if the
> data to be written will fill an entire stripe.  However, does it only apply
> this logic if the data will completely fill a stripe?  The most efficient
> use of disk space of course will be accomplished if the system reads the
> potential partially used target stripe whenever the write buffer contains
> even 1 chunk less than a full stripe, but the most efficient write speeds
> will only check on writing to a partially used stripe if the write buffer
> contains less than half a stripe worth of data.  Does anyone know which is
> the case?

I only know that in the raid6 case it always reads all data blocks and
recomputes the parity while raid5 iirc can update the parity by xoring
the old and new data block without having to read all data blocks of a
stripe. But I have no idea where the cutoff would be for this.

MfG
        Goswin
