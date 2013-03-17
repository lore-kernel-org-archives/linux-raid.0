From: NeilBrown <neilb@suse.de>
Subject: Re: Strange / inconsistent behavior with mdadm -I -R
Date: Mon, 18 Mar 2013 10:35:10 +1100
Message-ID: <20130318103510.45bdd4a8@notabene.brown>
References: <51422D10.3040000@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8_9jpCeqoMclGnRHPDBxHYS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51422D10.3040000@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8_9jpCeqoMclGnRHPDBxHYS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Mar 2013 21:03:28 +0100 Martin Wilck <mwilck@arcor.de> wrote:

> Hello Neil,
>=20
> for my DDF/RAID10 work, I have been trying to figure out how mdadm -I -R
> is supposed to behave, and I have found strangeness I'd like to clarify,
> lest I make a mistake in my DDF/RAID10 code.
>=20
> My test case is incremental assembly of a clean array running mdadm -I
> -R by hand for each array device in turn.
>=20
> 1) native md and containers behave differently for RAID 1
>=20
> Both native and container RAID 1 are started in auto-read-only mode when
> the 1st disk is added. When the 2nd disk is added, the native md
> switches to "active" and starts a recovery which finishes immediately.
> Container arrays (tested: DDF), on the other hand, do not switch to
> "active" until a write attempt is made on the array. The problem is in
> the native case: after the switch to "active", no more disks can be
> added any more ("can only add $DISK as a spare").
>=20
> IMO the container behavior makes more sense and matches the man page
> better than the native behavior. Do you agree? Would it be hard to fix th=
at?

Without -R, the array should remain inactive until all expected devices have
been found.  Then it should switch:
  to 'active' if the array is known to this host - i.e. listed
       in /etc/mdadm.conf or has the right hostname in the metadata
  to 'read-auto' if the array is not known to this host.

With -R, it only stays inactive until we have the minimum devices needed for
a functioning array.  Then it will switch to 'read-auto' or, if the array is
known and all expected devices are present, it will switch to 'active'.

I think this is correct behaviour.  However I'm not quite sure from your
description whether you are saying that it doesn't behave like this, or if
you are saying that it does but it should behave differently.

Maybe if you could provide a sequence of "mdadm" commands that produces an
outcome different to what you would expect - that would reduce the chance
that I get confused.

>=20
> 2) RAID1 skips recovery for clean arrays, RAID10 does not
>=20
> Native RAID 10 behaves similar to RAID1 as described above. When the
> array can be started, it does so, in auto-read-mode. When the next disk
> is added after that, recovery starts, and the array switches to
> "active", and further disks can't be added the "simple way" any more.
> There's one important difference: in the RAID 10 case, the recovery
> doesn't finish immediately. Rather, md does a full recovery of the added
> disk although it was clean. This is wrong; I have come up with a patch
> for this which I will send in a follow-up email.
>=20

I agree with your assessment here and with your patch, thanks.

NeilBrown



--Sig_/8_9jpCeqoMclGnRHPDBxHYS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUZTLjnsnt1WYoG5AQKN/RAAqUprfm5x7WmoYCEHCVQBbUIO+tW0q36N
c4ZBBj9FPTCsDOk8aetApLdj+Dg2oUNxd5tLYZ8iJh6PDpb0QrSY+Za/U87N/L7H
nP2n5uFAn1OhaP/mkKnDEuF4vp8+T1AXVKgxqNUC71IpBE4z6OBc/Z/QjwtpcF1a
7Bpa2CLvwNp/ExDY3DNIvQsSmvCoInjM83ZqaORk1XYRpDbc8HdoJFk4LPUl3AFa
COmR3VHxaY53o0w2jqoRsXZvldxp2hQEzDyoO1o5CiV2O8OT+JkIfxxLjXC0oi/T
d+/VfW4WcPpiP+2r2Om6IkD0rrDKcJvAnTmb49h67fW4JKRaHq+R4+lv5iFZG2Ll
R12DGPV8Jxyr3vSfIirFVrOLZb7uOcWcA+NXHfCGuXP6iVww/MLSuoVnTuJ/XCxz
EBhuFcu8In3hnjzWnCTmEKw/pXWeZ4mn7j0t6LsifXbh8p0jCxd5lTdb5daZoabn
M50mHSivbOXIxwQks6wgiow5Tlxa+7mnhSpOI+9LbmBb1ek+xTZTD+0/sKMll0Yg
sL62nvvOAmdo2pYU7FiiI8NNReol9eKbx2Wiy8JkNzwYYt6dwzhbPzuoqitLBQ6W
FWziR6vUkHIZF0pV0DX9nsrllfoviXHPSpKpQKCLLXIAsBuLl0YoRTaR57kYb6KT
ajuQw2xgRgs=
=NVVf
-----END PGP SIGNATURE-----

--Sig_/8_9jpCeqoMclGnRHPDBxHYS--
