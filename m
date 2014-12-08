From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: On RAID5 read error during syncing - array .A.A
Date: Mon, 8 Dec 2014 16:55:35 +0000
Message-ID: <20141208165535.GC8530@cthulhu.home.robinhill.me.uk>
References: <CAB_L8sZoinCMbp7wrjYaQ=XgCOiBWZBLHkMsV_g+nUyM9pc7CQ@mail.gmail.com>
 <20141206185600.GA2343@cthulhu.home.robinhill.me.uk>
 <CAB_L8sYkWFO0hC-rUHednzy=BWZoBaVS_DhoBedg-viPnTdU-g@mail.gmail.com>
 <20141208094841.GA8530@cthulhu.home.robinhill.me.uk>
 <CAB_L8sYfFNaeUNiCFhidGVuRtMOP1XjJ4e=edsXp1bqe-FYBww@mail.gmail.com>
 <20141208151419.GB8530@cthulhu.home.robinhill.me.uk>
 <CAB_L8sZNxNDO_f0X_uXwLuM8kcRgT=p+f8+-wtYDhEQPy_dX5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAB_L8sZNxNDO_f0X_uXwLuM8kcRgT=p+f8+-wtYDhEQPy_dX5Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emery Guevremont <emery.guevremont@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Dec 08, 2014 at 11:31:09AM -0500, Emery Guevremont wrote:
> On Mon, Dec 8, 2014 at 10:14 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> > On Mon Dec 08, 2014 at 09:13:13AM -0500, Emery Guevremont wrote:
> >> On Mon, Dec 8, 2014 at 4:48 AM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> >> > On Sat Dec 06, 2014 at 03:49:10PM -0500, Emery Guevremont wrote:
> >> >> On Sat, Dec 6, 2014 at 1:56 PM, Robin Hill <robin@robinhill.me.uk> =
wrote:
> >> >> > On Sat Dec 06, 2014 at 01:35:50pm -0500, Emery Guevremont wrote:
> >> >> >
> >> >> >> The long story and what I've done.
> >> >> >>
> >> >> >> /dev/md0 is assembled with 4 drives
> >> >> >> /dev/sda3
> >> >> >> /dev/sdb3
> >> >> >> /dev/sdc3
> >> >> >> /dev/sdd3
> >> >> >>
> >> >> >> 2 weeks ago, mdadm marked /dev/sda3 as failed. cat /proc/mdstat =
showed
> >> >> >> _UUU. smarctl also confirmed that the drive was dying. So I shut=
down
> >> >> >> the server and until I received a replacement drive.
> >> >> >>
> >> >> >> This week, I replaced the dying drive with my new drive. Booted =
into
> >> >> >> single user mode and did this:
> >> >> >>
> >> >> >> mdadm --manage /dev/md0 --add /dev/sda3  a cat of /proc/mdstat
> >> >> >> confirmed the resyncing process. The last time I checked it was =
up to
> >> >> >> 11%. After a few minutes later, I noticed that the syncing stopp=
ed. A
> >> >> >> read error message on /dev/sdd3 (have a pic of it if interested)
> >> >> >> appear on the console. It appears that /dev/sdd3 might be going =
bad. A
> >> >> >> cat /proc/mdstat showed _U_U. Now I panic, and decide to leave
> >> >> >> everything as is and to go to bed.
> >> >> >>
> >> >> >> The next day, I shutdown the server and reboot with a live usb d=
istro
> >> >> >> (Ubuntu rescue remix). After booting into the live distro, a cat
> >> >> >> /proc/mdstat showed that my /dev/md0 was detected but all drives=
 had
> >> >> >> an (S) next to it. i.e. /dev/sda3 (S)... Naturally I don't like =
the
> >> >> >> looks of this.
> >> >> >>
> >> >> >> I ran ddrescue to copy /dev/sdd onto my new replacement disk
> >> >> >> (/dev/sda). Everything, worked, ddrescue got only one read error=
, but
> >> >> >> was eventually able to read the bad sector on a retry. I followe=
d up
> >> >> >> by also cloning with ddrescue, sdb and sdc.
> >> >> >>
> >> >> >> So now I have cloned copies of sdb, sdc and sdd to work with.
> >> >> >> Currently running mdadm --assemble --scan, will activate my arra=
y, but
> >> >> >> all drives are added as spares. Running mdadm --examine on each
> >> >> >> drives, shows the same Array UUID number, but the Raid Devices i=
s 0
> >> >> >> and raid level is -unknown- for some reason. The rest seems fine=
 and
