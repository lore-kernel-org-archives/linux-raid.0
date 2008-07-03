From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Grow a RAID-10
Date: Thu, 3 Jul 2008 08:28:59 +0100
Message-ID: <20080703072859.GA20905@cthulhu.home.robinhill.me.uk>
References: <486BF974.70508@amfes.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <486BF974.70508@amfes.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Jul 02, 2008 at 02:56:04PM -0700, Daniel L. Miller wrote:

> I currently have a RAID10 across (4) SATA drives.  It looks like I'm goin=
g=20
> to need to grow in the near future.  Any tips for a procedure for this?  =
My=20
> current plan:
>
> 1.  Add a PCI SATA controller (MB had 4 SATA + 4 RAID SATA, it's a Tyan M=
B=20
> with a NFORCE chipset, I'm not sure if I want/can use the RAID SATA ports=
=20
> as plain SATA connections).
>
> 2.  Add 2 more drives - not necessarily the same size as the existing (th=
ey=20
> were all 4 the same)
>
> 3.  Execute "mdadm --grow /dev/md0"
>
Unless something's changed very recently then you can't grow a RAID-10
array (by adding disks anyway) - only RAID-1, RAID-5 and RAID-6 can be
grown in this way.

If you do want to grow it then the process will have to be backup,
recreate and restore.  Otherwise you can set them up as a RAID-1 and
mount them as another filesystem.

Sorry,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhsf7sACgkQShxCyD40xBJIjQCgzzjfcK+ltpYR8XlfR2tWJHyC
wEwAoKgGtwnfWy7h05Cqs1rAu/d9Lm/0
=SH8G
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
