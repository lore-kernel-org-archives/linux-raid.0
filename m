From: NeilBrown <neilb@suse.de>
Subject: Re: md raid performance with 3-18-rc3
Date: Wed, 3 Dec 2014 17:21:01 +1100
Message-ID: <20141203172101.17859aee@notabene.brown>
References: <5472E7DE.5070702@caviumnetworks.com>
	<20141125133742.0154a4d4@notabene.brown>
	<54758B3B.5080907@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/KBoI2uN/Aho.h0t9zVsdlpo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54758B3B.5080907@caviumnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Manish Awasthi <manish.awasthi@caviumnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/KBoI2uN/Aho.h0t9zVsdlpo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Nov 2014 13:41:39 +0530 Manish Awasthi
<manish.awasthi@caviumnetworks.com> wrote:

> Whatever data I have on comparison is attached, I have consolidated this=
=20
> from log files to excel. See if this helps.

raid_3_18_performance.xls shows read throughput to be consistently 20% down
on 3.18 compared to 3.6.11.

Writes are a few percent better for 4G/8G files, 20% better for 16G/32G fil=
es.
unchanged above that.
Given that you have 8G of RAM, that seems like it could be some change in
caching behaviour, and not necessarily a change in RAID behaviour.

The CPU utilization roughly follows the throughput: 40% higher when write
throughput is 20% better.
Could you check if the value of /proc/sys/vm/dirty_ratio is the same for bo=
th
tests.  That number has changed occasionally and could affect these tests.


The second file, 3SSDs-perf-2-Cores-3.18-rc1 has the "change" numbers
negative where I expected positive.. i.e. negative mean an increase.

Writes consistently have higher CPU utilisation.
Reads consistently have much lower CPU utilization.

I don't know what that means ... it might not mean anything.

Could you please run the tests between the two kernels *with* RAID.  i.e.
directly on an SSD.  That will give us a baseline for what changes are caus=
ed
by other parts of the kernel (filesystem, block layer, MM, etc).  Then we c=
an
see how much change RAID5 is contributing.

The third file, 3SSDs-perf-4Core.xls seems to show significantly reduced
throughput across the board.
CPU utilization is less (better) for writes, but worse for reads.  That is
the reverse of what the second file shows.

I might try running some tests across a set of kernel versions and see what=
 I
can come up with.

NeilBrown

--Sig_/KBoI2uN/Aho.h0t9zVsdlpo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVH6rzTnsnt1WYoG5AQK8+A//VGbcQvvYsfATDSZ75cwP8u7tdsY1Xeb5
fAykmtGZojZA8Iq8RC14NA2SzC1CbF05qB6Fgye9lDBP2h+iZWjcJsqXUlWY6uw3
UIc0hbfBAaxyfXeDqt1N/bhLKYJi2PAhy3lxPfSGiHKIz0r9q/eJl+JRwx/z3x/S
mqTpUVz8N4OhQLRHqPinD7uEW6iAGg8pE2yKEYTtlY3OTwvymtGFZR1UgvhaBFT5
Pi72ZQy5KZ/wauf7AkQaIjxwNj4SleQJ9dy4rZTvGe8LnQiM8RLQYqqCfKcokZ9q
GoTbIXkbuLDaxfNp7n/oE95PtZ/TIPVe116pXhWhzIA+7z2RYD6XD8edCBaNeA9I
EunOvrmfIl3CRMyMfDV6TI5xxIOD/vUuW+0nJ0JhTJWMfzL0pSSqGiCzjQn9Zt98
qyapowD7XtcCV0EDYpNg6h9SYgS6gHWUPjW8/MiX490P2iH3+1Zsdnmotm3CC3Ke
JET3vQrIMK6OT2WR4TS4XyfnRx3wWrmKmZLX3IkG27QVWTUrnlL7sW0xleClJ343
mc7PJHYkC0jtnhLId1XdD219g+feO51e8WO9+Uj9wS87QdcoJlk5JHWvf2HoIouV
VfV4LxnMXN5IQblZMRhvwm7wLYQ6TC4CUGc1VxzJyF7/yXIyEPCltP2Cxtljs8A7
kcByT3q8+zw=
=ssBq
-----END PGP SIGNATURE-----

--Sig_/KBoI2uN/Aho.h0t9zVsdlpo--
