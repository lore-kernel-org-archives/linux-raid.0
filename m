From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 21:43:02 +0000
Message-ID: <AANLkTikLX-d6CtXhLBQU_qoxx0fQ2HdR8acFCU+o9JeP@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<AANLkTi=SbAM3BXxjH6Mvcn-Tw4b0FYyLjLFqSGuxY1fk@mail.gmail.com>
	<AANLkTik4MGS7V7ePBgbk+KW-FcBBV7MuYgB7n29RRXF=@mail.gmail.com>
	<20110130094444.68288b0e@natsu>
	<AANLkTi=jXwcEgRquKgsf5HQUA+AQdt8nHeHCUJYqdSbX@mail.gmail.com>
	<20110130171533.4c9e236b@natsu>
	<AANLkTi=6UnGjDXdrM76-8_iW+1D6MC5fkGB-vhhYxUXu@mail.gmail.com>
	<4D45C3FA.2040900@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D45C3FA.2040900@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Roman Mamedov <rm@romanrm.ru>, CoolCold <coolthecold@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30 January 2011 20:03, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> Mathias Bur=C3=A9n put forth on 1/30/2011 1:41 PM:
>
>> Thanks. New results up for those interested:
>> http://stuff.dyndns.org/logs/bonnie_results.html
>
> Three things I notice:
>
> 1. =C2=A0You're CPU bound across the board, for all the tests that ma=
tter anyway
> 2. =C2=A0Because of this, your performance spread is less than 5% acr=
oss the board
> =C2=A0 =C2=A0meaning any optimizations are useless
> 3. =C2=A0Is that a 7 Gigabyte chunk size? =C2=A0That's totally unreal=
istic. =C2=A0It should be
> =C2=A0 =C2=A0less than 1 MB for almost all workloads.
>
> According to those numbers, you can swap SATA controllers and PCIe bu=
s slot
> assignments all day long, but you'll gain nothing without a faster CP=
U.
>
> Why are you using a 7 Gigabyte chunk size? =C2=A0And if the other OP =
was correct
> about the 768MB stripe cache, that's totally unrealistic as well. =C2=
=A0And in real
> world use, you don't want a high readahead setting. =C2=A0It just was=
tes buffer cache
> memory for no gain (except maybe in some synthetic benchmarks).
>
> --
> Stan
>

CPU bound, got it.

3) 7GB output from bonnie++. Like so:

$ time bonnie++ -m ion -d ./
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version 1.03e       ------Sequential Output------ --Sequential Input- -=
-Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- -=
-Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  =
/sec %CP
ion              7G 13455  96 150827  92 67719  43 14439  99 271832
59 469.6   3
                    ------Sequential Create------ --------Random Create=
--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -=
Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  =
/sec %CP
                 16 20318  99 +++++ +++ 25428  99 21095  99 +++++ +++ 2=
5278  99
ion,7G,13455,96,150827,92,67719,43,14439,99,271832,59,469.6,3,16,20318,=
99,+++++,+++,25428,99,21095,99,+++++,+++,25278,99

real	21m7.872s
user	16m17.836s
sys	2m51.405s

(after ion)

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
