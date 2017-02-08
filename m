From: NeilBrown <neilb@suse.com>
Subject: Re: [systemd-devel] Errorneous detection of degraded array
Date: Wed, 08 Feb 2017 15:10:57 +1100
Message-ID: <87h945uxta.fsf@notabene.neil.brown.name>
References: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com> <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com> <87vasxs47y.fsf@notabene.neil.brown.name> <666d5a48-4c71-77ee-f71b-c32f334cf7cc@gmail.com> <87k29drr3w.fsf@notabene.neil.brown.name> <CAA91j0V92RXDky-AnD6w+Dy=M7KJVCWyssA7yHRfRqBxLTWvog@mail.gmail.com> <8760kwry0r.fsf@notabene.neil.brown.name> <e32430d2-5f59-40af-6027-715dfde1045d@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e32430d2-5f59-40af-6027-715dfde1045d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Luke Pyzowski <Luke@sunrisefutures.com>, "systemd-devel@lists.freedesktop.org" <systemd-devel@lists.freedesktop.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 31 2017, Andrei Borzenkov wrote:

>
>>>> Changing the
>>>>   Conflicts=3Dsys-devices-virtual-block-%i.device
>>>> lines to
>>>>   ConditionPathExists=3D/sys/devices/virtual/block/%i
>>>> might make the problem go away, without any negative consequences.
>>>>
>>>
>>> Ugly, but yes, may be this is the only way using current systemd.
>>>
>
> This won't work. sysfs node appears as soon as the very first array
> member is found and array is still inactive, while what we need is
> condition "array is active".

Of course, you are right.
A suitable "array is active" test is the existence of
  .../md/sync_action
which appears when an array is activated (except for RAID0 and Linear,
which don't need last-resort support).

So this is what I propose to post upstream.  Could you please confirm
that it works for you?  It appears to work for me.

Thanks,
NeilBrown

From: NeilBrown <neilb@suse.com>
Date: Wed, 8 Feb 2017 15:01:05 +1100
Subject: [PATCH] systemd/mdadm-last-resort: use ConditionPathExists instead=
 of
 Conflicts

Commit cec72c071bbe ("systemd/mdadm-last-resort: add Conflicts to .service =
file.")

added a 'Conflicts' directive to the mdadm-last-resort@.service file in
the hope that this would make sure the service didn't run after the device
was active, even if the timer managed to get started, which is possible in
race conditions.

This seemed to work is testing, but it isn't clear why, and it is known
to cause problems.
If systemd happens to know that the mentioned device is a dependency of a
mount point, the Conflicts can unmount that mountpoint, which is certainly
not wanted.

So remove the "Conflicts" and instead use
 ConditionPathExists=3D!/sys/devices/virtual/block/%i/md/sync_action

The "sync_action" file exists for any array which require last-resort
handling, and only appear when the array is activated.  So it is safe
to reliy on it to determine if the last-resort is really needed.

Fixes: cec72c071bbe ("systemd/mdadm-last-resort: add Conflicts to .service =
file.")
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 systemd/mdadm-last-resort@.service | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/systemd/mdadm-last-resort@.service b/systemd/mdadm-last-resort=
@.service
index e93d72b2b45e..f9d4d12738a3 100644
=2D-- a/systemd/mdadm-last-resort@.service
+++ b/systemd/mdadm-last-resort@.service
@@ -1,7 +1,7 @@
 [Unit]
 Description=3DActivate md array even though degraded
 DefaultDependencies=3Dno
=2DConflicts=3Dsys-devices-virtual-block-%i.device
+ConditionPathExists=3D!/sys/devices/virtual/block/%i/md/sync_action
=20
 [Service]
 Type=3Doneshot
=2D-=20
2.11.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliamlEACgkQOeye3VZi
gbmVBg//XYNrhN9rm5uqaLLTx8tOaxaT0pm/6dY5RCZXi7DWZkacUVNx0qw26ylz
hZzImeJ4CwuQi61ssSyOhMPHSpw+0VvddUmm4lT26CjIHd011V/yBMuqedVPBKNq
YvrXBMS084Xbln4TFNC7MdGhmYFsg9E96J8zuVCqNrqvLLl+pFhiCzAL9htFWXAa
yreKs6WjOWxmxXXWMUH8a8v8uoPodFgr8290Y/OK1MUCcZqTa4QxRqGv+huhsWYF
qyrOSLnravDtgQuh36JKin5U0+TicS7WSaYnmHGLAeKymerZ4Xe/rBQDAi5nyaG7
n27V6Xo9+QamPn6vdxR9VFW2enRDcji1sg5coCLmTWSRrblNOgIRai/OPN/tFSVF
i4mp4SXno3QmLQgyxTYeH/Qqx4k0BtzDFPOhoSJGISUmZYpIikU6lwGp/BspznvV
hilpyGoBWcv2d2zG2LKVAvxUNjptN2x0Zd9QdaJatqtCxZCIlYnHSfw19IrWhfFr
Gc+TzIKGX4Fd6CXfAcdNrK1HXJ2ysgDdpWGkEkLGoS+B9J9aSsmav2qDAuFbx6ff
4yopDVfT/TyNwHRsjWKi1TRM8cj9MORg037Vsmnuhk99B4OQNzMCXSXSXp6z8fYw
IazV41FbNoLJujJ8JKoKGkxys3hVsnuiUz6XEbiDYRNBCx3ei78=
=Rx3/
-----END PGP SIGNATURE-----
--=-=-=--
