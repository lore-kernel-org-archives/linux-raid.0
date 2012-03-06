From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: sending ioctl 1261 to a partition!
Date: Tue, 6 Mar 2012 13:27:01 +1100
Message-ID: <20120306132701.1b9600f4@notabene.brown>
References: <4F54B997.3060207@crc.id.au>
	<4F54D314.9060504@anonymous.org.uk>
	<4F550BA8.3010306@crc.id.au>
	<20120306070143.4f8abc0e@notabene.brown>
	<4F556FA1.5020006@crc.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aSCkcSBOKyPPjOd=DP_mBQA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F556FA1.5020006@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/aSCkcSBOKyPPjOd=DP_mBQA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 06 Mar 2012 13:00:01 +1100 Steven Haigh <netwiz@crc.id.au> wrote:

> On 6/03/2012 7:01 AM, NeilBrown wrote:
> > On Tue, 06 Mar 2012 05:53:28 +1100 Steven Haigh<netwiz@crc.id.au>  wrot=
e:
> >
> >> On 6/03/2012 1:52 AM, John Robinson wrote:
> >>> On 05/03/2012 13:03, Steven Haigh wrote:
> >>>> I've noticed that recently I've managed to get a ton of messages like
> >>>> this at boot:
> >>>>
> >>>> mdadm: sending ioctl 1261 to a partition!
> >>>> mdadm: sending ioctl 800c0910 to a partition!
> >>>
> >>> It's probably harmless.
> >>>
> >>> http://lists.debian.org/debian-kernel/2012/01/msg01105.html says "This
> >>> warning was introduced as part of the fix for CVE-2011-4127"
> >>>
> >>> https://bugzilla.redhat.com/show_bug.cgi?id=3D783955#c4 says "Actuall=
y,
> >>> the warning seems a false positive to me"
> >>
> >> I did see these - and I probably should have mentioned it in the
> >> original post. Naughty me for posting at times I should really be asle=
ep.
> >>
> >> The general jist of it seemed to be "it always failed before, now we
> >> just know about it". What makes me wonder is that if it always failed
> >> before, why do we do it in the first place?
> >>
> >
> > 800c0910 is 'are you an md device'.  So failure is a valid response.
> >
> > 1261 is flush-bufs.  I hope that does still work on partitions....
>=20
> Thanks Neil, Any ideas how I can test this to check if flush-bufs is=20
> working? While I'm not a code junkie these days - I'm great at picking=20
> holes in thing ;)

Read the code....

In block/ioctl.c
	case BLKFLSBUF:
		if (!capable(CAP_SYS_ADMIN))
			return -EACCES;

		ret =3D __blkdev_driver_ioctl(bdev, mode, cmd, arg);
		/* -EINVAL to handle old uncorrected drivers */
		if (ret !=3D -EINVAL && ret !=3D -ENOTTY)
			return ret;

		lock_kernel();
		fsync_bdev(bdev);
		invalidate_bdev(bdev);
		unlock_kernel();
		return 0;


So it is still called fsync_bdev and invalidate_bdev as long as the ioctl
function for the underlying disk returns -EINVAL or -ENOTTY.

The function that shows that warning is scsi_verify_blk_ioctl in
block/scsi_ioctl.c
The worst it can do is return -ENOTTY, and that is safe.

So the warning is bogus, the code still works.

NeilBrown



>=20
> I picked it up as it only seemed to be visible in 2.6.32.56. I don't=20
> recall seeing it in any previous 2.6.32.x kernel.
>=20


--Sig_/aSCkcSBOKyPPjOd=DP_mBQA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1V19jnsnt1WYoG5AQJoAQ/9F7PdQGMU6+xWUV6FzZcNr5/jKkTXnWD0
njfhCBj9k3L+HHP2lTYKBlJrZReZWNYHhNCpQaHAg1Fvms4QobcygpMGBe7d6Fmx
0VDLT5rhyGnBQucJ9AkRGsylcpmbg8nD+9VAw4ubcrGLCUx5r/ZoIJXqrTUWf8VZ
gKQ5PAvCBVs5S0WLsYU8A+DYVJK9AtUvDLIMzhlmjDp2Ku9I7aFuo6yMTvtYvbzf
JjunQ/jdV7U4mmn20BFSFJvGK9cB8o9chyJBNYOqNh4MBhcStLVnx6MMAa0aqHmO
HV7VxpH7ZK7cl02tfQiX0g45dPcZfiy8ZyYJn+C7YzwXOibhckiZMaNh7yeJUIvI
V1wN3Tf4N0xevF6NNNo8Bzg/RO6YFEnd9jGeP9oca9LZgkHo926ukGsyVG4YqS5w
5pAhSOHsHoaXRd0NJC0VTO+Tkg2h7S97atGBO0GV1qAEI2QqzKk4Fp3ZMsh+AHXE
i0I7NAWTaTEh0+VMr4kmoJhvxj2p1oABSAff72os+ofBbdHZqvBFT29MC5qucYju
KYgYWWzQ6/3Bz39YnIyr0oge+refZ4xiQjwKH58EpSoXDAw+VGXSN8c/DPuLrRUX
AbrOMbm4Wx+ymoGk9+BBPsXb3/b4HPHuKJkslHFvWAwOuPSJ0RjISaxSmQxHbsSx
oMFwEShOiY8=
=D6tD
-----END PGP SIGNATURE-----

--Sig_/aSCkcSBOKyPPjOd=DP_mBQA--
