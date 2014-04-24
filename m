From: "L.M.J" <linuxmasterjedi@free.fr>
Subject: Re: Corrupted ext4 filesystem after mdadm manipulation error
Date: Thu, 24 Apr 2014 21:53:35 +0200
Message-ID: <20140424215335.191ad6cc@netstation>
References: <20140424070548.445497dd@netstation>
	<20140424194832.2d0a867f@netstation>
	<CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com>
	<20140424203506.5fdee0d3@netstation>
	<CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Scott D'Vileskis <sdvileskis@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le Thu, 24 Apr 2014 15:39:11 -0400,
"Scott D'Vileskis" <sdvileskis@gmail.com> a =E9crit :

> Your data is split 3 ways.. 50% on one disk, 50% on another disk, and=
 one
> disk worth of parity.
>=20
> Now, it's not that simple, because the data is not continuous.. It is
> written across the three drives in chinks, with the parity alternatin=
g
> between the three drives.
>=20
> If you were able to recover 50%, it probably means one disk contains =
valid
> data.
>=20
> Were you able to recover anything larger than your chunk size? Are la=
rger
> files (Mp3s and or movies) actually playable? Likely not.

I ran a fsck on a snapshot lvm partition.
It recovered a 50% of the file, all of them are located in /lost+found/
Here is the size

5,5M 2013-04-24 17:53 #4456582
5,7M 2013-04-24 17:53 #4456589
 16M 2013-04-24 17:53 #4456590
 25M 2013-04-24 17:53 #4456594
 17M 2013-04-24 17:53 #4456578
 18M 2013-04-24 17:53 #4456580
1,3M 2013-04-24 17:54 #4456597
1,1M 2013-04-24 17:54 #4456596
 17M 2013-04-24 17:54 #4456595
2,1M 2013-04-24 17:54 #4456599
932K 2013-04-24 17:54 #4456598


> You might get lucky trying to assemble the array in degraded mode wit=
h the
> 2 good disks, as long as the array didn't resync your new disk + good=
 disk
> to the other good disk...
I try that already : re-assemble the array with the good disk and then =
add the new one. It didn't work as
expected.=20


> If added properly, it would have resynced the two good disks with the=
 blank
> disk. Try doing a 'hd /dev/sdb1' to see if there is data on the new d=
isk

