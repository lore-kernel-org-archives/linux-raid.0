From: NeilBrown <neilb@suse.de>
Subject: Re: After reshaping raid1 to raid0 with bitmap, then stop md panic
Date: Wed, 6 Aug 2014 16:37:02 +1000
Message-ID: <20140806163702.15592dc6@notabene.brown>
References: <324320204.17911195.1407221719669.JavaMail.zimbra@redhat.com>
	<11051344.17913061.1407222186494.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/W6DV+PE/B.rycQs0_IDtnWk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11051344.17913061.1407222186494.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

--Sig_/W6DV+PE/B.rycQs0_IDtnWk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Aug 2014 03:03:06 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

> Dear all
>=20
>=20
>    I faced one problem that the system panic after reshaping raid1 to rai=
d0 with bitmap.
> The dmesg and calltrace information is like this:
>=20
>    You can easily reproduce this by those steps:
>    1. mdadm -CR /dev/md0 -l1 -n2 /dev/loop[0-1] --bitmap=3Dinternal
>    2. mdadm --wait /dev/md0
>    3. mdadm --grow -l0 /dev/md0
>    4. mdadm -S /dev/md0
...
>=20
> [ 1485.646746] BUG: unable to handle kernel NULL pointer dereference at 0=
000000000000038
> [ 1485.654724] IP: [<ffffffff8148db2e>] bitmap_daemon_work+0x24e/0x450

Yes, RAID0 doesn't support bitmaps, so this cannot possibly work.

Following patch should turn the crash into a clean failure.

Thanks for the report,
NeilBrown


=46rom 1bdb20e16166240a4ca3b861c48defefaf218874 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 6 Aug 2014 16:34:27 +1000
Subject: [PATCH] md: check for bitmap compatability when changing raid leve=
ls.

If an array has a bitmap, then it cannot be converted to
a level which does not support bitmaps.

Reported-by: Xiao Ni <xni@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1379b1a3b9ff..3bd13b276e45 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3500,6 +3500,12 @@ level_store(struct mddev *mddev, const char *buf, si=
ze_t len)
 		       mdname(mddev), clevel);
 		return -EINVAL;
 	}
+	if (mddev->bitmap && !pers->quiesce) {
+		module_put(pers->owner);
+		printk(KERN_WARNING "md: %s: %s does not support a bitmap\n",
+		       mdname(mddev), clevel);
+		return -EINVAL;
+	}
=20
 	rdev_for_each(rdev, mddev)
 		rdev->new_raid_disk =3D rdev->raid_disk;

--Sig_/W6DV+PE/B.rycQs0_IDtnWk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+HNDznsnt1WYoG5AQLDaw/+NNt3GWUq6ksTLnkXG530zA3pd/+dlQxU
XoL/at3JSdpBFPSXIFytQwnE35XdlaSMHBQ0oqgh2CJVIcpAZl7sAaqQIrUrBAYX
0gPyVkHO9efaU0zBR5jUxfegIlaiQZapLSil8qkKR7rat3EVzJVe5dqHGSz8kHg0
ni5DgVyYGjC1wMH6+DzzCtvr/VqmKdKTQasJQ+PUx6LAY+V68eeWrWHAdpshHqTl
y8WLRUN6fjCivoKSSICGXypKn2yf4g4bltkWAE3AlwxTMyeiij8AcchnWen0N681
n5fESxQuN+V2YN340KV9BGCkyAn7Rj1mPdP7h/GFYOwqHKMCqKurTErl7G6iaZN5
xXaA+PQOzezhtS3t44agu0wJLrbAYD0vnbMYNW9xAKBYV9RfbTH4QDnTahUushxl
Fvtz/kg8WQDZCYNF0V0ScHlFs0h4lhzGtrKODIFdHYQcAnXCJCGAyO92ksZDh11c
8h6Wbnyal+GVLWfFMahMAAsrL4N7xJ5lWxpxMjpM5egM58eLROmLPb0aMjt1e+1x
fn/B+ORs8LREEjhU0Md1rDzL2MqBZvknsgSpqm8PIBDIe4hP20BskJOTdP3ip+Qj
sMERT2tl4GjAeXg4lqcvBksfE9X2Ds6/FbEoBLRbM/WvQlPYIYl6xJ06UfY8KI/d
XsooXiA98FM=
=koRD
-----END PGP SIGNATURE-----

--Sig_/W6DV+PE/B.rycQs0_IDtnWk--
