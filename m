From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC mdadm PATCH 11/11] imsm: support cache enabled arrays
Date: Thu, 24 Apr 2014 00:23:18 -0700
Message-ID: <20140424072318.4515.25901.stgit@viggo.jf.intel.com>
References: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, dave.jiang@intel.com
List-Id: linux-raid.ids

Turn on attribute support for caching.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e69d2a044e92..10c38b248ce6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -81,7 +81,8 @@
 					MPB_ATTRIB_RAID1           | \
 					MPB_ATTRIB_RAID10          | \
 					MPB_ATTRIB_RAID5           | \
-					MPB_ATTRIB_EXP_STRIPE_SIZE)
+					MPB_ATTRIB_EXP_STRIPE_SIZE | \
+					MPB_ATTRIB_NVM)
 
 /* Define attributes that are unused but not harmful */
 #define MPB_ATTRIB_IGNORED		(MPB_ATTRIB_NEVER_USE)

