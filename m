From: jim owens <jowens@hp.com>
Subject: Re: MD performance options: More =?windows-1252?Q?CPU=92s_or_?=
 =?windows-1252?Q?more_Hz=92s=3F?=
Date: Wed, 04 Nov 2009 10:41:44 -0500
Message-ID: <4AF1A0B8.2080807@hp.com>
References: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com>	 <4AF18A39.6010404@tmr.com> <66781b10911040634mcdc3c70jec3410c09003fb6c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10911040634mcdc3c70jec3410c09003fb6c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mark delfman wrote:
> Thank you Bill... maybe a silly question but doesn=92t the fact we ca=
n
> achieve 1.6GBsec on MD RAID0 mean we have drive bandwidth available t=
o
> MD to use?  To the block device (sas drives in this case) it does not
> know if the data is been xor=92d or just striped, its just blocks of
> data.  So wouldn=92t this mean that we know that MD RAID6 =91could=92
> achieve up to 1.6GB if the software could send it out quicker?
>=20
> Hence my logic of =91deal with MD software aspects faster =3D faster =
writes=92

Are your tests and assumptions valid... remember that raid6
will put 1.6GB of data on the drives for each 800MB of data
from the application in minimum 4 stripe mode (2 data stripes,
1 P stripe, 1 Q stripe).

So the proper comparison of raid6 software overhead is to
run the same application writing a fixed large amount of data
to 4 drives at raid0 and the same 4 drives at raid6.

   overhead =3D raid0_time * 2 - raid6_time;

Of course if you add more data stripes, the ratio of
user data to disk data gets better than 1/2.

jim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
