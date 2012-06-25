From: NeilBrown <neilb@suse.de>
Subject: Re: linux-image-2.6.32-5-686: kernel BUG at ...
 build/source_i386_none/drivers/md/raid5.c:2764!
Date: Mon, 25 Jun 2012 16:42:30 +1000
Message-ID: <20120625164230.2ba8f72c@notabene.brown>
References: <20120622121953.GA25149@calhariz.com>
	<20120624182146.7d63fbbb@notabene.brown>
	<20120624170234.GA13154@calhariz.com>
	<20120625123906.2c302212@notabene.brown>
	<20120625115833.71190b7e@batzmaru.gol.ad.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WL_o8uEK5QhpcV8ZEk.qNON"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625115833.71190b7e@batzmaru.gol.ad.jp>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Balzer <chibi@gol.com>
Cc: linux-raid@vger.kernel.org, Jose Manuel dos Santos Calhariz <jose.spam@netvisao.pt>
List-Id: linux-raid.ids

--Sig_/WL_o8uEK5QhpcV8ZEk.qNON
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2012 11:58:33 +0900 Christian Balzer <chibi@gol.com> wrote:

> On Mon, 25 Jun 2012 12:39:06 +1000 NeilBrown wrote:
>=20
> > On Sun, 24 Jun 2012 18:02:34 +0100 Jose Manuel dos Santos Calhariz
> > <jose.spam@netvisao.pt> wrote:
> >=20
> > > On Sun, Jun 24, 2012 at 06:21:46PM +1000, NeilBrown wrote:
> > > > On Fri, 22 Jun 2012 13:19:53 +0100 Jose Manuel dos Santos Calhariz
> > > > <jose.spam@netvisao.pt> wrote:
> > > >=20
> > > > >=20
> > > > > In another day during the periodic mdadm RAID check:=20
> > > > >  - the linux kernel gave a kernel BUG,=20
> > > > >  - tried to kick out a failed disk and=20
> > > > >  - stopped accepting I/O to the affected raid. =20
> > > > >=20
> > > > > The affected programs were in state D.  The only way to recover
> > > > > was to do a reboot.  After reboot the problematic disk was
> > > > > replaced.
> > > > >=20
> > > > > I reported the bug to Debian and is there all the information
> > > > > about it:
> > > > >=20
> > > > > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D675969
> > > > >=20
> > > > > I was asked to report the BUG here in case someone knows what
> > > > > happened.
> > > > >=20
> > > > > Here is a summary of the more relevant information:
> > > > >=20
> > > > > This machine have 2 x RAID6 with 6 disks each, for a total of 12
> > > > > disks.=20
> > > > >=20
> > > > > I have 5 systems with a similar setup and only one failed, maybe
> > > > > because of the failing disk.  I will use one of the systems to try
> > > > > to reproduce the bug, before triyng a new kernel.
> > > > >=20
> > > > >=20
> > > > > The proprietary module is the openafs filesystem v1.6.1 backported
> > > > > from Debian testing.
> > > > >=20
> > > > > The kernel bug is:
> > > > >=20
> > > > >=20
> > > > > build/source_i386_none/drivers/md/raid5.c:2764!
> > >=20
> > > >=20
> > > > This bug was fixed in 2.6.32.49 and 3.2
> > > >=20
> > > > http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dcommitdiff;h=3D61d433c479a6ccfed6a7e73e6111ca8fa0348c63
> > > >=20
> > > > http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3D=
commitdiff;h=3D9a3f530f39f4490eaa18b02719fb74ce5f4d2d86
> > > >=20
> > > > NeilBrown
> > >=20
> > > The failing kernel had that fix all ready.  The machine was running
> > > the kernel Debian 2.6.32-41squeeze2.  Looking into the change log,
> > > this kernel have all the fixes until 2.6.32.51 plus other fixes.
> > >=20
> > >      Jose Calhariz
> > >=20
> >=20
> > The oops report said:
> >=20
> > (2.6.32-5-686 #1)
> >=20
> > is "5" the same as "41squeeze2" ???  This is a genuine question - I have
> > little idea about Debian versioning so maybe these are the same thing
> > somehow.  But they look different.
> >=20
> Yes, the "name' of the kernel and it's actual detail version are disjunct
> like that in Debian, the current kernel of that vintage is:
> ---
> Package: linux-image-2.6.32-5-amd64
> Source: linux-2.6
> Version: 2.6.32-44
> ---

Ok.
So the version number reported by "uname -a" doesn't change when you upgrade
a Debian kernel?  That's rather sad.
I means that one has to take the reporters work for which kernel was running
rather than looking in the oops message for where the kernels tells me
what version it was.

Given the report, it is entirely possible that an older kernel was running
while a newer kernel was installed.

Jose: how certain are you that the kernel that was running at the time was
exactly the kernel that was installed at the time.  i.e. you had not
performed a software update since the last reboot?

However even if you can confirm that a new kernel was running I doubt I cou=
ld
find an answer.  There isn't really much info to go on.  So unless you can
reproduce the problem, I doubt I'll even start looking.

NeilBrown

--Sig_/WL_o8uEK5QhpcV8ZEk.qNON
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+gIVjnsnt1WYoG5AQJH8A//eDAlWkLJOh0WnOJyTlLXs2qVNlxZdS2b
F3f+ag7BlZXI1oFQSjwpLHYmqhovcSEC24MpQSwZopPfvuc4XeasTJP/eKnn9lX4
SyfIpO/VKi4LZNKDIvm6jiVy8qdnrP99DgCTh5srN3Ep4X1kKKavii8CG3akgHt6
QrMaDqSVOSM8cE5J8Q775M2Ab0yU0gjYgNwe83uaBZ8v7MLUA4XzKPnNqE3gxaGw
b+2Ol1whUv8VILMUWPtITT8Nclb1YO00bOafFEVynto62r+bNKOX1iJY/w4wJdzn
KM6kBDELzGfrAd1qEU7MG/9VKpfqQ3B2uFGuf8/YkXPGGoX8FQnOWmE1Hkze39I9
bhpfwyFhkzBZ01dAS2Uokby+GLjnjl293k+Feb8a3Hejh2gFuFPHpdwXkpnMt6RL
3Q9xoIQBI/uO29/EayHorLFn2XwPcVT+0gNXTBmvh2atk7bEJvPtIcd47eCm7s2d
cDkkI0LW3IEK+egOJPX5i/qBogUk53+VIufLvMAQibjqCi6hivDqyDMyZE75LshO
izqmygKHXvLW4Qo2MStvMdwi/X0JdqhFDHE/h/WEBpn7atlMOZeKvYMw9f4HWBPS
9ihd1r+lwvNA/76wCKg4i7d3M2uY9UuoFY0mY44v9lJuLcV5gDrZdDb1Q/EL/Cag
7kOa2217iJE=
=gDVm
-----END PGP SIGNATURE-----

--Sig_/WL_o8uEK5QhpcV8ZEk.qNON--
