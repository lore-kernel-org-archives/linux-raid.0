From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: fsck out of memory
Date: Sun, 9 Feb 2003 11:08:44 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0302090953440.1039@ddx.a2000.nu>
References: <Pine.LNX.4.53.0302071555110.718@ddx.a2000.nu>
 <Pine.LNX.4.53.0302071800200.1306@ddx.a2000.nu> <20030207102858.P18636@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030207102858.P18636@schatzie.adilger.int>
To: Andreas Dilger <adilger@clusterfs.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, Theodore Ts'o <tytso@mit.edu>, peter@chubb.wattle.id.au, tbm@a2000.nu
List-Id: linux-raid.ids

On Fri, 7 Feb 2003, Andreas Dilger wrote:

> Hmm, I don't think that will be easy...  By default e2fsck will load all
> of the inode blocks into memory (pretty sure at least), and if you have
> 76922880 inodes that is 9.6GB of memory, which you can't allocate from a
> single process on i386 no matter how much swap you have.  2.5GB sounds
> about right for the maximum amount of memory one can allocate.

hmms the data is not critical yet (i was just testing this server)
i really wonder why the crash was there in the first place

thing i found in /var/log/messages :

Feb  7 04:18:15 storage kernel: EXT3-fs error (device md(9,0)):
ext3_new_block:
Allocating block in system zone - block = 536875638
Feb  7 04:18:15 storage kernel: EXT3-fs error (device md(9,0)):
ext3_new_block:
Allocating block in system zone - block = 536875639

doesn't look ok to me (and explains the crash?)

makes me wonder if this can have todo with the lbd (to allow 2TB+ devices)
patch ? or is this something else?
(if it can be related to the lbd patch, i will remove 2 hd's from the
array (but i don't prefer this option))

also for not getting this thing again (that i can't fsck my filesystem)
what are the setting i can use for creating a large filesystem on /dev/md0
? (what is the maximum workable inodes?)

i did this :

mke2fs -j -m 0  -b 4096 -i 4096 -R stride=16

