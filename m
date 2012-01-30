From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: do not overwrite existing devices' symlinks
Date: Tue, 31 Jan 2012 09:13:57 +1100
Message-ID: <20120131091357.18fa2b75@notabene.brown>
References: <20120123120652.20165.47998.stgit@gklab-128-085.igk.intel.com>
	<20120130122728.3aa8da9a@notabene.brown>
	<D9FFE20C522965449E182ACE73889AEB07067C@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+LqTM15KUF35JVb_KTGCA0g"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB07067C@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

--Sig_/+LqTM15KUF35JVb_KTGCA0g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jan 2012 12:13:05 +0000 "Dorau, Lukasz" <lukasz.dorau@intel.com>
wrote:

> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Monday, January 30, 2012 2:27 AM
> > To: Dorau, Lukasz
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Labun, Marcin; Ciechan=
owski,
> > Ed
> > Subject: Re: [PATCH] fix: do not overwrite existing devices' symlinks
> >=20
> > On Mon, 23 Jan 2012 13:06:52 +0100 Lukasz Dorau <lukasz.dorau@intel.com>
> > wrote:
> >=20
> > > If the device's name is given in /etc/mdadm.conf, create_mddev()
> > > does not check if the map contains a device of this name (mdopen.c:14=
0).
> > > If it does, the symlink of that name will be overwritten.
> > >
> > > create_mddev() has been changed. Now it checks if the map contains
> > > a device of the name given in /etc/mdadm.conf.
> > > If it does, the appropriate suffix is added to the given name.
> > >
> > > Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> >=20
> > Can you please remind me what the big picture problem is here??
> >=20
> > It seem like you are suggesting that if
> >    /dev/md/thing
> >=20
> > is given in mdadm.conf, but some other array is already assembled with =
the
> > name /dev/md/thing, then the array from mdadm.conf should be assembled =
as
> >    /dev/md/thing0
> > or something like that - is that correct?
> >=20
> > I don't think we want that.  If there is a name conflict like  this wit=
h a
> > name given in mdadm.conf, then one of the arrays should fail to assembl=
e as
> > this is really a fairly serious configuration error.
> >=20
> > Or did I misunderstand?
> >=20
>=20
>=20
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Monday, January 30, 2012 2:30 AM
> > To: Dorau, Lukasz
> > Subject: Re: mdadm: checking dev's names from mdadm.conf - question
> >=20
> > On Fri, 20 Jan 2012 09:27:58 +0000 "Dorau, Lukasz" <lukasz.dorau@intel.=
com>
> > wrote:
> >=20
> > > Hi
> > >
> > > Is it OK that mdadm does not check if a symlink of the name given in
> > /etc/mdadm.conf already exists (in function create_mddev() in mdopen.c:=
140) ?
> > >
> > > For example:
> > > If we modify the original /etc/mdadm.conf file:
> > >
> > > ARRAY metadata=3Dimsm UUID=3De92bcf10:ca6b3fbd:95904441:5472d320
> > > ARRAY /dev/md/vol1 container=3De92bcf10:ca6b3fbd:95904441:5472d320
> > member=3D0 UUID=3Dea776aa6:4691d6ee:9400457e:73e1e9d9
> > > ARRAY metadata=3Dimsm UUID=3Dd61a8e6a:ed4e8ed6:dc0f4fb7:f839907e
> > > ARRAY /dev/md/vol2 container=3Dd61a8e6a:ed4e8ed6:dc0f4fb7:f839907e
> > member=3D0 UUID=3Db33bbd5e:964c7acc:66cfdfcc:7a938902
> > >
> > > by adding the 2nd container 's name /dev/md/imsm0 to the 3rd line:
> > >
> > > ARRAY metadata=3Dimsm UUID=3De92bcf10:ca6b3fbd:95904441:5472d320
> > > ARRAY /dev/md/vol1 container=3De92bcf10:ca6b3fbd:95904441:5472d320
> > member=3D0 UUID=3Dea776aa6:4691d6ee:9400457e:73e1e9d9
> > > ARRAY /dev/md/imsm0 metadata=3Dimsm
> > UUID=3Dd61a8e6a:ed4e8ed6:dc0f4fb7:f839907e
> > > ARRAY /dev/md/vol2 container=3Dd61a8e6a:ed4e8ed6:dc0f4fb7:f839907e
> > member=3D0 UUID=3Db33bbd5e:964c7acc:66cfdfcc:7a938902
> > >
> > > mdadm will create the first container /dev/md127 and the symlink of d=
efault
> > name /dev/md/imsm0 (and the first volume /dev/md126 with symlink
> > /dev/md/vol1).
> > > Later it will create the second container /dev/md125 and the symlink =
of the
> > name given in /etc/mdadm.conf - /dev/md/imsm0 - the same as the name of
> > the first container.
> > >
> > > Mdadm does not check if the symlink of the given name already exists =
and it
> > _overwrites_ the first symlink. Is it OK or maybe should it be correcte=
d?
> > >
> >=20
> > Ahhh.. this is where the big-picture bit is...
> >=20
> > I don't have a big problem with it over-writing the symlink - that is w=
hat
> > you asked for in a way.
> >=20
> > However I also wouldn't have a problem with mdadm refusing the assemble=
 the
> > second container as its name is already in use.
> >=20
>=20
>=20
> So, are you going to apply this patch or do you want it to be fixed in an=
other way?

The approaches I said were OK were:
  1/ over-write the symlink
  2/ refuse to assemble the second container

The approach the patch takes is
  3/ use a different name to the one in mdadm.conf

As 3 !=3D 1 and 3 !=3D 2, I'm not going to apply the patch.

NeilBrown


--Sig_/+LqTM15KUF35JVb_KTGCA0g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTycWJTnsnt1WYoG5AQLNxBAAqXYyzbkcTq5su44IL5qlA7WZMDajUu9x
J9imBOa562UbiLuMUtuCVlQ/Vqyro0kRIym4Z0KZZ+25IHS+QcskjB7nPcfmu7nh
e70Z/FPSyHokmB2QV0+khxOHuXVm948u4CVW01+KIsATeeaiQIeBICtwLNkBoVzN
Yez4lNyg33wFtccwhTPAhHlzrc0GExdqVYMjeRZ5MA48ldbv0I23eSNbTr/V88+R
t0e8COdhC0Y0qUoOVKiNIMTexk5xyqSxRA1HUrchPa5dyc0puku52Nc8bY7PKJn0
PKkuaWbCVaeCyMXTiBjsGt8UBb1WVnxDfnQioJBjCl1qWN8qXenvMfWH95r6Wn5a
wmQ+VsKESKMnMM3ZVbZFaek3e6+yIXLeZNHipUjZZszruRqMYw1vZ+kbbwM2PxPt
CHiuaOcUOv4kzWtbjrpTEd5QApWtXcTFRN/W4VBTQ2DB9t/8KzkRWjv+puU3hCib
R4XvRtsZoEuXG6qvQm6CfD3kbp3jszJFab2TyCOaNM4ljXZ08BycSK5zw7UT13g3
kfRTk2ZsdGrbS6rNYfq9Fv6AYKp7RWEAbwXlfBbcQURVgcDXHMMDqfIEHT2cWGzV
74VH2gBVjU3oY1PoiwerZ6VcsJI33eGEIJODGVOJx+Y7T4grbrvDc4oCwB2giMDr
CKAf3ArCS1A=
=7P8H
-----END PGP SIGNATURE-----

--Sig_/+LqTM15KUF35JVb_KTGCA0g--
