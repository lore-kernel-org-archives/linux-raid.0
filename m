From: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Subject: Re: mdadm and automatic re-add / incremental mode with usb-disk
Date: Mon, 1 Dec 2008 07:46:55 +0100
Message-ID: <200812010746.55418.wilhelm.meier@fh-kl.de>
References: <200811301231.58180.wilhelm.meier@fh-kl.de> <84ecb37ac21f70e48b360192851e2f3a.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84ecb37ac21f70e48b360192851e2f3a.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Montag 01 Dezember 2008 schrieb NeilBrown:
> On Sun, November 30, 2008 10:31 pm, Wilhelm Meier wrote:
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
>
> You would need to put some magic in udev.
> Something in /etc/udev/rules.d would need to do something like
>  RUN+="/sbin/mdadm -I ..the..device.name"

Yes, I tried that and it works half-the-way: as I wrote in another 
posting, mdadm -I does not allow the -c configfile option. Because I 
use a different config for a special set of devices, mdadm -I does 
not know the uuid's of the arrays of this special config file and 
therefore creates a new array with a different naming scheme (and 
different major/minor dev-numbers) (see below).

>
> if the detected device was one that you want to be added to an
> array. I have tried this yet so I don't know the details of how to
> make it work.
>
> > I tried the mdm-2.6.2 from etch-backports too. Same effect.
> >
> > Here, if I try to use the --incremental mode, it constructs a new
> > (!) array /dev/md/d_1000  instead of adding it to /dev/md1000.
> > Thats strange to me.
>
> --incremental only works properly if the array was created by
> --incremental.  

Thats a point I don't understand. 
Should I use --increment instead of normal creation and 
later --assemble? 
Why is this different?
Can this work together, I mean: can I --assemble arrays (as most 
distros do that on boot) and later --incremental create/reconstruct 
other arrays?

> You might be able to make it work better by 
> running
>    mdadm -Ir
>
> first.  This recreates /var/run/mdadm/map.

-- 
Wilhelm
