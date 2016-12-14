From: NeilBrown <neilb@suse.com>
Subject: Re: (user) Help needed: mdadm seems to constantly touch my disks
Date: Wed, 14 Dec 2016 12:15:00 +1100
Message-ID: <871sxbz4yz.fsf@notabene.neil.brown.name>
References: <CAJ=9zicFM+wOUhpdX1XEVm+y2gYoW3r2aTRj6gAcEkypxJULmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ=9zicFM+wOUhpdX1XEVm+y2gYoW3r2aTRj6gAcEkypxJULmA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jure =?utf-8?Q?Erzno=C5=BEnik?= <jure.erznoznik@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13 2016, Jure Erzno=C5=BEnik wrote:

> First of all, I apologise if this mail list is not intended for layman
> help, but this is what I am and I couldn't get an explanation
> elsewhere.
>
> My problem is that (as it seems) mdadm is touching HDD superblocks
> once per second, once at address 8 (sectors), next at address 16.
> Total traffic is kilobytes per second, writes only, no other
> detectable traffic.
>
> I have detailed the problem here:
> http://unix.stackexchange.com/questions/329477/
>
> Shortened:
> kubuntu 16.10 4.8.0-30-generic #32, mdadm v3.4 2016-01-28
> My configuration: 4 spinning platters (/dev/sd[cdef]) assembled into a
> raid5 array, then bcache set to cache (hopefully) everything
> (cache_mode =3D writeback, sequential_cutoff =3D 0). On top of bcache
> volume I have set up lvm.
>
> * iostat shows traffic on sd[cdef] and md0
> * iotop shows no traffic
> * iosnoop shows COMM=3D[idle, md0_raid5, kworker] as processes working
> on the disk. Blocks reported are 8, 16 (data size a few KB) and
> 18446744073709500000 (data size 0). That last one must be some virtual
> thingie as the disks are nowhere near that large.
> * enabling block_dump shows md0_raid5 process writing to block 8 (1
> sectors) and 16 (8 sectors)
>
> This touching is caused by any write into the array and goes on for
> quite a while after the write has been done (a couple of hours for
> 60GB of writes). When services actually work with the array, this
> becomes pretty much constant.
>
> What am I observing and is there any way of stopping it?

Start with the uppermost layer which has I/O that you cannot explain.
Presumably that is md0.
Run 'blktrace' on that device for a little while, then 'blkparse' to
look at the results.

 blktrace -w 10 md0
 blkparse *blktrace*

It will give the name of the process that initiated the request in [] at
the end of some lines.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhQnRQACgkQOeye3VZi
gbnA0w/9EfKQvxhYrCWDUY06WSoHJQLHvXNJc7qDDoD+S76Q8AJ90RBwE4oQvyym
5qrZmmZC6YNt0wT0CVJGehRrN/J42iagMq5u80Meqt00yveup4r1tcLtMD19RHF8
UyoDlcCG93vvuf4mPYeM/OjCQV0R/imDqX2GzspChZ30pvYis9GDFfJmstea+BGS
ZJEJWQulaH294Jj4EG/6hVcjdkiuyeemdSGsiHRbw4Ti0GfmZREKNgl8xtmlWlUv
EB9lQ5D+MGcUe+7wYGzS3bnl/87berFUJ5cUUZW7pbtp8JyvSKSeDjU70NxfcuUd
JAnyRnnfSibwyo3NR1+xGIBIMYcnwPuydLqScPkbEZv3jf8s6l/RmwsiQeoyiFPX
iB1B0vEd0DyIde3WeT4FlJsOLOowgmDlMQWM/SfIYzYf74YA7vT7VBihrnPaRxKS
x13RMI6XL1lGvXybp5QXDgtR0u12jZDfkRtXZw+OrgAHhZyW2cU8VIbjrrlbrLgU
OYdWzDTmwn//piiM4id7DxvCbfVTJ0jLpi3zMKQVOdEFApnAnLBU8n/gtqnD0p8b
KgljzioBkAveJBJJRE1m66sUfAYr3P+QUUmZpLqmFonJpeKDET+yPmJ0wFrTi0Qr
9LT5hAD9cFko4v/zlBAFyOc9y1OlnaRZ6drYbPlywaxsqPyTsCw=
=J1mX
-----END PGP SIGNATURE-----
--=-=-=--
