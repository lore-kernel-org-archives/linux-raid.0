From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Subject: Re: raid1 issue after disk failure: both disks of the array are still
 active
Date: Thu, 13 Sep 2012 17:48:01 +0200
Message-ID: <50520031.4010906@linuxsystems.it>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <5051B992.7030200@linuxsystems.it> <CABYL=TpKD2B0vwTrHH=iFK3PcMWueEsi84ACRbBQkDXuiWG3kw@mail.gmail.com> <CABYL=TrQPH9aPVAGbqrGcFWuwbAs=7h2H3BjpjUZHRmnwzaC6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=TrQPH9aPVAGbqrGcFWuwbAs=7h2H3BjpjUZHRmnwzaC6Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il 13/09/2012 17:32, Roberto Spadim ha scritto:
> you forced read from a block device (md0) that have a md raid1. check
> in source of raid1 read balance... it don=B4t read from all disks, ju=
st
> from 'near/fasters' disks.

I know, but since reading from md0 triggered a warning in dmesg (like=20
the previous I posted) it *did* read from the broken disk!!! Both disks=
=20
of the array are still active even after the read error, why?

Cheers,
Niccol=F2
--=20
http://www.linuxsystems.it
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
