From: "Rob Bray" <raid@bymeinc.com>
Subject: Re: Raid on USB flash disk
Date: Mon, 5 Mar 2007 11:38:43 -0500 (EST)
Message-ID: <34133.192.168.0.1.1173112723.squirrel@bymeinc.com>
References: <45CE0DD9.4050009@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45CE0DD9.4050009@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hi,
>
> I just tried to setup a one-device raid onto an USB flash drive.
> Creating, setting up ext3 and filling with data was no problem.
> But when I tried to work with it afterwards the metadevice was
> unresponsive. I tried both linear and raid0 levels, but that
> made no difference.
> For my uneducated eye it looks like something is deadlocking if
> md tries to read from the device.
>
> I'm using kernel 2.6.18 (gentoo) on a VIA EPIA CN10000 mainboard
> with a 2GB USB flash drive (extreme). Please ask if I should provide
> more information like dmesg or lspci.
>
> The main reason why I'm trying this weird setup is that the USB
> drive is always enumerated last in my kernel, and I want to boot
> from it. That means every time I add a disk or remove one I have
> to edit grub.conf and fstab. Very inconvenient. So my idea was
> to create a single device md on it and leave it to the autodetection
> to find the device. So I never have to edit /etc/fstab again for
> a simple hardware change and I'm independent of any enumeration
> changes in future kernel releases.
>
> But unfortunately it doesn't work :-(
>
> Any help appreciated.
>
> --Arne
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I believe you could use udev persistant names (eg /dev/dsk/by-name) to
refer to your USB partitions, instead of /dev/sd?, etc.

