From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: patches for mdadm 1.8.0 (auto=dev and stacking of devices)
Date: Sun, 23 Jan 2005 19:52:53 +0100
Message-ID: <5d8dc2-utu.ln1@news.it.uc3m.es>
References: <20050123151305.GB15317@percy.comedia.it> <20050123152819.GE24350@marowsky-bree.de> <41F3D4E5.1020300@tls.msk.ru> <20050123170009.GD15317@percy.comedia.it>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra <bluca@comedia.it> wrote:
> I believe the correct solution to this would be implementing a char-misc
> /dev/mdadm device that mdadm would use instead of the block device,
> like device-mapper does. Alas i have no time for this in the forseable
> future.

It's a generic problem (or non-problem) - there's nothing wrong with
mdadm needing a special device file nor with the driver allowing ioctls
on any of the minors.  Device files have traditionally always been
supplied with the o/s, so it is the duty of an install script to make
them if they will or might be needed later.

And in the absence of an install script, a boot script.

Making special device files "on demand" requires the cooperation of the
driver and devfs (and since udev apparently replaces devfs, udev). One
would need to add the code to the driver.

> >BTW, is there a real need to do that?  In theory, one might just
> >create the necessary /dev/md1 from within startup script...
> I would have done it in a script if --auto was not implemented, the
> changes to have auto=dev are not big, mostly man page and indenting.

I'm not sure I follow that. If I understand you, --auto was what you
added to mdadm to make the special device files.

Personally I would prefer there to be no unannounced making of device
files, but yours is an extra flag so it does no harm in that sense.
However, I think it is a mistaken addition.  You can see that by asking
yourself why EVERY control utility does not have that option in it.
Hdparm?  Fdisk?

The answer is: because it's (a) silly, (b) none of its business. And
the same applies here. If the sysadmin does not want a dev file, then
let him be. If he wants one, let him make it.

However, as a matter of convenience, I would prefer that the driver
made the devices in /dev or /sys or wherever if it can. I don't recall
if the code is there or not!

Is there a udev document anywhere? I searched in 2.6.8.1 and found
nothing (I won't burden you with the details of my obviously too
cursory search).


Peter

