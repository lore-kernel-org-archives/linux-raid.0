From: Liam Kurmos <quantum.leaf@gmail.com>
Subject: Re: mdadm raid1 read performance
Date: Thu, 5 May 2011 01:20:33 +0100
Message-ID: <BANLkTimNxTnf2xW8hbEWK2iA6axqjnjT+A@mail.gmail.com>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
	<20110504105822.21e23bc3@notabene.brown>
	<BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
	<4DC0F2B6.9050708@fnarfbargle.com>
	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>
	<BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
	<20110505094538.0cef02cc@notabene.brown>
	<BANLkTi=W=DNdqOBiGwbu67P1EgoEqNy+sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=W=DNdqOBiGwbu67P1EgoEqNy+sg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Roberto Spadim <roberto@spadim.com.br>, Brad Campbell <lists2009@fnarfbargle.com>, Drew <drew.kay@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

incidentally what does the f2 layout do that it performs so much
better than the default?

Liam


On Thu, May 5, 2011 at 1:14 AM, Liam Kurmos <quantum.leaf@gmail.com> wr=
ote:
> Thanks guys!
>
>
>
>>> raid10: 220MB/s
>>
>> Assuming the default 'n2' layout, I would expect 2*140 or 280, so th=
is is a
>> little slow. =A0Try "--layout=3Df2" and see what you get (should be =
more like
>> RAID0).
>
>
> mdadm -C /dev/md0 --level=3Draid10 --layout=3Df2 --raid-devices=3D4
> /dev/sda1 /dev/sdc1 /dev/sdd1 /dev/sde1
>
> dd if=3D/dev/md0 of=3D/dev/null bs=3D1M count=3D1000
> 1000+0 records in
> 1000+0 records out
> 1048576000 bytes (1.0 GB) copied, 2.23352 s, 469 MB/s
>
> :D
>
> awesome!!
>
>>
>>> raid5: ~165MB/s
>>
>> I would expect 3*140 or 420, so this is very slow. =A0I wonder if re=
ad-ahead is
>> set badly.
>
>> Can you:
>> =A0 blockdev --getra /dev/md0
>> multiply the number it gives you by 8 and give it back with
>> =A0 blockdev --setra NUMBER /dev/md0
>>
>
> genius.
>
> im not really sure what this did but it totally fixed the problem.
>
> look ahead was 768, set it 6144 and immediately got 400MB/s
>>
>>> raid1: ~140MB/s =A0(single disk speed)
>>
>> as expected.
>>
>>>
>>> for 4 disks raid0 seems like suicide, but for my system drive the
>>> speed advantage is so great im tempted to try it anyway and try and
>>> use rsync to keep constant back up.
>>
>> If you have somewhere to rsync to, then you have more disks so RAID1=
0 might
>> be an answer... but I suspect you cannot move disks around that free=
ly :-)
>>
>
> no need now! f2 layout is awesome.
>
> many thanks,
>
> Liam
>
>
>
>> NeilBrown
>>
>>
>>
>>>
>>> cheers for you responses,
>>>
>>> Liam
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
