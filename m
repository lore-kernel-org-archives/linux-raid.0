From: Maarten van den Berg <maarten@ultratux.net>
Subject: Re: Adding a new mirror disk to RAID1 configuration
Date: Sat, 10 Jul 2004 13:49:03 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407101349.04419.maarten@ultratux.net>
References: <Pine.LNX.4.44.0407091945330.20336-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0407091945330.20336-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 10 July 2004 02:03, Mark Hahn wrote:


> > here is "less [ moving parts | intelligence ], thus less to break".  That
> > is true in a business setting, sure.  Virtually no amount of DLT robots
> > would match the cost of a lost businessday combined with several
> > consultants scrambling to get the data back in place (for fortune-500
> > companies).
>
> critical data must be hot-replicated.

...in addition to, yes. But that same critical data must be backed up 
somewhere far away, safe, too.  And that is not hot-replicateable.  
Any stuff that is hot-replicated WILL suffer the same fate as the original 
stuff in case of a user thinko, virus or intrusion.  Hot replication guards 
against media failure<period>  It does not guard against anything else. 

> > asset when it comes to backups.  A virus or a rogue (or stupid...) user
> > can render a harddisks' data useless in minutes, whereas erasing a tape
> > still takes hours (except with a bulk eraser but virii cannot do that). 
> > This leaves you much more time to react to attacks and other bad stuff.
>
> ah, a great new security idea: slow down all IO!  seriously, real data
> management means tracking versions, not just slamming the latest version
> over top of last night's.

Laugh all you want but I've seen it happen all the time. The CEO starts 
deleting a bunch of stuff and realizes his error too late. Thanks for tape 
backups, because even with a fifty-way raid disk mirror set that data would 
be gone.  The fact that tapemedia are offline seriously increases the 
security thereof. The same goes for CD / DVD media. If it's not online, it's 
not eraseable.  In the case of a tape robot, it is online (more or less) but 
it will take a week erasing all. Not so with harddisks.  Are you still saying 
you do not see any advantages in that slow speed, security-wise ???

> > Not being a coder, but what would be the possible bad consequences of a
> > continuously degraded array ??
>
> some reads require you to run the block-parity algorithm to reconstruct
> the data.  some writes, too.  the worst is that your data is now
> vulnerable.

Please read back further in a thread before you start contributing without 
knowing what it was about..  The issue was about raid 1, and whether it was 
bad to have missing drives as_a_matter_of_fact. To be totally clear about 
this once and for all: This is the question we're talking about:  
A RAID1 set with four disks defined, two missing
OR 
A RAID1 set with two disks defined, none missing

> > I can't imagine a degraded raid 5 array being
> > any worse than a raid 0 array with the same amount of disks (leaving the
> > issue of parity-calculations alone for now).
>
> you can't ignore the parity, since with a disk gone, some of your data
> has to be inferred using parity.

As I said above, you are missing the point here.  And I left out the parity 
just because it bears no relevance at all to the question, which is stated 
above.  Or to make it even clearer yet: What is better, a degraded two-disk 
raid1 or a single drive ?

> > It's not that there exists a
> > "best-before" date on raid arrays, degraded or not.
>
> it's purely a risk-assessment question.  if you build an 8+1 raid5,
> and lose one disk, then the next disk failure will kill your data.
> the liklihood of one of the 8 remaining disks failing is 8x the liklihood
> of a single disk failing (probably higher, since the initial failure was
> probably not completely independent.)

PLease read back.  You're confusing this with another thread perhaps.
I'll repeat:  I stated that you can build a raid 1 array consisting of 4 
drives; two online, and two missing.  So, it IS degraded, but it has two 
drives, which is exactly identical to a traditional raid-1 two-disk setup.
Hence, no data is at risk any more than in the second case. 

Now in this special scenario, we were just wondering if the state of being 
degraded held any drawbacks. Note again that it is the EXACT same physical 
layout: we have two drives and they are a mirror of each other. 

Maarten

