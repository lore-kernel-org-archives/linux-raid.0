From: "J. Ryan Earl" <ryan@dynaconnections.com>
Subject: RE: RAID1 & 2.6.9 performance problem
Date: Tue, 18 Jan 2005 13:18:47 -0600
Message-ID: <OMEKLMBKKEOEENCKLEIDOEFICAAA.ryan@dynaconnections.com>
References: <1106073663.14134.249.camel@pipi.ma.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1106073663.14134.249.camel@pipi.ma.cx>
Sender: linux-raid-owner@vger.kernel.org
To: Janusz Zamecki <janusz@pipi.ma.cx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I missed that, sounds like you got an IDE concurrency problem.  Perhaps=
 you
can't read from both ports for some reason.  Don't think it's a raid pr=
oblem
though.

-ryan

-----Original Message-----
=46rom: Janusz Zamecki [mailto:janusz@pipi.ma.cx]
Sent: Tuesday, January 18, 2005 12:41 PM
To: J. Ryan Earl
Cc: linux-raid@vger.kernel.org
Subject: RE: RAID1 & 2.6.9 performance problem


W li=B6cie z wto, 18-01-2005, godz. 18:34, J. Ryan Earl pisze:
> "You will get 2 parallel sequential reads at around 120MB/sec
> assuming you're not bus limited."
>
> To clarify because this looks ambiguous to me now, you should be able=
 to
> perform 2 parallel sequential reads both at 60MB/sec =3D 120MB/sec to=
tal.
>
> -ryan
>

Hi,

Unfortunatelly it is not the case. Please go to my original e-mail. I'v=
e
ran two simultaneous tests and I get:


hdparm -t /dev/md6 &
hdparm -t /dev/md6

This is the result:

--disk/hdg----disk/hde-
_read write _read write
    0     0 :   0     0
    0     0 :   0     0
  124k    0 :26.0M    0
  368k    0 :45.5M    0
    0     0 :   0     0
    0     0 : 896k    0
  124k    0 :1568k    0
    0     0 :   0     0

One disk works with 75% of its full speed, the second one works with
0,6% of its full speed or even less.

Best regards, Janusz

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
