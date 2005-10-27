From: Bill Davidsen <tmrbill@tmr.com>
Subject: Re: split RAID1 during backups?
Date: Thu, 27 Oct 2005 09:23:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0510270910500.21222-100000@firewall2.tmr.com>
References: <E1EUgTj-0001lj-00@toko.jab.org>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EUgTj-0001lj-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 26 Oct 2005, Jeff Breidenbach wrote:

> 
> Norman> What you should be able to do with software raid1 is the
> Norman> following: Stop the raid, mount both underlying devices
> Norman> instead of the raid device, but of course READ ONLY. Both
> Norman> contain the complete data and filesystem, and in addition to
> Norman> that the md superblock at the end. Both should be identical
> Norman> copies of that.  Thus, you do not have to resync
> Norman> afterwards. You then can backup the one disk while serving the
> Norman> web server from the other. When you are done, unmount,
> Norman> assemble the raid, mount it and go on.
> 
> I tried both variants of Norman's suggestion on a test machine and
> they worked great. Shutting down and restarting md0 did not trigger a
> rebuild. Perfect! And I could mount component partitions
> read-only at any time. However on the production machine the
> component partitions refused to mount, claiming to be "already
> mounted". Despite the fact that the component drives do not show up
> anywhere in lsof or mtab. When I saw this, I got nervous and did not
> even try stopping md0 on the production machine.

As long as md0 is running I suspect the partition will be marked as in 
use. So you have to stop it. If the 2.4 kernel didn't detect that, I would 
call it a bug.

> 
> # mount -o ro /dev/sdc1 backup
> mount: /dev/sdc1 already mounted or backup busy
> 
> The two machines hardly match. The test machine has a 2.4.27 kernel
> and JBOD drives hanging off a 3ware 7xxx controller. The production
> machine has a 2.6.12 kernel and Intel SATA controllers. Both machines
> have mdadm 1.9.0, and the discrepancy in behavior seems weird to
> me. Any insights?

	[___snip___]
> 
> Bill> If you want to try something "which used to work" see nbd,
> Bill> export 500GB from another machine, add the network block device
> Bill> to the mirror, let it sync, break the mirror. Haven't tried
> Bill> since 2.4.19 or so.
> 
> Wow, nbd (network block device) sounds really useful. I wonder if it
> is a good way to provide more spindles to a hungry webserver.  Plus
> they had a major release yesterday. While I've been focusing on
> managing disk contention, if there's an easy way to reduce it, that's
> definitely fair game.
> 
> Some of the other suggestions I'm going to hold off on. For example,
> sendfile() doesn't really address the bottleneck of disk contention.

sendfile() bypasses the copy to user buffer, which in turn will bypass 
copy to system buffers, which eliminates contention for buffer space. Use 
vmstat to check, if you have a lot of system time and lots of space in 
buffers of various kinds, there's a good possibility that the problem is 
there.

> I'm also not so anxious to switch filesystems. That's a two week
> endeavor that doesn't really address the contention issue. And it's
> also a little hard for me to imagine that someone is going to beat the
> pants off of reiserfs, especially since reiserfs was specifically
> designed to deal with lots of small files efficiently. Finally, I'm
> not going to focus on incremental backups if there's any prayer of
> getting a 500GB full backup in 3 hours.  Full backups provide a LOT of
> warm fuzzies.
> 
> Again, thank you all very much.


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
Doing interesting things with little computers since 1979

