From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6: help wanted
Date: Tue, 26 Oct 2004 23:03:28 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <417F3A30.4000902@zytor.com>
References: <cleqh6$ps4$1@terminus.zytor.com> <16764.37392.910080.718564@cse.unsw.edu.au> <20041025062026.GA17502@jim.sh> <16767.6168.695527.234379@cse.unsw.edu.au> <417F30C7.9050308@zytor.com> <20041027060018.GA17085@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041027060018.GA17085@jim.sh>
To: Jim Paris <jim@jtan.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Paris wrote:
>>That makes sense (and definitely explains why I didn't find the problem.)
>>
>>I tried it out, and it seems much better now.  It does, however, still 
>>seem to have a problem:
>>
>>+ e2fsck -nf /dev/md6
>>e2fsck 1.35 (28-Feb-2004)
>>Pass 1: Checking inodes, blocks, and sizes
>>Inode 7 has illegal block(s).  Clear? no
>>
>>Illegal block #-1 (33619968) in inode 7.  IGNORED.
>>Error while iterating over blocks in inode 7: Illegal indirect block found
>>e2fsck: aborted
> 
> 
> The patch (thanks, Neil!) seems to work fine for me with both the
> ReiserFS and ext2 test scripts, on an x86, both with and without
> waiting for resync.
> 

Right, see previous; it seems to be an unrelated ppc64 problem that 
happens even without RAID of any kind.  I'm building an i386 kernel with 
the patch now to try it out.

FWIW, I also hacked up Altivec support for ppc/ppc64; it took all of a 
whopping half-hour to make work, since gcc can generate Altivec code and 
it's actually quite good at it.  The resulting code runs at a whopping 
6.1 GB/s on a 2.5 GHz 970.

	-hpa
