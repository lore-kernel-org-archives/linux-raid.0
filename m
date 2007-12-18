From: Neil Brown <neilb@suse.de>
Subject: Re: Raid over 48 disks
Date: Wed, 19 Dec 2007 07:28:20 +1100
Message-ID: <18280.11620.381726.737353@notabene.brown>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Norman Elton on Tuesday December 18
Sender: linux-raid-owner@vger.kernel.org
To: Norman Elton <normelton@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 18, normelton@gmail.com wrote:
> We're investigating the possibility of running Linux (RHEL) on top of  
> Sun's X4500 Thumper box:
> 
> http://www.sun.com/servers/x64/x4500/
> 
> Basically, it's a server with 48 SATA hard drives. No hardware RAID.  
> It's designed for Sun's ZFS filesystem.
> 
> So... we're curious how Linux will handle such a beast. Has anyone run  
> MD software RAID over so many disks? Then piled LVM/ext3 on top of  
> that? Any suggestions?
> 
> Are we crazy to think this is even possible?

Certainly possible.
The default metadata is limited to 28 devices, but with
    --metadata=1

you can easily use all 48 drives or more in the one array.  I'm not
sure if you would want to though.

If you just wanted an enormous scratch space and were happy to lose
all your data on a drive failure, then you could make a raid0 across
all the drives which should work perfectly and give you lots of
space.  But that probably isn't what you want.

I wouldn't create a raid5 or raid6 on all 48 devices.
RAID5 only survives a single device failure and with that many
devices, the chance of a second failure before you recover becomes
appreciable.

RAID6 would be much more reliable, but probably much slower.  RAID6
always needs to read or write every block in a stripe (i.e. it always
uses reconstruct-write to generate the P and Q blocks,  It never does
a read-modify-write like raid5 does).  This means that every write
touches every device so you have less possibility for parallelism
among your many drives.
It might be instructive to try it out though.

RAID10 would be a good option if you are happy wit 24 drives worth of
space.  I would probably choose a largish chunk size (256K) and use
the 'offset' layout.

Alternately, 8 6drive RAID5s or 6 8raid RAID6s, and use RAID0 to
combine them together.  This would give you adequate reliability and
performance and still a large amount of storage space.

Have fun!!!

NeilBrown

