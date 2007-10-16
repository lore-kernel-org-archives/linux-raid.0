From: Neil Brown <neilb@suse.de>
Subject: Re: Help RAID5 reshape Oops / backup-file
Date: Tue, 16 Oct 2007 11:16:19 +1000
Message-ID: <18196.4323.854776.966812@notabene.brown>
References: <20071011142518.igm1jud7ms408ggg@cakebox.homeunix.net>
	<18190.46828.156191.300754@notabene.brown>
	<20071012084328.2f6vk4cdw80kscw0@cakebox.homeunix.net>
	<20071014185550.d6hbv2bk00kkwkgc@cakebox.homeunix.net>
	<18194.42699.193194.986448@notabene.brown>
	<20071015135522.xjds82zo08cgc08c@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nagilum on Monday October 15
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks for the extra details.
I still cannot manage to reproduce it which is frustrating, but I
think I can fix your array for you.

Get the source for mdadm 2.6.3, apply the following patch, then use

   mdadm -A /dev/md0 --update=this /dev/sd[abcde]

that should re-write the part of the superblocks that is wrong, then
assemble the array.

Please let me know how it goes.

Also, if you could show me "mdadm.conf" and "mdrun.conf" from the
initrd, that might help.

Thanks,
NeilBrown


diff --git a/Grow.c b/Grow.c
index 825747e..8ad1537 100644
--- a/Grow.c
+++ b/Grow.c
@@ -978,5 +978,5 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 		/* And we are done! */
 		return 0;
 	}
-	return 1;
+	return 0;
 }
diff --git a/mdadm.c b/mdadm.c
index 40fdccf..7e7e803 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -584,6 +584,8 @@ int main(int argc, char *argv[])
 				exit(2);
 			}
 			update = optarg;
+			if (strcmp(update, "this")==0) 
+				continue;
 			if (strcmp(update, "sparc2.2")==0) 
 				continue;
 			if (strcmp(update, "super-minor") == 0)
diff --git a/super0.c b/super0.c
index 0396c2c..e33e623 100644
--- a/super0.c
+++ b/super0.c
@@ -394,6 +394,21 @@ static int update_super0(struct mdinfo *info, void *sbv, char *update,
 			fprintf (stderr, Name ": adjusting superblock of %s for 2.2/sparc compatability.\n",
 				 devname);
 	}
+	if (strcmp(update, "this") == 0) {
+		/* to fix a particular corrupt superblock.
+		*/
+		int i;
+		for (i=0; i<10; i++)
+			if (sb->disks[i].major == sb->this_disk.major &&
+			    sb->disks[i].minor == sb->this_disk.minor) {
+				if (sb->this_disk.number == sb->disks[i].number)
+					break;
+				fprintf(stderr, Name ": Setting this disk from %d to %d\n",
+					sb->this_disk.number, sb->disks[i].number);
+				sb->this_disk = sb->disks[i];
+				break;
+			}
+	}
 	if (strcmp(update, "super-minor") ==0) {
 		sb->md_minor = info->array.md_minor;
 		if (verbose > 0)
