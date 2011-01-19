From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 19 Jan 2011 08:10:06 +0100
Message-ID: <20110119071006.C05B12FC@gemini.denx.de>
References: <20110118210112.D13A236C@gemini.denx.de> <4D361F26.3060507@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4D361F26.3060507@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: stefan.huebner@stud.tu-ilmenau.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear =3D?ISO-8859-15?Q?Stefan_/*St0fF*/_H=3DFCbner?=3D,

In message <4D361F26.3060507@stud.tu-ilmenau.de> you wrote:
>=20
> [in German:] Sch=E4tzelein, Dein Problem sind die Platten, nicht der
> Controller.

Irrtum.

> [in English:] Dude, the disks are your bottleneck.

Wrong.  Testing the same workload with soft RAID versus the h/w RAID
solution gives a _significant_ performance difference.

I happen to know which benchmarks 3ware (and other RAID controller
manufacturers) are optimizing their firmware for - IOPS is not even
mentioned there.

> On a 4-disk RAID0 software RAID can only outspeed this 3ware Controll=
er
> with a really really fast processor.  The limiting factor is the disk=
's
> access time.  If SSDs are too expensive, then your actual performance=
 is
> the max you'll get (maybe to replace the HWRAID controller might give=
 a
> little speed-up, but not very much).

=46rom some tests done before I expect to see a speed increase of >10.

Hey, even a single disk is performing better under this work load.

And fast processor? Yes, I have it, but what for? It spends most of
it's time (>90%, usually more) in iowait.

Best regards,

Wolfgang Denk

--=20
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"To IBM, 'open' means there is a modicum  of  interoperability  among
some of their equipment."                            - Harv Masterson
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
