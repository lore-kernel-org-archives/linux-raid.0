From: NeilBrown <neilb@suse.com>
Subject: Re: Bitmap in RAM?
Date: Fri, 28 Oct 2016 16:58:35 +1100
Message-ID: <87twbxrp4k.fsf@notabene.neil.brown.name>
References: <57F8EC82.9010804@yandex.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57F8EC82.9010804@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 08 2016, Dark Penguin wrote:

> After researching write-intent bitmaps for a while, my understanding is=20
> that they are used only to speed up "re-adding" drives by avoiding a=20
> full resync, and to enable --write-mostly --write-behind. However, it=20

This is not correct.  Speeding up re-adding is certainly one benefit.
The other benefit is speeding up resync after a system crash.


> does introduce some pretty heavy load on whatever device it's on,=20
> especially if it's an internal bitmap, because the head would have to=20
> fly all the way to the superblock twice per each write. If it's an=20
> external bitmap, then the device it's on would be too busy just serving=20
> it to do anything else.

It doesn't update the bitmap immediately before and after every write.
Writes are batched, and the bitmap is updated once before each batch of
writes.
There does need to be another update to record that the write has
completed, but that is delayed and usually merged with the update at the
start of the next batch of writes.
So the bitmap is usually updated once per batch of writes.


>
> So if I were to place it on a tmpfs, I could eliminate this problem only=
=20
> at the expense of being unable to re-add drives after a reboot, right?..=
=20
> I've read somewhere that bitmaps only work correctly on ext2 or ext3=20
> filesystems, but that probably means that it's not a good idea to put it=
=20
> on a filesystem with delayed allocation like ext4 of zfs, otherwise I=20
> don't understand why - and so I don't know if there would be any problem=
=20
> with it running on tmpfs. Is there?..

You could create a ramdisk, create an ext2 filesystem on that, and put
the bitmap file there.

It probably would make sense to support in-memory bitmaps which never
get written to disk.  It would be fairly easy to do, and would allow
expedited re-add.  I just hasn't been done.
(patches welcome :-)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYEukLAAoJEDnsnt1WYoG5mZMP/3PYwVCh9hSkzb8fE0+d38Gd
Pfr2pJoFnGRgJJG68yhnLnvZ8+ul610U/9WxaDedjD6vZsM68h0+wRPgAXjA3vXe
TfEhncHC5VVRR6k2272qdGuVHXfUI4yPWHFtdge48hUEcmjxWLCwzkMwGmo6ogYt
MoVa6FMvmYDRCKoVtwNNi+vaCEnbFO/JcnF7VRVheIRB4mQf0vB0BAIpn7qbqlDI
rNlzdqhYJFH37IUdfar3X0A3ABNYD2j+A6TQKCu5fCVQr90YM8UjLC4vqO7IT9Tb
qxoFs1Hb4XhtXPBy9xg06bQL6Mkt0haozOmWNDPkhCrx7cCOO9zATnUSWBURvZLk
C4ufLfnoZoXTb6NwTdDTCZlJW0DzFZUIVZB02RhTXWVwKno9AVGm4I9p2OE+KI0U
rEfjLQjZGBZizecdrBU4UjcEFfYxz5gLQaW8lzC04ySUrHfswvGPwVLZFNQrRE4q
dKnd8wYOnMp8si2NrVAR/TAHGEtE5hD2u7wxGyEX4Wt8eKhDFP2kA+kDcd7CBRdN
+DL8J+ruiVJ7s3FE0/Kvh1UM+eQ+b92AzhK9kQTcAsz5xhA6ViFzAAjDvDZcXwAb
m58oA9IY/hks7GCYMRqs7vIc/01MGn19PR4rMhtp4KrzU/BDJxuQVSYrvybuts+e
Ygn2pQ599tUQoaqqOLaP
=dzKa
-----END PGP SIGNATURE-----
--=-=-=--
