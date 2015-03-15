From: NeilBrown <neilb@suse.de>
Subject: [PATCH] kernfs: handle poll correctly on 'direct_read' files.
Date: Mon, 16 Mar 2015 10:44:52 +1100
Message-ID: <20150316104452.366bffc0@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Dyc_uFBn2Om3ig_zrj+SipM"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Prakash Punnoor <prakash@punnoor.de>, Torsten Kaiser <just.for.lkml@googlemail.com>, linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Dyc_uFBn2Om3ig_zrj+SipM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



Kernfs supports two styles of read: direct_read and seqfile_read.

The latter supports 'poll' correctly thanks to the update of
'->event' in kernfs_seq_show.
The former does not as '->event' is never updated on a read.

So add an appropriate update in kernfs_file_direct_read().

This was noticed because some 'md' sysfs attributes were
recently changed to use direct reads.

Reported-by: Prakash Punnoor <prakash@punnoor.de>
Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Fixes: 750f199ee8b578062341e6ddfe36c59ac8ff2dcb
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index b684e8a132e6..2bacb9988566 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -207,6 +207,7 @@ static ssize_t kernfs_file_direct_read(struct kernfs_op=
en_file *of,
 		goto out_free;
 	}
=20
+	of->event =3D atomic_read(&of->kn->attr.open->event);
 	ops =3D kernfs_ops(of->kn);
 	if (ops->read)
 		len =3D ops->read(of, buf, len, *ppos);

--Sig_/Dyc_uFBn2Om3ig_zrj+SipM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVQYZdDnsnt1WYoG5AQKd3hAAiDZXpMs4abX2hp+Ip19UG99XXCEGEuuL
BNp8h7OK4/n5SDsQ8a7YJKwHy4O1WbcytcvRKdd8jyiVO5Bq9DkuVKEwKIIV8B+4
j41sw/hxON63t2+zsXdweagcO0XnpT5fl3u5hiiXe4eomUaPD0/qcoOofT1WmTpy
qcBxrecdDzQt+8OHAyD8kLILoFlFU0M5zlDWS0pztIKqP2UjixBPFrDb4x18UPSt
/d2gnHf6ZCB/O4Pwmy9bNL6AMb3VoNn4+FJoQrX/J1AYGuPsTl7oITc/fOZ4TYLk
bNRjsEJRV2JS4cie1d9OuMK23pZFDHKEeUhQXu8MPuMNsEt94MalOe8FtX65eZyf
P8UZEu2jGeXjQiClOqO/HmRtDNwc7a8QgDuLe3M9egB1ZKtoPGN/A2ELzs9/IY8X
Ei/kplKPLx769loXErOoBRJFndd3Hjln3NS0KEIuKfWpUF6p8pLOYzQn0y0YEp+k
15Tj4jKtX1wJ6xgyTNBUT2/jYWpI7R4tNje8tK+4ZYAxjHayg/Ch/JdicVVvKlI0
HhlIBSfpBNlkBVLkOV44H5/98yGFsNHeemxLgaF0voJLCp7gcKifZPKemWHlQT89
Ps+uecTzE7G3Db9/4oLULku0E1aLUpCVqk5CbiUNaJo3uT2CeqNRkJfmb0q+hZOC
mTEcShJl93M=
=DAtK
-----END PGP SIGNATURE-----

--Sig_/Dyc_uFBn2Om3ig_zrj+SipM--
