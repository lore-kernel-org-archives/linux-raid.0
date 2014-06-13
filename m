From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Subject: RE: [PATCH] Forbid merging with partially assembled IMSM array
Date: Fri, 13 Jun 2014 09:48:16 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F0792870C@IRSMSX105.ger.corp.intel.com>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918BDA@IRSMSX105.ger.corp.intel.com>
	<20140602121955.10a72b32@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0791C0DD@IRSMSX105.ger.corp.intel.com>
	<20140604123046.02e224d6@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0791D2DE@IRSMSX105.ger.corp.intel.com>
 <20140605162730.33e36f25@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140605162730.33e36f25@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

>On Thursday, June 05, 2014 8:28 AM NeilBrown [neilb@suse.de] wrote:
> To: Baldysiak, Pawel
> Cc: linux-raid@vger.kernel.org; Paszkiewicz, Artur
> Subject: Re: [PATCH] Forbid merging with partially assembled IMSM 
>array
> 
> On Wed, 4 Jun 2014 09:25:47 +0000 "Baldysiak, Pawel"
> <pawel.baldysiak@intel.com> wrote:
> 
> 
> > Hi Neil
> >
> > There are several cases where not forbidding this operation can 
> > cause
> problems.
> > For example, if user will create IMSM array at one platform, then 
> > stop it, detach devices, and hotplug them to another platform (mixed 
> > between two different controllers) - everything will be looking good 
> > (array
> will be incrementally assembled without any errors) until reboot.
> > After that, user will be confused why array is degraded/failed and 
> > will be at
> risk of losing data.
> > Also, creation of IMSM array under different controllers is 
> > forbidden, so
> there is no point in allowing that it in assemble process.
> >
> > If you really think this is no justification - I will prepare a 
> > patch that will print warning, but in my opinion this operation 
> > should be allowed
> only with "--force"...
> >
> 
> I came across a situation once where someone was trying to crash-dump 
> onto an IMSM array.  'crashdump' does some sort of kexec thing and 
> runs a very minimal kernel/installation  which just does crash dumps.
> 
> It didn't work because mdadm couldn't find the OpROM in that context 
> and so refused the assemble the array.
> I really don't like that sort of thing happening.
> If the OpROM is going to destroy your data (or whatever it does) when 
> you plug different devices into different controllers, then that is 
> the OpROM's problem, not mine.  I just want to make sure people can 
> get at their data in as many situations as possible.
> 
> 
> A warning is probably OK, though I wonder if anyone would ever see it.
> However the code would need improvement.
> Doing a strcmp for "imsm" is not acceptable.
> 
> I'm not even sure I understand what they rest of the code is trying to do.
> It doesn't seem to make reference to separate OpROMs....
> 
> NeilBrown
> 

Hi Neil,

Here is the patch that adds warning message.

Thanks
Pawel Baldysiak

From a0270724eb42e24a74508f5b0ec35afc64f17cf7 Mon Sep 17 00:00:00 2001
From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Date: Fri, 13 Jun 2014 10:55:19 +0200
Subject: [PATCH 1/1] IMSM: Add warning message when assemble spanned container

Due to several changes in code assemble with disks
spanned between different controllers can be obtained
in some cases. After IMSM container will be assembled, check HBA of
disks, and print proper warning if mismatch is detected.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Assemble.c       | 28 ++++++++++++++++++++++++++++
 platform-intel.h |  1 +
 2 files changed, 29 insertions(+)

diff --git a/Assemble.c b/Assemble.c
index 63e09ac..3542b16 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -23,6 +23,7 @@
  */
 
 #include	"mdadm.h"
+#include	"platform-intel.h"
 #include	<ctype.h>
 
 static int name_matches(char *found, char *required, char *homehost)
@@ -1001,6 +1002,33 @@ static int start_array(int mdfd,
 					content->array.raid_disks);
 			fprintf(stderr, "\n");
 		}
