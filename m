From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Fri, 18 Sep 2009 01:11:14 +0300
Message-ID: <70ed7c3e0909171511j6403f51h722e54bb467792df@mail.gmail.com>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
	<20090917212252.GC19611@cthulhu.home.robinhill.me.uk> <70ed7c3e0909171435u661eeccbte85f968e067709f9@mail.gmail.com>
	<2267211f0909171451q547355a7sd26d3f984fd0bccf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2267211f0909171451q547355a7sd26d3f984fd0bccf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Bostrom <tbostrom@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If you run mdadm --examine /dev/sda you'll be able to see the disks'
order in the array (and the position of the disk you're
querying/examining). The faulty one is previously known as sdf. You
can find its new name by running --examine on all disks, and the one
that shows that all disks are healthy, is sdf.

On Fri, Sep 18, 2009 at 12:51 AM, Tim Bostrom <tbostrom@gmail.com> wrot=
e:
> I think the direct SATA connections ended up making them get reversed=
=2E
> sdb =3D sdf now
> sdc =3D sde now
> ..... I think....
>
> I labeled the drives as I pulled them out of the enclosure... I'll
> make sure they match up and then try your suggestions. =C2=A0I just n=
ow
> noticed the chunk size issue as well. =C2=A0<ugh>
>
>
> -Tim
>
>
> On Thu, Sep 17, 2009 at 2:35 PM, Majed B. <majedb@gmail.com> wrote:
>> Looking at your initial examine output, seems like the proper order =
is: bdce.
>>
>> If the hardware resets have gone after plugging into a normal PC cas=
e,
>> with different SATA cables, then I'd say the cables in your external
>> enclosure might be the suspect here.
>>
>> As Robin said, make sure you have the disks in the proper original
>> order as they were previously and that the chunksize is the same as
>> before.
>>
>> This should do it: mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bdce]1=
 missing
>> (notice the order)
>>
>> On Fri, Sep 18, 2009 at 12:22 AM, Robin Hill <robin@robinhill.me.uk>=
 wrote:
>>> On Thu Sep 17, 2009 at 01:42:30PM -0700, Tim Bostrom wrote:
>>>
>>>> OK,
>>>>
>>>> Let me start off by saying - I panicked. =C2=A0Rule #1 - don't pan=
ic. =C2=A0I
>>>> did. =C2=A0Sorry.
>>>>
>>>> I have a RAID 5 array running on Fedora 10.
>>>> (Linux tera.teambostrom.com 2.6.27.30-170.2.82.fc10.i686 #1 SMP Mo=
n
>>>> Aug 17 08:38:59 EDT 2009 i686 athlon i386 GNU/Linux)
>>>>
>>>> 5 drives in an external enclosure (AMS eSATA Venus T5). =C2=A0It's=
 a
>>>> Sil4726 inside the enclosure running to a Sil3132 controller via e=
SATA
>>>> in the desktop. =C2=A0I had been running this setup for just over =
a year.
>>>> Was working fine. =C2=A0 I just moved into a new home and had my s=
erver
>>>> down for a while =C2=A0- before I brought it back online, I got a =
"great
>>>> idea" to blow out the dust from the enclosure using compressed air=
=2E
>>>> When I finally brought up the array again, I noticed that drives w=
ere
>>>> missing. =C2=A0Tried re-adding the drives to the array and had som=
e issues
>>>> - they seemed to get added but after a short time of rebuilding th=
e
>>>> array, I would get a bunch of HW resets in dmesg and then the arra=
y
>>>> would kick out drives and stop.
>>>>
>>> <- much snippage ->
>>>
>>>> I popped the drives out of the enclosure and into the actual tower
>>>> case and connected each of them to its own SATA port. =C2=A0The HW=
 resets
>>>> seemed to go away, but I couldn't get the array to come back onlin=
e.
>>>> =C2=A0Then I did the stupid panic (following someone's advice I sh=
ouldn't
>>>> have).
>>>>
>>>> thinking I should just re-create the array, I did:
>>>>
>>>> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D5 /dev/sd[b-f=
]1
>>>>
>>>> Stupid me again - ignores the warning that it belongs to an array
>>>> already. =C2=A0I let it build for a minute or so and then tried to=
 mount it
>>>> while rebuilding... and got error messages:
>>>>
>>>> EXT3-fs: unable to read superblock
>>>> EXT3-fs: md0: couldn't mount because of unsupported optional featu=
res
>>>> (3fd18e00).
>>>>
>>>> Now - I'm at a loss. =C2=A0I'm afraid to do anything else. =C2=A0 =
I've been
>>>> viewing the FAQ and I have a few ideas, but I'm just more freaked.=
 =C2=A0Is
>>>> there any hope? =C2=A0What should I do next without causing more t=
rouble?
>>>>
>>> Looking at the mdadm output, there's a couple of possible errors.
>>> Firstly, your newly created array has a different chunksize than yo=
ur
>>> original one. =C2=A0Secondly, the drives may be in the wrong order.=
 =C2=A0In
>>> either case, providing you don't _actually_ have any faulty drives,=
 then
>>> it should be (mostly) recoverable.
>>>
>>> Given the order you specified the drives in the create, sdf1 will b=
e the
>>> partition that's been trashed by the rebuild, so you'll want to lea=
ve
>>> that out altogether for now.
>>>
>>> You need to try to recreate the array with the correct chunk size a=
nd
>>> with the remaining drives in different orders, running a read-only
>>> filesystem check each time until you find the correct order.
>>>
>>> So start with:
>>> =C2=A0 =C2=A0mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bcde]1 miss=
ing
>>>
>>> Then repeat for every possible order of the four disks and "missing=
",
>>> stopping the array each time if the mount fails.
>>>
>>> When you've finally found the correct order, you can re-add sdf1 to=
 get
>>> the array back to normal.
>>>
>>> HTH,
>>> =C2=A0 =C2=A0Robin
>>> --
>>> =C2=A0 =C2=A0 ___
>>> =C2=A0 =C2=A0( ' } =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 Robin Hill =
=C2=A0 =C2=A0 =C2=A0 =C2=A0<robin@robinhill.me.uk> |
>>> =C2=A0 / / ) =C2=A0 =C2=A0 =C2=A0| Little Jim says .... =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|
>>> =C2=A0// !! =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0"He fallen i=
n de water !!" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
|
>>>
>>
>>
>>
>> --
>> =C2=A0 =C2=A0 =C2=A0 Majed B.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> -tim
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
