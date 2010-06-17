From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: How to boost performance
Date: Thu, 17 Jun 2010 10:01:09 +0600
Message-ID: <20100617100109.32a20ffa@natsu>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vwK7yVKQoJVqCO62lcqunNZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: aragonx@dcsnow.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vwK7yVKQoJVqCO62lcqunNZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Jun 2010 18:23:36 -0400
aragonx@dcsnow.com wrote:

> Before I start spewing server information, my question is this.  Is there
> anything I can tweak to improve my performance?  It seems that the server
> is CPU bound when I am transferring large amounts of data to or from it.=
=20
> Any suggestions will be considered.  Faster processor, switching to RAID
> 0, etc.  I'm hoping there is something I can do with the RAID software
> though.  Maybe a different chunk size or different algorithm?

Increasing stripe cache size from the default of 256 should help immensely.

echo 16384 > /sys/block/md0/md/stripe_cache_size

Be warned that this consumes (^that amount * 4096 * number of disks) bytes =
of
RAM. Some benchmarks:=20

http://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-write-tr=
ansfer/

On a related note -- Neil, are there plans to implement a stripe cache which
would be shared between all RAID devices? I have two RAID5s in my system, a=
nd
when one has a lot of writes, the other is often idle (or vice versa), so t=
hat
array's stripe cache is just sitting there wasting memory. Would be nice to
be able to have a shared pool of RAM for stripe-caching all the arrays and
the active one(s) using it to the fullest.

--=20
With respect,
Roman

--Sig_/vwK7yVKQoJVqCO62lcqunNZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwZngUACgkQTLKSvz+PZwhzhQCglMmq/t7jmKkry/6/YE2iCdDd
PFEAnA2pt8ZgXDSgoVLO4oGRfOnbpPaW
=u/ut
-----END PGP SIGNATURE-----

--Sig_/vwK7yVKQoJVqCO62lcqunNZ--
