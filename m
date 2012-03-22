From: NeilBrown <neilb@suse.de>
Subject: Re: grub-probe seems to be having problems
Date: Thu, 22 Mar 2012 13:46:44 +1100
Message-ID: <20120322134644.4ab6aa3a@notabene.brown>
References: <4F685BC2.1030008@gmail.com>
	<529358656.324923.1332383237382.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WMdUw/17VLWwZT7SLFM86W6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <529358656.324923.1332383237382.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: jlcenter@comcast.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WMdUw/17VLWwZT7SLFM86W6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Mar 2012 02:27:17 +0000 (UTC) jlcenter@comcast.net wrote:

> Any takers?  -John

Without the "details in the previous mail", there isn't much to take...

NeilBrown


>=20
> ----- Forwarded Message -----
> From: "Vladimir '=CF=86-coder/phcoder' Serbinenko" <phcoder@gmail.com>
> To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
> Cc: "The development of GRUB 2" <grub-devel@gnu.org>, "Marco d'Itri" <md@=
Linux.IT>
> Sent: Tuesday, March 20, 2012 6:28:18 AM
> Subject: Re: grub-probe seems to be having problems
>=20
> On 19.03.2012 22:28, Lennart Sorensen wrote:
> > On Fri, Mar 09, 2012 at 03:37:57PM -0500, Lennart Sorensen wrote:
> >> Interestingly after poking at reading all the disks and poking mdadm
> >> --examine and --detail, now grub-prob likes md1, but still dislikes md=
0.
> >>
> >> root@rceng03new:/tmp# /usr/sbin/grub-probe --device-map=3D --target=3D=
abstraction --device /dev/md1
> >> diskfilter mdraid1x raid5rec
> >> root@rceng03new:/tmp# /usr/sbin/grub-probe --device-map=3D --target=3D=
abstraction --device /dev/md0
> >> /usr/sbin/grub-probe: error: Couldn't find physical volume `(null)'. C=
heck your device.map.
> >>
> >> md1 was failing before with the same grub code.
> >>
> >> I don't get it.  I wonder if there is any known issues in 2.6.32 kernel
> >> and/or mdadm - v3.1.4 - 31st August 2010
> > Any suggestion for how to try and debug this myself, like which
> > file/function to start debuging at?  I would like to put this machine
> > in to production use soon, but I would also like to take this chance to
> > fix the bug in grub first.
>=20
> There is no need to debug. I know exactly why GRUB is confused: because=20
> as far as my understanding goes the superblock makes no sense (details=20
> in previous mail). What we need is that someone familiar with md tells=20
> me how this sector should be interpreted.
>=20
>=20
>=20


--Sig_/WMdUw/17VLWwZT7SLFM86W6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2qSlDnsnt1WYoG5AQKjmA/9FpI//le1Iynep2wYO7ZPEBj8Amh/q3z7
Qvl24KHWvYJjNBg8qAT7vNU8NczSkjrjOB8p9etaaThjJla2RP+07nJGmN3L89oB
sAQr2siBgdXvIRm9E1UArWSxdMaXbVf14x9wpz+J/XJjh+YLvl/v3IXPx77/poyM
xSAuIP/Lky4macC7chbINzYNMqeXi/ap56LBdIvw5mJEw6KVOfXcA8Q1ePMgSSYS
wY3ZHg5TBwuEwQApocbZ3gwmwDnDz1Rxnb/X2Iky21tRiuSj19id6gHVCQqE3+Pk
oILthVg8BwrMpAppixVSbhZL/OUEMaCXnlXWov1HiWg9ozXDfcfiR5x8Uoc4IVZl
iPHXxz1CL69MqJBt7B/gLAvMPVexf/aRRh5ADSwVtXEkTTm05F9dlvmkB9/RrCfL
vBDIthTJmYIAd1ov9JlA4KsEcFki9/qRZWOCXSMVT6BLlU/ZNWtnBAQgl8jk3mOO
h9KHPPuEpI3D7JeCcm7w56s1H2gy6aXi6lb7XSDF9AZQY1cerz2eurK+6iajymIb
PJ3I/jr5IFGYFd3mKS5FCVvUvL0UwVQg9NInFPW8Q1VNksjxuIWUJxI+982PXE80
TVMCEEAMbgjLKj5pJ6JwS09tN0ipO2NBA9iaxLIHj9rfQmxAD8f5mVK5UrVqFt3b
18jvafISw0w=
=mA51
-----END PGP SIGNATURE-----

--Sig_/WMdUw/17VLWwZT7SLFM86W6--
