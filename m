From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 2/2] Incremental: accept '--no-degraded' as a deprecated
	option
Date: Tue, 10 Aug 2010 09:46:48 -0700
Message-ID: <20100810164648.26691.16684.stgit@localhost.localdomain>
References: <20100810164551.26691.17944.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100810164551.26691.17944.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Commit 3288b419 (Revert "Incremental: honor --no-degraded to delay assembly")
killed the --no-degraded flag since commit 97b4d0e9 (Incremental: honor
an 'enough' flag from external handlers) made this the default behavior
of -I, and brought -I usage for external/container formats in line with
native metadata.  However, this breaks existing usages of '-I
--no-degraded', so allow it as a deprecated option.

Starting a degraded container, like the native metadata case, requires -R.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mdadm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index 20a5638..08e8ea4 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -691,6 +691,8 @@ int main(int argc, char *argv[])
 		"     'summaries', 'homehost', 'byteorder', 'devicesize'.\n");
 			exit(outf == stdout ? 0 : 2);
 
+		case O(INCREMENTAL,NoDegraded):
+			fprintf(stderr, Name ": --no-degraded is deprecated in Incremental mode\n");
 		case O(ASSEMBLE,NoDegraded): /* --no-degraded */
 			runstop = -1; /* --stop isn't allowed for --assemble,
 				       * so we overload slightly */

