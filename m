From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Subject: Re: raid1 issue after disk failure: both disks of the array are still
 active
Date: Thu, 13 Sep 2012 13:29:34 +0200
Message-ID: <5051C39E.5080108@linuxsystems.it>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <5051B992.7030200@linuxsystems.it> <5051BBC3.4050805@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5051BBC3.4050805@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il 13/09/2012 12:56, Adam Goryachev ha scritto:
> See /etc/default/mdadm:
> # AUTOCHECK:
> #   should mdadm run periodic redundancy checks over your arrays? See
> #   /etc/cron.d/mdadm.
> AUTOCHECK=3Dtrue
>
> Regards,
> Adam

I set it on true since I installed the system.

Cheers,
Niccol=F2
--=20
http://www.linuxsystems.it
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
