From: Thomas -Balu- Walter <tw@itreff.de>
Subject: Re: Woody, initrd, raid1, boot
Date: Tue, 18 Jun 2002 11:25:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020618112549.C14962@itreff.de>
References: <20020617171511.B12084@itreff.de> <20020617185019.GB7974@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020617185019.GB7974@unthought.net>; from jakob@unthought.net on Mon, Jun 17, 2002 at 08:50:19PM +0200
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for CCing, Jakob - I am not subscribed to the list and was
thinking of checking the archives, but this way answering is easier (and
might not shuffle threads too much)

+ Jakob Oestergaard <jakob@unthought.net> [17.06.02 21:05]:
> On Mon, Jun 17, 2002 at 05:15:11PM +0200, Thomas -Balu- Walter wrote:
[...]
> >         md: md driver 0.90.0 MAX_MD...
> >         cramfs: wrong magic
> >         EXT3-FS: unable to read superblock
> >         EXT2-FS: unable to read superblock
> >         Kernel panic: VFS: Unable to mount root fs on 09:01
> 
> Since it's cramfs that complains, I suppose it's your initrd that is
> bad.

Hm - thats the default woody initrd of that kernel, however I have added
the raid module, created a new initrd and got the same message - but I
can mount the initrd manually (-t cramfs -o loop) and look whats inside,
and I can spawn the shell at boot and load the modules manually (they
get loaded automatically too, but still can not find the superblocks)

> Compile the RAID-1 into the kernel, forget about using modules.  That is
> the simple solution that I use - I am no initrd expert, and I have no
> intentions of becoming one  :)

No, that would be "the easy way" - I am not supposed to give up on this
8). 

If I am able to get it running this way, I don't have to bother with
updates or other things. I could just get a new default debian
kernel-image and the initrd would be built with the new modules, ...

+ Scott Bisker <scott@bisker.com> wrote:
> What you need to do is recreate your initrd to include the modules you
> need during boot.  The default mkinitrd /boot/initrd-2.4.18-686-raid1
> 2.4.18-686-raid1 will not suffice.
> 
> Try this.
> 
> mkinitrd --preload=raid1 --preload=xor /boot/initrd-2.4.18-686-raid1
> 2.4.18-686-raid1

The debian mkinitrd does not have --preload, the modules that should be
included go into /etc/mkinitrd/modules. I've added raid1 already, but
not xor? Perhaps this is the one to go for?
> 
> Not sure about on debian, but raidtools should have at least the
> following tools.
> 
> /sbin/arytst
> /sbin/detect_multipath
> /sbin/lsraid
> /sbin/raidreconf

The ones above do not exist. Woody's raidtools2 are 0.90.20010914-15

> /sbin/mkraid
> /sbin/raid0run
> /sbin/raidhotadd
> /sbin/raidhotgenerateerror
> /sbin/raidhotremove
> /sbin/raidsetfaulty
> /sbin/raidstart
> /sbin/raidstop

I have those. Do they have to be on the initrd too?

     Balu
