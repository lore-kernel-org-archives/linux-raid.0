From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: [md PATCH 01/10] md: allow a reshape operation to be reversed.
Date: Mon, 1 Oct 2012 16:15:54 +0600
Message-ID: <20121001161554.2445f3e5@natsu>
References: <20120403054656.19495.36380.stgit@notabene.brown>
	<20120403055301.19495.37242.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/If6asaDxF/Kw5.SvTwcNkXv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403055301.19495.37242.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/If6asaDxF/Kw5.SvTwcNkXv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Apr 2012 15:53:01 +1000
NeilBrown <neilb@suse.de> wrote:

> To reverse a partial reshape which changes the number of devices
> you can stop the array and re-assemble with the raid-disks numbers
> reversed and it will undo.

Unfortunately this does not seem to work:

# mdadm --assemble --raid-disks=3D5 --backup-file=3D/mnt/scratch/backup-fil=
e /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sde1 /dev/sdd1 /dev/sdf1
mdadm:option --raid-disks not valid in assemble mode

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/If6asaDxF/Kw5.SvTwcNkXv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBpbVoACgkQTLKSvz+PZwhAfgCgkQjr4XOpyvdnmOj2oE/Wkfxl
tyIAn2APH60M18wri+lMLvnTZIHG7yvV
=Neq0
-----END PGP SIGNATURE-----

--Sig_/If6asaDxF/Kw5.SvTwcNkXv--
