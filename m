From: Jeff Breidenbach <jeff@jab.org>
Subject: split RAID1 during backups?
Date: Wed, 26 Oct 2005 01:17:47 -0700
Message-ID: <E1EUgTj-0001lj-00@toko.jab.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Norman> What you should be able to do with software raid1 is the
Norman> following: Stop the raid, mount both underlying devices
Norman> instead of the raid device, but of course READ ONLY. Both
Norman> contain the complete data and filesystem, and in addition to
Norman> that the md superblock at the end. Both should be identical
Norman> copies of that.  Thus, you do not have to resync
Norman> afterwards. You then can backup the one disk while serving the
Norman> web server from the other. When you are done, unmount,
Norman> assemble the raid, mount it and go on.

I tried both variants of Norman's suggestion on a test machine and
they worked great. Shutting down and restarting md0 did not trigger a
rebuild. Perfect! And I could mount component partitions
read-only at any time. However on the production machine the
component partitions refused to mount, claiming to be "already
mounted". Despite the fact that the component drives do not show up
anywhere in lsof or mtab. When I saw this, I got nervous and did not
even try stopping md0 on the production machine.

# mount -o ro /dev/sdc1 backup
mount: /dev/sdc1 already mounted or backup busy

The two machines hardly match. The test machine has a 2.4.27 kernel
and JBOD drives hanging off a 3ware 7xxx controller. The production
machine has a 2.6.12 kernel and Intel SATA controllers. Both machines
have mdadm 1.9.0, and the discrepancy in behavior seems weird to
me. Any insights?

Paul> There have been a couple bug fixes in the bitmap stuff since
Paul> 2.6.13 was released, but it's stable. You'll need mdadm 2.x as
Paul> well.

It turns out Debian has not yet packaged 2.6.13 even in the unstable
branch. I will wait for this to happen before trying out the whizzy
intent-logging and write-mostly suggestions. I'm brave, but not THAT
brave. 

Dean> i didn't realise you were using reiserfs... i'd suggest
Dean> disabling tail packing... but then i've never used reiser, and
Dean> i've only ever seen reports of tail packing having serious
Dean> performance impact.

Done, thanks.

Bill> If you want to try something "which used to work" see nbd,
Bill> export 500GB from another machine, add the network block device
Bill> to the mirror, let it sync, break the mirror. Haven't tried
Bill> since 2.4.19 or so.

Wow, nbd (network block device) sounds really useful. I wonder if it
is a good way to provide more spindles to a hungry webserver.  Plus
they had a major release yesterday. While I've been focusing on
managing disk contention, if there's an easy way to reduce it, that's
definitely fair game.

Some of the other suggestions I'm going to hold off on. For example,
sendfile() doesn't really address the bottleneck of disk contention.
I'm also not so anxious to switch filesystems. That's a two week
endeavor that doesn't really address the contention issue. And it's
also a little hard for me to imagine that someone is going to beat the
pants off of reiserfs, especially since reiserfs was specifically
designed to deal with lots of small files efficiently. Finally, I'm
not going to focus on incremental backups if there's any prayer of
getting a 500GB full backup in 3 hours.  Full backups provide a LOT of
warm fuzzies.

Again, thank you all very much.

-Jeff
