From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: More tales of horror from the linux (HW) raid crypt
Date: Wed, 22 Jun 2005 13:54:22 -0700
Message-ID: <1119473663.22853.189.camel@seki.nac.uci.edu>
References: <5d96567b05061804477325d743@mail.gmail.com>
	 <200506201853.11768.hjm@tacgi.com>  <42B9BCF6.1010206@h3c.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pjOvTwezHULFGJaM79Um"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42B9BCF6.1010206@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: Harry Mangalam <hjm@tacgi.com>, linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


--=-pjOvTwezHULFGJaM79Um
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-06-22 at 12:33 -0700, Mike Hardy wrote:

> I'm very interested in the relative SW raid / HW raid performance. I
> have both in service (two raid 5 sets are actually the same size with
> the same number of components) and see roughly the same as you mention.
> One difference that I see is that HW raid should generate fewer
> interrupts and lower bus traffic.

In the early days of RAID, people always used to say that for speed, you
had to get a hardware RAID controller instead of doing software RAID.

However, I saw an interesting comment on a local linux user group
mailing list recently.  That comment was to the effect that hardware
RAID controllers tend to have no where near the horsepower of a modern
desktop CPU - so the claim was (I've not verified this!) that using
software RAID would be much faster.

I'm thinking that if you can do software RAID with a dedicated box
that's doing nothing but RAID and a little network, then yes, that
likely would be faster than some scaled-down hardware RAID controller -
but it would also likely cost more, be less likely to have good hot
swap, and so on.



--=-pjOvTwezHULFGJaM79Um
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBCuc/+o0feVm00f/8RAi4xAKCPoZ3ZltqzJV6ntYOHCzNlSelQkgCeOjKa
Wj/DTI+QrpMCZsA3lrwlF7k=
=7MdO
-----END PGP SIGNATURE-----

--=-pjOvTwezHULFGJaM79Um--

