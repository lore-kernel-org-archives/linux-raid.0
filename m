From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Fri, 1 May 2009 19:55:24 +0200
Message-ID: <20090501175524.GA8163@darkside.22.kls.lan>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org> <18922.50050.860008.242658@notabene.brown> <slrnguupf4.911.Mario.Holbe@darkside.dyn.samba-tng.org> <slrngve39c.8a2.Mario.Holbe@darkside.dyn.samba-tng.org> <18938.23135.726382.733302@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18938.23135.726382.733302@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ADZbWkCsHQ7r3kzd
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 01, 2009 at 12:11:43PM +1000, Neil Brown wrote:
> There some other places
> where are are overflowing on a shift.  One of those (in
> bitmap_dirty_bits) can cause the problem you see.
> This patch should fix it.  Please confirm.

Together with the small syntax-fix attached this patch fixes the
allocation of half of the available pages only. Now, all pages are
allocated when I set all bits and they all get cleaned in-kernel as well
as on-disk.

However, can you confirm that the bitmap is really used in raid10
resync? I removed half of the disks (a correctly removable subset, of
course :)), copied 100G to the degraded array, got about 7k bit set in
the bitmap, (re-)added the removed devices (mdadm correctly states
re-add as well), but the resync looks *very* sequential.
Moreover: I stopped and re-assembled the array with about 2k bit left
set and the resync starts from the beginning, I can see no skip to the
previous position in the resync process.
I'll try to watch this and will trigger you again when I have more
stable evidence, but perhaps you have some faster test-cases, I have to
wait for at least 5 hours now :)


regards
   Mario
--=20
Singing is the lowest form of communication.
                         -- Homer J. Simpson

--Kj7319i9nmIyA2yE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="linux-source-2.6.28+bitmap3.patch"

diff -urN a/drivers/md/bitmap.c b/drivers/md/bitmap.c
--- a/drivers/md/bitmap.c	2009-05-01 12:50:48.463877165 +0200
+++ b/drivers/md/bitmap.c	2009-05-01 12:55:56.185432118 +0200
@@ -1021,7 +1021,6 @@
 			bitmap_set_memory_bits(bitmap,
 					       (sector_t)i << CHUNK_BLOCK_SHIFT(bitmap),
 					       needed);
-				);
 			bit_cnt++;
 			set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}

--Kj7319i9nmIyA2yE--

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSfs3jBS+e2HeSPbpAQJ7Pwf+KpOyiaVD2+hCSTJF9/iZq1nD2DjgLDDc
nmlvyv8q0u6h5/r7DLN7cR9lLY56dIJrPUIR+MGblglAequVIeM0fuQm/nFo8AXU
O4cJnyu/zXMQTwlx4fYJDUpglKsc9bRXlybcoQZTNMjZ63EEp3ewRIMH6g82UagQ
bx7PA74Vaxr327nB5RWU+D2Np6GR4RbDoRxY3fFiKFSD187SxxWbmfg5CdL3/PKU
FkiNYKNsUkwWFOYwNe1qu+VyJYZtBvqmgZm/PsWcrK2PH4ynXG1rWEo8MJwH5YRo
N/ff7quQniK7rAw14ljFLpzofsQVfGZ84FOGDCC+yEnb72CY+CQWXA==
=WfBF
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
