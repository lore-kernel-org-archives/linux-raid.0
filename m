From: NeilBrown <neilb@suse.de>
Subject: Re: degraded raid 6 (1 bad drive) showing up inactive, only spares
Date: Sun, 10 Jun 2012 08:09:13 +1000
Message-ID: <20120610080913.445d3cea@notabene.brown>
References: <B5902F16-9C82-4072-BD67-FC6D6488ADB7@googlemail.com>
	<20120607222933.14ec3cd5@notabene.brown>
	<CAGHsWsm_Xvf59VCuHyJvoMW6peiFHK=YQKGzr3cq=RDk7jyqKg@mail.gmail.com>
	<20120608071412.5408516f@notabene.brown>
	<C9680CD3-8DA8-4FE3-8337-481676213C39@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WNRu6L_xjF2=F9gRfaP7mTG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C9680CD3-8DA8-4FE3-8337-481676213C39@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Ziler <martin.ziler@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WNRu6L_xjF2=F9gRfaP7mTG
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 9 Jun 2012 20:14:12 +0200 Martin Ziler <martin.ziler@googlemail.com>
wrote:

>=20
> Am 07.06.2012 um 23:14 schrieb NeilBrown:
>=20
> > On Thu, 7 Jun 2012 18:49:49 +0200 Martin Ziler <martin.ziler@googlemail=
.com>
> > wrote:
> >=20
> >> 2012/6/7 NeilBrown <neilb@suse.de>
> >>=20
> >>> On Thu, 7 Jun 2012 13:55:32 +0200 Martin Ziler <
> >>> martin.ziler@googlemail.com>
> >>> wrote:
> >>>=20
> >>>> Hello everybody,
> >>>>=20
> >>>> I am running a 9-disk raid6 without hot spares. I already had one dr=
ive
> >>> go bad, which I could replace and continue using the array without any
> >>> degraded raid messages. Recently I had another drive going bad by the
> >>> smart-info. As it wasn't quite dead I left the array as was without r=
eally
> >>> using it all that much waiting for a replacement drive I ordered. As I
> >>> booted the machine up in order to replace the drive I was greeted by =
an
> >>> inactive array with all devices showing up as spares.
> >>>>=20
> >>>> md0 : inactive sdh2[0](S) sdi2[7](S) sde2[6](S) sdd2[5](S) sdf2[1](S)
> >>> sdg2[2](S) sdc1[9](S) sdb2[3](S)
> >>>>      15579088439 blocks super 1.2
> >>>>=20
> >>>> mdadm --examine confirms that. I already searched the web quite a bit
> >>> and found this mailing list. Maybe someone in here can give me some i=
nput.
> >>> Normally a degraded raid should still be active. So I am quite surpri=
sed
> >>> that my array with only one drive missing goes inactive. I appended t=
he
> >>> info mdadm --examine puts out for all the drives. However the first t=
wo
> >>> should probably suffice as only /dev/sdk differs from the rest. The f=
aulty
> >>> drive - sdk - is still recognized as a raid6 member, wheres all the o=
thers
> >>> show up as spares. With lots of bad sectors sdk isn't accessible anym=
ore.
> >>>=20
> >>> You must be running 3.2.1 or 3.3 (I think).
> >>>=20
> >>> You've been bitten by a rather nasty bug.
> >>>=20
> >>> You can get your data back, but it will require a bit of care, so don=
't
> >>> rush
> >>> it.
> >>>=20
> >>> The metadata on almost all the devices have been seriously corrupted.=
  The
> >>> only way to repair it is to recreate the array.
> >>> Doing this just writes new metadata and assembles the array.  It does=
n't
> >>> touch
> >>> the data so if we get the --create command right, all your data will =
be
> >>> available again.
> >>> If we get it wrong, you won't be able to see your data, but we can ea=
sily
> >>> stop
> >>> the array and create again with different parameters until we get it =
right.
> >>>=20
> >>> First thing to do it to get a newer kernel.  I would recommend the la=
test
> >>> in
> >>> the 3.3.y series.
> >>>=20
> >>> Then you need to:
> >>> - make sure you have a version of mdadm which gets the data offset to=
 1M
