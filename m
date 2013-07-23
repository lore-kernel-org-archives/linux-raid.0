From: NeilBrown <neilb@suse.de>
Subject: Re: Problem with disk replacement
Date: Tue, 23 Jul 2013 13:21:24 +1000
Message-ID: <20130723132124.3bb0bcaf@notabene.brown>
References: <45ae92bb.4ffb.13ff2092e1d.Coremail.13691222965@163.com>
	<7945ee0b.7d5e.13ff2acdc3f.Coremail.13691222965@163.com>
	<20130722130415.44b85e93@notabene.brown>
	<3391fc7f.14685.14005e82e81.Coremail.qindehua@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P+iQ51+y7r7BLrkuijWthMY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3391fc7f.14685.14005e82e81.Coremail.qindehua@163.com>
Sender: linux-raid-owner@vger.kernel.org
To: qindehua <qindehua@163.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/P+iQ51+y7r7BLrkuijWthMY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Jul 2013 18:23:57 +0800 (CST) qindehua <qindehua@163.com> wrote:

> Hi Neil,
> I have tested with this patch, and it fixes the problem.
> I have also tried various combinations of failing and replacing disks,
> with echo idle to /sys/block/md1/md/sync_action, they all work fine.
>=20
> Regards,
> Qin Dehua

Thanks for confirming, and for all of your testing!

I'll forward the patch to Linus shortly.

NeilBrown



>=20
> At 2013-07-22 11:04:15,NeilBrown <neilb@suse.de> wrote:
> >Hi Qin,
> > thanks for the report.  I can easily reproduce the bug.
> >
> >I think this will fix it.  Could you please test and confirm that it fix=
es
> >the problem for you too.
> >
> >Thanks,
> >NeilBrown
> >
> >
> >From: NeilBrown <neilb@suse.de>
> >Date: Mon, 22 Jul 2013 12:57:21 +1000
> >Subject: [PATCH] md/raid5: fix interaction of 'replace' and 'recovery'.
> >
> >If a device in a RAID4/5/6 is being replaced while another is being
> >recovered, then the writes to the replacement device currently don't
> >happen, resulting in corruption when the replacement completes and the
> >new drive takes over.
> >
> >This is because the replacement writes are only triggered when
> >'s.replacing' is set and not when the similar 's.sync' is set (which
> >is the case during resync and recovery - it means all devices need to
> >be read).
> >
> >So schedule those writes when s.replacing is set as well.
> >
> >In this case we cannot use "STRIPE_INSYNC" to record that the
> >replacement has happened as that is needed for recording that any
> >parity calculation is complete.  So introduce STRIPE_REPLACED to
> >record if the replacement has happened.
> >
> >This bug was introduced in commit 9a3e1101b827a59ac9036a672f5fa8d5279d0f=
e2
> >(md/raid5:  detect and handle replacements during recovery.)
> >which introduced replacement for raid5.
> >That was in 3.3-rc3, so any stable kernel since then would benefit
> >from this fix.
> >
> >Cc: stable@vger.kernel.org (3.3+)
> >Reported-by: qindehua <13691222965@163.com>
> >Signed-off-by: NeilBrown <neilb@suse.de>
> >
> >diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >index 2bf094a..f0aa7abd 100644
> >--- a/drivers/md/raid5.c
> >+++ b/drivers/md/raid5.c
> >@@ -3607,8 +3607,8 @@ static void handle_stripe(struct stripe_head *sh)
> > 			handle_parity_checks5(conf, sh, &s, disks);
> > 	}
> >=20
> >-	if (s.replacing && s.locked =3D=3D 0
> >-	    && !test_bit(STRIPE_INSYNC, &sh->state)) {
> >+	if ((s.replacing || s.syncing) && s.locked =3D=3D 0
> >+	    && !test_bit(STRIPE_REPLACED, &sh->state)) {
> > 		/* Write out to replacement devices where possible */
> > 		for (i =3D 0; i < conf->raid_disks; i++)
> > 			if (test_bit(R5_UPTODATE, &sh->dev[i].flags) &&
> >@@ -3617,7 +3617,9 @@ static void handle_stripe(struct stripe_head *sh)
> > 				set_bit(R5_LOCKED, &sh->dev[i].flags);
> > 				s.locked++;
> > 			}
> >-		set_bit(STRIPE_INSYNC, &sh->state);
> >+		if (s.replacing)
> >+			set_bit(STRIPE_INSYNC, &sh->state);
> >+		set_bit(STRIPE_REPLACED, &sh->state);
> > 	}
> > 	if ((s.syncing || s.replacing) && s.locked =3D=3D 0 &&
> > 	    test_bit(STRIPE_INSYNC, &sh->state)) {
> >diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> >index b0b663b..70c4932 100644
> >--- a/drivers/md/raid5.h
> >+++ b/drivers/md/raid5.h
> >@@ -306,6 +306,7 @@ enum {
> > 	STRIPE_SYNC_REQUESTED,
> > 	STRIPE_SYNCING,
> > 	STRIPE_INSYNC,
> >+	STRIPE_REPLACED,
> > 	STRIPE_PREREAD_ACTIVE,
> > 	STRIPE_DELAYED,
> > 	STRIPE_DEGRADED,


--Sig_/P+iQ51+y7r7BLrkuijWthMY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUe32tTnsnt1WYoG5AQKNxA/+IfCMqvdv73vVP8k6ec+zv7pJVkvGO4Ze
+XdCewZcfRaEZr2cn1J04ToFcKZpkmph+szs9Txr6syluJvlVAazc+K+CAm4xnjO
EJFZo4Q9RvIEjrfbeIdz2HvyWCiY5NX2sKeJ0e9X2KvQAdCmpSMXiQ8BCGgDwYRk
d1COWk5dZa27I3mPofZ0RsQMFaktEn7DIvxsQHJgT+W96HrdNRZbQ5rFBKdHQw4X
a9I6pMN5QJPOFLk5IxCwVV0J+gOCuin9GHUdfElLGK2whG1Ozpq3DMxXkx9a94ZA
bG04zT0gTnXM9a92Ys/VZExbDX/Ql3+pIKhUUZyJLrTOOtoH6rzSCTz4etPPnaLx
M1Zx44TY+L3RFGGW3ZIV2rrxp3UhcgLLU7hMBRWG7QUk7d9UBhBhZ6leOxto0F+k
Z6MT7d7JuP1MUVJXYQ+y1saVbEW4d1bsy1U9mxlo7lTyxpMnhobF2LBNYElNaBWs
U0hgDxX4LDihIBqCqtqclAFCH75cefPHNpSsKSdRuCssK/+2lOGJ93PdNaxGJ4j+
DIKpPyi2gkV5f+/Ck9yoJ1fX9xH920GJxw9gNhU/lwJ8Ky+vZHM6aqHICgv+Tmzt
NA71BXdcukgd8EzLnd6O+ILfoTKTVITX10hmpk683YfYJjtcxi1pflBo+yQIhwUD
ArwHABPTyV8=
=9N/C
-----END PGP SIGNATURE-----

--Sig_/P+iQ51+y7r7BLrkuijWthMY--
