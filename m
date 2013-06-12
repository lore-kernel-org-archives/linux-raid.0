From: NeilBrown <neilb@suse.de>
Subject: Re: BUG - raid 1 deadlock on handle_read_error / wait_barrier
Date: Wed, 12 Jun 2013 10:42:07 +1000
Message-ID: <20130612104207.65b0e3ef@notabene.brown>
References: <1361487504.4863.54.camel@linux-lxtg.site>
	<20130225094350.4b8ef084@notabene.brown>
	<20130225110458.2b1b1e2d@notabene.brown>
	<1361808662.20264.4.camel@148>
	<alpine.DEB.2.02.1302260905390.1736@jlaw-desktop.mno.stratus.com>
	<CAGRgLy45byT7fxLBOqU6ZNjpOL0Xmq6nNsiwJSCTq+kd1Ya7Jg@mail.gmail.com>
	<20130520171753.002f07d9@notabene.brown>
	<CAGRgLy5m8KxKPxJE+AbtYbBDzo9uo81wez1ba=H4VY3Jiq32WQ@mail.gmail.com>
	<CAGRgLy4zTwopPS-cVwT1RKBr8pE7f3n-X3YLyFpktooQtTYGuQ@mail.gmail.com>
	<20130604114924.37e4573c@notabene.brown>
	<51B0A40A.2010208@bluehost.com>
	<CAGRgLy5yWdo4qu5kKsaYjzTwRJNQB_87vPKOFx71FCUxjd6K_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ruNoKtg0fshDRPg4Q8O2UCn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5yWdo4qu5kKsaYjzTwRJNQB_87vPKOFx71FCUxjd6K_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shyam Kaushik <shyam@zadarastorage.com>, yair@zadarastorage.com, Tregaron Bayly <tbayly@bluehost.com>
List-Id: linux-raid.ids

--Sig_/ruNoKtg0fshDRPg4Q8O2UCn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 8 Jun 2013 12:45:41 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> after reading the code of raid1.c, I see that there's also
> conf->retry_list, which is also flushed by raid1d, but not by
> flush_pending_writes(). So I think it can also cause similar deadlock,
> but I don't know how to fix it:(
>=20

Good point.
Requests in retry_list are counted in nr_queued, which is checked in
freeze_array().

And freeze_array() already calls flush_pending_writes().

So I suspect the right thing to do is use freeze_array() in place of
raise_barrier().

So maybe this is the right approach.

Testing greatly appreciated...

Thanks,
NeilBrown



diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 226dcd0..240b328 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1569,8 +1569,8 @@ static int raid1_add_disk(struct mddev *mddev, struct=
 md_rdev *rdev)
 		 * we wait for all outstanding requests to complete.
 		 */
 		synchronize_sched();
-		raise_barrier(conf);
-		lower_barrier(conf);
+		freeze_array(conf);
+		unfreeze_array(conf);
 		clear_bit(Unmerged, &rdev->flags);
 	}
 	md_integrity_add_rdev(rdev, mddev);
@@ -1620,11 +1620,11 @@ static int raid1_remove_disk(struct mddev *mddev, s=
truct md_rdev *rdev)
 			 */
 			struct md_rdev *repl =3D
 				conf->mirrors[conf->raid_disks + number].rdev;
-			raise_barrier(conf);
+			freeze_array(conf);
 			clear_bit(Replacement, &repl->flags);
 			p->rdev =3D repl;
 			conf->mirrors[conf->raid_disks + number].rdev =3D NULL;
-			lower_barrier(conf);
+			unfreeze_array(conf);
 			clear_bit(WantReplacement, &rdev->flags);
 		} else
 			clear_bit(WantReplacement, &rdev->flags);
@@ -3021,7 +3021,7 @@ static int raid1_reshape(struct mddev *mddev)
 		return -ENOMEM;
 	}
=20
-	raise_barrier(conf);
+	freeze_array(conf);
=20
 	/* ok, everything is stopped */
 	oldpool =3D conf->r1bio_pool;
@@ -3052,7 +3052,7 @@ static int raid1_reshape(struct mddev *mddev)
 	conf->raid_disks =3D mddev->raid_disks =3D raid_disks;
 	mddev->delta_disks =3D 0;
=20
-	lower_barrier(conf);
+	unfreeze_array(conf);
=20
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);

--Sig_/ruNoKtg0fshDRPg4Q8O2UCn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUbfD3znsnt1WYoG5AQLOEw/9HvfTq9oXazAJc8YfJs3OzRbj0zwknp9b
/ICQu5/Su23loOqRI1Bqctlgcebb+nBFHlr78aIlqCeSC6Q0v7smmZGc5+I8BI94
AArhkE0x9U7+VbGCqktGkH+Z2JmI9VtSpySF3vD7dO69sWuif+fx5D6z1jQytaaX
aORsTsrNw4G+m6BoTcbHfVzsG/Pr+JvYrNz9zPqTuVYzZAmnmwMZb1XKhzJw5jPz
7ofSfVz/suavlUKZRBe9UBL625JaYwpAw09g3IHSfxsE9L01jfMm6D7GgP6XSgJ+
zHm5bzsVo40ATHCHOCMk93NzzDJckateMOPUht3A8Yo4mpoAudl37mSW5lPfMhz5
kjXoS6Aw2PUucmnFmBpqHJ9fzzW6XkffoMAZy52ftY33vSSVModYuuZIFkOJ3ygt
eNrhIWzmO0hJBy3sIe48VgaO6qmvpRpepTmqmgTjOSvM8I3VoBNLUsJAUAPFt4Fi
h3Z3kLDqqClTpDXtUXAkYd53U3mQ7PARtTVlVSb9I19t+2qPnM72G5sd0ZsT7Zfw
NGRF4nise+u6vvaa9EO36f1qMb/+YKy6GyMPBz4NlnMe+tPkOajfOtlTzQVdKitK
8tu/gDDdlLuKyAraK4ZmQD2ao+0iXTbMCaMb6YmpOEQEhws/yY/xSf2t4wLI8bh0
D75zS9lKc8Q=
=BwYy
-----END PGP SIGNATURE-----

--Sig_/ruNoKtg0fshDRPg4Q8O2UCn--
