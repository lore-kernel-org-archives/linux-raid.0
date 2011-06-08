From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 11/21] imsm: FIX: Remove unused parameter from
	save_backup_imsm() interface
Date: Wed, 08 Jun 2011 18:11:02 +0200
Message-ID: <20110608161102.24327.99468.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

new_data parameter is not used in save_backup_imsm().
It is removed from function interface.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b22c7df..708b51d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7677,9 +7677,9 @@ void init_migr_record_imsm(struct supertype *st, struct imsm_dev *dev,
  *		and to write it to the Copy Area.
  * Parameters:
  *	st		: supertype information
+ *	dev		: imsm device that backup is saved for
  *	info		: general array info
  *	buf		: input buffer
- *	write_offset	: address of data to backup
  *	length		: length of data to backup (blocks_per_unit)
  * Returns:
  *	 0 : success
@@ -7689,7 +7689,6 @@ int save_backup_imsm(struct supertype *st,
 		     struct imsm_dev *dev,
 		     struct mdinfo *info,
 		     void *buf,
-		     int new_data,
 		     int length)
 {
 	int rv = -1;
@@ -8811,8 +8810,7 @@ static int imsm_manage_reshape(
 			 * in backup general migration area
 			 */
 			if (save_backup_imsm(st, dev, sra,
-					     buf + start_buf_shift,
-					     ndata, copy_length)) {
+				buf + start_buf_shift, copy_length)) {
 				dprintf("imsm: Cannot save stripes to "
 					"target devices\n");
 				goto abort;

