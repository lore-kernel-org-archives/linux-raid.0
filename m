From: NeilBrown <neilb@suse.com>
Subject: Re: internal write-intent bitmap is horribly slow with RAID10 over 20 drives
Date: Tue, 06 Jun 2017 13:40:14 +1000
Message-ID: <87tw3tdbs1.fsf@notabene.neil.brown.name>
References: <CAGqmV7qRh+_BXAr-qf6vUkiZyzi69E8CiX_vA92tZV2LfDxq_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qRh+_BXAr-qf6vUkiZyzi69E8CiX_vA92tZV2LfDxq_A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Jun 05 2017, CoolCold wrote:

> Hello!
> Keep testing the new box and while having not the best sync speed,
> it's not the worst thing I found.
>
> Doing FIO testing, for RAID10 over 20 10k RPM drives, I have very bad
> performance, like _45_ iops only.

...
>
>
> Output from fio with internal write-intent bitmap:
> Jobs: 1 (f=1): [w(1)] [28.3% done] [0KB/183KB/0KB /s] [0/45/0 iops]
> [eta 07m:11s]
>
> array definition:
> [root@spare-a17484327407661 rovchinnikov]# cat /proc/mdstat
> Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
> md1 : active raid10 sdx[19] sdw[18] sdv[17] sdu[16] sdt[15] sds[14]
> sdr[13] sdq[12] sdp[11] sdo[10] sdn[9] sdm[8] sdl[7] sdk[6] sdj[5]
> sdi[4] sdh[3] sdg[2] sdf[1] sde[0]
>       17580330880 blocks super 1.2 64K chunks 2 near-copies [20/20]
> [UUUUUUUUUUUUUUUUUUUU]
>       bitmap: 0/66 pages [0KB], 131072KB chunk
>
> Setting journal to be
> 1) on SSD (separate drives), shows
> Jobs: 1 (f=1): [w(1)] [5.0% done] [0KB/18783KB/0KB /s] [0/4695/0 iops]
> [eta 09m:31s]
> 2) to 'none' (disabling) shows
> Jobs: 1 (f=1): [w(1)] [14.0% done] [0KB/18504KB/0KB /s] [0/4626/0
> iops] [eta 08m:36s]

These numbers suggest that the write intent bitmap causes a 100-fold slow
down.
i.e. 45 iops instead of 4500 iops (roughly).

That is certainly more than I would expect, so maybe there is a bug.

Large RAID10 is a worst-base for bitmap updates as the bitmap is written
to all devices instead of just those devices that contain the data which
the bit corresponds to.  So every bitmap update goes to 10 device.

Your bitmap chunk size of 128M is nice and large, but making it larger
might help - maybe 1GB.

Still 100-fold ... that's a lot..

A potentially useful exercise would be to run a series of tests,
changing the number of devices in the array from 2 to 10, changing the
RAID chunk size from 64K to 64M, and changing the bitmap chunk size from
64M to 4G.
In each configuration, run the same test and record the iops.
(You don't need to wait for a resync each time, just use
--assume-clean).
Then graph all this data (or just provide the table and I'll graph it).
That might provide an insight into where to start looking for the
slowdown.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlk2JCAACgkQOeye3VZi
gblZKBAAvqx0YBVXQVKj0HYzIyDsgrB9M6eGq8U2nepVlkcBc5H0KiVEbhoxepgX
RjjTFIIoMZqrLwGFbmSoS8gX2nNK2X7Wz7uNNGvL/wWuzRDw8Q3qixQDAz4xIVZo
scGMknlrLhp7AsyOH5tvl/NFRzUF8fMkw9bzhfWIPjebnt8oJa9o/XHEXzZ6G7FM
iPNLYTXHZbNCHOl5/IUXv5v5rWl3r7LCMJKpePqck5XzjIYXG8uJpXQZRjrRm0wW
qH3JHymjBh1/DcWo7r+TXlcC5pe0Z7DsQdx5L7hujwE+oJGQpNZy8YSxwf0gXZRj
v1eMkEyn+HMS9pWccAewNc7P6DORqHgne7U/wQSv8Bhv9LvecQixCTN4aJzerm76
jdVoNzA8gmaljQ5326Rch7SzMkHgBNIT948coU0EqaXdWjQ6Cua2/6fFI/6V87+3
Ch+epDZEd/2VFK5qZQExq4wB+JvSsNZB8uSG7KLevBnuCgo72SdaGwH7J7LFvWsD
MGqwE9NAyy0Pwj4CzWKIJ2Rp6nhYVPCr408aAFBAcf0aN4g+aMOMO1ZN6prnHbEW
e+grCbY6ggu5q/mPICqOweRgyDHlaWm6TJR2XESwCmbyKWAKnUHt5DXJCXWZ/aFy
lyi6hh5W8GnmrCiuWlcpj4+sErEkpHRPHKrE24imr9OY6466aBw=
=OvtA
-----END PGP SIGNATURE-----
--=-=-=--
