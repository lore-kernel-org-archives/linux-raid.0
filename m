From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: raidreconf: Successful RAID5 Reconstruction (re-size)
Date: Wed, 26 Jun 2002 20:06:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020626180640.GC4914@unthought.net>
References: <NDBBIAKEEKGGEIKCBKNAAEOGDAAA.kc130iseo@coastalnet.com> <NDBBIAKEEKGGEIKCBKNACEOIDAAA.kc130iseo@coastalnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <NDBBIAKEEKGGEIKCBKNACEOIDAAA.kc130iseo@coastalnet.com>
To: cwebster@ec.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 26, 2002 at 11:35:06AM -0600, Cal Webster wrote:
>=20
=2E.
> Although there were no indications of errors and initial indications =
were
> promising, deeper investigation revealed that the data (or at least t=
he
> directories) have been corrupted.

Did you fsck -f the array before re-sizing the filesystem ?

What does fsck -f show on (the unmounted) filesystem now ?

>=20
> When attempting to re-mount iso images located on the RAID device, I =
got
> "Not a directory" errors.
>=20
> A listing at the top level of the mounted RAID5 device shows a somewh=
at
> garbled directory:
>=20
> [root@winggear archive]# df -k
> Filesystem           1k-blocks      Used Available Use% Mounted on
> /dev/hda5              1008952    149796    807904  16% /
> /dev/hda2             25134948  11767212  12090936  50% /home
> /dev/hda1             25134948   2299120  21559028  10% /usr
> /dev/hda4             25136164  18782060   5077244  79% /var
> /dev/md0              69616104  37240476  28839296  57% /usr/local/ar=
chive
>=20
> [root@winggear root]# cd /usr/local/archive/
>=20
> [root@winggear archive]# ls -l
> total 16
> ?-wSrwxr-T  38216 843638119 136403541 3092718354 May 21  1957 backup
> sr-x--S--t  62581 1917696496 1424539385 3344111388 Nov 13  1975 iso
> drwxr-xr-x    2 root     root        16384 Apr 26  2001 lost+found
> b--Sr-xrw-  24320 1593859840 1902061873  44,  49 Jul  8  2002 shares
>=20
> There should be four normal directory entries here.

Ough.  Bad bad.

>=20
> Anyone know what could have caused this?

Possibly raidreconf.   I am very suspicious about the spare-disk anomal=
y
that you saw - it is possible that raidreconf did "the bad thing" with
your array.

It is also possible that you have hardware errors, bad cabling, bad
disk, etc.  Anything suspicious in dmesg ?

It is really important to run fsck -f on arrays after running raidrecon=
f
and before re-sizing the filesystem.  For this reason - tracking of
when/where errors occurred.  Of course, it is a little late for you to
be told this now - sorry.  I should add this note to the raidreconf
output after successful reconfiguration.


I will try to see if I can dig out a SCSI crontroller from the crap-hea=
p
here at work, then I will see if I can reproduce the spare-disk error.

It is entirely possible that that is the reason for the screwup.

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
