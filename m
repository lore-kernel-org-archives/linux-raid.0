From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: Raid Failed What to to
Date: Fri, 21 May 2004 17:45:26 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40ADC1A6.9020108@tequila.co.jp>
References: <40AD2C0D.10709@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40AD2C0D.10709@gmx.de>
To: Dominik Sennfelder <sennfelder@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dominik Sennfelder wrote:
| Hello
|
| I have got a Raid 5 with 4 160 GB Disk,
| On of the Disks Failed because. But I know its OK I had this for some
| times.
| A Restart solved The Problem.
| But now  Tried to raidhotremove the Drive and removed the wrong drive.
| I just recongized the Problem after i raidhotadded itagain.
| No the Raid tries to sync again.

well if you removed two drives from your Raid5 array, it might got
competly out of sync and then there is no way to recover. I have never
tried this with my raid, but if you add another disk it well be
re-synced, ergo it tries to rebuild the array out of the CRCs on the
other drives, if you remove two, you don't have enough redudant data to
do this (raid 6 can recover from a 2 drive failure).

I hope you have a backup.

- --
Clemens Schwaighofer - IT Engineer & System Administration
==========================================================
TEQUILA\Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
http://www.tequila.co.jp
==========================================================
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFArcGmjBz/yQjBxz8RAkYKAJ9TAc03OnmIth/M03xBmopKerZLOQCcCiiG
wk/lAjdcrd1jPWSoLyOGLAE=
=5uyj
-----END PGP SIGNATURE-----
