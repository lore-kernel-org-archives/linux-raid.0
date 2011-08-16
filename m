From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Device utilization with RAID-1
Date: Mon, 15 Aug 2011 22:30:18 -0300
Message-ID: <CABYL=Tp_PcRYg_dnv3Fbs=Jpih4vcM_9hnioKPNRMms3Y43ikg@mail.gmail.com>
References: <4E49BC53.8040604@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E49BC53.8040604@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hochglanz@googlemail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

try raid10 with far layout

2011/8/15 Harald Nikolisin <hochglanz@gmail.com>:
> Since a long time I'm unhappy with the performance of my RAID-1 syste=
m.
> Investigation with atop and iostat unveils that the disk utilization =
is
> always on a certain level although nothing happens on the system. In =
the
> case of reading or writing files the utilization boosts always to 100=
%
> for a long time. Very ugly examples are "Firefox starting" or "zypper
> updates".
> That is snapshot of the output of iostat:
>
>
> Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0=
 rsec/s =A0 wsec/s
> avgrq-sz avgqu-sz =A0 await =A0svctm =A0%util
> sda =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 =A0=
7,33 =A0 =A0 0,00 =A0 =A043,33
> 5,91 =A0 =A0 0,33 =A0 43,18 =A033,32 =A024,43
> sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 =A0=
7,33 =A0 =A0 0,00 =A0 =A043,33
> 5,91 =A0 =A0 0,35 =A0 45,59 =A039,73 =A029,13
> md0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 =A0=
0,67 =A0 =A0 0,00 =A0 =A0 5,33
> 8,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
> md1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 =A0=
0,33 =A0 =A0 0,00 =A0 =A0 5,33
> 16,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
> md2 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 =A0=
0,33 =A0 =A0 0,00 =A0 =A0 1,00
> 3,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
> md3 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 =A0=
0,00 =A0 =A0 0,00 =A0 =A0 0,00
> 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
> md4 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 =A0=
0,00 =A0 =A0 0,00 =A0 =A0 0,00
> 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
> md5 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 =A0=
0,33 =A0 =A0 0,00 =A0 =A0 0,67
> 2,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
>
> I checked with mdadm if a resync happens or so, but this is not the
> case. The state says "active" on all RAID devices - btw. what is the
> difference to "clean" ?
>
> thanks for any hints,
> =A0harald
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
