From: Marc MERLIN <marc@merlins.org>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks -nsv did
Date: Mon, 6 Jun 2016 15:44:01 -0700
Message-ID: <20160606224401.GA6672@merlins.org>
References: <20160606174113.GI12382@merlins.org> <5755CA9F.6090807@prgmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5755CA9F.6090807@prgmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sarah Newman <srn@prgmr.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jun 06, 2016 at 12:10:23PM -0700, Sarah Newman wrote:
> https://www.kernel.org/doc/Documentation/md.txt shows for sync_action
> 
>        check         - A full check of redundancy was requested and is
>                        happening.  This reads all blocks and checks
>                        them. A repair may also happen for some raid
>                        levels.
>        repair        - A full check and repair is happening.  This is
>                        similar to 'resync', but was requested by the
>                        user, and the write-intent bitmap is NOT used to
> 		       optimise the process.
> 
> I think you wanted 'repair' not 'check'.

From what I understand, the only difference between the 2 is that repair
does not use the write-intent bitmap, but both will repair an error if
found.
https://www.thomas-krenn.com/en/wiki/Mdadm_checkarray#Check_vs._Repair

Or are you saying that check after getting a read error from one drive,
would not rewrite the bad block on that drive? I thought it did...

Either way, it seems that neither would have worked because while those
blocks were marked as "need to be reallocated" by the drive, I think the
kernel was actually able to read them without problem, so the md layer never
saw anything and therefore never did anything either.

Whereas badblocks forced an unconditional rewrite of all blocks, and forced
the drive to re-allocate those "weak" blocks, even though it was able to
read them.

Does that sound about right?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
