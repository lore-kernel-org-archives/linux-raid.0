From: Dominik Sennfelder <sennfelder@gmx.de>
Subject: Re: Raid Failed What to to
Date: Sun, 23 May 2004 20:31:51 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40B0EE17.3060708@gmx.de>
References: <200405211459.i4LExPB24054@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200405211459.i4LExPB24054@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Looks Bad :(

with mkraid i get the following output in /var/log/syslog

May 23 19:13:47 utgard kernel: md: bind<hde1>
May 23 19:13:47 utgard kernel: md: bind<hdi1>
May 23 19:13:47 utgard kernel: md: bind<hdk1>
May 23 19:13:47 utgard kernel: raid5: device hdk1 operational as raid disk 3
May 23 19:13:47 utgard kernel: raid5: device hdi1 operational as raid disk 2
May 23 19:13:47 utgard kernel: raid5: device hde1 operational as raid disk 0
May 23 19:13:47 utgard kernel: raid5: cannot start dirty degraded array 
for md0
May 23 19:13:47 utgard kernel: RAID5 conf printout:
May 23 19:13:47 utgard kernel:  --- rd:4 wd:3 fd:1
May 23 19:13:47 utgard kernel:  disk 0, o:1, dev:hde1
May 23 19:13:47 utgard kernel:  disk 2, o:1, dev:hdi1
May 23 19:13:47 utgard kernel:  disk 3, o:1, dev:hdk1
May 23 19:13:47 utgard kernel: raid5: failed to run raid set md0
May 23 19:13:47 utgard kernel: md: pers->run() failed ...

so i tried mdadm with the options from raidtab

mdadm -C /dev/md0 -l 5 -c 32 -p left-symmetric -n 4 /dev/hde1 /dev/hdi1 
/dev/hdk1 missing /dev/hdg1

this seems to work, the raid startet without any error
but when i try to mount the array i geht

utgard:~# mount /dev/md0 /mnt/hdd1/
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       or too many mounted file systems

a cfdisk tries to start with with a zero table.

any ideas ?

Dominik


Guy wrote:

>This is an example for using mdadm where the second of three disks is bad.
>But you must use the same chunk size and other RAID5 parameters or the array
>will have bogus data.  It would be nice if you still have the original
>command you used to create the array.
>
>mdadm -C /dev/md0 -l 5 -n 3 /dev/hda3 missing /dev/hdc3
>
>Guy
>
>-----Original Message-----
>From: Guy [mailto:bugzilla@watkins-home.com] 
>Sent: Friday, May 21, 2004 10:00 AM
>To: 'Clemens Schwaighofer'; 'Dominik Sennfelder'
>Cc: 'linux-raid@vger.kernel.org'
>Subject: RE: Raid Failed What to to
>
>If you re-make the array with the same parameters as it has now the data
>will not be lost (assuming it is still there now).  If 1 disk is really bad
>then leave it out.
>
>The procedures depend on which program you use to create the array.  Do you
>use mkraid or mdadm?
>
>Guy
>
>-----Original Message-----
>From: linux-raid-owner@vger.kernel.org
>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Clemens Schwaighofer
>Sent: Friday, May 21, 2004 4:45 AM
>To: Dominik Sennfelder
>Cc: linux-raid@vger.kernel.org
>Subject: Re: Raid Failed What to to
>
>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>Dominik Sennfelder wrote:
>| Hello
>|
>| I have got a Raid 5 with 4 160 GB Disk,
>| On of the Disks Failed because. But I know its OK I had this for some
>| times.
>| A Restart solved The Problem.
>| But now  Tried to raidhotremove the Drive and removed the wrong drive.
>| I just recongized the Problem after i raidhotadded itagain.
>| No the Raid tries to sync again.
>
>well if you removed two drives from your Raid5 array, it might got
>competly out of sync and then there is no way to recover. I have never
>tried this with my raid, but if you add another disk it well be
>re-synced, ergo it tries to rebuild the array out of the CRCs on the
>other drives, if you remove two, you don't have enough redudant data to
>do this (raid 6 can recover from a 2 drive failure).
>
>I hope you have a backup.
>
>- --
>Clemens Schwaighofer - IT Engineer & System Administration
>==========================================================
>TEQUILA\Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
>Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
>http://www.tequila.co.jp
>==========================================================
>-----BEGIN PGP SIGNATURE-----
>Version: GnuPG v1.2.4 (GNU/Linux)
>
>iD8DBQFArcGmjBz/yQjBxz8RAkYKAJ9TAc03OnmIth/M03xBmopKerZLOQCcCiiG
>wk/lAjdcrd1jPWSoLyOGLAE=
>=5uyj
>-----END PGP SIGNATURE-----
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

