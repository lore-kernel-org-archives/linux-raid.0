From: NeilBrown <neilb@suse.com>
Subject: Re: RAID boot documentation
Date: Wed, 02 Nov 2016 17:29:04 +1100
Message-ID: <87funaqtsf.fsf@notabene.neil.brown.name>
References: <CAFx4rwS4xWDcRbWpnq__zTw5FqXA1SUNW1bJgWpxWotJiRKzdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwS4xWDcRbWpnq__zTw5FqXA1SUNW1bJgWpxWotJiRKzdA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Nov 02 2016, Doug Dumitru wrote:

> Does anyone have any documentation on when a non-root RAID device
> mounts and how this is triggered?
>
> I have dug around looking for calls to 'mdadm' and or references to
> mdadm.conf to read the array details, but am not finding the obvious
> things.  Then again, the new boot services still confuses me.
>

This depends on what the distro you are using chooses to implement.

If your distro that uses systemd and uses the udev rules and unit files
that are distrubuted with upstream mdadm, then:

When a device is discovered that contains raid metadata, udev will run
  mdadm --incremental --export /dev/whatever
(or similar)

See /usr/lib/udev/rules.d/64-md-raid-assembly.rules for details.

Once this has happened for all devices in an array, the array will be
started by mdadm.

If mdadm notices that the array *could* be started if needed, but that
it still expects more devices to appear, it reports
    MD_STARTED=*unsafe*
and the udev rules file uses this to trigger a message to systemd to
start "mdadm-last-resort@devicename.timer"
This sets a timer.  When the timer fires, the array is started even
though some devices might be missing.
If the array gets started before that (because the missing devices
appeared) the timer is canceled.

When an md array (or any other device) appear, some other udev handling,
possibly involving udisks, might cause the filesystem to be mounted.
That is completely outside of the control of mdadm.  mdadm just
assembles the device.

Hope that helps.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYGYexAAoJEDnsnt1WYoG5j/sQAKq+CAPCFi159SISNYegT5ZJ
rTw6KEku+Y+aBoeYJ8pRUAFwt5L2Kd1rBtejgAW/lCU0Urxdt2+2VVrDExNHBV2n
zsyfTW3HuGbBbBxEvvwOJyPBJgt7+c8rqFhApx2nW7QVfAz0KGCwKMhV4MlSE+8D
QRmdqCXHyQwQ8oQSu29fF2NyUrEMzJYpiAzOQ45lVSA9UgimMyhTMa0VwgyvfZWX
KGLy29qKhit2Gv18xNt3kny7nxsayOCng7jdEiIk4oNY1u1HVPImPrN2c9FofW9c
6wFBpQDJ3Q7j0r26kQApK/ZXuFuaDZE8TeuW3v+1rvO2xuhx2W26cJJF6LJy+WhB
kGm/SPCp9HPcBtHyDh8uJxiZkvhTZ1CZNqMUzSOEP6sIbQgLK5QAuDgiKNF1SP+p
UnuKl4SFT39/ohawDmMpoSuB59mibnYryPuHKm+9lkJkKlY9rsjqVWsUBLS2NgWP
wbJhDGWFnWJgM+LLemMegXFbbXlV+ocDXfRcateMzk1Tl0z0gEhOQBKnMcQkiyYx
U81C8R2q8vqvjAmu3069iZUSgzq7nI9DZW27yFS019vox69Wft6t4nNYQoOg53G8
PTeuHBC96CuveRO9r6OZHbjWJpfOgzo7etu77leT+Ge4vyiwoLHSsne5//8ANIZf
sd0tiawAvDKqS6ro0Sxe
=3FRy
-----END PGP SIGNATURE-----
--=-=-=--
