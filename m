From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: RE: linux disk access when idle
Date: Fri, 21 Aug 2009 01:17:23 -0700 (PDT)
Message-ID: <371021.65217.qm@web51309.mail.re2.yahoo.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A6F9E25@SE-EX008.groupinfra.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A6F9E25@SE-EX008.groupinfra.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, AndrewHenry <andrew.henry@logica.com>
List-Id: linux-raid.ids




--- On Fri, 21/8/09, Henry, Andrew <andrew.henry@logica.com> wrote:

> From: Henry, Andrew <andrew.henry@logica.com>
> Subject: RE: linux disk access when idle
> To: "Matt Garman" <matthew.garman@gmail.com>, "linux-raid" <linux-rai=
d@vger.kernel.org>
> Date: Friday, 21 August, 2009, 7:42 AM
> I had a similar issue, as I wanted to
> take full advantage of parking heads but they kept coming
> alive again.=A0 I was putting them to sleep with hdparm.
>=20
> I gave up at the end, but thought I had read that it was
> likely syslog or other internals that were polling the disc
> too frequently.=A0 Sorry Im a bit vague on the details.
>=20
> If this was the case (I didn't really investigate) then I
> thought, stuff it, because I wanted syslog to keep doing
> it's thing.
>=20
> --andrew
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20

I did this with the data drives in my array - never managed it with the=
 system drives though.

You need to tell smartd to not poll if the drives are asleep and also t=
ell syslog not to poll too often.=20

There is some for of flag you can apply to see write requests and the a=
pplication that is doing them.......?

BUT a curious problem I have - and have NEVER really solved is that whe=
n a drive is asleep if a scheduled smart check runs - the drive doesn't=
 wake up quickly enough so smart brands the drive as 'incapable of a sm=
art test' and sends me a warning email.... every single time...

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'
-----------------------


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
