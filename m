From: martin f krafft <madduck@debian.org>
Subject: Re: Bug#567468: (boot time consequences of) Linux mdadm superblock
 question.
Date: Mon, 22 Feb 2010 10:14:52 +0100
Message-ID: <20100222091452.GD2641@lapse.rw.madduck.net>
References: <1266465801.11568.183.camel@localhost.localdomain>
 <20100218044004.GC5136@lapse.rw.madduck.net>
 <20100218161012.704b43a6@notabene.brown>
 <20100218052145.GA7178@lapse.rw.madduck.net>
 <20100218163448.0d3f3107@notabene.brown>
 <20100219004237.GC25162@lapse.rw.madduck.net>
 <1266547875.11568.1552.camel@localhost.localdomain>
 <20100221171445.GB17267@lapse.rw.madduck.net>
 <873a0t4ume.fsf@frosties.localdomain>
 <4877c76c1002212337i36f208dcyd1be7a93625d2a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="sgneBHv3152wZ8jf"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4877c76c1002212337i36f208dcyd1be7a93625d2a6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, 567468@bugs.debian.org
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Daniel Reurich <daniel@centurion.net.nz>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


--sgneBHv3152wZ8jf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Michael Evans <mjevans1983@gmail.com> [2010.02.22.0837 +0100]:
> I don't know how whatever was mentioned previously would work for
> that, but I do have a solution.

[=E2=80=A6]

> Incremental assembly, or examine with all block devices to
> generate a new mdadm.conf file.

Please see the thread for reasons why incremental assembly works
only with an mdadm.conf file, or if you can uniquely identify the
system before the root filesystem is mounted.

Please see the thread for reasons why unconditional auto-assembly of
all available arrays may not be desirable.

> Presuming you have a consistently labeled rootfs in your
> deployment (say mandating that the / filesystem be labeled 'root'
> or some other value and that no other FS may share that same
> label) then it should work out just fine.

I fundamentally agree. However, driving this change from mdadm will
be impossible. If that is the way to go, then we must first ensure
that device names become deprecated, and that everyone uses
/dev/disk/by-uuid/*. Only then can we start relying on it.

--=20
 .''`.   martin f. krafft <madduck@d.o>      Related projects:
: :'  :  proud Debian developer               http://debiansystem.info
`. `'`   http://people.debian.org/~madduck    http://vcs-pkg.org
  `-  Debian - when you have better things to do than fixing systems

--sgneBHv3152wZ8jf
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkuCSwwACgkQIgvIgzMMSnW0uACgrL3Dy86fFSMW1uReHnZH8lA5
SqcAoMJQPwT2sDyj5oVmEqJji4t9owOE
=Rrmt
-----END PGP SIGNATURE-----

--sgneBHv3152wZ8jf--
