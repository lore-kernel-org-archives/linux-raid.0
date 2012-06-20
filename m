From: Robert Buchholz <robert.buchholz@goodpoint.de>
Subject: Find mismatch in data blocks during raid6 repair
Date: Wed, 20 Jun 2012 19:41:05 +0200
Message-ID: <10900468.MPSjVn2C3J@peanut>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1506901.2o3daRAQF0"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nextPart1506901.2o3daRAQF0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hello list,

I have been looking into the repair functionality of the raid6 
implementation in recent kernels to find out how the md driver handles 
parity mismatches. As I understand, the handle_parity_checks6 function 
simply regenerates P and Q from the data blocks if they do not match. 
While this makes perfect sense for a single parity mismatch, when both 
are wrong it may indicate an error in the data blocks.

When repairing a full raid6 with no missing drives (raid-devices=n+2), a 
single inconsistent data block could be detected: For every one of the n 
blocks, assume its device is missing, recover the block from P, generate 
Q' and compare with the actual Q. If there is exactly one block where Q' 
equals Q, rewrite the data block in question.*

I understand the usual failure mode is to remove a drive from the array, 
or use IO errors from the kernel to identify incorrect data blocks. 
However, this assumes we recognize the error at the time and thus know 
which data block is incorrect. But that is not always the case:
The drives could be inconsistent after a multi-drive failure, unclean 
shutdown, bit rot or because one raid drive was replaced outside the 
realm of md using dd(rescue).
Is there a reason this approach is not currently chosen? The performance 
implications seem to be low, there is no increased io (in fact, it may 
decrease since write-back decreases up to a factor of 2), and number of 
parity calculations increases by a factor of n in the error case (both 
error case and n could be assumed low).


Cheers

Robert

--nextPart1506901.2o3daRAQF0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABCgAGBQJP4gs1AAoJECaaHo/OfoM5i0oP/ROLvFDldvfbKhVBrrDhhvqP
BO4yKaTwwlokQ36XRn2DTMQpnOWh3L0tYhEoxB+UZfc2s+qEFqaREb/7ANnH6Har
n+InMBxb1m4Z3lYjEJ8bEAniBbRF21uv06reZPAtADNjyD7IHPnqFd/d+EY3D43P
CVd+Xybi61i4AUUTKIaKrhjGzGD/8kKCfu9jFhd53mP3MWOKzk20UYFLPcrqoNJJ
Wv154XJsgf9geFjsM0q3cMnBvH/kXy9RybEfKjJbWo0RWaL1P0evEqQZe/SFFgfh
j3TmL9Psba0rb1ntxXjfoAChNMjFneXj9WqmTUVkKVp7GBFbWqxZ2hsLbNWfKC14
tkSIbb28yGiGW5oMVVMj6Fdbz2/H3ml4w91Jp3LBG76qFE2YrXPA53+kqzsAg/qk
6EaOhqaGG2lxKPMF///oPoAMKJ/4w2JjDRgQJYhCOQivuKFP1sxfLr4UYWbyq/g+
aKGUbF627UegwmXzoKPRIMU9xVouHrvv9xRH4kbcx3eOO1hbfjSRpZ7fT4ONT1M/
hmH68SylPDnrNkW+s6OjFap8GIgTXdneHTcASlrl+U0RVOUZnJGSc2RHb+cV1TI+
DQg6j2/EW6YYNGtAe9/puFtE7NnMofNKx+O6mSOaGzphz4VMFPWc/6zhZxZRN4P6
0QSof+ynzj65AKoTp0D3
=0xdI
-----END PGP SIGNATURE-----

--nextPart1506901.2o3daRAQF0--