> >>>  (2048 sectors).  I think 3.2.3 or earlier does that - don't upgrade =
to
> >>>  3.2.5.
> >>> - find the chunk size - looks like it is 4M, as sdk2 isn't corrupt.
> >>> - find the order of devices.  This should be in your kernel logs in
> >>>   "RAID conf printout".  Hopefully device names haven't changed.
> >>>=20
> >>> Then (with new kernel running)
> >>>=20
> >>> mdadm --create /dev/md0 -l6 -n9 -c 4M -e 1.2 /dev/sdb2 /dev/sdc2
> >>> /dev/sdd2 \
> >>>    /dev/sde2 /dev/sdf2 /dev/sdg2 /dev/sdh2 /dev/sdi2 missing \
> >>>    --assume-clean
> >>>=20
> >>> Make double-sure you add that --assume-clean.
> >>>=20
> >>> Note the last device is 'missing'. That corresponds to sdk2 (which we
> >>> know is device 8 - the last of 9 (0..8)).  It fails so it not part of=
 the
> >>> array any more.  The others I just guessed the order.  You should try=
 to
> >>> verify it before you proceed (see RAID conf printout in kernel logs).
> >>>=20
> >>> After the 'create' use "mdadm -E" to look at one device and make sure
> >>> the Data Offset, Avail Dev Size and Array Size are the same as we saw
> >>> on sdk2.
> >>> If it is, try "fsck -n /dev/md0". That assumes ext3 or ext4.  If you =
had
> >>> something else on the array some other command might be needed.
> >>>=20
> >>> If that looks bad, "mdadm -S /dev/md0" and try again with a different
> >>> order.
> >>> If it looks good, "echo check > /sys/block/md0/md/sync_action" and wa=
tch
> >>> "mismatch_cnt" in the same directory.  If it says low (few hundred at
> >>> most)
> >>> all is good.  If it goes up to thousands something is wrong - try ano=
ther
> >>> order.
> >>>=20
> >>> Once you have the array working again,
> >>>   "echo repair > /sys/block/md0/md/sync_action"
> >>> then add your new device to be rebuilt.
> >>>=20
> >>> Good luck.
> >>> Please ask if you are unsure about anything.
> >>>=20
> >>> NeilBrown
> >>>=20
> >>>=20
> >>=20
> >> Hello Neil,
> >>=20
> >> thank you very much for this detailed input. My last reply didn't make=
 it
