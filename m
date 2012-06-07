From: NeilBrown <neilb@suse.de>
Subject: Re: degraded raid 6 (1 bad drive) showing up inactive, only spares
Date: Fri, 8 Jun 2012 08:34:50 +1000
Message-ID: <20120608083450.5dba2d2a@notabene.brown>
References: <B5902F16-9C82-4072-BD67-FC6D6488ADB7@googlemail.com>
	<20120607222933.14ec3cd5@notabene.brown>
	<4FD11A32.90107@schinagl.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wkZy0bjZhf7Rl4VOg/OUJhE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FD11A32.90107@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Martin Ziler <martin.ziler@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/wkZy0bjZhf7Rl4VOg/OUJhE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 07 Jun 2012 23:16:34 +0200 Oliver Schinagl <oliver+list@schinagl.nl>
wrote:

> Since i'm still working on repairing my own array, and using a wrong=20
> version of mdadm corrupted one of my raid10 array, I'm trying to hexedit=
=20
> the start of an image of the disk to recover the metadata.
>=20
> A quick question, if I've edited/checked the first superblock,
> (i'm using=20
> https://raid.wiki.kernel.org/index.php/RAID_superblock_formats for=20
> reference and looks quite accurate)
>=20
> Would I need to check other area's on the disk for superblocks? Or will=20
> the first superblock be enough?

Are we talking about filesystem superblocks or RAID superblocks?

there is only one RAID superblock - normally 4K from the start (with 1.2
metadta).  There may be lots of filesystem superblocks.  I think extX only
uses the first if it is good, but I don't know for certain.

NeilBrown


>=20
> On 07-06-12 14:29, NeilBrown wrote:
> > On Thu, 7 Jun 2012 13:55:32 +0200 Martin Ziler<martin.ziler@googlemail.=
com>
> > wrote:
> >
> >> Hello everybody,
> >>
> >> I am running a 9-disk raid6 without hot spares. I already had one driv=
e go bad, which I could replace and continue using the array without any de=
graded raid messages. Recently I had another drive going bad by the smart-i=
nfo. As it wasn't quite dead I left the array as was without really using i=
t all that much waiting for a replacement drive I ordered. As I booted the =
machine up in order to replace the drive I was greeted by an inactive array=
 with all devices showing up as spares.
> >>
> >> md0 : inactive sdh2[0](S) sdi2[7](S) sde2[6](S) sdd2[5](S) sdf2[1](S) =
sdg2[2](S) sdc1[9](S) sdb2[3](S)
> >>        15579088439 blocks super 1.2
> >>
> >> mdadm --examine confirms that. I already searched the web quite a bit =
and found this mailing list. Maybe someone in here can give me some input. =
Normally a degraded raid should still be active. So I am quite surprised th=
at my array with only one drive missing goes inactive. I appended the info =
mdadm --examine puts out for all the drives. However the first two should p=
robably suffice as only /dev/sdk differs from the rest. The faulty drive - =
sdk - is still recognized as a raid6 member, wheres all the others show up =
as spares. With lots of bad sectors sdk isn't accessible anymore.
> > You must be running 3.2.1 or 3.3 (I think).
> >
> > You've been bitten by a rather nasty bug.
> >
> > You can get your data back, but it will require a bit of care, so don't=
 rush
> > it.
> >
> > The metadata on almost all the devices have been seriously corrupted.  =
The
> > only way to repair it is to recreate the array.
> > Doing this just writes new metadata and assembles the array.  It doesn'=
t touch
> > the data so if we get the --create command right, all your data will be
> > available again.
> > If we get it wrong, you won't be able to see your data, but we can easi=
ly stop
> > the array and create again with different parameters until we get it ri=
ght.
> >
> > First thing to do it to get a newer kernel.  I would recommend the late=
st in
> > the 3.3.y series.
> >
> > Then you need to:
> >   - make sure you have a version of mdadm which gets the data offset to=
 1M
> >     (2048 sectors).  I think 3.2.3 or earlier does that - don't upgrade=
 to
> >     3.2.5.
> >   - find the chunk size - looks like it is 4M, as sdk2 isn't corrupt.
> >   - find the order of devices.  This should be in your kernel logs in
> >      "RAID conf printout".  Hopefully device names haven't changed.
> >
> >   Then (with new kernel running)
> >
> >    mdadm --create /dev/md0 -l6 -n9 -c 4M -e 1.2 /dev/sdb2 /dev/sdc2 /de=
v/sdd2 \
> >       /dev/sde2 /dev/sdf2 /dev/sdg2 /dev/sdh2 /dev/sdi2 missing \
> >       --assume-clean
> >
> >   Make double-sure you add that --assume-clean.
> >
> >   Note the last device is 'missing'. That corresponds to sdk2 (which we
> >   know is device 8 - the last of 9 (0..8)).  It fails so it not part of=
 the
