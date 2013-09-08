From: =?UTF-8?Q?Gar=C3=B0ar_Arnarsson?= <gardar@giraffi.net>
Subject: Re: raid6 array assembled from 11 drives and 2 spares - not enough to
 start the array
Date: Sun, 8 Sep 2013 00:36:45 +0000
Message-ID: <CAH-e9vJS+_HhBZUTCW2wOG1us0KbGUgcAmCFzO9YGTcynB1UiA@mail.gmail.com>
References: <CAH-e9vL7fUYSrd4J7+nej=xiqndgk3vim38Mu7+E-w37QX0Ebw@mail.gmail.com>
 <CAH-e9vJGPOWm2YqGk54CRtGVW1pYcxbU0xS9HaU74fR_q+Ecug@mail.gmail.com> <CAAMCDecz8uf+1366o8XSduxeo=-emhFnrdRjgWOFsy39rV2Mgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDecz8uf+1366o8XSduxeo=-emhFnrdRjgWOFsy39rV2Mgg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes I forgot to mention that I already did check the smart status on
each drive which is the reason I went and checked the sata cables.

My controllers might be playing tricks on me, as I have noticed a
devices dropping out of the arrays before without any reasons I could
find. I might have to get some different controllers and maybe
bigger/fewer drives soon. Rebuilding a 14 drive array is slow and
dangerous.
Is there any rule of thumb about how many drives you should have
maximum in a raid5/raid6 array?

Thanks for the tip about /dev/sd[abc]1, somehow you forget all of
those things when you are stressed out of loosing all your data. :)

On Sun, Sep 8, 2013 at 12:05 AM, Roger Heflin <rogerheflin@gmail.com> w=
rote:
> run smartctl --all /dev/sdX were you replace X with each of the devic=
es.
>
> Watch for reported uncorrected and or other errors coming from variou=
s
> disks. especially on the ones that had an issue.
>
> And check /var/log/messages to see what the sequence of events was on
> the failure.
>
> If you have certain controllers (some marvell's, probably some others=
)
> under certain conditions they will lock up and drop all devices on th=
e
> given card, if a disk behaves badly some controllers will also have
> issues that can result in other ports on the same device going away.
>
> And also this works nicely without having to specify all devices
> explicitly...for /dev/sda1 /dev/sdb1 /dev/sdc1 this will work
> /dev/sd[abc]1 and is much easier to type so long as all of the device=
s
> are on partition 1.
>
> On Sat, Sep 7, 2013 at 6:49 PM, Gar=C3=B0ar Arnarsson <gardar@giraffi=
=2Enet> wrote:
>> I seem to have been able to resolve this.
>>
>> I tried force assembling the array with all the drives except for sd=
a1
>> (the problematic device before) that way the array got assembled wit=
h
>> 12 drives and one spare, enough so I could recover the array.
>>
>> Still would want to know what might have caused these problems for t=
he
>> first place, but I'm glad it seems to be working ok for now.
>>
>> On Sat, Sep 7, 2013 at 10:56 PM, Gar=C3=B0ar Arnarsson <gardar@giraf=
fi.net> wrote:
>>> I am unable to start my raid6 array.
>>>
>>> At first I got sda1 missing so I went ahead and re-added it and was
>>> able to start the array. Then few minutes later I got 3 failed driv=
es.
>>>
>>> I shut down my server, checked all the sata and power cables and
>>> booted up again.
>>> The array did not start automatically so I tried to force assemble =
it.
>>>
>>> sudo mdadm --assemble --verbose --force /dev/md1 /dev/sda1 /dev/sdb=
1
>>> /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sd=
i1
>>> /dev/sdj1 /dev/sdk1 /dev/sdm1 /dev/sdp1 /dev/sdq1
>>> mdadm: looking for devices for /dev/md1
>>> mdadm: /dev/sda1 is identified as a member of /dev/md1, slot 15.
>>> mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 8.
>>> mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 1.
>>> mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 3.
>>> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 6.
>>> mdadm: /dev/sdf1 is identified as a member of /dev/md1, slot 9.
>>> mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 10.
>>> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 0.
>>> mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 11.
>>> mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 7.
>>> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 5.
>>> mdadm: /dev/sdm1 is identified as a member of /dev/md1, slot 14.
>>> mdadm: /dev/sdp1 is identified as a member of /dev/md1, slot 2.
>>> mdadm: /dev/sdq1 is identified as a member of /dev/md1, slot 4.
>>> mdadm: ignoring /dev/sdq1 as it reports /dev/sda1 as failed
>>> mdadm: added /dev/sdc1 to /dev/md1 as 1
>>> mdadm: added /dev/sdp1 to /dev/md1 as 2
>>> mdadm: added /dev/sdd1 to /dev/md1 as 3
>>> mdadm: no uptodate device for slot 4 of /dev/md1
>>> mdadm: added /dev/sdk1 to /dev/md1 as 5
>>> mdadm: added /dev/sde1 to /dev/md1 as 6
>>> mdadm: added /dev/sdj1 to /dev/md1 as 7
>>> mdadm: added /dev/sdb1 to /dev/md1 as 8
>>> mdadm: added /dev/sdf1 to /dev/md1 as 9
>>> mdadm: added /dev/sdg1 to /dev/md1 as 10
>>> mdadm: added /dev/sdi1 to /dev/md1 as 11
>>> mdadm: no uptodate device for slot 12 of /dev/md1
>>> mdadm: no uptodate device for slot 13 of /dev/md1
>>> mdadm: added /dev/sdm1 to /dev/md1 as 14
>>> mdadm: added /dev/sda1 to /dev/md1 as 15
>>> mdadm: added /dev/sdh1 to /dev/md1 as 0
>>> mdadm: /dev/md1 assembled from 11 drives and 2 spares - not enough =
to
>>> start the array.
>>>
>>> Any ideas what could have gone wrong and how I can possibly start t=
he
>>> array again?
>>
>>
>>
>> --
>> Gar=C3=B0ar Arnarsson
>> kerfisstj=C3=B3ri Giraffi sf.
>> gardar@giraffi.net
>> http://gardar.giraffi.net
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Gar=C3=B0ar Arnarsson
kerfisstj=C3=B3ri Giraffi sf.
gardar@giraffi.net
http://gardar.giraffi.net
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
