From: dean gaudet <dean@arctic.org>
Subject: Re: naming of md devices
Date: Wed, 22 Mar 2006 18:07:58 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603221757340.1724@twinlark.arctic.org>
References: <87slpav0p6.fsf@uwo.ca> <87ek0uc595.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ek0uc595.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Dan Christensen <jdc@uwo.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 23 Mar 2006, Nix wrote:

> Last I heard the Debian initramfs constructs RAID arrays by explicitly
> specifying the devices that make them up. This is, um, a bad idea:
> the first time a disk fails or your kernel renumbers them you're
> in *trouble*.

yaird seems to dtrt ... at least in unstable.  if you install yaird 
instead of initramfs-tools you get stuff like this in the initrd /init:

mknod /dev/md3 b 9 3
mdadm -Ac partitions /dev/md3 --uuid 2b3a5b77:c7b4ab81:a2b8322a:db5c4e88

initramfs-tools also appears to do something which should work... but i 
haven't tested it... it basically runs "mdrun /dev" without specifying a 
minor/uuid for the root, so it'll start all arrays... i'm afraid that 
might mess up for one of my arrays which is "auto=mdp"... and has the 
annoying property of starting arrays on disks you've moved from other 
systems.

so anyhow i lean towards yaird at the moment... (and i should submit some 
bug reports i guess).

the above is on unstable... i don't use stable (and stable definitely does 
the wrong thing -- 
<http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=338200>).

-dean