> >   array any more.  The others I just guessed the order.  You should try=
 to
> >   verify it before you proceed (see RAID conf printout in kernel logs).
> >
> >   After the 'create' use "mdadm -E" to look at one device and make sure
> >   the Data Offset, Avail Dev Size and Array Size are the same as we saw
> >   on sdk2.
> >   If it is, try "fsck -n /dev/md0". That assumes ext3 or ext4.  If you =
had
> >   something else on the array some other command might be needed.
> >
> >   If that looks bad, "mdadm -S /dev/md0" and try again with a different=
 order.
> >   If it looks good, "echo check>  /sys/block/md0/md/sync_action" and wa=
tch
> >    "mismatch_cnt" in the same directory.  If it says low (few hundred a=
t most)
> >   all is good.  If it goes up to thousands something is wrong - try ano=
ther
> >   order.
> >
> >   Once you have the array working again,
> >      "echo repair>  /sys/block/md0/md/sync_action"
> >   then add your new device to be rebuilt.
> >
> > Good luck.
> > Please ask if you are unsure about anything.
> >
> > NeilBrown
> >
> >>
> >> /dev/sdk2:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
> >>             Name : server:0  (local to host server)
> >>    Creation Time : Mon Jul 25 23:40:50 2011
> >>       Raid Level : raid6
> >>     Raid Devices : 9
> >>
> >>   Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
> >>       Array Size : 27172970496 (12957.08 GiB 13912.56 GB)
> >>    Used Dev Size : 3881852928 (1851.01 GiB 1987.51 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>            State : clean
> >>      Device UUID : 882eb11a:33b499a7:dd5856b7:165f916c
> >>
> >>      Update Time : Fri Jun  1 20:26:45 2012
> >>         Checksum : b8c58093 - correct
> >>           Events : 623119
> >>
> >>           Layout : left-symmetric
> >>       Chunk Size : 4096K
> >>
> >>     Device Role : Active device 8
> >>     Array State : AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >>
> >> /dev/sdh2:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
> >>             Name : server:0  (local to host server)
> >>    Creation Time : Mon Jul 25 23:40:50 2011
> >>       Raid Level : -unknown-
> >>     Raid Devices : 0
> >>
> >>   Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>            State : active
> >>      Device UUID : 44008309:1dfb1408:cabfbd0a:64de3739
> >>
> >>      Update Time : Thu Jun  7 12:27:52 2012
> >>         Checksum : 27f93899 - correct
> >>           Events : 2
> >>
> >>     Device Role : spare
> >>     Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >> ----------------------------------------------------------------------=
-----------------------------------------
> >>
> >> /dev/sdi2:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
> >>             Name : server:0  (local to host server)
> >>    Creation Time : Mon Jul 25 23:40:50 2011
> >>       Raid Level : -unknown-
> >>     Raid Devices : 0
> >>
> >>   Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>            State : active
> >>      Device UUID : 135f196d:184f11a1:09207617:4022e1a5
> >>
> >>      Update Time : Thu Jun  7 12:27:52 2012
> >>         Checksum : 9ded8f86 - correct
> >>           Events : 2
> >>
> >>
> >>     Device Role : spare
> >>     Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >> /dev/sde2:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
> >>             Name : server:0  (local to host server)
> >>    Creation Time : Mon Jul 25 23:40:50 2011
> >>       Raid Level : -unknown-
> >>     Raid Devices : 0
> >>
> >>   Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>            State : active
> >>      Device UUID : 3517bcc4:2acb381f:f5006058:5bd5c831
> >>
> >>      Update Time : Thu Jun  7 12:27:52 2012
> >>         Checksum : 408957c0 - correct
> >>           Events : 2
> >>
> >>
> >>     Device Role : spare
> >>     Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >> /dev/sdd2:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
> >>             Name : server:0  (local to host server)
> >>    Creation Time : Mon Jul 25 23:40:50 2011
> >>       Raid Level : -unknown-
> >>     Raid Devices : 0
> >>
> >>   Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>            State : active
> >>      Device UUID : 9e8b2d2c:844a009a:fd6914a2:390f10ac
> >>
> >>      Update Time : Thu Jun  7 12:27:52 2012
> >>         Checksum : e6bdee68 - correct
> >>           Events : 2
> >>
> >>
> >>     Device Role : spare
> >>     Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >> /dev/sdf2:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
> >>             Name : server:0  (local to host server)
> >>    Creation Time : Mon Jul 25 23:40:50 2011
> >>       Raid Level : -unknown-
> >>     Raid Devices : 0
> >>
> >>   Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>            State : active
> >>      Device UUID : 87ad38ac:4ccbd831:ee5502cd:28dafaad
> >>
> >>      Update Time : Thu Jun  7 12:27:52 2012
> >>         Checksum : 2b7a47f6 - correct
> >>           Events : 2
> >>
> >>
> >>     Device Role : spare
> >>     Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >> /dev/sdg2:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
> >>             Name : server:0  (local to host server)
> >>    Creation Time : Mon Jul 25 23:40:50 2011
> >>       Raid Level : -unknown-
> >>     Raid Devices : 0
> >>
> >>   Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>            State : active
> >>      Device UUID : eef2f06f:28f881a5:da857a00:fb90e250
> >>
> >>      Update Time : Thu Jun  7 12:27:52 2012
> >>         Checksum : 393ba0f8 - correct
> >>           Events : 2
> >>
> >>
> >>     Device Role : spare
> >>     Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >> /dev/sdc1:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
> >>             Name : server:0  (local to host server)
> >>    Creation Time : Mon Jul 25 23:40:50 2011
> >>       Raid Level : -unknown-
> >>     Raid Devices : 0
> >>
> >>   Avail Dev Size : 3985162143 (1900.27 GiB 2040.40 GB)
> >>    Used Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>            State : active
> >>      Device UUID : 4cf86fb0:6f334e2c:19e89c99:0532f557
> >>
> >>      Update Time : Thu Jun  7 12:27:52 2012
> >>         Checksum : a6e42bdc - correct
> >>           Events : 2
> >>
> >>
> >>     Device Role : spare
> >>     Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >> /dev/sdb2:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
> >>             Name : server:0  (local to host server)
> >>    Creation Time : Mon Jul 25 23:40:50 2011
> >>       Raid Level : -unknown-
> >>     Raid Devices : 0
> >>
> >>   Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>            State : active
> >>      Device UUID : 4852882a:b8a3989f:aad747c5:25f20d47
> >>
> >>      Update Time : Thu Jun  7 12:27:52 2012
> >>         Checksum : a8e25edd - correct
> >>           Events : 2
> >>
> >>
> >>     Device Role : spare
> >>     Array State :  ('A' =3D=3D active, '.' =3D=3D missing)--
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/wkZy0bjZhf7Rl4VOg/OUJhE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9Esijnsnt1WYoG5AQI8GBAAmjTMaSlXlcCsWOQhcU1wqb3w9mA7Zafh
HvaS5UkEteyLAKkgoxkvWveKPLNVcniHQzBU2OaEqhutnNKurTdmbPdRA3fmferF
Nwccc5ffM1+ey2aYltKJRaFBxkcSQ8VqQm73k+Yo60PHCnOLMSxkQGfVvm7lZYgl
j05LXwuGgy4pTrGVfh+HlSthFQE6CGqbW3cB1XuDq+JrkBiCOgrdW3tC8J2SI5LK
h0/Ump/a1gsr898eUcDDLExjDPwm46yY7Cvpc6yDSprrlZrX1Y/Iphtag1sxlXPD
u4r2A/RqrD/NHj94/DKk0/eu++1EBSkyAgNVyD5mVjb3WOBmhNTBic1VjeJUxnO4
Y8XwKZ+i5KT3BNqFExHCzgq+rSVtmHJ0fzskor/4Euqi7CvpmreGpq+nB091qLn+
4nQ91/c0fGQFaDnX73Qi+CgE51z8SLV7dQTBUl67P3WO5v0zKKCLxKmZf8f8hoY5
qx4kbbR1CIijZL/J01j2NUlsZ7IiLj58WdXFtatGmJQWuuYETYqJEGguIS5PnjOO
mdxy9wmEEstU4NIiHaU/geDSVYe2UGrYtvgpQSUm3LTi24IhZXxeWf9JkD+x6X0K
rFh6ALvJZW9EK/w63hf+jjayE5DybKTsnPH2rcm9rr3UQ7GpKpOmh8QFr5hRsB3h
RSXVAvmoNSk=
=db5u
-----END PGP SIGNATURE-----

--Sig_/wkZy0bjZhf7Rl4VOg/OUJhE--
