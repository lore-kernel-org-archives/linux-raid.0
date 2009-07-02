From: Andre Noll <maan@systemlinux.org>
Subject: Re: RAID6 questions
Date: Thu, 2 Jul 2009 18:27:14 +0200
Message-ID: <20090702162714.GE9910@skl-net.de>
References: <2bdd5a4c0907020822s7d136681g23a4e34e13f0be8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eheScQNz3K90DVRs"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2bdd5a4c0907020822s7d136681g23a4e34e13f0be8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marek <mlf.conv@gmail.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


--eheScQNz3K90DVRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:22, Marek wrote:
> it seems that unless I'm using mdadm 3.0 which is practically
> unavailable, I'm stuck with 0.9.

Nope, mdadm-2.6 supports v1.2 superblocks.

> 3. Is it possible to use 0xDA with 0.9 superblock and omit autodetect
> with mdadm 2.6.x?

yes, unless of course you have your root partition on md and want the
kernel (rather than your initramfs scripts) to detect the md device.

> is there a safe way(without losing any data) to convert from
> autodetect + 0xFD in the future?

Yes, just change the partition types. No sane program relies on these
types anyway.

> 4. (probably a stupid question but..) Should an extended 0x05
> partition be ignored on RAID build? This is not directly related to
> mdadm, but many tutorials basically suggest to
> for i in `seq 1 x`; do mdadm --create (...) /dev/md$i /dev/sda$i
> /dev/sdb$i (...)

Of course you can not have an md device on both the extended
partition and some logical partition contained therein. I'd
recomment to stay away from the extended partition craziness whenever
possible. Especially as you are talking about to

> partition the drives into many small partitions e.g. 1TB into 20x
> 50GB,

If you are planning to have that many devices, I'd rather use LVM on top
of md which is much more flexible.

> does mdadm kick out faulty partitions or whole drives?

It kicks whatever the failing component device is, so if the md is made
=66rom partitions only, only the faulty partition would be kicked out.

> I have read several sources including some comments on slashdot that
> it's much better to split large drives into many small partitions, but
> noone clarified in detail.

Yeah, and if you use emacs rather than vi, your disks won't fail at
all. ;)

> If mdadm kicks out faulty partitions only, but leaves the remaining
> part of drive going as long as it's able to read it, would it mean
> that even if every single hdd in the array failed somewhere (for
> example due to Reallocated_Sector_Ct), mdadm would keep the healthy
> partitions of that failed drive running, thus the entire system would
> be still running in degraded mode without loss of data?

True. It's up to you to estimate the likelyhood of this scenario.
Usually, if a disk starts to fail, it will soon return errors for
the other partitions as well. Also, you should be aware of the fact
that md tries to re-write bad sectors on read-errors with (valid)
data from the remaining good drives. So md will "fix" the read error
if the drive can remap the bad sector.

> 6. Is it safe to have 20+ partitions for a RAID5,6 system?

Yes, as the number of partitions is not as critical as the number of
component devices. The latter is bounded by 26 for raid6 and v0.90
superblocks IIRC.

> Most RAID related sources state that there's a limitation on number of
> partitions one can have on SATA drives(AFAIK 16)

This limitation is not imposed by the disk, but by the type of the
partition table.

> 8. Most RAID related sources seem to deal with rather simple scenarios
> such as RAID0 or RAID1. There are only a few brief examples avaliable
> on how to build RAID5 and none for RAID6. Does anyone know of any
> recent & decent RAID6 tutorial?

At least for md, creating and using a raid5/raid6 array is not much
different than the raid0/raid1 case. If you want to understand the
algorithm behind raid6 I'd recommend to read hpa's paper [1].

Regards
Andre

[1] http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--eheScQNz3K90DVRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKTN/iWto1QDEAkw8RAmkNAKCV2LHvwQBqtDD3C6U8KiRHXLV4PwCcCx9b
7uSN8JmhZDD2eeB/gWUK/nQ=
=1ri5
-----END PGP SIGNATURE-----

--eheScQNz3K90DVRs--
