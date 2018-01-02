From: Amy Chiang <amychiang@qnap.com>
Subject: conf->min_offset_diff calculation timing of growing raid5
Date: Tue, 2 Jan 2018 11:49:48 +0800
Message-ID: <CAJtTb3GYuEL-tco3Uy7L0G3ssTFez3=Qwghd5DzqTU5y-snh3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I was trying to find a way to make rehape fast but safe. Since growing
a 3-SSD raid5 array to 4-SSD raid6 with backup file specified takes
180 minutes and it only takes 30 minutes if there's no backup file.
I tried to do it with command
          mdadm --grow /dev/md0 --level=6 --raid-device=4

I didn't specify --backup-file because I thought mdadm would give me a
warning if there's a possibility that I might lose my data if this
operation crash.
From the trace I added in function reshape_request in kernel I found
        1. metadata only updated every 10 seconds
        2. conf->min_offset_diff is always 0 thus makes no difference
to write/safe/readpos calculation.

Then I made a test, I cut off the power before the first metadata
update but the new stripe has been overlapped with the old data. The
reshape started from the beginning after I turn on the power and the
array started again. This sudden power loss actually crashed my data.

And if I calculate conf->min_offset_diff before reshape started, none
of the problem mentioned above would happen and it takes only around
30 minutes for doing reshape.

So I was wondering if calculating conf->min_offset_diff before doing
reshape can keep data safe when there's no backup file, and if it can,
why did kernel calculate this value when array starts instead of
before doing reshape.

Thanks,
