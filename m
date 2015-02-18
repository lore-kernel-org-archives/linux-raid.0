From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/1] RFC: Use /dev/md/X as default name
Date: Thu, 19 Feb 2015 09:32:36 +1100
Message-ID: <20150219093236.25660678@notabene.brown>
References: <1423684389-10977-1-git-send-email-Jes.Sorensen@redhat.com>
	<wrfjsie36qdi.fsf@redhat.com>
	<20150219083708.2ab46006@notabene.brown>
	<wrfj61ay6fai.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.GT9Mf7DN+8BMW1.jekM6A6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj61ay6fai.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.GT9Mf7DN+8BMW1.jekM6A6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Feb 2015 17:11:33 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> NeilBrown <neilb@suse.de> writes:
> > On Wed, 18 Feb 2015 13:12:09 -0500 Jes Sorensen <Jes.Sorensen@redhat.co=
m>
> > wrote:
> >
> >> Jes.Sorensen@redhat.com writes:
> >> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
> >> >
> >> > I have received some issues for when creating an array using a
> >> > /dev/mdX name, the matching symlink in /dev/md/X isn't
> >> > created. Whereas if you create /dev/md/X, /dev/mdX is created
> >> > automatically.
> >> >
> >> > I was trying to see if there was a better way of dealing with this,
> >> > but I couldn't find one. If you have suggestions for a better soluti=
on
> >> > I am all ears.
> >> >
> >> > Thoughts?
> >>=20
> >> Hi Neil,
> >>=20
> >> Any thoughts on this one?
> >
> > Thanks for the reminder....
> >
> > I'm not sure that I really see the problem.
> >
> >   "I ask it to create /dev/mdX and it doesn't create /dev/md/X".
> >
> > Well ... no.  You didn't ask it to.  If you want it to create /dev/md/X,
> > then ... ask it to.
> >
> > /dev/mdX is the canonical name.  It always gets created.
> > /dev/md/X is a convenient alias.  It gets created if requested.
> >
> > Is there really a problem here worth solving?
> >
> > Maybe I missed something.
>=20
> I have had complaints in Fedora from the installer people that they rely
> on the /dev/md/ name being created when they create a new device. It is
> also inconsistent because /dev/md/<X> will be created if you run
> 'mdadm -As' later on.

If they rely on the /dev/md/ name being created, then surely they should ask
for it to be created.
Is it really harder to run "mdadm -C /dev/md/0" than "mdadm -C /dev/md0" ??

If you create an array as "/dev/md0", then after subsequent "mdadm
-As" /dev/md0 will exist.
If you create an array as "/dev/md/0", then after subsequent mdadm
-As", /dev/md/0 will exist.

The fact that something unasked for also exists is a bonus.

>=20
> I don't see it as a major issue, but I can see why it is frustrating for
> some and I think there is something to be said for being consistent in
> behavior.

I think the behaviour is perfectly consistent.  It just follows rules that
are slightly less trivial that some people appear to want.

However....
If you changed

			mp =3D map_by_uuid(&map, info->uuid);
			if (mp && mp->path &&
			    strncmp(mp->path, "/dev/md/", 8) =3D=3D 0) {
				printf("MD_DEVNAME=3D");
				print_escape(mp->path+8);
				putchar('\n');
			}


in Detail.c so that when mp->path were "/dev/md0", MD_DEVNAME became "0",
then you should get the result that you are after, and I probably wouldn't
object to the patch.

NeilBrown=20


--Sig_/.GT9Mf7DN+8BMW1.jekM6A6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOUTBDnsnt1WYoG5AQKu1A/8Cf2oze5nrvbTegzjpCWK5HOsGxwYKE+p
C0jwuE3MLke6jFMyNK/L5KFZz2pUjTDiMpC/bE5BKCcX+spXzFT7XMRRvn+PA0Da
hhJJ4gYzyNz/u9oHuWueLKhMUTraJaFgZtBYF9w9LvnQuILdR3Zx46FZMOODS/Gu
ewJectNtF686MIQsrhkOsG7jv8OEPA9pZwW1DqXP343tYwgZsbVdebVfmQH2Xj4p
oxG0al7TfZBQzRMu0QV0HuzilfvYdVspi4yXkv1826eakvhgtMmGHNa4xdEqtLFw
iCxCHKPcXOVD2SvZfNqN0LlLqC1Wx8nUYW6PqOYWWfUpYGjWBpoGFpuxWP/Wmz0X
yUj22qe4/LGF+tJ6p56VDbvw/DtS4NVzDHxACebp2JcBGvmy0kDU8I2fT1E/rDkf
QRP9nl5r8JradlLoOVPN3h+6KvcMJgNgfU8GxdlEd49yBQKMIyTGXZtKu1b3MGU6
UJJmPfxCrdWlxRQhsUyi8QDb1fk+bZsMbkiJqvQ5eTkBtOz2LAdXsvLp84xtuP3a
XlVikAos8r0feIzbq1xhHQkiiw+R6RZLEWEX2L3UTW+KCKPhGziBbqAz0wdTraU0
4KF5ZTronoOzWn608h6HlHohK8JAjOCMVOEr0PxKgwRkLdTgrB9ab0c+w4qtIt0u
f0CwQJbljaE=
=cRpG
-----END PGP SIGNATURE-----

--Sig_/.GT9Mf7DN+8BMW1.jekM6A6--
