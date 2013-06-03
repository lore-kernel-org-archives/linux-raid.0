From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --assemble considers event count for spares
Date: Tue, 4 Jun 2013 09:51:24 +1000
Message-ID: <20130604095124.4f4012bc@notabene.brown>
References: <CAGRgLy6fc8fF8KWoO7EEG6Uo8d4jUPPLcucwX-fNw9O5qKMJgg@mail.gmail.com>
	<20130528111633.0ba7bed5@notabene.brown>
	<CAGRgLy5-ACTy1SyQdNO4mbCY0MXzFueGmRsYhQ7tS=BqQRWrCw@mail.gmail.com>
	<20130528191500.2a5bb83a@notabene.brown>
	<CAGRgLy4bHdxybSC9U8rw=bVM1Aq+HPir_Y6Cwv7obQg-oe-6RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nyfOaJL73iOjn1vFE+1VUlk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4bHdxybSC9U8rw=bVM1Aq+HPir_Y6Cwv7obQg-oe-6RQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/nyfOaJL73iOjn1vFE+1VUlk
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

Sounds reasonable.
I would suggest looking at the place where 'most_recent' is set in
Assemble.c, and get it to avoid updating 'most_recent' if the current device
is a spare.
Something like

		if (most_recent < devcnt) {
			if (devices[devcnt].i.events
			    > devices[most_recent].i.events)
+			      if (devices[devcnt].i.disk.state =3D=3D 6)
				most_recent =3D devcnt;
		}

Care to give that a try?

NeilBrown


>=20
> After array is assembled, we may choose one of the following:
> # User has to explicitly add the spare drives after array has been
> assembled. Assemble can warn that some spares have been left out, and
> tell the user what they are.
> # Assemble adds the spare drives (perhaps after zeroing their
> superblocks even), after it assembled the array with non-spare drives.
>=20
> Alex.

--Sig_/nyfOaJL73iOjn1vFE+1VUlk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUa0r/Tnsnt1WYoG5AQLpAA/+LiU4crfmkuJjAtkiKYezADNgUt5w0R57
Fhx5aBdz5ds31jYKqtddZPM1u5L3X9nEupNUNyLYgBQokYbKA+KBIgyLdRWOB2pD
SQFUZgXSfQUgnZ/hyy3Zh3p8rfIZYaZlQPZJoDUQwiZjlxyfE+ORaZSeRMbSi3Gd
f8CTHI6p/tE6wKi1fMgPsBFof9xr1aRuiITli7IICpWi0LcS0njq7PuJdoAYppvT
8YNRYo7seuDPdqEzx/hcZ3G/yVXiD7qkBKsQyJTaX7lhXRaHjNFxuxwW8PdrlAqE
tFjdPZGbqAUt5Db9oSwmSlTov/KFCcqZlTNB2ov9wzSrgQKtvol6NFU325uxQje1
aoiH7pGPJP+WCZOAV8j6hSEsf9hoFH+mdZ0CmNdJgpeti6NUgqOfRZtJhGJxIwnF
H3pl+6XP5hrVmodybXx702A9bYFj4W2gDJ31kEESDi8TY3VMVuRuXs+N9J43Di9d
0foderi4RkB+HpoAkyIrOCS+YKJwIPEoedUhE5Lu3yHz6yjugt1NRGvjhYcaDfdQ
GyAkCvhdtm55YptAnvXD7bpGJuhhf7fkLL91Dh7/2PJxRPNi6eG46diAc3PnsWHw
pDNpd0M0IEk333MGnezK39ZqWAdMp6uJ+zKq+mluMP7duTIulHshudxuFBYIGsij
SAJcBzSkOBk=
=EX0I
-----END PGP SIGNATURE-----

--Sig_/nyfOaJL73iOjn1vFE+1VUlk--
