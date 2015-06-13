From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: doubts about sdd raid1 and cfs
Date: Sat, 13 Jun 2015 17:18:51 -0300
Message-ID: <CAH3kUhGHPD5PhBcMzjH1iQBJgviuUa76KtAp-UVSqhwFnBpY1g@mail.gmail.com>
References: <CAH3kUhFLHdJ6T_RHaL2AyFHuH3Ta90DLhj8TKM5jZ_31mY2OCw@mail.gmail.com>
	<alpine.DEB.2.02.1506132211560.9487@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1506132211560.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hum, but what about the 850 version instead of 840?

2015-06-13 17:14 GMT-03:00 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Sat, 13 Jun 2015, Roberto Spadim wrote:
>
>> hi guys, i`m setting up a new server, it have
>> 1) 2x 256gb sdd
>> Samsung SSD 850 PRO 256GB, EXM02B6Q
>> 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32)
>> 2)1tb hdd
>> Hitachi HUA722010CLA330, JP4OA3EA
>> 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)
>>
>> i`m plannig a raid1 with ssd and hdd, hdd being a "write-mostly", an=
d
>> 750gb of hdd i will use to backup or other useless files
>>
>> i have somedoubts about the setup..
>> i use xfs at filesystem, should i consider TRIM command at filesyste=
m?
>> the problem is hdd being part of raid1 setup with others ssd, could
>> the ssd receive the TRIM and the hdd too?
>> any idea is wellcome
>
>
> Frankly, reading about the firmware problems on Samsung SSDs in combi=
nation
> with TRIM, I would recommend against using TRIM on samsung drives.
>
> https://bugs.launchpad.net/ubuntu/+source/fstrim/+bug/1449005
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se



--=20
Roberto Spadim
SPAEmpresarial - Software ERP
Eng. Automa=C3=A7=C3=A3o e Controle
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
