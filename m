From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: patches for mdadm 1.8.0 (auto=dev and stacking of devices)
Date: Sun, 23 Jan 2005 21:27:05 +0100
Message-ID: <ptddc2-77c.ln1@news.it.uc3m.es>
References: <20050123151305.GB15317@percy.comedia.it> <20050123152819.GE24350@marowsky-bree.de> <41F3D4E5.1020300@tls.msk.ru> <20050123170009.GD15317@percy.comedia.it> <5d8dc2-utu.ln1@news.it.uc3m.es> <20050123191415.GF15317@percy.comedia.it>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra <bluca@comedia.it> wrote:
> On Sun, Jan 23, 2005 at 07:52:53PM +0100, Peter T. Breuer wrote:
> >Making special device files "on demand" requires the cooperation of the
> >driver and devfs (and since udev apparently replaces devfs, udev). One
> >would need to add the code to the driver.
> 
> devfs just created 256 /dev/md/<minor> entries, and that was obnoxyous,

It wasn't devfs - it was md, if anyone. One added calls to the drivers
to make devfs devices (well, I suppose some are made in other places
than the driver and I haven't checked what happens in md, but that is
the place the calls to make the devfs stuff would normally go).

If md makes too many for your taste, then you could submit a patch.  It
would entail doing the making as each md device is started, as opposed
to when the driver is loaded.  But as you noted there is a chicken/egg
problem.  To start md1 you have to run mdrun /dev/md1 (or whatever).

Fortunately, I think I recall that mdadm at least falls back to
/dev/md0 if it can't find md1, on the basis that any device will do for
the ioctls. I may be wrong.


> besides now we have mdp devices, and one of the aims of udev was
> avoiding /dev pollution with un-needed nodes.

I know nothing at all about udev. devfs I know most things about :).
One of the aims of devfs was to avoid unneeded entries in /dev/. I
therefore will assume that my knowledge of devfs translates to the
present case too, in the context of your comment, and say that well,
then you have to patch the driver to make the devices more
parsimoniously.

That combined with mdadm falling back to using /dev/md0 should be OK.
(I am not distinguishing between /dev/md/0 and /dev/md0 because I
don't care about the name!).

BTW - can I put in a plea for individual directories in /sys/whatever
for the controls for each device? I will want to control each device 
individually and at the moment there is no opportunity for a
non-invasive patch.

> >> >BTW, is there a real need to do that?  In theory, one might just
> >> >create the necessary /dev/md1 from within startup script...
> >> I would have done it in a script if --auto was not implemented, the
> >> changes to have auto=dev are not big, mostly man page and indenting.
> >
> >I'm not sure I follow that. If I understand you, --auto was what you
> >added to mdadm to make the special device files.
> nope,
> --auto was added by Neil some time ago, it is mostly needed for mdp
> devices, i just added the "dev" option to --auto.

OK.

> >Personally I would prefer there to be no unannounced making of device
> >files, but yours is an extra flag so it does no harm in that sense.
> >However, I think it is a mistaken addition.  You can see that by asking
> >yourself why EVERY control utility does not have that option in it.
> >Hdparm?  Fdisk?
> >
> >The answer is: because it's (a) silly, (b) none of its business. And
> >the same applies here. If the sysadmin does not want a dev file, then
> >let him be. If he wants one, let him make it.
> you should have told Neil back then.

Shrug.

> >However, as a matter of convenience, I would prefer that the driver
> >made the devices in /dev or /sys or wherever if it can. I don't recall
> >if the code is there or not!
> yes, but then you would need the char device trick.

No - you can make /dev/md0 at driver startup, let mdadm fall back to
using it (I think it does), and make the rest on device startup.

> >Is there a udev document anywhere? I searched in 2.6.8.1 and found
> >nothing (I won't burden you with the details of my obviously too
> >cursory search).
> >
> ftp://ftp.kernel.org/pub/linux/utils/kernel/hotplug

Uh, yuh. Thanks.

Peter

