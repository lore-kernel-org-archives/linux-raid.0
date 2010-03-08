From: Neil Brown <neilb@suse.de>
Subject: Re: Weird Issue with raid 5+0
Date: Mon, 8 Mar 2010 16:50:21 +1100
Message-ID: <20100308165021.6529fe6d@notabene.brown>
References: <31e44a111002202033m4a9dfba9yf8aef62b8b39933a@mail.gmail.com>
	<20100221164805.5bdc2d60@notabene.brown>
	<31e44a111002202326x407c814dsaa60e51a8a0ff049@mail.gmail.com>
	<20100221191640.39b68b01@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100221191640.39b68b01@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: chris <tknchris@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 21 Feb 2010 19:16:40 +1100
Neil Brown <neilb@suse.de> wrote:

> On Sun, 21 Feb 2010 02:26:42 -0500
> chris <tknchris@gmail.com> wrote:
> 
> > That is exactly what I didn't want to hear :( I am running
> > 2.6.26-2-xen-amd64. Are you sure its a kernel problem and nothing to
> > do with my chunk/block sizes? If this is a bug what versions are
> > affected, I'll build a new domU kernel and see if I can get it working
> > there.
> > 
> > - chris
> 
> I'm absolutely sure it is a kernel bug.

And I think I now know what the bug is.

A patch was recently posted to dm-devel which I think addresses exactly this
problem.

I reproduce it below.

NeilBrown

-------------------
If the lower device exposes a merge_bvec_fn,
dm_set_device_limits() restricts max_sectors
to PAGE_SIZE "just to be safe".

This is not sufficient, however.

If someone uses bio_add_page() to add 8 disjunct 512 byte partial
pages to a bio, it would succeed, but could still cross a border
of whatever restrictions are below us (e.g. raid10 stripe boundary).
An attempted bio_split() would not succeed, because bi_vcnt is 8.

One example that triggered this frequently is the xen io layer.

raid10_make_request bug: can't convert block across chunks or bigger than 64k 209265151 1

Signed-off-by: Lars <lars.ellenberg@linbit.com>


---
 drivers/md/dm-table.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4b22feb..c686ff4 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -515,14 +515,22 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 
 	/*
 	 * Check if merge fn is supported.
-	 * If not we'll force DM to use PAGE_SIZE or
+	 * If not we'll force DM to use single bio_vec of PAGE_SIZE or
 	 * smaller I/O, just to be safe.
 	 */
 
-	if (q->merge_bvec_fn && !ti->type->merge)
+	if (q->merge_bvec_fn && !ti->type->merge) {
 		limits->max_sectors =
 			min_not_zero(limits->max_sectors,
 				     (unsigned int) (PAGE_SIZE >> 9));
+		/* Restricting max_sectors is not enough.
+		 * If someone uses bio_add_page to add 8 disjunct 512 byte
+		 * partial pages to a bio, it would succeed,
+		 * but could still cross a border of whatever restrictions
+		 * are below us (e.g. raid0 stripe boundary).  An attempted
+		 * bio_split() would not succeed, because bi_vcnt is 8. */
+		limits->max_segments = 1;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
-- 
1.6.3.3
