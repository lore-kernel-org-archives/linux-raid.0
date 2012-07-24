From: Jaromir Capik <jcapik@redhat.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Tue, 24 Jul 2012 11:09:00 -0400 (EDT)
Message-ID: <1033621438.2057828.1343142540202.JavaMail.root@redhat.com>
References: <CABYL=Tq0w150QMcehdsScUfDfCD2tGFeuROjWjwsepy1rRXk_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=Tq0w150QMcehdsScUfDfCD2tGFeuROjWjwsepy1rRXk_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
List-Id: linux-raid.ids

> yeah, i think this too, but IMO Jamiro exposed a specific scenario,
> let=C2=B4s get back to it and after check a generic scenario,
> he is using small computers (i don=C2=B4t know if it=C2=B4s ARM or X8=
6) with
> space to only 2 disks (i told him to use raid5 or raid6 because the
> checksums but he don=C2=B4t have space for >=3D3 disks in computer ca=
se,
> maybe if we could run raid5 with 2 disks could help... or 1 disk...
> just a idiot idea, but this could help...)

I believe, that Piergiorgio meant something else. It was about
creation of a high number of small partitions on two physical
drives and then build a RAID6 array on top of them. But that's
really a bit overkill :]


> i don=C2=B4t know the real scenario, i think he will not use it in
> 100partitions, maybe 4 or 5 partitions, and performance to be a
> second
> option, security is priority here
> in the implementation of this new layer (maybe like LINEAR, MULTIPATH
> or another not raid level) we could focus on security and after
> performace
>=20
> just some ideas...
>=20
> 2012/7/23 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
> >
> > Hi all,
> >
> > actually, what you would like to do is already
> > possible, albeit it will kill the performance
> > of a rotating, mechanical, HDD.
> > With SSD might work better.
> >
> > If you take an HDD and partition it, let's say
> > with 100 partitions (GPT will be required),
> > then you can build a RAID-6 using this 100
> > partitions, having a redundancy of 2%.
> > Taking two, or more, of such configured RAID-6,
> > it will be possible to build (with them) a
> > RAID-1 (or else).
> >
> > If a check of this RAID-1 returns mismatches,
> > it will be possible to check the single devices
> > and find out which is not OK.
> > With RAID-6 (per device), and a bit of luck, it
> > will be possible to fix it directly.
> >
> > Of course a lot of variables are tunable here.
> > For example the number of partitions, the chunk
> > size, or even the fact that with X partitions
> > it could be possible to build more than one RAID-6,
> > increasing the effective redundancy.
> >
> > All with the performance price I mentioned at the
> > beginning.
> >
> > bye,
> >
> > --
> >
> > piergiorgio
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20
>=20
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
