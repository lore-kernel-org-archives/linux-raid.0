From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 01 Apr 2004 13:57:14 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406BA12A.6020300@tequila.co.jp>
References: <008f01c41737$8b57be40$6405a8c0@a30> <006401c417a1$36a45790$6405a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <006401c417a1$36a45790$6405a8c0@a30>
To: me@heyjay.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

me@heyjay.com wrote:

| - I'm using a (fairly) old machine, I have to figure processor speed
has to
| be an issue with software raid
| - When the box is being stressed most of the work is computational, the
| process I run puts the CPU% at 98% (according to top).
| - Most of the disk activity is read (the disks aren't very active in
| general)
| - I'm going to use WD 7200 rpm drives
| - going to do raid 1
| - I'm going to want to do backups onto a tape drive

The only thing that comes to my mind is hot swapping. If you go with IDE
drives it is highlu possible it is not going to work. which means, you
don't have data loss if a drive fails, but downtime (depends on the
server if this is critical).
If you use SCSI drives and Softwareraid you can make hotswap, then if
you don't have an special reason for hardware raid, you can go for
software raid.

- --
Clemens Schwaighofer - IT Engineer & System Administration
==========================================================
TEQUILA\Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
http://www.tequila.co.jp
==========================================================
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAa6EqjBz/yQjBxz8RApbuAKDf2q472lXPznFHPkpQ56dSLRkKJwCdGHWm
agCc+RjOofOQk3aNaZRB4GY=
=w1b7
-----END PGP SIGNATURE-----
