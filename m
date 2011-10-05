From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/4] FIX: restore_backup() throws core dump
Date: Wed, 5 Oct 2011 13:30:36 +1100
Message-ID: <20111005133036.2107c993@notabene.brown>
References: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
	<20111003161338.18410.79083.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/c66YG.GkDRsVBXTdZV_ggyQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111003161338.18410.79083.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/c66YG.GkDRsVBXTdZV_ggyQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 03 Oct 2011 18:13:38 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> 1. restore_backup() throws core dump during releasing fdlist.
> Loop for closing handlers checks next_spare variable,
> but iterates disk_count.

The best way to fix this is simply to just fix this.. See below.

>=20
> 2. fdlist initialization/close is corrected to initialize/close
>    whole allocated array

This is unnecessary.

>=20
> 3. next_spare variable name is replaced by spares

But the variable doesn't contain a count of the number of spares.  It conta=
ins
the number of the next spare...

NeilBrown

commit cc7f63e55319b5c372af20ce528e7e7230746d92
Author: NeilBrown <neilb@suse.de>
Date:   Wed Oct 5 13:29:16 2011 +1100

    restore_backup() throws core dump
   =20
    restore_backup() throws core dump during releasing fdlist.
    Loop for closing handlers checks next_spare variable,
    but iterates disk_count.
   =20
    Reported-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Grow.c b/Grow.c
index de177d8..9fa2d6b 100644
--- a/Grow.c
+++ b/Grow.c
@@ -78,9 +78,9 @@ int restore_backup(struct supertype *st,
 				   backup_file, verbose > 0);
=20
 	while (next_spare > 0) {
-		disk_count--;
-		if (fdlist[disk_count] >=3D 0)
-			close(fdlist[disk_count]);
+		next_spare--;
+		if (fdlist[next_spare] >=3D 0)
+			close(fdlist[next_spare]);
 	}
 	free(fdlist);
 	if (err) {

--Sig_/c66YG.GkDRsVBXTdZV_ggyQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOi8FMG5fc6gV+Wb0RAisxAJ0QOpwacg7WGCia6c6tG1ti6EV/swCdEhv8
zpTGT+PPQBVBC8s+nuRRnBo=
=/GBB
-----END PGP SIGNATURE-----

--Sig_/c66YG.GkDRsVBXTdZV_ggyQ--
