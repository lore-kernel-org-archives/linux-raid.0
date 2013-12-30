From: Phillip Susi <psusi@ubuntu.com>
Subject: The chunk size paradox
Date: Mon, 30 Dec 2013 13:48:58 -0500
Message-ID: <52C1C01A.7010407@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I believe that using a single "chunk size" causes a lose-lose tradeoff
when creating raid 5/6/10 arrays.  Too small of a chunk size and you
waste too much time seeking to skip over the redundant data ( I think
this is why the default was changed from 64k to 512k ), but too large of
a chunk size, and you lose parallelism since your requests won't be
large enough to span a whole stripe, and in the case of raid5 you run
into problems with the stripe cache.

I believe that what is needed is to drop back down to 64k chunk size,
and deal with the seek problem by grouping stripes.  Instead of rotating
between every stripe, you only rotate between groups of stripes.  An
example of a three disk raid5 would look like this with a group factor
of 3:

1     2     1+2'
3     4     3+4'
5     6     5+6'
7+8'  7     8
9+10' 9    10

And a raid10-offset:

1     2     3
4     5     6
7     8     9
3'    1'    2'
6'    4'    5'
9'    7'    8'

And raid10-near:

1     1'    2
3     3'    4
5     5'    6
2'    7     7'
4'    8     8'
6'    9     9'

This gets you the benefit of reduced seeks, without hindering
parallelism.  In the case of the raid10-offset, you can use a relatively
large ( ~1GB ) group size to get sequential read performance nearly
identical to that of raid0, only needing to seek every 1 * n GB, while
not requiring requests at least 1 * n GB to keep all disks busy.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSwcAZAAoJEI5FoCIzSKrw7J4IAKvCT/pvph2/PRiU4hB+nQAa
2PkZujxN0qQOzt/WH8nBPtibFIZDMrz7BF77R4H9ysJDJ2zScwJXPUtVhfDGp4rG
l++JsE7Drie/+hFR60N2gJNGZIBTnTWAWmfMig72fbJcURTwKDcqrhkPBe2gnA9D
gVlz+prNKcbVAa9j3LByL1PN29Gq2Vr9ICLeDs+x+epIA2ZslbIWwj8A3rsS98/3
D2LX3m5Jx5DzgjxIxWsgFcJy1aT6bby0QgNwSh/2ITLeQVKE8HlQb2r6PupPX/GC
MVMP7CLGREBb2D83Q2YDBMLz4+xCd0h4mbMPkD7L47m1XPobPLeEu4SfsiHjDSk=
=O9Ce
-----END PGP SIGNATURE-----
