From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Wed, 31 Oct 2012 16:43:36 +1100
Message-ID: <20121031164336.3828a6ca@notabene.brown>
References: <20120918145710.55394bd4@notabene.brown>
	<20120919055106.GA1305@kernel.org>
	<20120919171646.6bc35ba5@notabene.brown>
	<20120920015655.GB6798@kernel.org>
	<20121017051113.GA17821@kernel.org>
	<20121018095601.7aa3238b@notabene.brown>
	<20121018011735.GA1448@kernel.org>
	<20121018122959.10bb6c87@notabene.brown>
	<20121018020134.GB1448@kernel.org>
	<20121018133657.1bd012f6@notabene.brown>
	<20121031032533.GA1487@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AibD=ejJm_m_WShdVrrW80i"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121031032533.GA1487@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/AibD=ejJm_m_WShdVrrW80i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 31 Oct 2012 11:25:33 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Oct 18, 2012 at 01:36:57PM +1100, NeilBrown wrote:
> > On Thu, 18 Oct 2012 10:01:34 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > On Thu, Oct 18, 2012 at 12:29:59PM +1100, NeilBrown wrote:
> > > > On Thu, 18 Oct 2012 09:17:35 +0800 Shaohua Li <shli@kernel.org> wro=
te:
> > > > =20
> > > > > > > Neil,
> > > > > > > any further comments on this? This is a usable feature, I hop=
e we can have some
> > > > > > > agreements.
> > > > > >=20
> > > > > > You still haven't answered my main question, which possibly mea=
ns I haven't
> > > > > > asked it very clearly.
> > > > > >=20
> > > > > > You are saying that this new behaviour should not be the defaul=
t and I think
> > > > > > I agree.
> > > > > > So the question is:  how it is selected?
> > > > > >=20
> > > > > > You cannot expect the user to explicitly enable it any time a r=
esync or
> > > > > > recovery starts that should use this new feature.  You must hav=
e some
> > > > > > automatic, or semi-automatic, way for the feature to be activat=
ed, otherwise
> > > > > > it will never be used.
> > > > > >=20
> > > > > > I'm not asking "when should the feature be used" - you've answe=
red that
> > > > > > question a few time and it really isn't an issue.
> > > > > > The question it "What it the exact process by which the feature=
 is turned on
> > > > > > for any particular resync or recovery?"
> > > > >=20
> > > > > So you worried about users don't know how to correctly select the=
 feature. An
> > > > > experienced user knows this, the usage scenario I mentioned descr=
ibes how to do
> > > > > the decision. For example, a resync after system crash should ena=
ble the
> > > > > feature. I admit an inexperienced user doesn't know how to select=
 it, but this
> > > > > isn't a big problem to me. There are a lot of tunables in the ker=
nel (even MD),
> > > > > which can significantly impact kernel behavior. These tunables ar=
e just for
> > > > > experienced users.
> > > > >=20
> > > > > Thanks,
> > > > > Shaohua
> > > >=20
> > > >=20
> > > > You still aren't answering my question.
> > > >=20
> > > > What exactly, precisely, specifically, will an "experienced user" d=
o?
> > >=20
> > > Set something to a sysfs entry to enable the feature (like my RFC pat=
ch does to
> > > have a new sysfs entry for the feature), and readd disk. resync then =
does 'only
> > > write mismatch data'. Is this what you asked?
>=20
> sorry for the delay.
> =20
> > Yes, that is the sort of thing I was asking for.
> > When you say "readd disk" I assume you mean to use the --readd option to
> > mdadm.
> > The only works when there is a bitmap active on the array,  so relative=
ly few
> > blocks will be resynced so does it really matter which approach is take=
n?
> > Always copy, or read-and-test?
> >=20
> > Though maybe you really mean to "--add" the device.  In that case it wo=
uld
> > probably make sense to add some other option to mdadm to say "enable
> > read-mostly recovery".  I wonder what a good name would be.
> > --minimize-writes ??
>=20
> Yep, it's '--add' case. For the '--readd' with bitmap case, bitmap can al=
ready
> avoid a lot of write already. The useage case is something like:
> one disk is broken; trim whole disk of a new disk; add the new disk
> If source disk has a lot of 0 and we only write mismatch data, we can avo=
id
> write a lot.
>=20
> I believe we need such mechanism for '--create' too, if the first disk ha=
s some
> data, but the second disk is empty.
> =20
> > You earlier gave a list of scenarios in which you thought this would be
> > useful.  It was:
> >=20
> > > > > For 'compare and avoid write if equal' case:
> > > > > 1. update SSD firmware. This doesn't change the data, but we need=
 take one disk
> > > > > off from the raid one time.
> > > > > 2. One disk has errors, but these errors don't ruin most of the d=
ata (for
> > > > > example, a pcie error)
> > > > > 3. driver/os crash.
> > > > > In all these cases, two raid disks must be resync, and they have =
almost identical
> > > > > data. write avoidness will be very helpful for these. =20
> >=20
> >=20
> > For case '3', it would be a "resync" rather than a "recovery".  How wou=
ld you
> > expect an "advanced user" to choose read-and-test recovery in that case?
> > There is no "readd" command happening.
>=20
> If there is bitmap, maybe we don't need do read-and-test, so this one isn=
't
> very necessary in current stage. If not, what I suggested is:
> 1. user suspends resync (write something to a sysfs file)
> 2. user enables read-and-test (again, write a sysfs file)
> 3. resume resync

So you are happy for the resync to start doing the wrong thing, and expect
the sysadmin to notice, and then take some obscure action to stop it doing
the wrong thing and start it doing the right thing.
Certainly possible, but very error prone I would think.

NeilBrown

--Sig_/AibD=ejJm_m_WShdVrrW80i
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJC6iDnsnt1WYoG5AQL8Ig//ShAbUJg7LJOUZvew+P3HTYhMBKge6l0f
uYtAkxgmb3DDbuwYscNhWFxX+fFmoBZSs+b/f3GrRb2/ofR3hZD+h+Bvn0kqeIJu
nhIrYmHGzltVt8bWKd5mRlsy8xf9hPBZWKPU2FxVQHe+1iuvu7ZhQ07ROLxLE8uK
GLIhPAh6Yp4FUg+WbpSwJuTecHAqnlsIqqaxZSCsf2VlQmXaOv0DPQyp/G/TaP7z
hM4aVyymPwTO3NDtYprrBE3C/7acmGQOtSHczJYyRND9FGIko1GkGJFswNVrDkk3
Kf/6fVKhf8rDkecwYQZNw++6jLbP1ezBfy5aK3iwXB7lN65wQ+1n13GjfVQ9fTiz
PE47etEduVx59mMZRHPFaZpQKxIaoCYjgRXPQfVClPMWtvfK05cUpwflVJS0kkBy
uSqhwDgWyqQd7K6dWiQeTXcHVyo7vIUD9NuOQGksKfMQpkYJmwVX56B+1FGypqhu
sRfaLYSLrbjj38NJvtM0IVww5NJg9FKMJ3jydxoPlMnrbteVTPVaydTXBC/0KzSS
+JyAR1zZA3cugcUWhlZzMaIV5gr4JvD/BoFu9sBZToVwyv8BScl1EtL/wAwDWD3j
YkX/W7zrgm6gITD4kj0pIcixTgxK4LHtjFIKvR/f63aidJvPctAv3eOZDpg2NmUY
X85+TJ5omME=
=5mVj
-----END PGP SIGNATURE-----

--Sig_/AibD=ejJm_m_WShdVrrW80i--
