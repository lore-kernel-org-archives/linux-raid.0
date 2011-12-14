From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/3] Enable mdadm UT execution for imsm
Date: Wed, 14 Dec 2011 16:06:55 +0100
Message-ID: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

3 mdadm UT (08, 09, 15) are not working now. 
This series fixes those UT execution.

BR
Adam

---

Adam Kwolek (3):
      imsm: FIX: UT '08imsm-overlap' fails
      imsm: FIX: 'UT 09imsm-assemble' fails
      imsm: FIX: Chunk size migration is not possible


 Assemble.c    |    2 ++
 Incremental.c |    3 +++
 super-intel.c |   52 +++++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 46 insertions(+), 11 deletions(-)

-- 
Signature
