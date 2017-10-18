From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] [RFC] md raid10: use rcu to avoid NULL dereference in raid10d()
Date: Thu, 19 Oct 2017 10:06:56 +1100
Message-ID: <87zi8oginj.fsf@notabene.neil.brown.name>
References: <20171017163637.17132-1-colyli@suse.de> <87efq1k0ef.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87efq1k0ef.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18 2017, NeilBrown wrote:

> On Wed, Oct 18 2017, Coly Li wrote:
>
>> We have a bug report about NULL dereference in md raid10 code. The
>> operations are,
>>  - Create a raid10 device
>>  - add a spare disk
>>  - disconnect one of the online disks from the raid10 device
>>  - wait to the recovery happens on the spare disk
>>  - remove the spare disk which is recovering
>> And sometimes a kernel oops of NULL dereference in md raid10 module can
>> be observed, and crash tool reports the following information:
>>> (gdb) list *(raid10d+0xad6)
>>> 0x5de6 is in raid10d (../drivers/md/raid10.c:2300).
>>> 2295		 * the latter is free to free wbio2.
>>> 2296		 */
>>> 2297		if (wbio2 && !wbio2->bi_end_io)
>>> 2298			wbio2 =3D NULL;
>>> 2299		if (wbio->bi_end_io) {
>>> 2300			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
>>> 2301			md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
>>> 2302			generic_make_request(wbio);
>>> 2303		}
>>> 2304		if (wbio2) {
>> At line 2300, conf->mirrors[d].rdev is NULL, this causes a NULL pointer
>> dereference to conf->mirrors[d].rdev->nr_pending. After reading previous
>> raid10 patches, I find conf->mirrors[d].rdev can be NULL at any point
>> unless,
>>  - a counted reference is held
>>  - ->reconfig_mutex is held, or
>>  - rcu_read_lock() is held
>
> There is one other condition: MD_RECOVERY_RUNNING is set (without
> MD_RECOVERY_DONE).
> mirrors[d].rdev is only set to NULL by ->hot_remove_disk() which is only
> called from remove_and_add_spares(), and that is never called while
> resync/recovery/reshape is happening.
> So there is no need for RCU protection here.
>
> Only ... remove_and_add_spares() *can* sometimes be called during
> resync -
> Commit: 8430e7e0af9a ("md: disconnect device from personality before tryi=
ng to remove it.")
> added a called to remove_and_add_spares() when "remove" is written to
> the device/state attribute.  That was wrong.
> This:
>
>  	} else if (cmd_match(buf, "remove")) {
> -		if (rdev->mddev->pers) {
> +		if (rdev->mddev->pers &&
> +		    !test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
>  			clear_bit(Blocked, &rdev->flags);
>  			remove_and_add_spares(rdev->mddev, rdev);
>
> should fix it.

Actually, that doesn't even compile :-(

I think this is a better fix.
Thanks,
NeilBrown

From: NeilBrown <neilb@suse.com>
Date: Thu, 19 Oct 2017 09:58:19 +1100
Subject: [PATCH] md: only allow remove_and_add_spares() when no sync_thread=
 running.

The locking protocols in md assume that a device will
never be removed from an array during resync/recovery/reshape.
When that isn't happening, rcu or reconfig_mutex is needed
to protect an rdev pointer while taking a refcount.  When
it is happening, that protection isn't needed.

Unfortuantely there is a case were remove_and_add_spares() is
called when recovery might be happening: when "remove" is
written to the device/state sysfs attribute.

This call is an optimization and not essential so it doesn't
matter if it fails.
So change remove_and_add_spares() to abort early if
resync/recovery/reshape is happening.

As this can result in a NULL dereference, the fix is suitable
for -stable.

Cc: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Fixes: 8430e7e0af9a ("md: disconnect device from personality before trying =
to remove it.")
Cc: stable@ver.kernel.org (v4.8+)
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b3192943de7d..01eac0dbca98 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8563,6 +8563,10 @@ static int remove_and_add_spares(struct mddev *mddev,
 	int removed =3D 0;
 	bool remove_some =3D false;
=20
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		/* Mustn't remove devices when resync thread is running */
+		return 0;
+
 	rdev_for_each(rdev, mddev) {
 		if ((this =3D=3D NULL || rdev =3D=3D this) &&
 		    rdev->raid_disk >=3D 0 &&
=2D-=20
2.14.0.rc0.dirty



--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnn3pIACgkQOeye3VZi
gbllnQ//W92nxA7D8ag1zrk0TyPBDsviNd+RTQUrKBn4yHrZoMXobizMvhUmfZcK
w7Xyx5YPLgXLmGEPZ1hEurzFbdr+RzemuDLB3ifqPkpXRMhq8bhT7BDv0rNs5cTA
bWQLiHomVPdCzGobDWP2115jypzmJsG/TknCN7C3IHNfMLoLA7KGVti103WQxrmx
odiWhyiM+cTkfLmFkZpj8+v+6lbqEjtV/ZIZeHmbNn+dJLP6HUIpQqPhY5mzms3/
Q96IoF/jnHW6h51JDFkVTdN+LxFFempEtbIK+zLQ0O41UdKPa1zhNCtdXIqTnUW6
Am02/FoxwFxAuSfWrKlms5s70fNiwP/XeoAtplPjLXK8xoUE/+E7RgWmkKdYC+9R
wTXIPEMFhDRxL+4jJzDGd2yrcHr1ZscyQIozTviXotPAjkGLJ1qCrq7y6yY3uhT6
aRbpz0LTQWyxVbY55nQ5xZ5ESuvFIYuJk60mw/UUyS1Pvh/Swr5OsgE7YxYuXdS4
lsqcWVSxi36JKO6/UQfQaNWSAKtjuIv87gacTHtyrDzpDEHC99oCOdmQYOws7s/Y
4agQ1sUONhoOMel2KrSEI1R3SSGdTCSF08vtWWqznS46Q9sY+NI1Kly3bQ6Muigy
gmPojhE4VXlBlefzbielQDNhRUrqtZj8YKTbfhzaSj2nEJ7wb8s=
=sTfb
-----END PGP SIGNATURE-----
--=-=-=--
