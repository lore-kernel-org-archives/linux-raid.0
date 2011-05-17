From: CoolCold <coolthecold@gmail.com>
Subject: Re: repartitioning disks
Date: Tue, 17 May 2011 16:31:04 +0400
Message-ID: <BANLkTikJ3BcRxjHgFKR3V5YMxfj+3bQ-Og@mail.gmail.com>
References: <BANLkTim5A1HEiPrRMxiUFZ4PGuyc4pbG-Q@mail.gmail.com>
	<20110517203944.65d8114e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110517203944.65d8114e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 17, 2011 at 2:39 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 17 May 2011 12:20:50 +0400 CoolCold <coolthecold@gmail.com> w=
rote:
>
>> Wiki says: "Never NEVER never re-partition disks that are part of a
>> running RAID. If you must alter the partition table on a disk which =
is
>> a part of a RAID, stop the array first, then repartition. " -
>> https://raid.wiki.kernel.org/index.php/Tweaking,_tuning_and_troubles=
hooting#Pitfalls
>>
>> Is it really true for situations like - I have 2x1Tb drives, which a=
re
>> already partitioned like /dev/sd{a,b}1 - 500mb, /boot & /dev/sd{a,b}=
2
>> - 20gb, / and are assembled in RAID1 arrays md0 & md1 accordingly. S=
o,
>> if I want to create one more RAID1 array , say md3 from the rest of
>> the drives.
>> So i take my cfdisk ,add new partition with some space 100-150mb fro=
m
>> the end, do write changes & partprobe the drives, then creating new
>> array.
>>
>> Is it bad? To be honest i'm doing this all the time and can't
>> understand how this gonna hurt md. Neil and/or others, please clarif=
y
>> this.
>>
>>
>
> There shouldn't be any problem with that as long as you are careful (=
and if
> you aren't careful, there are plenty of other ways to destroy your da=
ta).
>
> I wasn't aware of partprobe. =A0 =A0Just telling the kernel to reread=
 the
> partition table won't work when a partition is in use.
> But partprobe seems to just tell the kernel about the partitions that=
 have
> changed, using a different ioctl, and that seem to work.
Hmm..when I'm adding new partitions (or even deleting partitions which
are not part of any array), i'm not changing the existing ones, which
are part of arrays, and even without partprobe this action should be
ok, as it doesn't do anything to md's metadata ?
Updating partition which is part of running array going to be bad
thing, this is clear for me.

>
> NeilBrown
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
