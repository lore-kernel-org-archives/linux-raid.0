From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Re: Software RAID level 1 issue
Date: Fri, 30 May 2003 14:40:41 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030530184041.GP20195@rdlg.net>
References: <C587FF391BCAD411B8120008C7864670057DA5B8@mtvxch07.veritas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Eu9PQ+LfZADlAtIa"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C587FF391BCAD411B8120008C7864670057DA5B8@mtvxch07.veritas.com>
To: Brian Schwarz <Brian.Schwarz@veritas.com>
Cc: 'Greg Rasberry' <rgreg-r@pacbell.net>, 'Linux raid mailing list' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Eu9PQ+LfZADlAtIa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Not quite the same.  The Linux kernel has built in RAID as well as LVM.
If he's doing RAID1 as it seems then the LVM isn't needed as that's a
completely separate monster.  I'm thinking it's likely a bad drive that
didn't like the restart.

On a RedHat9 system He's likely using an EXT3 filesystem which by
default has a journal attached which is pretty much the same thing as
the DRL.  The IO cost of the journal on EXT3 is extremely negligable.
At work I have 8 servers with four 600Gig (yes gig) filesystems each.
While building one out I did some different tests using ext2 (no
journal) and ext3, raid0+1 and raid5.  A raid5 system with the journal
is an extremely small impact on a 600 Gig system and even a 1.8TB system
(we had time to play with disk configurations).

In this case the raid is syncing it's mirrors, not fscking the filesystem
so the journal/DRL wouldn't do any good at all.  If one of the disks in
the mirror is having media or other hardware errors it could be trying
and failing thought the kernel has been extremely reliable for me to
just puke on a bad disk and mark the array degraded.

http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/html_single/Softw=
are-RAID-HOWTO.html

Robert


Thus spake Brian Schwarz (Brian.Schwarz@veritas.com):

> Greg,
>=20
> Can't help you with the LVM specifics, but I would suggest investigating
> functionality called Dirty Region Logging (DRL). I know we have a feature=
 in
> the VERITAS Volume Manager that tracks changes at a block level so the
> resync can happen much more quickly. Think of it as similar to a transact=
ion
> log or Redo log in Oracle. Not sure if LVM has the same type of
> functionality. Won't help you this time, but will save you next time. One
> trade-off is that it costs you some I/Os to write and clear the log, would
> recommend putting the log on a RAID 10 volume. More info on VERITAS Volume
> Manager at www.veritas.com/linux.
>=20
> Regards,
>=20
> -Brian
>=20
>=20
> -----Original Message-----
> From: Greg Rasberry [mailto:rgreg-r@pacbell.net]
> Sent: Friday, May 30, 2003 10:54 AM
> To: 'Linux raid mailing list'
> Subject: Software RAID level 1 issue
>=20
>=20
> I have a RedHat 9.0 server that went down. On re-start the server has=20
> started to come up just fine. It started re-syncing, the first of the rai=
d=20
> partitions, the first one went buy fast, then the second took a day and t=
he=20
> last drive (md2) has been working on the re-sync for four days (it is=20
> fairly large 70 Gig).  We are unable to use the server and cannot pull th=
e=20
> data off of it because the drives have not mounted, etc.
>=20
> I was wondering if anyone knows if this is normal, and/or how I can get=
=20
> around this problem. I understand that the re-sync is supposed to happen =
in=20
> the background?
>=20
> I have only been using Linux for about a year and could really use some=
=20
> help with this, the system has been down for a week.
> Thanks in advance for your help.
>=20
> R,
> Greg
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | GPG Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.

Diagnosis: witzelsucht  =09

IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net

--Eu9PQ+LfZADlAtIa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+16Wp8+1vMONE2jsRAmR9AJ9e+uIegxD6WfQBZrLSSgPzgPF3bgCdF6rK
rEA//5WwWf8Lr8xPBKGtCVs=
=YP5l
-----END PGP SIGNATURE-----

--Eu9PQ+LfZADlAtIa--
