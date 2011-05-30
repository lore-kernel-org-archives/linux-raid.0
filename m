From: Gordon Henderson <gordon@drogon.net>
Subject: Re: filesystem-level tool to validate array
Date: Mon, 30 May 2011 09:20:20 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1105300857540.25119@unicorn.drogon.net>
References: <BANLkTi=9mp0v4kn+3ZZP7CtBxE88Ox3_rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=9mp0v4kn+3ZZP7CtBxE88Ox3_rA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 29 May 2011, Michael Stumpf wrote:

> I'm looking for a filesystem-level tool to perform something similar
> to what badblocks does at the drive level.  I can certainly write it
> on my own (I'd build it as a Perl or Python script), but if someone's
> already invented this..
>
> (The intended purpose is to validate that there are no quirks/bugs in
> the overall fs.)

If you can take the partition offline, then fsck -fC might work, although 
it'll depend on the fileysstem type... And fsck doesn't actually read the 
file blocks (that I'm aware of)

For something crude, you can use find to descend a heirarchy then copy the 
file, or maybe even something like

   cd /top-level/dir/
   fgrep -r "wumpus" .

that'll perform a read of every file - well, mostly as some might be in 
the filesystem cache.

But if you want to make sure every file block belongs to a file, and the 
structure (directory) integrity is there, then fsck is probably the best 
bet...

Another way might be to recursively compute md5 checksums for all files - 
then do it again and compare.. (at a later date?)

You might want to look at something like tripwire to automate this though.

(Obviously won't work if you get the same error at the same place every 
time though!)

One of the burn-in tools I have is a script that writes a file of random 
numbers - md5's it. Then copies this file to n+1, then copies n+1 to n+2, 
then n+2 to n+3 and so on, then md5's the final file. The file-sizes are 
typically double RAM size to negate the effects of cache (same idea as 
bonnie)... However if there's a failure, then it's it's not clear where 
the issue is - memory, PCI bus, SATA cable, disk platter?

Of-course in a RAID array, looking at it from the fileysstem level (or 
even the block level) isn't going to read all platters of all disks - you 
need to use the /sys/block/mdX/md/sync_action mechanism.

Gordon
