From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 11:13:36 -0400
Message-ID: <1225120416.4845.128.camel@firewall.xsintricity.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <20081027082257.GB1801@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/rq9adNK92CdnQAimysZ"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081027082257.GB1801@piper.oerlikon.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@debian.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids


--=-/rq9adNK92CdnQAimysZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 09:22 +0100, martin f krafft wrote:
> also sprach Neil Brown <neilb@suse.de> [2008.10.26.2356 +0100]:
> > Greeting.
> >  This is a Request For Comments....
>=20
> Good morning!
>=20
> [...]
> > I'm also wondering if I should include a udev 'rules' file for md
> > in the mdadm distribution.  Obviously it would be no more than
> > a recommendation, but it might give me a voice in guiding how udev
> > interacted with mdadm.
>=20
> I would really like to have a clear separation of competencies.
> Ideally, mdadm never creates any devices but leaves it all to udev,
> and all configuration about alternate names ("symlinks") is done in
> the udev rules file.

This would then require that we have a working udev in our initrd
images.  It would greatly increase the complexity of early booting as a
result.

> I know mdadm needs the devices for the ioctls(). However, much of
> what it does with ioctl should already be possible with /sys. Thus,
> in my ideal world, I imagine mdadm to be a manipulator of /sys,
> instructing the kernel to do stuff with components and arrays, and
> have udev create and remove corresponding devices in response to
> kernel events.
>=20
> I realise this would require a revamp of mdadm, and might actually
> be better done in a new software designed to eventually replace
> mdadm. But is this a way forward with which you could befriend
> yourself?
>=20
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-/rq9adNK92CdnQAimysZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkF2qAACgkQTzP9PM7pjw99dQCfTm8pZqn9UpZ1ADKXtQ8EccLG
9xAAnR8SP34gHW9so5YGohHg/Am1GIuh
=89Oc
-----END PGP SIGNATURE-----

--=-/rq9adNK92CdnQAimysZ--

