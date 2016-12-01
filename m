From: NeilBrown <neilb@suse.com>
Subject: Re: MD Remnants After --stop
Date: Thu, 01 Dec 2016 13:52:48 +1100
Message-ID: <87shq8743j.fsf@notabene.neil.brown.name>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com> <87fun3ond9.fsf@notabene.neil.brown.name> <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com> <87fumlebwo.fsf@notabene.neil.brown.name> <CAHkw+LfN9xaFmmvg653OKh1eH=_kLdhd3Y1QMg3955TePCCtkg@mail.gmail.com> <CAHkw+Ldbwkknz6ZqxVpFEE-3z1r7pz1AjamUbZaEPn_uyMn_-w@mail.gmail.com> <878tsbcbub.fsf@notabene.neil.brown.name> <CAHkw+Ldv+-uXGCQ+tKfkraZ3VF4V8sk203+Oopm7RvygGQQYGQ@mail.gmail.com> <87oa15938i.fsf@notabene.neil.brown.name> <CAHkw+LfJzZoWVnO8kDi+YVV09fas2DveQoChh10wEBZfYin6aQ@mail.gmail.com> <8760n8a7k5.fsf@notabene.neil.brown.name> <CAHkw+Lc9YEdbJcRu2bOLU-gex9UYSXB32iRKD8TPS7JpjSOdQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHkw+Lc9YEdbJcRu2bOLU-gex9UYSXB32iRKD8TPS7JpjSOdQA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Smith <marc.smith@mcc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Nov 28 2016, Marc Smith wrote:

>
> # find /sys/block/md127/md
> /sys/block/md127/md
> /sys/block/md127/md/reshape_position
> /sys/block/md127/md/layout
> /sys/block/md127/md/raid_disks
> /sys/block/md127/md/bitmap
> /sys/block/md127/md/bitmap/chunksize

This tells me that:
	sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
hasn't been run, so mddev_delayed_delete() hasn't run.
That suggests the final mddev_put() hsn't run. i.e. mddev->active is > 0

Everything else suggests that array has been stopped and cleaned and
should be gone...

This seems to suggest that there is an unbalanced mddev_get() without a
matching mddev_put().  I cannot find it though.

If I could reproduce it, I would try to see what is happening by:

- putting
   printk("mddev->active = %d\n", atomic_read(&mddev->active));
 in the top of mddev_put().  That shouldn't be *too* noisy.

- putting
   printk("rd=%d empty=%d ctime=%d hold=%d\n", mddev->raid_disks,
   	list_empty(&mddev->disks), mddev->ctime, mddev->hold_active);

  in mddev_put() just before those values are tested.

 - putting
     printk("queue_work\n");
   just before the 'queue_work()' call in mddev_put.

 - putting
     printk("mddev_delayed_delete\n");
   in mddev_delayed_delete()

Then see what gets printed when you stop the array.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlg/kIAACgkQOeye3VZi
gbnyjxAApSaRa1ykGC0r++NqQa78AliV+c54DR0xkughH53pg9W5XfPnLN0tl+Qz
cXV/axRP4O0Dxuppax1KJHzn9G7fR87gPqPeikJ0FLQXRe6OsB3sFoLx/zFn2umj
gHEvHDk5SEABjgA8Mrna9cxO+GT7KUNF+svzZEStA8xG2i/Z0zz9vf5pW1t+aM2u
YzUoiSfzoM7AiVfkP5mzb0N/svQ92ONzdYsz7dhslPPqerHkj33w6etidkaYNXCW
Kh3gG3tMGLdEzoPLHc7ubka819F6YJFSby7AxDkdkHgkEeARCHTaRxRuMF/UV0bo
HFhkqEGyUG1I1ozliD/kcQ+G4Y5oeUSc7unedssKquojFFQjBYndWpUXy9AohHvI
YV5Tw5V3yzeh1WfXlubr2ws0ver00wSRH1nULnbCusEhIa00Xy9AC6/3eZuSSNGR
8pZAkgVw/jbZC0u0AYff9Xc3+ivoN5RkU5ATplhN1JqcT9FiNYXLz9YZTGLKHB74
6x3ubsco2+lWEivC5rpZRq6tR9qRB4549hyi2Htlf1vLm/mQ4mE4AUOYQbUymxCM
oizNZISJ3jmA7q20uY6g4xv5lNdB0MJwVOi5IPtbq1JRkanWAyWnECyHfcniqIfy
d0qsF4zz4HEYzRXPH+OApa7inHdhmx2sjhHGwrvitrk7goUobVc=
=guN2
-----END PGP SIGNATURE-----
--=-=-=--
