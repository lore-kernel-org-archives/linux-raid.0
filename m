From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Adding a new mirror disk to RAID1 configuration
Date: Fri, 9 Jul 2004 20:03:29 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0407091945330.20336-100000@coffee.psychology.mcmaster.ca>
References: <200407092304.24431.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407092304.24431.maarten@ultratux.net>
To: maarten van den Berg <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> anyway.  Like that it is harder to insert a disk than a tape, and that disks 
> cannot stand rough treatment much.  There is also the problem of the head of 

whereas tapes lose data if you let their ambient get warm or humid;
have you ever let a tape sit for 5 years, and tried to read it?
I certainly wouldn't fee sanguine about trying that.  not to mention
the fact that tape drives are incredibly finicky/flakey/rare.

> a disk sticking to the platter when left really long without use. The keyword 

not at all clear how much of a threat this is.  obviously, there have 
been models with design problems in the past, but I don't believe 
this is a general property of disks.  after all, disks sit on vendor 
shelves for significant periods of time.

> here is "less [ moving parts | intelligence ], thus less to break".  That is 
> true in a business setting, sure.  Virtually no amount of DLT robots would 
> match the cost of a lost businessday combined with several consultants 
> scrambling to get the data back in place (for fortune-500 companies).

critical data must be hot-replicated.  

> asset when it comes to backups.  A virus or a rogue (or stupid...) user can 
> render a harddisks' data useless in minutes, whereas erasing a tape still 
> takes hours (except with a bulk eraser but virii cannot do that).  This 
> leaves you much more time to react to attacks and other bad stuff. 

ah, a great new security idea: slow down all IO!  seriously, real data
management means tracking versions, not just slamming the latest version
over top of last night's.

> Not being a coder, but what would be the possible bad consequences of a 
> continuously degraded array ??

some reads require you to run the block-parity algorithm to reconstruct
the data.  some writes, too.  the worst is that your data is now vulnerable.

> I can't imagine a degraded raid 5 array being 
> any worse than a raid 0 array with the same amount of disks (leaving the 
> issue of parity-calculations alone for now).

you can't ignore the parity, since with a disk gone, some of your data
has to be inferred using parity.

> It's not that there exists a 
> "best-before" date on raid arrays, degraded or not.

it's purely a risk-assessment question.  if you build an 8+1 raid5,
and lose one disk, then the next disk failure will kill your data.
the liklihood of one of the 8 remaining disks failing is 8x the liklihood
of a single disk failing (probably higher, since the initial failure was
probably not completely independent.)

the main issue is that your liklihood of losing data takes a steep dive
when you're in degraded mode.  you were smugly robust, and now are holding
your breath, vulnerable...

