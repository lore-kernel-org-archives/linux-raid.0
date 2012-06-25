From: Jose Manuel dos Santos Calhariz <jose.spam@netvisao.pt>
Subject: Re: linux-image-2.6.32-5-686: kernel BUG at ...
 build/source_i386_none/drivers/md/raid5.c:2764!
Date: Mon, 25 Jun 2012 11:59:04 +0100
Message-ID: <20120625105903.GA6005@calhariz.com>
References: <20120622121953.GA25149@calhariz.com>
 <20120624182146.7d63fbbb@notabene.brown>
 <20120624170234.GA13154@calhariz.com>
 <20120625123906.2c302212@notabene.brown>
 <20120625115833.71190b7e@batzmaru.gol.ad.jp>
 <20120625164230.2ba8f72c@notabene.brown>
Reply-To: jose.spam@netvisao.pt
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120625164230.2ba8f72c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Christian Balzer <chibi@gol.com>, linux-raid@vger.kernel.org, Jose Manuel dos Santos Calhariz <jose.spam@netvisao.pt>
List-Id: linux-raid.ids


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 25, 2012 at 04:42:30PM +1000, NeilBrown wrote:
> On Mon, 25 Jun 2012 11:58:33 +0900 Christian Balzer <chibi@gol.com> wrote:
>=20
> > On Mon, 25 Jun 2012 12:39:06 +1000 NeilBrown wrote:
> >=20
> > > On Sun, 24 Jun 2012 18:02:34 +0100 Jose Manuel dos Santos Calhariz
> > > <jose.spam@netvisao.pt> wrote:
> > >=20
> > > > On Sun, Jun 24, 2012 at 06:21:46PM +1000, NeilBrown wrote:
> > > > > On Fri, 22 Jun 2012 13:19:53 +0100 Jose Manuel dos Santos Calhariz
> > > > > <jose.spam@netvisao.pt> wrote:
> > > > >=20
> > > > > >=20
> > > > > > In another day during the periodic mdadm RAID check:=20
> > > > > >  - the linux kernel gave a kernel BUG,=20
> > > > > >  - tried to kick out a failed disk and=20
> > > > > >  - stopped accepting I/O to the affected raid. =20
> > > > > >=20
> > > > > > The affected programs were in state D.  The only way to recover
> > > > > > was to do a reboot.  After reboot the problematic disk was
> > > > > > replaced.
> > > > > >=20
> > > > > > I reported the bug to Debian and is there all the information
> > > > > > about it:
> > > > > >=20
> > > > > > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D675969
> > > > > >=20
> > > > > > I was asked to report the BUG here in case someone knows what
> > > > > > happened.
> > > > > >=20
> > > > > > Here is a summary of the more relevant information:
> > > > > >=20
> > > > > > This machine have 2 x RAID6 with 6 disks each, for a total of 12
> > > > > > disks.=20
> > > > > >=20
> > > > > > I have 5 systems with a similar setup and only one failed, maybe
> > > > > > because of the failing disk.  I will use one of the systems to =
try
> > > > > > to reproduce the bug, before triyng a new kernel.
> > > > > >=20
> > > > > >=20
> > > > > > The proprietary module is the openafs filesystem v1.6.1 backpor=
ted
> > > > > > from Debian testing.
> > > > > >=20
> > > > > > The kernel bug is:
> > > > > >=20
> > > > > >=20
> > > > > > build/source_i386_none/drivers/md/raid5.c:2764!
> > > >=20
> > > > >=20
> > > > > This bug was fixed in 2.6.32.49 and 3.2
> > > > >=20
> > > > > http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.g=
it;a=3Dcommitdiff;h=3D61d433c479a6ccfed6a7e73e6111ca8fa0348c63
> > > > >=20
> > > > > http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=
=3Dcommitdiff;h=3D9a3f530f39f4490eaa18b02719fb74ce5f4d2d86
> > > > >=20
> > > > > NeilBrown
> > > >=20
> > > > The failing kernel had that fix all ready.  The machine was running
> > > > the kernel Debian 2.6.32-41squeeze2.  Looking into the change log,
> > > > this kernel have all the fixes until 2.6.32.51 plus other fixes.
> > > >=20
> > > >      Jose Calhariz
> > > >=20
> > >=20
> > > The oops report said:
> > >=20
> > > (2.6.32-5-686 #1)
> > >=20
> > > is "5" the same as "41squeeze2" ???  This is a genuine question - I h=
ave
> > > little idea about Debian versioning so maybe these are the same thing
> > > somehow.  But they look different.
> > >=20
> > Yes, the "name' of the kernel and it's actual detail version are disjun=
ct
> > like that in Debian, the current kernel of that vintage is:
> > ---
> > Package: linux-image-2.6.32-5-amd64
> > Source: linux-2.6
> > Version: 2.6.32-44
> > ---
>=20
> Ok.
> So the version number reported by "uname -a" doesn't change when you upgr=
ade
> a Debian kernel?  That's rather sad.
> I means that one has to take the reporters work for which kernel was runn=
ing
> rather than looking in the oops message for where the kernels tells me
> what version it was.
>=20
> Given the report, it is entirely possible that an older kernel was running
> while a newer kernel was installed.
>=20
> Jose: how certain are you that the kernel that was running at the time was
> exactly the kernel that was installed at the time.  i.e. you had not
> performed a software update since the last reboot?



Whenever I reboot a server I run a script to collect information about
it: Kernel boot messages, kernel version, kernel modules, md raid
information, etc.

So I have the kernel boot messages for the precise boot that gave the
BUG.  From that boot log:

[    0.000000] Linux version 2.6.32-5-686 (Debian 2.6.32-41squeeze2)
(dannf@debian.org) (gcc version 4.3.5 (Debian 4.3.5-4) ) #1 SMP Mon
Mar 26 05:20:33 UTC 2012



The version of the running kernel is 2.6.32-41squeeze2.  In the
changelog of the Debian package, for version 2.6.32-41:=20

   * Add longterm release 2.6.32.54

The complete changelog, in case someone want look into it:
http://packages.debian.org/changelogs/pool/main/l/linux-2.6/linux-2.6_2.6.3=
2-45/changelog



On the previous Debian version 2.6.32-40 there is this entry on the
changelog:=20

   * Add longterm release 2.6.32.49, including:
     - SCSI: st: fix race in st_scsi_execute_end
     - NFS/sunrpc: don't use a credential with extra groups.
     - netlink: validate NLA_MSECS length
     - hfs: add sanity check for file name length (CVE-2011-4330)
     - md/raid5: abort any pending parity operations when array fails.
     - mm: avoid null pointer access in vm_struct via /proc/vmallocinfo
     - ipv6: udp: fix the wrong headroom check (CVE-2011-4326)
     - USB: Fix Corruption issue in USB ftdi driver ftdi_sio.c


The complete boot log is on:

http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=3D15;filename=3Dkernel-boo=
t;att=3D1;bug=3D675969



>=20
> However even if you can confirm that a new kernel was running I doubt I c=
ould
> find an answer.  There isn't really much info to go on.  So unless you can
> reproduce the problem, I doubt I'll even start looking.

I have too much information about the system that gave the BUG, but no
way to sort it out what is relevant and what it's not relevant.  Is
there anything more you would like to know?

I understand if you can't help me.  I have 5 similar servers that are
running 2.6.32.x for 3 months but I have 1 BUG only.  I have one
server where I am trying to reproduce the BUG without avail. =20

 - Doing a re-sync of the RAID when there is a "error read corrected"
   don't trigger the BUG.

 - Hot unplug a disk don't trigger the BUG.

My guess is this bug is related with bad disks and errors messages
that sometimes the disks give to the kernel.  But is more difficult to
find disks that give this errors messages in a reproducible way than
finding disks with bad sectors for the test server.


>=20
> NeilBrown



--=20
--

Ambi=E7=E3o: um supremo desejo de ser vilipendiado por seus inimigos enquan=
to voc=EA est=E1 vivo e ser ridicularizado pelos amigos quando estiver morto

--Ambrose Bierce

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJP6ER3AAoJEDSKd41ohe+PP7UP/3Ckp2jKG+PZCFRbcxkh5aTK
NkVZrlrsCJ29aNKgctAaHRIgW3jTjdDrl/KCoavZ51vGsLck/nwcUOzVo3YuPVLI
dC0vT7s9X5IOjZVXjqfTpknDQrFJJIEXW/fjlcnmF5Yr45iD2oYvNZVwuMapSBtF
/1u8ZLvk2sZQgkr+khCgzSHvXXeA6TXTsYdHryKaZvD5Wmo7eSCkTMrpJPZ6+f6m
iJblGk89rhzmsfoF1sHjNWjS18y7slm0ZhiTjsQZxePWsoR1ibTxD4/FTdqd4GGf
YMn7wnfxgh3rQaXxV/nOol2oBiUJb4DMaasB1GbGMjxSLX+IjeKprXpe2DX9B1tc
XJwCL5D4fc7N+Xygftfpv9rjJhOFXRS1Amh0RvUNU4YLsD7SLXyuSQdLs0ytrBWt
ox511i94czQ19VrIgShEPuMP1VjR18yMN0WxJiFoXq5VQHl+U9hOGyzYSnCA3Zo1
xp8NjUm4EENVWu/5+PdXEPt0zpb4xo090BEgdj4upmQ4JXSXsYjPFk7Yxfl2BL0u
BrxzWp79EWiA7z1L4tsxTUUy0HjBB0+ltcwg+/qqHXo2NTox/o0cPE57ElQgh94o
3tzTOH3m5wYjW+XcgaxVzivhsgAWwNxiUi47gF/Y2+WN03r+tu0DYaT1z5JwqYBV
P3SQhdpgJPD9O5uCGzSb
=E2On
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
