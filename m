From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 29 Oct 2007 11:47:19 -0400
Message-ID: <1193672839.10336.443.camel@firewall.xsintricity.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com>
	 <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>
	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>
	 <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com>
	 <1193294406.10336.76.camel@firewall.xsintricity.com>
	 <472576A5.3030603@amfes.com>  <20071029081802.GB15475@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iFbzXgsCxYRsp1eO0gtM"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071029081802.GB15475@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-iFbzXgsCxYRsp1eO0gtM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-29 at 09:18 +0100, Luca Berra wrote:
> On Sun, Oct 28, 2007 at 10:59:01PM -0700, Daniel L. Miller wrote:
> >Doug Ledford wrote:
> >>Anyway, I happen to *like* the idea of using full disk devices, but the
> >>reality is that the md subsystem doesn't have exclusive ownership of th=
e
> >>disks at all times, and without that it really needs to stake a claim o=
n
> >>the space instead of leaving things to chance IMO.
> >>  =20
> >I've been re-reading this post numerous times - trying to ignore the=20
> >burgeoning flame war :) - and this last sentence finally clicked with me=
.
> >
> I am sorry Daniel, when i read Doug and Bill, stating that your issue
> was not having a partition table, i immediately took the bait and forgot
> about your original issue.

I never said *his* issue was lack of partition table, I just said I
don't recommend that because it's flaky.  The last statement I made
about his issue was to ask about whether the problem was happening
during initrd time or sysinit time to try and identify if it was failing
before or after / was mounted to try and determine where the issue might
lay.  Then we got off on the tangent about partitions, and at the same
time Neil started asking about udev, at which point it came out that
he's running ubuntu, and as much as I would like to help, the fact of
the matter is that I've never touched ubuntu and wouldn't have the
faintest clue, so I let Neil handle it.  At which point he found that
the udev scripts in ubuntu are being stupid, and from the looks of it
are the cause of the problem.  So, I've considered the initial issue
root caused for a bit now.


> like udev/hal that believes it knows better than you about what you have
> on your disks.
> but _NEITHER OF THESE IS YOUR PROBLEM_ imho

Actually, it looks like udev *is* the problem, but not because of
partition tables.

> I am also sorry to say that i fail to identify what the source of your
> problem is, we should try harder instead of flaming between us.

We can do both, or at least I can :-P

> Is it possible to reproduce it on the live system
> e.g. unmount, stop array, start it again and mount.
> I bet it will work flawlessly in this case.
> then i would disable starting this array at boot, and start it manually
> when the system is up (stracing mdadm, so we can see what it does)
>=20
> I am also wondering about this:
> md: md0: raid array is not clean -- starting background reconstruction
> does your system shut down properly?
> do you see the message about stopping md at the very end of the
> reboot/halt process?

The root cause is that as udev adds his sata devices one at a time, on
each add of the sata device it invokes mdadm to see if there is an array
to start, and it doesn't use incremental mode on mdadm.  As a result, as
soon as there are 3 out of the 4 disks present, mdadm starts the array
in degraded mode.  It's probably a race between the mdadm started on the
third disk and mdadm started on the fourth disk that results in the
message about being unable to set the array info.  The one loosing the
race gets the error as the other one has already manipulated the array
(for example, the 4th disk mdadm could be trying to add the first disk
to the array, but it's already there, so it gets this error and bails).

So, as much as you might dislike mkinitrd since 5.0 Luca, it doesn't
have this particular problem ;-)  In the initrd we produce, it loads all
the SCSI/SATA/etc drivers first, then calls mkblkdevs which forces all
of the devices to appear in /dev, and only then does it start the
mdadm/lvm configuration.  Daniel, I make no promises what so ever that
this will even work at all as it may fail to load modules or all other
sorts of weirdness, but if you want to test the theory, you can download
the latest mkinitrd from fedoraproject.org, then use it to create an
initrd image under some other name than your default image name, then
manually edit your boot to have an extra stanza that uses the mkinitrd
generated initrd image instead of the ubuntu image, and then just see if
it brings the md device up cleanly instead of in degraded mode.  That
should be a fairly quick and easy way to test if Neil's analysis of the
udev script was right.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-iFbzXgsCxYRsp1eO0gtM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJgCHTzP9PM7pjw8RAlFvAJ4lZehTbg+fsLVg7FWhSWCuT1jGpQCfVsHm
j6/Ln2uxqVKDGYSnPWQNek0=
=vyvB
-----END PGP SIGNATURE-----

--=-iFbzXgsCxYRsp1eO0gtM--

