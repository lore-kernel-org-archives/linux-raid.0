From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: RAID1 recovery fails with 2.6 kernel
Date: 22 Oct 2003 12:43:11 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1066844591.1260.31.camel@star2>
References: <7da.3f929f6e.d36f3@altium.nl>
	 <16275.32127.862408.701013@notabene.cse.unsw.edu.au>
	 <297d.3f93a033.85d8f@altium.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <297d.3f93a033.85d8f@altium.nl>
To: Dick Streefland <dick.streefland@altium.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2003-10-20 at 03:43, Dick Streefland wrote:
> Neil Brown <neilb@cse.unsw.edu.au> wrote:
> | Thanks for providing a script...
> | It works fine for me (2.6.0-test8).
> | 
> | I don't suppose there is anything in the kernel logs about write
> | errors on loop2 ???
> 
> No, there was nothing unusual in the log files. I have no access to
> the test machine at the moment, but there is a message when the
> recovery starts, and a few seconds later the message "sync done".
> 
> | Does it fail consistently for you, or only occasionally?
> 
> It fails every time. This test was on an dual PIII 450 system, but it
> also fails on a VIA C6 system with the 2.6.0-test5 kernel. Both
> kernels are compiled without CONFIG_PREEMPT, because I had other
> problems that might be related to this option:
> 
>   http://www.spinics.net/lists/raid/msg03507.html
> 
> Could this be related to CONFIG_DM_IOCTL_V4? I was not sure about this
> option, and have not enabled it. Otherwise, I think it is time to put
> in some printk's. Do you have suggestions where to start looking?

I have been experiencing the same problem on my test machine.  I found
out that the resync terminated early because of MD_RECOVERY_ER R bit set
by raid1's sync_write_request().  I don't understand why it fails the
sync when all the writes already completed successfully and quickly.  If
there is a need to check for "nowhere to write this to" as in 2.4.x
kernel, I think we need a different check.

The following patch for 2.6.0-test8 kernel seems to fix it.

--- a/raid1.c   2003-10-17 16:43:14.000000000 -0500
+++ b/raid1.c   2003-10-22 11:57:59.350900256 -0500
@@ -841,7 +841,7 @@
        }
 
        if (atomic_dec_and_test(&r1_bio->remaining)) {
-               md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9,
0);
+               md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9,
1);
                put_buf(r1_bio);
        }
 }






