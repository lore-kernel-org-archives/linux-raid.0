From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH]  DM RAID:  Ensure the bitmap region_size is a power of 2
Date: Wed, 12 Dec 2012 08:53:32 -0600
Message-ID: <1355324012.26828.9.camel@f16>
References: <1355261825.26828.6.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1355261825.26828.6.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids

This is probably a better way to do it...

 brassow

DM RAID:  Ensure the bitmap region_size is a power of 2

If the user does not supply a region_size, a reasonable size is computed
automatically.  However, region_size needs to be a power of 2 and the
code was not properly ensuring that.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -295,9 +295,11 @@ static int validate_region_size(struct r
 		 * Choose a reasonable default.  All figures in sectors.
 		 */
 		if (min_region_size > (1 << 13)) {
+			/* If not a power of 2, make it the next power of 2 */
+			if (min_region_size & (min_region_size - 1))
+				region_size = 1 << fls(region_size);
 			DMINFO("Choosing default region size of %lu sectors",
 			       region_size);
-			region_size = min_region_size;
 		} else {
 			DMINFO("Choosing default region size of 4MiB");
 			region_size = 1 << 13; /* sectors */


