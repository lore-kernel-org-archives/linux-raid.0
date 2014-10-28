From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: can i recover an all spare raid10 array ?
Date: Tue, 28 Oct 2014 20:02:39 +0000
Message-ID: <20141028200239.GA31861@cthulhu.home.robinhill.me.uk>
References: <DUB121-W342C9D8FABB014826217FA8A9F0@phx.gbl>
 <20141028170111.GA20226@cthulhu.home.robinhill.me.uk>
 <DUB121-W268A97DFB2DCC142617CED8A9F0@phx.gbl>
 <DUB121-W26D4B9D346A4A0A0407CD38A9F0@phx.gbl>
 <20141028183422.GA30582@cthulhu.home.robinhill.me.uk>
 <DUB121-W224F0805F3F731496386978A9F0@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DUB121-W224F0805F3F731496386978A9F0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Roland RoLaNd <r_o_l_a_n_d@hotmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Oct 28, 2014 at 09:11:21PM +0200, Roland RoLaNd wrote:

>=20
>=20
> ----------------------------------------
> > Date: Tue, 28 Oct 2014 18:34:22 +0000
> > From: robin@robinhill.me.uk
> > To: r_o_l_a_n_d@hotmail.com
> > CC: robin@robinhill.me.uk; linux-raid@vger.kernel.org
> > Subject: Re: can i recover an all spare raid10 array ?
> >
> > Please don't top post, it makes conversations very difficult to follow.
> > Responses should go at the bottom, or interleaved with the previous post
> > if responding to particular points. I've moved your previous responses
> > to keep the conversation flow straight.
> >
> > On Tue Oct 28, 2014 at 07:30:50PM +0200, Roland RoLaNd wrote:
> >>
> >>> From: r_o_l_a_n_d@hotmail.com
> >>> To: robin@robinhill.me.uk
> >>> CC: linux-raid@vger.kernel.org
> >>> Subject: Re: can i recover an all spare raid10 array ?
> >>> Date: Tue, 28 Oct 2014 19:29:25 +0200
> >>>
> >>>> Date: Tue, 28 Oct 2014 17:01:11 +0000
> >>>> From: robin@robinhill.me.uk
> >>>> To: r_o_l_a_n_d@hotmail.com
> >>>> CC: linux-raid@vger.kernel.org
> >>>> Subject: Re: can i recover an all spare raid10 array ?
> >>>>
> >>>> On Tue Oct 28, 2014 at 06:22:11PM +0200, Roland RoLaNd wrote:
> >>>>
> >>>>> I have two raid arrays on my system:
> >>>>> raid1: /dev/sdd1 /dev/sdh1
> >>>>> raid10: /dev/sde1 /dev/sda1 /dev/sdf1 /dec/sdb1 /dev/sdc1 /dev/sdg1
> >>>>>
> >>>>>
> >>>>> two disks had bad sectors: sdd and sdf <<-- they both got hot swapp=
ed.
> >>>>> i added sdf back to raid10 and recovery took place but adding sdd1 =
to
> >>>>> raid1 proved to be troublesome
> >>>>> as i didn't have anything important on '/' i formatted and installed
> >>>>> ubuntu 14 on raid1
> >>>>>
> >>>>> now system is up on raid 1, but raid10 (md127) is inactive
> >>>>>
> >>>>> cat /proc/mdstat
> >>>>>
> >>>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5=
] [raid4] [raid10]
> >>>>> md127 : inactive sde1[2](S) sdg1[8](S) sdc1[6](S) sdb1[5](S) sdf1[4=
](S) sda1[3](S)
> >>>>> 17580804096 blocks super 1.2
> >>>>>
> >>>>> md2 : active raid1 sdh4[0] sdd4[1]
> >>>>> 2921839424 blocks super 1.2 [2/2] [UU]
> >>>>> [=3D=3D>..................] resync =3D 10.4% (304322368/2921839424)=
 finish=3D672.5min speed=3D64861K/sec
