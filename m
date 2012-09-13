From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 issue after disk failure: both disks of the array are still active
Date: Thu, 13 Sep 2012 12:53:29 -0300
Message-ID: <CABYL=TqfHqBz7uh165Oa9jhiTLe4fFjYuhMW+BYJNbiAstjY9w@mail.gmail.com>
References: <5051AF17.8010501@linuxsystems.it>
	<20120913103432.GA11764@cthulhu.home.robinhill.me.uk>
	<5051B992.7030200@linuxsystems.it>
	<CABYL=TpKD2B0vwTrHH=iFK3PcMWueEsi84ACRbBQkDXuiWG3kw@mail.gmail.com>
	<CABYL=TrQPH9aPVAGbqrGcFWuwbAs=7h2H3BjpjUZHRmnwzaC6Q@mail.gmail.com>
	<50520031.4010906@linuxsystems.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50520031.4010906@linuxsystems.it>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

check the read error counters of you md in sys folder
(max_read_errors,  device/errors)
maybe it got a error and retried and readed without error

2012/9/13 Niccol=C3=B2 Belli <darkbasic@linuxsystems.it>:
> Il 13/09/2012 17:32, Roberto Spadim ha scritto:
>
>> you forced read from a block device (md0) that have a md raid1. chec=
k
>> in source of raid1 read balance... it don=C2=B4t read from all disks=
, just
>> from 'near/fasters' disks.
>
>
> I know, but since reading from md0 triggered a warning in dmesg (like=
 the
> previous I posted) it *did* read from the broken disk!!! Both disks o=
f the
> array are still active even after the read error, why?
>
> Cheers,
> Niccol=C5=86
>
> --
> http://www.linuxsystems.it
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
