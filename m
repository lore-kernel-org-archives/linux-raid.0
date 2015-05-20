From: James J <james.j@shiftmail.org>
Subject: Massive data corruption on replace + fail + rebuild
Date: Wed, 20 May 2015 22:36:04 +0200
Message-ID: <555CF034.8050303@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello all,
I wrote some days ago to the ML with subject "MD RAID hot-replace wants 
to rewrite to the source! (and fails, and kicks)"
The problem went much worse than that and ended with massive data 
corruption on the replacement drive sdm.

In this report I will use the same letters as in previous email: sdl for 
the failing drive, sdm for the replacement drive.
This report is for raid5 on kernel 3.4.34 .
Bad blocks list is not enabled.
Bitmap is enabled
See previous post for details, mdstat and dmesg log.

It seems that the following series of events deeply corrupts the 
replacement drive:
1) drive sdl is flaky, so the user initiates replacement process 
(want_replacement) to the spare drive sdm
2) the disk sdl has read errors on some sectors. MD performs reconstruct 
read and then rewrite for those sectors. Currently MD wants to rewrite 
the source drive sdl, instead of just to the replacement drive sdm which 
I would much prefer.
3) sdl unfortunately is too flaky to receive rewrites, so it fails on 
the rewrites and is kicked by MD. The array is now degraded
4) At this point, MD apparently continues the rebuild process 
transforming the replacement into a full rebuild, but continuing from 
the point where sdl was kicked, and not from the start. This seems 
smart, however I guess there is a bug in doing this, maybe an off-by-N 
error. In the previous post you can see the dmesg line "[865031.586650] 
md: resuming recovery of md54 from checkpoint."

At the end of the rebuild, when MD starts using sdm as a member drive, 
an enormous amount of errors appear on the filesystems located on that 
array.

In fact, I performed a check afterwards, and this was the mismatch_cnt:

   root@server:/sys/block/md54/md# cat mismatch_cnt
   5296438776

This is on a 5x3TB array so about 90.4% of it has mismatches, if my math 
is correct.

The drive sdl was kicked at about 1% of the replacement process, so this 
90.4% would not match, should have been 99%, but considering that many 
stripes could be zeroes, an 8.5% could be parities on zeroes which match 
just by chance.

So I suppose there is a problem in the handover between the replacement 
and the rebuild. I would bet on an off-by-N problem, i.e. a shifting of 
the data. Maybe the sources start a reconstruct-read from the beginning 
of the array while the destination continues writing from the point of 
the handover, or vice versa.

Currently I have "solved" the problem already, by artificially failing 
the drive sdm, and introducing another disk as spare to perform a clean 
rebuild from scratch. After failing sdm and dropping the caches, before 
inserting the new spare, the filesystems were readable again, so I was 
optimistic, and in fact at the end of the clean rebuild this appears to 
have recovered our data and mismatch_cnt is now zero. However I was 
lucky to have immediately understood what happened, otherwise we would 
have probably lost all our data, so please look into this.

Thanks for your work
PS: I would appreciate if you can also make MD not rewrite to the source 
during replacement :-)
JJ

