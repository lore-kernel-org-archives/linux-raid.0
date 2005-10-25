From: Bill Davidsen <tmrbill@tmr.com>
Subject: Re: split RAID1 during backups?
Date: Tue, 25 Oct 2005 16:05:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0510251550250.28299-100000@firewall2.tmr.com>
References: <E1EUFcV-0005s3-00@toko.jab.org>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EUFcV-0005s3-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 24 Oct 2005, Jeff Breidenbach wrote:

> 
> Ok... thanks everyone!
> 
> David, you said you are worried about failure scenarios
> involved with RAID splitting. Could you please elaborate?
> My biggest concern is I'm going to accidentally trigger
> a rebuild no matter what I try but maybe you have something
> more serious in mind.
> 
> Brad, your suggestion about kernel 2.6.13 and intent logging and
> having mdadm pull a disk sounds like a winner. I'm going to to try it
> if the software looks mature enough. Should I be scared?
> 
> Dean, the comment about "write-mostly" is confusing to me.  Let's say
> I somehow marked one of the component drives write-mostly to quiet it
> down. How do I get at it? Linux will not let me mount the component
> partition if md0 is also mounted. Do you think "write-mostly" or
> "write-behind" are likely enough to be magic bullets that I should
> learn all about them?
> 
> Bill, thanks for the suggestion to use nbd instead of netcat.  Netcat
> is solid software and very fast, but does feel a little like duct
> tape. You also suggested putting a third drive (local or nbd remote)
> temporarily in the RAID1. What does that buy versus the current
> practice of using dd_rescue to copy the data off md0? I'm not
> imagining any I/O savings over the current approach.

As a paranoid admin, you (a) reduce read-only time, (b) never have an 
unmirrored data running, and (c) it does let you send from an unused drive 
(or you can get a real hot swap bay and put the mirrored drive in the 
safe).

I have one other thought, if you want to just stream this to another drive 
and can stand long r/o mounts (or play with intent stuff, carefully), that 
is to:
 open a socket to something on the other machine which is going to write a 
single BIG data file, or to a partition of the same size.

 open the partition as a file (open /dev/md0)

 use the sendfile() system call to blast the "file" to the socket without 
using user memory.

Based on my vast experience with one test program, this should work ;-) It 
will be limited by how fast you can write it at the other end, I suspect.

====

I still think you should be able to do incrementals. If that's Reiser3 
you're using, it may not be performing as well as ext3 with hashing would, 
but I lack the time to test that properly.

> 
> John, I'm using 4KB blocks in reiserfs with tail packing. All sorts of
> other details are in the dmesg output [1]. I agree seeks are a major
> bottleneck, and I like your suggestion about putting extra spindles
> in. Master-slave won't work because the data is continuously changing.
> I'm not going to argue about the optimality of millions of tiny files
> (go talk to Hans Reiser about that one!) but I definitely don't foresee
> major application redesign any time soon.
> 
> Most importantly, thanks for the encouragement. So far it sounds like
> there might be some ninja magic required, but I'm becoming
> increasingly optimistic that it will be - somehow - possible manage
> disk contention in order to dramatically raise backup speeds.
> 
> Cheers,
> Jeff
> 
> [1] http://www.jab.org/dmesg
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
Doing interesting things with little computers since 1979

