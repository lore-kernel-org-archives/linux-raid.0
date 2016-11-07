From: NeilBrown <neilb@suse.com>
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl can't be used?
Date: Mon, 07 Nov 2016 11:16:56 +1100
Message-ID: <87lgwwnnyf.fsf@notabene.neil.brown.name>
References: <20161030093337.GA3627@metamorpher.de> <20161030153857.GB28648@merlins.org> <20161030161929.GA5582@metamorpher.de> <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org> <20161030171234.GD28648@merlins.org> <20161030171654.GE28648@merlins.org> <20161104181808.lplrtmafwlub3ck4@merlins.org> <90cf5c8f-fcd3-d510-7f6e-6be6ade3969f@turmel.org> <20161104185040.yrznk3j4rvtwsxbk@merlins.org> <20161104235917.2d6d0fcc@natsu> <20161104195127.ymenm7ezmhscbzn6@merlins.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161104195127.ymenm7ezmhscbzn6@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, Roman Mamedov <rm@romanrm.net>
Cc: Phil Turmel <philip@turmel.org>, Neil Brown <neilb@suse.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 05 2016, Marc MERLIN wrote:
>
> What's interesting is that it started exactly at 50%, which is also
> likely where my reads were failing.
>
> myth:/sys/block/md5/md# echo repair > sync_action=20
>
> md5 : active raid5 sdg1[0] sdd1[5] sde1[3] sdf1[2] sdh1[6]
>       15627542528 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5]=
 [UUUUU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>..........]  resync =3D 50.0% (1953=
925916/3906885632) finish=3D1899.1min speed=3D17138K/sec
>       bitmap: 0/30 pages [0KB], 65536KB chunk

Yep, that is weird.

You can cause that to happen by e.g
   echo 7813771264 > /sys/block/md5/md/sync_min

but you are unlikely to have done that deliberately.


>
> That said, as this resync is processing, I'd think/hope it would move
> the error forward, but it does not seem to:
> myth:/sys/block/md5/md# dd if=3D/dev/md5 of=3D/dev/null bs=3D1GiB skip=3D=
8190
> dd: reading `/dev/md5': Invalid argument
> 2+0 records in
> 2+0 records out
> 2147483648 bytes (2.1 GB) copied, 27.8491 s, 77.1 MB/s

EINVAL from a read() system call is surprising in this context.....

do_generic_file_read can return it:
	if (unlikely(*ppos >=3D inode->i_sb->s_maxbytes))
		return -EINVAL;

s_maxbytes will be MAX_LFS_FILESIZE which, on a 32bit system, is

#define MAX_LFS_FILESIZE        (((loff_t)PAGE_SIZE << (BITS_PER_LONG-1))-1)

That is 2^(12+31) or 2^43 or 8TB.

Is this a 32bit system you are using?  Such systems can only support
buffered IO up to 8TB.  If you use iflags=3Ddirect to avoid buffering, you
should get access to the whole device.

If this is a 64bit system, then the problem must be elsewhere.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYH8f4AAoJEDnsnt1WYoG5EyoP/10mbJNy2xzpvUhNZU0Yc5+M
WzZwN+OOFJZnq/raPRxgJ3XhlLK9D5qWeFHNKdibnMdMnPqi4aA0R0nksYjt6Lrh
LiYkk4udc/fltZPGWUnDunFvvaa7ZXhmv7sod2wHmJXe9MN01HjiuwKhDVHYPvTS
8PRjVA6ORATuzrWyOZABk/6yGNCACtIc5fmXX/kLN+1JkgEgqXmKM3jngBg/lfu+
dNqAsV63GorzxFYv7IjoS24IDuL4QPGb66X6icwHVTWJwVF2yLqP5/1QY12Ki6Mf
uBuF+3XS5CSM9gMOkWbB24zWYqYxp0s3MGLGuxRMDcOvkqo1ly1R4lK1SUaJuM8g
hm9n5kCw5Q930SxfJxSgdjZgECkliajZOEt237IEy51GCc2AfJajqC+o2OkXlOFf
W2hDXn9583tabhXaxK/soXrtFfKoAKBBY8CoYyIJuQ2BBEUeqVU1l9z+f5v7LODW
TZf4woNQ65hRKZGU70MXo6/e6giwn0J3BB/QuyRcQV/8nE8UBoeb+9LQ8pPIXNel
QitsdhyArRXWXNwin6nF/ZbM0k+8bxfSgfjPGoYbzqfUs4NEWp+9jMdP2PqbBICk
GaYpsbjHAvYVPDjjkbksLRc/7g+p5dTn9BmiCBZmMtclLY9hQqRpF3UGcgRrvblF
b6GRpPLBY6b5Vkihm3DT
=YcmN
-----END PGP SIGNATURE-----
--=-=-=--
