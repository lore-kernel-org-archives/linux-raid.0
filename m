From: Christoph Hellwig <hch@lst.de>
Subject: raid5-cache I/O path improvements
Date: Mon,  7 Sep 2015 07:20:40 +0200
Message-ID: <1441603250-5119-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Hi Shaohua, hi Neil,

this series contains a few updates to the raid5-cache feature.

The first patch just ports it to the post-4.2 block layer.  As part of that
I noticed that it currently doesn't handle I/O errors - fixes for that will
follow.

The second and third patch simplify the I/O unit state machine and reduce
latency and memory usage for the I/O units.  The remainder are just a couple
of cleanups in this area that I stumbled upon.

