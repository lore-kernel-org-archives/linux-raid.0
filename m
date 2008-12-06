From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Have the velociraptors in a test system now, checkout the
 errors.
Date: Sat, 6 Dec 2008 12:32:36 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812061224460.21825@p34.internal.lan>
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan> <493A5E62.1020508@msgid.tls.msk.ru> <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan> <493AAE8D.8070607@yuiop.co.uk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-271602853-1228584756=:21825"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <493AAE8D.8070607@yuiop.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@yuiop.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-271602853-1228584756=:21825
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 6 Dec 2008, John Robinson wrote:

> On 06/12/2008 12:11, Justin Piszcz wrote:
>> As far the PSU, just btw/FYI, Velociraptors consume ~4-5 watts a piece,=
=20
>
> These are the 2.5" drives, yes?
Yup.

> Even then, I think that's very unlikely; they=20
> don't even claim any better than 6W operating, I think 8-10W is more like=
ly.=20
http://www.wdc.com/en/products/Products.asp?DriveID=3D494

 =09Power Dissipation
 =09Read/Write=096.08 Watts
 =09Idle=094.53 Watts

Independent reviews (anandtech etc) also seem to confirm this finding.

They are roughly half a regular raptor150, my system uses 200-210 watts now
that I went back with the raptor150s in my main server.  Before it used
around 100-120.

> Even if they are running as low as 5-6W, they're so much smaller than 3.5=
"=20
> drives that heat could still cause problems. Can you check what temps the=
=20
> drives have reached, using smartctl?
The temps were always between 20-30c.

Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sda: WDC WD3000HLFS-01G6U0: 27=B0C
Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sdb: WDC WD3000HLFS-01G6U0: 24=B0C
Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sdc: WDC WD3000GLFS-01F8U0: 24=B0C
Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sdd: WDC WD3000GLFS-01F8U0: 22=B0C
Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sde: WDC WD3000GLFS-01F8U0: 22=B0C
Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sdf: WDC WD3000GLFS-01F8U0: 24=B0C
Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sdg: WDC WD3000GLFS-01F8U0: 25=B0C
Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sdh: WDC WD3000GLFS-01F8U0: 25=B0C
Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sdi: WDC WD3000GLFS-01F8U0: 25=B0C
Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sdj: WDC WD3000GLFS-01F8U0: 22=B0C
Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sdk: WDC WD3000GLFS-01F8U0: 22=B0C
Nov 25 13:00:02 p34 hddtemp[9588]: /dev/sdl: WDC WD3000GLFS-01F8U0: 23=B0C

>
>> my entire system used ~100-120watts with all 12 velociraptors on a 650 w=
att=20
>> PSU (now moved into a test system).
>
> Do you have your dozen drives on a staggered start or all at power-on?
All of them start at the same time, I do not use staggered start.

> I could see 12 drives starting at once causing damage to almost any 650W =
PSU=20
> unless it's designed specifically for hard drive enclosures, due to the=
=20
> relatively enormous current draw at startup - called inrush current.
I wonder if this is a thing of the past, I have several PSUs, all 550+
and a number of systems have 12 drives+ in them, they all surge up to 500-5=
50
watts or so on startup but no drive and no system has any problems whatsoev=
er,
except the velociraptors.

BTW:

Latest update is I removed the velociraptors from my main system, replaced =
them
with Raptor150s and yeah it does use 500+ watts at startup according to the=
 LCD
on the UPS and also a using Kill-A-Watt but all my problems are gone, I hav=
e
been writing to the disks, running smart tests, running RAID VERIFY over th=
e
array, writing nearly continuously and not a single error of any kind.

I think there is something wrong with Velociraptors + Linux, at some point =
I
suppose it would be worth trying to use them in Windows and see if I can
reproduce the problems.

Justin.

---1463747160-271602853-1228584756=:21825--
