From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Fri, 18 Sep 2009 00:35:39 +0300
Message-ID: <70ed7c3e0909171435u661eeccbte85f968e067709f9@mail.gmail.com>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
	<20090917212252.GC19611@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090917212252.GC19611@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Looking at your initial examine output, seems like the proper order is:=
 bdce.

If the hardware resets have gone after plugging into a normal PC case,
with different SATA cables, then I'd say the cables in your external
enclosure might be the suspect here.

As Robin said, make sure you have the disks in the proper original
order as they were previously and that the chunksize is the same as
before.

This should do it: mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bdce]1 mi=
ssing
(notice the order)

On Fri, Sep 18, 2009 at 12:22 AM, Robin Hill <robin@robinhill.me.uk> wr=
ote:
> On Thu Sep 17, 2009 at 01:42:30PM -0700, Tim Bostrom wrote:
>
>> OK,
>>
>> Let me start off by saying - I panicked. =C2=A0Rule #1 - don't panic=
=2E =C2=A0I
>> did. =C2=A0Sorry.
>>
>> I have a RAID 5 array running on Fedora 10.
>> (Linux tera.teambostrom.com 2.6.27.30-170.2.82.fc10.i686 #1 SMP Mon
>> Aug 17 08:38:59 EDT 2009 i686 athlon i386 GNU/Linux)
>>
>> 5 drives in an external enclosure (AMS eSATA Venus T5). =C2=A0It's a
>> Sil4726 inside the enclosure running to a Sil3132 controller via eSA=
TA
>> in the desktop. =C2=A0I had been running this setup for just over a =
year.
>> Was working fine. =C2=A0 I just moved into a new home and had my ser=
ver
>> down for a while =C2=A0- before I brought it back online, I got a "g=
reat
>> idea" to blow out the dust from the enclosure using compressed air.
>> When I finally brought up the array again, I noticed that drives wer=
e
>> missing. =C2=A0Tried re-adding the drives to the array and had some =
issues
>> - they seemed to get added but after a short time of rebuilding the
>> array, I would get a bunch of HW resets in dmesg and then the array
>> would kick out drives and stop.
>>
> <- much snippage ->
>
>> I popped the drives out of the enclosure and into the actual tower
>> case and connected each of them to its own SATA port. =C2=A0The HW r=
esets
>> seemed to go away, but I couldn't get the array to come back online.
>> =C2=A0Then I did the stupid panic (following someone's advice I shou=
ldn't
>> have).
>>
>> thinking I should just re-create the array, I did:
>>
>> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D5 /dev/sd[b-f]1
>>
>> Stupid me again - ignores the warning that it belongs to an array
>> already. =C2=A0I let it build for a minute or so and then tried to m=
ount it
>> while rebuilding... and got error messages:
>>
>> EXT3-fs: unable to read superblock
>> EXT3-fs: md0: couldn't mount because of unsupported optional feature=
s
>> (3fd18e00).
>>
>> Now - I'm at a loss. =C2=A0I'm afraid to do anything else. =C2=A0 I'=
ve been
>> viewing the FAQ and I have a few ideas, but I'm just more freaked. =C2=
=A0Is
>> there any hope? =C2=A0What should I do next without causing more tro=
uble?
>>
> Looking at the mdadm output, there's a couple of possible errors.
> Firstly, your newly created array has a different chunksize than your
> original one. =C2=A0Secondly, the drives may be in the wrong order. =C2=
=A0In
> either case, providing you don't _actually_ have any faulty drives, t=
hen
> it should be (mostly) recoverable.
>
> Given the order you specified the drives in the create, sdf1 will be =
the
> partition that's been trashed by the rebuild, so you'll want to leave
> that out altogether for now.
>
> You need to try to recreate the array with the correct chunk size and
> with the remaining drives in different orders, running a read-only
> filesystem check each time until you find the correct order.
>
> So start with:
> =C2=A0 =C2=A0mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bcde]1 missin=
g
>
> Then repeat for every possible order of the four disks and "missing",
> stopping the array each time if the mount fails.
>
> When you've finally found the correct order, you can re-add sdf1 to g=
et
> the array back to normal.
>
> HTH,
> =C2=A0 =C2=A0Robin
> --
> =C2=A0 =C2=A0 ___
> =C2=A0 =C2=A0( ' } =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 Robin Hill =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<robin@robinhill.me.uk> |
> =C2=A0 / / ) =C2=A0 =C2=A0 =C2=A0| Little Jim says .... =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|
> =C2=A0// !! =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0"He fallen in =
de water !!" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
