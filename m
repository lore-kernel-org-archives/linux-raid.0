From: Andre Noll <maan@systemlinux.org>
Subject: Re: Poor write performance with write-intent bitmap?
Date: Wed, 22 Apr 2009 16:21:48 +0200
Message-ID: <20090422142148.GC13280@skl-net.de>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com> <49ED096E.1000002@anonymous.org.uk> <49ED16F7.3040906@anonymous.org.uk> <4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name> <49ED2BC3.7050109@anonymous.org.uk> <87d4b5m4kf.fsf@frosties.localdomain> <49EF108D.4070605@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49EF108D.4070605@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13:41, John Robinson wrote:

> >Normal shutdown should put the raid in read-only mode as last step. At
> >least Debian does that. That way even a mounted raid will be clean
> >after reboot.
>=20
> Yes, I would have thought it should as well. But I've just looked at=20
> CentOS 5's /etc/rc.d/halt and as far as I can see it doesn't try to=20
> switch md devices to read-only.

There's no need to do that in the shutdown script as the kernel will
switch all arrays to read-only mode on halt/reboot.

Moreover, as raid arrays are automatically marked clean if no writes
are pending for some small time period, a simple "sync; sleep 1"
at the end of the shutdown script is usually enough to have a clean
array during the next boot.

An alternative way to deal with this issue is to not have a root file
system at all but to mount/link each top level directory separately.
This allows to stop all md arrays cleany.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJ7yf8Wto1QDEAkw8RAg7kAJ9JlttrKZJqKHk7GAP1Y6DnENgH1QCgoNKu
to6czP04gT0cpV8f0XTntLg=
=aTo/
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--
