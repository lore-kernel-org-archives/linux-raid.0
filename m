From: David Brown <david@westcontrol.com>
Subject: Re: expand raid10
Date: Thu, 14 Apr 2011 10:16:43 +0200
Message-ID: <io6adm$2q5$1@dough.gmane.org>
References: <BANLkTimFwM0m3jT4mg8ZL4VvSXkbi4pU6g@mail.gmail.com>	<BANLkTimqdD39TgbghGi3hK4b1gh1FmcmdQ@mail.gmail.com>	<BANLkTi=udXzNJwK9CKtK1QEqK1PznSp_2g@mail.gmail.com>	<20110413111015.GA10195@www2.open-std.org>	<20110413211715.286d9203@notabene.brown>	<io454g$fq3$1@dough.gmane.org> <20110414093657.1e848952@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110414093657.1e848952@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/04/2011 01:36, NeilBrown wrote:
> On Wed, 13 Apr 2011 14:34:15 +0200 David Brown<david@westcontrol.com>=
  wrote:
>
>> On 13/04/2011 13:17, NeilBrown wrote:
>>> On Wed, 13 Apr 2011 13:10:16 +0200 Keld J=F8rn Simonsen<keld@keldix=
=2Ecom>   wrote:
>>>
>>>> On Wed, Apr 13, 2011 at 07:47:26AM -0300, Roberto Spadim wrote:
>>>>> raid10 with other layout i could expand?
>>>>
>>>> My understanding is that you currently cannot expand raid10.
>>>> but there are things in the works. Expansion of raid10,far
>>>> was not on the list from neil, raid10,near was. But it should be f=
airly
>>>> easy to expand raid10,far. You can just treat one of the copies as=
 your
>>>> refence data, and copy that data to the other raid0-like parts of =
the
>>>> array.  I wonder if Neil thinks he could leave that as an exersize=
 for
>>>> me to implement... I would like  to be able to combine it with a
>>>> reformat to a more robust layout of raid10,far that in some cases =
can survive more
>>>> than one disk failure.
>>>>
>>>
>>> I'm very happy for anyone to offer to implement anything.
>>>
>>> I will of course require the code to be of reasonable quality befor=
e I accept
>>> it, but I'm also happy to give helpful review comments and guidance=
=2E
>>>
>>> So don't wait for permission, if you want to try implementing somet=
hing, just
>>> do it.
>>>
>>> Equally if there is something that I particularly want done I won't=
 wait for
>>> ever for someone else who says they are working on it.  But RAID10 =
reshape is
>>> a long way from the top of my list.
>>>
>>
>> I know you have other exciting things on your to-do list - there was
>> lots in your roadmap thread a while back.
>>
>> But I'd like to put in a word for raid10,far - it is an excellent ch=
oice
>> of layout for small or medium systems with a combination of redundan=
cy
>> and near-raid0 speed.  It is especially ideal for 2 or 3 disk system=
s.
>> The only disadvantage is that it can't be resized or re-shaped.  The
>> algorithm suggested by Keld sounds simple to implement, but it would
>> leave the disks in a non-redundant state during the resize/reshape.
>> That would be good enough for some uses (and better than nothing), b=
ut
>> not good enough for all uses.  It may also be scalable to include bo=
th
>> resizing (replacing each disk with a bigger one) and adding another =
disk
>> to the array.
>>
>> Currently, it /is/ possible to get an approximate raid10,far layout =
that
>> is resizeable and reshapeable.  You can divide the member disks into=
 two
>> partitions and pair them off appropriately in mirrors.  Then use the=
se
>> mirrors to form a degraded raid5 with "parity-last" layout and a mis=
sing
>> last disk - this is, as far as I can see, equivalent to a raid0 layo=
ut
>> but can be re-shaped to more disks and resized to use bigger disks.
>>
>
> There is an interesting idea in here....
>
> Currently if the devices in an md/raid array with redundancy (1,4,5,6=
,10) are
> of difference sizes, they are all treated as being the size of the sm=
allest
> device.
> However this doesn't really make sense for RAID10-far.
>
> For RAID10-far, it would make the offset where the second slab of dat=
a
> appeared not be 50% of the smallest device (in the far-2 case), but 5=
0% of
> the current device.
>
> Then replacing all the devices in a RAID10-far with larger devices wo=
uld mean
> that the size of the array could then be increased with no further da=
ta
> rearrangement.
>
> A lot of care would be needed to implement this as the assumption tha=
t all
> drives are only as big as the smallest is pretty deep.  But it could =
be done
> and would be sensible.
>
> That would make point 2 of http://neil.brown.name/blog/20110216044002=
#11 a
> lot simpler.
>

