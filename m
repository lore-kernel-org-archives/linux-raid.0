From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/3] UT and error case changes
Date: Mon, 14 Mar 2011 15:09:20 +0100
Message-ID: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series implements 2 changes:
1. Fix for unit tests failure.
UT suits 12 and 13 fails, when backup file cannot be opened
for grow operation (backup file exists already).

2. I've got proposal for handling/rollback metadata in error case.
Currently in case of error external metadata can remain in reshape state.
In some cases metadata can be automatically restored to initial state
(i.e. metadata during  imsm container operation can be rolled back 
when error occurs on first reshaped array before reshape is started).
For such cases, additional superswitch function can be introduced.

Metadata shouldn't be rolled back in restart case.
I'm passing restart flag to abort function in Grow.c only, as this is general rule.
In the same way array reshape state is checked. 

This is proposal, so I've put no implementation in to imsm handler (no metadata update is created yet).
Please let me know your opinion. If you will like it, I'll fill out gaps in imsm code.

BR
Adam

---

Adam Kwolek (3):
      imsm: Add metadata abort changes handler template
      External metadata has to be restored to initial state in error case
      imsm: FIX: existing backup file fails unit tests


 Grow.c                   |   26 ++++++++++++++++++++++++++
 mdadm.h                  |   10 ++++++++++
 super-intel.c            |   15 +++++++++++++++
 tests/imsm-grow-template |    8 ++++++--
 4 files changed, 57 insertions(+), 2 deletions(-)

-- 
Signature
