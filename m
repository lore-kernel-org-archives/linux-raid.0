From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --assemble considers event count for spares
Date: Mon, 17 Jun 2013 16:57:27 +1000
Message-ID: <20130617165727.3a37c0e7@notabene.brown>
References: <CAGRgLy6fc8fF8KWoO7EEG6Uo8d4jUPPLcucwX-fNw9O5qKMJgg@mail.gmail.com>
	<20130528111633.0ba7bed5@notabene.brown>
	<CAGRgLy5-ACTy1SyQdNO4mbCY0MXzFueGmRsYhQ7tS=BqQRWrCw@mail.gmail.com>
	<20130528191500.2a5bb83a@notabene.brown>
	<CAGRgLy4bHdxybSC9U8rw=bVM1Aq+HPir_Y6Cwv7obQg-oe-6RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ahr6kO1HDJQlK95VWve_gy."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4bHdxybSC9U8rw=bVM1Aq+HPir_Y6Cwv7obQg-oe-6RQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Ahr6kO1HDJQlK95VWve_gy.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 May 2013 13:50:49 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Neil,
> In my opinion (I may be wrong), a spare drive (raid_disk=3D=3D-1) doesn't
> add any information to array assembly. It doesn't have a valid raid
> slot, and I don't see how its event count is relevant. I don't think a
> spare can help us much in figuring out array's latest state, which is
> what assembly code tries to do.
> So what I was thinking: mdadm --assemble doesn't consider spare drives
> (raid_disk=3D-1) at all. It simply skips over them in the initial loop
> after reading their superblocks. Perhaps it can keep them in a side
> list. Then array is assembled with non-spare drives only.
>=20
> After array is assembled, we may choose one of the following:
> # User has to explicitly add the spare drives after array has been
> assembled. Assemble can warn that some spares have been left out, and
> tell the user what they are.
> # Assemble adds the spare drives (perhaps after zeroing their
> superblocks even), after it assembled the array with non-spare drives.

Hi,
 I have just committed

  http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommitdiff;h=3Df80057aec5d3=
14798251e318555cb8ac92e4c06f

which I believe fixes this issue.  If you can test and confirm I would
appreciate it.

NeilBrown

--Sig_/Ahr6kO1HDJQlK95VWve_gy.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUb6zVznsnt1WYoG5AQJT1hAAmI7fmejBc69wqfvy6ILwYDPjweIVGCRI
0kxmMJuOGjYq/1ELQXjG+ZRW9i2X615r/qjaD+dWHrtrfmWbchdFScdXJfGUMMad
8kPz8JENb1yYXvpNnuLbHnNbaI3ybCPzXKyTHPnpu+CKhEMSHQzCJ4irX9G3hHbw
WArpAlZAgxGWPwDPKntck2nABQjoz1vtexTxfIMwiDUwAzOAmcWSwL+7k0yMM34E
SGq947skwfSde5kQ4mCTRU9GtWHLRD3dviCab5cWCSnXiLV+L4Nh/p2wjYDmG2IS
hoYDRDB4+0EImXBRjSDJT3F5nDAVch9q0/Fm6hy3Gh06foDj/6UP7irFQLYOj/W4
Ke9nbCwAE0AQUeDqpiUu9KzAqpLL3kbONGO6HoL0D2wJPA3yqIGmf4ZhvwxrZYTm
cc0LzjjBhy3mWMpAR13eK9tNCapdQTqCl3kDVLddrLeBF0R8rI/9yyX6vYT4wL0o
XT9CZtHcrACnc6xOiFQ2L98AWHzsTTEKTJFv3CEXbFJu77OsGLyRg2grauizVff1
/Z4q1Bjm3gkF2lvJ1qL7YJGS8JXfZqUQtPV37NmdxM2jvP5mgtQ5qD66fjQZaHgZ
Jk+oNAT3ulur/f5+OTIiicciS9ISq8HKgrewnpVUNOIxylLPyZ20dhW5MLeYbNyV
7qXEJhEUOZU=
=ISq4
-----END PGP SIGNATURE-----

--Sig_/Ahr6kO1HDJQlK95VWve_gy.--
