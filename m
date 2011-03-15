From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/4] Raid0 metadata cannot be recognized
Date: Tue, 15 Mar 2011 14:48:16 +0100
Message-ID: <20110315134000.32643.1818.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Hi,

I've executed unit tests on today's devel3-2 and I've found that
expansion cannot be executed due to fact that imsm metadata
cannot be found after creation.
Looking patches I've found that problem was introduced by patch:

Manage/external: for external metadata, add_to_super needs lock on container.

It is due to fact that metadata is not written by monitor for raid0.

Problem is fixed by patch:
  FIX: Write metadata when mdmon is not running

Other patches addresses problems/i.e. inconsistency in closing handle/
that I've noticed during investigation.

BR
Adam


---

Adam Kwolek (4):
      FIX: ping_monitor() usage causes memory leaks
      FIX: Handle has to be closed
      FIX: Write metadata when mdmon is not running
      FIX: Ping monitor when mdmon is running only


 Assemble.c    |    2 +-
 Create.c      |    2 +-
 Grow.c        |    2 +-
 Incremental.c |   10 ++++------
 Manage.c      |   10 +++++++++-
 Monitor.c     |    2 +-
 msg.c         |   14 ++++++++++++++
 msg.h         |    1 +
 8 files changed, 32 insertions(+), 11 deletions(-)

-- 
Signature
