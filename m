From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks -nsv
 did
Date: Tue, 7 Jun 2016 10:14:52 -0400
Message-ID: <5756D6DC.5090807@turmel.org>
References: <20160606174113.GI12382@merlins.org>
 <20160607135731.GA12550@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160607135731.GA12550@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Marc MERLIN <marc@merlins.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/07/2016 09:57 AM, Andreas Klauer wrote:
> On Mon, Jun 06, 2016 at 10:41:13AM -0700, Marc MERLIN wrote:
>> Howdy, I have a raid 5 where one drive reported this:
>> 197 Current_Pending_Sector  0x0032   200   199   000    Old_age   Always -       29
> 
> RAID survival depends on healthy drives. This one does not look healthy. 
> If the data on your RAID is important, I'd replace this drive. Getting 
> this count back down to zero doesn't make it any more trustworthy.

That's excessively paranoid.  You missed:

>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0

In other words, the totally normal accumulation of weak spots on his
disk aren't being cleaned up by overwriting as expected from raid
scrubbing.  The vast majority of such flaws are successfully overwritten
and are not a problem.  When they are overwritten and the drive firmware
decides to reallocate, then you can start worrying.  I replace drives
when *reallocations* hit double digits, as my experience says they go to
hell quickly between 10 and 100.

FWIW, all of my troubles with drives were consumer-grade, mostly w/
scterc support, @ > 35k hours.  I'll report to the list when my first
big batch of WD reds starts to die.

