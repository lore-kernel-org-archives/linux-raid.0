From: "Dominik Sennfelder" <buliwyf@gmx.de>
Subject: RE: Raid Failed What to to
Date: Sat, 22 May 2004 00:35:52 +0200 (MEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4845.1085178952@www14.gmx.net>
References: <200405212141.i4LLfEB25161@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Guy <bugzilla@watkins-home.com>
Cc: Sennfelder@gmx.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

But it tried to resync after i have added the disc again with raidhotad=
d. :(
But it could do nothing. in the log file there have bon hundreds of ent=
ires
like.
May 20 23:52:25 utgard kernel: md: syncing RAID array md0
May 20 23:52:25 utgard kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
May 20 23:52:25 utgard kernel: md: using maximum available idle IO band=
with
(but not more than 200000 KB/sec) for reconstruction.
May 20 23:52:25 utgard kernel: md: using 128k window, over a total of
156288256 blocks.
May 20 23:52:25 utgard kernel: md: md0: sync done.
But how you can se this lastet only for 1 second or something like that=
=2E

How would this work?
comment out the entries in the /etc/raidtab, boot the system=20
set 1 device as faulty ( best would be the one that faild the day befor=
e)
and than just mkraid /dev/md0 ?

Dominik


> 2mkraid or mdadm will work, just be very sure you use the correct opt=
ions.
> As long as the system does not attempt a re-sync, the data will not b=
e
> destroyed.  But if you get the parameters wrong and a re-sync starts,
> expect
> data to be lost.  So, keep 1 disk missing until you are sure you have=
 it
> right!
>=20
> One of the parameters that must be correct: "parity-algorithm".
>=20
> If you used mkraid your /etc/raidtab file should have what you need. =
 You
> will need to use the "failed-disk" keyword.  See "man raidtab".  I am=
 not
> sure how to use it.  So be careful!
>=20
> Guy
>=20
> -----Original Message-----
> From: Dominik Sennfelder [mailto:Sennfelder@gmx.de]=20
> Sent: Friday, May 21, 2004 4:59 PM
> To: Guy
> Cc: linux-raid@vger.kernel.org
> Subject: RE: Raid Failed What to to
>=20
> Hello
>=20
> Thanks for your help.
> I created the array with mkraid /dev/md0 after i added the entrys in
> /etc/raidtab.
> I analyzed the logs an saw that one disk failed one day before,
> so the raid run with 3 discs. My fault was to raidsetfault the wrong
> drive.
> But in that moment the Raid broke up an no write was possilble becaus=
e it
> got remountet -ro. After i hotadded it again, it tried to sync but wi=
th
> only
> two discs syncing wouldn't be possible. The drive i removed wan't rea=
lly
> faulty, it was just set faulty. I even could browse the filesystem wh=
en
> just
> 2 discs run.=20
> So can i reassamble the drive mith mdadm? or do i have to use mkraid?
>=20
> Thanks for your help and suggestions.
>=20
> Dominik
>=20
>=20
> > This is an example for using mdadm where the second of three disks =
is
> bad.
> > But you must use the same chunk size and other RAID5 parameters or =
the
> > array
> > will have bogus data.  It would be nice if you still have the origi=
nal
> > command you used to create the array.
> >=20
> > mdadm -C /dev/md0 -l 5 -n 3 /dev/hda3 missing /dev/hdc3
> >=20
> > Guy
> >=20
> > -----Original Message-----
> > From: Guy [mailto:bugzilla@watkins-home.com]=20
> > Sent: Friday, May 21, 2004 10:00 AM
> > To: 'Clemens Schwaighofer'; 'Dominik Sennfelder'
> > Cc: 'linux-raid@vger.kernel.org'
> > Subject: RE: Raid Failed What to to
> >=20
> > If you re-make the array with the same parameters as it has now the=
 data
> > will not be lost (assuming it is still there now).  If 1 disk is re=
ally
> > bad
> > then leave it out.
> >=20
> > The procedures depend on which program you use to create the array.=
  Do
> > you
> > use mkraid or mdadm?
> >=20
> > Guy
> >=20
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org
> > [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Clemens
> > Schwaighofer
> > Sent: Friday, May 21, 2004 4:45 AM
> > To: Dominik Sennfelder
> > Cc: linux-raid@vger.kernel.org
> > Subject: Re: Raid Failed What to to
> >=20
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >=20
> > Dominik Sennfelder wrote:
> > | Hello
> > |
> > | I have got a Raid 5 with 4 160 GB Disk,
> > | On of the Disks Failed because. But I know its OK I had this for =
some
> > | times.
> > | A Restart solved The Problem.
> > | But now  Tried to raidhotremove the Drive and removed the wrong d=
rive.
> > | I just recongized the Problem after i raidhotadded itagain.
> > | No the Raid tries to sync again.
> >=20
> > well if you removed two drives from your Raid5 array, it might got
> > competly out of sync and then there is no way to recover. I have ne=
ver
> > tried this with my raid, but if you add another disk it well be
> > re-synced, ergo it tries to rebuild the array out of the CRCs on th=
e
> > other drives, if you remove two, you don't have enough redudant dat=
a to
> > do this (raid 6 can recover from a 2 drive failure).
> >=20
> > I hope you have a backup.
> >=20
> > - --
> > Clemens Schwaighofer - IT Engineer & System Administration
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > TEQUILA\Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
> > Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
> > http://www.tequila.co.jp
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > -----BEGIN PGP SIGNATURE-----
> > Version: GnuPG v1.2.4 (GNU/Linux)
> >=20
> > iD8DBQFArcGmjBz/yQjBxz8RAkYKAJ9TAc03OnmIth/M03xBmopKerZLOQCcCiiG
> > wk/lAjdcrd1jPWSoLyOGLAE=3D
> > =3D5uyj
> > -----END PGP SIGNATURE-----
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> >=20
>=20
> --=20
> Mfg Dominik Sennfelder
> --------------
> Sennfelder@gmx.de         IRC: #spooky =20
> ICQ: 18164192          Blue Skies         =20
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
cYa Bul|w=FDf
--------------
Buliwyf@gmx.de         IRC: #spooky  =20
ICQ: 18164192          Blue Skies         =20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
