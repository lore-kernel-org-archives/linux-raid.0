From: Micah Anderson <micah@riseup.net>
Subject: Re: Unable to read superblock
Date: Tue, 23 Jul 2002 14:01:37 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020723210137.GD27638@riseup.net>
References: <20020718033404.GR17829@riseup.net> <20020722234502.GP12736@riseup.net> <20020723025205.GB14359@willow.seitz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020723025205.GB14359@willow.seitz.com>
To: Ross Vandegrift <ross@willow.seitz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 22 Jul 2002, Ross Vandegrift wrote:

> On Mon, Jul 22, 2002 at 04:45:03PM -0700, Micah Anderson wrote:
> > > I had lilo set for:
> > > 
> > > boot=/dev/md0
> > > root=/dev/md5
> > > image=/boot/vmlinuz-2.2.20RAID
> > >         label=RAID
> > >         read-only
> > >         alias=4
> 
> Are you using the raid-extra-boot option?  If you aren't you probably
> want to be - it'll allow the system to boot if one of the boot drives is
> dead.

Actually, I switched to grub, I wasn't aware of the raid-extra-boot
option, wonder if there is something similar in grub.


> This may sound dumb, but are you sure you didn't compile RAID1 as a
> module?  If you did, you'll need to use an initrd to load the module
> before you mount root.  Otherwise, you'll need to rebuild the kernel
> with the driver included in the kernel.

Yes, I did *not* build them as modules. Modules are too much of a
pain. :)

Micah

