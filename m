From: Doug Ledford <dledford@redhat.com>
Subject: Re: question on how to (correctly) build an initrd for a root disk
	on a RAID1
Date: Mon, 27 Oct 2008 13:56:16 -0400
Message-ID: <1225130177.26510.3.camel@firewall.xsintricity.com>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
	 <20081027071613.GA8197@maude.comedia.it>
	 <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com>
	 <4905EE05.9070108@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dXk9O5UxD4cH56AeBlUT"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4905EE05.9070108@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brendan Conoboy <blc@redhat.com>
Cc: Joe Landman <joe.landman@gmail.com>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-dXk9O5UxD4cH56AeBlUT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 10:36 -0600, Brendan Conoboy wrote:
> Joe Landman wrote:
> > Ok.  This is where it gets interesting.  If the /etc/mdadm.conf is on
> > the RAID, you have a bit of a "chicken and egg" problem to deal with
> > here.  How does the system find /etc/mdadm.conf to make the RAID when
> > /etc/mdadm.conf is on the RAID?
> >=20
> > This implies that /etc/mdadm.conf is in the initrd.  Peeking inside
> > the default centos one, I can see that this is not true.  Which
> > implies that it doesn't see /etc/mdadm.conf before it assembles the
> > array, as the /etc/mdadm.conf is on the array, and not in the initrd
> > image.
> >=20
> > Is there a way to include the /etc/mdadm.conf into the initrd?
>=20
> This is almost certainly your problem.  If / is a RAID volume, the=20
> initrd itself needs to have an /etc/mdadm.conf that reflects how it is=20
> constructed.  This is something that mkinitrd should be doing for you.=20
> I'll second the suggestion of running mkinitrd with sh's -x option to=20
> see why it's not doing this for you.  Good luck.

Keep in mind that mkinitrd senses what it needs to boot the machine from
the currently running setup.  So, if you run mkinitrd with a root raid
array, it should detect that it needs to start the md raid device, copy
mdadm.static and mdadm.conf to the initrd, and add the appropriate lines
to the initrd script.  If you aren't running the md raid array (maybe
it's a raid1 and you just mounted a bare member long enough to create an
initrd for instance), then it won't.  But, since the system works with a
centos provided kernel, and not with the custom kernel, I'm guessing
that this isn't the issue, that mkinitrd is just fine, and instead the
custom kernel's config is somehow fubar'ed and that's what's causing all
the problems.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-dXk9O5UxD4cH56AeBlUT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkGAMAACgkQTzP9PM7pjw/R8wCfcvmK3NSJWwkHKp0RF8/jBa4y
m3cAnA+POGmBjoa7FekBdyjJzlJK+KaR
=z5/v
-----END PGP SIGNATURE-----

--=-dXk9O5UxD4cH56AeBlUT--

