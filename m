From: Phillip Susi <psusi@ubuntu.com>
Subject: raid10 offset distance
Date: Thu, 26 Dec 2013 21:37:21 -0500
Message-ID: <52BCE7E1.9050904@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

md(4) hints that you can get sequential read performance near that of
the far layout with the offset layout and a large chunk size.  That
sounded nice and I thought that chunk size was just the number of
stripes to write before the backup copy.  It turns out that "chunk
size" is really just the stripe factor, and so using a very large
stripe factor hurts performance since even a relatively large IO
doesn't span disks.

Is there a way to keep a sane stripe factor, but have the offset copy
stored further away to reduce seeking during sequential reads?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSvOfhAAoJEI5FoCIzSKrwizkIAIfDU2MS9S1Hb4wYSZm5QZhn
HSvDcnVD2jxSXwgJXLSsvq8dlO426OVnIwFECGcXS/1Lc/UcaX6t9C6cbsKGtvBG
5NQdq4WE/mBTQ4nXUzAJvyZfkacn4JhJinZjK6uEaGkoIj2cj1FP0/qjLGP3S7eT
9dMrXU61PbrS6XGHgfJzp0BXAN7YVjajCXKvwsY53BEjnuFsACs9eM8S8GBztNe8
mR9JqM9TfRhZ7C0t9/T+sbFHQqATm24Bnl7awzd7UuqXOJR8qA1GpxMHlfy07OHt
8Ya7RV28ezPmaa//RrlvPeVN8iVtvJoWndaqeXghmJYYn06CNd90gEOZZEDDi00=
=WgY2
-----END PGP SIGNATURE-----
