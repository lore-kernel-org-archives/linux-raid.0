From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 1/2] Incremental: return success in 'container not
	enough' case
Date: Tue, 10 Aug 2010 09:46:43 -0700
Message-ID: <20100810164643.26691.14548.stgit@localhost.localdomain>
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

Commit 97b4d0e9 "Incremental: honor an 'enough' flag from external
handlers" introduced a regression in that it changed the error return
code for successful invocations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Incremental.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index a8a072d..e4b6196 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -264,7 +264,7 @@ int Incremental(char *devname, int verbose, int runstop,
 		else {
 			if (verbose)
 				fprintf(stderr, Name ": not enough devices to start the container\n");
-			return 1;
+			return 0;
 		}
 
 		/* This is a pre-built container array, so we do something

