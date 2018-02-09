From: Marc MERLIN <marc@merlins.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Fri, 9 Feb 2018 14:36:14 -0800
Message-ID: <20180209223613.GO9565@merlins.org>
References: <20180209202958.6mieeomu5of45rjf@merlins.org> <59144df0-35b7-942f-22c8-754afd0f89c4@uni-konstanz.de> <20180206181416.amo6geclrvc6ylrf@merlins.org> <aedfc1ac-a95f-b20f-2713-87cf412afdf4@uni-konstanz.de> <20180209192928.vliiwkv6q76jf6jp@merlins.org> <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org> <20180209202958.6mieeomu5of45rjf@merlins.org> <5947e803-b1e8-b530-4935-df126f867213@turmel.org> <20180209212252.GN9565@merlins.org> <3345d6f0-80d0-bfaf-9974-a7472d499117@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3345d6f0-80d0-bfaf-9974-a7472d499117@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wol's lists <antlists@youngman.org.uk>
Cc: Phil Turmel <philip@turmel.org>, Kay Diederichs <kay.diederichs@uni-konstanz.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 09, 2018 at 10:07:57PM +0000, Wol's lists wrote:
> On 09/02/18 21:22, Marc MERLIN wrote:
> >Interesting. I figured once a sector went pending once, it would not 
> >actually be re-used and
> >be remapped on the next write. Seems like it didn't happen here.
> 
> Because there's all sorts of reasons a sector can go pending.
> 
> My favourite example is to compare it to DRAM. DRAM needs refreshing 
> every couple of seconds, otherwise it loses its contents and cannot be 
> read, but it's perfectly okay to rewrite and re-use it.
 
You're correct. The density of drives is so high now that writing a block
affects the ones around it.

> Likewise, the magnetism in a drive can decay such that the data is 
> unreadable, but there's nothing actually wrong with the drive. (If the 
> data next door is repeatedly rewritten, the rewrite can "leak" and trash 
> nearby data ...) The decay time for that should be years.

Right. That's why I'm unhappy that it happened within a week of unpacking
the drives and 2 out of 5 had problems already.

> The problem of course is when the problem has a decay time measured in 
> minutes or hours. The rewrite succeeds, so the sector doesn't get 
> remapped, but when you next read it it has died :-(

Speaking of this, I still haven't gotten the drive to actually remap
anything yet.
On that 2nd drive, I'm seeing 7 pending sectors, and can't trigger any error
or remapping on them:
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always -       7

# 1  Short offline       Completed: read failure       90%       519         569442000
# 2  Short offline       Completed: read failure       90%       519         569442000
# 3  Extended offline    Completed: read failure       90%       518         569442000
# 4  Short offline       Completed without error       00%       508         -
# 5  Short offline       Completed without error       00%       484         -
# 6  Short offline       Completed without error       00%       460         -
# 7  Short offline       Completed without error       00%       436         -
# 8  Short offline       Completed: read failure       90%       413         569441985
# 9  Extended offline    Completed: read failure       90%       409         569441990
#10  Extended offline    Completed: read failure       90%       409         569441985
#11  Extended offline    Completed: read failure       90%       409         569441991
#12  Extended offline    Completed: read failure       90%       409         569441985

So, running badblocks over that range should help, right?

But no, I get nothing:
myth:~# badblocks -fsvn -b512 /dev/sdf  569942000 569001000
/dev/sdf is apparently in use by the system; badblocks forced anyway.
Checking for bad blocks in non-destructive read-write mode
From block 569001000 to 569942000
Checking for bad blocks (non-destructive read-write test)
Testing with random pattern: done                                                 
Pass completed, 0 bad blocks found. (0/0/0 errors)

In some way, unless I'm reading the wrong blocks, that would mean the blocks are good again?

But smart still shows 
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       7

and a short offline test immediately shows
# 1  Short offline       Completed: read failure       90%       519         569442000

Clearly, I still have some things to learn.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
