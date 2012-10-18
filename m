From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Thu, 18 Oct 2012 13:36:57 +1100
Message-ID: <20121018133657.1bd012f6@notabene.brown>
References: <20120911105908.51681433@notabene.brown>
	<20120912052941.GA15827@kernel.org>
	<20120918145710.55394bd4@notabene.brown>
	<20120919055106.GA1305@kernel.org>
	<20120919171646.6bc35ba5@notabene.brown>
	<20120920015655.GB6798@kernel.org>
	<20121017051113.GA17821@kernel.org>
	<20121018095601.7aa3238b@notabene.brown>
	<20121018011735.GA1448@kernel.org>
	<20121018122959.10bb6c87@notabene.brown>
	<20121018020134.GB1448@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dd.j_DHxCZmA+B9hmvRcMCu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121018020134.GB1448@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dd.j_DHxCZmA+B9hmvRcMCu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Oct 2012 10:01:34 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Oct 18, 2012 at 12:29:59PM +1100, NeilBrown wrote:
> > On Thu, 18 Oct 2012 09:17:35 +0800 Shaohua Li <shli@kernel.org> wrote:
> > =20
> > > > > Neil,
> > > > > any further comments on this? This is a usable feature, I hope we=
 can have some
> > > > > agreements.
> > > >=20
> > > > You still haven't answered my main question, which possibly means I=
 haven't
> > > > asked it very clearly.
> > > >=20
> > > > You are saying that this new behaviour should not be the default an=
d I think
> > > > I agree.
> > > > So the question is:  how it is selected?
> > > >=20
> > > > You cannot expect the user to explicitly enable it any time a resyn=
c or
> > > > recovery starts that should use this new feature.  You must have so=
me
> > > > automatic, or semi-automatic, way for the feature to be activated, =
otherwise
> > > > it will never be used.
> > > >=20
> > > > I'm not asking "when should the feature be used" - you've answered =
that
> > > > question a few time and it really isn't an issue.
> > > > The question it "What it the exact process by which the feature is =
turned on
> > > > for any particular resync or recovery?"
> > >=20
> > > So you worried about users don't know how to correctly select the fea=
ture. An
> > > experienced user knows this, the usage scenario I mentioned describes=
 how to do
> > > the decision. For example, a resync after system crash should enable =
the
> > > feature. I admit an inexperienced user doesn't know how to select it,=
 but this
> > > isn't a big problem to me. There are a lot of tunables in the kernel =
(even MD),
> > > which can significantly impact kernel behavior. These tunables are ju=
st for
> > > experienced users.
> > >=20
> > > Thanks,
> > > Shaohua
> >=20
> >=20
> > You still aren't answering my question.
> >=20
> > What exactly, precisely, specifically, will an "experienced user" do?
>=20
> Set something to a sysfs entry to enable the feature (like my RFC patch d=
oes to
> have a new sysfs entry for the feature), and readd disk. resync then does=
 'only
> write mismatch data'. Is this what you asked?

Yes, that is the sort of thing I was asking for.
When you say "readd disk" I assume you mean to use the --readd option to
mdadm.
The only works when there is a bitmap active on the array,  so relatively f=
ew
blocks will be resynced so does it really matter which approach is taken?
Always copy, or read-and-test?

Though maybe you really mean to "--add" the device.  In that case it would
probably make sense to add some other option to mdadm to say "enable
read-mostly recovery".  I wonder what a good name would be.
--minimize-writes ??

You earlier gave a list of scenarios in which you thought this would be
useful.  It was:

> > > For 'compare and avoid write if equal' case:
> > > 1. update SSD firmware. This doesn't change the data, but we need tak=
e one disk
> > > off from the raid one time.
> > > 2. One disk has errors, but these errors don't ruin most of the data =
(for
> > > example, a pcie error)
> > > 3. driver/os crash.
> > > In all these cases, two raid disks must be resync, and they have almo=
st identical
> > > data. write avoidness will be very helpful for these. =20


For case '3', it would be a "resync" rather than a "recovery".  How would y=
ou
expect an "advanced user" to choose read-and-test recovery in that case?
There is no "readd" command happening.

NeilBrown

--Sig_/dd.j_DHxCZmA+B9hmvRcMCu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUH9rSTnsnt1WYoG5AQKn8A/8CAW29sflZZvaSwk2w9b0zu5FOSxWJk1m
0uOhbO5SUulXx3V9paegMJK57JFxjW/3w8arE2GxuF40MS3prb3I2/+MLObkrE6s
MycenmXvE3Lk7zkhTKjubR3hNeFYhLSUuCEktVMJG0zdo1brpBs9qVLbDMM6ruIF
vtcqCkV72Yw7wVs/pPaEWDTP/80hye7bQAMca/E76QUViGh0IuHpWGAd4zYu8SkD
OuBQCvr+lx+E2jCARa7Sfx5I0xLEyR+5X9stv3cT0zPxKyVHZQ0CGQGPjIZQdO3Z
pflt3tbbTJ9fOw6IaVoHEgDKEq4xuWLNvIloseZxvlDJD3Hw1ZZiIlNmN/K7gqWY
qnzLyLm6uw+buGO24TZW6x3ewxKpKtajWJNnvWYep6hjwDDcp9ezjz8ovPQt2iW3
FWlOWRBBrr4WcMaWusBrpB2V3+rHuYaMFEVyocReA37O43eWjTB6C3WO0/015Qiw
PRSgAKqbFrKnXY1J/w53iuAz3OSYikc0npFrBtiqGc5gcn4Xt8mzA0LTl8XOuTRt
ziAmrfLjZi1hWmKnYpnQK7wCSSVviCThhnwLKhMFUpVVsOONWyi582h7OnbPRc5F
BAZRiBs09X22DTkbhy2It5n462bmHwa+UFWyBEPxhkgrZL5rEhvFTQZ5fhqmDTZS
GCtealYKw1A=
=WBFR
-----END PGP SIGNATURE-----

--Sig_/dd.j_DHxCZmA+B9hmvRcMCu--
