From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: RAID 0 -> 1 possible?
Date: Fri, 12 Mar 2004 14:53:02 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4051503E.6090703@tequila.co.jp>
References: <4050CF9C.6000704@microcenter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4050CF9C.6000704@microcenter.com>
To: Jeff Hoffmann <jhoffman@microelectronics.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeff Hoffmann wrote:
| Hello list,
|
| Is it possible to convert from RAID 0 to 1 without data loss?
|
| Given a system with two disks, three partitions on each: boot, /, and
swap.
|
| Convert / from RAID 0 to 1 without requiring a backup/reinstall/restore
| scenario
|
| Any RAID-mojo-masters with the answer?

I think that can't work unless you add two more disks. Raid 0 is strip
where 1 is mirroring.

- --
Clemens Schwaighofer - IT Engineer & System Administration
==========================================================
Tequila Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
http://www.tequila.jp
==========================================================
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAUVA9jBz/yQjBxz8RAiSnAJ9qeBSBhpWLjlfUqZoGarM6smgw8gCgxnf+
+6ScO+vbTIu9u5XKNpqDrHw=
=Jvfs
-----END PGP SIGNATURE-----
