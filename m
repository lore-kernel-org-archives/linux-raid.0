From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0/2] Fixes for dm-raid faulty device restoration
Date: Wed, 08 May 2013 17:54:57 -0500
Message-ID: <1368053697.2890.5.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

Neil,

I've discovered a bug in the recently accepted (for 3.11) patch:
"[PATCH - v2] DM RAID: Add ability to restore transiently failed devices
on resume"

I have two follow-on patches to fix the issue:
- [PATCH 1/2] DM RAID:  Break-up untidy function
- [PATCH 2/2] DM RAID:  Fix raid_resume not reviving failed devices in
all cases

Thanks,
 brassow

