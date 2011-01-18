From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 19 Jan 2011 00:15:50 +0100
Message-ID: <4D361F26.3060507@stud.tu-ilmenau.de>
References: <20110118210112.D13A236C@gemini.denx.de>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110118210112.D13A236C@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

[in German:] Sch=E4tzelein, Dein Problem sind die Platten, nicht der
Controller.

[in English:] Dude, the disks are your bottleneck.

On a 4-disk RAID0 software RAID can only outspeed this 3ware Controller
with a really really fast processor.  The limiting factor is the disk's
access time.  If SSDs are too expensive, then your actual performance i=
s
the max you'll get (maybe to replace the HWRAID controller might give a
little speed-up, but not very much).

All the best,
Stefan

Am 18.01.2011 22:01, schrieb Wolfgang Denk:
> Hi,
>=20
> I'm going to replace a h/w based RAID system (3ware 9650SE) by a plai=
n
> s/w RAID0, because the existing system appears to be seriously limite=
d
> in terms of numbers of I/O operations per second.
>=20
> Our workload is mixed read / write (something between 80% read / 20%
> write and 50% / 50%), consisting of a very large number of usually
> very small files.
>=20
> There may be 20...50 millions of files, or more. 65% of the files are
> smaller than 4 kB; 80% are smaller than 8 kB; 90% are smaller than 16
> kB; 98.4% are smaller than 64 kB.
>=20
> I will have 4 x 1 TB disks for this setup.
>=20
> The plan is to build a RAID0 from the 4 devices, create a physical
> volume and a volume group on the resulting /dev/md?, then create 2 or
> 3 logical volumes that will be used as XFS file systems.
>=20
> My goal is to optimize for maximum number of I/O operations per
> second. [I am aware that using SSDs would be a nice thing, but that
> would be too expensive.]
>=20
> Is this a reasonable approach for such a task?
>=20
> Should I do anything different to acchive maximum performance?
>=20
> What are the tunables in this setup?  [It seems the usual recipies ar=
e
> more oriented in maximizing the data troughput for large, mostly
> sequential accesses - I figure that things like increasing read-ahead
> etc. will not help me much here?]
>=20
> Thanks in advance.
>=20
> Best regards,
>=20
> Wolfgang Denk
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
