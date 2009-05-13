From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: RAID0 - unitialised zone->dev_start for zone[0]
Date: Wed, 13 May 2009 22:38:27 +0530
Message-ID: <37d33d830905131008y4a3a3815i6bec41a0d9b32ddf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,


[22:33:46 sinhas]$ diff raid0.c raid0.c.orig
160d159
<       zone->dev_start =3D 0;
[/usr/src/linux-2.6.29/drivers/md]
[22:33:59 sinhas]$

I see this piece of code missing and being used later.
Not very sure of the code flow, but still as part of defensive programm=
ing.

Am i missing something?



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
