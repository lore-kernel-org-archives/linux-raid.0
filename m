From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 22/22] imsm: Unit Tests - remove backup-file during grow
	command
Date: Thu, 02 Jun 2011 16:51:14 +0200
Message-ID: <20110602145114.27355.3908.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

Update reshape/migration unit tests to not to use backup file.
Imsm native check-pointing has to be used (internally) instead.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 tests/imsm-grow-template |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tests/imsm-grow-template b/tests/imsm-grow-template
index 191f056..8022e3a 100644
--- a/tests/imsm-grow-template
+++ b/tests/imsm-grow-template
@@ -14,10 +14,9 @@ function grow_member() {
 	local offset=$6
 	local chunk=$7
 	local array_size=$((comps * size))
-	local backup_imsm=/tmp/backup_imsm
 
 	rm -f $backup_imsm
-	( set -ex; mdadm --grow $member --chunk=$chunk --level=$level --backup-file=$backup_imsm )
+	( set -ex; mdadm --grow $member --chunk=$chunk --level=$level )
 	local status=$?
 	if [ $negative_test -ne 0 ]; then
 		if [ $status -eq 0 ]; then
@@ -83,7 +82,7 @@ if [ $migration_test -ne 0 ]; then
 	fi
 else
 	rm -f $backup_imsm
-	( set -x; mdadm --grow $container --raid-disks=$num_disks --backup-file=$backup_imsm )
+	( set -x; mdadm --grow $container --raid-disks=$num_disks )
 	grow_status=$?
 	if [ $negative_test -ne 0 ]; then
 		if [ $grow_status -eq 0 ]; then

