From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --fail doesn't mark device as failed?
Date: Thu, 22 Nov 2012 15:40:27 +1100
Message-ID: <20121122154027.39a21f09@notabene.brown>
References: <1353514677.5795.14.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qzpaf.MWXx.DuTs6oz8fUPR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353514677.5795.14.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Qzpaf.MWXx.DuTs6oz8fUPR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Nov 2012 08:17:57 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrot=
e:

> After I failed and removed a partition, mdadm --examine seems to show
> that partition is fine.

Correct.  When a device fails it is assumed that it has failed and probably
cannot be written to.  So no attempt is made to write to it, so it will look
unchanged to --examine.

All the other devices in the array will record the fact that that device is
now faulty, and their event counts are increased so their idea of the status
of the various devices will take priority over the info stored on the faulty
device - should it still be readable.

>=20
> Perhaps related to this, I failed a partition and when I rebooted it
> came up as the sole member of its RAID array.

This is a bug which is fixed in my mdadm development tree which will
eventually become mdadm-3.3.

Does the other decice get assembled into a different array, so you
end up with two arrays (split brain)?

What can happen is "mdadm --incremental /dev/whatever" is call on each devi=
ce
and that results in the correct array (with non-failed device) being
assembled.
Then "mdadm -As" gets run and it sees the failed device and doesn't notice
the other array, so it assembles the failed device into an array of its own.

The fix causes "mdadm -As" to notice the arrays that "mdadm --incremental"
has created.


>=20
> Is this behavior expected?  Is there a way to make the failures more
> convincing?

mdadm --zero /dev/whatever

after failing and removing the device.
Or unplug it and put in an acid bath - that makes failure pretty convincing.

NeilBrown

--Sig_/Qzpaf.MWXx.DuTs6oz8fUPR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK2suznsnt1WYoG5AQLARA//aozwK2Ikp0LmaelHKzA8w2KSSIxVijQ9
+I0rUh4T5w21DzCx7CiE96zeqqpV+yrC3AoyMrelGH7Lpawm3pE3LzDI+xryaCQX
7WFLDSUvW4TRnvPPMu+N0iHcoyeThk6rO1QQUp0ZrdhM87vJxNDQWia4VhqcktrI
bv9CVvEOEDdBENnxB66FYefjyU2TiObbFssqw5hcxU+GCABif1RR5xXCEF/05gIL
TMAONe9NiBj5s2So2yI6b3rzk2G4tpW2bsgPkQFbko6+WwHKfkAxJ3xIsJOuK4sB
s5eu1Qa63I7eWusVvj6psrW305pieSIsj6LPEuszFJ+j2fk7lwNb4dVwVVAZSzQv
Lc+NeZ5W16hbp0wkF35Jpqfhp+p+oEAc/C4WyEyrrdK4UvRk9a211FTqq0mwAa6o
5Pw+vpwhaYwjbSu2s5mucN3kAof76VrNmwYybZYVsS1jS4mVhYiMO0o+zf1gtaiJ
ZDBsqCJqjHu+TPYjRwew6sb9jK0u0u8UwD3UwMaNc1HSXyj3sR3ICNjd5++177E9
oCsRMtFkv7avp3/qANIKLAdvEksW4Y/EGNcrflG88HgnqDBGhJa9nrqEoAjLhytO
iZi9Nx8R7Ckjw2RhO3fh1Amh7dleWUSdSeleZokmGidbyjNOEUzQFJWsOpk9qFWI
URy+bkKXlFg=
=+9US
-----END PGP SIGNATURE-----

--Sig_/Qzpaf.MWXx.DuTs6oz8fUPR--
