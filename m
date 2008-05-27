From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 3] md: raid5 patches suitable for 2.6.26 and -stable
Date: Tue, 27 May 2008 16:31:53 +1000
Message-ID: <20080527162558.16305.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, stable@kernel.org
List-Id: linux-raid.ids

Following are three patches that fixes bugs in raid5 that could
conceivable cause data corruption (1 and 3) or and oops (2).

Bugs 1 and 3 can cause a 'resync' to mistakenly think the partiy block
is correct when infact it isn't (it looks at a parity block that was
generated rather than read from disk).  If this happens to leave a
parity block wrong, and a device then fails, data regenerated based on
that parity block will be wrong.

Once a patched kernel is installed, running a repair pass 
(echo repair > .../sync_action) will fix any incorrect parity.

The Oops (patch 2) can only happen if you right to a partucular sysfs
file that only root has access to and only developer (currently) have
any reason to write to.

NeilBrown

 [PATCH 001 of 3] md: md: fix prexor vs sync_request race
 [PATCH 002 of 3] md: fix uninitialized use of mddev->recovery_wait
 [PATCH 003 of 3] md: Do not compute parity unless it is on a failed drive
