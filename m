From: NeilBrown <neilb@suse.de>
Subject: Re: Backup file size when migrating from raid5 to raid6?
Date: Sun, 6 May 2012 21:00:28 +1000
Message-ID: <20120506210028.6212b2f8@notabene.brown>
References: <CAH-e9vLTY2eo0p3ud5FaWNe_2f8hej0aitFuu8K0M1RZdObiXQ@mail.gmail.com>
	<CAH-e9vLiK6=HmDjM=Ub7p_Lxrp_L0x1bkAa2oP=ykajqvtkfDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XR0CbIxscGBbf=GNKbG9BZx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH-e9vLiK6=HmDjM=Ub7p_Lxrp_L0x1bkAa2oP=ykajqvtkfDQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Gar=F0ar?= Arnarsson <gardar@giraffi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/XR0CbIxscGBbf=GNKbG9BZx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 6 May 2012 10:17:52 +0000 Gar=C3=B0ar Arnarsson <gardar@giraffi.net=
> wrote:

> My raid5 array has gotten a bit big, it's containing total 10 drives
> right now (I started out with 3 drives). So I am going to convert it
> to raid6 before it gets any bigger.
>=20
> I am doing a test-run on a virtual machine with virtual drives to see
> that everything works flawlessly.
>=20
> When I tried to convert the array to raid6 I got a error message about
> a missing backup-file
>=20
> mdadm --grow /dev/md0 --raid-devices=3D5 --level=3D6
>=20
> mdadm level of /dev/md0 changed to raid6
> mdadm: /dev/md0: Cannot grow - need backup-file
> mdadm: aborting level change
>=20
> I added the backup file and was able to convert the array successfully
> after that.
>=20
> My question is, how big is this backup file going to be? My real raid
> array consists of 2tb drives, will the backup file be as big as one
> drive in the array, or will it just be few megabytes or gigabytes?
> I'm asking because I'm wondering if I need to buy an extra hdd for the
> backup file or if the backup file can just be on my OS hdd that has
> around 100gb free.

The backup file is a few megabytes. Around 16MB I think.

However if you are likely to add another device in the not too distant futu=
re
you can save yourself a bit of time.

If you

 mdadm --grow /dev/md0 --level=3D6 --layout=3Dpreserve

It will just make the new few a 'Q-block' device, containing the extra RAID6
'parity' block for each stripe.  This doesn't require any reshape or or any
backup file and is a lot faster.  All it requires is a normal recovery
operation.

Then when you later add another device you can

  mdadm --grow /dev/md0 --raid-devices=3DN+1 --layout=3Dnormalise

This will convert from the Q-on-the-last-device layout to a more normal
rotated-P-and-Q layout at the same time as adding extra space.

NeilBrown

--Sig_/XR0CbIxscGBbf=GNKbG9BZx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6ZZzDnsnt1WYoG5AQKPRBAAqr3OKSzlOtSlTFgvg4oD+T5sHhvlqVwH
0ujgKz9uKiq2zBz2S8+OmkbatAbPzxVQsLs677SY0a1WBuNfdUIlslqcgkk5x6dP
HDpxRvyykvBINv4WGGP5/kQe+qCTo3UZcMxgEMRGCuhbTVIq79tDWXw6a9fADH3u
Cyi5dfK/xjpPihWkMVNl3mAIBxdzoFBD30ZND0b9YOibRxJ2MAhq9tpysGkCAh0N
saa+gK6lMpyj4iw1LijlHlSS0fszZHvSRQ7nXIWWjuYTMUH45vQdAvAOditEmrUC
kkBti7n3b1t8tuPQHIDhR0ApNQ+ZY4qIpYglhMY9u71gZKmy6ub7xbbMboVgmWS8
WasUjWCfp/kdwBimYRneIqj/p8csF4rEkNLmsyBNjrppqxNKnYEizzeCUSmUTv43
BCZKTrZRSA0X5S3nNyuBTCfmd/4azF4AAzj2aI/LQXXMEkqOOnvqxGVxQaevukPU
gWgQaiDpTi/Z+MT2ZX9MVqq3a6YbVm6S6kWKYYamWnEZsg4ucgV+bAdJJ1kmYWVP
e7RQNlk49TOmzcquF1vEC+AVJrYMqsMWCMxjJcmwpGz43kJoCOcyWqGA9vhEadfO
qm43yaHF35VGPx1tZolZyCZRN3egwPjgZy7x/AZfQIjdBeg+afdMqyUoLLPMggvA
ZACZGCYul8Y=
=ByPd
-----END PGP SIGNATURE-----

--Sig_/XR0CbIxscGBbf=GNKbG9BZx--
