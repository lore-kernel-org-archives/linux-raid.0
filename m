From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: [PATCH] md - 0 of 2 - Introduction
Date: Fri, 05 Mar 2004 17:42:16 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40483D68.9030906@tequila.co.jp>
References: <20040305164342.7205.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040305164342.7205.patches@notabene>
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

NeilBrown wrote:
| Here are two patches for md that I believe are suitable
| for 2.6.4.
|
| 2/ Support assembling partitionable raid at boot-time so that it is
|    possible to boot from a partition of a raid array without needing
|    an initramfs.

I have a RAID 1 here and I boot with grub and I don't need ana initramfs
(initrd) ...

- --
Clemens Schwaighofer - IT Engineer & System Administration
==========================================================
Tequila Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
http://www.tequila.jp
==========================================================
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFASD1ojBz/yQjBxz8RAq6lAKDdN8hKgdBocQZOqC0yGoYd/Z6MCQCfdaL/
BFv6yTZznpg7wIEWxlQELak=
=Zht7
-----END PGP SIGNATURE-----
