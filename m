From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: Unable to read superblock
Date: Mon, 22 Jul 2002 22:52:05 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020723025205.GB14359@willow.seitz.com>
References: <20020718033404.GR17829@riseup.net> <20020722234502.GP12736@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020722234502.GP12736@riseup.net>
To: Micah Anderson <micah@riseup.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 22, 2002 at 04:45:03PM -0700, Micah Anderson wrote:
> > I had lilo set for:
> > 
> > boot=/dev/md0
> > root=/dev/md5
> > image=/boot/vmlinuz-2.2.20RAID
> >         label=RAID
> >         read-only
> >         alias=4

Are you using the raid-extra-boot option?  If you aren't you probably
want to be - it'll allow the system to boot if one of the boot drives is
dead.

However, this shouldn't be preventing you from mounting root.

> > When I installed 2.4.18, all of a sudden I can't boot, EXT2-fs: unable
> > to read superblock. Yes, I selected all the RAID options on kernel
> > compile.

This may sound dumb, but are you sure you didn't compile RAID1 as a
module?  If you did, you'll need to use an initrd to load the module
before you mount root.  Otherwise, you'll need to rebuild the kernel
with the driver included in the kernel.

Ross Vandegrift
ross@willow.seitz.com
