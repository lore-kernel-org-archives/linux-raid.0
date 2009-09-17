From: Tim Bostrom <tbostrom@gmail.com>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Thu, 17 Sep 2009 15:23:51 -0700
Message-ID: <2267211f0909171523k39739f01tc8e3ba196dd6bfa1@mail.gmail.com>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
	<20090917212252.GC19611@cthulhu.home.robinhill.me.uk> <70ed7c3e0909171435u661eeccbte85f968e067709f9@mail.gmail.com>
	<2267211f0909171451q547355a7sd26d3f984fd0bccf@mail.gmail.com>
	<70ed7c3e0909171511j6403f51h722e54bb467792df@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909171511j6403f51h722e54bb467792df@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

OK - I was just about to ask how you both knew that the array was out o=
f order.


Thank you again.

-Tim

On Thu, Sep 17, 2009 at 3:11 PM, Majed B. <majedb@gmail.com> wrote:
> If you run mdadm --examine /dev/sda you'll be able to see the disks'
> order in the array (and the position of the disk you're
> querying/examining). The faulty one is previously known as sdf. You
> can find its new name by running --examine on all disks, and the one
> that shows that all disks are healthy, is sdf.
>
> On Fri, Sep 18, 2009 at 12:51 AM, Tim Bostrom <tbostrom@gmail.com> wr=
ote:
>> I think the direct SATA connections ended up making them get reverse=
d.
>> sdb =3D sdf now
>> sdc =3D sde now
>> ..... I think....
>>
>> I labeled the drives as I pulled them out of the enclosure... I'll
>> make sure they match up and then try your suggestions. =A0I just now
>> noticed the chunk size issue as well. =A0<ugh>
>>
>>
>> -Tim
>>
>>
>> On Thu, Sep 17, 2009 at 2:35 PM, Majed B. <majedb@gmail.com> wrote:
>>> Looking at your initial examine output, seems like the proper order=
 is: bdce.
>>>
>>> If the hardware resets have gone after plugging into a normal PC ca=
se,
>>> with different SATA cables, then I'd say the cables in your externa=
l
>>> enclosure might be the suspect here.
>>>
>>> As Robin said, make sure you have the disks in the proper original
>>> order as they were previously and that the chunksize is the same as
>>> before.
>>>
>>> This should do it: mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bdce]=
1 missing
>>> (notice the order)
>>>
>>> On Fri, Sep 18, 2009 at 12:22 AM, Robin Hill <robin@robinhill.me.uk=
> wrote:
>>>> On Thu Sep 17, 2009 at 01:42:30PM -0700, Tim Bostrom wrote:
>>>>
>>>>> OK,
>>>>>
>>>>> Let me start off by saying - I panicked. =A0Rule #1 - don't panic=
=2E =A0I
>>>>> did. =A0Sorry.
>>>>>
>>>>> I have a RAID 5 array running on Fedora 10.
>>>>> (Linux tera.teambostrom.com 2.6.27.30-170.2.82.fc10.i686 #1 SMP M=
on
>>>>> Aug 17 08:38:59 EDT 2009 i686 athlon i386 GNU/Linux)
>>>>>
>>>>> 5 drives in an external enclosure (AMS eSATA Venus T5). =A0It's a
>>>>> Sil4726 inside the enclosure running to a Sil3132 controller via =
eSATA
>>>>> in the desktop. =A0I had been running this setup for just over a =
year.
>>>>> Was working fine. =A0 I just moved into a new home and had my ser=
ver
>>>>> down for a while =A0- before I brought it back online, I got a "g=
reat
>>>>> idea" to blow out the dust from the enclosure using compressed ai=
r.
>>>>> When I finally brought up the array again, I noticed that drives =
were
>>>>> missing. =A0Tried re-adding the drives to the array and had some =
issues
>>>>> - they seemed to get added but after a short time of rebuilding t=
he
>>>>> array, I would get a bunch of HW resets in dmesg and then the arr=
ay
>>>>> would kick out drives and stop.
>>>>>
>>>> <- much snippage ->
>>>>
>>>>> I popped the drives out of the enclosure and into the actual towe=
r
>>>>> case and connected each of them to its own SATA port. =A0The HW r=
esets
>>>>> seemed to go away, but I couldn't get the array to come back onli=
ne.
>>>>> =A0Then I did the stupid panic (following someone's advice I shou=
ldn't
>>>>> have).
>>>>>
>>>>> thinking I should just re-create the array, I did:
>>>>>
>>>>> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D5 /dev/sd[b-=
f]1
>>>>>
>>>>> Stupid me again - ignores the warning that it belongs to an array
>>>>> already. =A0I let it build for a minute or so and then tried to m=
ount it
>>>>> while rebuilding... and got error messages:
>>>>>
>>>>> EXT3-fs: unable to read superblock
>>>>> EXT3-fs: md0: couldn't mount because of unsupported optional feat=
ures
>>>>> (3fd18e00).
>>>>>
>>>>> Now - I'm at a loss. =A0I'm afraid to do anything else. =A0 I've =
been
>>>>> viewing the FAQ and I have a few ideas, but I'm just more freaked=
=2E =A0Is
>>>>> there any hope? =A0What should I do next without causing more tro=
uble?
>>>>>
>>>> Looking at the mdadm output, there's a couple of possible errors.
>>>> Firstly, your newly created array has a different chunksize than y=
our
>>>> original one. =A0Secondly, the drives may be in the wrong order. =A0=
In
>>>> either case, providing you don't _actually_ have any faulty drives=
, then
>>>> it should be (mostly) recoverable.
>>>>
>>>> Given the order you specified the drives in the create, sdf1 will =
be the
>>>> partition that's been trashed by the rebuild, so you'll want to le=
ave
>>>> that out altogether for now.
>>>>
>>>> You need to try to recreate the array with the correct chunk size =
and
>>>> with the remaining drives in different orders, running a read-only
>>>> filesystem check each time until you find the correct order.
>>>>
>>>> So start with:
>>>> =A0 =A0mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bcde]1 missing
>>>>
>>>> Then repeat for every possible order of the four disks and "missin=
g",
>>>> stopping the array each time if the mount fails.
>>>>
>>>> When you've finally found the correct order, you can re-add sdf1 t=
o get
>>>> the array back to normal.
>>>>
>>>> HTH,
>>>> =A0 =A0Robin
>>>> --
>>>> =A0 =A0 ___
>>>> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robi=
n@robinhill.me.uk> |
>>>> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>>>> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 |
>>>>
>>>
>>>
>>>
>>> --
>>> =A0 =A0 =A0 Majed B.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>> --
>> -tim
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> =A0 =A0 =A0 Majed B.
>



--=20
-tim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