> >> >> >> makes sense. I believe I could re-assemble my array if I could d=
efine
> >> >> >> the raid level and raid devices.
> >> >> >>
> >> >> >> I wanted to know if there are a way to restore my superblocks fr=
om the
> >> >> >> examine command I ran at the beginning? If not, what mdadm create
> >> >> >> command should I run? Also please let me know if drive ordering =
is
> >> >> >> important, and how I can determine this with the examine output =
I'll
> >> >> >> got?
> >> >> >>
> >> >> >> Thank you.
> >> >> >>
> >> >> > Have you tried --assemble --force? You'll need to make sure the a=
rray's
> >> >> > stopped first, but that's the usual way to get the array back up =
and
> >> >> > running in that sort of situation.
> >> >> >
> >> >> > If that doesn't work, stop the array again and post:
> >> >> >  - the output from mdadm --assemble --force --verbose /dev/md0 /d=
ev/sd[bcd]3
> >> >> >  - any dmesg output corresponding with the above
> >> >> >  - --examine output for all disks
> >> >> >  - kernel and mdadm versions
> >> >> >
> >> >> > Good luck,
> >> >> >     Robin
> >> >
> >> >> You'll see from the examine output, raid level and devices aren't
> >> >> defined and notice the role of each drives. The examine output (I
> >> >> attached 4 files) that I took right after the read error during the
> >> >> synching process seems to show a more accurate superblock. Here's a=
lso
> >> >> the output of mdadm --detail /dev/md0 that I took when I got the fi=
rst
> >> >> error:
> >> >>
> >> >> ARRAY /dev/md/0 metadata=3D1.2 UUID=3Dcf9db8fa:0c2bb553:46865912:70=
4cceae
> >> >> name=3Drunts:0
> >> >>    spares=3D1
> >> >>
> >> >>
> >> >> Here's the output of how things currently are:
> >> >>
> >> >> mdadm --assemble --force /dev/md127 /dev/sdb3 /dev/sdc3 /dev/sdd3
> >> >> mdadm: /dev/md127 assembled from 0 drives and 3 spares - not enough=
 to
