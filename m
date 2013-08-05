From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/4] DDF: ddf_process_update: delete removed disks from
 dlist
Date: Mon, 5 Aug 2013 15:11:35 +1000
Message-ID: <20130805151135.08320f62@notabene.brown>
References: <1375396517-8479-1-git-send-email-mwilck@arcor.de>
	<1375396517-8479-3-git-send-email-mwilck@arcor.de>
	<51FC096B.8070804@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3CtB+29y3q9LglSDFK6=w9y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51FC096B.8070804@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3CtB+29y3q9LglSDFK6=w9y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 02 Aug 2013 21:32:59 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Neil,
>=20
> This calls free() from monitor context - I am not certain if that's
> allowed and if no, what alternative there might be.

Yes, I don't really like that.  And there is an 'fd' attached to the 'dl'
which would need to be closed too.

This relates to the "ddf: remove failed devices that are no longer in use ?=
!?"
discussion we had earlier.  That patch isn't really right ... as you noticed
by trying to fix it.

I think this fix is safer and more in the spirit of the original.  It appea=
rs
to fix the problem for me, and feels "right" as well:-)

It only removed pd entries for devices that really have disappeared.  If a
device still exists in ->dlist, we don't remove the pde.

I applied the other patches in the series  - thank especially for the added
test!

Thanks,
NeilBrown

=46rom 92939eb29175a0dc7c9c46ff70f95b76b693b796 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 5 Aug 2013 14:56:23 +1000
Subject: [PATCH] DDF: fix removal of failed devices.

Commit c7079c84 arrange for DDF to forget about any device
that is failed and not still marked as part of any array.

However such devices could still be part of the container and this
removal and updating of 'pdnum' can result in multiple devices having
the same pdnum.  This in turn easily leads to confusion and
corruption.

So only discard pd entries for devices which are failed, not listed in
any virtual device, and for which we don't have a handle on the
device.

pd entries will not get removed until a new device is added after
the device has been removed from the container, either by
"mdadm --remove" or by assembling without the failed devices.

Reported-by: Albert Pauw <albert.pauw@gmail.com>
Analysed-by: Martin Wilck <mwilck@arcor.de>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super-ddf.c b/super-ddf.c
index 20f4f25..b352a52 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4635,13 +4635,19 @@ static void ddf_process_update(struct supertype *st,
 		 */
 		pd2 =3D 0;
 		for (pdnum =3D 0; pdnum < be16_to_cpu(ddf->phys->used_pdes);
-		     pdnum++)
+		     pdnum++) {
 			if (be16_and(ddf->phys->entries[pdnum].state,
 				     cpu_to_be16(DDF_Failed))
 			    && be16_and(ddf->phys->entries[pdnum].state,
-					cpu_to_be16(DDF_Transition)))
-				/* skip this one */;
-			else if (pdnum =3D=3D pd2)
+					cpu_to_be16(DDF_Transition))) {
+				/* skip this one unless in dlist*/
+				for (dl =3D ddf->dlist; dl; dl =3D dl->next)
+					if (dl->pdnum =3D=3D (int)pdnum)
+						break;
+				if (!dl)
+					continue;
+			}
+			if (pdnum =3D=3D pd2)
 				pd2++;
 			else {
 				ddf->phys->entries[pd2] =3D
@@ -4651,6 +4657,7 @@ static void ddf_process_update(struct supertype *st,
 						dl->pdnum =3D pd2;
 				pd2++;
 			}
+		}
 		ddf->phys->used_pdes =3D cpu_to_be16(pd2);
 		while (pd2 < pdnum) {
 			memset(ddf->phys->entries[pd2].guid, 0xff,

--Sig_/3CtB+29y3q9LglSDFK6=w9y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUf80Bznsnt1WYoG5AQLf0g/9EcnrSg7XpXfUo6BuasjxIjOJffbSkLUg
DOi6qylTleKTgOvY+sXEN4efSRjsaP//vF/Z7Z+X6ydYoBC1ZUQ1d2nuJQBpw4sF
rEK/h64+KXCiX4fQqgpA6LjBOQOyol1DtlMz77oFWxX9anUXqt2mTdy+nObdBcqw
gGEt+w9iQSSr+d1pQIQ14KQM6unqltvW/2Ba/tGjbjT3e8nG/efOju/b2ZVDV1SG
159xwh5qdM8rnhu7OYw5Fgpc5uOHxs91o804RhIA9gd4Ia6WWNrcU/JyZDN19l8U
m2TZ86s5zncQUSo0MrZNv7u3gBWFIEIyb8kdyyWP/Lo2lf67apgxCK5aMYCUtday
PzKoAHFhIaAgdOTdY1ZZ3gnLklmGGUaL/BV+bcP+YSwALkv30hqzB2eeeX6sk4JO
lq89m0yfGmTF5fcu3V0Op8NzA380bYTXmkZ8091cxfGSukHd8cgM9jm/W3oTEBYJ
rOULP9wND3vQ0mM1W+HIfaOROxjkPCdTJS1Dbg/CMB0MFHfetSEEdKkZdRXxfgo3
h9/VZolSmgCK9hzESVy5J7fa1MEf2Zo7aP/k1NP6F49T3LWCZ/J+tcYAAHUgGi3N
OMHLtbz0+aOayD0P3A774pZD9OmrvXK/8jN+O8asixQygB0Y5SW96IUwLnZPacdj
b8f6fLqgRwI=
=uaIE
-----END PGP SIGNATURE-----

--Sig_/3CtB+29y3q9LglSDFK6=w9y--
