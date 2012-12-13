From: Phillip Susi <psusi@ubuntu.com>
Subject: imsm: 32 bit sector counts and > 2TB disks
Date: Thu, 13 Dec 2012 11:45:33 -0500
Message-ID: <50CA062D.2000002@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

It appears that the imsm format only uses 32 bits to represent the
sector counts used from each disk.  It appears that at least on
Windows, a disk > 2 TB works so could someone from intel explain how
this is supposed to work?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBAgAGBQJQygYtAAoJEJrBOlT6nu75CMMH/ibrw7zoKnt7aNHvSAKkxa8g
1d1JBXYuIV3rbfVyvIIli4+laHg1hf9FmJBN7vluZSTgULZPxvtRBi+DvD/cCkkL
yvzqACld5e2iZgTWG6cyFZeS73eVz2ah8XaHCNQB15pIu/2ZI9xWtgxk26r24Hei
mgt/IbrGxs2NCryn4jJ4gpXwJYDpl/KqlLKtky+USvuaIxv6+sz/6Ab5B1RO/M78
12M0GY71cxjcBwv4YTlgO/SVZjTwUZ+ZiJooiwiV5O+6xPJ+hO1QIyCl/z6a7Mlc
2vE0q09ak3f85qK4/dQfOTOL0xbr62jfoJO6QwO96rK9PoCUkbjbBAk5fKPIggM=
=5Los
-----END PGP SIGNATURE-----
