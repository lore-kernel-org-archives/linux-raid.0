From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Tue, 03 Nov 2009 20:26:40 +0100
Message-ID: <87vdhr4dfz.fsf@frosties.localdomain>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	<4AEEF29C.10309@tmr.com>
	<cccedfc60911020703s3188ebcsac867922f937bb39@mail.gmail.com>
	<9e52db7bed791d8c8f5653b1958b1874.squirrel@neil.brown.name>
	<4877c76c0911022209g60e40364i2cb82909e31f707d@mail.gmail.com>
	<763d89fcf9c0164cbe8b6245dc3d2d7f.squirrel@neil.brown.name>
	<87fx8viwoh.fsf@frosties.localdomain>
	<4877c76c0911030828k6c2e5b88s299a7f1b19abc198@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911030828k6c2e5b88s299a7f1b19abc198@mail.gmail.com>
	(Michael Evans's message of "Tue, 3 Nov 2009 08:28:07 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, NeilBrown <neilb@suse.de>, Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Evans <mjevans1983@gmail.com> writes:

> On Tue, Nov 3, 2009 at 5:07 AM, Goswin von Brederlow <goswin-v-b@web.=
de> wrote:
>> "NeilBrown" <neilb@suse.de> writes:
>>
>>> A reshape is a fundamentally slow operation. =A0Each block needs to
>>> be read and then written somewhere else so there is little opportun=
ity
>>> for streaming.
>>> An in-place reshape (i.e the array doesn't get bigger or smaller) i=
s
>>> even slower as we have to take a backup copy of each range of block=
s
>>> before writing them back out. =A0This limits streaming even more.
>>>
>>> It is possible to get it fast than it is by increasing the
>>> array's stripe_cache_size and also increasing the 'backup' size
>>> that mdadm uses. =A0mdadm-3.1.1 will try to do better in this respe=
ct.
>>> However it will still be significantly slower than e.g. a resync.
>>>
>>> So reshape will always be slow. =A0It is a completely different iss=
ue
>>> to filesystem activity on a RAID array being slow. =A0Recent report=
s of
>>> slowness are, I think, not directly related to md/raid. =A0It is ei=
ther
>>> the filesystem or the VM or a combination of the two that causes
>>> these slowdowns.
>>>
>>>
>>> NeilBrown
>>
>> Now why is that? Lets leave out the case of an in-place
>> reshape. Nothing can be done to avoid making a backup of blocks
>> there, which severly limits the speed.
>>
>> But the most common case should be growing an array. Lets look at th=
e
>> first few steps or 3->4 disk raid5 reshape. Each step denotes a poin=
t
>> where a sync is required:
>>
>> Step 0 =A0 =A0 =A0 =A0 Step 1 =A0 =A0 =A0 =A0 Step 2 =A0 =A0 =A0 =A0=
 Step 3 =A0 =A0 =A0 =A0 Step 4
>> =A0A =A0B =A0C =A0D =A0 =A0 A =A0B =A0C =A0D =A0 =A0 A =A0B =A0C =A0=
D =A0 =A0 A =A0B =A0C =A0D =A0 =A0 A =A0B =A0C =A0D
>> 00 01 =A0p =A0x =A0 =A000 01 02 =A0p =A0 =A000 01 02 =A0p =A0 =A000 =
01 02 =A0p =A0 =A000 01 02 =A0p
>> 02 =A0p 03 =A0x =A0 =A002 =A0p 03 =A0x =A0 =A003 04 =A0p 05 =A0 =A00=
3 04 =A0p 05 =A0 =A003 04 =A0p 05
>> =A0p 04 05 =A0x =A0 =A0 p 04 05 =A0x =A0 =A0 x =A0x =A0x =A0x =A0 =A0=
06 =A0p 07 08 =A0 =A006 =A0p 07 08
>> 06 07 =A0p =A0x =A0 =A006 07 =A0p =A0x =A0 =A006 07 =A0p =A0x =A0 =A0=
 x =A0x =A0x =A0x =A0 =A0 p 09 10 11
>> 08 =A0p 09 =A0x =A0 =A008 =A0p 09 =A0x =A0 =A008 =A0p 09 =A0x =A0 =A0=
08 =A0p 09 =A0x =A0 =A0 x =A0x =A0x =A0x
>> =A0p 10 11 =A0x =A0 =A0 p 10 11 =A0x =A0 =A0 p 10 11 =A0x =A0 =A0 p =
10 11 =A0x =A0 =A0 x =A0x =A0x =A0x
>> 12 13 =A0p =A0x =A0 =A012 13 =A0p =A0x =A0 =A012 13 =A0p =A0x =A0 =A0=
12 13 =A0p =A0x =A0 =A012 13 =A0p =A0x
>> 14 =A0p 15 =A0x =A0 =A014 =A0p 15 =A0x =A0 =A014 =A0p 15 =A0x =A0 =A0=
14 =A0p 15 =A0x =A0 =A014 =A0p 15 =A0x
>> =A0p 16 17 =A0x =A0 =A0 p 16 17 =A0x =A0 =A0 p 16 17 =A0x =A0 =A0 p =
16 17 =A0x =A0 =A0 p 16 17 =A0x
>> 18 19 =A0p =A0x =A0 =A018 19 =A0p =A0x =A0 =A018 19 =A0p =A0x =A0 =A0=
18 19 =A0p =A0x =A0 =A018 19 =A0p =A0x
>> 20 =A0p 21 =A0x =A0 =A020 =A0p 21 =A0x =A0 =A020 =A0p 21 =A0x =A0 =A0=
20 =A0p 21 =A0x =A0 =A020 =A0p 21 =A0x
>> =A0p 22 23 =A0x =A0 =A0 p 22 23 =A0x =A0 =A0 p 22 23 =A0x =A0 =A0 p =
22 23 =A0x =A0 =A0 p 22 23 =A0x
>> 24 25 =A0p =A0x =A0 =A024 25 =A0p =A0x =A0 =A024 25 =A0p =A0x =A0 =A0=
24 25 =A0p =A0x =A0 =A024 25 =A0p =A0x
>> 26 =A0p 27 =A0x =A0 =A026 =A0p 27 =A0x =A0 =A026 =A0p 27 =A0x =A0 =A0=
26 =A0p 27 =A0x =A0 =A026 =A0p 27 =A0x
>> =A0p 28 29 =A0x =A0 =A0 p 28 29 =A0x =A0 =A0 p 28 29 =A0x =A0 =A0 p =
28 29 =A0x =A0 =A0 p 28 29 =A0x
>>
>> Step 5 =A0 =A0 =A0 =A0 Step 6 =A0 =A0 =A0 =A0 Step 7 =A0 =A0 =A0 =A0=
 Step 8 =A0 =A0 =A0 =A0 Step 9
>> =A0A =A0B =A0C =A0D =A0 =A0 A =A0B =A0C =A0D =A0 =A0 A =A0B =A0C =A0=
D =A0 =A0 A =A0B =A0C =A0D =A0 =A0 A =A0B =A0C =A0D
>> 00 01 02 =A0p =A0 =A000 01 02 =A0p =A0 =A000 01 02 =A0p =A0 =A000 01=
 02 =A0p =A0 =A000 01 02 =A0p
>> 03 04 =A0p 05 =A0 =A003 04 =A0p 05 =A0 =A003 04 =A0p 05 =A0 =A003 04=
 =A0p 05 =A0 =A003 04 =A0p 05
>> 06 =A0p 07 08 =A0 =A006 =A0p 07 08 =A0 =A006 =A0p 07 08 =A0 =A006 =A0=
p 07 08 =A0 =A006 =A0p 07 08
>> =A0p 09 10 11 =A0 =A0 p 09 10 11 =A0 =A0 p 09 10 11 =A0 =A0 p 09 10 =
11 =A0 =A0 p 09 10 11
>> =A0x =A0x =A0x =A0x =A0 =A012 13 14 =A0p =A0 =A012 13 14 =A0p =A0 =A0=
12 13 14 =A0p =A0 =A012 13 14 =A0p
>> =A0x =A0x =A0x =A0x =A0 =A015 16 =A0p 17 =A0 =A015 16 =A0p 17 =A0 =A0=
15 16 =A0p 17 =A0 =A015 16 =A0p 17
>> 12 13 =A0p =A0x =A0 =A0 x =A0x =A0x =A0x =A0 =A018 =A0p 19 20 =A0 =A0=
18 =A0p 19 20 =A0 =A018 =A0p 19 20
>> 14 =A0p 15 =A0x =A0 =A0 x =A0x =A0x =A0x =A0 =A0 p 21 22 23 =A0 =A0 =
p 21 22 23 =A0 =A0 p 21 22 23
>> =A0p 16 17 =A0x =A0 =A0 x =A0x =A0x =A0x =A0 =A024 25 26 =A0p =A0 =A0=
24 25 26 =A0p =A0 =A024 25 26 =A0p
>> 18 19 =A0p =A0x =A0 =A018 19 =A0p =A0x =A0 =A0 x =A0x =A0x =A0x =A0 =
=A027 28 =A0p 29 =A0 =A027 28 =A0p 29
>> 20 =A0p 21 =A0x =A0 =A020 =A0p 21 =A0x =A0 =A0 x =A0x =A0x =A0x =A0 =
=A030 =A0p 31 32 =A0 =A030 =A0p 31 32
>> =A0p 22 23 =A0x =A0 =A0 p 22 23 =A0x =A0 =A0 x =A0x =A0x =A0x =A0 =A0=
 p 33 34 35 =A0 =A0 p 33 34 35
>> 24 25 =A0p =A0x =A0 =A024 25 =A0p =A0x =A0 =A0 x =A0x =A0x =A0x =A0 =
=A036 37 38 =A0p =A0 =A036 37 38 =A0p
>> 26 =A0p 27 =A0x =A0 =A026 =A0p 27 =A0x =A0 =A026 =A0p 27 =A0x =A0 =A0=
 x =A0x =A0x =A0x =A0 =A039 40 =A0p 41
>> =A0p 28 29 =A0x =A0 =A0 p 28 29 =A0x =A0 =A0 p 28 29 =A0x =A0 =A0 x =
=A0x =A0x =A0x =A0 =A042 =A0p 43 44
>>
>>
>> In Step 0 and Step 1 the source and destination stripes overlap so a
>> backup is required. But at Step 2 you have a full stripe to work wit=
h
>> safely, at Step 4 2 stripes are save, Step 6 3 stripes and Step 7 4
>> stripes. As you go the safe region gets larger and larger requiring
>> less and less sync points.
>>
>> Idealy the raid reshape should read as much data from the source
>> stripes as possible in one go and then write it all out in one
>> go. Then rince and repeat. For a simple implementation why not do
>> this:
>>
>> 1) read reshape-sync-size from proc/sys, default to 10% ram size
>> 2) sync-size =3D min(reshape-sync-size, size of safe region)
>> 3) setup internal mirror between old (read-write) and new stripes (w=
rite only)
>> 4) read source blocks into stripe cache
>> 5) compute new parity
>> 6) put stripe into write cache
>> 7) goto 3 until sync-size is reached
>> 8) sync blocks to disk
>> 9) record progress and remove internal mirror
>> 10) goto 1
>>
>> Optionally in 9 you can skip recording the progress if the safe regi=
on
>> is big enough for another read/write pass.
>>
>> The important idea behind this would be that, given enough free ram,
>> there is a large linear read and large linear write alternating. Als=
o,
>> since the normal cache is used instead of the static stripe cache, i=
f
>> there is not enough ram then writes will be flushed out prematurely.
>> This will lead to a degradation of performance but that is better th=
an
>> running out of memory.
>>
>> I have 4GB on my desktop with at least 3GB free if I'm not doing
>> anything expensive. A raid-reshape should be able to do 3GB linear
>> read and write alternatively. But I would already be happy if it wou=
ld
>> do 256MB. There is lots of opportunity for streaming. It might justb=
e
>> hard to get the kernel IO system to cooperate.
>>
>> MfG
>> =A0 =A0 =A0 =A0Goswin
>>
>
> Skimming your message I agree with the major points, however you're
> only considering the best case scenario (which is how it probably
> should run for performance).  There is also the worst-case scenario
> where a device, driver, OS, or even power (supply lets say) fails in
> mid-operation.
>
> If there isn't a gap created due to the reshape (obviously it would
> continue to grow the more the reshape proceeds) then it's still an 'i=
n
> place' operation (which I argue should be done in the largest block
> possible within memory, but with data backed up on a device).

That is considered:
2) sync-size =3D min(reshape-sync-size, size of safe region)

At first the safe region is 0 and you need to backup some data. Then
the safe region is one stripe and things will go slowly. But as you
can see above and as you say the region quickly grows. I think the
region grows quickly enough that only a minimum of data needs to be
backuped up followed by a few slow iterations. It gets faster quickly
enough. But yeah, you can back up more at the start to get a larger
initial safe region.

> Growing operations obviously have free space on the new device, and
> further as the operation proceeds there will be a growing gap between
> the re-written data and the old copy of the data.
>
> Shrinking operations, counter-intuitively, also have a growing area o=
f
> free space; at the end of the device.  Working backwards, after a
> given number of stripes, the operation should be just as safe, if in
> reverse, as a normal grow.
>
> In any of the three cases, the largest possible write window per
> device should be used to take advantage of the usual gains in speed.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
