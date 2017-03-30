From: NeilBrown <neilb@suse.com>
Subject: Re: RAID6 rebuild oddity
Date: Thu, 30 Mar 2017 12:53:33 +1100
Message-ID: <87r31f5y3m.fsf@notabene.neil.brown.name>
References: <9eb215dd-437e-ac62-c4df-f3307d8fc4b4@fnarfbargle.com> <87zig467z3.fsf@notabene.neil.brown.name> <5584b8b1-b4f1-0d2e-cbf3-f14b4127d031@fnarfbargle.com> <87wpb7612w.fsf@notabene.neil.brown.name> <a8ad0de2-5cec-1e70-0fff-1df911a02932@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a8ad0de2-5cec-1e70-0fff-1df911a02932@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Linux-RAID <linux-raid@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 30 2017, Brad Campbell wrote:

>        [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>......]  recovery =3D =
72.0% (4222847296/5860391360)=20
> finish=3D541.6min speed=3D50382K/sec
...
>        [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>......]  recovery =3D =
73.3% (4297641980/5860391360)=20
> finish=3D284.7min speed=3D91465K/sec
>

>
> So that has significantly increased the rebuild speed, as you would expec=
t.
>

Not quite twice as fast, but close!
Everyone has been suffering with that poor speed for years and nobody
noticed until you did.  Thanks for being thorough!  And thanks for
confirming the patch.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljcZR0ACgkQOeye3VZi
gblnqA//f8yJxEiXd7t9tgusgfcre3dAs585CG/UfYuK/IR9TK0wS9VLrIt6XeXC
7uG4WuFbNq8YcPwuERX7oOnCyZtsV/MEuQMfJjmOPL6VHhS7pPimbFYDyLElBASI
2M0CylMQfCIeFt+NsD4YgxhyzPHXIPjqhlHY2y+D4GXUrKKkDnuj64dVxVlzMumY
k0M37f39V3tAnkafJaq/xgI4dGcwtEC10X5/YOjAVdw4otFil8DB3jwuhte+VR3J
5oTamWkL0RUuMjjs4fT5kPjVJS07Y7WbKxFSEqECroNUv3qqh5e7ICNArpSaPAIV
vaR/UJVDjM0jKv5ng0e95maERVqwapuJeD7Kv+SVtMQFFIONcQ631y0QKvNXGMVi
h6PlI8txfeAaQ5byt1b8BM8DlqFrd8VfLEzjhCMVVIw3zJ1KPKgDDAf3qlwuFSiI
6moDqAkqmxReGO1iFuZZ9FkKbPCAZhqEtadSRQ6EQEiYi+XBm+ADR2MS2JyS/RGi
FbHMjytWNhKKQXq8t9i+QnV/iM9CqjUSIQIpwqRUmR06YZb0TVHVrbBzAYmjfjx1
09sFLqr2eHuV6BhXDbshyGbq7Hz/rTO1a5XlzVSy0rRhJPfNQCXscnQeCxQ2D7jE
FZR4eCEVYvkPNfJ9Q8PafrzWNlpRS3r+1vgIL+Z0GHZXB1TS1Z8=
=Om38
-----END PGP SIGNATURE-----
--=-=-=--
