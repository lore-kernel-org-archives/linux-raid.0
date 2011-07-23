From: CoolCold <coolthecold@gmail.com>
Subject: Re: how to recover filesystem after clobbering array?
Date: Sat, 23 Jul 2011 23:04:14 +0400
Message-ID: <CAGqmV7q7SzQNSPLueai+nwkpL1TqxUfkB4hymEL9JWM2ES2r-w@mail.gmail.com>
References: <20110719104325.16112cl7f4lrzkjh@mail.sapo.pt>
	<j03lp4$h72$1@dough.gmane.org>
	<4E255FE1.2060006@tolaris.com>
	<20110719120153.1529669k4o1t6v4x@mail.sapo.pt>
	<4E2A8420.5000603@sapo.pt>
	<alpine.DEB.2.00.1107231029280.20159@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1107231029280.20159@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: =?ISO-8859-1?Q?Vasco_N=E9voa?= <vasco.nevoa@sapo.pt>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just to make data restoring a bit safer - one can use device mappers's
snapshot feature as it can snapshot _any_ block device, you can create
snapshots of say /dev/sda1 & /dev/sdb1 , then do your raid experiments
on that snapshotted devices.

More info http://www.mjmwired.net/kernel/Documentation/device-mapper/sn=
apshot.txt
https://www.redhat.com/archives/dm-devel/2004-July/msg00071.html

2011/7/23 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Sat, 23 Jul 2011, Vasco N=E9voa wrote:
>
>> I initially used "mdadm --create --assume-clean ..." on a level1 arr=
ay of
>> 2 disks that came from another machine. I didn't know any other way =
of
>> starting an array in this situation. While this is an acceptable pra=
ctice in
>> some cases, it is better to use "--assemble" and pass the necessary =
info
>> (like uuid).
>
> In case someone finds this from the archives:
>
> mdadm --create --assume-clean is a LAST RESORT. It's to be used when
> everything else fails. I've seen so many start doing this way too ear=
ly in
> the process and who then subsequently lost their data because of supe=
rblock
> version and mdadm changes over time (especially when they forgot
> --assume-clean and got the layout wrong).
>
> --
> Mikael Abrahamsson =A0 =A0email: swmike@swm.pp.se



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
