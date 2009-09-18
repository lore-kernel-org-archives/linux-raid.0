From: Tim Bostrom <tbostrom@gmail.com>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Fri, 18 Sep 2009 08:27:08 -0700
Message-ID: <2267211f0909180827jbfa57acqadd308b4b889058c@mail.gmail.com>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
	<20090917212252.GC19611@cthulhu.home.robinhill.me.uk> <2267211f0909171611m4b4a0d02p81b80bc882a0855@mail.gmail.com>
	<70ed7c3e0909171628w4040ae5cydf4335adb51f2b7d@mail.gmail.com>
	<2267211f0909171654v766e658fn620b23268a2393a6@mail.gmail.com>
	<0F9F69CA6B3942B1A44BC0B2D00AE139@m5> <2267211f0909172119w6de04e46m5fcfc5e6d35c0382@mail.gmail.com>
	<20090918080706.GB22909@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090918080706.GB22909@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Is there any mdadm command that would have given any info or metadata
from the previous array?  I have almost 9 months of SSH logging on my
laptop that I use to manage the array.  Maybe there's some useful info
left in the log that might help.

-Tim

On Fri, Sep 18, 2009 at 1:07 AM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> On Thu Sep 17, 2009 at 09:19:58PM -0700, Tim Bostrom wrote:
>
>> This seemed to work, though I'm still working through the permutatio=
ns
>> of the drive letters.
>>
>> I noticed that mdadm think that partition sde1 is ext2 filesystem on
>> it. =A0See below:
>>
>> [root@tera tbostrom]# mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sdb1
>> /dev/sdd1 /dev/sdc1 /dev/sde1 missing
>> mdadm: /dev/sdb1 appears to be part of a raid array:
>> =A0 =A0 level=3Draid5 devices=3D5 ctime=3DThu Sep 17 21:13:21 2009
>> mdadm: /dev/sdd1 appears to be part of a raid array:
>> =A0 =A0 level=3Draid5 devices=3D5 ctime=3DThu Sep 17 21:13:21 2009
>> mdadm: /dev/sdc1 appears to be part of a raid array:
>> =A0 =A0 level=3Draid5 devices=3D5 ctime=3DThu Sep 17 21:13:21 2009
>> mdadm: /dev/sde1 appears to contain an ext2fs file system
>> =A0 =A0 size=3D396408836K =A0mtime=3DMon Sep 21 03:41:16 2026
>> mdadm: /dev/sde1 appears to be part of a raid array:
>> =A0 =A0 level=3Draid5 devices=3D5 ctime=3DThu Sep 17 21:13:21 2009
>> Continue creating array?
>>
>> What gives? =A0I tried popping sdf1 in there without creating the ar=
ray
>> - just to see what would happen and it thinks that sdf1 has ext2 as
>> well.
>>
> That would suggest that sde1 is the first disk in the array (I think)=
=2E
>
>> Still at a loss here. =A0I haven't worked through all the drive
>> permutations. =A0In the meantime, I'll try that. =A0Does it make sen=
se to
>> try sdf1 in the permutation since the drive letters may have changed
>> since moving from the enclosure? =A0I thought I put them back in the
>> same order as the enclosure.
>>
> Definitely not - we know sdf1 has been re-written when you did the
> initial --create after moving the drives out of the enclosure. =A0Thi=
s
> means it _definitely_ has invalid data on it.
>
> Unfortunately, without having the metadata information from the
> _original_ array _after_ it has been moved from the enclosure, there'=
s
> no way of knowing what order the drives should be in. =A0I _think_ th=
at
> sde1 will be the first disk (as it shows up as an ext2 filesystem), b=
ut
> you'll really have to try every possible combination of the 5 devices
> (the 4 partitions and "missing"). =A0You may be best scripting this (=
or
> searching to see whether someone's already done that) - there's 120
> possible combinations to try.
>
> Cheers,
> =A0 =A0Robin
>
> --
> =A0 =A0 ___
> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@r=
obinhill.me.uk> |
> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 |
>



--=20
-tim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
