From: Phillip Susi <psusi@ubuntu.com>
Subject: Shrinking raid array
Date: Tue, 12 Feb 2013 10:52:52 -0500
Message-ID: <511A6554.1010100@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm working on shrinking a raid array and need some clarification on
where the metadata goes and how large it is.  I have used -G with -Z
and -z to reduce the used size of each disk, but the man page says you
need some extra space at the end of the disk for the metadata ( format
1.0 ), but doesn't specify exactly how much.  I need to know what the
exact size of the reduced partition should be.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRGmVUAAoJEJrBOlT6nu7591gIAIxoEWfN0L84UhaEwbKjzaOi
MXeCEdMjiGi5a4DCkl8FkKsrAHDHrmFKJ5hBr8u6DfS8rHyX7CmdUz5aVW1VhK/e
/bo44Vsrl/Tj7nqBYX4rxm3yhPzN17tTGKcf0lunWXFg9Ykv4Gc4EefzSsjTPbZf
oHepjklaik2tff3JCuxP7nv3I97BULmVvKJFKgeooK9QB6F5pRY1LnjRNhM91CKN
zkvoi3mitmK6fGZ+N7PUiogv2TczvX6m+yeNFb7Qw7opsrdErh7TH752efeKQ4bU
Iwomx1kYZT2k2swo+SahkZr58bfBkTzG5KZXUojEXO/pTX1vJFg+FOoVZ5m0bLY=
=k41W
-----END PGP SIGNATURE-----
