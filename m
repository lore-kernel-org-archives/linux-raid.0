From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Re: "failed-disk" ?
Date: Mon, 24 Mar 2003 09:34:58 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030324143458.GB683@rdlg.net>
References: <20030320213253.GP13201@rdlg.net> <Pine.LNX.4.44.0303210828520.10546-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0303210828520.10546-100000@duplo.agenda.si>
To: danci@agenda.si
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



  I'm trying to rebuild a system with a non-mirrored root.  I
intentionally killed /dev/sda by yanking it (hotswap disk) and let the
machine croak.  I put the replacement disk in and rebooted, rebuilt (we
have a system similar to jumpstart that makes this very fast and clean).

  I'm at the point of trying to restart /dev/md0 with one mirror dead.
My raidtab looks like this:

raiddev /dev/md0
  raid-level 1
  nr-raid-disks 2
  nr-spare-disks 0
  chunk-size 16
  persistent-superblock 1
  device /dev/lvm-vg1/lvm1
  raid-disk 0
  device /dev/lvm-vg2/lvm2
  raid-disk 1

I changed the first raid-disk line to be:
  failed-disk 0

and then tried:

root@rharris-build2.acs:~# raidstart /dev/md0
/dev/md0: Invalid argument
md: could not lock [dev 9e:0e], zero-size? Marking faulty.
md: could not import [dev 9e:0e]!
md: autostart [dev 9e:0e] failed!


At this point /dev/lvm-vg1/lvm1 doesn't exist and will need to be
rebuilt but I'd like to get the machine up and running with /dev/md0=20
intact.

Any idea what's wrong here? =20

Robert



Thus spake danci@agenda.si (danci@agenda.si):

> On Thu, 20 Mar 2003, Robert L. Harris wrote:
>=20
> >
> >
> > No but according to the RAID HOWTO it says it's a valid keyword for when
> > you need to build a mirror with a failed/missing disk (i.e. converting
> > root to raid and can't kill your existing /)
>=20
> It is, but:
>=20
> 'failed-disk' replaces 'raid-disk' to inform the md driver, that a device
> '/dev/sda1' should not be automatically synchronized.
>=20
> This gives you an operative array in degraded mode, so you can copy files
> from your current root to your new degraded array.
>=20
> You have to change the file /etc/fstab (on the NEW filesystem) to use
> /dev/md0 for root, arrange the boot manager (lilo, grub, whatever) to boot
> with the new root (/dev/md0), reboot and 'un-fail' :) (or add) /dev/sda1
> to the array (using mdadm or raidhotadd).
>=20
>=20
>   D.
>=20
>=20
> >
> >
> > Thus spake Lars Marowsky-Bree (lmb@suse.de):
> >
> > > On 2003-03-20T16:22:50,
> > >    "Robert L. Harris" <Robert.L.Harris@rdlg.net> said:
> > >
> > > > I'm trying to "mkraid /dev/md1" with the following:
> > > >
> > > > raiddev /dev/md1
> > > >   raid-level 1
> > > >   nr-raid-disks 2
> > > >   nr-spare-disks 0
> > > >   chunk-size 16
> > > >   persistent-superblock 1
> > > >   device failed-disk
> > > >   raid-disk 0
> > > >   device /dev/sdb1
> > > >   raid-disk 1
> > > >
> > > > I'm trying to convert this machine to raid1 on root.  Don't ask abo=
ut
> > > > the md1, long story.  At any rate when I do the mkraid I get this:
> > > >
> > > > root@rharris-build2:~# mkraid /dev/md1
> > > > handling MD device /dev/md1
> > > > analyzing super-block
> > > > couldn't call stat() on device failed-disk -- No such file or direc=
tory
> > > > mkraid: aborted, see the syslog and /proc/mdstat for potential clue=
s.
> > >
> > > Does your system have a device named 'failed-disk' ? I would assume n=
ot ;-)
> > >
> > >
> > > Sincerely,
> > >     Lars Marowsky-Br?e <lmb@suse.de>
> > >
> > > --
> > > SuSE Labs - Research & Development, SuSE Linux AG
> > >
> > > "If anything can go wrong, it will." "Chance favors the prepared (min=
d)."
> > >   -- Capt. Edward A. Murphy            -- Louis Pasteur
> >
> > :wq!
> > -----------------------------------------------------------------------=
----
> > Robert L. Harris                     | PGP Key ID: E344DA3B
> >                                          @ x-hkp://pgp.mit.edu
> > DISCLAIMER:
> >       These are MY OPINIONS ALONE.  I speak for no-one else.
> >
> > Diagnosis: witzelsucht
> >
> > IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
> > IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net
> >
>=20
> --=20
> ___________________________________________________________________
> |    Danilo Godec    |     Agenda d.o.o.    |   ISP for business  |
> |  jr. Syst. Admin   |    Gosposvetska 84   |     WAN networks    |
> |  danci@agenda.si   |    si-2000 Maribor   |  Internet/Intranet  |
> | tel:+386.2.2340860 |       Slovenija      | Application servers |
> | fax:+386.2.2340854 | http://www.agenda.si |  Caldera OpenLinux  |
>=20

:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.

Diagnosis: witzelsucht  =09

IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+fxeS8+1vMONE2jsRAmcqAJ9g7HHUd+lPpF5A4/GGGoi7l3oLGgCgtCYq
FUVn4SND+5YJ3VuvvY1+ZJI=
=O0CG
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
