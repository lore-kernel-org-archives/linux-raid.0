From: Vitaly <agri@desnol.ru>
Subject: ibm serveraid
Date: Fri, 7 Feb 2003 15:25:10 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030207152510.3e3be8ef.agri@desnol.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="pgp-sha1"; boundary="8274=.3aQ6OeN2YW"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--8274=.3aQ6OeN2YW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello

I have IBM ServeRAID controller
> lspci -v
<01:06.0 RAID bus controller: IBM Netfinity ServeRAID controller
<        Subsystem: IBM: Unknown device 020e
<        Flags: bus master, 66Mhz, slow devsel, latency 96, IRQ 10
<        Memory at edffe000 (32-bit, prefetchable) [size=8K]
<        Expansion ROM at <unassigned> [disabled] [size=512K]
<        Capabilities: [80] Power Management version 2
I want to compile new kernel with full support for the controller.
What i need? Is scsi support enough and all disk array will work correctly? Or there should be some special initialization during boot time and i need some special features compiled in?
Can i compile serverRAID support as a module?
I already have working system based on linux with configured raid controller.

Agri

PS: i suppose that ibm support team can't answer "2 x 2 = ?" :-(

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.0.7 (GNU/Linux)

mQGiBD396OoRBAC8hupjq2bx4l0IQbxXYUYBsiNljXqG3L7Ezv2Kcwfi4L1gVOJQ
7DcNFPTXRa7CREdtYhGtaBDtdx1xynIvTa6Wu7qNnTIvkxh0TxlAbcVoioz6Y3CA
LO2MvyuuuafEPEDKj8u8lILl1RW4KTItwlf3x3dazyZNSduYKSfHI+NH8wCg8bE/
mSYQwZBFHVuJyFZhUS8bNAcD/18K5L5pRPpQBqJX4ShS5gn5BgUWg/+XsE4ZLTuF
beTziXLpGo01dTskNt++WuD0b6kLlKqJgSqP50fHDvWGD1JCYyD6RKM5yFYrEl1A
wq0jCmRxDxg3k3ls/K1d5pkOWnafnA+Fo+EjJYQv89epPJ43FZHRPFpSHBIRUa29
jHlTA/4nrQH5mIL1lfzJ0/IQfL5rU/BBc69Yq7YawSsOtHclMEbPLHQntygthSth
f0E/2i6ZqS+4UgRBiMp6hol/OEpxqNrnxS6mOc3ABRy7yeDcnJuSWTyY4D0M92LS
HipkTWQBblq4IdkKpuIlYNHLdyp+qkAXtUH9vPyHqkzUxMXhsLQ0Vml0YWx5IFYu
IE1hbnVzaGtpbiAoYWRtaW5pc3RyYXRvcikgPGFncmlAZGVzbm9sLnJ1PohZBBMR
AgAZBQI9/ejqBAsHAwIDFQIDAxYCAQIeAQIXgAAKCRBcuphZ4z54200gAJ9/drYg
QEKs5GqKbNRwGtqShEh9kgCdE/esc/vN0Mep93nnGPW7Mqsbu/65AQ0EPf3o7RAE
AOJVOEja9fQyrSvpgTtRir6h2Ga9MxF6vGyTo+9TnT4lC9yh6dGfM6dVPbwbXD9S
A5yFsirLg3Qj+P6LSAv+MtdTQhHhwT3XhKcQYwrEzWxqwRRRLEpi91wqO/DauBDL
Lk+ZcDlsh87yTBPnLTmSuJMOEjg2WPnZOD5EvYu8f3tjAAMFA/9wDguv2Dix/bEl
eP4B2PdLVlKssqX65wSL/Z3P9ptfr3cU+j15kQ4WuUmy4dJ4wUBjit7ZJmpQYqVS
lJX/9NwZD4jRwsKk0B2tjPAidTCAcUN2BnXYjpMs+FD+sZ2wv/4RROxnixa3+/pr
+V3ig+OqQKvVFT38HWI4sJ13iYhVbohGBBgRAgAGBQI9/ejtAAoJEFy6mFnjPnjb
ZRYAn0GBCcRx0xvAtwbYQqE9sjhSi/AsAKCk6pN4KRUJhGxJSJKTlfBcHwELqw==
=/1mC
-----END PGP PUBLIC KEY BLOCK-----

--8274=.3aQ6OeN2YW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE+Q6WpXLqYWeM+eNsRAuogAKCMjumHjjhxHzkBJyrkFAd/Jiy2fwCeKRxx
U4oh8vtmtX77bPgH23k7o60=
=Jo/q
-----END PGP SIGNATURE-----

--8274=.3aQ6OeN2YW--
