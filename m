From: NeilBrown <neilb@suse.de>
Subject: Re: How to use --freeze-reshape  and is it safe?
Date: Thu, 14 Aug 2014 15:56:33 +1000
Message-ID: <20140814155633.567baece@notabene.brown>
References: <53EC4B63.90703@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/C/IcTL7sOk=sizaoD+5h7QC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53EC4B63.90703@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/C/IcTL7sOk=sizaoD+5h7QC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Aug 2014 00:38:43 -0500 Ram Ramesh <rramesh2400@gmail.com> wrote:

> I was browsing through mdadm man pages to check out --layout options=20
> when converting 3disk-raid5 to 4disk-raid6 and encountered=20
> --freeze-reshape switch/arg. I did a quick google and could not get much=
=20
> info. Can a user issue this to suspend reshape for a short while?=20

As --freeze-reshape is only meaningful in combination with --assemble,
this question doesn't really make sense.

If you are using a sufficiently new kernel and mdadm so that "data_offset" =
is
adjusted during reshapes so that no 'backup' is needed, then you can
suspend a reshape for a period of time by:

  echo frozen > /sys/block/mdXXX/md/sync_action

This is perfectly safe.  When you want to unfreeze, write 'idle'
to 'sync_action'.  md will notice that a reshape is pending and will restart
where it was up to.


> Specifically
>=20
>  1. Is the use (or frequent use) of this switch safe? recommended?
>  2. Can the array be mounted when this switch is used?
>  3. What is correct syntax for the usage?
>  4. Can I use this to manage the reshape load on an array? May be to let
>     the disk cool off after a busy hours of seeking to reshape?
>  5. Can I use it as a safe method for shutting down  the machine?
>  6. Is there a tutorial/faq/manual that explains in detail the use of
>     other mdadm esoteric switches? (like --layout I was searching)

Is it really that esoteric?
If you want to reshape an array, you run "mdadm --grow" and list all the
changes you want to make.  Set a new level, a new number of devices, a new
layout, a new chunk size, whatever.  mdadm will do it if it can and give an
error if it cannot.
If you want to test it out first then that is extremely sensible.  Make some
loop devices and experiment.

NeilBrown

--Sig_/C/IcTL7sOk=sizaoD+5h7QC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+xPkTnsnt1WYoG5AQJbwA//R/EkWNA0hc2m/RbAah5SlT47asMlqD0J
WADxz68cw897WSGuhnBxCE3FNGeqw3iqnTV7ruxrNaNaZpLp6f6paKCi8JYICuW8
yDhoxTVXLEayt9e0ocmL2eEdA4/63QyGRbCriH8Rd4lhUQL4vdLUqmmb6XGNejvB
ePDr1ESFV9bDlJQCZkOaej/Yzau6MxQE4+AfFRR74XfMJ3Z4zGCPNJYjiKTGQ+YB
jhqryy8OR5XBh5F/DRASsAVGJewbOY6Z7oL4zXhzLAjQcD60R/+LWht194dP43/a
8raMILUNVDUqRz49eQklQvB21w8x+64Z1DTUtEq8kow43vUACMxi0R9SAHuPoQLF
UkdRRKCWuBw6PS0S1C+2O7w1JUdYjlXeJJwNUkrxz6SSNjAfyF+LIuFpDH22XHBx
IbtW6E+YRgKzahTlvigO5gDU3ix5GcuUhQOfS822d/YXqiTnt9ykcZcpOgdLI1zm
sbrGzXQKGbYreg1r32ozygqj7NAYbIbIJ7IjZOmh7ZA5z7zEXuBfn2q1H6L0fajO
M2ZZwCw2wKAJimbVmkm6A1MB9Lmt6xF9v0g5vi8oeVsNLUOwHFrn3LRmyRJ55Zb4
6327HSe+Oo9lizB0740Q675gJGr+OXRa4oha9DYMvclkH/PyYN18F/WFCfSQk6gC
r+7yDGGE2/I=
=/YUM
-----END PGP SIGNATURE-----

--Sig_/C/IcTL7sOk=sizaoD+5h7QC--
