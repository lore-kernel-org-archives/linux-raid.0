From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID10 - migrating disks without failing/degrading array?
Date: Tue, 13 Oct 2009 18:20:36 -0400
Message-ID: <4AD4FD34.4090402@tmr.com>
References: <72dbd3150910021122r474c43f6m2f1d953b5af9c3e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150910021122r474c43f6m2f1d953b5af9c3e0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Rees wrote:
> I've got an 8 disk RAID10 array (near2 layout) where I am moving data
> off some older disks onto newer disks.
>
> Currently what I'm doing is adding the newer disks as spares and then
> failing/removing the older disks one at a time.
>
> This works fine, but leaves me with an hour or so of running the array
> degraded while the spare drive syncs up which leaves me open for
> data-loss during this time period.
>
> It seems like I should be able to add a drive as a directly
> replacement for one of the drives I'm pulling out (so I temporarily
> end up with 3-copies of that chunk instead of 2) until I pull
> fail/remove the older disk.  If I was using RAID0 striped over RAID1
> mirrors, for example, I know this is possible.
>
> Is this possible to do with RAID10?
>   

In a slow, ugly, complex way, as someone described in another response. 
It involves using raid-1, and I suggest checking the write-mostly option 
as well, and involves some short time without the 2nd copy configured 
(and using check may not test everything on raid-10). Use a bitmap if 
you're not already.

There is at least one other current thread regarding the need for a 
"clone member" feature in md, but unless someone with time and skills 
also has the problem, I doubt it's going to get added soon.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

