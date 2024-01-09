Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950273F8C8
	for <linux-raid@vger.kernel.org>; Tue,  9 Jan 2024 23:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jmlp7krz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4D4C433F1;
	Tue,  9 Jan 2024 23:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704841671;
	bh=6YH5pCeWleGaoDttPiZxbfa3y0xz7uMwGMlhbx6z3To=;
	h=From:To:Cc:Subject:Date:From;
	b=Jmlp7krz+JVboChNnP0RcGOAUuJ5Rul0Z0L0Z3hYyJa4DsnzdIox1C7VBb4n9JZac
	 dhqq0g6/JPWymsD16jkslO1Vt2Q6Xt4OnDp1KwOLxiMgjaXBuHM2P2z8IxZBoyCdvL
	 NfEdMsAFfnOlYbthIf4ayWgxhT1TTBTgg4z3g8sMx2cnKaHbceY2gF/XCNkbRg8M/9
	 XB3HtYm6cH20atOQ6kbnpG/+6y9NbOtj3mPRiS3a+GXixRfrm8FM8eIcwjQgx2D+8l
	 u4fwCL9lx9l6h/BvDLKgrg60RrPJ8Tk5bBW4eaVuEUVIS8z1FiQavCH2GFJTaUMFfT
	 XPBwjWhIxzJdQ==
From: Song Liu <song@kernel.org>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org,
	Song Liu <song@kernel.org>
Subject: [PATCH v2 mdadm] tests: Gate tests for linear flavor with variable LINEAR
Date: Tue,  9 Jan 2024 15:07:16 -0800
Message-Id: <20240109230716.2433929-1-song@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

linear flavor is being removed in the kernel [1], so tests for the linear
flavor will fail. Add detection for linear flavor and --disable-linear
option, with the same logic as multipath.

[1] https://lore.kernel.org/linux-raid/20231214222107.2016042-1-song@kernel.org/
Signed-off-by: Song Liu <song@kernel.org>
---
 test               |  4 ++++
 tests/00linear     |  5 +++++
 tests/00names      |  8 +++++++-
 tests/00raid0      |  4 ++++
 tests/00readonly   |  8 +++++++-
 tests/02lineargrow |  5 +++++
 tests/03assem-incr |  8 +++++++-
 tests/03r0assem    |  4 ++++
 tests/04r0update   |  6 ++++++
 tests/func.sh      | 11 +++++++++++
 10 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/test b/test
index b244453b1cec..49a36c3b8ef2 100755
--- a/test
+++ b/test
@@ -140,6 +140,7 @@ do_help() {
 		--raidtype=                 raid0|linear|raid1|raid456|raid10|ddf|imsm
 		--disable-multipath         Disable any tests involving multipath
 		--disable-integrity         Disable slow tests of RAID[56] consistency
+		--disable-linear            Disable any tests involving linear
 		--logdir=directory          Directory to save all logfiles in
 		--save-logs                 Usually use with --logdir together
 		--keep-going | --no-error   Don't stop on error, ie. run all tests
@@ -255,6 +256,9 @@ parse_args() {
 		--disable-integrity )
 			unset INTEGRITY
 			;;
+		--disable-linear )
+			unset LINEAR
+			;;
 		--dev=* )
 			case ${i##*=} in
 			loop )
diff --git a/tests/00linear b/tests/00linear
index e3ac6555c9dd..5a1160851af2 100644
--- a/tests/00linear
+++ b/tests/00linear
@@ -1,6 +1,11 @@
 
 # create a simple linear
 
+if [ "$LINEAR" != "yes" ]; then
+  echo -ne 'skipping... '
+  exit 0
+fi
+
 mdadm -CR $md0 -l linear -n3 $dev0 $dev1 $dev2
 check linear
 testdev $md0 3 $mdsize2_l 1
diff --git a/tests/00names b/tests/00names
index 7a066d8fb2b7..d996befc5e8b 100644
--- a/tests/00names
+++ b/tests/00names
@@ -4,7 +4,13 @@ set -x -e
 conf=$targetdir/mdadm.conf
 echo "CREATE names=yes" > $conf
 
-for i in linear raid0 raid1 raid4 raid5 raid6
+levels=(raid0 raid1 raid4 raid5 raid6)
+
+if [ "$LINEAR" == "yes" ]; then
+  levels+=( linear )
+fi
+
+for i in ${levels[@]}
 do
   mdadm -CR --config $conf /dev/md/$i -l $i -n 4 $dev4 $dev3 $dev2 $dev1
   check $i
