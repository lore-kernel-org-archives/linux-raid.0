From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Sat, 14 Sep 2013 20:38:00 +1000
Message-ID: <20130914203800.385466b2@notabene.brown>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>
	<20130914064305.0baadc69@notabene.brown>
	<CAC9WiBhbyV6Xpu=7HvKUK1hXNw1uC+QZcDOM0R9zUCMrR7WNtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lCK3CUENmH1/YZGaAAMIpIO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBhbyV6Xpu=7HvKUK1hXNw1uC+QZcDOM0R9zUCMrR7WNtQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lCK3CUENmH1/YZGaAAMIpIO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 14 Sep 2013 00:35:47 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hi Neil,
>=20
> On Fri, Sep 13, 2013 at 10:43 PM, NeilBrown <neilb@suse.de> wrote:
> > On Fri, 13 Sep 2013 15:22:20 +0200 Francis Moreau <francis.moro@gmail.c=
om>
> > wrote:
> >
> >> Hi Neil,
> >>
> >> I'm probably doing something wrong since it's a pretty critical bug
> >> but can't see what.
> >>
> >> I'm creating a RAID1 array with 1.2 metadata. After that I stop the
> >> array, and restart the array with only one disk. I write random data
> >> on the array and then stop it again:
> >>
> >> # mkfs.ext4 /dev/md125
> >> # mdadm --stop /dev/md125
> >> # mdadm -IRs /dev/loop0
> >> # mount /dev/md125 /mnt/
> >> # date >/mnt/foo
> >> # umount /mnt
> >> # mdadm --stop /dev/md125
> >>
> >> Finally I restart the array with the 2 disks (one disk is outdated)
> >> and mdadm happily activates the array without error. Note that I add
> >> the outdated disk first in that case:
> >>
> >> # mdadm -IRs /dev/loop1
> >> mdadm: /dev/loop1 attached to /dev/md/array1, which has been started.
> >> # mdadm -IRs /dev/loop0
> >> mdadm: /dev/loop0 attached to /dev/md/array1 which is already active.
> >
> > That's a worry.  I'm not sure how to fix it.
> >
> > I would probably suggest you don't use "-IR" to add devices.  That woul=
d make
> > it a lot less likely to happen.
> >
>=20
> Well I'm not sure how I should start an array...
>=20
> For example doing:
>=20
> # mdadm -I /dev/loop0
> # mdadm -I /dev/loop1
> # mdadm -R /dev/md125
>=20
> works for array using metadata 1.2 but doesn't if the array is using
> DDF (mdmon not started). To workaround this issue you suggested to use
> -IRs:
>=20
> # mdadm -IRs /dev/loop0
> # mdadm -IRs /dev/loop1

This isn't what I meant.
I mean that after you had run
  mdadm -I /dev/foo
for all devices, you then run
  mdadm -IRs
to start any that are degraded.

BTW I think I've fixed the issue with mdadm -R /dev/md125 for DDF.
Try the latest git.

NeilBrown


>=20
> but now mdadm can't detect outdated disk anymore.
>=20
> Could you suggest something to start an array which would work in all
> cases (ddf or 1.2, add non-fresh disk...) ?
>=20
> >
> >> # cat /proc/mdstat
> >> Personalities : [raid1]
> >> md125 : active raid1 loop0[0] loop1[1]
> >>       117056 blocks super 1.2 [2/2] [UU]
> >> # mount /dev/md125 /mnt
> >> # ls /mnt/
> >> [  457.321771] EXT4-fs error (device md125): ext4_lookup:1047: inode
> >> #2: comm ls: deleted inode referenced: 12
> >> ls: cannot access /mnt/1: Input/output error
> >>
> >> If I add the outdated disk last I got this:
> >> # mdadm -IRs /dev/loop0
> >> mdadm: /dev/loop0 attached to /dev/md/array1, which has been started.
> >> # mdadm -IRs /dev/loop1
> >> mdadm: can only add /dev/loop1 to /dev/md/array1 as a spare, and
> >> force-spare is not set.
> >> mdadm: failed to add /dev/loop1 to existing array /dev/md/array1:
> >> Invalid argument.
> >>
> >> which didn't tell me the reason why loop1 must be a spare.
> >
> > It  must be a spare because it is out of date.
> >
>=20
> Yes but I think mdadm should tell the reason, no  ?
>=20
> Thanks


--Sig_/lCK3CUENmH1/YZGaAAMIpIO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjQ8kDnsnt1WYoG5AQJ1Ew/+NTRET4Y2mTc+Kf967JN2PmEVEUAau1yF
N5hbiTRi5AcF1hZOj3xguUOFGLa3gwwtvOdQsjTJ8FGnInsMFVMykt6mvMRznZlf
arTkGb8JR0qsRR6N1AVYf3ynxikH7iFMiE0ffuPl7yNGDVvQ9MNUpvgoTic/wCWc
FVmWofFO0a8JuIir6EIdeN1LN217Um5KGlLZOdqrUf6YDgxY2ZDXu6Xsaw3ggFKn
hQ6w6eEpgSscBQdC9c4EK0uC8SVfiuSDd44j3CMZ+Z6+saBz2jFnbQ8G642ggha6
gVVCObE64nJH8IzDuuBQQexbhrIlT+PHNIoubweX1qIitgIFo1etM/VZLya/K9al
PkeWGuUN2N0mnVSpXB7e6hMafWV+TqzwQK0QyFpNKHZnLC4HbDrUpbc5Q1LXpMLN
29jtSioL//5wHR2CMwSm4sGV4/iBTZnSAPRodnaxbAo9HtuOKkVrQTEwYPFSU0DG
bbde9VI7tBlHzN/mZ1uOpunx9D34QL1jQwDLsbW9n5F+KxPpyxMDmF35fQjxG5Nd
oMxWHXU9U/SycODroLE2tn0vz8Dog8uEFDvjTJHGX5h/3L74/L354I5ILAaJmSQ4
Fc7dcKsAZbDg8kBCb00iQyWL+ZGe+TcZl2hmdk8V/yj+CGWu86ejF41f23cUj0jI
NZysMdbA9f8=
=NNch
-----END PGP SIGNATURE-----

--Sig_/lCK3CUENmH1/YZGaAAMIpIO--
