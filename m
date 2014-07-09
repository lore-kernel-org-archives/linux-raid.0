From: NeilBrown <neilb@suse.de>
Subject: Re: no automatic resync after device disconnect then reconnect
Date: Thu, 10 Jul 2014 08:58:40 +1000
Message-ID: <20140710085840.78a65722@notabene.brown>
References: <883F6A2C-C8F6-4A27-B7BF-2FB98F395592@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.e=.=bNEl8DVNjuvMiWydPR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <883F6A2C-C8F6-4A27-B7BF-2FB98F395592@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/.e=.=bNEl8DVNjuvMiWydPR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Jul 2014 16:44:27 -0600 Chris Murphy <lists@colorremedies.com>
wrote:

> This is in a VM, no data at risk.
>=20
> Two problems:
>=20
> 1. I intentionally removed one of two md raid1 member devices, boot degra=
ded succeeds, clean power off, reconnect the removed md member device, boot=
 succeeds but an automatic resync does not occur for the previously disconn=
ect md members. Maybe this is expected, I'm not sure, but I'd think a bette=
r user experience would be autoresync perhaps with a notification?

Do you?  Maybe the device was removed from the array because it is faulty.
Do you *really* want a faulty device automatically added back into your arr=
ay?

It is quite possible to set up udev rules and configure mdadm policy to do
this.  I just don't think it is a sensible default.

>=20
> 2. For the raid set with a bitmap, this command succeeds
>  # mdadm --manage /dev/md126 --re-add /dev/sdb3

Good to know.

>=20
> However, for the raid set without bitmap (seems the same otherwise, same =
metadata version), it fails:
>  # mdadm --manage /dev/md127 --re-add /dev/sdb2
> mdadm: --re-add for /dev/sdb2 to /dev/md127 is not possible

You need a bitmap to --re-add.
Without a bit map, you are just adding an unused device to an array and
"--add" is the command to use.
If you set up the mdadm policy (in mdadm.conf) suitably then
   mdadm -I /dev/sdb2

would find the add and --add it for you (I think).

NeilBrown


>

--Sig_/.e=.=bNEl8DVNjuvMiWydPR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU73JIDnsnt1WYoG5AQI8xhAAg908v/qhnSigj79QnAM4Z+WJlWlCp4uc
HpauED17DcAASESvuQlnRhGjQWFJnoTM6isNPjZGH2WFUJnGu7XSy8DeafM8YM+E
Y2iPzlax6IBr6oVimDxdTCNO+CZ8Z+/2TM8uvi7SinuxrYlVUY1AAeYmIH9EIRlw
z/d+uwC01cc1LVg0vVC1OCZ+lqRbIHhyRquGwWLiMD3ROY7nRHA+7aYtuHLKyLY2
+yjKrYD5H9F2LSeocPdWtJ4QjybFiJQQVFw3ycYlqC1tfLDnhfKuHRqlabPRP+Ng
UMkBSZIouS76ONfZirIgVapJS23o2B+lkFqOTP36TTrAaib7PFbYp+NvGKyNaJk+
H6dj3b0xBYccQIBwMUWlAUmKhZQdKlRuF+H7SC5ZOViqGhORhx0TL6LWRDtvNP8o
NW8rWv5M4BDwr4gCRfLDt9NYx0yA6MPJiNenQexGNtipQopQMgwZ+tuzDpy4MvAT
zJYl6gdx6I0MjxJm3U1SPdyO/nrTg6CjEZIoJ/YVlS48KoCPtyB4OFHgHjDbsg67
Zr8kVMEhj8ITZatxMFyjm474IBLtpSP+xQuQn3TtBwZkmpZHfhUUseESGEmGX6RT
L7xNDUq6tPH09fsKr7Bwheh221kT6Kf8CExcy4J0yDNcTfyHJNL5xyNuF1PUzJmk
oSPcpSA0GWw=
=X825
-----END PGP SIGNATURE-----

--Sig_/.e=.=bNEl8DVNjuvMiWydPR--
