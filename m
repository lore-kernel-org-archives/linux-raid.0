From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 08/12] imsm: regression test for prodigal array member
	scenario
Date: Tue, 13 Oct 2009 19:10:56 -0700
Message-ID: <20091014021056.31570.25624.stgit@dwillia2-linux.ch.intel.com>
References: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

Provide a test to sanity check assembly and reassembly in the presence
of conflicting family number information.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tests/09imsm-assemble     |   46 +++++++++++++++++++++++++++++++++++++++++++++
 tests/env-09imsm-assemble |   32 +++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 0 deletions(-)
 create mode 100644 tests/09imsm-assemble
 create mode 100644 tests/env-09imsm-assemble

diff --git a/tests/09imsm-assemble b/tests/09imsm-assemble
new file mode 100644
index 0000000..7389b0e
--- /dev/null
+++ b/tests/09imsm-assemble
@@ -0,0 +1,46 @@
+# validate the prodigal member disk scenario i.e. a former container
+# member is returned after having been rebuilt on another system
+num_disks=4
+size=$((10*1024))
+mdadm -CR $container -e imsm -n $num_disks $dev0 $dev1 $dev2 $dev3
+mdadm -CR $member $dev0 $dev2 -n 2 -l 1 -z $size
+mdadm --wait $member
+mdadm -Ss
+
+# make dev0 and dev1 a new rebuild family
+mdadm -A $container $dev0 $dev1
+mdadm -I $container
+mdadm --wait ${member}_0
+mdadm -Ss
+
+# make dev2 and dev3 a new rebuild family
+mdadm -A $container $dev2 $dev3
+mdadm -I $container
+mdadm --wait ${member}_0
+mdadm -Ss
+
+# reassemble and make sure one of the families falls out
+mdadm -A $container $dev0 $dev1 $dev2 $dev3
+mdadm -I $container
+testdev ${member}_0 1 $size 1
+if mdadm --remove $container $dev0 ; then
+    # the dev[23] family won
+    imsm_check_removal $container $dev1
+    imsm_check_hold $container $dev2
+    imsm_check_hold $container $dev3
+else
+    # the dev[01] family won
+    imsm_check_hold $container $dev1
+    imsm_check_removal $container $dev2
+    imsm_check_removal $container $dev3
+fi
+mdadm -Ss
+
+# reassemble with a new id for the dev[23] family
+mdadm -A $container $dev0 $dev1
+mdadm -I $container
+mdadm -A ${container}2 $dev2 $dev3 --update=uuid
+mdadm -I ${container}2
+
+testdev ${member}_0 1 $size 1
+testdev ${member}_1 1 $size 1
diff --git a/tests/env-09imsm-assemble b/tests/env-09imsm-assemble
new file mode 100644
index 0000000..b12954b
--- /dev/null
+++ b/tests/env-09imsm-assemble
@@ -0,0 +1,32 @@
+imsm_check_hold() {
+   if mdadm --remove $1 $2; then
+       echo "$2 removal from $1 should have been blocked" >&2
+       cat /proc/mdstat >&2
+       mdadm -E $2
+       exit 1
+   fi
+}
+
+imsm_check_removal() {
+   if ! mdadm --remove $1 $2 ; then
+       echo "$2 removal from $1 should have succeeded" >&2
+       cat /proc/mdstat >&2
+       mdadm -E $2
+       exit 1
+   fi
+}
+
+setup_env() {
+	export IMSM_DEVNAME_AS_SERIAL=1
+	export IMSM_TEST_OROM=1
+	container=/dev/md/container
+	member=/dev/md/vol0
+}
+
+reset_env() {
+	unset IMSM_DEVNAME_AS_SERIAL
+	unset IMSM_TEST_OROM
+	unset imsm_check
+	unset container
+	unset member
+}

