From: "Lewis Shobbrook" <lshobbrook@fasttrack.net.au>
Subject: RE: lilo fails on root raid 1 on 2.6.4
Date: Thu, 8 Apr 2004 17:32:10 +1000
Message-ID: <0C8098CA7F09CE419F0C2B68EB8358761EB885@exchange.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-testing=debian-testing=m.gmane.org@lists.debian.org>
Content-class: urn:content-classes:message
Resent-Message-ID: <XAvOj.A.BDB.J_PdAB@murphy>
List-Post: <mailto:debian-testing@lists.debian.org>
List-Help: <mailto:debian-testing-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-testing-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-testing-request@lists.debian.org?subject=unsubscribe>
List-Archive: <http://lists.debian.org/debian-testing/>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, debian-testing@lists.debian.org
List-Id: linux-raid.ids

Thanks for the reply Neil,
=20
> > Hi All,
> >=20
> > I've struck an issue attempting to run lilo when booting to=20
> a raid 1=20
> > system using a stock Debain 2.6.4-1-686 unstable release=20
> kernel image.
> >=20
> > After sucecssfully booting into the raid filesystem,=20
> attempts to run=20
> > lilo give me the error...
> >=20
> > Fatal: Trying to map files from unnamed device 0x0000=20
> (NFS/RAID mirror=20
> > down ?)
> >=20
>=20
> You probably need a "raid-extra-boot=3D" option in lilo.conf
> Just list the partition(s) that are currently active and it=20
> might work.


I've been able to apply the "raid-extra-boot=3D" option on an alternate
system and did a bit of toying around with the syntax to see what was
required and possible. All was well on the test machine, running the
same 2.6.4-1 kernel, however the problems persist....=20

With raid-extra-boot=3D/dev/hdc,hda  (hda being marked as failed)...

Fatal: Unable to open dev/hda

With raid-extra-boot=3D/dev/hdc ...
Fatal: Trying to map files from unnamed device 0x0000 (NFS/RAID mirror
down ?)

And with raid-extra-boot=3Dauto...=20

Warning: Boot sector on  /dev/md0  will depend upon the BIOS device code
  passed in the DL register being accurate.  Install Master Boot Records
  with the 'lilo -M' command, and activate the RAID1 partitions with the
  'lilo -A' command.
Fatal: Trying to map files from unnamed device 0x0000 (NFS/RAID mirror
down ?)

...=3D=3D>...

# lilo -M /dev/hda
/boot/boot.0300 exists - no /dev/hda backup copy made.

 *** oops, well at least I have a boot disk....

The Master Boot Record of  /dev/hda  has been updated.
# lilo -M /dev/hdc
Backup copy of /dev/hdc in /boot/boot.1600
The Master Boot Record of  /dev/hdc  has been updated.
# lilo -A /dev/hdc
/dev/hdc2
# lilo -A /dev/hda
/dev/hda2
# lilo
Warning: Boot sector on  /dev/md0  will depend upon the BIOS device code
  passed in the DL register being accurate.  Install Master Boot Records
  with the 'lilo -M' command, and activate the RAID1 partitions with the
  'lilo -A' command.
Fatal: Trying to map files from unnamed device 0x0000 (NFS/RAID mirror
down ?)

Perhaps it may be due stale bios HDD detection as...
lilo -T geom

    bios=3D0x00, cylinders=3D80, heads=3D2, sectors=3D18
        (  1.44Mb         2,880 sectors)        C:H:S supported (IBM PC
bios)

BIOS reports 2 hard drives
    bios=3D0x80, cylinders=3D1022, heads=3D255, sectors=3D63    vol-ID: =
95759575
        (  8.40Gb    16,418,430 sectors)        LBA32 supported (EDD
bios)
    bios=3D0x81, cylinders=3D1022, heads=3D255, sectors=3D63    vol-ID: =
3A19FFA5
        (  8.40Gb    16,418,430 sectors)        LBA32 supported (EDD
bios)

And I know the Hard drives are not the same size and neither are 8.40 Gb

Cheers,

Lewis
