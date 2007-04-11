From: Greg KH <gregkh@suse.de>
Subject: [patch 11/31] Fix calculation for size of filemap_attr array in
	md/bitmap.
Date: Wed, 11 Apr 2007 15:51:52 -0700
Message-ID: <20070411225152.GL24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename="fix-calculation-for-size-of-filemap_attr-array-in-md-bitmap.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, Reuben Farrelly <reuben-linuxkernel@reub.net>
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Neil Brown <neilb@suse.de>

If 'num_pages' were ever 1 more than a multiple of 8 (32bit platforms)
for of 16 (64 bit platforms). filemap_attr would be allocated one
'unsigned long' shorter than required.  We need a round-up in there.


Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/bitmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -863,9 +863,7 @@ static int bitmap_init_from_disk(struct 
 
 	/* We need 4 bits per page, rounded up to a multiple of sizeof(unsigned long) */
 	bitmap->filemap_attr = kzalloc(
-		(((num_pages*4/8)+sizeof(unsigned long)-1)
-		 /sizeof(unsigned long))
-		*sizeof(unsigned long),
+		roundup( DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
 		GFP_KERNEL);
 	if (!bitmap->filemap_attr)
 		goto out;

-- 
