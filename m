From: Janusz Zamecki <janusz@pipi.ma.cx>
Subject: RE: RAID1 & 2.6.9 performance problem
Date: Tue, 18 Jan 2005 19:41:03 +0100
Message-ID: <1106073663.14134.249.camel@pipi.ma.cx>
References: <OMEKLMBKKEOEENCKLEIDGEFGCAAA.ryan@dynaconnections.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OMEKLMBKKEOEENCKLEIDGEFGCAAA.ryan@dynaconnections.com>
Sender: linux-raid-owner@vger.kernel.org
To: "J. Ryan Earl" <ryan@dynaconnections.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W li=B6cie z wto, 18-01-2005, godz. 18:34, J. Ryan Earl pisze:=20
> "You will get 2 parallel sequential reads at around 120MB/sec
> assuming you're not bus limited."
>=20
> To clarify because this looks ambiguous to me now, you should be able=
 to
> perform 2 parallel sequential reads both at 60MB/sec =3D 120MB/sec to=
tal.
>=20
> -ryan
>=20

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
