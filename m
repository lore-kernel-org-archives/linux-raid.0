From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6: help wanted
Date: Tue, 26 Oct 2004 22:23:19 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <417F30C7.9050308@zytor.com>
References: <cleqh6$ps4$1@terminus.zytor.com>	<16764.37392.910080.718564@cse.unsw.edu.au>	<20041025062026.GA17502@jim.sh> <16767.6168.695527.234379@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16767.6168.695527.234379@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Jim Paris <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> Ok, take-2.  I've tested this one myself and it does seem to fix it.
> 
> The problem is that it is sometimes using parity to reconstruct a
> block, when not all of the blocks have been read in.
> 
> In raid5, there are two choices for write - reconstruct-write or
> read-modify-write.
> 
> If there are any failed drives, it always chooses read-modify-write
> and so only has to read data from good drives.
> 
> raid6 only allows for reconstruct-write, so if it ever writes to an
> array with a failed drive, it must read all blocks and reconstruct the
> missing blocks before allowing the write.
> As this is something that raid5 didn't have to care about, and as the
> raid6 code was based on the raid5 code, it is easy to see how this
> case was missed.
> 
> The following patch added a bit of tracing to track other cases
> (hopefully non-existent) where calculations are done using
> non-existent data, and make sure the required blocks are pre-read.
> Possible this code (in handle_stripe) needs a substantial clean up...
> 
> I'll wait for comments and further testing before I forward it to
> Andrew.
> 

That makes sense (and definitely explains why I didn't find the problem.)

I tried it out, and it seems much better now.  It does, however, still 
seem to have a problem:

+ e2fsck -nf /dev/md6
e2fsck 1.35 (28-Feb-2004)
Pass 1: Checking inodes, blocks, and sizes
Inode 7 has illegal block(s).  Clear? no

Illegal block #-1 (33619968) in inode 7.  IGNORED.
Error while iterating over blocks in inode 7: Illegal indirect block found
e2fsck: aborted

Inode 7 is a special-use inode:
#define EXT3_RESIZE_INO          7      /* Reserved group descriptors 
inode */

This is running the version of the r6ext.sh script that I posted, with 
the same datafile, on a PowerMac.

	-hpa
