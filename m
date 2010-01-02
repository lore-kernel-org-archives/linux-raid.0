From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID5 broke during reshape...
Date: Sat, 2 Jan 2010 20:33:49 +0300
Message-ID: <70ed7c3e1001020933x7ac028a5n42af404eb5e23e30@mail.gmail.com>
References: <1262451347.10047.14.camel@michal-laptop.sawicz.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1262451347.10047.14.camel@michal-laptop.sawicz.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Micha=C5=82_Sawicz?= <michal@sawicz.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Post the output of mdadm -E /dev/sdx1 and smart -a /dev/sdx for all dis=
ks.
Also, which version of mdadm are you using?

2010/1/2 Micha=C5=82 Sawicz <michal@sawicz.net>:
> Hi all,
>
> I have quite a big problem, I had a clean 4 disk RAID5 array, wanted =
to
> reshape it to 5 disks, building a degraded array (I know, I shouldn't
> have done that). One of the disks (sdh) failed and the array is
> currently broken:
>
>> md5 : active raid5 sdh1[1](S) sdf1[4](S) sdc1[3] sdg1[2]
>> =C2=A0 =C2=A0 =C2=A0 2930279424 blocks super 1.1 level 5, 256k chunk=
, algorithm 2 [4/2] [U_U_]
>
> sdh1 was initially marked F, it changed to S when I removed it and
> readded it to the array. The filesystem shut down instantly so no wri=
te
> operations were performed.
>
> What I can't understand is why sdf1 also got marked as a spare.
>
> Is there any way I can recover the data? SMART only reports 3 unreada=
ble
> sectors, so most of the data should be recoverable... I will provide =
any
> additional information needed to get as much of the data back.
>
> --
> Regards
> Micha=C5=82 (Saviq) Sawicz
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
