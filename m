From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [Ext2-devel] Re: Journal-guided Resynchronization for Software RAID
Date: Thu, 8 Dec 2005 03:53:39 -0700
Message-ID: <20051208105339.GN14509@schatzie.adilger.int>
References: <Pine.LNX.4.58.0511301015520.14240@macduff.cs.wisc.edu> <17294.34794.477608.760700@cse.unsw.edu.au> <Pine.LNX.4.63.0512022211460.4248@twinlark.arctic.org> <17299.27732.251785.345960@cse.unsw.edu.au> <Pine.LNX.4.61.0512080901280.31862@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0512080901280.31862@praktifix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Neil Brown <neilb@suse.de>, dean gaudet <dean-list-linux-raid@arctic.org>, "Timothy E. Denehy" <tedenehy@cs.wisc.edu>, linux-raid <linux-raid@vger.kernel.org>, ext2-devel@lists.sourceforge.net, tytso@mit.edu, akpm@osdl.org
List-Id: linux-raid.ids

On Dec 08, 2005  09:20 +0000, Holger Kiehl wrote:
> Do you have any performance numbers that show how these cards increase
> performance? I have tried doing it with a ramdisk and the performance
> was not much better, using ext3 and journal on ramdisk. ext2 is still
> much faster, here some quick tests with dd:
> 
>      2.6.15-rc1-git2
> 
>      time dd if=/dev/full of=/home/aaaa bs=4M count=4883
>      SW Raid 1+0
>      ext2
>      real    1m11.856s 1m16.050s 1m18.449s
>      user     0m0.020s  0m0.000s  0m0.010s
>      sys     0m44.630s 0m44.820s 0m45.870s
> 
>      ext3 writeback
>      real    2m1.511s  1m40.958s 1m43.889s
>      user    0m0.070s   0m0.000s  0m0.000s
>      sys     1m33.390s 1m21.470s 1m23.430s
> 
>      ext3 writeback+external journal in ram disk
>      real     2m5.357s 1m41.349s 1m36.228s
>      user     0m0.010s  0m0.020s  0m0.010s
>      sys     1m37.500s 1m24.110s 1m21.960s
> 
> Wonder how one can increase the write performance but still having a 
> journal.

You should test a metadata workload that uses the journal a lot
(e.g. bonnie file create/unlink) to see if there is a more noticable
effect for the external journal.  Also, increasing the journal size can
have a noticable effect on performance, which is why Ted increased the
default journal size for large filesystems to 128MB.


To get ext3 performance on-par with ext2 it is possible to use the
delalloc+mballoc+extent patches, which Alex+IBM were testing for 2.6.12
a while back.  I believe Mingming also worked on delalloc patches for
regular block-allocated ext3 filesystems.  If you search for "mballoc
delalloc" in ext2-devel you will find some benchmark data on this.

Hopefully Alex will have some time in the new year to make the new version
of the mballoc patch and updates for a newer kernel available for testing.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

