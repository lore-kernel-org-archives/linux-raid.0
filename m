From: Neil Brown <neilb@suse.de>
Subject: Re: Map Block number from hdd to md
Date: Tue, 16 Feb 2010 12:20:14 +1100
Message-ID: <20100216122014.18696241@notabene.brown>
References: <7362c3826262551b46e9b0bb1a777633@rw23.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7362c3826262551b46e9b0bb1a777633@rw23.de>
Sender: linux-raid-owner@vger.kernel.org
To: Michael <michael@rw23.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 12 Feb 2010 01:24:30 +0100
Michael <michael@rw23.de> wrote:

> Hello,
> 
> i've came into the situation that one of my 4 mdadm raid5 drives failed.
> not realy faild, but not detectet at system startup. so i started resync,
> and one of the remaining hdd's had a bad block and faild. so 2 drives
> offline and raid not functional anymore.
> 
> 1st question:
> i have read that it is possible with debugfs to locate which file belongs
> to the bad block on a ext file system. good thing, so i can check if i have
> *lost* an inportant or an unimportant file... or just free space.
> problen with this is, that i cant map the known bad block from, lets say,
> sda to my raid array md0.
> 
> is there any method to find that bad block in context of the raid block
> device? reading all files is not a good option on large raidsets.
> level 5, 64k chunk, algorithm 2

It isn't that hard.  The code is in drivers/md/raid5.c in the kernel.....

Rather than trying to describe in general, give me the block number, device,
and "mdadm --examine" of that device, and I'll tell you how I get the answer.



> 
> 2nd question:
> 
> in my case, i have a functional raid5 array with 3 of 4 disks, in which
> one of the active discs has a bad sector. assume that the one failed disk
> has consistent parity information/data on this sector, but has been altered
> so that a complete resync would not work. is there a way to resync only
> that one chunk that belongs to the block? using the data from the 3 drives
> without a bad block, even if one is not a active part of the array but was
> before?

No.
If you were desperate, you could use 'dd' to read each of the chunks into a
file, then write a little c/perl/whatever program to xor those files
together, then use 'dd' to write that file back out the the target chunk.

NeilBrown
