From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: use static major/minor numbers.
Date: Thu, 22 Nov 2012 07:57:13 +1100
Message-ID: <20121122075713.240e783d@notabene.brown>
References: <50AB7964.60002@mpstor.com>
	<20121121081622.162d6f08@notabene.brown>
	<50ACC858.6030105@mpstor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_cm/EMDa/DtNJty7P0k5F5g"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50ACC858.6030105@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/_cm/EMDa/DtNJty7P0k5F5g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Nov 2012 12:26:00 +0000 Benjamin ESTRABAUD <be@mpstor.com> wrote:

> On 20/11/12 21:16, NeilBrown wrote:
> > On Tue, 20 Nov 2012 12:36:52 +0000 Benjamin ESTRABAUD <be@mpstor.com> w=
rote:
> >
> >> Hi!
> >>
> >> I recently updated mdadm-2.6.9 to mdadm-3.2.6 on a system (own busybox
> >> based distro) that had its kernel version updated from 2.6.35 to 3.4.
> >>
> >> Everything works well apart from a feature I used that I seem to be
> >> unable to reactivate:
> >>
> >> In the past, to ensure knowing the number of possible RAID devices that
> >> could be created on the system, I used static major:minor mappings by
> >> building the /dev/md/dXX and /dev/md/dXXpXX entries (with major 254, a=
nd
> >> three minors for each device for 3 partitions), allowing me to be
> >> certain that 64 RAID devices could be created at all times.
> >>
> >> When creating an array, the /dev/md/dXX and dXXpXX devices "nodes" wou=
ld
> >> be used (not recreated) and the major/minor number these devices point
> >> to would be used for the actual MD block device.
> >>
> >> This was a very handy feature. With the latest mdadm, I simply cannot =
do
> >> that, as creating a /dev/md/dXX will in fact remove that device file a=
nd
> >> symlink it to /dev/md_dXX. I then created /dev/md_dXX devices prior to
> >> creating an array, and got the following error message: "mdadm:
> >> /dev/md_d3 exists but looks wrong, please fix".
> >>
> >> Looking through the source I can see that mdadm basically verifies if
> >> the file's major/minor matches the one that it had planned for the
> >> device, which in this case doesn't.
> >>
> >> Is there any way to work around that? Or in fact, I don't actually
> >> *need* to use static major/minor numbers, but I need to know in advance
> >> how many RAIDs I'll be able to create provided I'll always use 2
> >> partitions for them and can provide the -amdp2 argument to mdadm to ma=
ke
> >> sure that only 2 partitions devices nodes are created.
> >>
> >> Is there a way to know the maximum number of RAIDs that can be created,
> >> provided that nothing else uses major 9 and 254?
> >>
> >> Thank you very much in advance for your help!
> > I don't really understand what your problem is.
> >
> > mdadm should create any devices it needs - unless it detects udev, in w=
hich
> > case it leaves the device creation to udev.
> >
> > So simply don't create any md devices in /dev and let mdadm do whatever=
 is
> > required.
> > Does that approach not suit your needs?  If not, why not?
> >
> > NeilBrown
> Hi Neil,
>=20
> mdadm creates the devices it needs quite well (there is no udev on this=20
> system), but how can I tell how many maximum RAID devices mdadm will be=20
> able to create before running out of major/minors, since their=20
> allocation is done on the fly?
>=20
> Will mdadm use all of "md" registered major (9) minor numbers (9:0-254)?=
=20

Actually I think it is 9:0-4194303.  There are 22 bits for minor numbers.
And yes, md will use as many as needed (Though I haven't tested millions of=
=20
arrays - or even hundreds - so there might be bugs).

> Will it also use the "mdp" registered ones (254) when running out?

mdp uses 4 bits for the partition, so 18 bits available for arrays.
Though you don't really need mdp any more as 'md' devices can now be
partitioned.

>=20
> I need to know how many MD devices I'll be able to create in advance on=20
> that system. Creating the devices beforehand helped with that, since I=20
> had md_d0 254:0 up to md_d127 254:252, I knew that I could create a=20
> maximum of 128 devices.

Creating the device files in /dev doesn't really have any effect on whether
the devices can be created.  It is a bit like creating a whole bunch of
symlinks to non-existent files, and assuming that means that the files can
later be created.

>=20
> What's the maximum number of MD devices that can be created on a=20
> udev-less system provided we specify 2 partitions in mdadm --create?

millions.

NeilBrown


>=20
> Thank you very much in advance for your help.
>=20
> Regards,
> Ben.


--Sig_/_cm/EMDa/DtNJty7P0k5F5g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK1AKjnsnt1WYoG5AQL5PQ//YGKtNCOwuusTszYc4csb29IwhKmr854T
P29Zkan2BXaDs55lYG5diAlQ6ApDe4XRLm4jJq4bs77BojjstkMKzJDS6R+p+4Gs
hZEJdD9wO6E4r3Oqzeqprhd2hAAKgURVjkXs/LYnd/r1eAkGlR5R2MkumvrLA/ut
7RgwR+h/V/nmv624tyPln5rsrZ5jq++hezvomrTfpy1QFLfXpZzi1Xul1rj+9Eqw
iLzQHLhd/XkFMabkBya7Nh9yUgELbKNZkxfrdUCUeSMiARMbgD5zjZ9vqGc4OkwI
yfW2TU+vRdVeepqtmqXcY6T+oEznbRMPS5CSSvX9w4HBttnSY8UnxVZaf+ysjsfy
TBShjq75xyF3lzOrNGyHF0P5NAS2sN8yqojlqvYTHv8Kyw7KE0zCsrmwRztaDaPB
TjXOsrMKeUzIs5piDH4m9p5lv0jEM3RgEhhwUPABkMun2nS/zFHzwT3jaQ2sFQc2
9IQpcjfLIsUAlXUHex0+WZqk2FkPRTYPy+JQoCXutH76A817khht3UP9s0oSCiNM
/ri+joEdQ5pX/JdIP64P3RQuBqu1oezQITOu5SvJU66jKiSPwZoSONbHid+fUxe6
vha7dneIdMi87Qp1fP3cl257sq4STmJjv/UEZ/z5eS5y9gQFOu6VKz9N6BMJadRo
/im6Bddp4g4=
=DaF4
-----END PGP SIGNATURE-----

--Sig_/_cm/EMDa/DtNJty7P0k5F5g--
