From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] md: Subject: introduce get_priority_stripe() to
	improve raid456 write performance
Date: Fri, 28 Mar 2008 12:33:39 -0700
Message-ID: <1206732819.29383.11.camel@dwillia2-linux.ch.intel.com>
References: <20080328164351.30557.patches@notabene>
	 <1080328054528.30605@suse.de>
	 <20080327232252.20764ac4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080327232252.20764ac4.akpm@linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2008-03-27 at 23:22 -0700, Andrew Morton wrote:
> On Fri, 28 Mar 2008 16:45:28 +1100 NeilBrown <neilb@suse.de> wrote:
> 
> > +static ssize_t
> > +raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t len)
> > +{
> > +     raid5_conf_t *conf = mddev_to_conf(mddev);
> > +     char *end;
> > +     int new;
> > +     if (len >= PAGE_SIZE)
> > +             return -EINVAL;
> > +     if (!conf)
> > +             return -ENODEV;
> > +
> > +     new = simple_strtoul(page, &end, 10);
> > +     if (!*page || (*end && *end != '\n'))
> > +             return -EINVAL;
> > +     if (new > conf->max_nr_stripes || new < 0)
> > +             return -EINVAL;
> > +     conf->bypass_threshold = new;
> > +     return len;
> > +}
> 
> checkpatch 0.16 (which I misfiled and have thus far failed to merge up)
> sayeth:
> 
> WARNING: consider using strict_strtoul in preference to simple_strtoul
> #258: FILE: drivers/md/raid5.c:4090:
> +       new = simple_strtoul(page, &end, 10);
> 
> the reason being that code which uses simple_strtoul() can treat
> "42-what-a-todo" as "42", which seems a bit sloppy.
> 
> Your code won't have that failing, because it explicitly checks that the
> input ended in \0 or \n.  But strict_strtoul() internally does that, so this
> open-coded test could be removed.

How about the following:
-------snip------>

Subject: md: raid5.c convert simple_strtoul to strict_strtoul

From: Dan Williams <dan.j.williams@intel.com>

strict_strtoul handles the open-coded sanity checks in
raid5_store_stripe_cache_size and raid5_store_preread_threshold

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bc39369..49f1265 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4034,15 +4034,13 @@ static ssize_t
 raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	char *end;
-	int new;
+	unsigned long new;
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
 	if (!conf)
 		return -ENODEV;
 
-	new = simple_strtoul(page, &end, 10);
-	if (!*page || (*end && *end != '\n') )
+	if (strict_strtoul(page, 10, &new))
 		return -EINVAL;
 	if (new <= 16 || new > 32768)
 		return -EINVAL;
@@ -4080,17 +4078,15 @@ static ssize_t
 raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t len)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	char *end;
-	int new;
+	unsigned long new;
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
 	if (!conf)
 		return -ENODEV;
 
-	new = simple_strtoul(page, &end, 10);
-	if (!*page || (*end && *end != '\n'))
+	if (strict_strtoul(page, 10, &new))
 		return -EINVAL;
-	if (new > conf->max_nr_stripes || new < 0)
+	if (new > conf->max_nr_stripes || (int) new < 0)
 		return -EINVAL;
 	conf->bypass_threshold = new;
 	return len;


