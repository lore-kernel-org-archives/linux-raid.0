From: NeilBrown <neilb@suse.de>
Subject: Re: MD RAID 1 fail/remove/add corruption in 3.10
Date: Wed, 17 Jul 2013 14:52:30 +1000
Message-ID: <20130717145230.5088c52c@notabene.brown>
References: <20130716144920.39f428b7@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZeeMu+oe08ba7VJo==l9TUM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130716144920.39f428b7@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org, Martin Wilck <mwilck@arcor.de>
List-Id: linux-raid.ids

--Sig_/ZeeMu+oe08ba7VJo==l9TUM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Jul 2013 14:49:20 -0400 Joe Lawrence <joe.lawrence@stratus.com>
wrote:

> Hi Neil, Martin,
>=20
> While testing patches to fix RAID1 repair GPF crash w/3.10-rc7
> ( http://thread.gmane.org/gmane.linux.raid/43351 ), I encountered disk
> corruption when repeatedly failing, removing, and adding MD RAID1
> component disks to their array.  The RAID1 was created with an internal
> write bitmap and the test was run against alternating disks in the
> set.  I bisected this behavior back to commit 7ceb17e8 "md: Allow
> devices to be re-added to a read-only array", specifically these lines
> of code:
>=20
> remove_and_add_spares:
>=20
> +		if (rdev->saved_raid_disk >=3D 0 && mddev->in_sync) {
> +			spin_lock_irq(&mddev->write_lock);
> +			if (mddev->in_sync)
> +				/* OK, this device, which is in_sync,
> +				 * will definitely be noticed before
> +				 * the next write, so recovery isn't
> +				 * needed.
> +				 */
> +				rdev->recovery_offset =3D mddev->recovery_cp;
> +			spin_unlock_irq(&mddev->write_lock);
> +		}
> +		if (mddev->ro && rdev->recovery_offset !=3D MaxSector)
> +			/* not safe to add this disk now */
> +			continue;
>=20
> when I #ifdef 0 these lines out, leaving rdev->recovery_offset =3D 0,
> then my tests run without incident.
>=20
> If there is any instrumentation I can apply to remove_and_add_spares
> I'll be happy to gather more data.  I'll send an attached copy of
> my test programs in a reply so this mail doesn't get bounced by
> any spam filters.
>=20
>

Thanks for the report Joe.

That code has problems.

If the array has a bitmap, then 'saved_raid_disk >=3D 0' means that the dev=
ice
is fairly close, but the bitmap based resync is required first.  This code
skips that.

If the array does not have a bitmap, then 'saved_raid_disk >=3D 0' means th=
at
this device was exactly right for this slot before, but there is no locking
to prevent updates going to the array between then super_1_validate checked
the event count, and when remove_and_add_spares tried to add it.

I suspect I should  just rip that code out and go back to the drawing board.

NeilBrown

--Sig_/ZeeMu+oe08ba7VJo==l9TUM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeYjDjnsnt1WYoG5AQKNfQ/+I7LESglpppIcQ/0uqnMqyLnDIyFOVFfr
5S6UrbGo9YTTerFN7mcyPWkNIicDFoaJa70jDUGdwe0oUYO29Q+rjImTcS17tqPr
M22UwojCO6D9R8/JCgLAQVlw0f2c/aRj+yPX0352kJAD71s7r3WaL1krJU2iifbG
R7k9Arlp6E2pNRdWXBav2EF5fCCCM1KBTtHEdOqAZjw+M9QgKAdvGDsTVy4D7g2d
e++BQ2yZ2UsR1R0EeV0aGfs03dvY+IJcnkZMXA6dtApwqJJIZ9aJ3yL4Cm5CkKHq
7/3zaJ1Ck5KrQyjfg5W1OxkjepShKrLjbQ9Ebhz/mU5EWBouxwEQacDYarIiFw5S
YaTIDpU+Ud/kX3OlE40zvbFlzq1/seNKfLxe+W+J4pvwwuRpLOhgL7Uh7AfGhXUU
cmht17nr9rmebNPtpvdK4cVMqj/GQJDqiy1C1dg2VWZZ7mw7r+HrRBgDy7hp00Fx
i21uoNbd0c1UbkV7giQgmT1xdSj3WvBRItIfcBu3x7VCSJrErj96yZnXnrIIuDOa
Ji4C213g8oFmeoWRIz8dQ9BFPfrL1aa/3CbQYB7Q8grzm4APA6eIkb9VpSs34Kat
90XZHap0fgJ/h/ft4YhALTC7bkftktqMmksBoom1hlREW9AHOOLNxn0i8LAAFSps
Dzyjsaf8dmU=
=sSXQ
-----END PGP SIGNATURE-----

--Sig_/ZeeMu+oe08ba7VJo==l9TUM--