diff --git a/tests/00raid0 b/tests/00raid0
index 9b8896cbdc52..6407c320fd65 100644
--- a/tests/00raid0
+++ b/tests/00raid0
@@ -16,6 +16,10 @@ check raid0
 testdev $md0 5 $size 512
 mdadm -S $md0
 
+if [ "$LINEAR" != "yes" ]; then
+  echo -ne 'skipping... '
+  exit 0
+fi
 
 # now same again with different chunk size
 for chunk in 4 32 256
diff --git a/tests/00readonly b/tests/00readonly
index afe243b3a0b0..80b63629e4f9 100644
--- a/tests/00readonly
+++ b/tests/00readonly
@@ -1,8 +1,14 @@
 #!/bin/bash
 
+levels=(raid0 raid1 raid4 raid5 raid6 raid10)
+
+if [ "$LINEAR" == "yes" ]; then
+  levels+=( linear )
+fi
+
 for metadata in 0.9 1.0 1.1 1.2
 do
-	for level in linear raid0 raid1 raid4 raid5 raid6 raid10
+	for level in ${levels[@]}
 	do
 		if [[ $metadata == "0.9" && $level == "raid0" ]];
 		then
diff --git a/tests/02lineargrow b/tests/02lineargrow
index 595bf9f20802..d17e2326d13f 100644
--- a/tests/02lineargrow
+++ b/tests/02lineargrow
@@ -1,6 +1,11 @@
 
 # create a liner array, and add more drives to to.
 
+if [ "$LINEAR" != "yes" ]; then
+  echo -ne 'skipping... '
+  exit 0
+fi
+
 for e in 0.90 1 1.1 1.2
 do
   case $e in
diff --git a/tests/03assem-incr b/tests/03assem-incr
index f10a1a48ee5c..38880a7fed10 100644
--- a/tests/03assem-incr
+++ b/tests/03assem-incr
@@ -6,7 +6,13 @@ set -x -e
 # Here just test that a partly "-I" assembled array can
 # be completed with "-A"
 
-for l in 0 1 5 linear
+levels=(raid0 raid1 raid5)
+
+if [ "$LINEAR" == "yes" ]; then
+  levels+=( linear )
+fi
+
+for l in ${levels[@]}
 do
   mdadm -CR $md0 -l $l -n5 $dev0 $dev1 $dev2 $dev3 $dev4 --assume-clean
   mdadm -S md0
diff --git a/tests/03r0assem b/tests/03r0assem
index 44df06456233..f7c29e8c1ab6 100644
--- a/tests/03r0assem
+++ b/tests/03r0assem
@@ -64,6 +64,10 @@ mdadm --assemble --scan --config=$conf $md2
 $tst
 mdadm -S $md2
 
+if [ "$LINEAR" != "yes" ]; then
+  echo -ne 'skipping... '
+  exit 0
+fi
 
 ### Now for version 0...
 
diff --git a/tests/04r0update b/tests/04r0update
index b95efb06c761..c495f34a0a79 100644
--- a/tests/04r0update
+++ b/tests/04r0update
@@ -1,5 +1,11 @@
 
 # create a raid0, re-assemble with a different super-minor
+
+if [ "$LINEAR" != "yes" ]; then
+  echo -ne 'skipping... '
+  exit 0
+fi
+
 mdadm -CR -e 0.90 $md0 -llinear -n3 $dev0 $dev1 $dev2
 testdev $md0 3 $mdsize0 1
 minor1=`mdadm -E $dev0 | sed -n -e 's/.*Preferred Minor : //p'`
diff --git a/tests/func.sh b/tests/func.sh
index 5053b0121f1d..1c1a28a2a9c8 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -123,6 +123,17 @@ check_env() {
 	modprobe multipath 2> /dev/null
 	grep -sq 'Personalities : .*multipath' /proc/mdstat &&
 		MULTIPATH="yes"
+	if [ "$MULTIPATH" != "yes" ]; then
+		echo "test: skipping tests for multipath, which is removed in upstream 6.8+ kernels"
+	fi
+
+	# Check whether to run linear tests
+	modprobe linear 2> /dev/null
+	grep -sq 'Personalities : .*linear' /proc/mdstat &&
+		LINEAR="yes"
+	if [ "$LINEAR" != "yes" ]; then
+		echo "test: skipping tests for linear, which is removed in upstream 6.8+ kernels"
+	fi
 }
 
 do_setup() {
-- 
2.34.1

