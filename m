From: Alfred Isele <Alfred.Isele@fujitsu-siemens.com>
Subject: Re: raid bug in 2.4.20
Date: Fri, 11 Apr 2003 10:20:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3.0.6.32.20030411102033.00bafcd0@athen>
References: <Pine.LNX.4.44.0304101623300.25209-100000@karma.hagopian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E961D24.BB595F33@SteelEye.com>
To: Paul Clements <Paul.Clements@SteelEye.com>, Rob Hagopian <rob@hagopian.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello!
Sorry, I have no solution but I'm searching too!
I observed this error with kernel 2.4.19-64GB-SMP (Suse).
We use raid1 with 2 mirrors.
Very often when I detach a mirror by
	/mdadm /dev/md0 -f /dev/sda1 -r /dev/sda1
and then reattach it by
	/mdadm /dev/md0 -a /dev/sda1
I too get
	... speed=0K/sec

After rebooting the resynch really starts.
Moreover sometimes after detaching (... -f ... -r ...)
I have either raid1d or mdrecoveryd 
obviously looping uninterruptible on a CPU. 
Program top then shows this:
----------------------------------------------------------------------------
----
  2:08pm  up  4:03,  5 users,  load average: 14.23, 14.55, 14.11
226 processes: 219 sleeping, 7 running, 0 zombie, 0 stopped
CPU0 states:  0.0% user, 100.0% system,  0.0% nice,  0.0% idle
CPU1 states:  8.0% user, 13.1% system,  0.0% nice, 78.3% idle
Mem:  1162020K av,  868428K used,  293592K free,       0K shrd,   84904K buff
Swap:  722808K av,       0K used,  722808K free                  554484K
cached

  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME COMMAND
   20 root      19   0     0    0     0 RW   99.8  0.0 161:14 raid1d
 1408 isele     15   0  1112 1112   768 R     5.8  0.0   8:48 top
----------------------------------------------------------------------------
-----


At 21:40 10.04.03 -0400, Paul Clements wrote:
>Hi,
>
>Rob Hagopian wrote:
> 
>> Personalities : [linear] [raid0] [raid1] [raid5]
>> read_ahead 1024 sectors
>> md7 : active raid1 sdb6[2] sda6[0]
>>       1052160 blocks [2/1] [U_]
>> 
>> md0 : active raid1 sdb1[2] sda1[0]
>>       128384 blocks [2/1] [U_]
>>       [>....................]  recovery =  0.0% (0/128384)
>> finish=3658.9min speed=0K/sec
>
>Have you been able to reproduce this problem with any regularity? Or
>have you tried? I have an idea what *might* be causing this, if you're
>willing to try out a patch...
>
>BTW, the md "BUG" you originally reported is not really a bug -- that
>always happens when you try to raidhotremove an active disk.
>
>--
>Paul
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

