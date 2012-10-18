From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Thu, 18 Oct 2012 12:29:59 +1100
Message-ID: <20121018122959.10bb6c87@notabene.brown>
References: <20120731155304.11c40f9b@notabene.brown>
	<CANejiEWZk6JcErw9Y6cqpotYMypQA_jvv8N0612FBq81Lo8jVQ@mail.gmail.com>
	<20120911105908.51681433@notabene.brown>
	<20120912052941.GA15827@kernel.org>
	<20120918145710.55394bd4@notabene.brown>
	<20120919055106.GA1305@kernel.org>
	<20120919171646.6bc35ba5@notabene.brown>
	<20120920015655.GB6798@kernel.org>
	<20121017051113.GA17821@kernel.org>
	<20121018095601.7aa3238b@notabene.brown>
	<20121018011735.GA1448@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G.=o7qgowu6DJwA+Iz+oeJV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121018011735.GA1448@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/G.=o7qgowu6DJwA+Iz+oeJV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Oct 2012 09:17:35 +0800 Shaohua Li <shli@kernel.org> wrote:
=20
> > > Neil,
> > > any further comments on this? This is a usable feature, I hope we can=
 have some
> > > agreements.
> >=20
> > You still haven't answered my main question, which possibly means I hav=
en't
> > asked it very clearly.
> >=20
> > You are saying that this new behaviour should not be the default and I =
think
> > I agree.
> > So the question is:  how it is selected?
> >=20
> > You cannot expect the user to explicitly enable it any time a resync or
> > recovery starts that should use this new feature.  You must have some
> > automatic, or semi-automatic, way for the feature to be activated, othe=
rwise
> > it will never be used.
> >=20
> > I'm not asking "when should the feature be used" - you've answered that
> > question a few time and it really isn't an issue.
> > The question it "What it the exact process by which the feature is turn=
ed on
> > for any particular resync or recovery?"
>=20
> So you worried about users don't know how to correctly select the feature=
. An
> experienced user knows this, the usage scenario I mentioned describes how=
 to do
> the decision. For example, a resync after system crash should enable the
> feature. I admit an inexperienced user doesn't know how to select it, but=
 this
> isn't a big problem to me. There are a lot of tunables in the kernel (eve=
n MD),
> which can significantly impact kernel behavior. These tunables are just f=
or
> experienced users.
>=20
> Thanks,
> Shaohua


You still aren't answering my question.

What exactly, precisely, specifically, will an "experienced user" do?

NeilBrown

--Sig_/G.=o7qgowu6DJwA+Iz+oeJV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUH9blznsnt1WYoG5AQIQHg//dPd86NoPenqJuccOdx1WXSv6TSdd6p+1
ujOgJgE8IWi7K8fCmu2W1Hm3R+oytvLUWF6Nt6ZfANXdQ6h/0IbkOw6+Enr0yFls
CmDikrYQLyHrsPXqLi1QRNRANEiPD+MtKagKqvYabvRNPyPgzz7iNOHnwro3ITya
A9LSaQvv+TF3Tl3QbObbsW3Qf82Hn9TbVy3LmCCOgynzCNjZT+ClW3m/Hv8oLj0V
1/zrfuefi2V8EXkLN10/jbI7GRURv5V32LauZF3puY55y/JO6+DWlrclIGxB5dbe
ABdXJAbD5SwuMbrXO7cpgMVkNW9T9UDCYWNLlsjnk3BWfalvRukzB3B12aAcElUT
UMqVUKPaYNV3WY5Ne4JS+dkxdbQr4El9Kt6sqZ3XOx4MHrVoPVGDdD7pW8JGpISo
6hOtOJQF4ngQ2xiGkbu0qO24zfn/UCZFi7BviuzZoJq3FraOdTk/3DPfyGioVNGi
NNIPzGw2XCi1dhiJ0BUR3n4V7Tkc+tc1LxUtZ5p3TjjU18vcyvla7t8+gYPlY1tw
SrzYKziI57EUgrST19Rt14iuAR3iW12u6/KQNGU9oY7g2lA7cN2Trl6hTPZGTloq
NsUiq0IYLsqf5qu3Vgy4NAnta+PtVlc/OGzpKqPbhTWcaADnk8N/FJtZdxL7THoI
gYnhsgnv5NI=
=9Bxs
-----END PGP SIGNATURE-----

--Sig_/G.=o7qgowu6DJwA+Iz+oeJV--
