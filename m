From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: Adding a new mirror disk to RAID1 configuration
Date: Fri, 9 Jul 2004 23:04:24 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407092304.24431.maarten@ultratux.net>
References: <200407091929.i69JTj320289@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407091929.i69JTj320289@watkins-home.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 09 July 2004 21:29, Guy wrote:
> I agree with you about tapes!  For 5+ years now I have been expecting
> someone to build a jukebox that uses disk drives, not tapes.  Today you can
> buy jukesboxes that store tapes, optical media, cds, dvds, ...  But not
> hard disks.  And like you said, a hard disk cost less than a tape with the
> same capacity.  I also think the shelf life of a hard disk is longer than a
> tape. And, seek time!  Hard disks are so much faster!

(...Not to disagree with myself, but)
Well there are drawbacks of course, but that is mostly relevant to businesses 
anyway.  Like that it is harder to insert a disk than a tape, and that disks 
cannot stand rough treatment much.  There is also the problem of the head of 
a disk sticking to the platter when left really long without use. The keyword 
here is "less [ moving parts | intelligence ], thus less to break".  That is 
true in a business setting, sure.  Virtually no amount of DLT robots would 
match the cost of a lost businessday combined with several consultants 
scrambling to get the data back in place (for fortune-500 companies).
But then again, tape also needs to be re-winded every now and again so to 
avoid it sticking together and / or to decrease the effect of adjacent layers 
messing with each others (there is a name for that effect but I forgot) so 
there is not (much) difference to disks in that regard.

Also of note is that the high speed of disks can be a drawback instead of an 
asset when it comes to backups.  A virus or a rogue (or stupid...) user can 
render a harddisks' data useless in minutes, whereas erasing a tape still 
takes hours (except with a bulk eraser but virii cannot do that).  This 
leaves you much more time to react to attacks and other bad stuff. 

But for most home users, these issues are largely irrelevant as the cost of 
rebuilding  / reacquiring the files (multiplied by the chances of something 
bad happening) is lower than what the backup thereof would cost.
Add to that the fact that for most home users the time that a backup needs to 
stay reliable is less important than for businesses (who still highly values 
his BBS collection of 320x240-pix gifs nowadays ??) 
So, disks are a reasonable alternative.

They do sell disk "jukeboxes" though, albeit not by that name.  You can buy 
NAS appliances with scsi hotswap units, that's as close to a jukebox as 
you're gonna get.  The pricetag -again- was prohibitive up till now, but we 
will most certainly see that change in 1-2 years when SATA will be default. 

> Back to RAID1...
> I would not want my array to be in a constant bad state.  If I wanted to be
> able to clone drives as you do, I would configure for 3 drives and have 3
> drives so the array was in a good state.  The 3rd drive would be the clone.
> Pull it when needed, then replace it.

Not being a coder, but what would be the possible bad consequences of a 
continuously degraded array ??  I can't imagine a degraded raid 5 array being 
any worse than a raid 0 array with the same amount of disks (leaving the 
issue of parity-calculations alone for now). It's not that there exists a 
"best-before" date on raid arrays, degraded or not. A raid array in degraded 
mode will happily survive several centuries IF the remaining disks do not 
fail.    And mdadm will (IIRC) still notify you whenever the array get 'more 
degraded' than you "designed" it to be. (Right ?)

> Or, if I ever upgrade from kernel 2.4, I would use
> mdadm --grow /dev/md0 --raid-disks 3
> Add the drive to clone to, then back to normal.
> mdadm --grow /dev/md0 --raid-disks 2

Sure, but that functionality didn't exist when I first did this. And anyway, I 
have great respect and confidence in Neil's code, but messing with the 
topology of an already built array is probably inherently more dangerous than 
just relying on the time-honoured sync and resync stages of degrading and 
(re-)filling arrays.  
But like I said, what do I know, I'm no coder nor expert on this. 

> (Thanks Neil!)
> Oops, not sure you can decrease the number!
>
> Feature request!
> Someone add a shrink option.
> mdadm --shrink /dev/md0 --raid-disks 2

I'd wager that Neil would agree with me in saying "What does it hurt to have 
too many devices defined ?" Those empty slots don't hurt nobody, except 
(maybe) a tiny little computing overhead... Overkill never killed anybody ;-)

> Or does --grow allow you to decrease the number?
> The name would imply no.

Well, ancient raidstop WAS a symlink to raidstart, so... you never know  ;-)

cheers,
Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

