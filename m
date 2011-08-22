From: Bill Allaire <vger@bogoflop.com>
Subject: [PATCH] md.4: two typos fixed
Date: Mon, 22 Aug 2011 13:24:17 -0400
Message-ID: <4E5290C1.5050400@bogoflop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
Cc: neilb@suse.de
List-Id: linux-raid.ids

Signed-off-by: Bill Allaire <vger@bogoflop.com>
---
  md.4 |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/md.4 b/md.4
index 36719ba..d97803c 100644
--- a/md.4
+++ b/md.4
@@ -136,7 +136,7 @@ details.
  .I md
  is able to communicate with the user-space program through various
  sysfs attributes so that it can make appropriate changes to the
-metadata \- for example to make a device as faulty.  When necessary,
+metadata \- for example to mark a device as faulty.  When necessary,
  .I md
  will wait for the program to acknowledge the event by writing to a
  sysfs attribute.
@@ -215,7 +215,7 @@ spindle. In theory, having an N-disk RAID1 will 
allow N sequential
  threads to read from all disks.

  Individual devices in a RAID1 can be marked as "write-mostly".
-This drives are excluded from the normal read balancing and will only
+These drives are excluded from the normal read balancing and will only
  be read from when there is no other option.  This can be useful for
  devices connected over a slow link.

-- 

