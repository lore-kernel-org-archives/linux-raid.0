From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Question about RAID1 plug/unplug code
Date: Mon, 8 Sep 2014 16:55:52 +0300
Message-ID: <CAGRgLy4WTXdF4Tp1pf0BJ-VPR3Yhx_xyzbCAXBzNDpeYTPvkmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,
We have been seeing high latency on the md/raid1 block device, due to
the fact that all WRITEs are handed off to raid1d thread. This thread
also calls bitmap_unplug(), which writes the bitmap synchronously.
While it waits for the bitmap, it cannot trigger other WRITEs waiting
in its pending_bio_list. This is especially seen with SSDs: MD's
latency is much higher that SSD latency (I have been stoned by Peter
Grandi when I brought up this issue previously for raid5).

Then I have noticed the commit:

commit f54a9d0e59c4bea3db733921ca9147612a6f292c
Author: NeilBrown <neilb@suse.de>
Date:   Thu Aug 2 08:33:20 2012 +1000

    md/raid1: submit IO from originating thread instead of md thread.

Looking at the code, I learned that to avoid switching into raid1d,
the caller has to use blk_start_plug/blk_finish_plug. So I added these
calls in our kernel module, which submits bios to MD. Results were
awesome, MD latency got down significantly.

So I have several questions about this plug/unplug thing.

1/ Originally this infrastructure was supposed to help IO schedulers
in merging requests. It is useful when one has a bunch of requests to
submit in one shot.
But in MD case, thus infrastructure is used for a different purpose:
not to merge requests (which may help bandwidth, but probably not
latency), but to avoid making raid1d a bottleneck, to be able to
submit requests from multiple threads in parallel, which brings down
latency significantly in our case. Indeed "struct blk_plug" has a
special "cb_list", which is used only by MD.
In my case I have only individual bios (not a bunch of bios), and I
after wrap them with plug/unplug, MD latency gets better. So we are
using the plug infrastructure for a different purpose.
Is my understanding correct? Was this your intention?

2/ Now that md/raid1 submits WRITEs from several threads in parallel,
is there any issue you can think of? Like for example, multiple
threads now call bitmap_unplug() in parallel. Is this alright?

Thanks!
Alex.
