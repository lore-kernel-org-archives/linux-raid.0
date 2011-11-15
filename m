From: NeilBrown <neilb@suse.de>
Subject: Re: raid startup on a live CD?
Date: Wed, 16 Nov 2011 08:15:01 +1100
Message-ID: <20111116081501.05c451e5@notabene.brown>
References: <CABTDG88XS6HeGbhj1=iApvsFfifbdjLrO-eoJ4TxNcEcNoyRQg@mail.gmail.com>
	<20111115160358.5653769c@notabene.brown>
	<CABTDG8-aV0q0_TF3LV2eDcXNU-jrW0atftMToo+wrM=7LtRkLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/t2qs4=eiZE4FZuQ5xoJVwTM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABTDG8-aV0q0_TF3LV2eDcXNU-jrW0atftMToo+wrM=7LtRkLw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hank Barta <hbarta@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/t2qs4=eiZE4FZuQ5xoJVwTM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Nov 2011 14:51:51 -0600 Hank Barta <hbarta@gmail.com> wrote:

> Here is a copy of the session.

Thanks.

It looks like you have an /etc/mdadm.conf file which lists /dev/md2,
/dev/md0 and /dev/md1 and has uuids for them which do not match the uuids of
any devices that are found.

Does the boot cd have /etc/mdadm.conf (or /etc/mdadm/mdadm.conf) ??

Try:

  mdadm --assemble --scan --verbose --config=3Dpartitions

That will cause it to ignore and mdadm.conf file.

NeilBrown


> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> root@debian:/home/user# cat /proc/mdstat
> Personalities :
> unused devices: <none>
> root@debian:/home/user# lsmod|grep raid
> root@debian:/home/user# lsmod|grep md
> md_mod                 73872  0
> edac_mce_amd            6433  0
> root@debian:/home/user# mdadm --assemble --scan --incremental --verbose
> mdadm: --incremental would set mdadm mode to "incremental", but it is
> already set to "assemble".
> root@debian:/home/user# mdadm --assemble --scan  --verbose
> mdadm: looking for devices for /dev/md2
> mdadm: cannot open device /dev/loop0: Device or resource busy
> mdadm: /dev/loop0 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdc1
> mdadm: /dev/sdc1 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdc
> mdadm: /dev/sdc has wrong uuid.
> mdadm: /dev/sdb9 has wrong uuid.
> mdadm: /dev/sdb8 has wrong uuid.
> mdadm: /dev/sdb7 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdb6
> mdadm: /dev/sdb6 has wrong uuid.
> mdadm: /dev/sdb5 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdb2
> mdadm: /dev/sdb2 has wrong uuid.
> mdadm: /dev/sdb1 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdb
> mdadm: /dev/sdb has wrong uuid.
> mdadm: /dev/sda9 has wrong uuid.
> mdadm: /dev/sda8 has wrong uuid.
> mdadm: /dev/sda7 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sda6
> mdadm: /dev/sda6 has wrong uuid.
> mdadm: /dev/sda5 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sda2
> mdadm: /dev/sda2 has wrong uuid.
> mdadm: /dev/sda1 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sda
> mdadm: /dev/sda has wrong uuid.
> mdadm: looking for devices for /dev/md0
> mdadm: cannot open device /dev/loop0: Device or resource busy
> mdadm: /dev/loop0 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdc1
> mdadm: /dev/sdc1 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdc
> mdadm: /dev/sdc has wrong uuid.
> mdadm: /dev/sdb9 has wrong uuid.
> mdadm: /dev/sdb8 has wrong uuid.
> mdadm: /dev/sdb7 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdb6
> mdadm: /dev/sdb6 has wrong uuid.
> mdadm: /dev/sdb5 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdb2
> mdadm: /dev/sdb2 has wrong uuid.
> mdadm: /dev/sdb1 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdb
> mdadm: /dev/sdb has wrong uuid.
> mdadm: /dev/sda9 has wrong uuid.
> mdadm: /dev/sda8 has wrong uuid.
> mdadm: /dev/sda7 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sda6
> mdadm: /dev/sda6 has wrong uuid.
> mdadm: /dev/sda5 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sda2
> mdadm: /dev/sda2 has wrong uuid.
> mdadm: /dev/sda1 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sda
> mdadm: /dev/sda has wrong uuid.
> mdadm: looking for devices for /dev/md1
> mdadm: cannot open device /dev/loop0: Device or resource busy
> mdadm: /dev/loop0 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdc1
> mdadm: /dev/sdc1 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdc
> mdadm: /dev/sdc has wrong uuid.
> mdadm: /dev/sdb9 has wrong uuid.
> mdadm: /dev/sdb8 has wrong uuid.
> mdadm: /dev/sdb7 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdb6
> mdadm: /dev/sdb6 has wrong uuid.
> mdadm: /dev/sdb5 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdb2
> mdadm: /dev/sdb2 has wrong uuid.
> mdadm: /dev/sdb1 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sdb
> mdadm: /dev/sdb has wrong uuid.
> mdadm: /dev/sda9 has wrong uuid.
> mdadm: /dev/sda8 has wrong uuid.
> mdadm: /dev/sda7 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sda6
> mdadm: /dev/sda6 has wrong uuid.
> mdadm: /dev/sda5 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sda2
> mdadm: /dev/sda2 has wrong uuid.
> mdadm: /dev/sda1 has wrong uuid.
> mdadm: no recogniseable superblock on /dev/sda
> mdadm: /dev/sda has wrong uuid.
> root@debian:/home/user# cat /proc/mdstat
> Personalities :
> unused devices: <none>
> root@debian:/home/user#
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>  I forgot to include this which looks the same on a normal boot:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> hbarta@olive:~$ sudo fdisk -l /dev/sd[ab]
> Disk /dev/sda: 200.0 GB, 200049647616 bytes
> 255 heads, 63 sectors/track, 24321 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00014d21
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *           1         124      995998+  fd  Linux raid autode=
tect
> /dev/sda2             125       24321   194362372    5  Extended
> /dev/sda5             125        1369    10000431   fd  Linux raid autode=
tect
> /dev/sda6            1370        1867     4000153+  82  Linux swap / Sola=
ris
> /dev/sda7            1868        2824     7680000   fd  Linux raid autode=
tect
> /dev/sda8            2824        3767     7577600   fd  Linux raid autode=
tect
> /dev/sda9            3767       24321   165101083   fd  Linux raid autode=
tect
>=20
> Disk /dev/sdb: 200.0 GB, 200049647616 bytes
> 255 heads, 63 sectors/track, 24321 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x000c071b
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1   *           1         124      995998+  fd  Linux raid autode=
tect
> /dev/sdb2             125       24321   194362372    5  Extended
> /dev/sdb5             125        1369    10000431   fd  Linux raid autode=
tect
> /dev/sdb6            1370        1867     4000153+  82  Linux swap / Sola=
ris
> /dev/sdb7            1868        2824     7680000   fd  Linux raid autode=
tect
> /dev/sdb8            2824        3767     7577600   fd  Linux raid autode=
tect
> /dev/sdb9            3767       24321   165101083   fd  Linux raid autode=
tect
> hbarta@olive:~$
> hbarta@olive:~$ cat /proc/mdstat
> Personalities : [raid0] [raid1] [linear] [multipath] [raid6] [raid5]
> [raid4] [raid10]
> md4 : active raid0 sda8[0] sdb8[1]
>       15155072 blocks 64k chunks
>=20
> md0 : active raid1 sda1[0] sdb1[1]
>       995904 blocks [2/2] [UU]
>=20
> md2 : active raid0 sdb7[1] sda7[0]
>       15359872 blocks 64k chunks
>=20
> md1 : active raid0 sdb5[1] sda5[0]
>       20000640 blocks 64k chunks
>=20
> md3 : active raid1 sda9[1] sdb9[0]
>       165100992 blocks [2/2] [UU]
>=20
> unused devices: <none>
> hbarta@olive:~$
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> I found nothing related to this in dmesg or any of the logs I checked.
>=20
> thanks,
> hank
>=20
> On Mon, Nov 14, 2011 at 11:03 PM, NeilBrown <neilb@suse.de> wrote:
> >
> >
> > Could you try again, but add --verbose to --incremental --scan,
> > report the output, and any message that appear in 'dmesg'.
> >
> > thanks,
> > NeilBrown
> >
> >
> >
> > On Mon, 14 Nov 2011 22:56:40 -0600 Hank Barta <hbarta@gmail.com> wrote:
> >
> >> Hi folks,
> >> On occasion I boot a live CD and need to have the md RAID devices
> >> running. Ordinarily (with Ubuntu live CDs) I find that I need to
> >> install the mdadm package after booting the live CD. At that point my
> >> recollection is that the RAID devices get started by the scripts that
> >> perform the installation (and probably run the startup scripts that
> >> are in /etc/init.d/...)
> >>
> >> Earlier today I did this with a distro that is derived from Debian and
> >> under development. I was happy to see that 'mdadm' was already
> >> installed. (I had asked for this in fact.) But then I started
> >> encountering difficulties. The /proc/mdstat file existed but listed no
> >> RAID personalities and none of my devices were started. I tried 'mdadm
> >> --assemble -scan' which reported no errors but did not improve the
> >> situation. I manually loaded the raid0 and raid1 modules (which caused
> >> the personalities to be listed in /prod/mdstat) and pulled in other
> >> raid related kernel modules. However 'mdadm --assemble -scan' still
> >> did not start my devices. I thrashed around a bit before finding a
> >> command that probed drives and listed the md devices and their UUIDs.
> >> I was then able to start them using 'mdadm --assemble /dev/md<n>
> >> --uuid <UUID>' individually for the RAID devices I wanted to start.
> >>
> >> I'd like to report back to the person working on this distro the
> >> difficulties I had with the RAID and beyond that, I'd like to provide
> >> the information that they need to set up RAID so it just works (like
> >> on a normal boot) if possible and desirable.
> >>
> >> First... Are there reasons that other live CDs I've used have not set
> >> up RAID? Live CDs by their nature are somewhat lightweight so if
> >> adding mdadm uses significant resources perhaps it is best left as a
> >> manual operation.
> >>
> >> Is there something I overlooked in getting it started in this
> >> particular situation?
> >>
> >> Where should I be looking for documentation that would help
> >> configuring RAID on a Live CD? I did some searching and the most
> >> promising thing I found was
> >> https://raid.wiki.kernel.org/articles/r/a/i/RAID_Boot_bac9.html which
> >> directs me to a text file in the kernel source tree.
> >> (http://lxr.linux.no/#linux+v3.1.1/Documentation/filesystems/ramfs-roo=
tfs-initramfs.txt)
> >> And that points to other documentation. I'd appreciate pointers to
> >> documentation that is particularly relevant to md RAID form a live CD.
> >>
> >> many thanks,
> >> hank
> >>
> >> --
> >> '03 BMW F650CS - hers
> >> '98 Dakar K12RS - "BABY K" grew up.
> >> '93 R100R w/ Velorex 700 (MBD starts...)
> >> '95 Miata - "OUR LC"
> >> polish visor: apply squashed bugs, rinse, repeat
> >> Beautiful Sunny Winfield, Illinois
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> >
> >
>=20
>=20
>=20


