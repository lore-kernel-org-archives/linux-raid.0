From: NeilBrown <neilb@suse.de>
Subject: Re: Data Offset
Date: Tue, 5 Jun 2012 08:57:28 +1000
Message-ID: <20120605085728.7e922359@notabene.brown>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com>
	<20120602095237.3822e2c2@notabene.brown>
	<CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com>
	<20120604133526.6da3bf10@notabene.brown>
	<4FCCFDBB.201@pierre-beck.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WmKtsRr7=X_0EPloS.kY+5D"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FCCFDBB.201@pierre-beck.de>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Beck <mail@pierre-beck.de>
Cc: freeone3000 <freeone3000@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WmKtsRr7=X_0EPloS.kY+5D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jun 2012 20:26:05 +0200 Pierre Beck <mail@pierre-beck.de> wrote:

> I'll try and clear up some confusion (I was in IRC with freeone3000).
>=20
> /dev/sdf is an empty drive, a replacement for a failed drive. The Array=20
> attempted to assemble, but failed and reported one drive as spare. This=20
> is the moment we saved the --examines.
>=20
> In expectation of a lost write due to drive write-cache, we executed=20
> --assemble --force, which kicked another drive.
>=20
> @James: remove /dev/sdf for now and replace /dev/sde3, which indeed has=20
> a very outdated update time, with the non-present drive. Post an=20
> --examine of that drive. It should report update time Jun 1st.
>=20
> We tried to re-create the array with --assume-clean. But mdadm chose a=20
> different data offset for the drives. A re-create with proper data=20
> offset will be necessary.

OK, try:

   git clone -b data_offset git://neil.brown.name/mdadm
   cd mdadm
   make

   ./mdadm -C /dev/md1 -e 1.2 -l 5 -n 5 --assume-clean -c 512 \=20
      /dev/sdc3:2048s /dev/sdb3:2048s ???  /dev/sdd3:1024s ???

The number after ':' after a device name is a data offset.  's' means secto=
rs.
With out 's' it means Kilobytes.
I don't know what should be at slot 2 or 4 so I put '???'.  You should fill=
 it
in.  You should also double check the command and double check the names of
your devices.
Don't install this mdadm, and don't use it for anything other than
re-creating this array.

Good luck.

NeilBrown

>=20
> Greetings,
>=20
> Pierre Beck
>=20
>=20
> Am 04.06.2012 05:35, schrieb NeilBrown:
> > On Fri, 1 Jun 2012 19:48:41 -0500 freeone3000<freeone3000@gmail.com>  w=
rote:
> >
> >> Sorry.
> >>
> >> /dev/sde fell out of the array, so I replaced the physical drive with
> >> what is now /dev/sdf. udev may have relabelled the drive - smartctl
> >> states that the drive that is now /dev/sde works fine.
> >> /dev/sdf is a new drive. /dev/sdf has a single, whole-disk partition
> >> with type marked as raid. It is physically larger than the others.
> >>
> >> /dev/sdf1 doesn't have a mdadm superblock. /dev/sdf seems to, so I
> >> gave output of that device instead of /dev/sdf1, despite the
> >> partition. Whole-drive RAID is fine, if it gets it working.
> >>
> >> What I'm attempting to do is rebuild the RAID from the data from the
> >> other four drives, and bring the RAID back up without losing any of
> >> the data. /dev/sdb3, /dev/sdc3, /dev/sdd3, and what is now /dev/sde3
> >> should be used to rebuild the array, with /dev/sdf as a new drive. If
> >> I can get the array back up with all my data and all five drives in
> >> use, I'll be very happy.
> > You appear to have 3 devices that are happy:
> >    sdc3 is device 0   data-offset 2048
> >    sdb3 is device 1   data-offset 2048
> >    sdd3 is device 3   data-offset 1024
> >
> > nothing claims to be device 2 or 4.
> >
> > sde3 looks like it was last in the array on 23rd May, a little over
> > a week before your report.  Could that have been when "sde fell out of =
the
> > array" ??
> > Is it possible that you replaced the wrong device?
> > Or is it possible the the array was degraded when sde "fell out" result=
ing
> > in data loss?
> >
> > I need more precise history to understand what happened, as I cannot su=
ggest
> > a fixed until I have that understanding.
> >
> > When did the array fail?
> > How certain are you that you replaced the correct device?
> > Can you examine the drive that you removed and see what it says?
> > Are you certain that the array wasn't already degraded?
> >
> > NeilBrown
> >


--Sig_/WmKtsRr7=X_0EPloS.kY+5D
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT809WDnsnt1WYoG5AQIcCg/+ICbMRIKmPNer5nzcR3LOkaTnZOHJLkKN
Q1ofnGVqhvP+dNvrIenf8JKdhz24wCVCQT5LA93wM5UPamy2ksvbd1nXe/eoyFyz
YrO6JCfmXdqRMC9n+l2MZAe+VRdv7gx7xD75NWkyagaNg19oWbl4+PZYtvhl3WaF
YbghYPiUI/3KZVMR6plULfFkYsXye5jU+CI+4Y48RvK4YXr5hmucYX3p3wyBYjg9
sXDKWoz2PiidPUvJ9Zg/vgGoCHZmyp4M8jR8RH4XDYJ55YyUEa6rArzGJcG79PXU
4vTtGwvB7GuECoEL+o3NStuUieIeomMbc7i5tOn0APZvtGzrtE5pXWEKAt4XlMi4
2RAiG3PC02+NgtwyGfz8Gsf8JO8hh47wR3EYTS3d2fMLxRNSZ1ULvaiah4Pmvg8a
yVl4q7es2827A2duMIlmayKY4K2rv3R5r1n/N+YwBbDG2EhKQC+m1FNsY/ZuBYjB
gci9Qplsx5IOTR3wpidGgNS6VLK+MRCRZHx8PdrLq2cxGwcoovj8ScASZPBRPpRR
kf88IXaEGZUnqg9gHJohNfH1wtlgrbfRr+xsEJMVnGZp18nSLxLRnp9rBfa51Fbh
HKRAPaiIpuCPc2edQD8YPvEV3aSuVwNrxUxA+ARQtC/emXUAmILunth5fIhebIVK
Xkk2MyKDPw0=
=5GpN
-----END PGP SIGNATURE-----

--Sig_/WmKtsRr7=X_0EPloS.kY+5D--