> >>>>>
> >>>>> md1 : active raid1 sdh3[0] sdd3[1]
> >>>>> 7996352 blocks super 1.2 [2/2] [UU]
> >>>>>
> >>>>> md0 : active raid1 sdh2[0] sdd2[1]
> >>>>> 292544 blocks super 1.2 [2/2] [UU]
> >>>>>
> >>>>> unused devices: <none>
> >>>>> if i try to assemble md127
> >>>>>
> >>>>>
> >>>>> mdadm --assemble /dev/md127 /dev/sde1 /dev/sda1 /dev/sdf1 /dev/sdb1=
 /dev/sdc1 /dev/sdg1
> >>>>> mdadm: /dev/sde1 is busy - skipping
> >>>>> mdadm: /dev/sda1 is busy - skipping
> >>>>> mdadm: /dev/sdf1 is busy - skipping
> >>>>> mdadm: /dev/sdb1 is busy - skipping
> >>>>> mdadm: /dev/sdc1 is busy - skipping
> >>>>> mdadm: /dev/sdg1 is busy - skipping
> >>>>>
> >>>>>
> >>>>> if i try to add one of the disks: mdadm --add /dev/md127 /dev/sdj1
> >>>>> mdadm: cannot get array info for /dev/md127
> >>>>>
> >>>>> if i try:
> >>>>>
> >>>>> mdadm --stop /dev/md127
> >>>>> mdadm: stopped /dev/md127
> >>>>>
> >>>>> then running: mdadm --assemble /dev/md127 /dev/sde1 /dev/sda1 /dev/=
sdf1 /dev/sdb1 /dev/sdc1 /dev/sdg1
> >>>>>
> >>>>> returns:
> >>>>>
> >>>>> assembled from 5 drives and 1 rebuilding - not enough to start the =
array
> >>>>>
> >>>>> what does it mean ? is my data lost ?
> >>>>>
> >>>>> if i examine one of the md127 raid 10 array disks it shows this:
> >>>>>
> >>>>> mdadm --examine /dev/sde1
> >>>>> /dev/sde1:
> >>>>> Magic : a92b4efc
> >>>>> Version : 1.2
> >>>>> Feature Map : 0x0
> >>>>> Array UUID : ab90d4c8:41a55e14:635025cc:28f0ee76
> >>>>> Name : ubuntu:data (local to host ubuntu)
> >>>>> Creation Time : Sat May 10 21:54:56 2014
> >>>>> Raid Level : raid10
> >>>>> Raid Devices : 8
> >>>>>
> >>>>> Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
> >>>>> Array Size : 11720534016 (11177.57 GiB 12001.83 GB)
> >>>>> Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB)
> >>>>> Data Offset : 262144 sectors
> >>>>> Super Offset : 8 sectors
> >>>>> State : clean
> >>>>> Device UUID : a2a5db61:bd79f0ae:99d97f17:21c4a619
> >>>>>
> >>>>> Update Time : Tue Oct 28 10:07:18 2014
> >>>>> Checksum : 409deeb4 - correct
> >>>>> Events : 8655
> >>>>>
> >>>>> Layout : near=3D2
> >>>>> Chunk Size : 512K
> >>>>>
> >>>>> Device Role : Active device 2
> >>>>> Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> >>>>>
> >>>>> Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB) <<--- does this=
 mean i still have my data ?
