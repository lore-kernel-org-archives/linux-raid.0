From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH 2/2] mdcheck: improve cleanup
Date: Fri, 06 Oct 2017 12:34:40 +1100
Message-ID: <87d16112kv.fsf@notabene.neil.brown.name>
References: <87h8vd12mn.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h8vd12mn.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


We should remove the tmp file on signals as well as on exit.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 misc/mdcheck | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/mdcheck b/misc/mdcheck
index 589d038eed9b..42d4094a2754 100644
=2D-- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -66,7 +66,7 @@ shift
=20
 # We need a temp file occasionally...
 tmp=3D/var/lib/mdcheck/.md-check-$$
=2Dtrap 'rm -f "$tmp"' 0
+trap 'rm -f "$tmp"' 0 2 3 15
=20
=20
 # firstly, clean out really old state files
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnW3bAACgkQOeye3VZi
gbn0RQ//URrP5TLbvKWCDg7FsBYHqmh/5owmrIUzZyxioK9mYtgDYZ59xpMnz0F5
2fnYK2YBPU7QMSK6/tCiauDbBdNplZ9bX3llYKFWwG8H9fvF2n4B/wct347DH5Oz
dzvWKyCwGFIfuZFh0ZY0pC4gs9Re9V1bJpWCP790YujNIYCTxY8oRF8Z7rWgaI3Q
uiattxNGf250Lq2JYTl/ptY4daEjCxLq7g+D60TBHyPMgcbiVqL6fazmdWsCrelc
ygyG91xcuFCV3EvwYfhYi6yVZmezuSoP5hmf+vX+tSfNqCgi5QdHSmky5cGITuHr
aL0mHtFSLbaxwsTFaIZLgI1xEU1cCiNOpkQ+jpAXE6iohG+TguUp6k/GetVVU3Kd
eTJQmHiXFT5KUBh68l1+kB9aXImjwekpGPveaJ0WYmf7JOXBtcQoIU7DVvUO/JLh
p8LeGb0xiHB4SPc/4GhEcISPuds1N49ZIFsLt1vFCCH0c2GZy4Pjp7uaFScKD+Xs
lDCd1M6w4Gph7hqpVrS190JMGgQ4bK0M6/5xoR8klO6m4zmX8zmGV2M9ji8Bv2bi
hNIFQrpJuAIN33g+JdwwrapnS3X3Nhnt88WmN7p0P4xn5iZBspekloqV6Q7nKtJK
NDRPcSBb57Ng3a++tjQqYT7zeJfg85B5ugSStFojbea3wRPSYP8=
=wPNy
-----END PGP SIGNATURE-----
--=-=-=--
