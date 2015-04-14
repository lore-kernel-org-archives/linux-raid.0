From: Emanuel Domingos <emanuelsdrock@gmail.com>
Subject: Re: Recovery Raid6 Degraded
Date: Tue, 14 Apr 2015 09:31:47 -0300
Message-ID: <CACsoFmgu9q6LCYg3knCTyzqa0aRrvVY44AbAPdt3NR9-u85wPQ@mail.gmail.com>
References: <CACsoFmjWW7mqSA8OKZZEPhpFidf-exSMm771ZOp0TssSYydcrw@mail.gmail.com>
	<alpine.DEB.2.02.1504132234220.16871@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1504132234220.16871@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, Mikael, thanks for reply


MDADM

mdadm - v3.2.3 - 23rd December 2011


KERNEL

Linux ubuntu 3.0.0-12-server #20-Ubuntu SMP Fri Oct 7 16:36:30 UTC
2011 x86_64 x86_64 x86_64 GNU/Linux



Will be with the new version and inform soon the result


Thanks!

2015-04-13 17:38 GMT-03:00 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Mon, 13 Apr 2015, Emanuel Domingos wrote:
>
>> guys, following guidelines on wiki, before to try recreate my array
>> I'm sending this mail to listen the experts.
>
>
> Good choice!
>
>> I would like to aid as a problem in my raid arrays after a crash in
>> which I had to restart the server.
>
>
> What kernel version and mdadm version are you running?
>
> My first recommendation would be for you to compile latest mdadm from
> source:
>
> "git clone https://github.com/neilbrown/mdadm"
>
> Then compile it and use that to do the --assemble-force operation tha=
t
> failed before. This has helped others.
>
> If it still doesn't work, please provide dmesg output from when that
> operation occured.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se



--=20
Emanuel Domingos

Cursando Bacharelado em Ci=C3=AAncia da Computa=C3=A7=C3=A3o - IFCE Cam=
pus Maracana=C3=BA
T=C3=A9cnico em Conectividade - IFCE Campus Maracana=C3=BA
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
