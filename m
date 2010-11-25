From: Neil Brown <neilb@suse.de>
Subject: Re: Devel 3.2 branch issues
Date: Thu, 25 Nov 2010 19:01:52 +1100
Message-ID: <20101125190152.01d61cbd@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF03CC6@irsmsx504.ger.corp.intel.com>
	<20101123115213.3664ec27@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123115213.3664ec27@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Tue, 23 Nov 2010 11:52:13 +1100 Neil Brown <neilb@suse.de> wrote:

> On Mon, 22 Nov 2010 22:39:00 +0000
> "Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:
> 
> > 
> > > by the way, some of the changes in you of the patches you sent have not
> > > been
> > > included in any form.  They include:
> > > 
> > > - the getinfo_super_disks method.  I couldn't see why you need this.
> > > All the
> > >   info about the state of the arrays should already be available.
> > >   If there is something that you need that we don't have, please
> > > explain and
> > >   we can see how best to add it back in.
> > 
> > Marcin has already answered this but here is my explanation.
> > Current test devstate[i]==0 is always true for container so any device seems a good candidate to move.
> > To be able to identify members, failed devices and real spares we updated devstate for containers.
> > To find members we can just check which disks are used in subarrays, but a failed disk is removed from subarray after a short while and as soon as it happens we are not able to see a difference between the failed disk and a spare unless we look at metadata. 
> 
> Thanks.  That makes sense.  I'll look at the code and see about applying it.
> 

OK, I have something, though I haven't tested it.

It uses your getinfo_super_disks and does the following to choose a spare
from an external array.  There are a couple of rearrangement patches before
this so it won't apply as-it, but should appear in my devel-3.2 within a few
hours.

NeilBrown

commit 5739e0d007a3eea80f5108d73d444751dbbde1ef
Author: NeilBrown <neilb@suse.de>
Date:   Thu Nov 25 18:58:27 2010 +1100

    Monitor: choose spare correctly for external metadata.
    
    When metadata is managed externally - probably as a container - we
    need to examine that metadata to see which devices are spares.
    
    So use the getinfo_super_disk message and use the info returned.
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Monitor.c b/Monitor.c
index 5fc18d1..9ba49f2 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -798,6 +798,63 @@ static int choose_spare(struct state *from, struct state *to,
 	return dev;
 }
 
+static int container_choose_spare(struct state *from, struct state *to,
+				  struct domainlist *domlist)
+{
+	/* This is similar to choose_spare, but we cannot trust devstate,
+	 * so we need to read the metadata instead
+	 */
+
+	struct supertype *st = from->metadata;
+	int fd = open(st->devname, O_RDONLY);
+	int err;
+	struct mdinfo *disks, *d;
+	unsigned long long min_size
+		= min_spare_size_required(to);
+	int dev;
+
+	if (fd < 0)
+		return 0;
+	if (!st->ss->getinfo_super_disks)
+		return 0;
+	
+	err = st->ss->load_container(st, fd, NULL);
+	close(fd);
+	if (err)
+		return 0;
+
+	disks = st->ss->getinfo_super_disks(st);
+	st->ss->free_super(st);
+
+	if (!disks)
+		return 0;
+	
+	for (d = disks->devs ; d && !dev ; d = d->next) {
+		if (d->disk.state == 0) {
+			struct dev_policy *pol;
+			unsigned long long dev_size;
+			dev = makedev(d->disk.major,d->disk.minor);
+			
+			if (min_size &&
+			    dev_size_from_id(dev,  &dev_size) &&
+			    dev_size < min_size)
+				continue;
+
+			pol = devnum_policy(dev);
+			if (from->spare_group)
+				pol_add(&pol, pol_domain,
+					from->spare_group, NULL);
+			if (!domain_test(domlist, pol, to->metadata->ss->name))
+				dev = 0;
+			
+			dev_policy_free(pol);
+		}
+	}
+	sysfs_free(disks);
+	return dev;
+}
+
+
 static void try_spare_migration(struct state *statelist, struct alert_info *info)
 {
 	struct state *from;
@@ -827,7 +884,11 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 				int devid;
 				if (!check_donor(from, to, domlist))
 					continue;
-				devid = choose_spare(from, to, domlist);
+				if (from->metadata->ss->external)
+					devid = container_choose_spare(
+						from, to, domlist);
+				else
+					devid = choose_spare(from, to, domlist);
 				if (devid > 0
 				    && move_spare(from, to, devid, info))
 						break;