--Sig_/t2qs4=eiZE4FZuQ5xoJVwTM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsLWWjnsnt1WYoG5AQIbVQ//QQQwxx8Ciyiy7Xdepn3HT12Fkrjx4KH0
Mvh2NBpAcJU7NJT9H5TbgrMvkzettCIMIvLDowbrAznO5/oKVa52MkArC9jFMViU
5/Qb1b8QHqH1Eqh2yhtY1QaTJTkiY9ZqPincI/eOR5/g31KKbcDKyAhozzOeARvH
3Jn+emHzfIKxk2sxdzN1uZUfgOr4WR7HNdd95kSSiakVB0gaETOn+Zx1ECi6y1xj
AMRdkLzVwSmA6N9Uc9w4DPeA54xUVbMnPTpHrAS2lc6kEeJZZzvJK8RMkMvsxMKj
U/QyOiwGTp3DYb9XLux9fFxsKlPH45SrL9BSdK4e2XJ9wzYUSyvFe4EYBBSdn26K
v5G/Gq5jA8mqIcuJ0NF02fxsqWW5MWizAlCxHpa0085SsIpVwnqXHJnNR4UG7WO0
zRavKfb5fKdGh8ZMCcL1/fsR8FYmW3JJ+n7VYvy5qDNolGxAPRxxx4Dp0qVKxI3H
qcpYl+BIrG4RaNnPsH+eW3Ilqucm6KNvONiz68HcF+SrXXxR/Rf6lr75NywQ9In3
QB3HzX7kVQVWK50kCPCaWyLCG9esZp25S3+HJOIPb8XqxBWf8X98XrlqySYC4T1B
efPI0ubuucCKOum1C6c42KvsyAhA7MihGOmp2a8ckYXj1o/s8VDoSnwMQEVPovu1
aFnjWvNYIRg=
=0Mx2
-----END PGP SIGNATURE-----

--Sig_/t2qs4=eiZE4FZuQ5xoJVwTM--
