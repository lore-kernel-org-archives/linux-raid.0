From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid Failed What to to
Date: Fri, 21 May 2004 17:41:10 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405212141.i4LLfEB25161@www.watkins-home.com>
References: <23885.1085173138@www14.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23885.1085173138@www14.gmx.net>
To: 'Dominik Sennfelder' <Sennfelder@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mkraid or mdadm will work, just be very sure you use the correct options.
As long as the system does not attempt a re-sync, the data will not be
destroyed.  But if you get the parameters wrong and a re-sync starts, expect
data to be lost.  So, keep 1 disk missing until you are sure you have it
right!

One of the parameters that must be correct: "parity-algorithm".

If you used mkraid your /etc/raidtab file should have what you need.  You
will need to use the "failed-disk" keyword.  See "man raidtab".  I am not
sure how to use it.  So be careful!

Guy

-----Original Message-----
From: Dominik Sennfelder [mailto:Sennfelder@gmx.de] 
Sent: Friday, May 21, 2004 4:59 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: RE: Raid Failed What to to

Hello

Thanks for your help.
I created the array with mkraid /dev/md0 after i added the entrys in
/etc/raidtab.
I analyzed the logs an saw that one disk failed one day before,
so the raid run with 3 discs. My fault was to raidsetfault the wrong drive.
But in that moment the Raid broke up an no write was possilble because it
got remountet -ro. After i hotadded it again, it tried to sync but with only
two discs syncing wouldn't be possible. The drive i removed wan't really
faulty, it was just set faulty. I even could browse the filesystem when just
2 discs run. 
So can i reassamble the drive mith mdadm? or do i have to use mkraid?

Thanks for your help and suggestions.

Dominik


> This is an example for using mdadm where the second of three disks is bad.
> But you must use the same chunk size and other RAID5 parameters or the
> array
> will have bogus data.  It would be nice if you still have the original
> command you used to create the array.
> 
> mdadm -C /dev/md0 -l 5 -n 3 /dev/hda3 missing /dev/hdc3
> 
> Guy
> 
> -----Original Message-----
> From: Guy [mailto:bugzilla@watkins-home.com] 
> Sent: Friday, May 21, 2004 10:00 AM
> To: 'Clemens Schwaighofer'; 'Dominik Sennfelder'
> Cc: 'linux-raid@vger.kernel.org'
> Subject: RE: Raid Failed What to to
> 
> If you re-make the array with the same parameters as it has now the data
> will not be lost (assuming it is still there now).  If 1 disk is really
> bad
> then leave it out.
> 
> The procedures depend on which program you use to create the array.  Do
> you
> use mkraid or mdadm?
> 
> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Clemens
> Schwaighofer
> Sent: Friday, May 21, 2004 4:45 AM
> To: Dominik Sennfelder
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Raid Failed What to to
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Dominik Sennfelder wrote:
> | Hello
> |
> | I have got a Raid 5 with 4 160 GB Disk,
> | On of the Disks Failed because. But I know its OK I had this for some
> | times.
> | A Restart solved The Problem.
> | But now  Tried to raidhotremove the Drive and removed the wrong drive.
> | I just recongized the Problem after i raidhotadded itagain.
> | No the Raid tries to sync again.
> 
> well if you removed two drives from your Raid5 array, it might got
> competly out of sync and then there is no way to recover. I have never
> tried this with my raid, but if you add another disk it well be
> re-synced, ergo it tries to rebuild the array out of the CRCs on the
> other drives, if you remove two, you don't have enough redudant data to
> do this (raid 6 can recover from a 2 drive failure).
> 
> I hope you have a backup.
> 
> - --
> Clemens Schwaighofer - IT Engineer & System Administration
> ==========================================================
> TEQUILA\Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
> Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
> http://www.tequila.co.jp
> ==========================================================
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.4 (GNU/Linux)
> 
> iD8DBQFArcGmjBz/yQjBxz8RAkYKAJ9TAc03OnmIth/M03xBmopKerZLOQCcCiiG
> wk/lAjdcrd1jPWSoLyOGLAE=
> =5uyj
> -----END PGP SIGNATURE-----
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Mfg Dominik Sennfelder
--------------
Sennfelder@gmx.de         IRC: #spooky  
ICQ: 18164192          Blue Skies          


