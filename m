From: Jose Manuel dos Santos Calhariz <jose.spam@netvisao.pt>
Subject: Re: linux-image-2.6.32-5-686: kernel BUG at ...
 build/source_i386_none/drivers/md/raid5.c:2764!
Date: Sun, 24 Jun 2012 18:02:34 +0100
Message-ID: <20120624170234.GA13154@calhariz.com>
References: <20120622121953.GA25149@calhariz.com>
 <20120624182146.7d63fbbb@notabene.brown>
Reply-To: jose.spam@netvisao.pt
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120624182146.7d63fbbb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: jose.spam@netvisao.pt, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 24, 2012 at 06:21:46PM +1000, NeilBrown wrote:
> On Fri, 22 Jun 2012 13:19:53 +0100 Jose Manuel dos Santos Calhariz
> <jose.spam@netvisao.pt> wrote:
>=20
> >=20
> > In another day during the periodic mdadm RAID check:=20
> >  - the linux kernel gave a kernel BUG,=20
> >  - tried to kick out a failed disk and=20
> >  - stopped accepting I/O to the affected raid. =20
> >=20
> > The affected programs were in state D.  The only way to recover was to
> > do a reboot.  After reboot the problematic disk was replaced.
> >=20
> > I reported the bug to Debian and is there all the information about it:
> >=20
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D675969
> >=20
> > I was asked to report the BUG here in case someone knows what happened.
> >=20
> > Here is a summary of the more relevant information:
> >=20
> > This machine have 2 x RAID6 with 6 disks each, for a total of 12 disks.=
=20
> >=20
> > I have 5 systems with a similar setup and only one failed, maybe
> > because of the failing disk.  I will use one of the systems to try to
> > reproduce the bug, before triyng a new kernel.
> >=20
> >=20
> > The proprietary module is the openafs filesystem v1.6.1 backported
> > from Debian testing.
> >=20
> > The kernel bug is:
> >=20
> >=20
> > build/source_i386_none/drivers/md/raid5.c:2764!

>=20
> This bug was fixed in 2.6.32.49 and 3.2
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dc=
ommitdiff;h=3D61d433c479a6ccfed6a7e73e6111ca8fa0348c63
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommit=
diff;h=3D9a3f530f39f4490eaa18b02719fb74ce5f4d2d86
>=20
> NeilBrown

The failing kernel had that fix all ready.  The machine was running
the kernel Debian 2.6.32-41squeeze2.  Looking into the change log,
this kernel have all the fixes until 2.6.32.51 plus other fixes.

     Jose Calhariz

--=20
--

Ambi=E7=E3o: um supremo desejo de ser vilipendiado por seus inimigos enquan=
to voc=EA est=E1 vivo e ser ridicularizado pelos amigos quando estiver morto

--Ambrose Bierce

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJP50gpAAoJEDSKd41ohe+PZ2gP/jH2+52UiJ77DtCSdOFsq+67
EsibupV5lkfwQELS++r4m3ZfsvZxbrR12oMuu9NnKCZYSuBSbCnHJvJl/i3mEYrW
vMak93FHDrfO2azK6xCuwTKr2oBcNk+px62T+xsoU/n6/nGreWySKy0txhd/1gHe
gFlf1eHMN2p6dX4hcWX8CDaqCRl0VDTaANwiFQ8957UgeG97XZO0AK2fMonhG9Ia
QC40Ft4vGbOnWP2iKfIZtB5mmjsq+Xhtu9+EDqddXPh7sYplBJ9HIwePO7wRfyUL
RXQDishqMQI8GDNajR8oRVUXunNeSi7HA4s2NTgxb1Hpp7l8H40vKUK8RHWCIAt5
w3acT0E1tXsG2ETYQZVyZk+LApu2iY5OIkQVNhWTL55tPhIp0xjTJr1q2c7WPLKB
fzMTtMXxaEtmfouWHeZCgXc9PQFotiHWNrMt3IAO+Pi922tzK+I4QUSctV0Tca4U
oWJoX4xeiHpJLv8WLvHTRb7Rt6NRw1PK0Xq9g7aGVcocx9EO1VtgEvcnt4ylNbRS
nLb80TCjbqkaD86nK5Qff1IAmBm0pG0Z8aocIWQCXhWJNS2lDlDS3EATo/3ScYdc
hBgPzbyxmoYExchBPE22HrNbsK7m9LRnnO2gN/Wj3Rocqt8YLMiQ2P974+MzxwQy
19YQA0lUc6Z93AoHNmWD
=O6M4
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
