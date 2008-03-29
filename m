From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] md: Subject: introduce get_priority_stripe() to     
	improve raid456 write performance
Date: Sat, 29 Mar 2008 09:33:22 -0700
Message-ID: <1206808402.28946.6.camel@dwillia2-linux.ch.intel.com>
References: <20080328164351.30557.patches@notabene>
	 <1080328054528.30605@suse.de>
	 <20080327232252.20764ac4.akpm@linux-foundation.org>
	 <1206732819.29383.11.camel@dwillia2-linux.ch.intel.com>
	 <39784.192.168.1.70.1206738637.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <39784.192.168.1.70.1206738637.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2008-03-28 at 14:10 -0700, NeilBrown wrote:
> On Sat, March 29, 2008 6:33 am, Dan Williams wrote:
> >  raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t
> > len)
> >  {
> >       raid5_conf_t *conf = mddev_to_conf(mddev);
> > -     char *end;
> > -     int new;
> > +     unsigned long new;
> >       if (len >= PAGE_SIZE)
> >               return -EINVAL;
> >       if (!conf)
> >               return -ENODEV;
> >
> > -     new = simple_strtoul(page, &end, 10);
> > -     if (!*page || (*end && *end != '\n'))
> > +     if (strict_strtoul(page, 10, &new))
> >               return -EINVAL;
> > -     if (new > conf->max_nr_stripes || new < 0)
> > +     if (new > conf->max_nr_stripes || (int) new < 0)
> 
> I had suggested that "new < 0" test when I saw that 'new' was an 'int'.
> A better suggestion would have been to make 'new' 'unsigned'.
> Now that you have done that, the "< 0" it pointless and
> should go.

Yeah, ->max_nr_stripes will always be less than (1 << 63).

> Otherwise
>   Acked-By: NeilBrown <neilb@suse.de>

Thanks, new patch follows,
Dan

------snip------>
Subject: md: raid5.c convert simple_strtoul to strict_strtoul

From: Dan Williams <dan.j.williams@intel.com>

strict_strtoul handles the open-coded sanity checks in
raid5_store_stripe_cache_size and raid5_store_preread_threshold

Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bc39369..e43e27a 100644
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
+	if (new > conf->max_nr_stripes)
 		return -EINVAL;
 	conf->bypass_threshold = new;
 	return len;


