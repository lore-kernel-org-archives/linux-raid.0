From: Keld Simonsen <keld@keldix.com>
Subject: Re: Map Block number from hdd to md
Date: Tue, 16 Feb 2010 06:02:52 +0200
Message-ID: <20100216040252.GA28729@rap.rap.dk>
References: <7362c3826262551b46e9b0bb1a777633@rw23.de> <20100216122014.18696241@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100216122014.18696241@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Michael <michael@rw23.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 16, 2010 at 12:20:14PM +1100, Neil Brown wrote:
> On Fri, 12 Feb 2010 01:24:30 +0100
> Michael <michael@rw23.de> wrote:
> 
> > Hello,
> > 
> > i've came into the situation that one of my 4 mdadm raid5 drives failed.
> > not realy faild, but not detectet at system startup. so i started resync,
> > and one of the remaining hdd's had a bad block and faild. so 2 drives
> > offline and raid not functional anymore.

I just had a similar situation. A raid5 with 4 disks had block errors on
one disk and was failed. I checked it and it seemed without errors, and
I wanted to re-add it. But then the other (Samsung 1 TB) disk erred in
the resync process due to this disk also having bad blocks.

I managed to get the raid5 running again forcing it to be run with only
3 disks (one with bad blocks), and checking the fs with xfs_repair I found out that I was
lucky that the fs integrity (directories, inodes etc) was undmaged.
So I could run the array. 

But I cannot resync it as resyncing almost immediately runs into a
resync of the bad blocks on the Samsung disk. It would have been nice if
there was some sort of bad blocks management with Linux MD, but I
understand that this is in the works.

I also understand that ext3 badblock management would not have saved me
here, true? 

MD  resyncing is in an underlying level and does not take care of ext3
badblock handling, I think.



> > 1st question:
> > i have read that it is possible with debugfs to locate which file belongs
> > to the bad block on a ext file system. good thing, so i can check if i have
> > *lost* an inportant or an unimportant file... or just free space.
> > problen with this is, that i cant map the known bad block from, lets say,
> > sda to my raid array md0.
> > 
> > is there any method to find that bad block in context of the raid block
> > device? reading all files is not a good option on large raidsets.
> > level 5, 64k chunk, algorithm 2
> 
> It isn't that hard.  The code is in drivers/md/raid5.c in the kernel.....
> 
> Rather than trying to describe in general, give me the block number, device,
> and "mdadm --examine" of that device, and I'll tell you how I get the answer.

Furthermore I would have liked to find out which files were affected.
Is there a way to do this with XFS? debugfs is for ext3.
I was not able to find a program mapping a sector to an inode in XFS.
And then there is the need to map the physical bad block number on the
device to the actual block in the (damaged) raid5. How to do that?
I think this is almost the same question as Michael's (with an XFS
variation).

Best regards
Keld
