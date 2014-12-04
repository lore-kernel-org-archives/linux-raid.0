From: "Matthew M. Dean" <fireculex@gmail.com>
Subject: pretty unstable raid 5 now
Date: Wed, 3 Dec 2014 18:08:22 -0800
Message-ID: <CAPRzDfn33EBkci823=zw=6b3jnf-0YMr1YTU_j7RQ5qseu_fvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So I've been running a raid 5 using an openwrt box with 3 loop files
and lvm. All was well for over a year. Now /dev/loop3 keeps dropping
from the raid

The first time it dropped was due to the network drive actually
locking up, it tried to start with only 1 drive and failed. I had to
--force the loop files to start, which 2 of them actually did. I could
no longer --re-add the drive.

Using --add did add the drive to the raid but the sync started at 0%
so have to wait for it to rebuild. 11mb/sec takes a while on a 1.5
terabyte array.

after 82% sync the router locked up I think to a oom condition, 128mb
only. /dev/loop3 was dropped from the array again. I was able to
--re-add. 0% SYNC AGAIN. ~30 hours wasted. This has never happened.

What has changed?

I upgraded from a 3.10 kernel to 3.14 and from mdadm 3.2.6 to 3.3.2

Aren't bitmap's supposed to fix this? Are they useless now?
