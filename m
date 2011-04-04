From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What the heck happened to my array? (No apparent data loss).
Date: Mon, 4 Apr 2011 13:49:24 -0300
Message-ID: <BANLkTi=prv_vzfJr2JJt3LLhdB0GFSMy4w@mail.gmail.com>
References: <4D9876E4.6080501@fnarfbargle.com>
	<AANLkTi=2GNYdySbCDXmaDC8-8vF8GU9V3Uoy1qByNq58@mail.gmail.com>
	<4D995E27.3060800@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D995E27.3060800@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i don=B4t know but this happened with me on a hp server, with linux
2,6,37 i changed kernel to a older release and the problem ended,
check with neil and others md guys what=B4s the real problem
maybe realtime module and others changes inside kernel are the
problem, maybe not...
just a quick solution idea: try a older kernel

2011/4/4 Brad Campbell <lists2009@fnarfbargle.com>:
> On 03/04/11 23:47, Roberto Spadim wrote:
>>
>> what kernel version? more informations about your linux box?
>
> The kernel version and architecture were the first 2 lines of the E-m=
ail you
> top posted over.
>
> What would you like to know about the box? It's a 6 core Phenom-II wi=
th 16G
> of ram. 2 LSI SAS 9240 controllers configured with 10 x 1TB SATA Driv=
es in a
> RAID-6(md0) & 3 x 750GB SATA drives in a RAID-5(md2).
>
> The boot drives are a pair of 1TB SATA drives in multiple RAID-1's us=
ing the
> on-board AMD chipset controller and there is a 64GB SSD on a separate=
 PCI-E
> Marvell 7042m Controller.
>
> The array in question is :
>
> root@srv:~# mdadm --detail /dev/md0
> /dev/md0:
> =A0 =A0 =A0 =A0Version : 1.2
> =A0Creation Time : Sat Jan =A08 11:25:17 2011
> =A0 =A0 Raid Level : raid6
> =A0 =A0 Array Size : 7814078464 (7452.09 GiB 8001.62 GB)
> =A0Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
> =A0 Raid Devices : 10
> =A0Total Devices : 9
> =A0 =A0Persistence : Superblock is persistent
>
> =A0 =A0Update Time : Mon Apr =A04 13:53:59 2011
> =A0 =A0 =A0 =A0 =A0State : clean, degraded, recovering
> =A0Active Devices : 9
> Working Devices : 9
> =A0Failed Devices : 0
> =A0Spare Devices : 0
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 512K
>
> =A0Reshape Status : 29% complete
> =A0New Chunksize : 64K
>
> =A0 =A0 =A0 =A0 =A0 Name : srv:server =A0(local to host srv)
> =A0 =A0 =A0 =A0 =A0 UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
> =A0 =A0 =A0 =A0 Events : 429198
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdc
> =A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0176 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdl
> =A0 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0192 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdm
> =A0 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 80 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdf
> =A0 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A04 =A0 =A0 =A0=
active sync =A0 /dev/sdb
> =A0 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A05 =A0 =A0 =A0=
active sync =A0 /dev/sdg
> =A0 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0removed
> =A0 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0 64 =A0 =A0 =A0 =A07 =A0 =A0 =A0=
active sync =A0 /dev/sde
> =A0 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0active sync =A0 /dev/sda
> =A0 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0112 =A0 =A0 =A0 =A09 =A0 =A0 =A0=
active sync =A0 /dev/sdh
> root@srv:~#
>
> Subsequent investigation has shown sdd has a pending reallocation and=
 I can
> only assume the unidentified IO error was as a result of tripping up =
on
> that. It still does not explain why all IO to the array froze after t=
he
> drive was kicked.
>
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
