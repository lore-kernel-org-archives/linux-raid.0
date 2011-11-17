From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Idea: Dynamic growth of the md array
Date: Thu, 17 Nov 2011 20:04:00 +0000
Message-ID: <20111117200400.GC1746@cthulhu.home.robinhill.me.uk>
References: <D32ED83685BD7643AC872D3EFF80E6BB0127480448@dc-ex1.power.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4jXrM3lyYWu4nBt5"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D32ED83685BD7643AC872D3EFF80E6BB0127480448@dc-ex1.power.com>
Sender: linux-raid-owner@vger.kernel.org
To: Terrance Hutchinson <Terrance.Hutchinson@dothill.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--4jXrM3lyYWu4nBt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Nov 17, 2011 at 11:53:59AM -0700, Terrance Hutchinson wrote:

> Hi,
>=20
> I know that mdadm supports growth of an array through the grow command
> but I would like to take it a step further. When a certain threshold
> is reach (user defined or default value) the user is emailed and the
> array is the grown to incorporate the next available disk or specified
> disk. This lets the user know what happened as well as prevent
> unnecessary downtime.
>=20
> The idea is to make the growth automatic if the user wishes it do so,
> otherwise the existing behavior would be used.
>=20
> Do you think this would be a good feature for mdadm? I've already
> begun working on it but wanted the community's opinion. If the overall
> consensus is that it's not a good idea, I'll post the diff on my
> website for those who would like it.
>=20
Sounds like a job for a user-space program to me. md/mdadm has no idea
about free space - that's a filesystem issue. It'd be far easier for a
user-space program to monitor that and fire off the appropriate
commands to grow the array, LVM volume, filesystem, etc. as required.

Cheers,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--4jXrM3lyYWu4nBt5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk7FaK8ACgkQShxCyD40xBIIfACfUXnsQQBclDdmiA5L3oowUmJO
6ZEAn2bbhRiuRRDGBjP+oz44EvlP7uDn
=80WO
-----END PGP SIGNATURE-----

--4jXrM3lyYWu4nBt5--
