From: martin f krafft <madduck@debian.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 09:22:57 +0100
Message-ID: <20081027082257.GB1801@piper.oerlikon.madduck.net>
References: <18692.62860.863118.727187@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18692.62860.863118.727187@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2008.10.26.2356 +0100]:
> Greeting.
>  This is a Request For Comments....

Good morning!

[...]
> I'm also wondering if I should include a udev 'rules' file for md
> in the mdadm distribution.  Obviously it would be no more than
> a recommendation, but it might give me a voice in guiding how udev
> interacted with mdadm.

I would really like to have a clear separation of competencies.
Ideally, mdadm never creates any devices but leaves it all to udev,
and all configuration about alternate names ("symlinks") is done in
the udev rules file.

I know mdadm needs the devices for the ioctls(). However, much of
what it does with ioctl should already be possible with /sys. Thus,
in my ideal world, I imagine mdadm to be a manipulator of /sys,
instructing the kernel to do stuff with components and arrays, and
have udev create and remove corresponding devices in response to
kernel events.

I realise this would require a revamp of mdadm, and might actually
be better done in a new software designed to eventually replace
mdadm. But is this a way forward with which you could befriend
yourself?

--=20
 .''`.   martin f. krafft <madduck@debian.org>
: :'  :  proud Debian developer, author, administrator, and user
`. `'`   http://people.debian.org/~madduck - http://debiansystem.info
  `-  Debian - when you have better things to do than fixing systems
=20
"a compliment is like a kiss through a veil."
                                                        -- victor hugo

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkFemEACgkQIgvIgzMMSnXpYQCfYgf0K8YVfL5GKxrl4PkEySG6
chYAoNhbUfLS9rxdrbwr9JbggYGKvSS8
=Te4H
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
