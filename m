From: NeilBrown <nfbrown@novell.com>
Subject: Re: Seeking advice to convert RAID5 to RAID10 adding a drive in the process
Date: Mon, 21 Dec 2015 12:44:01 +1100
Message-ID: <87a8p460f2.fsf@notabene.neil.brown.name>
References: <trinity-e29048a1-862f-4ae7-a1a2-e4e826b37f95-1450018043035@3capp-mailcom-bs10>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <trinity-e29048a1-862f-4ae7-a1a2-e4e826b37f95-1450018043035@3capp-mailcom-bs10>
Sender: linux-raid-owner@vger.kernel.org
To: Micheal Blue <mblue@gmx.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Dec 14 2015, Micheal Blue wrote:

> I have a 3 disk RAID5 currently that uses LUKS. I would like to add a new disk and covert the array to RAID10 but cannot find any walk-through of this process. I am grateful for any input from the list be it links or a personal summary.
>
>
> Below is a graphic of how my current 3 drive array is setup:
>  ---------------------------------------
> [          ext4 file system             ]
>  ---------------------------------------
> [          LUKS cryptdevice             ]
>  ---------------------------------------
> [               /dev/dm0                ]
>  ---------------------------------------
> [ /dev/sdb1 ] [ /dev/sdc1 ] [ /dev/sdd1 ]
>  ---------------------------------------


I assume that is /dev/md0, not /dev/dm0 ....

You would need to convert to RAID0 first.
Something like
  mdadm --grow /dev/md0 --level=0 --raid-disks=2
  # wait for that to complete
  mdadm --grow /dev/md0 --level=10 --raid-disks=4 --add /dev/sdd1 /dev/sde1


You should experiment first by creating some largish file (100Meg),
using losetup to make block devices /dev/loop0, /dev/loop1
... /dev/loop3

then create a raid 5 of some of those devices, creaet a LUKS and ext4 on
that, and then perform the reshape and make sure it all works as you
expect.

I just tested and it seemed to work on the kernel and mdadm that I have.

Of course, if you can create a backup - at least of the most important
files - that is always a good idea.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd1lhAAoJEDnsnt1WYoG5shgP/iO43KzAiJsnEuoQ1r+bMDwo
GR0qhZ4paBKB0y1OLvCyAAaeg8QS69lk57/McjPWP39fya7RqVGoyoxbvsCVlfZW
oy2P2SesE4EvQhuJLHDVzhxOfP0PSJ0e1+eZMfwYIBG/yIu0pfm7/qGRwbYbKjK2
rHaoP2w78nh/M3Pq5PWcOrtrBbBamlBQAonT4j6dDfb9QryLK0xYv8lZft+IyEv6
BTFxS5UbNF5gEPaDQXOlog6snqCru8kPl9itrcOIPs4LmjwEnzx06TBkf8MDO6Ar
FSi+nAcwwI1UXT05rhe40dw57j7BQrb/rT8SCfRSNCARkDB+mjNVw4m+OM4I87tA
eQuXla1T2AhgyrBCuItcyQzWeKsuHFxdmjWKWPE5ae1ggK+wfd+O85QNNFZYgJEL
+poCg0w1e+YTHWC25rnG3vE57S3yNffeEzm1QQsUdkhPFicS9nNbaXEjVizfSEVH
8PLkHvuwLHZsVLTSkK7HQ5K5L0ZqncB1CUCE+amozY7lacQ/P0m3k9tEpIOHvIeP
bXyo95WrjKt8o+UdWtiwDglhoIt/+aZRP6N698FAX9X5D/A9nOjBch1s0D3sxrY/
Nbt09dnsrC9ZaqLt5CWD7b19nrysfS8/1FTefdVdnYKsWW2WD24vk1gODoUmhNQm
gSZqwB8VpU+TugbK59k0
=c3Bp
-----END PGP SIGNATURE-----
--=-=-=--
