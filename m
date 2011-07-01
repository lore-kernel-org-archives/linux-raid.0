From: David Brown <david@westcontrol.com>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Fri, 01 Jul 2011 09:23:43 +0200
Message-ID: <iujspj$jgg$1@dough.gmane.org>
References: <4E0C5539.4030000@gmx.de>	<4E0C5E47.5090604@anonymous.org.uk>	<4E0C6CC4.3030506@turmel.org>	<4E0C7196.1070307@gmx.de>	<4E0C7B4B.7090404@turmel.org>	<4E0C8685.3020806@gmx.de> <20110701072855.69ee763b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110701072855.69ee763b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/06/2011 23:28, NeilBrown wrote:
> On Thu, 30 Jun 2011 16:21:57 +0200 Karsten R=F6mke<k.roemke@gmx.de>  =
wrote:
>
>> Hi Phil
>>>
>>> If your CPU has free cycles, I suggest you run raid6 instead of rai=
d5+spare.
>>>
>>> Phil
>>>
>> I started the raid 6 array and get:
>>
>> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
>> md0 : active raid6 sde5[4] sdd5[3] sdc5[2] sdb2[1] sda3[0]
>>         13759296 blocks level 6, 64k chunk, algorithm 2 [5/5] [UUUUU=
]
>>         [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>...]  r=
esync =3D 87.4% (4013184/4586432) finish=3D0.4min speed=3D20180K/sec
>                                    ^^^^^^
> Note: resync
>
>>
>> when I started the raid 5 array I get
>>
>> md0 : active raid5 sdd5[4] sde5[5](S) sdc5[2] sdb2[1] sda3[0]
>>         13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>>         [=3D>...................]  recovery =3D  6.2% (286656/458643=
2) finish=3D0.9min speed=3D71664K/sec
>                                    ^^^^^^^^
> Note: recovery.
>
>>
>> so I have to expect a three times less write speed - or is this calc=
ulation
>> to simple ?
>>
>
> You are comparing two different things, neither of which is write spe=
ed.
> If you want to measure write speed, you should try writing and measur=
e that.
>
> When you create a RAID5 mdadm deliberately triggers recovery rather t=
han
> resync as it is likely to be faster.  This is why you see a missed de=
vice and
> an extra spare.  I don't remember why it doesn't with RAID6.
>

What's the difference between a "resync" and a "recovery"?  Is it that =
a=20
"resync" will read the whole stripe, check if it is valid, and if it is=
=20
not it then generates the parity, while a "recovery" will always=20
generate the parity?

If that's the case, then one reason it might not do that with raid6 is=20
if the code is common with the raid5 to raid6 grow case.  Then a=20
"resync" would leave the raid5 parity untouched, so that the set keeps=20
some redundancy, whereas a "recovery" would temporarily leave the strip=
e=20
unprotected.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
