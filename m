From: "Majed B." <majedb@gmail.com>
Subject: Re: Growing after replacing with larger discs
Date: Sat, 13 Mar 2010 21:22:14 +0300
Message-ID: <70ed7c3e1003131022o78b065b3oadeb1a309cdc995f@mail.gmail.com>
References: <4B9A7C63.6090202@anonymous.org.uk> <20100312180910.GA12002@maude.comedia.it>
	<4B9BACC4.8030608@anonymous.org.uk> <70ed7c3e1003130721u29cf938ep9313a10078ee5e52@mail.gmail.com>
	<4B9BD5C0.2050902@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9BD5C0.2050902@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

What I meant was: If you use dd to clone an old disk to a new one of a
larger size, metadata isn't where it should be and the new disk won't
be recognized as part of an array.

So if you do that to all disks, then attempt to create a new array on
the new disks, it will cause a resync. And even if it didn't resync,
data mapping may be incorrect.

=46or argument's sake, let's assume that cloning the disks would work.
It means cloning 3 disks.

The other option that you presented, which I hope you avoid, is
degrading the array and presenting the new disks. This would also
require 3 resyncs.

The option where you copy the data off the old array then back to the
new one consist of 2 copy operations only. May not be as fast as a dd
operation, but still should consume less time than 3 resyncs.

Also, while copying the original data, if the filesystem has problems,
you'll see them right away and probably identify which files are
affected. I hope everything goes smooth for you, but in case such
problems occur, do NOT run fsck!
Clone the filesystem first for best assurance of data safety.

Good luck!

On Sat, Mar 13, 2010 at 9:13 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 13/03/2010 15:21, Majed B. wrote:
>>
>> You should never degrade the array to copy its contents. Its very
>> risky. There might be bad sectors on one or more disks and if you
>> don't have all disks at hand, you may not be able to rebuild the arr=
ay
>> on the new disk.
>
> OK that's fair, you're right I don't want to risk losing data because=
 I was
> using a degraded array.
>
>> As for using dd, as others have pointed, the metadata won't be in
>> place and if you create a new array after using dd, it'll still
>> require a resync and the data will be destroyed.
>
> I don't see whay either it'd require a resync - although I didn't say=
 it, I
> was planning to zero the rest of the larger drives and recreate with
> --assume-clean - nor why data would be destroyed if I didn't create w=
ith
> --assume-clean, after all the data will all be in the right place.
>
> But I think on balance I'm going to save the contents of the original=
 array
> to an extra drive, create a new array on the big discs, and copy the =
data
> back. It shouldn't take too much more time than copying the discs
> individually with dd, even though I'm copying the data twice rather t=
han
> once, and it's both safer and gives me a free defrag.
>
> Cheers,
>
> John.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
