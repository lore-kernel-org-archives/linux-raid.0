From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH] md: new bitmap sysfs interface
Date: Wed, 26 Jul 2006 22:27:23 -0400
Message-ID: <44C8248B.7010501@steeleye.com>
References: <44C5BA6F.3010404@steeleye.com> <170fa0d20607261430n3e9d3962xeef50669ce0d1996@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20607261430n3e9d3962xeef50669ce0d1996@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Mike Snitzer wrote:

> I tracked down the thread you referenced and these posts (by you)
> seems to summarize things well:
> http://marc.theaimsgroup.com/?l=linux-raid&m=111116563016418&w=2
> http://marc.theaimsgroup.com/?l=linux-raid&m=111117515400864&w=2
> 
> But for clarity's sake, could you elaborate on the negative
> implications of not merging the bitmaps on the secondary server?  Will
> the previous primary's dirty blocks get dropped on the floor because
> the secondary (now the primary) doesn't have awareness of the previous
> primary's dirty blocks once it activates the raid1?

Right. At the time of the failover, there were (probably) blocks that 
were out of sync between the primary and secondary. Now, after you've 
failed over to the secondary, you've got to overwrite those blocks with 
data from the secondary in order to make the primary disk consistent 
again. This requires that either you do a full resync from secondary to 
primary (if you don't know what differs), or you merge the two bitmaps 
and resync just that data.

> Also, what is the interface one should use to collect dirty bits from
> the primary's bitmap?

Whatever you'd like. scp the bitmap file over or collect the ranges into 
a file and scp that over, or something similar.

> This bitmap merge can't happen until the primary's dirty bits can be
> collected right?  Waiting for the failed server to come back to

Right. So, when the primary fails, you start the array on the secondary 
with a _clean_ bitmap, and just its local disk component. Now, whatever 
gets written while the primary is down gets put into the bitmap on the 
secondary. When the primary comes back up, you take the dirty bits from 
it and add them into the secondary's bitmap. Then, you insert the 
primary's disk (via nbd or similar) back into the array, and begin a 
resync.

That's the whole reason for this interface. We have to modify the bitmap 
while the array is active (modifying the bitmap while the array is down 
is trivial, and certainly doesn't require sysfs :).

> harvest the dirty bits it has seems wrong (why failover at all?); so I
> must be missing something.

We fail over immediately. We wait until later to combine the bitmaps and 
resync the data.

Hope that helps.

--
Paul
