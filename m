From: Bas van Schaik <bas@tuxes.nl>
Subject: Doing 'echo repair > /sys/devices/virtual/block/md?/md/sync_action'
 does not result in mismatch_cnt of 0 on RAID-6?
Date: Tue, 15 Mar 2011 11:30:59 +0000
Message-ID: <4D7F4DF3.7010804@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All,

I'm seeing a non-zero mismatch_cnt (in fact, it's 1704) on my RAID-6
array consisting of 8 devices on kernel 2.6.38. After replacing some
hardware, I decided to trigger a MD repair by issuing:
  echo repair > /sys/devices/virtual/block/md5/md/sync_action

Directly after issuing this command, the mismatch_cnt is reset to 0 and
MD starts checking the array. However, the mismatch_cnt increases during
this check - resulting in exactly the same count as seen before.
Shouldn't 'repair' yield a zero mismatch_cnt? I think I have seen
'repair' work on other RAID-6 arrays?

Furthermore, theoretically it should be possible to indicate which
device in the RAID-6 array contains the inconsistent data, or am I
mistaking? If so, that would certainly be a nice feature to see
implemented, as it would help diagnosing problems.

Please let me know your thoughts, as I'm quite keen to get my
mismatch_cnt back to 0 in order to see whether the new hardware works
properly!

Thanks,

  Bas
