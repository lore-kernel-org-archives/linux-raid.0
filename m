From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/2] Do not allow for resync during reshape
Date: Thu, 29 Sep 2011 17:45:26 +0200
Message-ID: <20110929154250.22094.48754.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

The following series blocks for IMSM metadata starting resync process
when there is active reshape in the same container.

BR
Adam


---

Adam Kwolek (2):
      imsm: Do not mark resync during reshape
      imsm: FIX: Do not allow for spare disk activation during reshape


 super-intel.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 34 insertions(+), 7 deletions(-)

-- 
Signature
