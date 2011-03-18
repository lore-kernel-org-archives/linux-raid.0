From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: disk order problem in a raid 10 array
Date: Fri, 18 Mar 2011 20:57:15 -0300
Message-ID: <AANLkTimN7TkgpMjfoF5NnUMAjA0jTAfO1Gqnduu9yMwO@mail.gmail.com>
References: <201103190006.56887.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103190006.56887.xavier@alternatif.org>
Sender: linux-raid-owner@vger.kernel.org
To: Xavier Brochard <xavier@alternatif.org>
Cc: linux-raid@vger.kernel.org, hansbkk@gmail.com
List-Id: linux-raid.ids

did you try to change udev configuration?

2011/3/18 Xavier Brochard <xavier@alternatif.org>:
> Hello,
>
> Le vendredi 18 mars 2011 23:22:51, NeilBrown =A0=E9crivait :
>> On Fri, 18 Mar 2011 21:12:49 +0100 Xavier Brochard <xavier@alternati=
f.org>
>> > Le vendredi 18 mars 2011 18:22:34 hansbkk@gmail.com, vous avez =E9=
crit :
>> > > On Fri, Mar 18, 2011 at 9:49 PM, Xavier Brochard
>> > > <xavier@alternatif.org>
>> >
>> > wrote:
>> > > > disk order is mixed between each boot - even with live-cd.
>> > > > is that normal?
>> > >
>> > > If nothing is changing and the order is swapping really every bo=
ot,
>> > > then IMO that is odd.
>> >
>> > nothing has changed, except kernel minor version
>>
>> Yet you don't tell us what the kernel minor version changed from or =
to.
>
> Previously it was ubuntu 2.6.32-27-server or 2.6.32-28-server and now=
 it is
> ubuntu 2.6.32-29.58-server 2.6.32.28+drm33.13
>
>> That may not be important, but it might and you obviously don't know=
 which.
>> It is always better to give too much information rather than not eno=
ugh.
>
> Again sorry, my wednesday email was long and I thought it was too lon=
g!
>
>> > exactly, in my case mdadm --examine output is somewhat weird as it=
 shows:
>> > /dev/sde1
>> > this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
>> > /dev/sdd1
>> > this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>> > /dev/sdc1
>> > this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sde1
>> > and /dev/sdf1 as sdf1
>>
>> You are hiding lots of details again...
>>
>> Are these all from different arrays? =A0They all claim to be 'device=
 0' of
>> some array.
>
> They are all from same md RAID10 array
>
>> Infact, =A0"8, 33" is *always* /dev/sdc1, =A0so I think the above li=
nes have
>> been edited by hand because I'm 100% certain mdadm didn't output the=
m.
>
> You're right, I'm sorry. I =A0have copied this line, just changing th=
e /dev/sd?
>
> Here's full output of mdadm --examine /dev/sd[cdefg]1
> As you can see, disks sdc, sdd and sde claims to be different, is it =
a problem?
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> /dev/sdc1:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
> =A0Creation Time : Sun Jan =A02 16:41:45 2011
> =A0 =A0 Raid Level : raid10
> =A0Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
> =A0 =A0 Array Size : 976767872 (931.52 GiB 1000.21 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 5
> Preferred Minor : 0
>
> =A0 =A0Update Time : Wed Mar 16 09:50:03 2011
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 1
> Working Devices : 1
> =A0Failed Devices : 2
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : ec151590 - correct
> =A0 =A0 =A0 =A0 Events : 154
>
> =A0 =A0 =A0 =A0 Layout : near=3D2
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A02 =A0 =A0 =
=A0active sync =A0 /dev/sde1
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0removed
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0faulty removed
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sde1
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0faulty removed
> /dev/sdd1:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
> =A0Creation Time : Sun Jan =A02 16:41:45 2011
> =A0 =A0 Raid Level : raid10
> =A0Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
> =A0 =A0 Array Size : 976767872 (931.52 GiB 1000.21 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 5
> Preferred Minor : 0
>
> =A0 =A0Update Time : Wed Mar 16 07:43:45 2011
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 5
> =A0Failed Devices : 0
> =A0Spare Devices : 1
> =A0 =A0 =A0 Checksum : ec14f740 - correct
> =A0 =A0 =A0 =A0 Events : 102
>
> =A0 =A0 =A0 =A0 Layout : near=3D2
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A00 =A0 =A0 =
=A0active sync =A0 /dev/sdc1
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sde1
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0spare =A0 /dev/sdg1
> /dev/sde1:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
> =A0Creation Time : Sun Jan =A02 16:41:45 2011
> =A0 =A0 Raid Level : raid10
> =A0Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
> =A0 =A0 Array Size : 976767872 (931.52 GiB 1000.21 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 5
> Preferred Minor : 0
>
> =A0 =A0Update Time : Wed Mar 16 07:43:45 2011
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 5
> =A0Failed Devices : 0
> =A0Spare Devices : 1
> =A0 =A0 =A0 Checksum : ec14f752 - correct
> =A0 =A0 =A0 =A0 Events : 102
>
> =A0 =A0 =A0 =A0 Layout : near=3D2
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A01 =A0 =A0 =
=A0active sync =A0 /dev/sdd1
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sde1
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0spare =A0 /dev/sdg1
> /dev/sdf1:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
> =A0Creation Time : Sun Jan =A02 16:41:45 2011
> =A0 =A0 Raid Level : raid10
> =A0Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
> =A0 =A0 Array Size : 976767872 (931.52 GiB 1000.21 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 5
> Preferred Minor : 0
>
> =A0 =A0Update Time : Wed Mar 16 07:43:45 2011
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 5
> =A0Failed Devices : 0
> =A0Spare Devices : 1
> =A0 =A0 =A0 Checksum : ec14f776 - correct
> =A0 =A0 =A0 =A0 Events : 102
>
> =A0 =A0 =A0 =A0 Layout : near=3D2
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0 =
=A0active sync =A0 /dev/sdf1
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sde1
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0spare =A0 /dev/sdg1
> /dev/sdg1:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
> =A0Creation Time : Sun Jan =A02 16:41:45 2011
> =A0 =A0 Raid Level : raid10
> =A0Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
> =A0 =A0 Array Size : 976767872 (931.52 GiB 1000.21 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 5
> Preferred Minor : 0
>
> =A0 =A0Update Time : Wed Mar 16 07:43:45 2011
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 5
> =A0Failed Devices : 0
> =A0Spare Devices : 1
> =A0 =A0 =A0 Checksum : ec14f782 - correct
> =A0 =A0 =A0 =A0 Events : 102
>
> =A0 =A0 =A0 =A0 Layout : near=3D2
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A04 =A0 =A0 =
=A0spare =A0 /dev/sdg1
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sde1
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0spare =A0 /dev/sdg1
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
>> > I think I can believe mdadm?
>>
>> Yes, you can believe mdadm - but only if you understand what it is s=
aying,
>> and there are times when that is not as easy as one might like....
>
> Specially when a raid system is broken! One mind looks broken too and=
 it's a
> bit hard to think clearly :-)
>
> Thanks for the help
>
> Xavier
> xavier@alternatif.org - 09 54 06 16 26
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
