From: NeilBrown <neilb@suse.de>
Subject: Re: Raid0 expansion problem in md
Date: Wed, 14 Dec 2011 15:42:19 +1100
Message-ID: <20111214154219.6eadf590@notabene.brown>
References: <79556383A0E1384DB3A3903742AAC04A05F9CF@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uBqzO=ECXK59weL5kIxRirV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A05F9CF@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/uBqzO=ECXK59weL5kIxRirV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Dec 2011 15:45:30 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> Hi Neil,
>=20
> On the latest md neil_for-linus branch I've found raid0 migration problem.
> During OLCE in user space everything goes fine, but in kernel process is =
not moved forward.
> /older md works fine/
>=20
> It is stopped in md in reshape_request() in line (near raid5.c:3957)
>     wait_event(conf->wait_for_overlap, atomic_read(&conf->reshape_stripes=
)=3D=3D0);
>=20
> I've found that this problem is a side effect of patch:
>     md/raid5: abort any pending parity operations when array fails.
> and added line in this patch:
>      sh->reconstruct_state =3D 0;
>=20
> During OLCE we are going inside because condition
>     if (s.failed > conf->max_degraded)
> with values:
>      locked=3D1 uptodate=3D5 to_read=3D0 to_write=3D0 failed=3D2 failed_n=
um=3D4,1
>=20
> and sh->reconstruct_state is set to 0 (reconstruct_state_idle) from 6 (re=
construct_state_result)
> When sh->reconstruct_state is not reset raid0 migration is executed witho=
ut problem.
> Problem is probably in not executed code for finishing reconstruction (ar=
ound raid5.c:3300)
>=20
> In our case field s.failed should not reach value 2 but we've got it for =
failed_num =3D 4,1.=20
> It seems that '1' is failed disk for stripe in old array geometry and 4 i=
s failed disk for stripe in new array geometry.
> This means that degradation during reshape is counted two times /final st=
ripe degradation is sum of old and new geometry degradation/.
> When we reading (from old array) and writing (to new geometry) a degraded=
 stripe  and degradation is on different positions (raid0 OLCE case) analys=
e_stripe() gives
> us false failure information. Possible that we should have old_failed and=
 new_failed counters to know in what geometry (old/new) failure occurs.
>=20
>=20
> Here is reproduction script:
>=20
> export IMSM_NO_PLATFORM=3D1
> #create container
> mdadm -C /dev/md/imsm0 -amd -e imsm -n 4 /dev/sdb /dev/sdc /dev/sde /dev/=
sdd -R
> #create array
> mdadm -C /dev/md/raid0vol_0 -amd -l 0 --chunk 64 --size  1048 -n 1 /dev/s=
db  -R --force
> #start reshape
> mdadm --grow /dev/md/imsm0 --raid-devices 4
>=20
>=20
> Please let me know your opinion.

Thanks for the excellent problem report.

I think it is best fixed by the following patch.
I also need to fixed up the calculate of 'degraded' so it doesn't say '2' in
this case, which is confusing.  Then I'll commit the fixes.


Thanks,
NeilBrown

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 31670f8..858fdbb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3065,11 +3065,17 @@ static void analyse_stripe(struct stripe_head *sh, =
struct stripe_head_state *s)
 			}
 		} else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);
-		else {
+		else if (sh->sector + STRIPE_SECTORS <=3D rdev->recovery_offset)
 			/* in sync if before recovery_offset */
-			if (sh->sector + STRIPE_SECTORS <=3D rdev->recovery_offset)
-				set_bit(R5_Insync, &dev->flags);
-		}
+			set_bit(R5_Insync, &dev->flags);
+		else if (test_bit(R5_UPTODATE, &dev->flags) &&
+			 test_bit(R5_Expanded, &dev->flags))
+			/* If we've reshaped into here, we assume it is Insync.
+			 * We will shortly update recovery_offset to make
+			 * it official.
+			 */
+			set_bit(R5_Insync, &dev->flags);
+
 		if (rdev && test_bit(R5_WriteError, &dev->flags)) {
 			clear_bit(R5_Insync, &dev->flags);
 			if (!test_bit(Faulty, &rdev->flags)) {

--Sig_/uBqzO=ECXK59weL5kIxRirV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTugpKznsnt1WYoG5AQL9AQ/8CRAYIFO+ivHDk6mIT6JuCoFjxNIktRaY
06IeMhqiFuDzRxedSe8BJUq2QWdXPsRovJ64TR0/o0TELXiEaomhlgqJvCcACdBB
bI5PU9QMbm7hx7qEHIvEsXHtZAvXGAx80qSYoASPuNWokxId8Ug5YirFIv7hAMEr
Yko9J+8GcwOba4vCw1OBm+/ZqYbtQ5+le4EJ9OihXlsk5A/iAJ3vCAg+2kXwBhPC
WbKj06lM58T3EuGBSIJOLDrLh3rf2wNKPLuzAxtTver4ONnZNcCD3mlqbKHBECwY
0q9k3673gAHGpCkqN8npifKzncFirrzs97Wvkz0/utroKWZwCaCmlrCRiv5pTPvh
UQbaS61peuyv37/OtfpSVSuKF+az1RszgdRegf2JCDEq/zxNzspnxZvlG5E+uVL4
ikO2SKMXjFsDfmmq+RxaH7JrqKAtRo+AhTO8gLAWNwRUVA+IvHcZrsqbkdwtIYK/
UNc7qezzo/6XYvNgiIRTozkkmT/P6TtVIhOAL13/HbxKiQTonvPuZuPlCLLfTMbs
U6BncuFAIC9pfabiFhD9+ohB4d3CquTApNIM4YyX/uubNnjT+22DpZhps2bElheH
Z3MEJaqHO1z0EnH+lOKOYI1No7WIvyTy2wBuyrjZ6BHvarT2mZdg7MiJmK23sgwc
ArOzxHu4V4I=
=hhKt
-----END PGP SIGNATURE-----

--Sig_/uBqzO=ECXK59weL5kIxRirV--
