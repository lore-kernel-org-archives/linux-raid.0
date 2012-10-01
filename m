From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: [md PATCH 01/10] md: allow a reshape operation to be reversed.
Date: Mon, 1 Oct 2012 15:11:28 +0600
Message-ID: <20121001151128.0a5e336f@natsu>
References: <20120403054656.19495.36380.stgit@notabene.brown>
	<20120403055301.19495.37242.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WTdHKq=eyqPnx2XZ0sv1wty"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403055301.19495.37242.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WTdHKq=eyqPnx2XZ0sv1wty
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Apr 2012 15:53:01 +1000
NeilBrown <neilb@suse.de> wrote:

> Currently a reshape operation always progresses from the start
> of the array to the end unless the number of devices is being
> reduced, in which case it progressed in the opposite direction.
>=20
> To reverse a partial reshape which changes the number of devices
> you can stop the array and re-assemble with the raid-disks numbers
> reversed and it will undo.
>=20
> However for a reshape that does not change the number of devices
> it is not possible to reverse the reshape in the middle - you have to
> wait until it completes.
>=20
> So add a 'reshape_direction' attribute with is either 'forwards' or
> 'backwards' and can be explicitly set when delta_disks is zero.
>=20
> This will become more important when we allow the data_offset to
> change in a reshape.  Then the explicit statement of what direction is
> being used will be more useful.
>=20
> This can be enabled in raid5 trivially as it already supports
> reverse reshape and just needs to use a different trigger to request it.

Hello,

Is it possible to use this to cancel a RAID5 reshape that is reducing the
number of devices?

I understand that reshape goes backwards by design in this case, so I need =
to
switch it to "forwards".

I stopped the reshaping array and then started it with "mdadm --assemble
--freeze-reshape" and listing the backup file and all the devices on the co=
mmand line.

But even then:

# echo forwards > /sys/block/md0/md/reshape_direction=20
-bash: echo: write error: Device or resource busy

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/WTdHKq=eyqPnx2XZ0sv1wty
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBpXkAACgkQTLKSvz+PZwha0QCggxaajfyrFiO0+xgdRPyxIlKK
nhEAmwS+2983JpxU92uWuX0TkKoGHn5+
=UBFn
-----END PGP SIGNATURE-----

--Sig_/WTdHKq=eyqPnx2XZ0sv1wty--
