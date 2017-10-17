From: NeilBrown <neilb@suse.com>
Subject: Re: Wiki, raid 10, and my new system :-)
Date: Tue, 17 Oct 2017 11:33:20 +1100
Message-ID: <87y3oak3zj.fsf@notabene.neil.brown.name>
References: <59E4BA29.4050907@youngman.org.uk> <e3ee3a5d-a6b0-49aa-1949-18a248e1397f@thelounge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e3ee3a5d-a6b0-49aa-1949-18a248e1397f@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 16 2017, Reindl Harald wrote:

> Am 16.10.2017 um 15:54 schrieb Wols Lists:
>> Raid 10 is a complicated subject what with near and far, and whether it
>> will grow, etc etc.
>>=20
>> I'm planning to raid-10 my swap partition, and while it doesn't matter
>> in the slightest because destroying and recreating will be no hassle for
>> swap, I'd like to understand what's going on.
>>=20
>> If I remember correctly, there was a thread a little while back on
>> growing a raid-10? And you can't (for certain values of "can't" :-) do i=
t?
>>=20
>> Where's the best place to find info about near, far and offset layouts?
>
> http://xmodulo.com/setup-raid10-linux.html

This patch has some good stuff, but

  Chunk Size, as per the Linux RAID wiki, is the smallest unit of data
  that can be written to the devices

I wonder where the Linux RAID wiki say that.  It is wrong.
The smallest unit of data that can be written to the devices is the
block size, which is hardware dependant and typically 512bytes or 4K.
This is not the same as the chunk size.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnlT9IACgkQOeye3VZi
gbkdKw//Yi+4pMA20kmm/QvKNOsz7DnZbuLZqNOqeldIJuI0/oF2L1kmfAi0n/Jj
M/CBC8IibvyqwJYYoT8e3QnOyd2QFUsn1NTIzLml4ODLaHvCDyUtOYkBFscsf4/r
LdlZFRWbiuPnSNVxmU6n+1w0+EWHwh6r2ENQBZv4apnoJXhUXnXOD1wcmrOUK6ts
8w0eKTRXmvfIregp+lbjjD5067i5xIsQPEasVwxOlfiEwNsB/73wSbgbBn5idPUG
rDMb6tqZEso6sGiqS66aBi6zhd3FsFSdh+7om3hM+Wn7svmOuiujpAb4H/WdWQ1g
CBDQw1QaihdbxVMShhTfBKFIsSbO2uk/gwkqZ7Li1DAAfY/9GqWS6SzLv+4FPqI6
Li/CtJ4yTAGdO7hVmPV8GUf4uV96xsf6H46c7nmBd6AKou3Bd8v1nxFMeoshy3e+
zWxmCs+C2zVoEvKodwourexuNp3h18fWGGQaViOoWviZvD4YwHufH/q3v0QUJAfM
V7LRfYSBp8JKsh55ulRuH2x2x6o45HUiPzh1WvV+k9ODpnvGUzVg2jlmWm2C57jv
/KGlacHQpqCrBB1Pcnn/kLLRACJouhhEoVySu9zOinAW027Jo6yKJcrwwoqZD9XU
5rt1Eciyg4hdrWLsUYtQU9kY4y6NY6rm2/VLNrEgkA7TQznu0V8=
=uZ2o
-----END PGP SIGNATURE-----
--=-=-=--
