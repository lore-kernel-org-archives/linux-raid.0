From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm file system type check
Date: Sat, 17 Mar 2007 16:40:02 +1100
Message-ID: <17915.32562.482059.394771@notabene.brown>
References: <1174089424.22511.26.camel@wlt.obsidian-studios.com>
	<17915.17571.333717.668140@notabene.brown>
	<1174099334.13073.46.camel@wlt.obsidian-studios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from William L. Thomson Jr. on Friday March 16
Sender: linux-raid-owner@vger.kernel.org
To: "William L. Thomson Jr." <wltjr@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday March 16, wltjr@gentoo.org wrote:
> 
> Instead of passing along an interpretation, here are some IRC log
> snippets that pertain from #gentoo-dev @ freenode.net
> 
> kingtaco|work: livecd ~ # mdadm --create --level=1 --raid-devices=2 /dev/md0 /dev/sda1 /dev/sdb1
> kingtaco|work: mdadm: /dev/sda1 is too small: 0K
> kingtaco|work: mdadm: create aborted
> 
> Now despite suggesting it pretty early on, it took a bit of time to
> realize that error was existing only because of file system type. Once
> he realized the problem and changed fs type. All was well, and he was
> able to create the arrays and move on.
> 
> kingtaco|work: wltjr, see, raidtools would have let me create an array eventhough the type wasn't fs
> kingtaco|work: er, fd
> kingtaco|work: mdadm just isn't that smart
> kingtaco|work: (and that fixed it)
> 
> So ot to sure about the error or why they would get that just because of
> file system type.


This failure has nothing do to with the partition type. As I
mentioned, mdadm doesn't see the partition type at all.

When you change the partition type, fdisk (or whatever) normally tells
the kernel to reread the partition table.  It would seem that the
partition table hadn't been read properly before this point, so
/dev/sda1 didn't exist.  After running fdisk that partition table had
been read by the kernel and everything was fine.
I.e. it was using fdisk to write the partition table that 'fixed' the
problem, not changing the partition type.  And the problem was not
causes by mdadm but by something else not setting up the partitions
properly (or removing them maybe).

NeilBrown
