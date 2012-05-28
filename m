From: NeilBrown <neilb@suse.de>
Subject: Re: Reason for md raid 01 blksize limited to 4 KiB?
Date: Mon, 28 May 2012 14:05:05 +1000
Message-ID: <20120528140505.6eb49b26@notabene.brown>
References: <4FBA0047.5050208@profitbricks.com>
	<20120522092817.1b5946b8@notabene.brown>
	<4FBF7CAD.7000307@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Yr1l4uVldO1jvEktQb+tuJ9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBF7CAD.7000307@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Yr1l4uVldO1jvEktQb+tuJ9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 May 2012 14:35:57 +0200 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> Hi Neil,
>=20
> On 22/05/12 01:28, NeilBrown wrote:
> >=20
> > This should be fixed in linux 3.4 with commit 6b740b8d79252f13bcb7e5d3c=
1d
> >=20
>=20
> I've tested the RAID 01 with kernel 3.4 and it isn't fixed. It is even
> worse, because direct IO doesn't work any more on the raid1 device (with
> kernel 3.2 it worked).

What do you mean by "doesn't work"?  Returns errors? crashes? hangs? kills
you cat?

It works for me.

When I use 32K direct writes to a RAID1, both underlying RAID0 arrays see
64-sector writes.

(when I do normal buffered writes I see 8-sector writes which seems odd,
 but clearly md/RAID1 is allowing large writes through)

NeilBrown


>=20
> There are still 4k chunks which aren't merged in the raid0 devices below
> (blkparse -i md100 -i md200 -i md300 | less).
> Could you also check this on your setup, please?
>=20
> Cheers,
> Sebastian
>=20
>=20
> Btw. this is my test script:
>=20
> #!/bin/bash
> if [ "`lsmod | grep brd`" =3D=3D "" ]; then
>         modprobe brd rd_nr=3D4 rd_size=3D524288
> fi
> mdadm -C /dev/md100 --force --assume-clean -n 2 -l raid0 /dev/ram0 /dev/r=
am1
> mdadm -C /dev/md200 --force --assume-clean -n 2 -l raid0 /dev/ram2 /dev/r=
am3
> blktrace /dev/md100 &
> pid=3D$!
> dd if=3D/dev/zero of=3D/dev/md100 bs=3D1M oflag=3Ddirect
> kill -2 $pid
> blktrace /dev/md200 &
> pid=3D$!
> dd if=3D/dev/zero of=3D/dev/md200 bs=3D1M oflag=3Ddirect
> kill -2 $pid
> mv md100* r0_only/
> mv md200* r0_only/
>=20
> mdadm -C /dev/md300 --force --assume-clean -n 2 -l raid1 /dev/md100
> /dev/md200
> blktrace -d /dev/md100 -d /dev/md200 -d /dev/md300 -b 4096 &
> pid=3D$!
> # Kernel 3.4 doesn't support direct IO on the md300 device
> dd if=3D/dev/zero of=3D/dev/md300 bs=3D1M
> kill -2 $pid
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Yr1l4uVldO1jvEktQb+tuJ9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8L5cTnsnt1WYoG5AQJYfg//ffqhxaUlsN3Nd+dTP9ZmsdBtSlOgDgwk
15j0rHtyPnNH4FJJ/WEXQkpQf+4ljFl1lCMZALp8f7dsgwvgZn8TOGzjuHGDzSEa
LKX1ysxtuuAiRHAftq6Z6Hz0pTIg0Jg42TYnTQvwDm/zDN6gGbr9NwDurIOzkp+A
Q2r7p8uX7xtQ/DD5zlgUWsosj6b1ly3niJu0bgT4RTb7FEYGq/xEnjJbsuXKEbbG
mL0Afpevu5NhdHKbCWMEB3WQe+XgKiRE7YmIt6S0qnAZc/+vG32mgyj38HhVQZ0C
vOFMX/VJitBDsRf3hbueiHGlnQr+tCfP8gmJZubfeBlGTXPmpafhSLOVW/OMeDwi
myLaxUwYkFrOymo9AgQVQ/QkOny9ScSIdffulkuWGzaxhon+YD3gO4yTFRRrj2jK
QJZxqP36XSiAsEM8JoLoWOEJn0BkjUhHipjSeBa3b4NzgGqFLRECUEYgRiUsaSJm
GAwG1iecU0QNfcnsJ79oi3z6ntu+Hto9TYaIzETM8xDZ7xADLAMGB6orRBTUMYDa
dsUjGJJ/mlOrJeF7hYbVF93IwF9MgxxyaEnT4AHsyuWvXCbqRBYvNXT2OnOQY8eD
rqC1Lry3HdzLr1zUvoOFbhPQeFv/m7vhJRdyQIUVC0Mh6M1HAfDtFDC0vwS/vTTV
UePB4Csf0u0=
=jDRf
-----END PGP SIGNATURE-----

--Sig_/Yr1l4uVldO1jvEktQb+tuJ9--
