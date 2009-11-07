From: Doug Ledford <dledford@redhat.com>
Subject: Re: mismatch_cnt again
Date: Sat, 07 Nov 2009 17:57:57 -0500
Message-ID: <4AF5FB75.6030904@redhat.com>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>	<4AF5268D.60900@eyal.emu.id.au>	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com> <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com> <4AF59F19.1080409@lazy.lzy> <4AF5A245.90404@redhat.com> <4AF5F3E1.4060509@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC47BFDF02753E4B1562A9620"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF5F3E1.4060509@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC47BFDF02753E4B1562A9620
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/07/2009 05:25 PM, Eyal Lebedinsky wrote:
> Doug,
>=20
> I can only see the cron job start a check:
>     echo "check" > /sys/block/$dev/md/sync_action
> It does not wait for completion and does not report the count. Neither =
is
> the count reported to the system log.
>=20
> I replaced it with a script that does report.

Or you can updated to a later mdadm package.  The one in rawhide has a
fairly well fletched out script now.

> Eyal
>=20
> Doug Ledford wrote:
>> On 11/07/2009 11:23 AM, Piergiorgio Sartor wrote:
>>> Side note: in F11 there is this cron.weekly raid-check, but
>>> nothing is reported (per email to root) in case of mismatch.
>>> Is there any plan to add a such a facility?
>>
>> Unless you've modified the default cron behaviour, then yes something =
is
>> reported to the user on a mismatch.  The fact that the script goes fro=
m
>> being silent to echoing a warning will result in the cron job itself
>> emailing root the output of the script.
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigC47BFDF02753E4B1562A9620
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr1+3UACgkQg6WylM+/8ZTD6ACgp69OMPnbpLXAmoqFd/muuIUw
tiIAmgIVd1vZUYG4kTWh5gp7VcZYzzEs
=2RLk
-----END PGP SIGNATURE-----

--------------enigC47BFDF02753E4B1562A9620--
