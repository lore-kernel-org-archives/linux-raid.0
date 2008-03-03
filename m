From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux and SSD and how to decrease io delay : question, please
Date: Mon, 03 Mar 2008 12:31:14 -0500
Message-ID: <47CC35E2.5000205@tmr.com>
References: <794655.87405.qm@web35701.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <794655.87405.qm@web35701.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mariella Petrini <mariellapetrini@yahoo.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mariella Petrini wrote:
> Hi,
>  
>  
> I did run some benchmarks with different values of dirty_expire_centisecs.
>  
> Lowering the value to 1500, 1000, 500  bring the worst values a little 
> lower
> (from 35sec to 31sec and less in number) but it increases the 
> percentage of response queries that are over 1secs. I guess this is 
> because pdflush has to write to IO more often.
>  
> Increasing the value of dirty_expire_centisecs to 6000
> actually it looks better, because it still keeps the same percentage 
> of queries whose response time is over  1 sec
> and lowers the number of queries that have a value over 30 secs.
>  
> Looking at what is happening and the fact that the database server 
> freezes almost any time I/O wait goes over 40%, pdflush starts flushing,
> I think the queries that have a response time over 20 secs (30 
> secs) are really generated
> when pdflush starts commiting and it is possible that if pdflush 
> hasn't  enough threads or the IO system/driver are not fast enough.
>  
I will go back and look at the iostats again, but you simply may be 
maxing out the hardware. That said, the io scheduler can still do a 
reasonable job of allowing reads to run when writes are backlogged, and 
you *might* benefit from more memory to allow better grouping of writes. 
You may find running vmstat at one sec intervals on a freshly booted 
system, then applying load will confirm how memory is being used, and if 
more is likely to help.

If you are maxing out your disks then software isn't going to help much, 
but reads should still get through.
> I have tried to increase the number of threads that pdflush could use 
> (through /etc/sysctl.conf), but I got permission denied.
> Do you know whether there is any way to increase the number of threads 
> that
> pdflush could use ?
>  
I don't know why you can't increase that, but I honestly don't expect it 
to help.
> I will try to compile also the latest kernel and see whether there is 
> any difference.
>  
> Thanks for your help,
>  
>  
> Mariella
>  
>  
>
>
> */Bill Davidsen <davidsen@tmr.com>/* wrote:
>
>     Mariella Petrini wrote:
>>     Hi,
>>      
>>     I did play a little bit with /proc/sys/vm/dirty_* , but that did
>>     not help much.
>>     It did help the use of the noop and deadline io schedulers.
>>      
>     Try lowering dirty_expire_centisecs to 1500, 1000, 500 and test at
>     each point. This will tend to start pushing stuff out sooner.
>     However, you may just be trying to write faster than your disk
>     system can push data to disk, in which case you have some hard
>     choices to make, faster hardware or poor performance.
>>     >Of course you didn't measure the
>>     >disk i/o rates along with this, so it's hard to see what's
>>     happening.
>>      
>>     I did run iostat reports while doing all the queries.
>>     I that you meant or did you mean somthing else ?
>>
>     Did the i/o rates show that you are maxing out your hardware? You
>     might do that again as you drop the expire time,  it may tell you
>     something interesting.
>
>     Keep me posted.
>>     Thanks,
>>      
>>     Mariella
>>
>>     */Bill Davidsen <davidsen@tmr.com>/* wrote:
>>
>>         Mariella Petrini wrote:
>>         > Hi All,
>>         >
>>         > I have been running Linux kernel 2.6.23 with Debian on
>>         >
>>         > a 2 CPUs Dual-Core AMD Opteron(tm) Processor 2218.
>>         > I have been using an SSD drive (MTRON) connected to a
>>         > raid controller (LSI MegaRAID 8704ELP) to contain
>>         > data stored on several databases.
>>         > Each database contains 20,000 files and there are 50
>>         > databases total (1,000,000 files distributed across 50
>>         > directories on the filesystem on the ssd).
>>         >
>>         > The database server uses the databases very "write"
>>         > intensively.
>>         > An approximate percentage could be 20% reads versus
>>         > 80% random writes.
>>         >
>>         > No matter which filesystem type is used (I have tried
>>         > ext3, xfs, jfs, reiserfs) I see every few seconds
>>         > snapshots (the could last in the worst case up to 200
>>         > seconds, depending on the filesystem type)
>>         > where the iowait on the ssd device goes approximately
>>         > over 50% (up to 100%) and
>>         > the database server threads go to wait (get
>>         > suspended).
>>         >
>>         > Is there any Linux kernel parameter or any Linux
>>         > parameter that could be varied that could help to
>>         > decrease the time spent to sync all the data to the
>>         > SSD device ?
>>         >
>>         I may misunderstand the problem, but have you tried tuning the
>>         parameters /proc/sys/vm/dirty_* to help this? It sounds as if
>>         you may be
>>         filling write cache and then flushing. Of course you didn't
>>         measure the
>>         disk i/o rates along with this, so it's hard to see what's
>>         happening.
>>
>>         -- 
>>         Bill Davidsen
>>         "We have more to fear from the bungling of the incompetent
>>         than from
>>         the machinations of the wicked." - from Slashdot
>>
>>
>>     ------------------------------------------------------------------------
>>     Looking for last minute shopping deals? Find them fast with
>>     Yahoo! Search.
>>     <http://us.rd.yahoo.com/evt=51734/*http://tools.search.yahoo.com/newsearch/category.php?category=shopping>
>
>
>
>     --   Bill Davidsen <davidsen@tmr.com>    "Woe unto the statesman who makes war without a reason that will still    be valid when the war is over..." Otto von Bismark    
>      
>
>
> ------------------------------------------------------------------------
> Be a better friend, newshound, and know-it-all with Yahoo! Mobile. Try 
> it now. 
> <http://us.rd.yahoo.com/evt=51733/*http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ%20> 



-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


