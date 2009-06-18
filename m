From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: Resize Raid5 devices
Date: Thu, 18 Jun 2009 10:36:32 +0200
Message-ID: <4CB2808F-EB88-458A-9D2B-22E31A97EB4F@bj-ig.de>
References: <62E07ACC-0F47-4B5F-94C7-29199ECE46FE@bj-ig.de> <87tz2e7xqt.fsf@frosties.localdomain>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tz2e7xqt.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
Cc: Goswin von Brederlow <goswin-v-b@web.de>
List-Id: linux-raid.ids


Am 18.06.2009 um 10:27 schrieb Goswin von Brederlow:
> Ralf M=FCller <ralf@bj-ig.de> writes:
>
>> After I added a forth 1.5TB disk to the array yesterday and =20
>> reshaped the
>> former 3 disk raid5 to a 4 disk one, I wiped out the 300GB disk =20
>> raid5,
>> set one of the 1.2TB partitions faulty, removed it from its raid,
>> removed the 300GB partition and resized the former 1.2TB partition
>> (in place) to 1.5TB. Now I added this partition to its raid.
>>
>> It has been recognized as a former member of this raid - so far so
>> good - but for whatever reason the raid subsystem decided to start
>> a complete recovery.
>> So here my question:
>>
>> What went wrong and what do I have to do to avoid a full recovery fo=
r
>> the next disk?
>
> I guess something wrote to your raid5 while the one disk was
> removed.

Thats possible - after re-add, the bitmap showed 2/275 pages as unclean=
=2E

> When you added it back the event counter would differ and the
> disk needs to be resynced completly. A bitmap would help limiting thi=
s
> to the parts that have changed. Add an internal bitmap before you
> remove the next disk.

There is an internal write intent bitmap at the array:
DatenGrab:/media # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1]
md3 : active raid5 sdf1[3] sdi1[0] sdj1[4] sdh1[1]
      3457099008 blocks super 1.2 level 5, 256k chunk, algorithm 2 =20
[4/4] [UUUU]
      bitmap: 0/275 pages [0KB], 2048KB chunk

Do you have an idea why this bitmap has been ignored?

> Alternatively stop the raid completly, resize all the partitions and
> start the raid again. No need to fail/readd each disk in turn.

good idea ...

Thanks so far
Ralf

--=20
Van Roy's Law: -------------------------------------------------------
        An unbreakable toy is useful for breaking other toys.



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
