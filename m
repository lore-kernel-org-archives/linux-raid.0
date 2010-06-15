From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 0/3] md: takeover fixes
Date: Tue, 15 Jun 2010 09:33:25 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E8734A1@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hello Neil,
I finally had a chance to validate the takeover patches that you have sent
and I encountered some significant problems while raid0->raid10 and raid10->raid0
takeover operations. 
Would it be possible to add these to 2.6.35 takeover patches?

Thanks,
Maciek.

---

Maciej Trela (3):
      md: fix raid10 takeover: use new_layout for setup_conf
      md: fix unwanted slot changes for raid10 takeover
      md: fix invalid dev slots after takeover


 drivers/md/md.c     |   14 ++++++++------
 drivers/md/raid10.c |   23 ++++++++---------------
 2 files changed, 16 insertions(+), 21 deletions(-)

-- 