> >> >> start the array.
> >> >>
> >> >> dmesg
> >> >> [27903.423895] md: md127 stopped.
> >> >> [27903.434327] md: bind<sdc3>
> >> >> [27903.434767] md: bind<sdd3>
> >> >> [27903.434963] md: bind<sdb3>
> >> >>
> >> >> cat /proc/mdstat
> >> >> root@ubuntu:~# cat /proc/mdstat
> >> >> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
> >> >> [raid1] [raid10]
> >> >> md127 : inactive sdb3[4](S) sdd3[0](S) sdc3[5](S)
> >> >>       5858387208 blocks super 1.2
> >> >>
> >> >> mdadm --examine /dev/sd[bcd]3
> >> >> /dev/sdb3:
> >> >>           Magic : a92b4efc
> >> >>         Version : 1.2
> >> >>     Feature Map : 0x0
> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
> >> >>            Name : runts:0
> >> >>   Creation Time : Tue Jul 26 03:27:39 2011
> >> >>      Raid Level : -unknown-
> >> >>    Raid Devices : 0
> >> >>
> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
> >> >>     Data Offset : 2048 sectors
> >> >>    Super Offset : 8 sectors
> >> >>           State : active
> >> >>     Device UUID : b2bf0462:e0722254:0e233a72:aa5df4da
> >> >>
> >> >>     Update Time : Sat Dec  6 12:46:40 2014
> >> >>        Checksum : 5e8cfc9a - correct
> >> >>          Events : 1
> >> >>
> >> >>
> >> >>    Device Role : spare
> >> >>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >> >> /dev/sdc3:
> >> >>           Magic : a92b4efc
> >> >>         Version : 1.2
> >> >>     Feature Map : 0x0
> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
> >> >>            Name : runts:0
> >> >>   Creation Time : Tue Jul 26 03:27:39 2011
> >> >>      Raid Level : -unknown-
> >> >>    Raid Devices : 0
> >> >>
> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
> >> >>     Data Offset : 2048 sectors
> >> >>    Super Offset : 8 sectors
> >> >>           State : active
> >> >>     Device UUID : 390bd4a2:07a28c01:528ed41e:a9d0fcf0
> >> >>
> >> >>     Update Time : Sat Dec  6 12:46:40 2014
> >> >>        Checksum : f69518c - correct
> >> >>          Events : 1
> >> >>
> >> >>
> >> >>    Device Role : spare
> >> >>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >> >> /dev/sdd3:
> >> >>           Magic : a92b4efc
> >> >>         Version : 1.2
> >> >>     Feature Map : 0x0
> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
> >> >>            Name : runts:0
> >> >>   Creation Time : Tue Jul 26 03:27:39 2011
> >> >>      Raid Level : -unknown-
> >> >>    Raid Devices : 0
> >> >>
> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
> >> >>     Data Offset : 2048 sectors
> >> >>    Super Offset : 8 sectors
> >> >>           State : active
> >> >>     Device UUID : 92589cc2:9d5ed86c:1467efc2:2e6b7f09
> >> >>
> >> >>     Update Time : Sat Dec  6 12:46:40 2014
> >> >>        Checksum : 571ad2bd - correct
> >> >>          Events : 1
> >> >>
> >> >>
> >> >>    Device Role : spare
> >> >>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >> >>
> >> >> and finally kernel and mdadm versions:
> >> >>
> >> >> uname -a
> >> >> Linux ubuntu 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:41:14 UTC
> >> >> 2012 i686 i686 i386 GNU/Linux
> >> >>
> >> >> mdadm -V
> >> >> mdadm - v3.2.3 - 23rd December 2011
> >> >
> >> > The missing data looks similar to a bug fixed a couple of years ago
> >> > (http://neil.brown.name/blog/20120615073245), though the kernel vers=
ions
> >> > don't match and the missing data is somewhat different - it may be t=
hat
> >> > the relevant patches were backported to the vendor kernel you're usi=
ng.
> >> >
> >> > With that data missing there's no way to assemble though, so a re-cr=
eate
> >> > is required in this case (it's a last resort, but I don't see any ot=
her
> >> > option).
> >> >
> >> >> /dev/sda3:
> >> >>           Magic : a92b4efc
> >> >>         Version : 1.2
> >> >>     Feature Map : 0x0
> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
> >> >>            Name : runts:0  (local to host runts)
> >> >>   Creation Time : Mon Jul 25 23:27:39 2011
> >> >>      Raid Level : raid5
> >> >>    Raid Devices : 4
> >> >>
> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
> >> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
> >> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
> >> >>     Data Offset : 2048 sectors
> >> >>    Super Offset : 8 sectors
> >> >>           State : clean
> >> >>     Device UUID : b2bf0462:e0722254:0e233a72:aa5df4da
> >> >>
> >> >>     Update Time : Tue Dec  2 23:15:37 2014
> >> >>        Checksum : 5ed5b898 - correct
> >> >>          Events : 3925676
> >> >>
> >> >>          Layout : left-symmetric
> >> >>      Chunk Size : 512K
> >> >>
> >> >>    Device Role : spare
> >> >>    Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing)
> >> >
> >> >> /dev/sdb3:
> >> >>           Magic : a92b4efc
> >> >>         Version : 1.2
> >> >>     Feature Map : 0x0
> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
> >> >>            Name : runts:0  (local to host runts)
> >> >>   Creation Time : Mon Jul 25 23:27:39 2011
> >> >>      Raid Level : raid5
> >> >>    Raid Devices : 4
> >> >>
> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
> >> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
> >> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
> >> >>     Data Offset : 2048 sectors
> >> >>    Super Offset : 8 sectors
> >> >>           State : clean
> >> >>     Device UUID : 92589cc2:9d5ed86c:1467efc2:2e6b7f09
> >> >>
> >> >>     Update Time : Tue Dec  2 23:15:37 2014
> >> >>        Checksum : 57638ebb - correct
> >> >>          Events : 3925676
> >> >>
> >> >>          Layout : left-symmetric
> >> >>      Chunk Size : 512K
> >> >>
> >> >>    Device Role : Active device 0
> >> >>    Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing)
> >> >
> >> >> /dev/sdc3:
> >> >>           Magic : a92b4efc
> >> >>         Version : 1.2
> >> >>     Feature Map : 0x0
> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
> >> >>            Name : runts:0  (local to host runts)
> >> >>   Creation Time : Mon Jul 25 23:27:39 2011
> >> >>      Raid Level : raid5
> >> >>    Raid Devices : 4
> >> >>
> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
> >> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
> >> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
> >> >>     Data Offset : 2048 sectors
> >> >>    Super Offset : 8 sectors
> >> >>           State : clean
> >> >>     Device UUID : 390bd4a2:07a28c01:528ed41e:a9d0fcf0
> >> >>
> >> >>     Update Time : Tue Dec  2 23:15:37 2014
> >> >>        Checksum : fb20d8a - correct
> >> >>          Events : 3925676
> >> >>
> >> >>          Layout : left-symmetric
> >> >>      Chunk Size : 512K
> >> >>
> >> >>    Device Role : Active device 2
> >> >>    Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing)
> >> >
> >> >> /dev/sdd3:
> >> >>           Magic : a92b4efc
> >> >>         Version : 1.2
> >> >>     Feature Map : 0x0
> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
> >> >>            Name : runts:0  (local to host runts)
> >> >>   Creation Time : Mon Jul 25 23:27:39 2011
> >> >>      Raid Level : raid5
> >> >>    Raid Devices : 4
> >> >>
> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
> >> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
> >> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
> >> >>     Data Offset : 2048 sectors
> >> >>    Super Offset : 8 sectors
> >> >>           State : clean
> >> >>     Device UUID : 4156ab46:bd42c10d:8565d5af:74856641
> >> >>
> >> >>     Update Time : Tue Dec  2 23:14:03 2014
> >> >>        Checksum : a126853f - correct
> >> >>          Events : 3925672
> >> >>
> >> >>          Layout : left-symmetric
> >> >>      Chunk Size : 512K
> >> >>
> >> >>    Device Role : Active device 1
> >> >>    Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
> >> >
> >> > At least you have the previous data anyway, which should allow
> >> > reconstruction of the array. The device names have changed between y=
our
> >> > two reports though, so I'd advise double-checking which is which bef=
ore
> >> > proceeding.
> >> >
> >> > The reports indicate that the original array order (based on the dev=
ice
> >> > role field) for the four devices was (using device UUIDs as they're
> >> > consistent):
> >> >     92589cc2:9d5ed86c:1467efc2:2e6b7f09
> >> >     4156ab46:bd42c10d:8565d5af:74856641
> >> >     390bd4a2:07a28c01:528ed41e:a9d0fcf0
> >> >     b2bf0462:e0722254:0e233a72:aa5df4da
> >> >
> >> > That would give a current device order of sdd3,sda3,sdc3,sdb3 (I don=
't
> >> > have the current data for sda3, but that's the only missing UUID).
> >> >
> >> > The create command would therefore be:
> >> >     mdadm -C -l 5 -n 4 -c 512 -e 1.2 -z 1952795136 \
> >> >         /dev/md0 /dev/sdd3 /dev/sda3 /dev/sdc3 missing
> >> >
> >> > mdadm 3.2.3 should use a data offset of 2048, the same as your old
> >> > array, but you may want to double-check that with a test array on a
> >> > couple of loopback devices first. If not, you'll need to grab the
> >> > latest release and add the --data-offset=3D2048 parameter to the abo=
ve
> >> > create command.
> >> >
> >> > You should also follow the instructions for using overlay files at
> >> > https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_=
RAID
> >> > in order to safely test out the above without risking damage to the
> >> > array data.
> >> >
> >> > Once you've run the create, run a "fsck -n" on the filesystem to che=
ck
> >> > that the data looks okay. If not, the order or parameters may be
> >> > incorrect - check the --examine output for any differences from the
> >> > original results.
> >> >
> >> Just to double check, would this be the right command to run?
> >>
> >> mdadm --create --assume-clean --level=3D5 --size=3D5858385408
> >> --raid-devices=3D4 /dev/md0 missing /dev/sdb3 /dev/sdc3 /dev/sdd3
> >>
> >> Are there any other options I would need to add? Should I specify
> >> --chunk and --size (and if I entered the right size)?
> >>
> > You don't need --assume-clean as there's a missing device, so no scope
> > for rebuilding one of the disks (which is all the flag prevents). It
> > won't do any harm leaving it in though.
> >
> > The size should be the per-device size in kiB (which is half the Used
> > Dev Size value listed in the --examine output, as that's given in
> > 512-byte blocks) and I gave you the correct value above. I'd recommend
> > including this as it will ensure that mdadm isn't calculating the size
> > any different from the version originally used to create the array.
> >
> > The device order you've given is incorrect for either the original
> > device numbering or the numbering you posted as being the most recent.
> > The order I gave above is based on the order as in the latest --examine
> > results you gave. If you've rebooted since then, you'll need to verify
> > the order based on the UUIDs of the devices though (again, the original
> > order should be the one I gave above, based on the device role order in
> > your original --examine output). If you're using different disks, you'll
> > need to be sure which one was mirrored from which original. If you use
> > the incorrect order, you'll get a lot of errors in the "fsck -n" output
> > but, as long as you don't actually write to the array, it shouldn't
> > cause any data corruption as only the metadata will be overwritten.
> >
> > There shouldn't be any need to specify the chunk size, as 512k should be
> > the default value, but I'd probably still stick it in anyway, just to be
> > on the safe side.
> >
> > Similarly with the metadata version - 1.2 is the default (currently
> > anyway, I'm not certain with 3.2.3), so shouldn't be necessary. Again,
> > I'd add it in to be on the safe side.
> >
> >> By the way thanks for the help.
> >>
> >
> > No problem.
> >
> > Cheers,
> >     Robin
>
> Here's the adjusted command.
>=20
> mdadm --create --assume-clean --level=3D5 --metadata=3D1.2 --chunk=3D512
> --size=3D1952795136 --raid-devices=3D4 /dev/md0 missing \
> 92589cc2:9d5ed86c:1467efc2:2e6b7f09 \
> 390bd4a2:07a28c01:528ed41e:a9d0fcf0 \
> 4156ab46:bd42c10d:8565d5af:74856641
>=20
No, the missing should come last - the original --examine info you gave
had info for device roles 0, 1, & 2, so the original failed disk must
have been role 3.

> For the --size option, I'm not quite sure I understood what you tried
> to explain to me. I re-read the manpage and I came up with this 2
> equations:
>=20
> (My understanding of your explanation) Used Dev size (3905590272)
> divided by 2 =3D size (1952795136)
> (My understanding from the manpages) Used Dev size (3905590272)
> divided by chunk size (512) =3D size (7628106)
>=20
No, the mdadm manual page says that it has to be a multiple of the chunk
size, not that it's given in multiples of the chunk size. It also says
(in the 3,3,1 release anyway) that it's the "Amount (in Kibibytes)".
It's not spelt out that the Used Dev size is in 512-byte blocks, but
that's obvious from the corresponding Gib size given. You can check by
creating some loopback devices and testing creating an array if you
like.

> As for the device, I should order them with the device UUID (as shown
> above) and I replace those UUID with the /dev/sdX3 that returns the
> same device uuid from a mdadm -E command I will currently get? i.e.
> mdadm -E /dev/sdd3 returns a device uuid of
> 92589cc2:9d5ed86c:1467efc2:2e6b7f09 , my first device with be
> /dev/sdd3...?
>=20
That's correct, yes.

> One last question, after running mdadm --create command, can I run
> mdadm -E and verify the values I get (chunk size, used dev size...)
> match the ones I got from my first mdadm -E command, and if it
> doesn't, to rerun the mdadm --create command to eventually get
> matching values?
>
Yes, the --create command will only overwrite the array metadata, so as
long as your array offset is correct then the actual array data will be
untouched (as the 1.2 superblock is near the start of the device, even a
size error won't damage the data). You'll want to ensure that the chunk
size & dev size match the originals, and that the device role is correct
for the corresponding device UUID.

Once that all matches, you can do the "fsck -f -n" and check that there
are no errors (or only a handful - there may be somea errors after the
array failure anyway).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlSF2AYACgkQShxCyD40xBJdNwCgx9TLKIF0cgx+BdNyGR7JWYxQ
XRsAnAxCd+Bh7S0mBBih5lUaXcfRhPTB
=wpre
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--
