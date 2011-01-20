From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/4] OLCE continue reshape for all arrays in container
	(rebased)
Date: Thu, 20 Jan 2011 11:57:14 +0100
Message-ID: <20110120104759.22926.66874.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Hi,
Thank you for new code base, I've re-based OLCE to this version and changed reshape continuation method as you mention.
Finish of reshape of first array triggers changes in metadata for next array in set_array_state().
This simplifies Grow.c changes. The only one bug is fixed in series for multi-array case when first reshaped array is raid0
(second is monitored array).

I'm resending patch for adding spares problem also (as you not commented it previously), and adding workaraound 
for check-pointing as reminder only.

BR
Adam


---

Adam Kwolek (4):
      WORKAROUND: mdadm hangs during reshape
      FIX: monitor doesn't handshake with md
      imsm: FIX: spare cannot be added
      imsm: Update metadata for second array


 Grow.c        |    7 +++++--
 super-intel.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 6 deletions(-)

-- 
Signature
