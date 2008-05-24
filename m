From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Proposal: non-striping RAID4
Date: Sat, 24 May 2008 10:21:39 -0400
Message-ID: <48382473.8090808@tmr.com>
References: <BAY130-W418FFF9E3F58536967DDEAE1C60@phx.gbl> <BC2A76AABABF8741A8ADEE62DB1350F80384C383@exchange2.valvesoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BC2A76AABABF8741A8ADEE62DB1350F80384C383@exchange2.valvesoftware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Green <cgreen@valvesoftware.com>
Cc: Tony Germano <tony_germano@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Green wrote:
> I would really like to have this functionality. Honestly, its pretty
> much perfect for the "home server" application (which I have several
> of), where:
>
>    - writes are far less common than reads,
>    - The system goes hours without any reads and days without any
> writes.
>    - single drive read speed is plenty for the applications that are
> sitting on the other side
>    - a lot of the data is too voluminous to backup (media that can just
> be re-ripped or downloaded).
>    - you want some redundancy beyond a single drive copy, but don't want
> to spend a lot of drives on it. The model of "if you lose 1 disk, you
> lose nothing, if you lose 2 disks you lose a portion" is better than the
> raid5 model of losing everything with a double-disk failure.
>    - a common access pattern is to do a long sequential read at a slow
> rate that takes hours to go through a few gigs (playing media).
>  

I think you can do this right now with a touch of cleverness...

Assume you create a raid-1 array, load your data, and call that initialized.

 From cron, daily or weekly, you set one drive of the array 
"write-mostly" and set the spin-down time (hdparm -S) to an hour or so. 
Now reads will go to one drive, the other will spin down, *and*, should 
you do one of those infrequent writes, the idle drive will spin back up 
and write the data (I want a bitmap of course). At the end of the time 
period you clear the write-mostly and spin-down time on the idle drive, 
put them on the other drive, and ideally you wind up with redundancy, 
splitting the disk wear evenly, and using existing capabilities.

Actually you can't quite use existing capabilities, write-mostly can 
only be used at inconvenient times, like build, create, or add, so it's 
not obviously possible to change without at least shutting the array 
down. Perhaps Neil will give us his thoughts on that. However, if you 
don't mind a *really* ugly script, you might be able to mark the active 
drive failed, which would force all i/o to the previously sleeping 
drive, then remove the previously active drive, and add it back in using 
write-mostly. You would do a full sync (I think) but the change would be 
made.

Better to make write-mostly a flag which can be enabled and disabled at 
will. That would be useful when a remote drive is normally operated over 
a fast link and has to drop to a slow backup link. I'm sure other uses 
would be found.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


