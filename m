From: David Brown <david@westcontrol.com>
Subject: Re: Triple-parity raid6
Date: Fri, 10 Jun 2011 11:03:26 +0200
Message-ID: <issmmc$tub$1@dough.gmane.org>
References: <isp2g2$rf$1@dough.gmane.org>	<20110609114954.243e9e22@notabene.brown>	<isqb2o$g0s$1@dough.gmane.org> <20110609220438.26336b27@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110609220438.26336b27@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/06/2011 14:04, NeilBrown wrote:
> On Thu, 09 Jun 2011 13:32:59 +0200 David Brown<david@westcontrol.com>=
  wrote:
>
>> On 09/06/2011 03:49, NeilBrown wrote:
>>> On Thu, 09 Jun 2011 02:01:06 +0200 David Brown<david.brown@hesbynet=
t.no>
>>> wrote:
>>>
>>>> Has anyone considered triple-parity raid6 ?  As far as I can see, =
it
>>>> should not be significantly harder than normal raid6 - either  to
>>>> implement, or for the processor at run-time.  Once you have the GF=
(2=E2=81=B8)
>>>> field arithmetic in place for raid6, it's just a matter of making
>>>> another parity block in the same way but using a different generat=
or:
>>>>
>>>> P =3D D_0 + D_1 + D_2 + .. + D_(n.1)
>>>> Q =3D D_0 + g.D_1 + g=C2=B2.D_2 + .. + g^(n-1).D_(n.1)
>>>> R =3D D_0 + h.D_1 + h=C2=B2.D_2 + .. + h^(n-1).D_(n.1)
>>>>
>>>> The raid6 implementation in mdraid uses g =3D 0x02 to generate the=
 second
>>>> parity (based on "The mathematics of RAID-6" - I haven't checked t=
he
>>>> source code).  You can make a third parity using h =3D 0x04 and th=
en get a
>>>> redundancy of 3 disks.  (Note - I haven't yet confirmed that this =
is
>>>> valid for more than 100 data disks - I need to make my checker pro=
gram
>>>> more efficient first.)
>>>>
>>>> Rebuilding a disk, or running in degraded mode, is just an obvious
>>>> extension to the current raid6 algorithms.  If you are missing thr=
ee
>>>> data blocks, the maths looks hard to start with - but if you expre=
ss the
>>>> equations as a set of linear equations and use standard matrix inv=
ersion
>>>> techniques, it should not be hard to implement.  You only need to =
do
>>>> this inversion once when you find that one or more disks have fail=
ed -
>>>> then you pre-compute the multiplication tables in the same way as =
is
>>>> done for raid6 today.
>>>>
>>>> In normal use, calculating the R parity is no more demanding than
>>>> calculating the Q parity.  And most rebuilds or degraded situation=
s will
>>>> only involve a single disk, and the data can thus be re-constructe=
d
>>>> using the P parity just like raid5 or two-parity raid6.
>>>>
>>>>
>>>> I'm sure there are situations where triple-parity raid6 would be
>>>> appealing - it has already been implemented in ZFS, and it is only=
 a
>>>> matter of time before two-parity raid6 has a real probability of h=
itting
>>>> an unrecoverable read error during a rebuild.
>>>>
>>>>
>>>> And of course, there is no particular reason to stop at three pari=
ty
>>>> blocks - the maths can easily be generalised.  1, 2, 4 and 8 can b=
e used
>>>> as generators for quad-parity (checked up to 60 disks), and adding=
 16
>>>> gives you quintuple parity (checked up to 30 disks) - but that's m=
aybe
>>>> getting a bit paranoid.
>>>>
>>>>
>>>> ref.:
>>>>
>>>> <http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf>
>>>> <http://blogs.oracle.com/ahl/entry/acm_triple_parity_raid>
>>>> <http://queue.acm.org/detail.cfm?id=3D1670144>
>>>> <http://blogs.oracle.com/ahl/entry/triple_parity_raid_z>
>>>>
>>>
>>>    -ENOPATCH  :-)
>>>
>>> I have a series of patches nearly ready which removes a lot of the =
remaining
>>> duplication in raid5.c between raid5 and raid6 paths.  So there wil=
l be
>>> relative few places where RAID5 and RAID6 do different things - onl=
y the
>>> places where they *must* do different things.
>>> After that, adding a new level or layout which has 'max_degraded =3D=
=3D 3' would
>>> be quite easy.
>>> The most difficult part would be the enhancements to libraid6 to ge=
nerate the
>>> new 'syndrome', and to handle the different recovery possibilities.
>>>
>>> So if you're not otherwise busy this weekend, a patch would be nice=
 :-)
>>>
>>
>> I'm not going to promise any patches, but maybe I can help with the
>> maths.  You say the difficult part is the syndrome calculations and
>> recovery - I've got these bits figured out on paper and some
>> quick-and-dirty python test code.  On the other hand, I don't really
>> want to get into the md kernel code, or the mdadm code - I haven't d=
one
>> Linux kernel development before (I mostly program 8-bit microcontrol=
lers
>> - when I code on Linux, I use Python), and I fear it would take me a
>> long time to get up to speed.
>>
>> However, if the parity generation and recovery is neatly separated i=
nto
>> a libraid6 library, the whole thing becomes much more tractable from=
 my
>> viewpoint.  Since I am new to this, can you tell me where I should g=
et
>> the current libraid6 code?  I'm sure google will find some sources f=
or
>> me, but I'd like to make sure I start with whatever version /you/ ha=
ve.
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> You can see the current kernel code at:
>
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
tree;f=3Dlib/raid6;h=3D970c541a452d3b9983223d74b10866902f1a47c7;hb=3DHE=
AD
>
>
> int.uc is the generic C code which 'unroll.awk' processes to make var=
ious
> versions that unroll the loops different amounts to work with CPUs wi=
th
> different numbers of registers.
> Then there is sse1, sse2, altivec which provide the same functionalit=
y in
> assembler which is optimised for various processors.
>
> And 'recov' has the smarts for doing the reverse calculation when 2 d=
ata
> blocks, or 1 data and P are missing.
>
> Even if you don't feel up to implementing everything, a start might b=
e
> useful.  You never know when someone might jump up and offer to help.
>
> NeilBrown


When looking at recov.c, I see in the "raid6_dual_recov" function there=
=20
is no code for testing data+Q failure as it is equivalent to raid5=20
recovery.  Should this not still be implemented here so that testing ca=
n=20
be more complete?

Is there a general entry point for the recovery routines, which then=20
decides which of raid6_2data_recov, raid6_datap_recov, or=20
raid6_dual_recov is called?  With triple-parity raid, there are many=20
more combinations - it would make sense for the library to have a singl=
e=20
function like :

void raid7_3_recov(int disks, size_t bytes, int noOfFails,
		int *pFails, void **ptrs);

or even (to cover quad parity and more) :

void raid7_n_recov(int disks, int noOfParities, size_t bytes,
	int noOfFails, int *pFails, void **ptrs);






--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
