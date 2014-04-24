From: "L.M.J" <linuxmasterjedi@free.fr>
Subject: Re: Corrupted ext4 filesystem after mdadm manipulation error
Date: Thu, 24 Apr 2014 20:35:06 +0200
Message-ID: <20140424203506.5fdee0d3@netstation>
References: <20140424070548.445497dd@netstation>
	<20140424194832.2d0a867f@netstation>
	<CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott D'Vileskis <sdvileskis@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Scott,

  Do you think I've lost my data 100% for sure ? fsck recovered 50% of =
the files, don't you thing there is
  still something to save ?

 Thanks


Le Thu, 24 Apr 2014 14:13:05 -0400,
"Scott D'Vileskis" <sdvileskis@gmail.com> a =E9crit :

> NEVER USE "CREATE" ON FILESYSTEMS OR RAID ARRAYS UNLESS YOU KNOW WHAT=
 YOU
> ARE DOING!
> CREATE destroys things in the creation process, especially with the -=
-force
> option.
>=20
> The create argument is only done to create a new array, it will start=
 with
> two drives as 'good' drives and the last will likely be the degraded =
drive,
> so it will start resyncing and blowing away data on the last drive.  =
If you
> used the --assume clean argument, and it DID NOT resync the drives, y=
ou
> might be able to recreate the array with the two good disks, provided=
 you
> know the original order.
>=20
> If you used the --create option, and didn't have your disks in the sa=
me
> order they were originally in, you probably lost your data.
>=20
> Since you replaced a disk, with no data (or worse, with bad data), yo=
u
> should have assembled the array, in degraded mode WITHOUT the
> --assume-clean argument.
>=20
> If C & D contain your data, and B used to..
> mdadm --assemble /dev/md0 missing /dev/sdc1 /dev/sdd1
> You might have to --force the assembly. If it works, and it runs in
> degraded mode, mount your filesystem and take a backup.
>=20
> Next, then add your replacement drive back in:
> mdadm --add /dev/md0 /dev/sdb1
> (Note, if sdb1 has some superblock data, you might have to
> --zero-superblock first)
>=20
>=20
> Good luck.
>=20
>=20
> On Thu, Apr 24, 2014 at 1:48 PM, L.M.J <linuxmasterjedi@free.fr> wrot=
e:
>=20
> > Up please :-(
> >
> > Le Thu, 24 Apr 2014 07:05:48 +0200,
> > "L.M.J" <linuxmasterjedi@free.fr> a =E9crit :
> >
> > > Hi,
> > >
> > > For the third time, I had to change a failed drive from my home l=
inux
> > RAID5 box. Previous one went right and
> > > this time, I don't know what I did wrong, but I broke my RAID5. W=
ell, at
> > least, he didn't want to
> > > start. /dev/sdb was the failed drive /dev/sdc and /dev/sdd are OK=
=2E
> > >
> > > I tried to reassemble the RAID with this command after I replace =
sdb and
> > create a new partition :
> > >
> > >  ~# mdadm -Cv /dev/md0 --assume-clean --level=3D5 --raid-devices=3D=
3
> > /dev/sdc1 /dev/sdd1 /dev/sdb1
> > > -> '-C' was not a good idea here
> > >
> > > Well, I guess I did an another mistake here, I should have done t=
his
> > instead :
> > >  ~# mdadm -Av /dev/md0 --assume-clean --level=3D5 --raid-devices=3D=
3
> > /dev/sdc1 /dev/sdd1 missing
> > >
> > > Maybe this wipe out my data...
> > > Let's go futher, then, pvdisplay, pvscan, vgdisplay returns empty
> > information
> > >
> > > Google helped me, and I did this :
> > >  ~# dd if=3D/dev/md0 bs=3D512 count=3D255 skip=3D1 of=3D/tmp/md0.=
txt
> > >
> > >       [..]
> > >       physical_volumes {
> > >               pv0 {
> > >                       id =3D "5DZit9-6o5V-a1vu-1D1q-fnc0-syEj-kVw=
AnW"
> > >                       device =3D "/dev/md0"
> > >                       status =3D ["ALLOCATABLE"]
> > >                       flags =3D []
> > >                       dev_size =3D 7814047360
> > >                       pe_start =3D 384
> > >                       pe_count =3D 953863
> > >               }
> > >       }
> > >       logical_volumes {
> > >
> > >               lvdata {
> > >                       id =3D "JiwAjc-qkvI-58Ru-RO8n-r63Z-ll3E-SJa=
zO7"
> > >                       status =3D ["READ", "WRITE", "VISIBLE"]
> > >                       flags =3D []
> > >                       segment_count =3D 1
> > >       [..]
> > >
> > > Since I saw lvm information, I guess I haven't lost all informati=
on
> > yet...
> > >
> > > I tried an unhoped command :
> > >  ~# pvcreate --uuid "5DZit9-6o5V-a1vu-1D1q-fnc0-syEj-kVwAnW"
> > > --restorefile /etc/lvm/archive/lvm-raid_00302.vg /dev/md0 Then,
> > >
> > >  ~# vgcfgrestore lvm-raid
> > >
> > >  ~# lvs -a -o +devices
> > >    LV     VG       Attr   LSize   Origin Snap%  Move Log Copy%  C=
onvert
> >  Devices
> > >    lvdata lvm-raid -wi-a- 450,00g
> >               /dev/md0(148480)
> > >    lvmp   lvm-raid -wi-a-  80,00g
> >               /dev/md0(263680)
> > > Then :
> > >  ~# lvchange -ay /dev/lvm-raid/lv*
> > >
> > > I was quite happy until now.
> > > Problem appears now when I try to mount those 2 LV (lvdata & lvmp=
) as
> > ext4 partition :
> > >  ~# mount /home/foo/RAID_mp/
> > >
> > >  ~# mount | grep -i mp
> > >       /dev/mapper/lvm--raid-lvmp on /home/foo/RAID_mp type ext4 (=
rw)
> > >
> > >  ~# df -h /home/foo/RAID_mp
> > >       Filesystem                            Size  Used Avail Use%
> > Mounted on
> > >       /dev/mapper/lvm--raid-lvmp   79G   61G   19G  77%
> > /home/foo/RAID_mp
> > >
> > > Here is the big problem
> > >  ~# ls -la /home/foo/RAID_mp
> > >       total 0
> > >
> > > I did a LVM R/W snapshot on the /dev/mapper/lvm--raid-lvmp LV, I =
fsck
> > it. I recover 50% of the files only,
> > > all located in lost-+found/ directory with names heading with #xx=
xxx.
> > >
> > > I would like to know if there is a last chance to recover my data=
 ?
> > >
> > > Thanks
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
