From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/3] Reshape restart after file system pivot (missing part)
Date: Tue, 04 Oct 2011 17:53:41 +0200
Message-ID: <20111004155129.27434.81564.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

This patch series (3) adds missing part for reshape restart after file system
pivot during OS boot.
Patches makes changes to Grow_continue() execute it on already run arrays:

start_reshape() function is modified (in simpler way) to set correct
restart position and allow reshape process to be reported by mdstat:

Note: 
  This patch series requires: Remove freeze() call from Grow_continue()
  patch to be applied (sent yesterday).

BR
Adam

---

Adam Kwolek (3):
      Set correct reshape restart position
      Monitor reshaped array
      Always run Grow_continue() for started array.


 Assemble.c |   23 +++++++++++++++++++----
 Grow.c     |   60 ++++++++++++++++++++++++++++++------------------------------
 2 files changed, 49 insertions(+), 34 deletions(-)

-- 
Signature
