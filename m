From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 12/14] Early reshape backup verification
Date: Fri, 16 Sep 2011 13:55:18 +0200
Message-ID: <20110916115518.5201.5649.stgit@gklab-128-013.igk.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

Ever reshape needs to backup its critical section. For this purposes
backup file or external metadata mechanisms can be used.

Add verification if backup file or metadata mechanisms can have chance
to restore data form backup.
For native metadata existence of passed (from command line) backup file
is checked. For external metadta manage_reshape() and recover_backup()
are tested for this purposes.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index fa22382..d54b8a8 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3667,6 +3667,18 @@ int Grow_continue_command(char *devname, int fd,
 			devname);
 		return 1;
 	}
+
+	/* request backup file
+	 * when no metadta specific backup action is defined
+	 */
+	if ((backup_file == NULL) &&
+	    ((st->ss->manage_reshape == NULL) ||
+	     (st->ss->recover_backup == NULL))) {
+		fprintf(stderr, Name ": Please provide backup file "
+			"for reshape continuation.\n");
+		return 1;
+	}
+
 	dprintf("Grow continue is run for ");
 	if (st->ss->external == 0) {
 		dprintf("native array (%s)\n", devname);