> >>>>>
> >>>>>
> >>>>> the remaining two disks:
> >>>>>
> >>>>> mdadm --examine /dev/sdj1
> >>>>> mdadm: No md superblock detected on /dev/sdj1.
> >>>>> mdadm --examine /dev/sdi1
> >>>>> mdadm: No md superblock detected on /dev/sdi1.
> >>>>
> >>>> The --examine output indicates the RAID10 array was 8 members, not 6.
> >>>> As it stands, you are missing two array members (presumably a mirror=
ed
> >>>> pair as mdadm won't start the array). Without these you're missing 5=
12K
> >>>> of every 2M in the array, so your data is toast (well, with a lot of
> >>>> effort you may recover some files under 1.5M in size).
> >>>>
> >>>> Were you expecting sdi1 and sdj1 to have been part of the original
> >>>> RAID10 array? Have you removed the superblocks from them at any poin=
t?
> >>>> For completeness, what mdadm and kernel versions are you running?
> >>>>
> >>>> Cheers,
> >>>> Robin
> >>>
> >>> Thanks for pitching in.here are the responses to you questions:
> >>>
> >>> - yes i expected both of them to be part of the array though one of
> >>> them was just added to the array and didnt finish recovering when
> >>> raid1 "/" crashed
> >>>
> > According to your --examine earlier, the RAID10 rebuild had completed
> > (it shows the array clean and having all disks active). Are you certain
> > that the new RAID1 array isn't using disks that used to be part of the
> > RAID10 array? Regardless, I'd expect the disks to have a superblock if
> > they were part of either array (unless they've been repartitioned?).
> >
>=20
> the examine earlier was to one of the 6 disks that belong to the current =
inactive array.. they're all clean
> as for raid1/10 arrays, =C2=A0that's what i thought as it happened with m=
e before, but lsblk shows the following:
>=20
> NAME =C2=A0 =C2=A0MAJ:MIN RM =C2=A0 SIZE RO TYPE =C2=A0MOUNTPOINT
> sda =C2=A0 =C2=A0 =C2=A0 8:0 =C2=A0 =C2=A00 =C2=A0 2.7T =C2=A00 disk =C2=
=A0
> =E2=94=94=E2=94=80sda1 =C2=A0 =C2=A08:1 =C2=A0 =C2=A00 =C2=A0 2.7T =C2=A0=
0 part =C2=A0
> sdb =C2=A0 =C2=A0 =C2=A0 8:16 =C2=A0 0 =C2=A0 2.7T =C2=A00 disk =C2=A0
> =E2=94=94=E2=94=80sdb1 =C2=A0 =C2=A08:17 =C2=A0 0 =C2=A0 2.7T =C2=A00 par=
t =C2=A0
> sdc =C2=A0 =C2=A0 =C2=A0 8:32 =C2=A0 0 =C2=A0 2.7T =C2=A00 disk =C2=A0
> =E2=94=94=E2=94=80sdc1 =C2=A0 =C2=A08:33 =C2=A0 0 =C2=A0 2.7T =C2=A00 par=
t =C2=A0
> sdd =C2=A0 =C2=A0 =C2=A0 8:48 =C2=A0 0 =C2=A0 2.7T =C2=A00 disk =C2=A0
> =E2=94=9C=E2=94=80sdd1 =C2=A0 =C2=A08:49 =C2=A0 0 =C2=A0 =C2=A0 1M =C2=A0=
0 part =C2=A0
> =E2=94=9C=E2=94=80sdd2 =C2=A0 =C2=A08:50 =C2=A0 0 =C2=A0 286M =C2=A00 par=
t =C2=A0
> =E2=94=82 =E2=94=94=E2=94=80md0 =C2=A0 9:0 =C2=A0 =C2=A00 285.7M =C2=A00 =
raid1 /boot
> =E2=94=9C=E2=94=80sdd3 =C2=A0 =C2=A08:51 =C2=A0 0 =C2=A0 7.6G =C2=A00 par=
t =C2=A0
> =E2=94=82 =E2=94=94=E2=94=80md1 =C2=A0 9:1 =C2=A0 =C2=A00 =C2=A0 7.6G =C2=
=A00 raid1 [SWAP]
> =E2=94=94=E2=94=80sdd4 =C2=A0 =C2=A08:52 =C2=A0 0 =C2=A0 2.7T =C2=A00 par=
t =C2=A0
> =C2=A0 =E2=94=94=E2=94=80md2 =C2=A0 9:2 =C2=A0 =C2=A00 =C2=A0 2.7T =C2=A0=
0 raid1 /
> sde =C2=A0 =C2=A0 =C2=A0 8:64 =C2=A0 0 =C2=A0 2.7T =C2=A00 disk =C2=A0
> =E2=94=94=E2=94=80sde1 =C2=A0 =C2=A08:65 =C2=A0 0 =C2=A0 2.7T =C2=A00 par=
t =C2=A0
> sdf =C2=A0 =C2=A0 =C2=A0 8:80 =C2=A0 0 =C2=A0 2.7T =C2=A00 disk =C2=A0
> =E2=94=94=E2=94=80sdf1 =C2=A0 =C2=A08:81 =C2=A0 0 =C2=A0 2.7T =C2=A00 par=
t =C2=A0
> sdg =C2=A0 =C2=A0 =C2=A0 8:96 =C2=A0 0 =C2=A0 2.7T =C2=A00 disk =C2=A0
> =E2=94=94=E2=94=80sdg1 =C2=A0 =C2=A08:97 =C2=A0 0 =C2=A0 2.7T =C2=A00 par=
t =C2=A0
> sdh =C2=A0 =C2=A0 =C2=A0 8:112 =C2=A00 =C2=A0 2.7T =C2=A00 disk =C2=A0
> =E2=94=9C=E2=94=80sdh1 =C2=A0 =C2=A08:113 =C2=A00 =C2=A0 =C2=A0 1M =C2=A0=
0 part =C2=A0
> =E2=94=9C=E2=94=80sdh2 =C2=A0 =C2=A08:114 =C2=A00 =C2=A0 286M =C2=A00 par=
t =C2=A0
> =E2=94=82 =E2=94=94=E2=94=80md0 =C2=A0 9:0 =C2=A0 =C2=A00 285.7M =C2=A00 =
raid1 /boot
> =E2=94=9C=E2=94=80sdh3 =C2=A0 =C2=A08:115 =C2=A00 =C2=A0 7.6G =C2=A00 par=
t =C2=A0
> =E2=94=82 =E2=94=94=E2=94=80md1 =C2=A0 9:1 =C2=A0 =C2=A00 =C2=A0 7.6G =C2=
=A00 raid1 [SWAP]
> =E2=94=94=E2=94=80sdh4 =C2=A0 =C2=A08:116 =C2=A00 =C2=A0 2.7T =C2=A00 par=
t =C2=A0
> =C2=A0 =E2=94=94=E2=94=80md2 =C2=A0 9:2 =C2=A0 =C2=A00 =C2=A0 2.7T =C2=A0=
0 raid1 /
> sdi =C2=A0 =C2=A0 =C2=A0 8:128 =C2=A00 =C2=A0 2.7T =C2=A00 disk =C2=A0
> =E2=94=94=E2=94=80sdi1 =C2=A0 =C2=A08:129 =C2=A00 =C2=A0 2.7T =C2=A00 par=
t =C2=A0
> sdj =C2=A0 =C2=A0 =C2=A0 8:144 =C2=A00 =C2=A0 2.7T =C2=A00 disk =C2=A0
> =E2=94=94=E2=94=80sdj1 =C2=A0 =C2=A08:145 =C2=A00 =C2=A0 2.7T =C2=A00 par=
t=C2=A0
>=20
>=20
> >>> - i have not removed their superblocks or at least not in a way that i
> >>> amaware of
> >>>
> >>> - mdadm: 3.2.5-5ubuntu4.1
> >>> - uname -a: 3.13.0-24-generic
> >>>
> > That's a pretty old mdadm version, but I don't see anything in the
> > change logs that looks relevant. Others may be more familiar with issues
> > though.
>=20
> that's the latest in my current ubuntu repository
>=20
> >
> >>>
> >>> PS:
> >>> I just followed this recovery page:
> >>> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_R=
AID
> >>> I managed to reach the last step, whenever i tried to mount it kept
> >>> asking me for the right file system
> >>>
> > That's good documentation anyway. As long as you stick to the overlay
> > devices your original data is untouched. It's amazing how many people
> > run --create on their original disks and lose any chance of getting the
> > data back.
>=20
> unfortunately i used to be/am one of those people.=C2=A0
> =C2=A0had bad experiences with this before, so i took it slow and went wi=
th
> the overlay documentation.
> all ebooks i could found about raid speak about different between
> multiple raid levels but none are thorough when it comes to =C2=A0setting
> up/troubleshooting =C2=A0raid.=C2=A0
> and once i do fix my issue, i move on to the next firefighting
> situation so i lose interest due to lack of time.
>=20
> >
> >> Correction:i couldn't force assemble the read devices so i issued inst=
ead:
> >> mdadm --create /dev/md089 --assume-clean --level=3D10 --verbose --raid=
-devices=3D8 missing /dev/dm-1 /dev/dm-0 /dev/dm-5 /dev/dm-3 /dev/dm-2 miss=
ing /dev/dm-4
> >> which got it into degraded state
> >>
> >
> > What error did you get when you tried to force assemble (both from mdadm
> > and anything reported via dmesg)? The device order you're using would
> > suggest that the missing disks wouldn't be mirrors of each other, so the
> > data should be okay.
>=20
> mdadm --assemble --force /dev/md100 $OVERLAYS
> mdadm: /dev/md100 assembled from 5 drives and =C2=A01 rebuilding - not en=
ough to start the array.
>=20
That's very odd - all the --examine results for the original disks show
the array as clean. That would suggest an issue with the installed
version of mdadm but it doesn't really matter in this case - see below.

> dmesg:
> [ 6025.573964] md: md100 stopped.
> [ 6025.595810] md: bind<dm-0>
> [ 6025.596086] md: bind<dm-5>
> [ 6025.596364] md: bind<dm-2>
> [ 6025.596612] md: bind<dm-1>
> [ 6025.596840] md: bind<dm-4>
> [ 6025.597026] md: bind<dm-3>
>=20
> >
> > Can you post the --examine results for all the RAID members? Both for
> > the original partitions and for the overlay devices after you recreated
> > the array. There may be differences in data offset, etc. which will
> > break the filesystem.
>=20
> Original partitions:
> http://pastebin.com/nHCxidvE
>=20
> overlay:
> http://pastebin.com/eva4cnu6
>=20

Right - these show you have the wrong order. The original partition
array device roles are:
  sdc1: 2
  sda1: 3
  sdf1: 4
  sdb1: 5
  sdc1: 6
  sdg1: 7

and your overlays are:
  dm-1: 1
  dm-0: 2
  dm-5: 3
  dm-3: 4
  dm-2: 5
  dm-4: 7

So the bad news is that you're missing roles 0 & 1, which will be
mirrors. That means your array is broken unless any other member disks
can be found.

If you're certain that sdi1 and sdj1 should be in the array then you can
try recreating the array (in the correct order) and using sdi1/sdj1 in
the missing slots and see if one option works. I'll assume the overlay
mapping is as follows (if not, remap as required):
         sda1 -> dm-0
         sdb1 -> dm-1
         sdc1 -> dm-2
         sde1 -> dm-3
         sdf1 -> dm-4
         sdg1 -> dm-5
         sdi1 -> dm-6
         sdj1 -> dm-7

For each of the following orders, you're going to need to:
    - stop the existing array (mdadm -S /dev/md089)
    - create a new array using --assume-clean
    - check for an valid filesystem (fsck -n /dev/md089)

If the fsck returns without errors then try mounting the filesystem and
see if all looks okay, otherwise move on to the next order.

The orders to try are:
- /dev/dm-6 missing /dev/dm-3 /dev/dm-0 /dev/dm-4 /dev/dm-1 /dev/dm-2 /dev/=
dm-5
- missing /dev/dm-6 /dev/dm-3 /dev/dm-0 /dev/dm-4 /dev/dm-1 /dev/dm-2 /dev/=
dm-5
- /dev/dm-7 missing /dev/dm-3 /dev/dm-0 /dev/dm-4 /dev/dm-1 /dev/dm-2 /dev/=
dm-5
- missing /dev/dm-7 /dev/dm-3 /dev/dm-0 /dev/dm-4 /dev/dm-1 /dev/dm-2 /dev/=
dm-5

Good luck,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlRP9l8ACgkQShxCyD40xBKmDwCfbIR68Rbc/Yo9qXEPlw+pGWDJ
k2EAoIbbUSUmw4WnyxXvQTLaKpqTdSaX
=uf7N
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
