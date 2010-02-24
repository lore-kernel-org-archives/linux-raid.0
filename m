From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Bug#567468: md homehost
Date: Wed, 24 Feb 2010 18:52:57 +0100
Message-ID: <20100224175257.GA7470@darkside.12.kls.lan>
References: <20100219004237.GC25162@lapse.rw.madduck.net>
 <20100219091619.GA2964@lazy.lzy>
 <20100221174007.GB19058@lapse.rw.madduck.net>
 <20100221201304.GB2570@lazy.lzy>
 <20100222091632.GE2641@lapse.rw.madduck.net>
 <20100223133028.279e0174@notabene.brown>
 <20100223062700.GB19666@lapse.rw.madduck.net>
 <87635opfwb.fsf@frosties.localdomain>
 <20100223081636.GD19730@lapse.rw.madduck.net>
 <87y6iilqsu.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87y6iilqsu.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: 567468@bugs.debian.org, Neil Brown <neilb@suse.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 24, 2010 at 02:13:53PM +0100, Goswin von Brederlow wrote:
> grub.cfg (grub2) uses UUID for grub itself. But the kernel can be bootet
> with root=3D/dev/md0. But in that case where does it get the homehost from
> and since when does kernel raid autoconfig have a homehost?

The homehost attribute does only exist with v1 superblocks. And there is
no in-kernel auto-assembly for v1 superblocks.
v0.9 superblocks (for which in-kernel auto-assembly is deprecated but
still provided) have no homehost.


just my 2 cents
   Mario
--=20
The secret that the NSA could read the Iranian secrets was more
important than any specific Iranian secrets that the NSA could
read.                           -- Bruce Schneier

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBS4VneRS+e2HeSPbpAQKSTgf/dlPeu4Xz5vMiYqeZFjdz5GklaZinBDyi
XdiUkZUyeUUWqP9vT9o5680VDCpX8Z/DCWFQnbcdPpaSTDTqZO/FdIlYc3CtaOX4
PHfDpsD3vj17Ypx7AUoajXETTEQhRWEyaRdLs3gebKd4dZEnrQO66ZbDX0FA55CS
94LQzFFfc8ASYPoXflDI63sRI1MRiV7DzMkCPEANCVkQap6SQFkw38QSAqR8FsSp
go5clj5lGjWSEYy1Jqg81ljfC3npoBQta3pF3wSwqvfow/aGoeyFEcFXE/UThupa
sV/YvnvJvLqHfK3U8C4b/leTdpLx70MwYc4D5Ra0t8dcd04/F6G4Tg==
=UCaj
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
