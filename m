From: Doug Ledford <dledford@redhat.com>
Subject: Re: mismatch_cnt again
Date: Sat, 07 Nov 2009 11:37:25 -0500
Message-ID: <4AF5A245.90404@redhat.com>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>	<4AF5268D.60900@eyal.emu.id.au>	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com> <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com> <4AF59F19.1080409@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig800FC5AA220C315038E8FFE9"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF59F19.1080409@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig800FC5AA220C315038E8FFE9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/07/2009 11:23 AM, Piergiorgio Sartor wrote:
> Side note: in F11 there is this cron.weekly raid-check, but
> nothing is reported (per email to root) in case of mismatch.
> Is there any plan to add a such a facility?

Unless you've modified the default cron behaviour, then yes something is
reported to the user on a mismatch.  The fact that the script goes from
being silent to echoing a warning will result in the cron job itself
emailing root the output of the script.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig800FC5AA220C315038E8FFE9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr1okUACgkQg6WylM+/8ZRNIQCgsGCVnokbtlOChe9/ke9FPCQ8
zywAoKDpFqi/VFXQzVpWxD3WmTY+KvQP
=Gw+3
-----END PGP SIGNATURE-----

--------------enig800FC5AA220C315038E8FFE9--
