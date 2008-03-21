From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Redundancy check using "echo check > sync_action": error
	reporting?
Date: Fri, 21 Mar 2008 23:55:58 +0000
Message-ID: <20080321235557.GA11801@cthulhu.home.robinhill.me.uk>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us> <47E3C504.3010700@tmr.com> <47E3CBAF.4090808@rabbit.us> <47E43E57.5010409@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47E43E57.5010409@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Mar 21, 2008 at 07:01:43PM -0400, Bill Davidsen wrote:

> Peter Rabbitson wrote:
>> I was actually specifically advocating that md must _not_ do anything on=
=20
>> its own. Just provide the hooks to get information (what is the current=
=20
>> stripe state) and update information (the described repair extension). T=
he=20
>> logic that you are describing can live only in an external app, it has n=
o=20
>> place in-kernel.
>
> So you advocate the current code being in the kernel, which absent a=20
> hardware error makes blind assumptions about which data is valid and whic=
h=20
> is not and in all cases hides the problem, instead of the code I proposed=
,=20
> which in some cases will be able to avoid action which is provably wrong=
=20
> and never be less likely to do the wrong thing than the current code?
>
I would certainly advocate that the current (entirely automatic) code
belongs in the kernel whereas any code requiring user
intervention/decision making belongs in a user process, yes.  That's not
to say that the former should be preferred over the latter though, but
there's really no reason to remove the in-kernel automated process until
(or even after) a user-side repair process has been coded.

> Currently the "repair" action (which *is* in the kernel now) takes no=20
> advantage of the additional information available in these cases I noted.=
=20
> By what logic do you conclude that the user meant "hide the error" when=
=20
> using the "repair" action? What I propose is never less likely to be=20
> correct than what the current code does, why would you not want to improv=
e=20
> the chances of getting the repair correct?
>
That is, of course, a separate issue to whether it should be in-kernel.
I would entirely agree that user-level processes should be able to
access and manipulate the low-level RAID data/metadata (via the md
layer) in order to facilitate more advanced repair functions, but this
should be separate from, and in addition to, the "ignorant"
parity-updating repair process currently in place.

Just my 2p,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH5EsLShxCyD40xBIRAs6CAJ0eNUJFG+mjIJyLbEgYzQYyoV1s7QCgg1m4
7l2nam9JTSgqRa/FRX17m3c=
=PFV3
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