+		if (st->ss == &super_imsm && !check_env("IMSM_NO_PLATFORM")) {
+			struct sys_dev *idev;
+			char *hba_path = NULL;
+			char *dev_path = devt_to_devpath(makedev(devices->i.disk.major,
+					devices->i.disk.minor));
+
+			for (idev = find_intel_devices(); idev; idev = idev->next) {
+				if (strstr(dev_path, idev->path)) {
+					hba_path = idev->path;
+					break;
+				}
+			}
+			free(dev_path);
+
+			if (hba_path) {
+				for (i = 1; (unsigned)i < okcnt+sparecnt; i++) {
+					if (!devt_attached_to_hba(makedev(devices[i].i.disk.major,
+							devices[i].i.disk.minor), hba_path)) {
+						pr_err("WARNING - IMSM container assembled with disks "
+							"under different HBAs!\n"
+							"       This operation is not supported "
+							"and can lead to data loss.\n");
+						break;
+					}
+				}
+			}
+		}
 		st->ss->free_super(st);
 		sysfs_uevent(content, "change");
 		if (err_ok && okcnt < (unsigned)content->array.raid_disks)
diff --git a/platform-intel.h b/platform-intel.h
index bcd84b7..999a601 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -203,6 +203,7 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver);
 struct sys_dev *find_intel_devices(void);
 const struct imsm_orom *find_imsm_capability(enum sys_dev_type hba_id);
 const struct imsm_orom *find_imsm_orom(void);
+int devt_attached_to_hba(dev_t dev, const char *hba_path);
 int disk_attached_to_hba(int fd, const char *hba_path);
 char *devt_to_devpath(dev_t dev);
 int path_attached_to_hba(const char *disk_path, const char *hba_path);
-- 
1.9.3


> 
> 
> 
> > Thanks
> > Pawel Baldysiak
> >
> > >
> > > > You can always use "--force" to override this check.
> > > >
> > > > Pawel Baldysiak
> > > >
> > > > > >
> > > > > > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > > > > > Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> > > > > >
> > > > > > ---
> > > > > > Assemble.c | 23 +++++++++++++++++++++++
> > > > > > 1 file changed, 23 insertions(+)
> > > > > >
> > > > > > diff --git a/Assemble.c b/Assemble.c index a57d384..9fb65e5
> > > > > > 100644
> > > > > > --- a/Assemble.c
> > > > > > +++ b/Assemble.c
> > > > > > @@ -1329,6 +1329,29 @@ try_again:
> > > > > >                                                return 1;
> > > > > >                                }
> > > > > >                                for (dv = pre_exist->devs; 
> > > > > > dv; dv =
> > > > > > dv->next) {
> > > > > > +                                             if 
> > > > > > + (strncmp(mp->metadata, "imsm", 4) == 0 && !c-
> > > > > >force) {
> > > > > > +                                                             int dfd;
> > > > > > +                                                             char dn[20];
> > > > > > +                                                             struct supertype *st2;
> > > > > > +                                                             
> > > > > > + sprintf(dn, "%d:%d", dv-
> >disk.major,
> > > > > > +                                                                                             dv->disk.minor);
> > > > > > +                                                             st2 = dup_super(st);
> > > > > > +                                                             
> > > > > > + dfd = dev_open(dn, O_RDONLY);
> > > > > > +
> > > > > > + if ((dfd > 0) && (st2->ss->load_super(st2,
> > > > > dfd, NULL) ||
> > > > > > +
> > > > > > + (st->ss->compare_super(st, st2) !=
> > > 0))) {
> > > > > > +
> > > > > > + pr_err("IMSM metadata
> > > > > mismatch!\n");
> > > > > > +                                                                             pr_err("Aborting...\n");
> > > > > > +                                                                             
> > > > > > + close(dfd);
> > > > > > +
> > > > > > + } else {
> > > > > > +
> > > > > > + pr_err("IMSM Array already
> > > > > partially assembled!\n");
> > > > > > +                                                                             pr_err("Aborting...\n");
> > > > > > +                                                             }
> > > > > > +                                                             if (st2) {
> > > > > > +                                                                             st2->ss->free_super(st2);
> > > > > > +                                                                             free(st2);
> > > > > > +                                                             }
> > > > > > +                                                             return 1;
> > > > > > +                                             }
> > > > > >                                                /* We want to add this device to our list,
> > > > > >                                                 * but it could already be there if "mdadm -I"
> > > > > >                                                 * started *after* we checked for O_EXCL.
> > > > > > --
> > > > > > 1.9.0
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > > > in the body of a message to majordomo@vger.kernel.org More
> > > majordomo
> > > > info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
