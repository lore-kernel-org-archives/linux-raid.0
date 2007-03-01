From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: swap on raid
Date: Thu, 01 Mar 2007 18:24:42 -0500
Message-ID: <45E760BA.3090905@tmr.com>
References: <20070301222739.GA4835@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070301222739.GA4835@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
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
I did some benchmarking, using mem= to force swap. It seems that RAID10 
is faster, has nice even disk utilization, etc, etc. The downside is 
that many recovery CDs do not know about RAID10 and can't handle running 
swap there. Test before you decide. Two fast and two slow can be done 
with RAID0 over RAID1 pairs, RAID1 one fast and one slow and mark the 
slow one "write-mostly" to reduce use. RAID1 on two active with the 
other two as hot spares is viable as well.

In other words, you can do it, tell us the size and speed of the 
partitions and you will get a bunch of ideas matched to your hardware.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

