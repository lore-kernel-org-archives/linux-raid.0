From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/4] Report new_disks number when migration is started
Date: Fri, 15 Apr 2011 14:30:22 +0200
Message-ID: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

External metadata handler reports starting disks number during expansion
until migration is finished. It is opposite to native metadata behavior
where new disks number is reported immediately when expansion is started.
This causes problem during expansion restart and causes exception
due to wrong disks number information.

This patch series unifies reported raid disks number. After reshape
is started external metadata handler reports new disks number now.

BR
Adam

---

Adam Kwolek (4):
      FIX: Count correctly added devices
      FIX: Set proper raid disks during migration
      FIX: Fiddle raid_disks number for external metadta
      FIX: Always report new raid_disks during migration


 Assemble.c    |    5 +++--
 Grow.c        |    2 ++
 super-intel.c |    2 +-
 sysfs.c       |    7 +++++--
 4 files changed, 11 insertions(+), 5 deletions(-)

-- 
Signature
