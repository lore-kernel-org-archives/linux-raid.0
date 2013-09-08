From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: raid6 array assembled from 11 drives and 2 spares - not enough to
 start the array
Date: Sat, 7 Sep 2013 20:25:51 -0500
Message-ID: <CAAMCDecoQrRCU1q+ToJBOJf_CkYMAzO5N-rM9M8EvJOOogbr+g@mail.gmail.com>
References: <CAH-e9vL7fUYSrd4J7+nej=xiqndgk3vim38Mu7+E-w37QX0Ebw@mail.gmail.com>
 <CAH-e9vJGPOWm2YqGk54CRtGVW1pYcxbU0xS9HaU74fR_q+Ecug@mail.gmail.com>
 <CAAMCDecz8uf+1366o8XSduxeo=-emhFnrdRjgWOFsy39rV2Mgg@mail.gmail.com> <CAH-e9vJS+_HhBZUTCW2wOG1us0KbGUgcAmCFzO9YGTcynB1UiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH-e9vJS+_HhBZUTCW2wOG1us0KbGUgcAmCFzO9YGTcynB1UiA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Gar=F0ar_Arnarsson?= <gardar@giraffi.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I would research the controllers, there is a lot of cheap unreliable
crap out there, and a number you can find people indicating it works
on linux...even though it does not work reliably.

I had a controller, it was nice and fast but it had a habit of
dropping all of the disks on it sometimes when a smart command was
used, and if one of the drives responded wrong/bad it would also drop
all of the disks, and when my disks aged and sectors starting failing
it started happening quite often.

I am trying to stay with the important raid parts being on the
build-in (AMD and/or Intel ports on the motherboard) ports.    Watch
out as the motherboards often have 2 or more ports that aren't AMD
and/or Intel and a fair number of these are less than good.   And
watch out for the port multipliers as there are issues that can cause
loss of all drives on the multiplier.

And you may want to look at some locking SATA cables and you probably
want to verify your power supply is big enough to run the number of
disks you have and that you have enough fans cooling the disks (smart
will tell you the disk temp).

14 is probably getting a bit high...I gave up on my around 3-year old
1.5TB disks as there were starting to act up quite often and went with
3tb drivers from 2 separate companies and I only had 6 drives and
almost lost my data from a 3 disk failure (was on a raid0 for about 3
days waiting for the next RMAed disk to return, got it added back in
just in time before the next disk died...

Also make sure you have bitmaps enabled...rebuilding it a disk back
into the same location is much faster with bitmaps.


On Sat, Sep 7, 2013 at 7:36 PM, Gar=F0ar Arnarsson <gardar@giraffi.net>=
 wrote:
> Yes I forgot to mention that I already did check the smart status on
> each drive which is the reason I went and checked the sata cables.
>
> My controllers might be playing tricks on me, as I have noticed a
> devices dropping out of the arrays before without any reasons I could
> find. I might have to get some different controllers and maybe
> bigger/fewer drives soon. Rebuilding a 14 drive array is slow and
> dangerous.
> Is there any rule of thumb about how many drives you should have
> maximum in a raid5/raid6 array?
>
> Thanks for the tip about /dev/sd[abc]1, somehow you forget all of
> those things when you are stressed out of loosing all your data. :)
>
> On Sun, Sep 8, 2013 at 12:05 AM, Roger Heflin <rogerheflin@gmail.com>=
 wrote:
>> run smartctl --all /dev/sdX were you replace X with each of the devi=
ces.
>>
>> Watch for reported uncorrected and or other errors coming from vario=
us
>> disks. especially on the ones that had an issue.
>>
>> And check /var/log/messages to see what the sequence of events was o=
n
>> the failure.
>>
>> If you have certain controllers (some marvell's, probably some other=
s)
>> under certain conditions they will lock up and drop all devices on t=
he
>> given card, if a disk behaves badly some controllers will also have
>> issues that can result in other ports on the same device going away.
>>
>> And also this works nicely without having to specify all devices
>> explicitly...for /dev/sda1 /dev/sdb1 /dev/sdc1 this will work
>> /dev/sd[abc]1 and is much easier to type so long as all of the devic=
es
>> are on partition 1.
>>
>> On Sat, Sep 7, 2013 at 6:49 PM, Gar=F0ar Arnarsson <gardar@giraffi.n=
et> wrote:
>>> I seem to have been able to resolve this.
>>>
>>> I tried force assembling the array with all the drives except for s=
da1
>>> (the problematic device before) that way the array got assembled wi=
th
>>> 12 drives and one spare, enough so I could recover the array.
>>>
>>> Still would want to know what might have caused these problems for =
the
>>> first place, but I'm glad it seems to be working ok for now.
>>>
>>> On Sat, Sep 7, 2013 at 10:56 PM, Gar=F0ar Arnarsson <gardar@giraffi=
=2Enet> wrote:
>>>> I am unable to start my raid6 array.
>>>>
>>>> At first I got sda1 missing so I went ahead and re-added it and wa=
s
>>>> able to start the array. Then few minutes later I got 3 failed dri=
ves.
>>>>
>>>> I shut down my server, checked all the sata and power cables and
>>>> booted up again.
>>>> The array did not start automatically so I tried to force assemble=
 it.
>>>>
>>>> sudo mdadm --assemble --verbose --force /dev/md1 /dev/sda1 /dev/sd=
b1
>>>> /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/s=
di1
>>>> /dev/sdj1 /dev/sdk1 /dev/sdm1 /dev/sdp1 /dev/sdq1
>>>> mdadm: looking for devices for /dev/md1
>>>> mdadm: /dev/sda1 is identified as a member of /dev/md1, slot 15.
>>>> mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 8.
>>>> mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 1.
>>>> mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 3.
>>>> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 6.
>>>> mdadm: /dev/sdf1 is identified as a member of /dev/md1, slot 9.
>>>> mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 10.
>>>> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 0.
>>>> mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 11.
>>>> mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 7.
>>>> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 5.
>>>> mdadm: /dev/sdm1 is identified as a member of /dev/md1, slot 14.
>>>> mdadm: /dev/sdp1 is identified as a member of /dev/md1, slot 2.
>>>> mdadm: /dev/sdq1 is identified as a member of /dev/md1, slot 4.
>>>> mdadm: ignoring /dev/sdq1 as it reports /dev/sda1 as failed
>>>> mdadm: added /dev/sdc1 to /dev/md1 as 1
>>>> mdadm: added /dev/sdp1 to /dev/md1 as 2
>>>> mdadm: added /dev/sdd1 to /dev/md1 as 3
>>>> mdadm: no uptodate device for slot 4 of /dev/md1
>>>> mdadm: added /dev/sdk1 to /dev/md1 as 5
>>>> mdadm: added /dev/sde1 to /dev/md1 as 6
>>>> mdadm: added /dev/sdj1 to /dev/md1 as 7
>>>> mdadm: added /dev/sdb1 to /dev/md1 as 8
>>>> mdadm: added /dev/sdf1 to /dev/md1 as 9
>>>> mdadm: added /dev/sdg1 to /dev/md1 as 10
>>>> mdadm: added /dev/sdi1 to /dev/md1 as 11
>>>> mdadm: no uptodate device for slot 12 of /dev/md1
>>>> mdadm: no uptodate device for slot 13 of /dev/md1
>>>> mdadm: added /dev/sdm1 to /dev/md1 as 14
>>>> mdadm: added /dev/sda1 to /dev/md1 as 15
>>>> mdadm: added /dev/sdh1 to /dev/md1 as 0
>>>> mdadm: /dev/md1 assembled from 11 drives and 2 spares - not enough=
 to
>>>> start the array.
>>>>
>>>> Any ideas what could have gone wrong and how I can possibly start =
the
>>>> array again?
>>>
>>>
>>>
>>> --
>>> Gar=F0ar Arnarsson
>>> kerfisstj=F3ri Giraffi sf.
>>> gardar@giraffi.net
>>> http://gardar.giraffi.net
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Gar=F0ar Arnarsson
> kerfisstj=F3ri Giraffi sf.
> gardar@giraffi.net
> http://gardar.giraffi.net
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
