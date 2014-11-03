From: NeilBrown <neilb@suse.de>
Subject: Re: Trying to get POLICY working
Date: Mon, 3 Nov 2014 12:54:16 +1100
Message-ID: <20141103125416.629a4810@notabene.brown>
References: <CADvHm=ZLp08Ydp+P=gn+bu1=GgVORx0TSJoRU33z3UNubwQryQ@mail.gmail.com>
	<20141101112001.344e5f20@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/CFvQge/sIUmVKr4vDYuxNAC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141101112001.344e5f20@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CFvQge/sIUmVKr4vDYuxNAC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 1 Nov 2014 11:20:01 +1100 NeilBrown <neilb@suse.de> wrote:

> On Fri, 31 Oct 2014 16:19:04 +0100 Caspar Smit <c.smit@truebit.nl> wrote:
>=20
> > Hi all,
> >=20
> > I'm trying to get the POLICY framework of mdadm working but I can't see=
m to.
> >=20
> > As i understand in the man page of mdadm the Incremental and POLICY
> > directives could allow adding a new disk without MD superblock as
> > spare to an already active array:
> >=20
> > "Note that mdadm will normally only add devices to an array which were
> > previously working (active or spare) parts of that array.  The support
> > for automatic inclusion of a new drive as a spare in some array
> > requires a configuration through POLICY in config file."
> >=20
> > Furthermore:
> >=20
> > "If no md metadata is found, the device may be still added to an array
> > as a spare if POLICY allows."
> >=20
> >=20
> > To get the basics working I created a system with 3 disks /dev/sdb,
> > /dev/sdc and /dev/sdd
> >=20
> > Created a RAID5 with one missing disk:
> >=20
> > mdadm -C /dev/md0 -l 5 -n 3 /dev/sd[b-c] missing
> >=20
> > I set the POLICY in mdadm.conf to:
> >=20
> > POLICY action=3Dforce-spare
> >=20
> > This should add any device (passed through mdadm --incremental) as
> > spare no matter what (Am i correct?)
>=20
> That is the theory, yes.
>=20
> >=20
> > Now when I do:
> >=20
> > #mdadm --incremental /dev/sdd
> > mdadm: no RAID superblock on /dev/sdd.
>=20
> The message suggests that 'guess_super' found something on the device, but
> it didn't turn out to be something useful.... not very helpful I know.
>=20
> What does "mdadm --examine /dev/sdd" report?
> I suspect there is a partition table and that is causing the confusion.
> Try removing the partition table (dd /dev/zero to the device for a few K).
> Then try again.
>=20
> Probably need a fix like:
>=20
> diff --git a/Incremental.c b/Incremental.c
> index c9372587f518..3156190c4603 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -196,7 +196,7 @@ int Incremental(struct mddev_dev *devlist, struct con=
text *c,
>  	policy =3D disk_policy(&dinfo);
>  	have_target =3D policy_check_path(&dinfo, &target_array);
> =20
> -	if (st =3D=3D NULL && (st =3D guess_super(dfd)) =3D=3D NULL) {
> +	if (st =3D=3D NULL && (st =3D guess_super_type(dfd, guess_array)) =3D=
=3D NULL) {
>  		if (c->verbose >=3D 0)
>  			pr_err("no recognisable superblock on %s.\n",
>  			       devname);
>=20
>=20
> and probably should improve the error messages...
>=20
> Thanks for the report.  Please let me know if that works, and what other
> difficulties you hit.

Actually, don't bother.  I must have been asleep.

Your problem is that you haven't defined a 'domain'.
A new spare needs to be assigned to a 'domain', and it will be attached to
any array in the same domain, as needed.

You can give all devices the domain "default" with

   POLICY domain=3Ddefault

The domain of an array is inherited from the member devices, or can be set
with "spare-group=3D" in mdadm.conf.

So

   POLICY domain=3Ddefault action=3Dforce-spare

should make it work for you.

NeilBrown

--Sig_/CFvQge/sIUmVKr4vDYuxNAC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFbgSDnsnt1WYoG5AQK2zxAAk+0pOaNwChP34B+UyT6Q6wL0UZokaTbL
6qwsIEaPqhD2jsDeHyaZtJ9Z83tw2NsUXbX0HpV9CbWLnV2Nqhmrea48CiTOM2Yw
EMvUlbAFEbsF7YW42N+173EAS/Qn6Io3KW21FtGte6F+YaAcHRiHqt5oym7ehIKJ
qHuMp2EQcZOUr+C/grBNp6Cj1WLcx3xf4qbUT3zZrgJ3OOYFomqdgMuEhhcvC8bi
IEg/76+1ZRYRjN2Q2BEhTUhorJaJe8gxi58KcZp+An8/798LjyfJW9PnzexlMCFb
+APbdCiTwENuXewBHFKf9bxUAZc7o+kwvo8xxxs83Ip8oEGR2nksWpsweetpw/Qj
BxvxVCahOPadYEHrIIjPB1ksdZi3kpBOAjcuUQkP50lPn6K0qARRxL+arSqrBjHs
GzcJDANwcOKeXBFqyUyAjn+p1RojxDJZQnyb/npnZnVfVup7gSH5tf6SJ00o37AQ
3ybjYguoUFInwBd/H8pOjHzxT1XVmJ7srL7pcGePJAhv3j0OZjOUExJT7DkKzTiX
c0ksXWmce0+RzoxDsGu3t3PPTBcQj3kPX2kDw+CwGJUoLpGpSw8VDH+13RSxo2TP
3w7py5f7RbZtaLFu7dF/3y4BVhbQl51IMcCFGbsR7OC4LTcfNaxx/8STT5A6gNU+
xOa6eyiWNJ0=
=qPP3
-----END PGP SIGNATURE-----

--Sig_/CFvQge/sIUmVKr4vDYuxNAC--
