From: NeilBrown <neilb@suse.de>
Subject: Re: Weird problem: mdadm blocks
Date: Sun, 22 Dec 2013 22:19:14 +1100
Message-ID: <20131222221914.78630829@notabene.brown>
References: <52B6AA66.5050502@hanswkraus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qswu7E61Zg376f/nlab4jyf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52B6AA66.5050502@hanswkraus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Kraus <hans@hanswkraus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Qswu7E61Zg376f/nlab4jyf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Dec 2013 10:01:26 +0100 Hans Kraus <hans@hanswkraus.com> wrote:

> Hi,
>=20
> my backup system (running backuppc) has developed a weird problem:
> calls from command line "mdadm --detail /dev/mdX" block, for every
> existing raid on the system, and can be only terminated with ^C. This
> is true even for the newest mdadm built from git.
>=20
> "cat /proc/mdstat" blocks too. All mounted raids are working (at least
> ls <mountpoint> is), exept for one, md127 (the storage of backuppc).
> There ls is blocking and is not terminable by ^C.
>=20
> The raid structure is the following:
> md2, md3, m4	raid1 for swap, /boot, /
> md30		raid0 for short term storage
> md10, md11, md12, md13	raid0, built from 2x 2TB or 1TB + 3TB drives
> md127		raid5 built from md10, md11, md12, md13
>=20
> I recently (some 12 hours ago) added md13 again and the system was
> rebuilding from a degraded state. The file system on md127 is xfs. All
> the physical rives are OK, at least according to smartmontools.
> Webmin 1.660 reports:
> CPU load averages 	16.96 (1 min) 15.04 (5 mins) 12.67 (15 mins)
> CPU usage 		0% user, 1% kernel, 99% IO, 0% idle
>=20
> Is there any way to diagnose the problem further? I'm reluctant to
> do a reboot.

Either some process has crashed leaving an 'oops' or 'bug' message in the
kernel logs, or some process is stuck in 'D' state in 'ps'.

So:
 1/ look through kernel logs since boot (e.g. output of 'dmesg', though that
   might not be complete) for anything  unusual - there should be a stack
   trace.
 2/ if there is a process in 'D' state, find how which and get a stack trace
    of it.  Possibly by
     echo w > /proc/sysrq-trigger
   or
     cat /proc/$PID/stack
   or event
     echo t > /proc/sysrq-trigger
   (though that might create lots of output that might be hard to capture).

NeilBrown

--Sig_/Qswu7E61Zg376f/nlab4jyf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUrbKsjnsnt1WYoG5AQIoFw//e+mLCt11tbJ2Q0L0BzrX8xywV1MrS6oV
mq8pk60h/a0bpSM6IAmTBmYTEXb4+v6O8715tMNL88mEWU/VOhlLpcn0Q1kBu24L
rDOywlxc8xpW4ELdwXOBoopHw+9LWgUwkklz2Oh6VSNz42cf4V/klN0MaKwT4dtI
R2nTiPqj/BX4d1aOjmzU7jQLPEoeCvZTME6yrTSudZ20vUerY500/QHW6+jROOfr
Qcowr7yq2oZAJNwE8cQmXgljOcpguFePP864+cd1x0QS7HlXeQvTH6R1WxyUtcQH
SkcW8aTamIv9kTWceJhOdNjXDXWB+O5XGiaSn27vMdFb+X4d3oOQGNFbrAR0Kvmj
t/uyugUg4asIhRpI+TrHNIZvkcUZYHEfJfDxxBaGTYemtqtb2MTj6jQdCNWcQz2g
w7mUdF78K/bxgVv3IAMfZRNpVzYdIW45fY4OM+ZBuVlPWKHSUGwrIer4JTNwPguB
qvMDEwwTh1tGU/v/+EHoGgAd4yiYYq0EMPkBaL87G2UcSsqtlnanTot16SOgS8hw
obqJsD/YK76XZ7p7kyAm6PHgrB/h6QmMcJL6A4k1Xk5Lym+EEnWZ5W14S9QMaYDm
mqVC/r2nYGZKbtFGByMCcUjb4IufNSRMfL0eTIFAseQcJKGO4R4VfhLbzxTeuf+B
hb8541Zla1w=
=9kx7
-----END PGP SIGNATURE-----

--Sig_/Qswu7E61Zg376f/nlab4jyf--
