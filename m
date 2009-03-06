From: martin f krafft <madduck@debian.org>
Subject: Re: Future of md multipath
Date: Fri, 6 Mar 2009 16:17:15 +0100
Message-ID: <20090306151715.GD6030@lapse.rw.madduck.net>
References: <20090303180433.GA27569@lst.de> <18863.15828.150450.275712@notabene.brown> <20090305130017.GA1696@piper.oerlikon.madduck.net> <18864.46425.242906.213929@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18864.46425.242906.213929@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2009.03.06.0632 +0100]:
> > I understand that dm-multipath is more favourable, but unless
> > there's a riskless way to convert mdadm multipath into dm-multipath
> > on old systems, I don't think we have the option of deprecating it,
> > unless deprecation lasts for several years.
>=20
> Always the practical one, aren't you :-)

Goes with the territory. Debian does not need to make long term
support guarantees. They're inherent in our quality assurance,
security support, and chaotic organisation. :)

> I wonder how hard it would be to get mdadm to assemble a multipath
> using the 'dm' code rather than the 'md' code....
> Or to get the md layer in the kernel to hook in to the dm multipath
> implementation.

A migration isn't possible?

> I think it is probably worth putting in a printk now to say "You
> should probably be using dm-multipath".  But we probably do need
> to leave the code there for a while longer..

Maybe it would be possible to disable creation of new multipath
arrays, but still to support existing ones, insert the warning, and
quote a fixed deprecation date, say, 5 years into the future?

--=20
 .''`.   martin f. krafft <madduck@d.o>      Related projects:
: :'  :  proud Debian developer               http://debiansystem.info
`. `'`   http://people.debian.org/~madduck    http://vcs-pkg.org
  `-  Debian - when you have better things to do than fixing systems
=20
god is dead.
    -- nietzsche
nietzsche is dead.
    -- god
nietzsche is god.
    -- dead

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmxPnsACgkQIgvIgzMMSnUQcQCff50ZnDoBq+g8Ek7c3O47GmPH
vKcAnRIu96ezlsqesT+c4i7mJOH8Sn5k
=F9q5
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
