From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/17] hot-replace support for RAID1 and RAID10
Date: Wed, 02 Nov 2011 16:25:43 +1100
Message-ID: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Last week I posted code to support hot-replace for RAID4/5/6.

Here now is similar code for RAID1 and RAID10.

I wasn't originally going to support RAID1, but during development I
realised that it does make sense.  Even though you can do the
equivalent manually (increase the number of devices in the array,
add the replacement, wait for rebuild, fail and remove the old
device..) :

1/ it make it a lot easier for people if the same mechanism is used
   for all RAID levels, and
2/ This needs to be triggered automatically when the kernel detects a
   write error and records it in a bad-block-log.

So I did do RAID1 in the end.  As you can imagine the changes are much
smaller.

All of this is in my md-devel branch:

   git://neil.brown.name/md md-devel

together with the RAID4/5/6 code which has been revised a bit since I
posted it.

As mentioned previously, mdadm doesn't understand this at all yet.  It
experiment, follow the same guidelines as in the RAID4/5/6
announcement.
I plan to spend the next few weeks doing some development on mdadm,
including proper support for bad-block-logs and hot-replace.

Test, review, questions: always welcome.

Thanks,
NeilBrown


---

NeilBrown (17):
      md/raid1: Mark device replaceable when we see a write error.
      md/raid1: If there is a spare and a replaceable device, start replacement.
      md/raid1: recognise replacements when assembling arrays.
      md/raid1: handle activation of replacement device when recovery completes.
      md/raid1: Allow a failed replacement device to be removed.
      md/raid1: Allocate spare to store replacement devices and their bios.
      md/raid1:  Replace use of mddev->raid_disks with conf->raid_disks.
      md/raid10: If there is a spare and a replaceable device, start replacement.
      md/raid10: recognise replacements when assembling array.
      md/raid10: Allow replacement device to be replace old drive.
      md/raid10: handle recovery of replacement devices.
      md/raid10:  Handle replacement devices during resync.
      md/raid10: writes should get directed to replacement as well as original.
      md/raid10: allow removal of failed replacement devices.
      md/raid10: preferentially read from replacement device if possible.
      md/raid10:  change read_balance to return an rdev
      md/raid10: prepare data structures for handling replacement.


 drivers/md/raid1.c  |  161 +++++++++++----
 drivers/md/raid1.h  |    7 +
 drivers/md/raid10.c |  563 +++++++++++++++++++++++++++++++++++++++++----------
 drivers/md/raid10.h |   61 +++---
 4 files changed, 622 insertions(+), 170 deletions(-)

-- 
Signature

