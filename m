From: martin f krafft <madduck@debian.org>
Subject: Re: Bug#567468: md homehost
Date: Tue, 23 Feb 2010 09:16:37 +0100
Message-ID: <20100223081636.GD19730@lapse.rw.madduck.net>
References: <20100218052145.GA7178@lapse.rw.madduck.net>
 <20100218163448.0d3f3107@notabene.brown>
 <20100219004237.GC25162@lapse.rw.madduck.net>
 <20100219091619.GA2964@lazy.lzy>
 <20100221174007.GB19058@lapse.rw.madduck.net>
 <20100221201304.GB2570@lazy.lzy>
 <20100222091632.GE2641@lapse.rw.madduck.net>
 <20100223133028.279e0174@notabene.brown>
 <20100223062700.GB19666@lapse.rw.madduck.net>
 <87635opfwb.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87635opfwb.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>, 567468@bugs.debian.org
Cc: Neil Brown <neilb@suse.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Goswin von Brederlow <goswin-v-b@web.de> [2010.02.23.0831 +0100=
]:
> Both filesystems and LVM have UUIDs. Does dm-crypt / LUKS have one
> too?

LVM already identifies PVs using UUIDs, so if you are using
anything-on-LVM-on-md, you need not worry about device names anyway.

dm-crypt currently needs to be told explicitly to use a base device
using /dev/disk/by-uuid if you want it to be flexible.

The only issue homehost protects against, I think, is machines that
use /dev/md0 directly from grub.conf or fstab.

--=20
 .''`.   martin f. krafft <madduck@d.o>      Related projects:
: :'  :  proud Debian developer               http://debiansystem.info
`. `'`   http://people.debian.org/~madduck    http://vcs-pkg.org
  `-  Debian - when you have better things to do than fixing systems

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkuDjuQACgkQIgvIgzMMSnXumACfU4rFUUIDv8JefxPoLUUaGl1J
wjIAn3/weNXvMJgIVrd5L+QOEKr6dDas
=Nb5D
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
