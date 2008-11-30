From: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Subject: Re: mdadm and automatic re-add / incremental mode with usb-disk
Date: Sun, 30 Nov 2008 14:03:29 +0100
Message-ID: <200811301403.29920.wilhelm.meier@fh-kl.de>
References: <200811301231.58180.wilhelm.meier@fh-kl.de> <alpine.DEB.1.10.0811300646440.29266@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811300646440.29266@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Sonntag 30 November 2008 schrieb Justin Piszcz:
> On Sun, 30 Nov 2008, Wilhelm Meier wrote:
> > Hi,
> >
> > I'm using debian etch with mdadm 2.5.6-9.
> >
> > I have a md-device /dev/md1000 with two usb-disks as raid1. The
> > array is assembled well if the system boots, if I unplug one of
> > the disks, the array goes to degraded. Thats all ok.
> >
> > If I re-plug the usb-disk, udev discovers the device fine, but
> > mdadm doesn't start the re-add to the md-array. I have to do this
> > but hand.
> >
> > Is there something missing to make this work automatically?
> >
> > I tried the mdm-2.6.2 from etch-backports too. Same effect.
> >
> > Here, if I try to use the --incremental mode, it constructs a new
> > (!) array /dev/md/d_1000  instead of adding it to /dev/md1000.
> > Thats strange to me.
> >
> > I thought I got it working some weeks ago (maybe with earlier /
> > other versions of mdadm or somme missing other tool), but I can't
> > get the puzzle right now.
> >
> > Any hints?
> > --
> > Wilhelm
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-raid" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at 
> > http://vger.kernel.org/majordomo-info.html
>
> Wilhelm,
>
> As far as I know mdadm never will re-add a
> broken/failed/disconnected disk back into the array.  Perhaps what
> you saw before is on an un-clean shutdown or something similar,
> upon reboot the array is checking/re-initializing.

That might be, but what is the difference between doing the re-add and 
re-sync on boot (that's what happens!) or if the drive comes back on 
a running system.

mdadm can surely determine the state/uuid and do this - the same as on 
reboot.

> When you have a failed drive and you re-attach it, it will stay as
> a removed unit and you need to remove it and add it manually as you
> stated.

the only thing I have to do is e.g.

mdadm --re-add /dev/md1000 /dev/sdg1

then it starts reconstructing the right way.

So, my thought was to do this as part of a udev-rule. 
But I think this is a common case and therefore there should be a 
well-known solution

> Were you seeing something other than this before?

I might be wrong, but I thought it was on debian ...

> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Wilhelm
