From: Anuj Goel <agoel@cs.stonybrook.edu>
Subject: [Doubt] how is a disk marked faulty in RAID5
Date: Tue, 24 Apr 2012 19:36:48 -0400
Message-ID: <CANSbrrpBAPdKgJYJGtpRs0DcwTs_1BEOEaxf3y4fVcO6M+0H1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have been looking into the RAID5 code, but unable to find how a disk
is marked faulty in a RAID5 array.
I consider the case when we try to read, say 2 sectors within a chunk
and the read fails. My understanding so far is as below:

The status of the read operation is returned in the call back function
"raid5_align_endio" registered in chunk-aligned_read().
If there was an error in the read, it LIFO adds the original bio to
the retry list and wakes up the raid5d thread.
This thread will remove the bio from the retry list and send it to
retry_aligned_read().

In retry_aligned_read(), we first compute the disk number and sector
offset within the disk using raid5_compute_sector().

1. Then we do some stripe operations, but I cannot see where the
actual read from the disk is scheduled.
2. Also, if the sector on the disk is found unreadable, according to
the RAID5 design, it should be recomputed using parity and the disk
marked FAULTY. Can you please point me to the code/functions I should
look into to understand how this is being done.
3. After one disk failure, if another disk fails, I think the RAID5
array cannot be used anymore. How is the second disk failure reported
?

This is my first tryst with Linux code, (specifically software RAID),
so I am not sure how to debug and understand the code flow.
Is code reading the only way to understand the flow, or is there some
documentation giving a high level overview of the implementation of
software RAID ?

Any suggestions will be highly appreciated !!

-- 
Best Regards,
Anuj Goel
Experimental Computer Science Lab
Stony Brook University.
Cell: +1-801-209-5873
