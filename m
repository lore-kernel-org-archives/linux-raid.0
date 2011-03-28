From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Something wrong with __prep_thunderdome in super-intel.c
Date: Mon, 28 Mar 2011 09:56:49 -0700
Message-ID: <1301331409.5888.8.camel@dwillia2-linux>
References: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
	 <20110315085346.3bf9feb7@notabene.brown>
	 <905EDD02F158D948B186911EB64DB3D17A9910DD@irsmsx503.ger.corp.intel.com>
	 <20110322132307.34e9bb3b@notabene.brown>
	 <1301020846.15264.12.camel@dwillia2-linux>
	 <20110328123509.043555e7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110328123509.043555e7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
List-Id: linux-raid.ids

On Sun, 2011-03-27 at 18:35 -0700, NeilBrown wrote:
> On Thu, 24 Mar 2011 19:40:46 -0700 Dan Williams <dan.j.williams@intel.com>
> wrote:
> 
> > <context switch out of isci driver review mode>
> 
> :-)
> 
[..]
> > -	disk = get_imsm_disk(super, ord_to_idx(ord));
> > +	dl = get_imsm_dl_disk(super, ord_to_idx(ord));
> 
> This sometimes return NULL, leading to bad stuff and mdmon crashing....
> 
> So there is more to this than meets the eye...

Yes, (and I chalk this up to context switch latency), setting the index
to -2 is not correct as other paths need to be able to reference a valid
disk index until the failed device is removed via a rebuild.

> I'll stop trying this patch.

Ok, here is a proposed v2 on top of the latest devel-3.2, but I need to
play with it a bit more, and figure out what the spare migration test is
complaining about.

diff --git a/super-intel.c b/super-intel.c
index 6e12af2..e2f66aa 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3993,7 +3993,7 @@ static int write_super_imsm(struct supertype *st, int doclose)
 
 	/* write the mpb for disks that compose raid devices */
 	for (d = super->disks; d ; d = d->next) {
-		if (d->index < 0)
+		if (d->index < 0 || is_failed(&d->disk))
 			continue;
 		if (store_imsm_mpb(d->fd, mpb))
 			fprintf(stderr, "%s: failed for device %d:%d %s\n",
@@ -5218,6 +5218,8 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	__u32 ord;
 	int slot;
 	struct imsm_map *map;
+	char buf[MAX_RAID_SERIAL_LEN+3];
+	unsigned int len, shift = 0;
 
 	/* new failures are always set in map[0] */
 	map = get_imsm_map(dev, 0);
@@ -5230,6 +5232,11 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
 		return 0;
 
+	sprintf(buf, "%s:0", disk->serial);
+	if ((len = strlen(buf)) >= MAX_RAID_SERIAL_LEN)
+		shift = len - MAX_RAID_SERIAL_LEN + 1;
+	strncpy((char *)disk->serial, &buf[shift], MAX_RAID_SERIAL_LEN);
+
 	disk->status |= FAILED_DISK;
 	set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUILD);
 	if (map->failed_disk_num == 0xff)



