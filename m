From: NeilBrown <neilb@suse.de>
Subject: Re: homehost and 0.90 format
Date: Tue, 25 Nov 2014 15:02:37 +1100
Message-ID: <20141125150237.17f2ddfc@notabene.brown>
References: <F1F13E14A610474196571953929C020963C639@ex08.net.ucsf.edu>
	<20141125140821.6ece0afb@notabene.brown>
	<F1F13E14A610474196571953929C02096432BD@ex08.net.ucsf.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NpgYCDt6oTIHq113LKkbX3/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F1F13E14A610474196571953929C02096432BD@ex08.net.ucsf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Boylan, Ross" <Ross.Boylan@ucsf.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/NpgYCDt6oTIHq113LKkbX3/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Nov 2014 03:31:32 +0000 "Boylan, Ross" <Ross.Boylan@ucsf.edu>
wrote:

> Thanks; I didn't know one could do that.
>=20
> But am I correct in my understanding that if 2 arrays have the same homeh=
ost they will have the same end (last half?) of the UUID?  That would mean =
the 2 devices I'm looking at can't have the same homehost.

Yes, that is correct.

>=20
> I am able to guess the homehost for one of them using your trick; none of=
 the possibilities have tried have matched the other.

Can't help you there, sorry.

You can always look at the content of the array, device what host it *shoul=
d*
belong  to, and the assemble the array with=20
  --update=3Dhomehost --homehost=3Dreal-host

to "fix" the uuid.

NeilBrown


>=20
> Ross
> ________________________________________
> From: NeilBrown [neilb@suse.de]
> Sent: Monday, November 24, 2014 7:08 PM
> To: Boylan, Ross
> Cc: linux-raid@vger.kernel.org
> Subject: Re: homehost and 0.90 format
>=20
> On Tue, 11 Nov 2014 03:14:34 +0000 "Boylan, Ross" <Ross.Boylan@ucsf.edu>
> wrote:
>=20
> > I am trying to figure out which of my RAID devices is considered home. =
 I haven't switched machines, but I have several operating systems, with di=
fferent hostnames, on the machine.  0.90 format metadata.
> >
> > Even 2 RAID devices created on the same OS don't seem to have any UUID =
in common.  i thought that the end of the UUID's would be the same.  For ex=
ample, inhttp://marc.info/?l=3Dlinux-raid&m=3D123999237229707 Neil Brown sa=
ys
> > > Note that 0.90 metadata does contain homehost information to some
> > > extent.  When homehost is set, the last few bytes of the uuid is set
> > > from a hash of the homehost name.  That makes it possible to test if a
> > > 0.90 array was created for 'this' host, but not to find out what host
> > > it was created for.
> >
> > mdadm.conf has
> > HOMEHOST <system>
> >
> > The 2 UUIDS are
> >  8691ad98:af955756:ae5efbfa:dfd20ce6
> > 6d89d3b5:19a0acce:319e1a9c:58606385
> >
> > Thanks,
> > Ross Boylan
>=20
> You need to guess-and-test.
> e.g.
>=20
>   mdadm --detail /dev/md7 --homehost=3Dfoo | grep UUID
>=20
> If it says "(local to host foo)", then "foo" is the correct name.
> If not, then try a different name.
>=20
> NeilBrown
>=20
>=20
> >
> > Details:
> >
> > root@wheezy4:~# mdadm --detail /dev/md7
> > /dev/md7:
> >         Version : 0.90
> >   Creation Time : Fri Oct  3 17:20:13 2014
> >      Raid Level : raid1
> >      Array Size : 48828352 (46.57 GiB 50.00 GB)
> >   Used Dev Size : 48828352 (46.57 GiB 50.00 GB)
> >    Raid Devices : 1
> >   Total Devices : 1
> > Preferred Minor : 7
> >     Persistence : Superblock is persistent
> >
> >     Update Time : Tue Nov  4 17:48:40 2014
> >           State : clean
> >  Active Devices : 1
> > Working Devices : 1
> >  Failed Devices : 0
> >   Spare Devices : 0
> >
> >            UUID : 8691ad98:af955756:ae5efbfa:dfd20ce6
> >          Events : 0.1
> >
> >     Number   Major   Minor   RaidDevice State
> >        0       8       20        0      active sync   /dev/sdb4
> > root@wheezy4:~# mdadm --detail /dev/md8
> > /dev/md8:
> >         Version : 0.90
> >   Creation Time : Tue Sep 30 13:27:56 2014
> >      Raid Level : raid1
> >      Array Size : 970702784 (925.73 GiB 994.00 GB)
> >   Used Dev Size : 970702784 (925.73 GiB 994.00 GB)
> >    Raid Devices : 2
> >   Total Devices : 1
> > Preferred Minor : 8
> >     Persistence : Superblock is persistent
> >
> >     Update Time : Mon Nov 10 18:16:11 2014
> >           State : clean, degraded
> >  Active Devices : 1
> > Working Devices : 1
> >  Failed Devices : 0
> >   Spare Devices : 0
> >
> >            UUID : 6d89d3b5:19a0acce:319e1a9c:58606385
> >          Events : 0.790792
> >
> >     Number   Major   Minor   RaidDevice State
> >        0       8       19        0      active sync   /dev/sdb3
> >        1       0        0        1      removed
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Sig_/NpgYCDt6oTIHq113LKkbX3/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHP/XTnsnt1WYoG5AQKPLQ/8CFv7Y6YKUa5FsCWyLEyC/XGj7QUUyigo
7Cn8jvGKeeYa1gWnVwtlRUWlR/9BiojgUDy0TZTAycY80iHHu8rprIEOOb7eSdi6
IAAp5BItV6vmSSRfNDE5icahUMBdUBM0SkfBl7U2XRjd7MAUvI3mIrEZFPWJkkSJ
Vp40D0O3XVi63LVEJa9VI/75iD5crOYbl0vvtWZ7iZqeOZQkcMTYmdwb2qL5p0It
Al0k/kSHV9c8Q5P+mI37FBJM2pQG1RrcUCb/MRAQVxcP/cNKvrg34nQZ4IR0Hwpn
EDwtVPmYkuSDopX/5qdJfiT8xRaoxR+NCOL5yIKI8WWAfqdibDHl/nNEwuHIBaTv
4WnQrDc1x2BtYjetisR4v8RXc+0gc7/6o3RpmN1Pkv7XJ5iqgXSrysFVsUbukvMj
wdGjb8llYejnp3ObZF3PNxCNidNOHHwCgnXzFeqvHaEDjEnQ03flECxi4UzdyhNK
KvAEAX9qMP+0G43dw9gsEmetm9XySW+HBZd5GkyWBPOSDgwLHjavV5462X0gcoL5
envGcYiSwWaGGF6T8gdWzowQ1IkYB151F1FCPC5MedIv3veEXFUj6TetUqULVHyw
yw4PI5mqINe8gz4b9SWkEP3AGFRM1Bsz7hPUgshoMc0yg35rvJmWZfHVBrR9bGWV
hsFtVIUDoSw=
=dcuu
-----END PGP SIGNATURE-----

--Sig_/NpgYCDt6oTIHq113LKkbX3/--
