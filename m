From: Jim Paris <jim@jtan.com>
Subject: Re: RAID-6: help wanted
Date: Wed, 27 Oct 2004 02:00:18 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041027060018.GA17085@jim.sh>
References: <cleqh6$ps4$1@terminus.zytor.com> <16764.37392.910080.718564@cse.unsw.edu.au> <20041025062026.GA17502@jim.sh> <16767.6168.695527.234379@cse.unsw.edu.au> <417F30C7.9050308@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <417F30C7.9050308@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> That makes sense (and definitely explains why I didn't find the problem.)
> 
> I tried it out, and it seems much better now.  It does, however, still 
> seem to have a problem:
> 
> + e2fsck -nf /dev/md6
> e2fsck 1.35 (28-Feb-2004)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 7 has illegal block(s).  Clear? no
> 
> Illegal block #-1 (33619968) in inode 7.  IGNORED.
> Error while iterating over blocks in inode 7: Illegal indirect block found
> e2fsck: aborted

The patch (thanks, Neil!) seems to work fine for me with both the
ReiserFS and ext2 test scripts, on an x86, both with and without
waiting for resync.

-jim
