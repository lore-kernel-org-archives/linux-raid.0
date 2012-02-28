From: John Adams <john.adams@avid.com>
Subject: What are these reads in what should be simply a full-stripe write?
Date: Tue, 28 Feb 2012 18:47:56 +0000
Message-ID: <FC0D60DF-6357-495C-B10A-1C727AAFCBE3@avid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <2E307D62BB48984CB52AF8C17B115238@avid.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

For some years I've been working on some niche filesystems which serve
workflows involving lots of video.  Lately, I have had occasion to
investigate the behavior of md as a possible raid solution (2.6.32
kernel).

As part of that, we looked at some fio based loads in the buffered and
O_DIRECT cases and noticed some reading that we didn't understand when
using O_DIRECT.  We were led to this comparision by incorrect
information from a vendor. (We were trying to repro some reported
performance and were initially told that O_DIRECT had been used).

We are aware of the problems discussed concerning O_DIRECT.  As fs
guys, we're accustomed to worrying about copies and such, so it wasn't
immediately obvious to us that O_DIRECT would be a mistake in our
case.  This is essentially an embedded system with a single process
owning a group of disks with no filesystem.  There is no possibility
of a race with another process.

Anyway, I am curious about this reading behavior and I would grateful for any
comments.

I tried writing single stripes under both scenarios.  To give the
barest possible summary. I used a dd command like this with
oflag=direct omitted or not.  This was driven from a script that
sets up some blktrace and ftrace things, waits an appropriate time in
the buffered case etc.

dd oflag=direct if=/dev/zero of=/dev/md0 seek=0 bs=1M count=1

8+2 128k strip

[physical disk completions via blkparse]

Buffered:

 Reads Completed:        2,        5KiB  Writes Completed:        4,      258KiB
 Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
 Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
 Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
 Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
 Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
 Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
 Reads Completed:        0,        0KiB  Writes Completed:        3,      130KiB
 Reads Completed:        2,        8KiB  Writes Completed:        3,      130KiB
 Reads Completed:        6,       24KiB  Writes Completed:        4,      258KiB

Direct Example 1:

 Reads Completed:        2,        5KiB  Writes Completed:       20,      258KiB
 Reads Completed:        9,       36KiB  Writes Completed:       14,      130KiB
 Reads Completed:       32,      128KiB  Writes Completed:       14,      130KiB
 Reads Completed:        1,        4KiB  Writes Completed:       16,      130KiB
 Reads Completed:       32,      128KiB  Writes Completed:       12,      130KiB
 Reads Completed:        0,        0KiB  Writes Completed:        8,      130KiB
 Reads Completed:        0,        0KiB  Writes Completed:        8,      130KiB
 Reads Completed:        0,        0KiB  Writes Completed:        8,      130KiB
 Reads Completed:        2,        8KiB  Writes Completed:        8,      130KiB
 Reads Completed:        6,       24KiB  Writes Completed:       19,      258KiB

Direct Example 2:

 Reads Completed:        4,      133KiB  Writes Completed:        3,      130KiB
 Reads Completed:       11,      164KiB  Writes Completed:        3,      130KiB
 Reads Completed:       34,      256KiB  Writes Completed:        3,      130KiB
 Reads Completed:        2,      132KiB  Writes Completed:        3,      130KiB
 Reads Completed:       33,      256KiB  Writes Completed:        3,      130KiB
 Reads Completed:        3,      136KiB  Writes Completed:        3,      130KiB
 Reads Completed:        7,      152KiB  Writes Completed:        3,      130KiB


I was able to gain a little bit of insight through blktrace and
ftrace.  Our initial assumption was that maybe things were being
broken up differently such that md thought it needed to do a rmv.

But as I dug into the blktrace output, that did not seem to be the
case (reads are coming after what is obviously the strip write).  I
used ftrace to show me the path down to md_make_request in the
O_DIRECT and buffered cases.  This showed me some calls refering to
read_ahead in the direct case.

           <...>-14859 [001] 510340.525310: md_make_request
           <...>-14859 [001] 510340.525311: <stack trace>
 => generic_make_request
 => submit_bio
 => submit_bh
 => block_read_full_page
 => blkdev_readpage
 => __do_page_cache_readahead
 => force_page_cache_readahead
 => page_cache_sync_readahead

So is this read ahead I'm observing?  Why does it occur only in the
direct case?

I noticed that blktrace sometime identifies what I assume to be the
instigator of the io.  So I can sometimes see dd or md_raid6 there.
As in [dd] or [md0_raid6]:

 8,16   1      115     0.042000000  2910  D   W 2256 + 48 [md0_raid6]

These unexplained reads either mention blkid or [0] or [(null)].

It isn't clear to me whether the unexpected read behavior is due to a
tuning problem in the O_DIRECT case or simply the way things work.

Thank you for any comments.