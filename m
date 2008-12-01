From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm and automatic re-add / incremental mode with usb-disk
Date: Mon, 1 Dec 2008 11:32:53 +1100 (EST)
Message-ID: <84ecb37ac21f70e48b360192851e2f3a.squirrel@neil.brown.name>
References: <200811301231.58180.wilhelm.meier@fh-kl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200811301231.58180.wilhelm.meier@fh-kl.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, November 30, 2008 10:31 pm, Wilhelm Meier wrote:
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

You would need to put some magic in udev.
Something in /etc/udev/rules.d would need to do something like
 RUN+="/sbin/mdadm -I ..the..device.name"

if the detected device was one that you want to be added to an array.
I have tried this yet so I don't know the details of how to make it
work.


>
> I tried the mdm-2.6.2 from etch-backports too. Same effect.
>
> Here, if I try to use the --incremental mode, it constructs a new (!)
> array /dev/md/d_1000  instead of adding it to /dev/md1000.
> Thats strange to me.

--incremental only works properly if the array was created by
--incremental.  You might be able to make it work better by
running
   mdadm -Ir

first.  This recreates /var/run/mdadm/map.


Good luck!

NeilBrown

