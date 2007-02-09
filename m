From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm RAID5 array failure
Date: Fri, 9 Feb 2007 14:26:02 +1100
Message-ID: <17867.59850.998622.932490@notabene.brown>
References: <798742.72217.qm@web55812.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from jahammonds prost on Thursday February 8
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 8, gmitch64@yahoo.com wrote:
> > mdadm -Af /dev/md0 should get it back for you. 
> 
> It did indeed... Thank you.
> 
> > But you really want to find out why it died.

Good!

> 
> Well, it looks like I have a bad section on hde, which got tickled
> as I was copying files onto it... As the rebuild progressed, and hit
> around 6%, it hit the same spot on the disk again, and locked the
> box up solid. I ended up setting speed_limit_min and speed_limit_max
> to 0 so that the rebuild didn't happen, activated my LVM volume
> groups, and mounted the first of the logical volumes. I've just
> copied off all the files on that LV, and tomorrow I'll get the other
> 2 done. I do have a spare drive in the array... any idea why it
> wasn't being activated when hde went offline? 

I would need to look at kernel logs to be sure of what was happening.
If the problem with the drive causes the drive controller to hang
(rather than return an error) then there is not much that the raid
layer can do.

If you do get any kernel logs when the machine hangs, or if you can
get something out with
  alt-sysrq-t
then I suspect the maintainer of the relevant driver would like to
know about it - testing error conditions in drives can be hard with
having the right sort of faulty drive....

NeilBrown
