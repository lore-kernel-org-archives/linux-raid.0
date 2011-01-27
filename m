From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 0/2] Release 3.2 summary
Date: Thu, 27 Jan 2011 17:46:42 +0100
Message-ID: <20110127154905.11703.56960.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Neil,

Intel plans to include following features in mdadm-3.2 release:
- Array Auto Rebuild,
- Online Capacity Expansion,
- Takeover raid10->raid0,
- Takeover raid0->raid10,
- Takeover raid1->raid0

They are almost incorporated into your repository and tested.
Some of patches are waiting for your acceptation and some will be send
today.
We're getting closer to the end of release and I would like to summarize
and explain what exactly needs to be done.

To finish our features following patches have to be appyied:
mdadm:
- FIX: Meet SET_ARRAY_INFO ioctl requirements (this series)
- FIX: Remove disks in mdmon for external metadata (this series)
- WORKAROUND: mdadm hangs during reshape (PART #2)
- FIX: delta_disk can have UnSet value
- imsm: FIX: spare cannot be added (very imprtand fix- blocks many tests)
- FIX: start_reshape status should be checked
- FIX: Container can be left frozen
- FIX: Array after takeover has to be frozen
- imsm: FIX: do not allow for container operation for the same disks number
- imsm: Update metadata for second array
kernel:
- Add raid1->raid0 takeover support
- md/raid5: FIX: reshape on degraded devices has wrong configuration
- md: do not write resync checkpoint, if max_sector has beeen reached
- unblock the creation of an external metadata RAID if native one exists

Could you review patches above and eventually apply them, please?

Besides "Assemble: allow to assemble spares on their own" patch has to be
discused and final solution has to be found.

After all patches will be applyied we expect all planned featues will be
working and we can finish the 3.2 release. Of course we will continue our
testing after official release and new defects may be discovered.

And question for you. When do you plan to announce official 3.2 release?
Can we assume that this will be at the beginning of next week?

---

Krzysztof Wojcik (2):
      FIX: Remove disks in mdmon for external metadata
      FIX: Meet SET_ARRAY_INFO ioctl requirements


 Grow.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

-- 
Regards
Krzysztof Wojcik