~# hd /dev/sdb1=20
00000000  37 53 2f 78 4b 00 13 6f  41 43 55 5b 45 14 08 16  |7S/xK..oAC=
U[E...|
00000010  01 03 7e 2a 11 63 13 6f  6b 01 64 6b 03 07 1a 06  |..~*.c.ok.=
dk....|
00000020  04 56 44 00 46 2a 32 6e  02 4d 56 12 6d 54 6d 66  |.VD.F*2n.M=
V.mTmf|
00000030  4b 06 18 00 41 49 28 27  4c 38 30 6b 27 2d 1f 25  |K...AI('L8=
0k'-.%|
00000040  07 59 22 0c 19 5e 4c 39  25 2f 27 59 2f 7c 79 10  |.Y"..^L9%/=
'Y/|y.|
00000050  31 7a 4b 6e 53 49 41 56  13 39 15 4b 58 29 0f 15  |1zKnSIAV.9=
=2EKX)..|
00000060  0b 18 09 0f 6b 68 48 0e  7f 03 24 17 66 01 45 12  |....khH...=
$.f.E.|
00000070  31 1b 7e 1d 14 3c 10 0f  19 70 2d 05 10 2e 51 2a  |1.~..<...p=
-...Q*|
00000080  4e 54 3a 29 7f 00 45 5a  4d 3e 4c 26 1a 22 2b 57  |NT:)..EZM>=
L&."+W|
00000090  33 7e 46 51 41 56 79 2a  4e 45 3c 30 6f 1d 11 56  |3~FQAVy*NE=
<0o..V|
000000a0  4d 1e 64 07 2b 02 1d 01  31 11 58 49 45 5f 7e 2a  |M.d.+...1.=
XIE_~*|
000000b0  4e 45 57 67 00 16 00 54  4e 0f 55 10 1b 14 1c 00  |NEWg...TN.=
U.....|
000000c0  7f 58 58 45 54 5b 46 10  0d 2a 3a 7e 1c 08 11 45  |.XXET[F..*=
:~...E|
000000d0  53 54 7d 10 01 14 1e 07  48 52 54 10 3f 55 58 45  |ST}.....HR=
T.?UXE|
000000e0  64 61 2b 0a 19 1f 45 1d  1d 02 4b 7e 1d 1b 19 02  |da+...E...=
K~....|
000000f0  0d 4c 2a 4e 54 50 05 06  01 3e 17 0e 57 64 17 4f  |.L*NTP...>=
=2E.Wd.O|
00000100  4a 7f 42 7d 4c 52 09 49  53 45 43 1e 7c 6e 12 00  |J.B}LR.ISE=
C.|n..|
00000110  13 36 03 0b 12 50 4e 48  34 7e 7d 3a 45 12 28 51  |.6...PNH4~=
}:E.(Q|
00000120  2a 48 3e 3a 42 58 51 7a  2e 62 12 7e 4e 32 2a 17  |*H>:BXQz.b=
=2E~N2*.|
[...]


PS : Why in this list 'reply' answer to the previous email sender inste=
ad of the ML email address ?

>=20
> On Thu, Apr 24, 2014 at 2:35 PM, L.M.J <linuxmasterjedi@free.fr> wrot=
e:
>=20
> > Hello Scott,
> >
> >   Do you think I've lost my data 100% for sure ? fsck recovered 50%=
 of the
> > files, don't you thing there is
> >   still something to save ?
> >
> >  Thanks
> >
> >
> > Le Thu, 24 Apr 2014 14:13:05 -0400,
> > "Scott D'Vileskis" <sdvileskis@gmail.com> a =E9crit :
> >
> > > NEVER USE "CREATE" ON FILESYSTEMS OR RAID ARRAYS UNLESS YOU KNOW =
WHAT YOU
> > > ARE DOING!
> > > CREATE destroys things in the creation process, especially with t=
he
> > --force
> > > option.
> > >
> > > The create argument is only done to create a new array, it will s=
tart
> > with
> > > two drives as 'good' drives and the last will likely be the degra=
ded
> > drive,
> > > so it will start resyncing and blowing away data on the last driv=
e.  If
> > you
> > > used the --assume clean argument, and it DID NOT resync the drive=
s, you
> > > might be able to recreate the array with the two good disks, prov=
ided you
> > > know the original order.
> > >
> > > If you used the --create option, and didn't have your disks in th=
e same
> > > order they were originally in, you probably lost your data.
> > >
> > > Since you replaced a disk, with no data (or worse, with bad data)=
, you
> > > should have assembled the array, in degraded mode WITHOUT the
> > > --assume-clean argument.
> > >
> > > If C & D contain your data, and B used to..
> > > mdadm --assemble /dev/md0 missing /dev/sdc1 /dev/sdd1
> > > You might have to --force the assembly. If it works, and it runs =
in
> > > degraded mode, mount your filesystem and take a backup.
> > >
> > > Next, then add your replacement drive back in:
> > > mdadm --add /dev/md0 /dev/sdb1
> > > (Note, if sdb1 has some superblock data, you might have to
> > > --zero-superblock first)
> > >
> > >
> > > Good luck.
> > >
> > >
> > > On Thu, Apr 24, 2014 at 1:48 PM, L.M.J <linuxmasterjedi@free.fr> =
wrote:
> > >
> > > > Up please :-(
> > > >
> > > > Le Thu, 24 Apr 2014 07:05:48 +0200,
> > > > "L.M.J" <linuxmasterjedi@free.fr> a =E9crit :
> > > >
> > > > > Hi,
> > > > >
> > > > > For the third time, I had to change a failed drive from my ho=
me linux
> > > > RAID5 box. Previous one went right and
> > > > > this time, I don't know what I did wrong, but I broke my RAID=
5.
> > Well, at
> > > > least, he didn't want to
> > > > > start. /dev/sdb was the failed drive /dev/sdc and /dev/sdd ar=
e OK.
> > > > >
> > > > > I tried to reassemble the RAID with this command after I repl=
ace sdb
> > and
> > > > create a new partition :
> > > > >
> > > > >  ~# mdadm -Cv /dev/md0 --assume-clean --level=3D5 --raid-devi=
ces=3D3
> > > > /dev/sdc1 /dev/sdd1 /dev/sdb1
> > > > > -> '-C' was not a good idea here
> > > > >
> > > > > Well, I guess I did an another mistake here, I should have do=
ne this
> > > > instead :
> > > > >  ~# mdadm -Av /dev/md0 --assume-clean --level=3D5 --raid-devi=
ces=3D3
> > > > /dev/sdc1 /dev/sdd1 missing
> > > > >
> > > > > Maybe this wipe out my data...
> > > > > Let's go futher, then, pvdisplay, pvscan, vgdisplay returns e=
mpty
> > > > information
> > > > >
> > > > > Google helped me, and I did this :
> > > > >  ~# dd if=3D/dev/md0 bs=3D512 count=3D255 skip=3D1 of=3D/tmp/=
md0.txt
> > > > >
> > > > >       [..]
> > > > >       physical_volumes {
> > > > >               pv0 {
> > > > >                       id =3D "5DZit9-6o5V-a1vu-1D1q-fnc0-syEj=
-kVwAnW"
> > > > >                       device =3D "/dev/md0"
> > > > >                       status =3D ["ALLOCATABLE"]
> > > > >                       flags =3D []
> > > > >                       dev_size =3D 7814047360
> > > > >                       pe_start =3D 384
> > > > >                       pe_count =3D 953863
> > > > >               }
> > > > >       }
> > > > >       logical_volumes {
> > > > >
> > > > >               lvdata {
> > > > >                       id =3D "JiwAjc-qkvI-58Ru-RO8n-r63Z-ll3E=
-SJazO7"
> > > > >                       status =3D ["READ", "WRITE", "VISIBLE"]
> > > > >                       flags =3D []
> > > > >                       segment_count =3D 1
> > > > >       [..]
> > > > >
> > > > > Since I saw lvm information, I guess I haven't lost all infor=
mation
> > > > yet...
> > > > >
> > > > > I tried an unhoped command :
> > > > >  ~# pvcreate --uuid "5DZit9-6o5V-a1vu-1D1q-fnc0-syEj-kVwAnW"
> > > > > --restorefile /etc/lvm/archive/lvm-raid_00302.vg /dev/md0 The=
n,
> > > > >
> > > > >  ~# vgcfgrestore lvm-raid
> > > > >
> > > > >  ~# lvs -a -o +devices
> > > > >    LV     VG       Attr   LSize   Origin Snap%  Move Log Copy=
%
> >  Convert
> > > >  Devices
> > > > >    lvdata lvm-raid -wi-a- 450,00g
> > > >               /dev/md0(148480)
> > > > >    lvmp   lvm-raid -wi-a-  80,00g
> > > >               /dev/md0(263680)
> > > > > Then :
> > > > >  ~# lvchange -ay /dev/lvm-raid/lv*
> > > > >
> > > > > I was quite happy until now.
> > > > > Problem appears now when I try to mount those 2 LV (lvdata & =
lvmp) as
> > > > ext4 partition :
> > > > >  ~# mount /home/foo/RAID_mp/
> > > > >
> > > > >  ~# mount | grep -i mp
> > > > >       /dev/mapper/lvm--raid-lvmp on /home/foo/RAID_mp type ex=
t4 (rw)
> > > > >
> > > > >  ~# df -h /home/foo/RAID_mp
> > > > >       Filesystem                            Size  Used Avail =
Use%
> > > > Mounted on
> > > > >       /dev/mapper/lvm--raid-lvmp   79G   61G   19G  77%
> > > > /home/foo/RAID_mp
> > > > >
> > > > > Here is the big problem
> > > > >  ~# ls -la /home/foo/RAID_mp
> > > > >       total 0
> > > > >
> > > > > I did a LVM R/W snapshot on the /dev/mapper/lvm--raid-lvmp LV=
, I fsck
> > > > it. I recover 50% of the files only,
> > > > > all located in lost-+found/ directory with names heading with=
 #xxxxx.
> > > > >
> > > > > I would like to know if there is a last chance to recover my =
data ?
> > > > >
> > > > > Thanks
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe
> > linux-raid" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info=
=2Ehtml
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux=
-raid"
> > in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
> > > >
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
