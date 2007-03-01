From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: swap on raid
Date: Thu, 1 Mar 2007 17:30:46 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0703011729530.7560@p34.internal.lan>
References: <20070301222739.GA4835@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070301222739.GA4835@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Swap on a redundant RAID is a smart idea, not sure who would tell you 
otherwise.  Depends which disks are faster?  I have a RAID5 which is 2x as 
fast as a RAID1 (both SW raid)-- whichever is faster, do some 
benchmarking.  I would assume RAID10, but I have not benchmarked to 
confirm this.

Justin.

On Thu, 1 Mar 2007, Peter Rabbitson wrote:

> Hi,
>
> I need to use a raid volume for swap, utilizing partitions from 4
> physical drives I have available. From my experience I have three
> options - raid5, raid10 with 2 offset chunks, and two raid 1 volumes
> that are swapon-ed with equal priority. However I have a hard time
> figuring out what to use as I am not really sure how can I detect the
> usage patterns of swap, left alone benchmark it. Has anyone done
> anything like this, or is there information on what kind of reads/writes
> the kernel performs when paging in and out?
>
> Before you answer my question - yes, I am painfully aware of the
> paradigm "swap on raid is bad", and I know there are other ways to solve
> it, but my situation requires me to have swap. Several weeks ago a drive
> failed and took a full partition away bringing the system to its knees
> and causied massive data corruption. I am also aware that I can use a
> file that will reside alongside my other data, but fragmentation makes
> this approach inefficient. So I am looking into placing the swap
> directly on a raid voulme.
>
>
> Thanks
>
> Peter
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
