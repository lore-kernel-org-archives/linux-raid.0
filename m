From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: raid10f2. mismatch_cnt=128. 'repair' does nothing.
Date: Fri, 17 Sep 2010 22:40:54 -0500
Message-ID: <AANLkTik5y-83xR=wR3=weXxLOegOeub3=jCuMMV5umjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a raid10f2 across 2 drives.
I happened to note (only by chance!) that mismatch_cnt was 128, after
a periodic 'check' (/sys/block/md0/md/sync_action).
A quick google seemed to suggest that a 'repair' was in order.
mismatch_cnt reset to 0, and I waited 2 hours.
mismatch_cnt is now 128 again, but *no* kernel messages about the
repair were output, except:

[463639.341245] md: requested-resync of RAID array md0
[463639.341252] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[463639.341257] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for requested-resync.
[463639.341266] md: using 128k window, over a total of 483401728 blocks.
[470612.805202] md: md0: requested-resync done.

This does not seem to be right.

Kernel: 2.6.34.4-0 from openSUSE 11.3 x86_64.

-- 
Jon
