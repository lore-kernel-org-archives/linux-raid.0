From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers
 [xfs]
Date: Thu, 11 Dec 2008 04:18:09 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812110416550.14590@p34.internal.lan>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan> <49405CD5.4070704@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49405CD5.4070704@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Wed, 10 Dec 2008, Bill Davidsen wrote:

> Justin Piszcz wrote:
>> Someone should write a document with XFS and barrier support, if I recall,
>> in the past, they never worked right on raid1 or raid5 devices, but it
>> appears now they they work on RAID1, which slows down performance ~12 
>> times!!
>> 
> I would expect you, as an experienced tester, to have done this measurement 
> more rigorously!
> I don't think it means much if this is what you did.
>
>> l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar 0.15user 1.54system 
>> 0:13.18elapsed 12%CPU (0avgtext+0avgdata 0maxresident)k
>> 0inputs+0outputs (0major+325minor)pagefaults 0swaps
>> l1:~#
>> 
>> l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar
>> 0.14user 1.66system 2:39.68elapsed 1%CPU (0avgtext+0avgdata 0maxresident)k
>> 0inputs+0outputs (0major+324minor)pagefaults 0swaps
>> l1:~#
>> 
> Before doing any disk test you need to start by dropping cache, to be sure 
> the appropriate reproducible things happen. And in doing a timing test, you 
> need to end with a sync for the same reason.
>
> So:
> echo 1 >/proc/sys/vm/drop_caches
> time bash -c "YOUR TEST; sync"
>
> This will give you a fair shot at being able to reproduce the results, done 
> on an otherwise unloaded system.
>
> -- 
> Bill Davidsen <davidsen@tmr.com>
> "Woe unto the statesman who makes war without a reason that will still
> be valid when the war is over..." Otto von Bismark 
>

Roughly the same for non-barriers:
# bash -c '/usr/bin/time tar xf linux-2.6.27.7.tar' 
0.15user 1.51system 0:12.95elapsed 12%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (4major+320minor)pagefaults 0swaps

For barriers I cannot test that right now but it most likely will be around the
same as well.

Justin.

