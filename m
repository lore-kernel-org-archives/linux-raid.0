From: NeilBrown <neilb@suse.de>
Subject: Re: recovering from raid5 corruption
Date: Mon, 30 Apr 2012 11:09:59 +1000
Message-ID: <20120430110959.561b1a4f@notabene.brown>
References: <4F9DC2E5.1090509@gmail.com>
	<20120430085257.65d19c20@notabene.brown>
	<4F9DCEC6.1050109@gmail.com>
	<20120430094546.4702be0a@notabene.brown>
	<4F9DE0EC.6080401@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ijLVpZ7u7mIkZfor2w40DC8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9DE0EC.6080401@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaya Potter <spotter@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ijLVpZ7u7mIkZfor2w40DC8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 29 Apr 2012 20:46:36 -0400 Shaya Potter <spotter@gmail.com> wrote:

> On 04/29/2012 07:45 PM, NeilBrown wrote:
> > On Sun, 29 Apr 2012 19:29:10 -0400 Shaya Potter<spotter@gmail.com>  wro=
te:
> >
> >> On 04/29/2012 06:52 PM, NeilBrown wrote:
> >>>
> >>> You've written a new superblock 4K in to each device, where previousl=
y here
> >>> was something.   So you have probably corrupted something though we c=
annot
> >>> easily tell what.
> >>>
> >>> Retry your experiment with --metadata=3D0.90.  Hopefully one of those
> >>> combinations will work better.  If it does, make a backup of the data=
 you
> >>> want to keep, then I would suggest rebuilding the array from scratch.
> >>
> >> ok, thanks, that was a huge help.
> >>
> >> I have it setup correctly now (obvious due to the fact that I can read
> >> the lvm configuration without any gibberish when ordered correctly).
> >
> > I should add that this only proves that you have the first device corre=
ct,
> > the rest may be wrong.
> > You need to activate the LVM, then look at the filesystem and see if it=
 is
> > consistent before you can be sure that all devices are in the correct
> > position.
>=20
> this cheat sheet came in handy
>=20
> http://www.datadisk.co.uk/html_docs/redhat/rh_lvm.htm
>=20
> did the method at the bottom "corrupt LVM metadata but replacing the=20
> faulty disk"
>=20
> copy/paste config file out of beginning of fs.
>=20
> pvcreate --uuid <uuid for pv0, from config file> /dev/md0
> vgcfgrestore -f <config file> <pv name>
> vgchange -a y <pv name>
>=20
> some cursory testing of large contigious files that have checksumming=20
> built in seems to indicate that they are all ok.  probably have other=20
> corruption due to the md 0,90 to 1.20 metadata booboo, but if that's=20
> only 16k-20k (4k * 4 or 5 disks) spread out over 3tb of data, I'm very=20
> happy :)  and it's mostly family photo data, so not the biggest deal if=20
> the large majority is ok.
>=20
> <shew> relieved.

Excellent.  Thanks for keeping us informed.

If you were using 3.3.1, 3.3.2, or 3.3.3 when this happened, then I know wh=
at
caused it and suggest upgrading to 3.3.4.

NeilBrown

--Sig_/ijLVpZ7u7mIkZfor2w40DC8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT53mZznsnt1WYoG5AQJIjQ/+P3MCLf9SMFe7jJta4UukAdHQFKsL3cu4
i8LUp4eRvsA2wgMVkIae9cVRI/vO+CDRdZUO3wxmu3ThVyyZCdOty+ofnsNGqPUT
ESi92QJayiOaJbe1PjR5+xnodXejY5ID9qGLQuAY0h/KTcIdozqPRmMzUeyDMJ1J
3tkSa2Ld4ewbLghM1P4HjSUmhlTThKFSkVbpMCyK0xHQNl6POOikkwDVFhNeiOWQ
Z4Opgp60poKP0AdzcI6Ej7h22sHvbCWto9z7ggXikcCvA6tdIv8xOcyOXommMoEp
/FNJwdm7SpQ9IgKJp1fZNtMj0myY86h7uIF41xfltdlPpF2dIkhaQzlfZSvk/ax3
yEWXAxZwy6qHKT6p0PpZ6dx4aSWvnS8ne8S0vP7EIJfE4zimjhiWV3j6fI94Jw5X
6z4WM/GJSJG85yNtgTQ47x9RYD41p3Vz7KV7+lzZcqZe2+hAYrfM16EJR1s8NnN8
NFsHNTAKvaT3bfNDQfzw3bvqz8zYMegpNA0wXvayrbUHV/4hqSX3hacSp8/sjQ4d
izYm/rUCMXmHVGCdUvGvZ8/8XE2yg5J3hLbzoP1YAxH6pJFQ1US4H7E/tj/Hs63k
kJX14ovdiNluCeHeyNc7tIHdy+OVD1HRy4aGghmSFLcwKA7m/GVxl//NC2sWOOLc
21QDI2BKUww=
=Socw
-----END PGP SIGNATURE-----

--Sig_/ijLVpZ7u7mIkZfor2w40DC8--
