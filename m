From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Booting from partitioned raid,  do_mounts_md.c patch (was: Re: Partitioned raid and major number)
Date: Wed, 10 Mar 2004 13:36:23 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16462.32551.605611.601873@notabene.cse.unsw.edu.au>
References: <20040225145624.GA1513@cistron.nl>
	<16445.12026.812778.621025@notabene.cse.unsw.edu.au>
	<20040226215144.GC11831@drinkel.cistron.nl>
	<16446.36226.591283.495194@notabene.cse.unsw.edu.au>
	<16446.39583.968782.41221@notabene.cse.unsw.edu.au>
	<20040309164623.GO3084@traveler.cistron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Miquel van Smoorenburg on Tuesday March 9
To: Andrew Morton <akpm@odsl.org>, Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 9, miquels@cistron.nl wrote:
> > 
> > Sorry, that patch was wrong.
> > This one, ontop of the original patch, works for me (I finally got
> > around to testing it).
> > 
> > 
> >  ----------- Diffstat output ------------
> >  ./drivers/md/md.c     |    2 +-
> >  ./init/do_mounts_md.c |    9 ++++++++-
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff ./drivers/md/md.c~current~ ./drivers/md/md.c
> > diff ./init/do_mounts_md.c~current~ ./init/do_mounts_md.c
> 
> I've tested this a lot as well, and it works fine. On my supermicro 1U test
> machine I can now pull out one of the two disks, and the machine still boots.
> I can even take out disk2, insert disk1 in the slot for disk2 and it
> still boots. Which is pretty cool ;)
> 
> I didn't see this in -rc2-mm1 yet - is this going to be submitted to -mm soon ?
> 

Thanks for reminding me.

Andrew: please include this patch which completes the change started
by "md-array-assembly-fix".

Thanks,
NeilBrown


----------------------------------------------------
Make sure correct major is used when assembling partitioned md arrays from boot parameters.

We need to make mdp_major available to do_mounts_md.c, and use it
there.

 ----------- Diffstat output ------------
 ./drivers/md/md.c     |    2 +-
 ./init/do_mounts_md.c |    9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-02-28 11:19:17.000000000 +1100
+++ ./drivers/md/md.c	2004-02-28 11:19:17.000000000 +1100
@@ -1450,7 +1450,7 @@ abort:
 	return 1;
 }
 
-static int mdp_major = 0;
+int mdp_major = 0;
 
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
 {

diff ./init/do_mounts_md.c~current~ ./init/do_mounts_md.c
--- ./init/do_mounts_md.c~current~	2004-02-28 11:19:17.000000000 +1100
+++ ./init/do_mounts_md.c	2004-02-28 11:19:17.000000000 +1100
@@ -24,6 +24,7 @@ static struct {
 
 static int md_setup_ents __initdata;
 
+extern int mdp_major;
 /*
  * Parse the command-line parameters given our kernel, but do not
  * actually try to invoke the MD device now; that is handled by
@@ -115,6 +116,8 @@ static int __init md_setup(char *str)
 	return 1;
 }
 
+#define MdpMinorShift 6
+
 static void __init md_setup_drive(void)
 {
 	int minor, i, ent, partitioned;
@@ -134,7 +137,11 @@ static void __init md_setup_drive(void)
 
 		sprintf(name, "/dev/md%s%d", partitioned?"_d":"", minor);
 		sprintf(devfs_name, "/dev/md/%s%d", partitioned?"d":"", minor);
-		create_dev(name, MKDEV(MD_MAJOR, minor), devfs_name);
+		if (partitioned)
+			dev = MKDEV(mdp_major, minor << MdpMinorShift);
+		else
+			dev = MKDEV(MD_MAJOR, minor);
+		create_dev(name, dev, devfs_name);
 		for (i = 0; i < MD_SB_DISKS && devname != 0; i++) {
 			char *p;
 			char comp_name[64];

