From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/3] Fix freezing multiple array in container during assembly
Date: Thu, 29 Sep 2011 17:53:27 +0200
Message-ID: <20110929154756.22854.13187.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

The following series corrects freezing reshaped array in container during assembly
while other arrays are present also.

The goal of patches is to get entire assembled container (all arrays inside)
to be blocked from monitoring when reshape is in progress /exactly as when reshape 
is initialized from mdadm command line/.

BR
Adam

---

Adam Kwolek (3):
      FIX: Remove error message during reshape restart (v2)
      FIX: Block array monitoring if any array is under reshape in container
      Move code to check_mdmon_version() function


 Assemble.c |   19 ++++++++-
 Grow.c     |   44 ++++++++++++++++++----
 mdadm.h    |    2 +
 msg.c      |  121 +++++++++++++++++++++++++++++++++++++++++++++++-------------
 msg.h      |    3 +
 5 files changed, 152 insertions(+), 37 deletions(-)

-- 
Signature
