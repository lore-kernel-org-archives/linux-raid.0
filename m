From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: a minor query - please help
Date: Thu, 23 Dec 2004 03:19:59 -0500
Message-ID: <200412230820.iBN8K5914570@www.watkins-home.com>
References: <8f8a519404122223042106571b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8f8a519404122223042106571b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Srinivasa S' <srinivasa.s@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't understand your question.  Please elaborate.

This may help.  It was sent by Mark Hahn, Feb 2004.  I snipped the stuff not
related to you.

---snip---
> [hahn@hahn hahn]$ cat /proc/sys/vm/bdflush
> 30      500     0       0       500     3000    60      20      0
>
>  Value      Meaning
>  nfract     Percentage of buffer cache dirty to activate bdflush
>  ndirty     Maximum number of dirty blocks to  write out per wake-cycle
>  dummy      Unused
>  dummy      Unused
>  interval   jiffies delay between kupdate flushes
>  age_buffer Time for normal buffer to age before we flush it
>  nfract_sync Percentage of buffer cache dirty to activate bdflush
>  synchronously
>  nfract_stop_bdflush Percetange of buffer cache dirty to stop bdflush
>  dummy      Unused
>
>
> in theory, this means:
> - wake up bdflush when 30% of buffers are dirty.
> - write up to 500 blocks per wakeup.
> - 5 seconds between wakeups.
> - let a buffer age for 30 seconds before flushing it.
> - if 60% of buffers are dirty, start throttling dirtiers.
> - stop bdflush when < 20% of buffers are dirty.
---snip---

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Srinivasa S
Sent: Thursday, December 23, 2004 2:05 AM
To: linux-raid@vger.kernel.org
Subject: a minor query - please help

I have configured a 3 disk raid5 on my linux system (fedora core 1
running 2.6.5-1.358 OS). I am basically trying to alter the RMW method
a bit, which I think might improve performance.

Multiple writes come to a stripe at the same time.
Here is the output of the debug stmts I've put in raid5.c code:
-----

Dec 23 11:16:01 raider kernel: check 2: state 0x4 read 00000000 write
2456be00 written 00000000
Dec 23 11:16:02 raider kernel: check 1: state 0x1 read 00000000 write
00000000 written 00000000
Dec 23 11:16:02 raider kernel: check 0: state 0x4 read 00000000 write
41fc8440 written 00000000
Dec 23 11:16:02 raider kernel: locked=0 uptodate=1 to_read=0
to_write=2 failed=0 failed_num=0

-----

Is there any method by which I can make only one write go through at a time?
I'd be glad if any of you could reply to this... 

Regards, 
Srinivasa S
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

