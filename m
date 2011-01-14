From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: open_dev_excl in reshape_container() fails
Date: Fri, 14 Jan 2011 10:36:04 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176E5A6CF@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D176E5A1BC@irsmsx503.ger.corp.intel.com>
 <AANLkTinKyBbX7S-yaM_FG=HU0ABuAzw+FxaUgdZPzy0Q@mail.gmail.com>
 <905EDD02F158D948B186911EB64DB3D176E5A4CA@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176E5A4CA@irsmsx503.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hi, 

I think I've found problem root cause.
As I'm working on "Online Capacity Expansion", my tests uses mounted arrays - this is in conflict with open_dev_ext()
and fails this function. Evrything is ok  This means that reshape operation cannot be performed online (or this is valid on my system only?).

I do not know why on begin (in main() of mdadm.c) this function can succeed and later not (later system blocks array ?).
More, when I've made some open_dev_exe()+close() earlier, it works later also (please look used code below/treat patch as demo/).

Summarizing problem is related to mounted arrays only.

BR
Adam


From cf545d2ffb906096da89aff7b1a5c5830221cc4a Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Fri, 14 Jan 2011 11:11:19 +0100
Subject: [PATCH] ADK: open workaround 2


Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c  |   17 +++++++++++++++++
 mdadm.c |   11 +++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 763287b..3b37f97 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1285,6 +1285,10 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 
 	struct mdinfo info;
 	struct mdinfo *sra;
+//adk
+	int fd_test = open_dev_excl(126);
+	if (fd_test >= 0)
+		close(fd_test);
 
 	if (ioctl(fd, GET_ARRAY_INFO, &array) < 0) {
 		fprintf(stderr, Name ": %s is not an active md array - aborting\n",
@@ -1319,6 +1323,10 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			" beyond %d\n", st->max_devs);
 		return 1;
 	}
+//adk
+	fd_test = open_dev_excl(126);
+	if (fd_test >= 0)
+		close(fd_test);
 
 	/* in the external case we need to check that the requested reshape is
 	 * supported, and perform an initial check that the container holds the
@@ -1394,6 +1402,10 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			" be reshaped\n", devname);
 		return 1;
 	}
+//adk
+	fd_test = open_dev_excl(126);
+	if (fd_test >= 0)
+		close(fd_test);
 
 	/* ========= set size =============== */
 	if (size >= 0 && (size == 0 || size != array.size)) {
@@ -1462,6 +1474,10 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			goto release;
 		}
 	}
+//adk
+	fd_test = open_dev_excl(126);
+	if (fd_test >= 0)
+		close(fd_test);
 
 	info.array = array;
 	sysfs_init(&info, fd, NoMdDev);
@@ -1545,6 +1561,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 * number of devices (On-Line Capacity Expansion) must be
 		 * performed at the level of the container
 		 */
+
 		rv = reshape_container(container, fd, devname, st, &info,
 				       force, backup_file, quiet);
 		frozen = 0;
diff --git a/mdadm.c b/mdadm.c
index 2ffe94f..bc9d34e 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -127,6 +127,7 @@ int main(int argc, char *argv[])
 	ident.name[0] = 0;
 	ident.container = NULL;
 	ident.member = NULL;
+//adk - can open
 
 	while ((option_index = -1) ,
 	       (opt=getopt_long(argc, argv,
@@ -134,6 +135,11 @@ int main(int argc, char *argv[])
 				&option_index)) != -1) {
 		int newmode = mode;
 		/* firstly, some mode-independent options */
+//adk
+		int fd_test = open_dev_excl(126);
+		if (fd_test >= 0)
+			close(fd_test);
+
 		switch(opt) {
 		case HelpOptions:
 			print_help = 2;
@@ -1115,6 +1121,11 @@ int main(int argc, char *argv[])
 			exit(2);
 		}
 		if (mode == MANAGE || mode == GROW) {
+//adk
+			int fd_test = open_dev_excl(126);
+			if (fd_test >= 0)
+				close(fd_test);
+
 			mdfd = open_mddev(devlist->devname, 1);
 			if (mdfd < 0)
 				exit(1);
-- 
1.6.0.2




> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Kwolek, Adam
> Sent: Friday, January 14, 2011 8:32 AM
> To: Williams, Dan J
> Cc: neilb@suse.de; linux-raid@vger.kernel.org; Neubauer, Wojciech;
> Ciechanowski, Ed
> Subject: RE: open_dev_excl in reshape_container() fails
> 
> 
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Dan Williams
> > Sent: Thursday, January 13, 2011 6:28 PM
> > To: Kwolek, Adam
> > Cc: neilb@suse.de; linux-raid@vger.kernel.org; Neubauer, Wojciech;
> > Ciechanowski, Ed
> > Subject: Re: open_dev_excl in reshape_container() fails
> >
> > 2011/1/13 Kwolek, Adam <adam.kwolek@intel.com>:
> > > Hi,
> > >
> > > I've got a problem using open_dev_excl() in reshape_container(), it
> > fails. This functions goes down
> > > and calls open() with flags O_DIRECT| O_RDWR| O_EXCL.
> > > It fails in reshape_container(), ealier in Grow_reshape() exactly
> the
> > same test call to open_dev_excl() succeed.
> > > Between test open and open in reshape_container() there is no other
> > open() performed (or other i/o operation that can cause problem).
> > > It not depends on mdmon action because it is the same for raid5 and
> > raid0.
> > > Function open_dev() works, and I'm using it as workaround.
> > >
> > > In man pages for open() is told that O_EXCL flag should be used
> with
> > O_CREAT flag only.
> > > I've read in manual for open() also: "If O_EXCL is set and O_CREAT
> is
> > not set, the result is undefined"
> >
> > Right, it is undefined with respect to Posix, but for Linux O_EXCL on
> > a block device without O_CREAT is defined to bd_claim the block
> > device.
> >
> > http://www.kernel.org/doc/man-pages/online/pages/man2/open.2.html
> >
> > The second call to open_dev_excl is a bug, by definition you can't
> > exclusive open twice.  Can you reuse the fd established in
> > Grow_reshape?
> >
> > --
> > Dan
> 
> There is no second open. My test call to open_dev_excl() is closed at
> once ;),
> and it is used to detect where I can successfully open device and if
> there is any duplicated open.
> There is no other open that can block open_dev_excl() in
> reshape_container() (when monitor is absent also),
> or I was unable to find it.
> Handle cannot be reused, because in Grow_reshape() container is opened
> and in reshape_container() all arrays
> Are opened one by one.
> 
> BR
> Adam
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
