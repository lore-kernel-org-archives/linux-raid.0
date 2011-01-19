From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 19 Jan 2011 20:21:04 +0100
Message-ID: <20110119192104.1FA92D30267@gemini.denx.de>
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
>=20
> [in English:] Dude, the disks are your bottleneck.
=2E..

Maybe we can stop speculations about what might be the cause of the
problems in some setup I do NOT intend to use, and rather discuss the
questions I asked.

> > I will have 4 x 1 TB disks for this setup.
> >=20
> > The plan is to build a RAID0 from the 4 devices, create a physical
> > volume and a volume group on the resulting /dev/md?, then create 2 =
or
> > 3 logical volumes that will be used as XFS file systems.

Clarrification: I'll run /dev/md* on the raw disks, without any
partitions on them.

> > My goal is to optimize for maximum number of I/O operations per
> > second. ...
> >=20
> > Is this a reasonable approach for such a task?
> >=20
> > Should I do anything different to acchive maximum performance?
> >=20
> > What are the tunables in this setup?  [It seems the usual recipies =
are
> > more oriented in maximizing the data troughput for large, mostly
> > sequential accesses - I figure that things like increasing read-ahe=
ad
> > etc. will not help me much here?]

So can anybody help answering these questions:

- are there any special options when creating the RAID0 to make it
  perform faster for such a use case?
- are there other tunables, any special MD / LVM / file system /
  read ahead / buffer cache / ... parameters to look for?

Thanks.

Wolfgang Denk

--=20
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Boykottiert Microsoft - Kauft Eure Fenster bei OBI!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
