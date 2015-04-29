From: heinzm@redhat.com
Subject: [PATCH v2 0/4] dm-raid: Add support for the MD RAID0 personality
Date: Wed, 29 Apr 2015 14:03:45 +0200
Message-ID: <1430309029-24851-1-git-send-email-heinzm@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: linux-raid.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This v2 patchset of 4 adds access to the MD RAID0 personality to dm-raid
(in addition to the already supported raid1/10/4/5/6 personalities)
to enable single zone striping.

The added functionality is the first step to allow full support
of MD kernel functionality via dm-raid and to eventually replace
the dm "striped" target altogether. Adding shrink/takeover and
reshape functionality to dm-raid is subject to future patches.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>


Heinz Mauelshagen (4):
  dm-raid: Add support for the MD RAID0 personality
  md-raid0: conditional mddev->queue access to suit dm-raid
  Documentation: add version history entries for raid0 support _and_
    forgotten devices_handle_discards_safely module paramater
  dm-raid: remove bogus parse_raid_params() comment about
    devices_handle_discards_safely

 Documentation/device-mapper/dm-raid.txt |   3 +
 drivers/md/dm-raid.c                    | 206 +++++++++++++++++---------------
 drivers/md/raid0.c                      |   5 +-
 3 files changed, 117 insertions(+), 97 deletions(-)

-- 
2.1.0
