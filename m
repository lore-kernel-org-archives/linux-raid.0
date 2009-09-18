From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Fri, 18 Sep 2009 11:22:34 +0100
Message-ID: <20090918102234.GE22909@cthulhu.home.robinhill.me.uk>
References: <h8nbt5$n8p$1@ger.gmane.org>
 <alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>
 <h8nfoe$n8p$3@ger.gmane.org>
 <alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
 <h8nreb$n8p$4@ger.gmane.org>
 <87ws3z5iro.fsf@frosties.localdomain>
 <1253106813.17888.9.camel@localhost>
 <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com>
 <20090918082851.GD22909@cthulhu.home.robinhill.me.uk>
 <70ed7c3e0909180257hf13ba48va808b942deaba177@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M/SuVGWktc5uNpra"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ed7c3e0909180257hf13ba48va808b942deaba177@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--M/SuVGWktc5uNpra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Sep 18, 2009 at 12:57:23PM +0300, Majed B. wrote:

> Thank you for the insight, Robin.
>=20
> I already have used dd_rescue to find which sectors are bad, so I
> guess I could either wait for Matthias to finish his modifications to
> mdadm, or I can reconstruct the bad sectors manually (read same sector
> from other disks, xor all, write to damaged disk's clone).
>=20
This won't work if your array is degraded though - you don't have enough
data to do the reconstruction (unless you have two failed drives you can
partially read?).

> Weird thing though, is that when I re-read some of the bad sectors, I
> didn't get I/O errors ... it's confusing!
>=20
Odd.  I'd recommend using ddrescue rather than dd_rescue - it's faster
and handles retries of bad sectors better.

> Also, I'd rather avoid a fsck when I have bad sectors to not lose
> files. I'll run fsck once I've fixed the bad sectors and resynced the
> array.
>=20
True - a fsck should only be done once the data's in the best possible
state,

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--M/SuVGWktc5uNpra
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqzX2oACgkQShxCyD40xBIjKACgodREmuab4AqitSS2nM0bDLRb
Wa4AniqmeKzZZ42YJCduoxTA1U29fELZ
=vqK5
-----END PGP SIGNATURE-----

--M/SuVGWktc5uNpra--
