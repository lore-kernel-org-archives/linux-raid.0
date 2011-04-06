From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] RAID-6 check standalone code cleanup
Date: Wed, 6 Apr 2011 20:02:02 +0200
Message-ID: <20110406180202.GA3267@lazy.lzy>
References: <20110221204551.GA15675@lazy.lzy>
 <20110321140244.2314b4b4@notabene.brown>
 <20110321104007.GA15379@lazy.lzy>
 <20110321220457.29d52f5c@notabene.brown>
 <20110321115440.GA15635@lazy.lzy>
 <20110322095905.737fb1d5@notabene.brown>
 <20110404175242.GA3411@lazy.lzy>
 <20110405091242.3427e0b1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110405091242.3427e0b1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Tue, Apr 05, 2011 at 09:12:42AM +1000, NeilBrown wrote:
> On Mon, 4 Apr 2011 19:52:42 +0200 Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> 
> > Hi Neil,
> > 
> > please find below a second patch to "raid6check.c".
> > This applies on top of the previous one.
> > 
> > Major change is code cleanup and simplification.
> > Furthermore, a better error handling and a couple
> > of bug fixes.
> > Last but not least, the command line parameters are
> > changed from "bytes" to "stripes", which is more
> > convenient, I guess.
> 
> Thanks - I've applied this.

please find attached very below the fix for the
component list scanning. Taking care, hopefully,
to skip/avoid spare drives.
Furthermore, I added also a check for degraded
array, which should not be checked.

> I'm not sure about using 'stripes', though it would be hard to argue in
> favour of 'bytes'.
> Possibly the best number to use would be 'sectors' as that is how the kernel
> would report an inconsistency.
> 
> Once the code settles and you work out what the expected usage pattern would
> be, it might then be obvious what the best number is.  i.e. try to document
> how it would be use and if you find yourself describing complex calculations,
> then change the program so it does the the calculations and you document can
> avoid the complexity.

I switched to "stripes" because the code is using theme
all over and because I was continuosly calculating from
stripe to bytes.

I guess you're right, later it will be possible to decided
which is the better unit for command line and for the
error reporting.

> > 
> > If you prefer, I can send a single patch, including
> > in one shot the last one and this one.
> 
> no, multiple patches are much better - thanks.
> 
> As for the granularity for suspend/check/fix/unsuspend, I suspect that 
> per-stripe would be best.
> A smaller size wouldn't work, and a bigger size would only be helpful if
> there were lots and lots of fixes needed ... which hopefully won't be the
> case.

The suspend story might be a bit more complex than
I was considering.

For example, what will happen if the user hits ctrl-c
while the array is suspended?
Maybe the signals will have to be blocked or re-routed
to a proper cleanup function.
How about kill -9?

Second issue, the stripe in the array should be suspend
also in case the user wants a correction to happen.
In this situation, the suspend should include read, check
and write, since it will not be possible to allow some
other access in between the operations.
Could it be this is too long time for the stripe to be
blocked?

Maybe it would be simpler to require the arrays is in
read only mode....

What do you think?

Thanks,

bye,

pg

Patch follows here:

--- cut here ---

diff -uNr a/raid6check.c b/raid6check.c
--- a/raid6check.c	2011-04-05 01:29:45.000000000 +0200
+++ b/raid6check.c	2011-04-05 22:51:32.587032612 +0200
@@ -207,6 +207,7 @@
 	char **disk_name = NULL;
 	unsigned long long *offsets = NULL;
 	int raid_disks = 0;
+	int active_disks = 0;
 	int chunk_size = 0;
 	int layout = -1;
 	int level = 6;
@@ -242,6 +243,7 @@
 			  GET_LEVEL|
 			  GET_LAYOUT|
 			  GET_DISKS|
+			  GET_DEGRADED |
 			  GET_COMPONENT|
 			  GET_CHUNK|
 			  GET_DEVS|
@@ -254,6 +256,12 @@
 		goto exitHere;
 	}
 
+	if(info->array.failed_disks > 0) {
+		fprintf(stderr, "%s: %s degraded array\n", prg, argv[1]);
+		exit_err = 8;
+		goto exitHere;
+	}
+
 	printf("layout: %d\n", info->array.layout);
 	printf("disks: %d\n", info->array.raid_disks);
 	printf("component size: %llu\n", info->component_size * 512);
@@ -262,12 +270,13 @@
 	printf("\n");
 
 	comp = info->devs;
-	for(i = 0; i < info->array.raid_disks; i++) {
+	for(i = 0, active_disks = 0; active_disks < info->array.raid_disks; i++) {
 		printf("disk: %d - offset: %llu - size: %llu - name: %s - slot: %d\n",
 			i, comp->data_offset * 512, comp->component_size * 512,
 			map_dev(comp->disk.major, comp->disk.minor, 0),
 			comp->disk.raid_disk);
-
+		if(comp->disk.raid_disk >= 0)
+			active_disks++;
 		comp = comp->next;
 	}
 	printf("\n");
@@ -317,18 +326,20 @@
 	close_flag = 1;
 
 	comp = info->devs;
-	for (i=0; i<raid_disks; i++) {
+	for (i=0, active_disks=0; active_disks<raid_disks; i++) {
 		int disk_slot = comp->disk.raid_disk;
-		disk_name[disk_slot] = map_dev(comp->disk.major, comp->disk.minor, 0);
-		offsets[disk_slot] = comp->data_offset * 512;
-		fds[disk_slot] = open(disk_name[disk_slot], O_RDWR);
-		if (fds[disk_slot] < 0) {
-			perror(disk_name[disk_slot]);
-			fprintf(stderr,"%s: cannot open %s\n", prg, disk_name[disk_slot]);
-			exit_err = 6;
-			goto exitHere;
+		if(disk_slot >= 0) {
+			disk_name[disk_slot] = map_dev(comp->disk.major, comp->disk.minor, 0);
+			offsets[disk_slot] = comp->data_offset * 512;
+			fds[disk_slot] = open(disk_name[disk_slot], O_RDWR);
+			if (fds[disk_slot] < 0) {
+				perror(disk_name[disk_slot]);
+				fprintf(stderr,"%s: cannot open %s\n", prg, disk_name[disk_slot]);
+				exit_err = 6;
+				goto exitHere;
+			}
+			active_disks++;
 		}
-
 		comp = comp->next;
 	}
 
--- cut here ---

> NeilBrown
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
