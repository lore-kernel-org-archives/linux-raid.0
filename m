From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] fix: imsm: re-enable size expansion to the max value
Date: Fri, 14 Sep 2012 16:04:08 +0200
Message-ID: <20120914140408.18473.68610.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, ed.ciechanowski@intel.com, Jacek.Danecki@intel.com
List-Id: linux-raid.ids

Size expansion to the 'max' value has been broken since
the following patch:

    commit d04f65f48c93e7e57cc3c1d70dd07d094dece717
    Change the values for "max size" from -1 to 1.

This patch re-enables it.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d11eabd..1d36613 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -9737,7 +9737,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	 */
 	current_size = info.custom_array_size / data_disks;
 
-	if (geo->size > 0) {
+	if ((geo->size > 0) && (geo->size != MAX_SIZE)) {
 		/* align component size
 		 */
 		geo->size = imsm_component_size_aligment_check(