> >> into the mailing list due to the format of my mail client (OSX mail). =
My
> >> kernel (Ubuntu) was 3.2.0 , I upgraded to 3.3.8. mdadm version was fin=
e.
> >>=20
> >> I searched the log files I got and was unable to find anything concern=
ing
> >> my array. Maybe that sorta stuff isn't logged in ubuntu. I did find so=
me
> >> mails concerning degraded raid that do not correlate with my current
> >> breakage. I received the following 2 messages:
> >>=20
> >> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> >> [raid4] [raid10]
> >> md0 : active (auto-read-only) raid6 sdi2[1] sdh2[0] sdg2[8] sdc1[9] sd=
d2[5]
> >> sdb2[3] sdf2[7] sde2[6]
> >>      13586485248 blocks super 1.2 level 6, 4096k chunk, algorithm 2 [9=
/8]
> >> [UU_UUUUUU]
> >>=20
> >> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> >> [raid4] [raid10]
> >> md0 : active (auto-read-only) raid6 sdj2[2] sdg2[8] sdd2[5] sde2[6] sd=
b2[3]
> >> sdf2[7] sdc1[9]
> >>      13586485248 blocks super 1.2 level 6, 4096k chunk, algorithm 2 [9=
/7]
> >> [__UUUUUUU]
> >>=20
> >> I conclude that my setup must have been sdh2 [0], sdi2 [1], sdj2 [2], =
sdb2
> >> [3], sdd2 [5] , sde2 [6], sdf2 [7], sdg2 [8], sdc1 [9]
> >=20
> > Unfortunately these number are not the roles of the device in the array=
.  They
> > are the order in which the devices were added to the array.
> > So 0-8 are very likely roles 0-8 in the array.  '9' is then the first s=
pare,
> > and it stays as '9' even when it becomes active.  So as there is no '4'=
, it
> > does look likely that 'sdc1' should come between  'sdb2' and 'sdd2'.
> >=20
> > NeilBrown
> >=20
> >=20
> >> sdc1 is the replacement for my first drive that went bad. It's somewhat
> >> strange that it is now listed as device 9 and not 4, isn't it? I reckon
> >> that I have to rebuild in that order, notwithstanding.
> >>=20
> >> regards,
> >> Martin
> >=20
>=20
>=20
> Hello Neil,
>=20
> I tracked the cables in my case and tried some permutations:
>=20
> mdadm --create /dev/md0 -l6 -n9 -c 4M -e 1.2 /dev/sdh2 /dev/sdi2 /dev/sdj=
2 /dev/sdb2 /dev/sdc1 /dev/sdd2 /dev/sde2 /dev/sdf2 missing --assume-clean
> mdadm --create /dev/md0 -l6 -n9 -c 4M -e 1.2 /dev/sdj2 /dev/sdb2 /dev/sdc=
1 /dev/sdd2 /dev/sde2 /dev/sdf2 missing /dev/sdh2 /dev/sdi2 --assume-clean
> mdadm --create /dev/md0 -l6 -n9 -c 4M -e 1.2   /dev/sdj2 /dev/sdb2 /dev/s=
dc1 /dev/sdd2 /dev/sde2 /dev/sdh2 missing /dev/sdf2 /dev/sdi2 --assume-clean
> mdadm --create /dev/md0 -l6 -n9 -c 4M -e 1.2   /dev/sdj2 /dev/sdb2 /dev/s=
dc1 /dev/sdd2 /dev/sde2 /dev/sdi2 missing /dev/sdf2 /dev/sdh2 --assume-clean
> mdadm --create /dev/md0 -l6 -n9 -c 4M -e 1.2 /dev/sdi2 /dev/sdh2 /dev/sdj=
2 /dev/sdb2 /dev/sdc1 /dev/sdd2 /dev/sde2 /dev/sdf2 missing --assume-clean
>=20
> The first ones did result in metadata that looked fine but the fsck-outpu=
t did not look good at all:
>=20
> e2fsck 1.42 (29-Nov-2011)
> fsck.ext4: Superblock ung=FCltig versuche es mit Backup-Bl=F6cken...
> fsck.ext4: Ung=FCltige magische Zahl im Superblock beim Versuch, /dev/md0=
 zu =F6ffnen
>=20
> SuperBlock ist unlesbar bzw. beschreibt kein g=FCltiges ext2
> Dateisystem.  Wenn Ger=E4t g=FCltig ist und ein ext2
> Dateisystem (kein swap oder ufs usw.) enth=E4lt,  dann ist der SuperBlock
> besch=E4digt, und sie k=F6nnten e2fsck mit einem anderen SuperBlock:
>     e2fsck -b 8193 <Ger=E4t>
>=20
> The last one resulted in this fsck output:
>=20
> e2fsck 1.42 (29-Nov-2011)
> fsck.ext4: Gruppen-Deskriptoren scheinen defekt zu sein... versuche es mi=
t Backup-Bl=F6cken...
> fsck.ext4: Ung=FCltige magische Zahl im Superblock when using the backup =
blocks
> fsck.ext4: es wird zum originalen Superblock zur=FCck gekehrt
> fsck.ext4: Gruppen-Deskriptoren scheinen defekt zu sein... versuche es mi=
t Backup-Bl=F6cken...
> fsck.ext4: Ung=FCltige magische Zahl im Superblock when using the backup =
blocks
> fsck.ext4: es wird zum originalen Superblock zur=FCck gekehrt
> Lesefehler - Block 3823364034 (Das Argument ist ung=FCltig). Ignoriere Fe=
hler? nein
>=20
> SuperBlock hat ein defektes Journal (Inode 8).
> Bereinige? nein
>=20
> fsck.ext4: Unzul=E4ssige Inodenummer w=E4hrend der Pr=FCfung des ext3-Jou=
rnals f=FCr /dev/md0
>=20
> /dev/md0: ********** WARNUNG: Noch Fehler im Dateisystem  **********
>=20
> If I interpret that correctly, the filesystem ext4 is now recognized. Do =
you think I should now go on with echo check > /sys/block/md0/md/sync_actio=
n?
>=20

