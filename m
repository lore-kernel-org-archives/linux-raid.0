From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH - RFC] MD: Sync thread not properly shutdown after
 mddev_suspend()
Date: Mon, 6 May 2013 16:12:45 +1000
Message-ID: <20130506161245.548b47a1@notabene.brown>
References: <1367525963.23442.4.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Dx7BGJ3QUGjyXETZ=M2aUVP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1367525963.23442.4.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Dx7BGJ3QUGjyXETZ=M2aUVP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 02 May 2013 15:19:23 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> MD: Sync thread not properly shutdown after mddev_suspend()
>=20
> After performing an 'md_stop_writes' followed by an 'mddev_suspend',
> it is possible to have 'MD_RECOVERY_RUNNING' set in mddev->recovery.
> It doesn't happen often, but when it does, the recovery thread does
> not restart properly after a resume.
>=20
> The problem seems to come from 'md_stop_writes'.  This function is a
> wrapper around '__md_stop_writes' - surrounding it with mddev_[un]lock
> calls.  While '__md_stop_writes' properly cleans up the sync thread,
> the subsequent 'mddev_unlock' call will wake up the personality thread,
> which in turn calls 'md_check_recovery' - a function that sets
> mddev->recovery flags and potentially launches the sync thread.
> Effectively, this can undo what has just been done.
>=20
> When 'mddev_suspend' is called, it sets the mddev->suspended variable.
> This variable causes 'md_check_recovery' to simply return if set.  Thus,
> it is better to reap the sync thread in mddev_suspend, because it cannot
> be respawned until mddev_resume is called.
>=20
> There are probably several ways to solve this problem.  The simplest way
> was to add 'md_reap_sync_thread' to mddev_suspend.  It may be
> better fixed in 'md_stop_writes' though.  We could also combine
> 'md_stop_writes' and 'mddev_suspend' by calling '__md_stop_writes' from
> within 'mddev_suspend' after mddev->suspended has been set.
>=20
> Thoughts?

Thanks for the thorough analysis.

Your patch looks like it would work,  but it involves calling
md_reap_sync_thread() twice which is a little ugly.

How about this:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4c74424..3e2acfa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5277,8 +5277,8 @@ static void md_clean(struct mddev *mddev)
=20
 static void __md_stop_writes(struct mddev *mddev)
 {
+	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	if (mddev->sync_thread) {
-		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		md_reap_sync_thread(mddev);
 	}


Callers of md_stop_writes() already need to be prepared for
MD_RECOVERY_FROZEN to get set, and raid_resume() clears it for dm-raid.c, so
it should be safe.
An md_check_recovery won't start anything while MD_RECOVERY_FROZEN is set.
So this should *really* stop writes going to the devices.

Make sense?

Thanks,
NeilBrown



>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/md.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/md.c
> +++ linux-upstream/drivers/md/md.c
> @@ -360,6 +360,7 @@ void mddev_suspend(struct mddev *mddev)
>  	mddev->pers->quiesce(mddev, 1);
> =20
>  	del_timer_sync(&mddev->safemode_timer);
> +	md_reap_sync_thread(mddev);
>  }
>  EXPORT_SYMBOL_GPL(mddev_suspend);
> =20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Dx7BGJ3QUGjyXETZ=M2aUVP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYdJ3Tnsnt1WYoG5AQLs4A/+NkL7YB0sF6b7LHPmWpgBTFV/JDMZHAs2
0u/JEqSrPaARgZ2I/mqPhB0M7gTa+nNG3VevFpO5Fd0DnNqdB6QK+9+IzYjMOLEX
pUy5jQoSjWDNCipYP40tY9o9Zhl8uH1n7s7g+BjsjdLtzY7zrWhwSglpDvXqAM5+
+sDh3t1NxkV+o0g9E7EQysXObhets/W3KVsW0+CWaIYcT8QCMxlaVUdC51K+8xQb
kesYbPqtvMuV+SbzNk1HrydZHok96GuBnP7UTwZe0xghLU5r3RFNzHXTbXZhTt8v
XoFLqy7GiH5FGJrqgSiDI1DxwB+wJiH44CWc2hLZfubk3sWT+e8aIyFfNod9vwLG
INRDzz4r4Bu53dbI+o7Q8eRNlAnMpcOYywkgNEpNyx/xxbNp2O91sUL5EbCpbEfh
JN0EN738Vr716NmmUTa/vJ5q/T5T18CDm4+g7SHwLBlTjhWKNNnE/JCkem0GbubX
vBUqedQyv5e3eDeeQyEqSr5jkqkdXQktvvpnFBTtBY3E/p//oh1ssLT+kAybhAVs
8wjrzIy1akovlUa1NbZFqsKNgFm10Uix6KiPnvD8JcIQsRabzpWOKZv/lxcCPwv+
LGuVk4JXF2EnBDsdMcSf7xEd9q/mEOiAl+df1FmzMbqldHZmNPzJ8NFv18PSbviF
txC1+9USB0A=
=WTM5
-----END PGP SIGNATURE-----

--Sig_/Dx7BGJ3QUGjyXETZ=M2aUVP--
