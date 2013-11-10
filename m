From: NeilBrown <neilb@suse.de>
Subject: Re: Running check and e2fsck simultaneously
Date: Mon, 11 Nov 2013 07:34:28 +1100
Message-ID: <20131111073428.583b83b2@notabene.brown>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com>
	<527FCBAF.4070208@hardwarefreak.com>
	<58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com>
	<527FDBC1.4000009@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JFaWyh._GOt6RfhRpNyCPOo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <527FDBC1.4000009@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/JFaWyh._GOt6RfhRpNyCPOo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Nov 2013 13:17:21 -0600 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> Also, I see little/no value in running a scheduled mdadm check on a
> RAID1 array.  Any problems with RAID1 will be due to one of the disks
> beginning to fail in some mode, usually requiring sector relocation.

I think scrubbing has value on any RAID with redundancy.
The firmware can only relocate a sector if it reads it when it is marginal
but not yet completely lost.  If a sector is not read for a long time and
during that time the media degraded beyond recovery the firmware cannot do
anything.  But RAID1 can - it can get it from the other device.

NeilBrown

--Sig_/JFaWyh._GOt6RfhRpNyCPOo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUn/t1Dnsnt1WYoG5AQLWhw/+MPJdExUJV9HdVXDZ9K/+4FMWHlKsvHnC
1dl3qWszHOXIUhOn7WtO4u+DjJjPqmnZGHqOsPnVnimaqmFh8Jfn0Yw8bjXr7r3c
FYgjqJI3wrjmR36Bv+daVIRgvC0BPsQi6On9QEs/qKWZprfuEyojKOFjGylCpZKe
Fz6jn1k4f4iS5QZxk4eSsyL9TJeVg5jtnmY6FxeO9+9L1yqVcVobAdUOEISOU6vQ
NUcPq/atDgDpr6LMXEosKzLYmn5WZJUQ3D8hEcCzQkF59JYHc2Ig6b3k1/yaiJvO
y3197wbE38oEWds8qN4hjprZujRybI9qnjc9EvwvOoLVSU1VSPGLvMEUuNfZXbe1
/+OMC7PYSTkRmjAPLE/NvsF+jvDUZWkWiKLtoFohnubXXH29Kb8GpUuCBVAojyRO
UkdeD2WZEA/GcykYYor7adny0y47YRiBxQn9YisC/tRnbNg9pgYy/5scmA3SvKqo
VAun7Xds49HDQ0RSvCd62G3yicQPHUlPbJD8hvLYiglewivmHthfaoZhqhA/OshE
eJPYToysSNe+0fhWMzalgNwL/yykRRrKRe0s5PDAjVk3qFUAu7O40CglOzU7em6/
oH9AJ7bdifPSraZe/5vRJzKmxBl6wpNFlI1LGnV9q1CFf/SvF4YmunTCYhJA9cxM
30Fa3N6TqBw=
=nOjC
-----END PGP SIGNATURE-----

--Sig_/JFaWyh._GOt6RfhRpNyCPOo--
