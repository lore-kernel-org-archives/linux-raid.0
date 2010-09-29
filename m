From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid5+hotspare: request for recommended procedure
Date: Wed, 29 Sep 2010 16:01:39 +0400
Message-ID: <4CA32AA3.3090602@msgid.tls.msk.ru>
References: <4CA300EB.1070909@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CA300EB.1070909@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

29.09.2010 13:03, Stefan G. Weichinger wrote:
> 
> Greets, raid-users,
> 
> I would like to ask for hints on how to proceed.
> 
> I have a customers server ~500kms away ... running 2 raid5-arrays w/
> hotspare:
> 
[]
> sdb shows errors:
> 
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
>       -       13
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
> Offline      -       13

I'd run the repair procedure for the raids first.  The procedure
reads all blocks from all raid drives, comparing them while it
goes.  If any block is unreadable, it tries to re-write it based
on the data reconstructed from other raid disks.  This way, your
sdb may become good again, after remapping the 13 bad sectors
(which is very small amount for nowadays high-dencity drives).

> The customer would now take the server with him and bring it to a fellow
> technician who could take out sdb, clone it to a new hdd and re-insert it.
> 
> This would be plan A.
> 
> Plan B would be that I mark sdb failed now and let the raids rebuild. I
> fear that a second hdd might fail when doing this.

Yes, at least run smart selftests on the remaining drives first,
to ensure they wont find badblocks.

> All Seagate-drives:
> 
> sda, sdb: ST3250310NS
> sdc, sdd: ST3250621NS
> 
> I also ran a "echo check > /sys/block/mdX/md/sync_action" because this
> had helped to remove those errors at another server, unfortunately it
> did not help here.

It should be repair, not check - check merely reads stuff, repair tries
to fix it.

> Could you please advise what the better and safer alternative would be?

There is - unfortunately - no good procedure for this case, even if
it is the most frequent usage case with failed drives (i think).
What should be needed is to let raid arrays to pick spare drive,
copy data to it from the drive being replaced (or, failing that,
from other raid drives), thus making a sort of raid1 (mirror)
between the spare drive and the one being replaced, and when the
mirror is finished, switch the roles, so you can remove the "new
spare".  But there's no such code, and any attempt to do that
manually does not work as good as the scenario I outlined.

Note you can't just copy all good data from failing to spare
outside the raid5 array: the bad blocks will be unreadable, and
you'll have to skip them somehow, but when you add the replacement
back to the array you can't tell raid code which blocks were
skipped.  So your array will be corrupt most likely, -- the only
way to get the original data is to reconstruct the unreadable
blocks from other raid disks, which is difficult to do manually.
That's actually what I said above - any attempt to recover it
outside the original arrays is worse than the ideal procedure
which does not exist.

So I'd do this:

 1) run repair.  If it fixes everything, you may as well just
  keep the "failing" drive, since I'm not really sure it is
  really bad.
 2) if you still want to replace it, after running repair you'll
  know your other drives work fine, so you can do either replace,
  or copy+replace - the latter is if the "failing" drive will be
  repaired in the first step.  Sure thing you've more luck
  (as in: two attempts instead of just one) attempting  to clone
  the "failing" drive - while your array is stopped; if that does
  not work, use the replace way.

Just imho :)

/mjt
