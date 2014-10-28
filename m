From: NeilBrown <neilb@suse.de>
Subject: Re: Help with raid1 to raid5 reshape after crash
Date: Wed, 29 Oct 2014 09:24:48 +1100
Message-ID: <20141029092448.368fbfeb@notabene.brown>
References: <001001cfefe3$a82538a0$f86fa9e0$@csy.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/2YSKkCqXJT.eADt+Ibbe++5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001001cfefe3$a82538a0$f86fa9e0$@csy.ca>
Sender: linux-raid-owner@vger.kernel.org
To: shane-kernel@csy.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2YSKkCqXJT.eADt+Ibbe++5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Oct 2014 16:38:40 -0700 <shane-kernel@csy.ca> wrote:

> Hello all,
>=20
> I was converting from a 2 disk raid1 array to a 4 disk raid5 (3+1s) in pr=
eparation to convert to a four disk raid6. I added the two additional compo=
nent devices and did a:
> Mdadm --grow /dev/md1 --level 5 --raid-devices 3

I guess you mean "to a 3 disk raid5 (2+1s)" ...


> And off it went. I had a power failure a good ways in and now when the sy=
stem boots, it runs the array, attempts to restart the reshape then disk IO=
 locks up hard.
>=20
> I figure it is disk IO rather than a complete system lockup as I have abo=
ut 10 seconds of interactive shell before it locks. If I enter a dmesg comm=
and then that command will succeed. After the lockup, subsequent dmesg comm=
ands succeed (dmesg is in cache) but another command such as ls will lock u=
p. Cat /proc/mdstat shows the reshape in progress but it doesn't actually p=
rogress beyond the point at which the system locks.
>=20
> Booting from a USB stick, I tried:
> Mdadm --assemble --readonly
> But that too hangs the system.
>=20
> Do I have any recourse beyond just recreating the array and restoring fro=
m backup? Kernel is 3.16.

Probably it can be fixed...

Can you include the output of "mdadm -D" instead of just mentioning the
command :-)
Also "mdadm --examine" of each device.
And "mdadm --version".

And
   cat /proc/PID/stack
for and PID which is in "D" state in 'ps'.

NeilBrown

--Sig_/2YSKkCqXJT.eADt+Ibbe++5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFAXsDnsnt1WYoG5AQLfLhAAixWcBVEE1kaEJx8x9r7M/+LSOJl5rVNU
JIt+u0Vn87cN97O3WweqiJU0pS4Kk6He95Dd/Het+IM5+CcWGfOe+DMyYQb06249
PbURzWMSCJXSZFv78axMAMSjkDjcpvhZnpQBamMTFsNp2+nU9yLiuiDnkx0LjPDL
H/IhHYyg7IN0P9AYHcvARy8KnJtqEPaDJtuHHzgySaTYVoeCK7ZZ3UcVPdQAz3Jd
+Y1ILPXuBzQuimuzdJ/c2zi1hizVdW7CW5s5wqVdjUjGsM0Ug4d3ag5CRCkTtMV5
LxISdkPckE7XiKVbVqlsacRmELgqM3LIUjQ/56f4cqRhLDpO1oeKfKAnXPXMySyj
ffO3zLnfd+gIOivMuTGt7k3ZPhJ7XxYcwt2ACznitL9GwTItQJFsy7lpPvpgWlpQ
ephRdTOt+YJtyZyLhHjgz0eVVyTiatCOZzkYw1hkAS3WaBQ4cV1AQJQYj8vG9Zoo
jNwlFteha+v44rS357f7d2VKO3/XK9o4VFiPqhRznR0C1QklluLnkJhAwRN8LHMk
dIrRg0JjEvArUzZQCmETuDuHna83z10My6/GkSi6DizsLUQfhWtRZkN9+M+eNzxM
iKQdQgYlZoorrmx1gx6CSpkEX5psw3yBjgGE3j3njIVTsST84DOmHM+ZU12RCT04
U8tsMs2jKO0=
=9Bli
-----END PGP SIGNATURE-----

--Sig_/2YSKkCqXJT.eADt+Ibbe++5--
