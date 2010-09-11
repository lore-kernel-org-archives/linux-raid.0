From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: New RAID causing system lockups
Date: Sat, 11 Sep 2010 16:56:56 -0400
Message-ID: <AANLkTikWY1QE_2HBADkVV1u1OSCktVT=ShQrCdNWBF8n@mail.gmail.com>
References: <AANLkTimTvPupaPuFbfpcCGC=0Ys9fQWihAgaADsrowqq@mail.gmail.com>
	<20100912064308.46d96742@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100912064308.46d96742@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 11, 2010 at 4:43 PM, Neil Brown <neilb@suse.de> wrote:
> On Sat, 11 Sep 2010 14:20:40 -0400
> Mike Hartman <mike@hartmanipulation.com> wrote:
>
>> PART 3:
>>
>> Update:
>>
>> I'm even more concerned about this now, because I just started the
>> newest reshaping to add a new drive with:
>>
>> mdadm --grow -c 256 --raid-devices=3D5 --backup-file=3D/grow_md0.bak=
 /dev/md0
>>
>> And the system output:
>>
>> mdadm: Need to backup 768K of critical section..
>>
>> cat /proc/mdstat shows the reshaping is proceeding,
>>
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [r=
aid4]
>> md0 : active raid6 sdi1[0] sdf1[5] md1p1[4] sdj1[3] sdh1[1]
>> =A0 =A0 =A0 2929691136 blocks super 1.2 level 6, 128k chunk, algorit=
hm 2 [5/5] [UUUUU]
>> =A0 =A0 =A0 [>....................] =A0reshape =3D =A00.0% (56576/14=
64845568)
>> finish=3D2156.9min speed=3D11315K/sec
>>
>> md1 : active raid0 sdg1[0] sdk1[1]
>> =A0 =A0 =A0 1465141760 blocks super 1.2 128k chunks
>>
>> unused devices: <none>
>>
>> but I've checked for /grow_md0.bak and it's not there. So it looks
>> like for some reason it ignored my backup file option.
>
> It didn't.
>
> When you making an array larger, you only need the backup file for a =
small
> 'critical region' at the beginning of the reshape - 768K worth in you=
r case.
>
> Once that is complete the backup-file is not needed and so is removed=
=2E
>
> So your current situation is no worse that before.

Ok. When I did the reshape from RAID 5 to RAID 6 (moving from 3 disks
to 4) it kept the backup file around until at least 13% (since that's
when it locked and I had to restart it with the backup) but I imagine
that's a less common case than just growing an array. Your comments
give me renewed confidence.

>
> [When making an array smaller, the critical section happen and the ve=
ry end,
> so mdadm keeps the backup file around - unused - until then. =A0Then =
uses it
> quickly and completes. =A0When reshaping an array without changing th=
e size the
> 'critical section' lasts for the entire time so a backup file is need=
ed and
> is very heavily used]
>
> I don't know yet what is causing the lock-up. =A0A quick look at your=
 logs
> suggest that it could be related to the barrier handling. =A0Maybe tr=
ying to
> handle a barrier during a reshape is prone to races of some sort - I =
wouldn't
> be very surprised by that.

Just note that during the second lockup no reshape or resync was going
on. The array state was stable, I was just writing to it.

>
> I'll have a look at the code and see what I can find.

Thanks a lot. If it was only a risk when I was growing/reshaping the
array, and covered by the backup file, it would just be an
inconvenience. But since it can seemingly happen at any time it's a
problem.

>
> Thanks for the report,
> NeilBrown
>
>
>>
>> This scares me, because if I experience the lockup again and am forc=
ed
>> to reboot, without a backup file I'm afraid my array will be hosed.
>> I'm also afraid to stop it cleanly right now for the same reason.
>>
>> So in addition to fixing the lockup itself, does anyone know if
>> there's a way to either cancel this reshaping or belatedly add the
>> backup file in a different way so it will be recoverable? It's only =
at
>> 1% and says it will take another 2193 minutes.
>>
>> Mike
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
