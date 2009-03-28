From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: RAID5 -> RAID6
Date: Sat, 28 Mar 2009 22:54:56 +0200
Message-ID: <49CE8EA0.9080704@fastmail.co.uk>
References: <49CE20B3.9010101@fastmail.co.uk> <a741976bf24fa274ac54be1f31d8bc2e.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a741976bf24fa274ac54be1f31d8bc2e.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> Wait 3 months :-)
>   

Sounds good. I'm in no particular hurry. Increasing capacity would be 
nice, but I'm not sure I want to do that since I only have a 1TB drive 
for backup...as such, the slow version of 1a/ sounds reasonable - I have 
a spare 80GB drive in the same machine that I could make use of to make 
it not-so-dangerous.

I guess I might consider a grow too - perhaps I'll have another drive by 
then so my backup can be bigger.

Thanks for the advice...I'll keep an eye out for the new support.

Max.

> 2.6.30 should contains support for this sort of conversion.  It is
> already written (mostly) but still needs some testing.
>
>
> Your options would then include:
>  1/  convert that raid5 to a raid6 of the same size but with one
>      extra device.  This device would store all the 'Q' blocks so
>      it could become a write bottle neck
>  1a/ as above, but then restripe the array so that the Q block is
>      rotated among the drives.  This process is either dangerous - in
>      that a crash would kill your data, or slow - in that all the data
>      would need to be copied elsewhere in chunks while the corresponding
>      chunk of the array was restriped.
>  2/  convert to raid6 and grow at the same time.  i.e. add both spares
>      using one of them to support the conversion to raid6 and the
>      other to increase the space.  You could then arrange to restripe
>      an grow at the same time which is faster/safer than striping in-place.
>  3/  Possibly you could restripe-and-grow, then restripe-and-shrink
>      so you end up with a 7 device RAID6 with properly rotating parity,
>      but don't go through the slow/dangerous restripe-in-place.
>      I'll need to do some experiments to see if that would actually
>      be faster
