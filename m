From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] debian: symlink mdmon pidfile into /run/sendsigs.omit.d
Date: Fri, 24 Aug 2012 22:31:52 +1000
Message-ID: <20120824223152.527e1ced@notabene.brown>
References: <50375007.5070401@xs4all.net>
	<CANBHLUgG49s1aiiKnxQTCDUF861wHv=2N+w73_7K-bi3tyysOg@mail.gmail.com>
	<50376A60.2010104@xs4all.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aj3xbq0p_bR/M/eeFG80CyG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50376A60.2010104@xs4all.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Dmitrijs Ledkovs <xnox@debian.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/aj3xbq0p_bR/M/eeFG80CyG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Aug 2012 13:49:52 +0200 Miquel van Smoorenburg <mikevs@xs4all.ne=
t>
wrote:

> On 24-08-12 1:12 PM, Dmitrijs Ledkovs wrote:
> > On 24 August 2012 10:57, Miquel van Smoorenburg <mikevs@xs4all.net> wro=
te:
> >> Some daemons should not be killed when the system is shutting down. In
> >> debian this is achieved by putting a file with the pid of the daemon i=
n it
> >> in /run/sendsigs.omit.d (or a symlink to its pidfile).
> >>
> >> This patch lets mdmon automatically create a symlink in /run/sendsigs.=
omit.d
> >> to its pidfile.
> >>
> >> See also debian bug 684708 at
> >> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D684708  ,
> >> where I submitted a previous version of this patch.
> >>
> >> Comments welcome.
> >>
> >
> > For upstream, it might be more appropriate to have a configurable
> > MDMON_PIDDIR, which defaults to $MDMON_DIR. As far as I know,
> > sendssigs.omit.d is very specific to Debian and it's derivatives, and
> > it's not used in the brave new systemd world.

No, the "brave new systemd world" requires that $ARGV[0] start with '@' to
avoid being killed, and mdmon has special code to support that.
So it would not be unreasonable to add special code to support
sendsigs.omit.d.

However if we only need to protect things at shutdown I wonder it you could
just add something like:

 cd /run/mdadm/
 for file in md*.pid
 do ln -s /run/mdadm/$file /.../sendsigs.omit.d/mdadm-$file
 done

in some script that gets run before the 'killall' happens.

That would be simple and should work.

If we really need mdmon to create the symlink I'd want:
1/ the compiled-in path (SENDSIGS_OMIT_DIR) to contain a %s which is replac=
ed
by the devname, so e.g.
    -DSENDSIGS_OMIT_DIR=3D/var/run/omit.dir/mdmon-%d.pid

and probably use asprintf rather than a fixed size buffer that the proposed
patch uses (yes, I know I used fixed size buffers all the time.  I'm bad -
show my how much better a real coder can do and I might learn to change my
ways!! :-)

Thanks,
NeilBrown



>=20
> Well, I'm not sure if there's a guideline for this in debian, but the=20
> convention appears to be to put the pidfiles in /run or a=20
> package-specific subdir of /run, and then to create a symlink from the=20
> sendsigs.omit.d directory to the pidfile- which is exactly what this=20
> patch does. If you're saying that something debian-specific like this=20
> should not be in the upstream package, then that's fine, and the patch=20
> will just be carried in debian. No problem.
>=20
> Note that I am not the debian mdadm maintainer, it's just that often=20
> it's appreciated if a bug/patch submitter works with upstream.
>=20
> Thanks,
>=20
> Mike.


--Sig_/aj3xbq0p_bR/M/eeFG80CyG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUDd0ODnsnt1WYoG5AQItRg/9EH8sL30/TaqFdV54/AC5AkobwyTmIQTN
64qraJRx+vWk31qZDvkl4hxtvBZJgATE3rFjNUJabf0Hua/2Se34maYX6cROqpXr
QMKekJzjGJ1sAc/OAzg8qCBAwrB64wzjjooyi4SNudw69daiiAWaT9mS+ZNRN6dl
92eUIGAhmLGzABfUt7qRcjPse/fwCrbbBkWH8clzd++RPr8aeKQt9MOhdTbAJDYw
V0/5LpwNdRMN6rT3YSt9Y/vA+VGkD3i3mcnsZqTFt3CQkPUu7+r1jELnl04E07E+
xgc9/YsMSqO2/Y+xeDaI340gDaTFuWYritaB5tnNibrJ5oV99prjZZAsJ+0qyObA
pBOOhHPtvonQGRsQFmMMWqUl0NzpwyaAP6LTycZf2o8mqnA9LqstKgiGJjvfh0qt
t0s3MoFRcG/xEwiPdIMUeP3a9DPlgq/T8Xk5opEHnoPJ2VOaQ/X/ZXCs/R0pvO0m
f0htgSz1UNA0xKnHFh5CxcbUo+a5s7PIgSBfMyDN3KCMiWSYC4q2PCfbgxs53fP6
q5e31XhoVtOlhmGf3Fa3nKxOMwTQjw4r5jqai5mafy3mfmqHhDA8m7MOeP/G0IW/
mupl4Swh5XGnWWCo7oTYwlSD6LB6xGTPRoENHWiuf9yku36a3syYyJH5c9akeVfv
cbtzU8/bMqA=
=ln+u
-----END PGP SIGNATURE-----

--Sig_/aj3xbq0p_bR/M/eeFG80CyG--