I'd like to share an idea here for a slight change in the metadata, and=
=20
an algorithm that I think can be used for resizing raid10,far.  I=20
apologise if I've got my terminology wrong, or if it sounds like I'm=20
teaching my grandmother to suck eggs.

I think you want to make a distinction between the size of the=20
underlying device (disk, partition, lvm device, other md raid), the siz=
e=20
of the components actually used, and the position of the mirror copy in=
=20
raid10.

I see it as perfectly reasonable to assume that the used component size=
=20
is the same for all devices in an array, and that this only changes whe=
n=20
you "grow" the array itself (assuming the underlying devices are=20
bigger).  That's the way raid 1, 4, 5, and 6 work, and I think that=20
assumption would help make 10 growable.  It is also, AFAIU, the reason=20
normal raid 0 isn't growable - because it doesn't have that restriction=
=2E=20
  (Maybe raid0 can be made growable for cases where the component sizes=
=20
are the same?)

To make raid10, far resizeable, I think the key is that instead of=20
"position of second copy" being fixed at 50% of the array component=20
size, or 50% of the underlying device size, it should be variable.  In=20
fact, not only should it be variable - it should consist of two (start,=
=20
length) pairs.

The issue here is that to do a safe grow after resizing the underlying=20
device (this being the most awkward case), the mirror copy has to be=20
moved rather than deleted and re-written - otherwise you lose your=20
redundancy.  But if you keep track of two valid regions, it becomes=20
easier.  In the most common case, growing the disk, you would start at=20
the end.  Copy a block from the end of the component part of the mirror=
=20
to the appropriate place near the end of the new underlying device.=20
Update the second (start, length) pair to include this block, and the=20
first (start, length) pair to remove it.  Repeat the process until you=20
have copied over everything valid and then have a device with a first=20
data block, then some unused space, then a mirror block, then some=20
unused space.  Once every underlying device is in this shape, then a=20
"grow" is just a straight sync of the unused space (or you just mark it=
=20
in the non-sync bitmap).

Let me try to put it into a picture.  I'll label all the real data=20
blocks by letters, and use "." for unused data blocks.  Small letters=20
and big letters represent the same data in two copies.  "*" is for=20
non-sync bitmap data, or data that must be synced normally (if the=20
non-sync bitmap functionality is not yet implemented).

The list of numbers after the disks is:

Size of underlying disk, size of component, (start, length), (start, le=
ngth)

We start with a raid10,far layout:

1: acegikBDFHJL		12, 6, (6, 6), (0, 0)
2: bdfhjlACEGIK		12, 6, (6, 6), (0, 0)

Then we assume disk 2 is grown (either it is an LVM partition, a raid=20
that is grown, or whatever).  Thus we have:

1: acegikBDFHJL			12, 6, (6, 6), (0, 0)
2: bdfhjlACEGIK......		18, 6, (6, 6), (0, 0)

Rebalancing disk 2 (which may be done as its own operation, or=20
automatically during a "grow" of the whole array - assuming each=20
component disk has enough space) goes through steps like this:

2: bdfhjlACEGIK......		18, 6, (6, 6), (0, 0)
2: bdfhjlACEGIK.IK...		18, 6, (6, 6), (13, 2)
2: bdfhjlACEG...IK...		18, 6, (6, 4), (13, 2)
2: bdfhjlACEG.EGIK...		18, 6, (6, 4), (11, 4)
2: bdfhjlAC...EGIK...		18, 6, (6, 2), (11, 4)
2: bdfhjlAC.ACEGIK...		18, 6, (6, 2), (9, 6)
2: bdfhjl...ACEGIK...		18, 6, (6, 0), (9, 6)
2: bdfhjl...ACEGIK...		18, 6, (9, 6), (0, 0)

With the pair now being:

1: acegikBDFHJL			12, 6, (6, 6), (0, 0)
2: bdfhjl...ACEGIK...		18, 6, (9, 6), (0, 0)

After a similar process with disk 1 we have:

1: acegik...BDFHJL...		18, 6, (9, 6), (0, 0)
2: bdfhjl...ACEGIK...		18, 6, (9, 6), (0, 0)

"Grow" gives you:

1: acegik***BDFHJL***		18, 9, (9, 9), (0, 0)
2: bdfhjl***ACEGIK***		18, 9, (9, 9), (0, 0)


A similar sort of sequence is easy to imagine for shrinking partitions.=
=20
  And when replacing a disk with a new one, this re-shape could easily=20
be combined with a hot-replace copy.

As far as I can see, this setup with the extra metadata will hold=20
everything consistent, safe and redundant during the whole operation.


mvh.,

David

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
