From: NeilBrown <neilb@suse.de>
Subject: Re: RAID showing all devices as spares after partial unplug
Date: Mon, 19 Sep 2011 09:08:31 +1000
Message-ID: <20110919090831.6464a1eb@notabene.brown>
References: <CAB=7dhk0AV1dKL2cngt1eZXJwCVrfixfLE5z=J1i-7tqdL-6QA@mail.gmail.com>
	<CAB=7dhn6+QDrYReDcxTViqe6rxgkxaHeWNQ7PCUq3S3F-Qgyqg@mail.gmail.com>
	<CAB=7dhmFQ=Rtagj2j_22cnoS0A2yoKvJgaTM+ZiqDBqhPRooDQ@mail.gmail.com>
	<20110918011749.98312581F7A@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XGcfVYAXExkMQdzrkaNkyZ/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110918011749.98312581F7A@mail.futurelabusa.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Schatzman <james.schatzman@futurelabusa.com>
Cc: Mike Hartman <mike@hartmanipulation.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/XGcfVYAXExkMQdzrkaNkyZ/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 17 Sep 2011 19:16:50 -0600 Jim Schatzman
<james.schatzman@futurelabusa.com> wrote:

> Mike-
>=20
> I have seen very similar problems. I regret that electronics engineers ca=
nnot design more secure connectors. eSata connector are terrible - they com=
e loose at the slightest tug. For this reason, I am gradually abandoning eS=
ata enclosures and going to internal drives only. Fortunately, there are so=
me inexpensive RAID chassis available now.
>=20
> I tried the same thing as you. I removed the array(s) from mdadm.conf and=
 I wrote a script for "/etc/cron.reboot" which assembles the array, "no-deg=
raded". Doing this seems to minimize the damage caused by drives prior to a=
 reboot. However, if the drives are disconnected while Linux is up, then ei=
ther the array will stay up but some drives will become stale or the array =
will be stopped. The behavior I usually see is that all the drives that wen=
t offline now become "spare".
>=20
> It would be nice if md would just reassemble the array once all the drive=
s come back online. Unfortunately, it doesn't. I would run mdadm -E against=
 all the drives/partitions, verifying that the metadata all indicates that =
they are/were part of the expected array. At that point, you should be able=
 ro re-create the RAID. Be sure you list the drives in the correct order. O=
nce the array is going again, mount the resulting partitions RO and verify =
that the data is o.k. before going RW.

mdadm certainly can "just reassemble the array once all the drives come ...
online".

If you have udev configured to run "mdadm -I device-name" when a device
appears, then as soon as all required devices have appeared the array will =
be
started.

It would be good to have better handling of "half the devices disappeared",
particular if this is notice while trying to read or while trying to mark t=
he
array "dirty" in preparation for write.
If it happens during a real 'write' it is a bit harder to handle cleanly.

I should add that to my list :-)

NeilBrown

--Sig_/XGcfVYAXExkMQdzrkaNkyZ/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOdnnvG5fc6gV+Wb0RAucMAJ9unq/zAbSKtvobfmJvY+xLA7Sl5wCfRPr9
2iwuRZrfpSZk4OJVwjEnctg=
=Pa0Z
-----END PGP SIGNATURE-----

--Sig_/XGcfVYAXExkMQdzrkaNkyZ/--
