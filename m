From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Partitioned raid and major number
Date: Fri, 27 Feb 2004 12:17:19 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16446.39583.968782.41221@notabene.cse.unsw.edu.au>
References: <20040225145624.GA1513@cistron.nl>
	<16445.12026.812778.621025@notabene.cse.unsw.edu.au>
	<20040226215144.GC11831@drinkel.cistron.nl>
	<16446.36226.591283.495194@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Friday February 27
To: Miquel van Smoorenburg <miquels@cistron.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 27, neilb@cse.unsw.edu.au wrote:
> 
> Right.  I missed a bit in the patch.
> (I assume you are still wanting to boot off /dev/sda until you copy
> the data into /dev/md/d0p* - then you will use root=/dev/md_d0p1)

Sorry, that patch was wrong.
This one, ontop of the original patch, works for me (I finally got
around to testing it).

 NeilBrown



 ----------- Diffstat output ------------
 ./drivers/md/md.c     |    2 +-
 ./init/do_mounts_md.c |    9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-02-26 10:17:05.000000000 +1100
+++ ./drivers/md/md.c	2004-02-27 12:06:31.000000000 +1100
@@ -1450,7 +1450,7 @@ abort:
 	return 1;
 }
 
-static int mdp_major = 0;
+int mdp_major = 0;
 
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
 {

diff ./init/do_mounts_md.c~current~ ./init/do_mounts_md.c
--- ./init/do_mounts_md.c~current~	2004-02-26 10:15:07.000000000 +1100
+++ ./init/do_mounts_md.c	2004-02-27 12:09:29.000000000 +1100
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
