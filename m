From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 01/13] imsm: catch attempt to auto-layout zero-length arrays
Date: Tue, 22 Dec 2009 16:59:24 -0700
Message-ID: <20091222235924.31628.63038.stgit@dwillia2-linux.ch.intel.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

When -z is omitted reserve_space() looks to satisfy a zero length
allocation which lo and behold is equal to the amount of free space on a
full disk.  So, catch maxsize == 0 and simplify the return value from
merge_extents() to always equal amount of free space (no benefit to
having a special case ~0ULL == error).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 super-intel.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2e119f8..6fe5e0d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3333,7 +3333,7 @@ static unsigned long long merge_extents(struct intel_super *super, int sum_exten
 	unsigned long reserve;
 
 	if (!e)
-		return ~0ULL; /* error */
+		return 0;
 
 	/* coalesce and sort all extents. also, check to see if we need to
 	 * reserve space between member arrays
@@ -3376,17 +3376,23 @@ static unsigned long long merge_extents(struct intel_super *super, int sum_exten
 	} while (e[i-1].size);
 	free(e);
 
+	if (maxsize == 0)
+		return 0;
+
+	/* FIXME assumes volume at offset 0 is the first volume in a
+	 * container
+	 */
 	if (start_extent > 0)
 		reserve = IMSM_RESERVED_SECTORS; /* gap between raid regions */
 	else
 		reserve = 0;
 
 	if (maxsize < reserve)
-		return ~0ULL;
+		return 0;
 
 	super->create_offset = ~((__u32) 0);
 	if (start + reserve > super->create_offset)
-		return ~0ULL; /* start overflows create_offset */
+		return 0; /* start overflows create_offset */
 	super->create_offset = start + reserve;
 
 	return maxsize - reserve;
@@ -3569,15 +3575,11 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 			i += dl->extent_cnt;
 
 	maxsize = merge_extents(super, i);
-	if (maxsize < size) {
+	if (maxsize < size || maxsize == 0) {
 		if (verbose)
 			fprintf(stderr, Name ": not enough space after merge (%llu < %llu)\n",
 				maxsize, size);
 		return 0;
-	} else if (maxsize == ~0ULL) {
-		if (verbose)
-			fprintf(stderr, Name ": failed to merge %d extents\n", i);
-		return 0;
 	}
 
 	*freesize = maxsize;
@@ -3634,7 +3636,8 @@ static int reserve_space(struct supertype *st, int raiddisks,
 
 	if (cnt < raiddisks ||
 	    (super->orom && used && used != raiddisks) ||
-	    maxsize < minsize) {
+	    maxsize < minsize ||
+	    maxsize == 0) {
 		fprintf(stderr, Name ": not enough devices with space to create array.\n");
 		return 0; /* No enough free spaces large enough */
 	}

