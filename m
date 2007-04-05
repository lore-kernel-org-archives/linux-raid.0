From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RAID1 "out of memory" error, was Re: 2.6.21-rc5-mm4
Date: Thu, 5 Apr 2007 13:21:48 -0700
Message-ID: <20070405132148.04d01bad.akpm@linux-foundation.org>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<461524BF.7050304@reub.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <461524BF.7050304@reub.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reuben Farrelly <reuben-linuxkernel@reub.net>
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 06 Apr 2007 02:33:03 +1000
Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:

> Hi,
> 
> On 3/04/2007 3:47 PM, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> > 
> > - The oops in git-net.patch has been fixed, so that tree has been restored. 
> >   It is huge.
> > 
> > - Added the device-mapper development tree to the -mm lineup (Alasdair
> >   Kergon).  It is a quilt tree, living at
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/.
> > 
> > - Added davidel's signalfd stuff.
> 
> Looks like some damage, or maybe intolerance to on-disk damage, to RAID-1.
> 
> md1 is the first array on the disk, and it refuses to start up on boot, or after 
> boot.
> 
> ...
> 
> tornado ~ # mdadm --assemble /dev/md1 /dev/sda1 /dev/sdc1
> mdadm: device /dev/md1 already active - cannot assemble it
> tornado ~ # mdadm --run /dev/md1
> mdadm: failed to run array /dev/md1: Cannot allocate memory
> tornado ~ #
> 
> and looking at a dmesg, this is logged:
> 
> md: bind<sdc1>
> md: bind<sda1>
> raid1: raid set md1 active with 2 out of 2 mirrors
> md1: bitmap initialized from disk: read 0/1 pages, set 0 bits, status: -12
> md1: failed to create bitmap (-12)
> md: pers->run() failed ...
> 
> tornado ~ # uname -a
> Linux tornado 2.6.21-rc5-mm4 #1 SMP Thu Apr 5 23:47:42 EST 2007 x86_64 Intel(R) 
> Pentium(R) 4 CPU 3.00GHz GenuineIntel GNU/Linux
> tornado ~ #
> 
> The last known version that worked was 2.6.21-rc3-mm1 - I haven't been testing 
> out the -mm releases so much lately.

OK.  I assume that bitmap->chunks in bitmap_init_from_disk() has some
unexpectedly large value.

I don't _think_ there's anything in -mm which would have triggered this. 
Does mainline do the same thing?

I guess it's possible that the code in git-md-accel.patch accidentally
broke things.  Perhaps try disabling CONFIG_DMA_ENGINE?

> Also, Andrew, can you please restart posting/cc'ing your -mm announcements to 
> the linux-kernel-announce@vger.kernel.org list?  Seems this stopped around about 
> 2.6.20, it was handy.

hm.  I always Bcc linux-kernel-announce@vger.kernel.org.  I assume that its
filters didn't get updated after the s/osdl/linux-foundation/ thing.  I'll
talk to people, thanks.

> .config is up at http://www.reub.net/files/kernel/configs/2.6.21-rc5-mm4
> 

