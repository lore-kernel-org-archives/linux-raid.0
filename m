From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Date: Wed, 28 May 2008 19:00:29 -0400
Message-ID: <483DE40D.8090608@tmr.com>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>	<95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com> <20080528195752.0cdcbc6d@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080528195752.0cdcbc6d@core>
Sender: linux-raid-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: =?UTF-8?B?SmVucyBCw6Rja21hbg==?= <jens.backman@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Alan Cox wrote:
> On Wed, 28 May 2008 18:34:00 +0200
> "Jens B=C3=A4ckman" <jens.backman@gmail.com> wrote:
>=20
>> On Wed, May 28, 2008 at 10:53 AM, Justin Piszcz <jpiszcz@lucidpixels=
=2Ecom> wrote:
>>> Results:
>>>
>>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
>>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
>> Either the RAID 1 read speed must be wrong, or something is odd in t=
he
>> Linux implementation. There's six drives that can be used for readin=
g
>> at the same time, as they contain the very same data. 63MB/s
>> sequential looks like what you would get from a single drive.
>=20
> Which is fairly typical of a cheap desktop PC where the limitation is=
 the
> memory and PCI bridge as much as the drive.
>=20
I really don't think that's any part of the issue, the same memory and=20
bridge went 4-5x faster in other read cases. The truth is that the=20
raid-1 performance is really bad, and it's the code causing it AFAIK. I=
f=20
you track the actual io it seems to read one drive at a time, in order,=
=20
without overlap.

--=20
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
