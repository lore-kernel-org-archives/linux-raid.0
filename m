From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: resync duration ?
Date: Thu, 14 May 2009 12:26:39 -0400
Message-ID: <7d86ddb90905140926u4c88a6d2s418c583f837ca260@mail.gmail.com>
References: <1308264373.20090514150647@kaneda.iguw.tuwien.ac.at>
	 <20090514135840.GB8862@atlantis.cc.ndsu.NoDak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090514135840.GB8862@atlantis.cc.ndsu.NoDak.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Mesich <bryan.mesich@ndsu.edu>, Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sounds like it could be wrapping around as suggested. Since you are
swapping out all the disks have you thought about stopping the array
and using dd to copy the old disk to the new disk. Then there is no
resync period or degraded array.

Ryan

On Thu, May 14, 2009 at 9:58 AM, Bryan Mesich <bryan.mesich@ndsu.edu> w=
rote:
> On Thu, May 14, 2009 at 03:06:47PM +0200, Rainer Fuegenstein wrote:
>> Hi guys,
>>
>> I'm a but confused about the duration of a raid5 resync:
>>
>> - occasionally, my server with 4*750 gb sata raid5 crashed (because =
of
>> problems with the power supply); after rebooting it took about 10 to=
 12
>> hours to resync the raid5 (guess it just re-created some parity
>> information or however it works internally, but didn't have to copy
>> any data)
>>
>> - right now I replaced one 750GB disk with a 1.5TB disk, but now
>> resyncing (according to /proc/mdstat) it is supposed to take only 16=
0
>> minutes ?! although it needs top copy data to a blank disk ?
>
> Just a guess...but your problem might be an artifact of a bug
> that has been recently fixed. =A0Neil sent out mail on 2009-05-04
> with the fix I'm thinking about. =A0Here is an excerpt from his
> mail:
>
> Subject: [md PATCH 4/7] md: tidy up status_resync to handle
> large arrays.
>
> Two problems in status_resync.
> 1. It still used Kilobytes as the basic block unit, while most
> =A0 code now uses sectors uniformly.
> 2. It doesn't allow for the possibility that max_sectors exceeds
> =A0 the range of "unsigned long".
>
> So
> =A0- change "max_blocks" to "max_sectors", and store sector numbers
> =A0 in there and in 'resync'
> =A0- Make 'rt' a 'sector_t' so it can temporarily hold the number
> =A0 of remaining sectors.
> =A0- use sector_div rather than normal division.
> =A0- change the magic '100' used to preserve precision to '32'.
> =A0 + making it a power of 2 makes division easier
> =A0 + it doesn't need to be as large as it was chosen when we
> =A0 averaged speed over the entire run. =A0Now we average speed over =
the
> =A0 last 30 seconds or so.
>
>> is this normal or should I be worried, especially before I pull out
>> the next 750GB disk and replace it with the next 1.5TB disk ?
>
> If your sync only takes 160 minutes...then I'd start to poke
> around. =A0If its finishing time is reasonable considering the
> array size, then I'd continue with the migration.
>
>> tnx in advance.
>
> Bryan
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
