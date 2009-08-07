From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] pending fixes for mdadm 3.0.1
Date: Fri, 7 Aug 2009 14:02:12 +1000
Message-ID: <19067.42820.630060.102559@notabene.brown>
References: <1249412514.19218.37.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday August 4
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jacek Danecki <jacek.danecki@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Hans de Goede <hdegoede@redhat.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Tuesday August 4, dan.j.williams@intel.com wrote:
> The following changes since commit fa09d4961e5c72da3c7f78d53a7d64f5196110a3:
>   NeilBrown (1):
>         Examine: fix --examine --brief --verbose on containers.
> 
> are available in the git repository at:
> 
>   git://github.com/djbw/mdadm.git master
> 
> Dan Williams (10):
>       teach imsm and ddf what st->subarray means at load_super time
>       fix RebuildMap() to retrieve 'subarray' info

Thanks.  I've pulled and pushed them all, but I'm not quite sure of
this one. 
What metadata information do we want to have in the map file?
The main use of the map file is for incremental assembly.  When we
find a device, the map file tells us which array/container to attach
the device to.
So subarrays probably aren't important in the map file and maybe
shouldn't be stored there at all???

What was the context where the current behaviour became an issue?
> 
> Hi Neil,
> 
> This is the same queue that was sent previously [1], but with a few
> additions:

Sorry I didn't respond to that - late June was a bad time for me :-(

> 
> 
> Lastly, I notice that there is a regression of sorts since commit
> fa09d496 "Examine: fix --examine --brief --verbose on containers".
> Changing the order of containers and members confuses mdadm -Asc, or -As
> when /etc/mdadm.conf is present.  We now only get the container, and no
> members in the multiple container case.  Unintended consequence?

Certainly unintended.  I guess I had forgotten that the order of
things in mdadm.conf is important.
Maybe the best approach would be for Examine.c to call in to the
metadata handler a second time to get the subarrays.

What would you think of something like the following?

Thanks,
NeilBrown

diff --git a/Examine.c b/Examine.c
index 02d5ac4..c79a701 100644
--- a/Examine.c
+++ b/Examine.c
@@ -145,6 +145,8 @@ int Examine(mddev_dev_t devlist, int brief, int export, int scan,
 					sep=',';
 				}
 			}
+			if (ap->st->ss->brief_examine_subarrays)
+				ap->st->ss->brief_examine_subarrays(ap->st, brief > 1);
 			ap->st->ss->free_super(ap->st);
 			/* FIXME free ap */
 			if (ap->spares || brief > 1)
diff --git a/mdadm.h b/mdadm.h
index 4111eaf..91ba624 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -436,6 +436,7 @@ extern struct superswitch {
 	 */
 	void (*examine_super)(struct supertype *st, char *homehost);
 	void (*brief_examine_super)(struct supertype *st, int verbose);
+	void (*brief_examine_subarrays)(struct supertype *st, int verbose);
 	void (*export_examine_super)(struct supertype *st);
 
 	/* Used to report details of an active array.
diff --git a/super-ddf.c b/super-ddf.c
index c28d804..9bf08c2 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1183,6 +1183,18 @@ static void brief_examine_super_ddf(struct supertype *st, int verbose)
 {
 	/* We just write a generic DDF ARRAY entry
 	 */
+	struct mdinfo info;
+	char nbuf[64];
+	getinfo_super_ddf(st, &info);
+	fname_from_uuid(st, &info, nbuf, ':');
+
+	printf("ARRAY metadata=ddf UUID=%s\n", nbuf + 5);
+}
+
+static void brief_examine_subarrays_ddf(struct supertype *st, int verbose)
+{
+	/* We just write a generic DDF ARRAY entry
+	 */
 	struct ddf_super *ddf = st->sb;
 	struct mdinfo info;
 	int i;
@@ -1203,7 +1215,6 @@ static void brief_examine_super_ddf(struct supertype *st, int verbose)
 		printf("ARRAY container=%s member=%d UUID=%s\n",
 		       nbuf+5, i, nbuf1+5);
 	}
-	printf("ARRAY metadata=ddf UUID=%s\n", nbuf + 5);
 }
 
 static void export_examine_super_ddf(struct supertype *st)
@@ -3597,6 +3608,7 @@ struct superswitch super_ddf = {
 #ifndef	MDASSEMBLE
 	.examine_super	= examine_super_ddf,
 	.brief_examine_super = brief_examine_super_ddf,
+	.brief_examine_subarrays = brief_examine_subarrays_ddf,
 	.export_examine_super = export_examine_super_ddf,
 	.detail_super	= detail_super_ddf,
 	.brief_detail_super = brief_detail_super_ddf,
diff --git a/super-intel.c b/super-intel.c
index dc0c9c0..782519e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -761,9 +761,7 @@ static void brief_examine_super_imsm(struct supertype *st, int verbose)
 	/* We just write a generic IMSM ARRAY entry */
 	struct mdinfo info;
 	char nbuf[64];
-	char nbuf1[64];
 	struct intel_super *super = st->sb;
-	int i;
 
 	if (!super->anchor->num_raid_devs) {
 		printf("ARRAY metadata=imsm\n");
@@ -772,6 +770,23 @@ static void brief_examine_super_imsm(struct supertype *st, int verbose)
 
 	getinfo_super_imsm(st, &info);
 	fname_from_uuid(st, &info, nbuf, ':');
+	printf("ARRAY metadata=imsm UUID=%s\n", nbuf + 5);
+}
+
+static void brief_examine_subarrays_imsm(struct supertype *st, int verbose)
+{
+	/* We just write a generic IMSM ARRAY entry */
+	struct mdinfo info;
+	char nbuf[64];
+	char nbuf1[64];
+	struct intel_super *super = st->sb;
+	int i;
+
+	if (!super->anchor->num_raid_devs)
+		return;
+
+	getinfo_super_imsm(st, &info);
+	fname_from_uuid(st, &info, nbuf, ':');
 	for (i = 0; i < super->anchor->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
 
@@ -781,7 +796,6 @@ static void brief_examine_super_imsm(struct supertype *st, int verbose)
 		printf("ARRAY /dev/md/%.16s container=%s member=%d UUID=%s\n",
 		       dev->volume, nbuf + 5, i, nbuf1 + 5);
 	}
-	printf("ARRAY metadata=imsm UUID=%s\n", nbuf + 5);
 }
 
 static void export_examine_super_imsm(struct supertype *st)
@@ -4554,6 +4568,7 @@ struct superswitch super_imsm = {
 #ifndef	MDASSEMBLE
 	.examine_super	= examine_super_imsm,
 	.brief_examine_super = brief_examine_super_imsm,
+	.brief_examine_subarrays = brief_examine_subarrays_imsm,
 	.export_examine_super = export_examine_super_imsm,
 	.detail_super	= detail_super_imsm,
 	.brief_detail_super = brief_detail_super_imsm,
