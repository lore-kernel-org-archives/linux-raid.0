From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/3] imsm: FIX: existing backup file fails unit tests
Date: Mon, 14 Mar 2011 15:09:29 +0100
Message-ID: <20110314140928.20478.77566.stgit@gklab-128-013.igk.intel.com>
References: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

During normal test execution, backup file is deleted after test execution.
If test is interrupted/broken, backup file can remain for next run.
When backup file exists before unit test run, suits 12 and 13 fails.

To avoid this remove backup file before grow is executed.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 tests/imsm-grow-template |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/imsm-grow-template b/tests/imsm-grow-template
index 7c212c4..d03752d 100644
--- a/tests/imsm-grow-template
+++ b/tests/imsm-grow-template
@@ -17,8 +17,10 @@ function grow_member() {
 	local offset=$6
 	local chunk=$7
 	local array_size=$((comps * size))
+	local backup_imsm=/tmp/backup_imsm
 
-	( set -ex; mdadm --grow $member --chunk=$chunk --level=$level --backup-file=/tmp/backup_imsm )
+	rm -f $backup_imsm
+	( set -ex; mdadm --grow $member --chunk=$chunk --level=$level --backup-file=$backup_imsm )
 	local status=$?
 	if [ $negative_test -ne 0 ]; then
 		if [ $status -eq 0 ]; then
@@ -71,6 +73,7 @@ done
 
 imsm_check container $num_disks
 num_disks=$((num_disks + add_to_num_disks))
+backup_imsm=/tmp/backup_imsm
 
 # Grow each member or a container depending on the type of an operation
 if [ $migration_test -ne 0 ]; then
@@ -82,7 +85,8 @@ if [ $migration_test -ne 0 ]; then
 		grow_member $member1 $new_num_disks $vol1_new_num_comps $vol1_new_level $vol1_comp_size $vol1_offset $vol1_new_chunk
 	fi
 else
-	( set -x; mdadm --grow $container --raid-disks=$num_disks --backup-file=/tmp/backup_imsm )
+	rm -f $backup_imsm
+	( set -x; mdadm --grow $container --raid-disks=$num_disks --backup-file=$backup_imsm )
 	grow_status=$?
 	if [ $negative_test -ne 0 ]; then
 		if [ $grow_status -eq 0 ]; then

