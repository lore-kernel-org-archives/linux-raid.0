From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid Failed What to to
Date: Fri, 21 May 2004 10:00:08 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405211400.i4LE0BB23915@www.watkins-home.com>
References: <40ADC1A6.9020108@tequila.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40ADC1A6.9020108@tequila.co.jp>
To: 'Clemens Schwaighofer' <cs@tequila.co.jp>, 'Dominik Sennfelder' <sennfelder@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you re-make the array with the same parameters as it has now the data
will not be lost (assuming it is still there now).  If 1 disk is really bad
then leave it out.

The procedures depend on which program you use to create the array.  Do you
use mkraid or mdadm?

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Clemens Schwaighofer
Sent: Friday, May 21, 2004 4:45 AM
To: Dominik Sennfelder
Cc: linux-raid@vger.kernel.org
Subject: Re: Raid Failed What to to

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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


