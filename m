From: NeilBrown <neilb@suse.de>
Subject: Re: PROBLEM: write to jbod with 3TB and 160GB drives hits BUG/oops
Date: Mon, 27 Apr 2015 11:11:59 +1000
Message-ID: <20150427111159.46b9781a@notabene.brown>
References: <55398462.1000202@cox.net>
	<KdvS1q00X1hjKLY01dvTMG>
	<553AA35A.5050300@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/_=GCmFhDkMSHjzHTrb.2L1u"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <553AA35A.5050300@cox.net>
Sender: linux-raid-owner@vger.kernel.org
To: Charles Bertsch <cbertsch@cox.net>
Cc: linux-raid@vger.kernel.org, "BertschC@acm.org" <BertschC@acm.org>
List-Id: linux-raid.ids

--Sig_/_=GCmFhDkMSHjzHTrb.2L1u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2015 13:11:06 -0700 Charles Bertsch <cbertsch@cox.net> wrote:

> On 04/23/2015 06:55 PM, NeilBrown wrote:
> >
> > By "jbod" I assume you mean "linear array".
> >
> > You say this happens without any filesystem on the array, yet the stack
> > traces clearly show ext2 in use.
> > Maybe some weird interaction is happening between the the filesystem an=
d the
> > linear array.
> > But please confirm that the stack trace happened when there was no file=
system
> > on the array you were testing, and report what filesystems you do have =
which
> > use ext2.
> >
> Neil --
> Yes, I do mean linear array.
>=20
> At the point of the stack trace, there was no file-system on the linear=20
> 2-drive array.  The test-jbod-2 script would create the array and then=20
> write directly to /dev/md0.  Any evidence of previous existence of a=20
> file-system would have been obliterated by earlier runs copying=20
> /dev/zero everywhere.
>=20
> The file-systems in use --
> -- The rootfs is an initrd file, squashfs, and mounted read-only.
> -- An ext3 for configuration and logs is mounted RW on /flash
> -- An ext2 using 8MB of RAM is mounted RW on /var
> -- The file-server is derived from a much earlier design that required=20
> some RW directories within the root.  These entries appear in the mount=20
> command as ext2, but are part of /var (and not separate file systems) --
> -- mount --bind /var/hd /hd
> -- mount --bind /var/home /home
>=20
> -- A devtmpfs mounted on /dev, tmpfs on /dev/shm, proc on /proc, sysfs=20
> on /sys, and another mount --bind from within /flash for nfs.
>=20
> # mount
> /dev/root on / type squashfs (ro,relatime)
> devtmpfs on /dev type devtmpfs=20
> (rw,relatime,size=3D1002600k,nr_inodes=3D250650,mode=3D755)
> proc on /proc type proc (rw,relatime)
> sysfs on /sys type sysfs (rw,relatime)
> /dev/ram1 on /var type ext2 (rw,relatime,errors=3Dcontinue)
> /dev/ram1 on /hd type ext2 (rw,relatime,errors=3Dcontinue)
> /dev/ram1 on /home type ext2 (rw,relatime,errors=3Dcontinue)
> tmpfs on /dev/shm type tmpfs (rw,relatime)
> /dev/sdb1 on /flash type ext3=20
> (rw,noatime,errors=3Dcontinue,commit=3D60,barrier=3D1,data=3Dordered)
> /dev/sdb1 on /var/lib/nfs type ext3=20
> (rw,noatime,errors=3Dcontinue,commit=3D60,barrier=3D1,data=3Dordered)
> nfsd on /proc/fs/nfsd type nfsd (rw,relatime)
> #

Thanks for the details.
On the whole, I don't think it is likely that your problem is directly
related to md - just a coincidence that it happened when you were using md
things.  But one never knows until that actual cause is found.

>=20
>  > Is there any chance you could use "git bisect" to find out exactly whi=
ch
>  > commit introduced the problem?  That is the mostly likely path to a=20
> solution.
>  >
>=20
>=20
> I am not familiar with "git bisect".  Would this be similar to=20
> downloading a series of kernel releases from linux-3.3.5 up to 3.18.5=20
> using a binary search to find which release (rather than which commit)=20
> has the problem ?

Similar, but (some of) the boring work is all done for you.

It would be best to stick to mainline kernels for testing.  i.e. just '3.x',
not '3.x.y'.

So presumably 3.3 works, and 3.18 fails.
In that case:

   git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
   cd linux
   git bisect start
   git bisect good v3.3
   git bisect bad v3.18

That should get you started, except that it seems to take an incredibly long
time.  So probably do the first few steps by hand.
e.g

   git checkout v3.10

and test that.  Then try v3.7 or v3.14.

Once you know which of those are good or bad, run e.g.
  git bisect start
  git bisect good v3.7
  git bisect bad v3.10

and that will checkout a kernel somewhere in the middle and tell you there
are 14 (or so) steps to go.

Then build and test the kernel. If it is good, run "git bisect good".
If bad, "git bisect bad".

If you can persist through testing over a dozen kernels (takes some
patience!!) it should lead you to the commit that introduced the problem.
It is always best to be caution before declaring a kernel 'good' - run the
test a few times.

>=20
> Thanks
>=20
> Charles Bertsch


NeilBrown

--Sig_/_=GCmFhDkMSHjzHTrb.2L1u
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT2M3znsnt1WYoG5AQIauhAAxJz1jKeqkty81UV4dVs4x8J4QMC6oSVs
YGfuifC8k0aO7ArppLmPU9BLIcYb85OXK7gjZd5gLizgOICl6USF76FdaOe1w6mW
mDYWjh6nkkIOJmEl4Jc+MqID7Kqo06lVK3D8QZOZN6uu5+36SWUpAFzXoYI7FwJ9
aKIHZIWMr4R/tS6VPlxbiOsgpvyCClR1EdoZ8jHc7prHxJr0POzcQ49MauWh1YWN
QqTXwTHNrOW3ZhhrtQJs/MUwS2udYtBrhKBrX0/RPk1dlewqgFLyjhpYmdKM6Y7B
uZgzD50G99TDi9J2gNnrFGwhMPTGBx8Dzxp4L5s0K9I+I+GhaO4r7gbxv9yKM5fx
eAyTO1koEvgalj1NgLOr32J8KExdFAMQpghbVN3MN0SDHhxwSY37nomS1N/X8g1p
NpJjz4HkvUDd74av7K7X2oIegJ8hPvUGH+BYGNuJIIq5GqJDCQuuKwvaaY1usVFw
ZbllQ6RmkUpEyERk6DJjBIXX+QVn/EXKNi9RKvsE5dDL4tdIJ7MleEwmTWUfuvi1
6G9q18ao49R91zVDaJGpCo1uI3hJpFTreRGFPLs7rkp0xuXbOV8BHi/i4rz56as+
Akv9UKaRkS7Py2EmH+iFIMnMruOGNjT7pSdmGAvsG7ohWZPH4a9VmCOXPxqMTNTK
EONdEMrZ9Hw=
=DKD2
-----END PGP SIGNATURE-----

--Sig_/_=GCmFhDkMSHjzHTrb.2L1u--
