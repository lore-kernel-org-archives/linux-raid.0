From: martin f krafft <madduck@debian.org>
Subject: Re: Future of md multipath
Date: Thu, 5 Mar 2009 14:00:17 +0100
Message-ID: <20090305130017.GA1696@piper.oerlikon.madduck.net>
References: <20090303180433.GA27569@lst.de> <18863.15828.150450.275712@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18863.15828.150450.275712@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2009.03.05.0349 +0100]:
> I'm in favour of deprecating it.  Whenever I hear of people using it I
> suggest dm-multipath, but there could people I don't here about.
> I think the upcoming mdadm-3.0 will need a compile-time option to
> enable multipath, so people will only get it if they really really
> want it.

How do you propose a distro to deal with this? Keep it enabled for
a certain time (with a deprecation warning?) and then just to close
the doors on users who still need it?

How long will you support it after deprecation?

I understand that dm-multipath is more favourable, but unless
there's a riskless way to convert mdadm multipath into dm-multipath
on old systems, I don't think we have the option of deprecating it,
unless deprecation lasts for several years.

--=20
 .''`.   martin f. krafft <madduck@d.o>      Related projects:
: :'  :  proud Debian developer               http://debiansystem.info
`. `'`   http://people.debian.org/~madduck    http://vcs-pkg.org
  `-  Debian - when you have better things to do than fixing systems
=20
"the perfect gun is an idealist without any ideal."
                                                  -- mc 900 ft jesus

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmvzOAACgkQIgvIgzMMSnWbdgCfYDKm4NPAjlfy6bRGkz90cocD
lloAoKEeOvdfXqE8xkTNENcI6XrpSqmu
=kZ+A
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
