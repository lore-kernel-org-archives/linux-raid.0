From: Nix <nix@esperi.org.uk>
Subject: Re: Making bootable SATA RAID1 array in Mandriva 2006
Date: Thu, 17 Aug 2006 00:49:10 +0100
Message-ID: <87lkpotf61.fsf@hades.wkstn.nix>
References: <44E319AD.6040603@aol.com>
	<Pine.LNX.4.64.0608161035070.21540@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0608161035070.21540@p34.internal.lan> (Justin Piszcz's message of "16 Aug 2006 15:35:39 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: andy liebman <andyliebman@aol.com>, bluca@comedia.it, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16 Aug 2006, Justin Piszcz murmured woefully:
> 
> -- snip --
> 
> If you are using a custom compiled kernel, why on earth would you want to use an initrd?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Lack of understanding of initramfs? :) it's new and many distros don't
use it yet, so I can understand a bit of confusion.

Andy, you might want to look at
<http://linux-raid.osdl.org/index.php/RAID_Boot> for the initramfs setup
I use, based around uClibc and busybox. It can fsck-and-mount root
stored on RAID+LVM or on LVM alone, and with small adjustments should be
able to boot RAID alone with no LVM involved (I'll make those changes
shortly, I just haven't needed them myself).

-- 
`We're sysadmins. We deal with the inconceivable so often I can clearly 
 see the need to define levels of inconceivability.' --- Rik Steenwinkel
