From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 11:31:36 -0500
Message-ID: <52C59468.6080200@ubuntu.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C588A7.6010207@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, joystick <joystick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/2/2014 10:41 AM, Stan Hoeppner wrote:
> First, there is no such thing as a 4K sector in Linux.  Sectors are
> 512 bytes.  Filesystem blocks and memory pages are 4K.

Of course there is.  Disks with 4k sectors are becoming more and more
popular.  CD-ROM type drives have always used 2k sectors.  Also
filesystem blocks and memory pages aren't necessarily 4K, though that
is the most common size.

> read the data chunk of the stripe in which the 4 sectors of the
> 4KB

You mean 8 sectors, assuming you're still talking about 512 byte sectors.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSxZRoAAoJEI5FoCIzSKrwCGUH/i7LbqjiCAxXo4to5mrNOKyj
3MlfRXyihoo0v78LNPZg5nX7toqEWD/E+kc+HxHPdQKAEkxFqVcgT7S+VA2Zoi59
/F2jFHFE+ZSI6szAkt1FiGsYR/SQ3bkAC2L078keZ0i1gaO6ZUov/4rdw5cTf+TG
pUZk6Kwqr1uNRaPIVRhvMUy9+qCnTOKJ/65/XvesIGDoTIZTcCMitbxLduPd7nkr
iZaiWv7HNrWba7WVPbD2SGKpkAUiE61F1+8nobeslYrWuD8w2QrNFfw1tA+2ScuB
b3lqdXnLGeIX6phDuEew/kveJ/mXvIuBJtDkNN4q6Xqc8FWVDSerI2u10xrDsc8=
=17Wg
-----END PGP SIGNATURE-----
