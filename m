From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Partition or whole disk ?
Date: Wed, 30 Jun 2004 12:11:59 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200406301611.i5UGBx330434@watkins-home.com>
References: <20040630145547.GV29086@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040630145547.GV29086@lug-owl.de>
To: 'Jan-Benedict Glaw' <jbglaw@lug-owl.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A partition of type FD is required to autodetect the array(s).

Guy

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jan-Benedict Gla=
w
Sent: Wednesday, June 30, 2004 10:56 AM
To: linux-raid@vger.kernel.org
Subject: Re: Partition or whole disk ?

On Wed, 2004-06-30 10:15:41 -0400, Josh Litherland <josh@emperorlinux.c=
om>
wrote in message <1088604941.2840.1.camel@JubJub>:
>=20
> Couldn't find an authoritative answer to this in the faq or elsewhere=
=2E..

Use either one of those.

> Is it preferred to build md sets out of whole disks or of partitions =
?=20

I can't remember any recommendation being spoken out ever. Personally, =
I
prefer having a number of partitions, but that's not a general guide fo=
r
everybody else:)

> Is there any functional reason why either one is better ?

Not really... You loose a few KBs or MBs if you use partitions, but
that's it...

MfG, JBG

--=20
   Jan-Benedict Glaw       jbglaw@lug-owl.de    . +49-172-7608481
   "Eine Freie Meinung in  einem Freien Kopf    | Gegen Zensur | Gegen =
Krieg
    fuer einen Freien Staat voll Freier B=FCrger" | im Internet! |   im=
 Irak!
   ret =3D do_actions((curr | FREE_SPEECH) & ~(NEW_COPYRIGHT_LAW | DRM =
|
TCPA));

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
