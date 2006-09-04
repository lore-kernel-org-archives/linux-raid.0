From: Guillaume Filion <gfk@logidac.com>
Subject: checkarray: E: no kernel support for parity checks.
Date: Mon, 4 Sep 2006 09:34:48 -0400
Message-ID: <2760ec154727cb74d5c8824eb24916a8@logidac.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-4-828545320"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-4-828545320
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Hi,

I'm not sure if this is the right place to ask this question, but a=20
Google search didn't turned out anything relevant, so I'm taking a=20
chance here.

I have my root on software raid on Debian and every night, cron is=20
sending me this error:
-----
Subject: Cron <root@ali> [ -x /usr/share/mdadm/checkarray ] &&=20
/usr/share/mdadm/checkarray --cron --all --quiet

checkarray: E: no kernel support for parity checks.
-----

Looking at the code, it looks like this is where the error is reported:
if [ -z "$(ls /sys/block/md*/md/sync_action 2>/dev/null)" ]; then
   [ $quiet -lt 2 ] && echo "$PROGNAME: E: no kernel support for parity=20=

checks." >&2
   exit 3
fi

My /sys directory is empty:
gfk@ali:~$ ls -ld /sys
drwxr-xr-x 2 root root 4096 Nov 12  2005 /sys
gfk@ali:~$ ls -l /sys
total 0

Is it normal that /sys is empty? I can't find how to populate it, if=20
someone could give me a clue... :-)

Thanks a lot,
GFK's
--=20
Guillaume Filion, ing. jr
Logidac Tech., Beaumont, Qu=E9bec, Canada - http://logidac.com/
PGP Key and more: http://guillaume.filion.org/=

--Apple-Mail-4-828545320
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: =?ISO-8859-1?Q?Ceci_est_une_signature_=E9lectronique_PGP?=
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (Darwin)

iD8DBQFE/Ct4CQALUqp8khARAjCWAJ4uP1Kv3Td2d2jq4/y38J2FrwxDvwCg5EkM
FifuYwwwvBu9ELEbpZ0zuKM=
=V/7N
-----END PGP SIGNATURE-----

--Apple-Mail-4-828545320--

