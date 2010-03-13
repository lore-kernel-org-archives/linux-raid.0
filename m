From: "Majed B." <majedb@gmail.com>
Subject: Re: Growing after replacing with larger discs
Date: Sat, 13 Mar 2010 18:21:53 +0300
Message-ID: <70ed7c3e1003130721u29cf938ep9313a10078ee5e52@mail.gmail.com>
References: <4B9A7C63.6090202@anonymous.org.uk> <20100312180910.GA12002@maude.comedia.it>
	<4B9BACC4.8030608@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9BACC4.8030608@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You should never degrade the array to copy its contents. Its very
risky. There might be bad sectors on one or more disks and if you
don't have all disks at hand, you may not be able to rebuild the array
on the new disk.

As for using dd, as others have pointed, the metadata won't be in
place and if you create a new array after using dd, it'll still
require a resync and the data will be destroyed.

On Sat, Mar 13, 2010 at 6:18 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 12/03/2010 18:09, Luca Berra wrote:
>>
>> On Fri, Mar 12, 2010 at 05:39:47PM +0000, John Robinson wrote:
>>>
>>> Before I have to go to a customer's premises and try it, I wanted t=
o ask
>>> if anyone had already done anything like this: I have a CentOS 5 sy=
stem with
>>> 0.90 metadata and type fd partitions with RAID-5 over 3 discs. I wa=
nt to
>>> grow it by replacing the drives. If I dd the small partitions onto =
larger
>>> ones on the new discs, then reboot, will the system recognise the R=
AID-5 -
>>> which now has its metadata somewhere in the middle of the paritions=
 not at
>>> the end - so that I can then --grow?
>>
>> I believe it won't work
>> mdadm has no way to know where the metadata is in the above case.
>>
>> you have to follow the painful procedure
>> fail one drive (mdadm /dev/mdX --fail /dev/sdY)
>> remove it (mdadm /dev/mdX --remove /dev/sdY)
>> replace drive with larger one
>> create larger partition
>> add drive again (mdadm /dev/mdX --add /dev/sdY)
>> wait for it to resync...
>> ...and repeat until all drives have been replaced
>
> Yeuch. That'll take forever, because I'd need to rebuild 3 times. I s=
ee two
> other options:
> (1) dd the drives as I said originally, and when the system can't fin=
d the
> array on the bigger discs, recreate the array using the same options =
the
> original array had
> (2) degrade the existing array to two discs, replace the soft-failed =
disc
> with one of the new discs, temporarily make a filesystem on it, copy =
the
> data; replace the other two discs, make a new array on them with a mi=
ssing
> drive, copy the data back; scrub the temporarily-made filesystem and =
add the
> drive to the array.
>
> Actually I think something along the lines of Majed B's suggestion - =
in this
> case hang a spare drive out the side of the chassis, and just copy tw=
ice -
> would be quicker than (2). But (1) should work, shouldn't it?
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
