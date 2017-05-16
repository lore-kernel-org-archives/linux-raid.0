From: NeilBrown <neilb@suse.com>
Subject: Re: How to delay mdadm assembly until all component drives are recognized/ready?
Date: Wed, 17 May 2017 07:25:10 +1000
Message-ID: <877f1gmr49.fsf@notabene.neil.brown.name>
References: <243ef080-c32f-f423-3a98-af70194f994b@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <243ef080-c32f-f423-3a98-af70194f994b@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, May 09 2017, Ram Ramesh wrote:

> Today, I noticed that my RAID6 md0 was assembled in degraded state with=20
> two drives in failed state after a pm-suspend and restart. Both of these=
=20
> drives were attached toSAS9211-8I controller. The other drives are=20
> attached to motherboard. I have not had this on a normal boot/reboot.=20
> Also, in this particular case, mythtv recording was going on when=20
> suspended and therefore as soon as resumed that used this md0.
>
> Upon inspection, it appears (I am not sure here) that mdadm assembled=20
> the array even before the drives were ready to be used. All I had to do=20
> was to remove and re-add them to bring the array back to "good" state. I=
=20
> am wondering if there is a way to tell mdadm to wait for all drives to=20
> be ready before assembling. Also, if there is something that I can add=20
> to resume scripts that will help, please let me know.
>
> Kernel: Linux zym 3.13.0-106-generic #153-Ubuntu SMP
> mdadm - v3.2.5 - 18th May 2012
>
> Failed drives are HGST NAS and WD Gold with less than a year of usage.=20
> So I doubt they are bad drives by any means.

This is a question that needs to be addressed by your distro.  mdadm
just does what it is told to do by init/udev/systemd scripts.

The preferred way for array startup to happen is that when udev
discovers a new device, "mdadm --incremental $DEV" is run, and mdadm
includes the device into an array as appropriate.  mdadm will not
normally activate the array until all expected devices have appeared.
After some timeout "mdadm -IRs" or "mdadm --run /dev/mdXX" can be run to
start the array even though it is degraded.

The udev-* scripts and systemd/* unit files provided with current
upstream mdadm do this, with a 30 second timeout.
If a given distro doesn't use these scripts, you need to take it up
with them.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkbbjYACgkQOeye3VZi
gbkGnQ/+JqG2A+ZWem1Yj7DNrTMR/mhahGJJddRH2snc5f9uOYhCx9rH/2NiIOZZ
Bu0m9OYI7ByigaoAS/T0/ywaSxverN+R56AfpAmqiY5V7WFZzaHh1DuiXkCJ5rLC
6xD4xL7h4vLAHEtkcU/BNTM95RHQDnPpN4R6DJQw16kEdyd7thNxiLmaNIREq3LQ
1h1OaIXlQbAkA8oROzIhYKysjrKLH1Piv4kzh4wWhi7AVym8tan/pAOlNHbVzsjU
1cSyc4uj0h8KD/HWXPzif7br1FCfOIZAkEHY4LE4UWsObhyjl0ej8dPMkE+YVn1P
/Rhc4hwWegxTUiyXaufvQ60yAI4TWu2NOtBdPoThFtAFrxK1w2vDZB3QLwX3Q7N/
7M83xPyG3h/rBsRoctqGZOyqPXojTiVBGIG4qEUmcxsBwMYoBdkkwjttJMspBKCt
rNeMhJOdyRBnqkjKocGvSInGMGw/ZyPdnZl0WINuHfAk6SsxRRXMijldzgqPETfA
XmROF6F4bqM3YutNkcmsZ2iB6yNgviCQMKr1riXcsGtHgbpWCsUAK6jxYopY6H3n
LZvhnBXX0bsO1YYQ+MVXzPmO7nVB8hGTD/zzmse9bkZpUwFKWuY58FGXilhbEh13
BXyASeWWc+69BVD/lXHx6AUHWpHJou9VXN7ngCGToHbkSG6/Ttc=
=HcaQ
-----END PGP SIGNATURE-----
--=-=-=--
