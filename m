From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 0/4] raid0<->raid10 takeover for imsm metadata
Date: Mon, 17 Jan 2011 16:42:35 +0100
Message-ID: <20110117153908.25096.42697.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The following series implements raid0 <-> raid10 takeover support
for imsm metadata format.
It includes corrections according last code review notes.

---

Krzysztof Wojcik (4):
      Add raid10 -> raid0 takeover support
      raid0->raid10 takeover- create metadata update
      raid0->raid10 takeover- allocate memory for added disks
      raid0->raid10 takeover- process metadata update


 Grow.c        |    1 
 super-intel.c |  201 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 201 insertions(+), 1 deletions(-)

-- 
Krzysztof Wojcik