The "echo check ...." is read-only and so harmless - you can do it any time
you like.  To stop it if it is showing lots of mismatches just "echo idle" =
to
the same file.

However that e2fsck output doesn't look good.
It does find a superblock, but then when it goes to look for "group
descriptors" they are bad.
Also: "Read error - block 3823364034 (Invalid argument)." (from
google-translate to English) suggests that the filesystem thinks the array =
is
bigger  than it is.

This probably suggests that the first device is the correct one, but other
devices are still in the wrong order.

I suggest some more permutations.  It shouldn't be too hard to write a scri=
pt
to try them all... might take a little while though.

The following script, if run with


sh permute.sh --prefix "mdadm --create /dev/md0 -l6 -n9 -c 4M -e 1.2 --assu=
me-clean" /dev/sdh2 /dev/sdi2 /dev/sdj2 /dev/sdb2 /dev/sdc1 /dev/sdd2 /dev/=
sde2 /dev/sdf2 missing

will output all possible "mdadm --create" commands with different
permutations.  Don't know if you want to try it or not.  There are only
362880 possibilities :-)  Can the 'echo' to 'eval', then add 'fsck -n /dev/=
md0' and 'mdadm -S /dev/md0' and  collect the output for examination the ne=
xt morning.

NeilBrown



#!/bin/sh

case $1 in
 --prefix )
   prefix=3D$2
   shift 2
   ;;
 * ) prefix=3D
esac

if [ $# -eq 1 ]
then echo $prefix $1
     exit 0
fi

early=3D
while [ $# -ge 1 ]
do
  a=3D$1
  shift
  sh permute.sh --prefix "$prefix $a" $early $*
  early=3D"$early $a"
done

--Sig_/WNRu6L_xjF2=F9gRfaP7mTG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9PJijnsnt1WYoG5AQJ1Og/9F5CBhSHg+1HAZDPQkkyou7nfh955YfRW
reGmQh3k9d9CpVKxVY85nHz5kgPoGf/puUl+EuwkhRcfHoZ083NSBsSBV2cYYYUf
0eSUEi8+00mJscgypg/KbTDVS3O9MkxTKS5Ocxm0rtPXucJ4yl/funCbRK6zfw0b
mP+xysIFyw7vAH5Rm2lPZezBw4nl+IhTMSF9QsPMQYQQonW+CHA01XF/RT5iqSlT
scbfy8eZZnCyh1rOajPGFTGBKdWWrvQLC75Z7ZSGzYBTW8aAbhZwyuXoH0Dufsul
Iyf2KIpbpsFARVoG+ulPkbRS1M6wvJfZ2zCPYQzBDkwAhZlVApPnfc4wAV1DdOrZ
Y1t/d2FT5oT/CvTX+F168mcGPhlez6bFw6e+kecZ5q9MiS7QBU47BXYfJt0NhPS3
BTf+hThDqFpy7TmU7r75Gf+LrMEEkmJE4hLh0IdYDKVZ4btHAXVrpks+adYz+Mv3
uK4oeHp14f5tBcuJW0TJ7YR3Y5wDlc6y9X17APSBGAVVI2U+Bcjb0o9+oft2/JhG
YU+rmE6DC16GK7v49mVO19jFtEYs3D4NBr7NR6dborDeTh/IzhcGEynQ48AzIWur
xcgdNLUvn3ale+gNtTWScfbhATfX7xkUF5OYhGBe6LA0hCtvyD6vqJjGe4MurgJE
xBhFk+LYH84=
=5o+Y
-----END PGP SIGNATURE-----

--Sig_/WNRu6L_xjF2=F9gRfaP7mTG--
