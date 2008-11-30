From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mdadm and automatic re-add / incremental mode with usb-disk
Date: Sun, 30 Nov 2008 06:48:15 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811300646440.29266@p34.internal.lan>
References: <200811301231.58180.wilhelm.meier@fh-kl.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200811301231.58180.wilhelm.meier@fh-kl.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 30 Nov 2008, Wilhelm Meier wrote:

> Hi,
>
> I'm using debian etch with mdadm 2.5.6-9.
>
> I have a md-device /dev/md1000 with two usb-disks as raid1. The array
> is assembled well if the system boots, if I unplug one of the disks,
> the array goes to degraded. Thats all ok.
>
> If I re-plug the usb-disk, udev discovers the device fine, but mdadm
> doesn't start the re-add to the md-array. I have to do this but hand.
>
> Is there something missing to make this work automatically?
>
> I tried the mdm-2.6.2 from etch-backports too. Same effect.
>
> Here, if I try to use the --incremental mode, it constructs a new (!)
> array /dev/md/d_1000  instead of adding it to /dev/md1000.
> Thats strange to me.
>
> I thought I got it working some weeks ago (maybe with earlier / other
> versions of mdadm or somme missing other tool), but I can't get the
> puzzle right now.
>
> Any hints?
> -- 
> Wilhelm
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Wilhelm,

As far as I know mdadm never will re-add a broken/failed/disconnected disk 
back into the array.  Perhaps what you saw before is on an un-clean shutdown
or something similar, upon reboot the array is checking/re-initializing.

When you have a failed drive and you re-attach it, it will stay as a 
removed unit and you need to remove it and add it manually as you stated.

Were you seeing something other than this before?

Justin.
