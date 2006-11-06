From: dean gaudet <dean@arctic.org>
Subject: Re: mdadm 2.5.5 external bitmap assemble problem
Date: Mon, 6 Nov 2006 00:26:16 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611060018300.20361@twinlark.arctic.org>
References: <Pine.LNX.4.64.0611041838080.13706@twinlark.arctic.org>
 <17742.27204.963051.400395@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17742.27204.963051.400395@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 6 Nov 2006, Neil Brown wrote:

> > hey i have another related question... external bitmaps seem to pose a bit 
> > of a chicken-and-egg problem.  all of my filesystems are md devices. with 
> > an external bitmap i need at least one of the arrays to start, then have 
> > filesystems mounted, then have more arrays start... it just happens to 
> > work OK if i let debian unstale initramfs try to start all my arrays, 
> > it'll fail for the ones needing bitmap.  then later /etc/init.d/mdadm-raid 
> > should start the array.  (well it would if the bitmap= in mdadm.conf 
> > worked :)
> > 
> > is it possible to put bitmaps on devices instead of files?  mdadm seems to 
> > want a --force for that (because the device node exists already) and i 
> > haven't tried forcing it.  although i suppose a 200KB partition would be 
> > kind of tiny.... but i could place the bitmap right beside the external 
> > transaction log for the filesystem on the raid5.
> 
> Create the root filesystem with --bitmap=internal, and store all the
> other bitmaps on that filesystem maybe?

yeah i only have the one external bitmap (it's for a large raid5)... so 
things will work fine once i apply your patch.  thanks.

> I don't know if it would work to have a bitmap on a device, but you
> can always mkfs the device, mount it, and put a bitmap on a file
> there??

yeah this was the first thing i tried after i found mdadm -b /dev/foo 
wasn't accepted...

without modifying startup scripts there's no way to use any filesystem 
other than root... it's just due to ordering of init scripts:

# ls /etc/rcS.d | grep -i 'mount\|raid'
S02mountkernfs.sh
S04mountdevsubfs.sh
S25mdadm-raid
S35mountall.sh
S36mountall-bootclean.sh
S45mountnfs.sh
S46mountnfs-bootclean.sh

i'd need to run another mdadm-raid after the S35mountall, and then another 
mountall.

anyhow, i don't think you need to change anything (except maybe a note in 
the docs somewhere), i'm just bringing it up as part of the experience of 
trying external bitmap.  i suspect that in the wild and crazy direction 
debian and ubuntu are heading (ditching sysvinit for event-driven systems) 
it'll be "easy" to express the boot dependencies.

-dean
