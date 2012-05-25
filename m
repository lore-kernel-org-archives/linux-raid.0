From: Jes.Sorensen@redhat.com
Subject: [PATCH 3/4] Improve --help message from test
Date: Fri, 25 May 2012 17:24:07 +0200
Message-ID: <1337959448-5299-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 test |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/test b/test
index a0561ab..8e06ae2 100755
--- a/test
+++ b/test
@@ -238,8 +238,15 @@ do_test() {
 }
 
 do_help() {
-  echo "Usage: "
-  echo " $0 [--tests=<test1,test2,..>] [--disable-multipath] [--logdir] [--save-logs] [--no-error] [setup] [prefix]"
+  echo "Usage: $0 [options]"
+  echo " Options:"
+  echo "    --tests=<test1,test2,..>    Comma separated list of tests to run"
+  echo "    --disable-multipath         Disable any tests involving multipath"
+  echo "    --logdir=<directory>        Directory to save logfiles in"
+  echo "    --save-logs                 Save all logs in <logdir>"
+  echo "    --no-error                  Don't stop on error, ie. run all tests"
+  echo "    setup                       Setup test environment and exit"
+  echo "    <prefix>                    Run tests with <prefix>"
 }
 
 parse_args() {
-- 
1.7.1

