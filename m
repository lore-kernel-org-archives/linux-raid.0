From: NeilBrown <neilb@suse.de>
Subject: Re: Stop IMSM verify?
Date: Tue, 18 Sep 2012 16:46:41 +1000
Message-ID: <20120918164641.224b9c19@notabene.brown>
References: <CA+ZgY1E2T6C+Db1eb8_GFnXm7nzo4ecgGbMiPPf18C9-p5X5WQ@mail.gmail.com>
	<20120913112246.77b3041e@notabene.brown>
	<CA+ZgY1FMZm-g3-ODPLaRnN14+da+8QBcWhSX-p08kx70pGz97g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P5ulg7QNCEOw=FGj3QYzazs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+ZgY1FMZm-g3-ODPLaRnN14+da+8QBcWhSX-p08kx70pGz97g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Frey <djqfrey@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/P5ulg7QNCEOw=FGj3QYzazs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Sep 2012 18:34:41 -0700 Daniel Frey <djqfrey@gmail.com> wrote:

> On Wed, Sep 12, 2012 at 6:22 PM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 12 Sep 2012 18:00:21 -0700 Daniel Frey <djqfrey@gmail.com> wrot=
e:
> >
> >> Is there any way to stop the verify of an IMSM raid through mdadm?
> >
> > No.
>=20
> Darn.
>=20
> >> I found https://raid.wiki.kernel.org/index.php/RAID_Administration,
> >> but the imsm raid does not seem to have sync_action anywhere in the
> >> /sys/block tree.
> >
> > It certainly should be there.
> >   find /sys/block -name sync_action
> > ??
>=20
> I'm using mdadm exclusively for my imsm raid, and:
>=20
>  ~ # find /sys/block -name sync_action
>  ~ #

Of course... it only exists in that tree via a symlink that find won't foll=
ow.

% find /sys/devices/ -name sync_action

will work.

>=20
> I take it the imsm raid should have that? I used that exact same
> command (and found nothing) before I posted to the list.
>=20
> >> I've been having issues with suspend which I'm trying to troubleshoot,
> >> and I know I can stop it if I boot into Windows. Just wondering if
> >> that functionality is in mdadm.
> >
> > I suspect your problem is that mdmon is being killed at an awkward time
> > during shutdown.
> > What distro?  Is 'systemd' being used?
>=20
> The distro is gentoo (no systemd) - suspend works (as in it goes into
> suspend properly) but 8 out of 10 times it fails to wake out of
> suspend by either the keyboard or power button. The only way to "wake"
> it is to yank the power plug from the PSU for a few seconds and plug
> it in. As you can imagine, the imsm raid isn't too happy about that...
> it boots in Verify mode. I've found I can stop the raid verify in
> Windows, so I thought perhaps mdadm could do the same.
>=20
> I haven't quite figured the suspend issue out yet. It could be
> hardware (thinking maybe PSU?) but I'm trying to troubleshoot this
> issue methodologically. It started after an upgrade to a kernel >
> 3.0.2, I have yet to try a 2.6.x to see if it goes back to normal.
> When it does resume properly, everything is fine (mdadm doesn't
> resync.) It's related to the sleep of death (or eternal sleep?) issue.

I guess it would be nice if we could somehow arrange that the array were
marked 'clean' just before suspend.... it looks like that should be possibl=
e.
'suspend notifiers' are called after the 'sync' and before user-space is
frozen.  I could maybe get md to register a 'suspend notifier' which poked
mdmon somehow so that it would mark the array as clean.  It might not even =
be
that hard.
If I were to create a patch against mainline (or maybe some earlier kernel =
if
you really wanted), would you be able/willing to test it out?

NeilBrown


--Sig_/P5ulg7QNCEOw=FGj3QYzazs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFgY0Tnsnt1WYoG5AQLJjQ/9F/P6K6CUCID+kHAfbeNh0XFyb4G/kItP
TlJ3kXnwDZrehlbstnWM2lPmAQycxD3be6K4IseS3IQ30b/qEBrdLDnLDYbUzZ0+
auB+ZBI45vCfvwyahzF5V8Wil5MswFZZga2ORM2b9eq9urvNPzZcwmIy8CrXiVMZ
iaHTS7VVQfA7DQm4lOxO7UqPJwOuAuUEvDE5MGmmYofOsNdOx2y5MirrzGT35ovK
mS8FWEsE/dM1GZ4sc/5smWBRfZ1P3iuqFd/VR6yzfk6DdldVHdZsgbkIZ23iOaLP
RcIrZyAEoAAa6izTZiEo+Oy64OuQ9H747Wh2x6bCUMSabuYG5pIZutwUI0u94RJE
RFc1sA/i2iGI9PrvxVH1cQKBBJoHwF6l37S8MKWvaJW6/ANTmY/UNpfsEayvR6sZ
8aE6yF09sVRKNyUsRzb08NAlYcRFH0VJMK9PxPwLqre+0ttx/z2Tq4S2Vi1W844B
JiLppLu7orH7T6RJPJgWgDjW+bLWh0eKTowrJfeEEAJzTlrjC2xUoGHrOZjMEUUV
ijAZreRtybqkXRguHl34OoXAL/xnysOYUWcfKfAUh81Ez9wuRpKxl3rMhHEdYXBq
R8Q1YC2Pu5iGhRG7J4wrSAp+BR338ovU/Pij+mpWgJgfX/cYEFNsAlkRy6AVBQKX
fTFakK0PMuE=
=CyMh
-----END PGP SIGNATURE-----

--Sig_/P5ulg7QNCEOw=FGj3QYzazs--
