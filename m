From: Bernhard Dobbels <Bernhard@Dobbels.com>
Subject: Re: New RAID-5 800GB array, wich fs ? wich stripe block size ?
Date: Mon, 19 Jul 2004 22:36:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40FC30C2.5050600@dobbels.com>
References: <40FB923D.1080903@gouny.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40FB923D.1080903@gouny.org>
To: =?ISO-8859-1?Q?Aur=E9lien_Gouny?= <aurelien@gouny.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

800 GB in one filesystem is possible, but I think it'll make life easie=
r=20
if you have multiple partitions which you can mount wherever you want.

Technically speaking, I prefer the LVM2 solution on which you can make=20
and resize partitions on the fly.

I must admit I lost my raid5 with LVM2. The cause will probably have=20
been my fault, although I don't know what I did wrong, so I suggest if=20
you have critical data, a backup on another medium is still advised.

Good luck.

Bernhard
Aur=E9lien Gouny wrote:
> Hi all,
>=20
> I have a Promise SX6000 card and i juste have bought 6x160 GB HDs tha=
t=20
> make a 800 GB RAID-5 array.
> I was wondering wich filesytem I should use (ext3/reiserfs/xfs/jfs/..=
=2E),=20
> if I should make one or more partitions and wich stripe block size to=
=20
> use knowing that:
>=20
> - it will be mainly a file-server with mp3s, divx, pictures (1 to 4MB=
=20
> each) and some files (openoffice, ...) all shared with Samba.
> - it will have a small postgresql database
>=20
> If someone need more information in order to determine the stripe blo=
ck=20
> size or else, just ask ;)
>=20
> Thanks a lot, (sorry for bad english)
> Aur=E9lien
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
