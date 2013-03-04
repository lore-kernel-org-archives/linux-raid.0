From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Mon, 04 Mar 2013 07:41:39 -0500
Message-ID: <51349683.4040903@turmel.org>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <513231BB.4070903@turmel.org> <ac5cdf66-ba01-4d7b-bd7b-60fb67517ad
 4@email.android.com> <5133F95A.5040508@turmel.org> <51346BB5.2010403@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51346BB5.2010403@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/04/2013 04:39 AM, Adam Goryachev wrote:

> Probably a silly question, but how do you convert from the
> information: Fast-Root: 0 314572800 linear 9:3 3072 vg0-hostname: 0
> 204808192 linear 147:2 512
> 
> My example was 512 sectors, assuming a sector size of 512 bytes,
> that provides 256kB (as you advised above).
> 
> Your example was 3072 sectors, again assuming a sector size of 512 
> bytes, that becomes 1.5MB (as you stated above).
> 
> So how come my system has an alignment of 256k (1 x offset) while
> yours has 512k (1.5M/3) ?

Alignment is the greatest common multiple of a power of two that the
beginning of the data area falls on.   In practice, that means find the
lowest "1" bit in the binary representation of the starting offset.  I
personally switch to hex, then mentally pick the lowest "1" bit in the
first non-zero digit from the right.

> I'm assuming that in any case, as you suggested, the main thing is
> that the answer I got (256kB offset) was equal to the MD chunk size
> (64kB) multiplied by the number of data drives (4), or 256kB.

Yes.

>>> Also, pvdisplay tells me the PE Size is 4M, so I'm assuming that
>>> regardless of how the LV's are arranged, they will always be 512k
>>> aligned?
>> 
>> 256k, but yeah.
> 
> So LVM will not allocate any LV a block of space smaller than 4M,
> and I'm assuming will always be on a 4M boundary from the beginning
> of the device. Since 4MB is a mulitple of 256kB, then alignment is
> OK?

It will not be on a 4M boundary.  The first PE is at a 256k offset, so
any multiple of 4M added to that will also be 256k aligned.  For you,
that's fine.

> If the MD stripe size was larger, eg, if I added 2 more drives it
> would become 64kB chunk x 6 data drives = 384kB. This would mean my
> LVM is no longer properly aligned. The first block of 4MB would start
> at 256kB which is smaller than the stripe size, and each 4MB block
> would most likely not line up since 4MB is not divisible by 384kB?

Then it gets complicated.  When the # of data drives in parity raid
isn't a power of two, you generally cannot make higher layers
consistently align with the stripe boundaries.  The best you can do is
align to the greatest common power of two of the stripe size.  For your
example, that would be 128k.

> So, if I ever choose to expand the array to include a larger number
> of devices (as opposed to replacing all members with larger drives),
> what would I need to do to fix all this up?
>
> Re-partition to start the partition at a higher starting sector
> (such that 4M / start sector * 512 produces an integer)?

pvcreate can be told what alignment to use.  It will round up to its
requirements, though.  vgcreate can be told what physical extent size to
use.  So you have a great deal of control over these behaviors.  It
can't deal with an odd stripe size, though.

> That resolves the first LVM block, but to ensure all other blocks
> are properly aligned, is the best answer to upgrade to 8 x data
> drives (512kB stripe size)? Or is there some other magic solution I'm
> missing here?

You want data alignment to be greater than or equal to stripe alignment.
 Going to 8 drives would break alignment for your existing PV.

>>> So, is that enough to be sure that this is not an issue?
>> It looks to me like you are good on alignment.
> 
> Thanks.
> 
> On 04/03/13 16:25, Stan Hoeppner wrote:
>> If you have no gaps between this one and your other LVs, and each
>> of them is evenly divisible by 512 sectors, then they should all
>> be aligned.
> 
> Given the 4MB size of the LVM blocks, does that automatically make
> this true? I thought it did, but given your above comment, I'm
> unsure.

Alignment is the lowest power of two of all of the offsets and sizing
multiples.  The 4M PE size is larger than any of the other alignment
factors, so it drops out of the analysis.

HTH,

Phil
