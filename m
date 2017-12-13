From: Amy Chiang <amychiang@qnap.com>
Subject: Will mdadm make a backup if it takes two steps to covert raid5 to raid6?
Date: Wed, 13 Dec 2017 11:57:22 +0800
Message-ID: <CAJtTb3EwgaAPCW+xKeNLxViWt2OixTLtW9Zeh3WZQY4q59x6hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I was trying to grow my raid5 array to raid6 with one more disk. And I
was wondering about when would the backup take place and when would
the backup file is required (or not required).

And I found this thread "Re: Backup file size when migrating from
raid5 to raid6?"
two steps were mentioned in the thread to reduce the time of level changing.

so I followed the steps,

currently there were 3 disks in my array.

$ mdadm --grow /dev/md0 --level=6 --layout=preserve
mdadm: Need 1 spare to avoid degraded array, and only have 0.
       Use --force to over-ride this check.
$ mdadm --grow /dev/md0 --level=6 --layout=preserve --force
mdadm: level of /dev/md119 changed to raid6

the array became raid6 and the state is clean, degraded and nothing
more happened, I thought it would create Q in this step, but there
were no writing from iostat.

so I added one disk
$ mdadm --grow /dev/md0 --raid-devices=4 --layout=normalise

State : clean, degraded, reshaping

but from previous post in this thread, I thought the backup file is a
must under this circumstance, and according to the throughput of those
disks (not slow), there seemed no backup was happening.

my question is,
1. "mdadm --grow /dev/md0 --level=6 --layout=preserve" will this
command create Q even though it degrades the array?
2. Is backup happening in second step (reshaping)? if it's happening,
why don't I need a backup file?

Thanks,
