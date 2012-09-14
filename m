From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Subject: Re: raid1 issue after disk failure: both disks of the array are still
 active
Date: Fri, 14 Sep 2012 09:45:26 +0200
Message-ID: <5052E096.5040509@linuxsystems.it>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I also would like to know if the raid1 will *surely* use data from the=20
other disk to write on the broken sector after a CHECK. I mean, i did=20
nothing even after a read error on md0 with a "failed command: READ DMA=
"=20
in dmesg (possibly because after a few reads it succeeded reading?). I=20
read that when raid1 is in doubt there is a 50%-50% chance it uses data=
=20
from the good disk, wouldn't be better to fail the broken disk and then=
=20
re-add it to the array?

Cheers,
Niccol=F2
--=20
http://www.linuxsystems.it
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
