From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-1 does not rebuild after hot-add
Date: Tue, 5 Aug 2003 16:53:03 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16175.21583.621336.653083@gargle.gargle.HOWL>
References: <3F2D1FAC.9030905@shaolinmicro.com>
	<16173.43804.617586.906225@gargle.gargle.HOWL>
	<3F2E8CAE.7090208@shaolinmicro.com>
	<16175.4992.765886.291774@gargle.gargle.HOWL>
	<3F2F4F7F.6010801@shaolinmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Chow on Tuesday August 5
To: David Chow <davidchow@shaolinmicro.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 5, davidchow@shaolinmicro.com wrote:
> >
> >
> >Rather than a hex dump, just use
> >
> >  mdadm --examine /dev/XXX
> >
> >That is the easiest way to view the superblock on the device.
> >
> >NeilBrown
> >
> Neil,
> 
> OK, I find out there is a problem in the superblock which is descrbed as 
> follows. The "Total Devices" is wrong. It should be 2 instead of 3. This 
> is probably a bug of the mkraid (from raidtools) which when I created 
> the array with a "failed-disk" in degraded mode. mkraid incorrectly made 
> a wrong superblock even I put "nr-raid-disk 2" and "nr-spare-disks 0" in 
> the raidtab. Ok, the superblock is incorrect, but how can I change the 
> total devices and spare device pramaters without re-initialize the
> array?

It is actuallt "Active Devices" that is the problem.  As this is the
same as "Raid Devices", it doesn't bother doing a reconstruction.

The following patch adds --update=summaries to mdadm-1.3.0, which
updates the various summary fields in the superblock (Total, Active,
Working, Failed, Spare - Devices).
It is untested but should work.
If you patch mdadm-1.3.0 and compile it, then

  mdadm --assemble /dev/md2 --update=summaries /dev/sda3 /dev/sdb3

then it should update these fields and start the array (you might need
a --run as well).

Let me know how it goes.

NeilBrown


 ----------- Diffstat output ------------
 ./Assemble.c |   25 +++++++++++++++++++++++++
 ./ReadMe.c   |    4 ++--
 ./mdadm.c    |    4 +++-
 3 files changed, 30 insertions(+), 3 deletions(-)

diff ./Assemble.c~current~ ./Assemble.c
--- ./Assemble.c~current~	2003-08-05 16:40:07.000000000 +1000
+++ ./Assemble.c	2003-08-05 16:49:00.000000000 +1000
@@ -292,6 +292,31 @@ int Assemble(char *mddev, int mdfd,
 					fprintf(stderr, Name ": updating superblock of %s with minor number %d\n",
 						devname, super.md_minor);
 			}
+			if (strcmp(update, "summaries") == 0) {
+				/* set nr_disks, active_disks, working_disks,
+				 * failed_disks, spare_disks based on disks[] 
+				 * array in superblock
+				 */
+				super.nr_disks = super.active_disks =
+					super.working_disks = super.failed_disks =
+					super.spare_disks = 0;
+				for (i=0; MD_SB_DISKS ; i++) 
+					if (super.disks[i].major ||
+					    super.disks[i].minor) {
+						int state = super.disks[i].state;
+						if (state & (1<<MD_DISK_REMOVED))
+							continue;
+						super.nr_disks++;
+						if (state & (1<<MD_DISK_ACTIVE))
+							super.active_disks++;
+						if (state & (1<<MD_DISK_FAULTY))
+							super.failed_disks++;
+						else
+							super.working_disks++;
+						if (state == 0)
+							super.spare_disks++;
+					}
+			}
 			super.sb_csum = calc_sb_csum(&super);
 			dfd = open(devname, O_RDWR, 0);
 			if (dfd < 0) 

diff ./ReadMe.c~current~ ./ReadMe.c
--- ./ReadMe.c~current~	2003-08-05 16:38:03.000000000 +1000
+++ ./ReadMe.c	2003-08-05 16:38:35.000000000 +1000
@@ -221,7 +221,7 @@ char OptionHelp[] =
 "  --config=     -c   : config file\n"
 "  --scan        -s   : scan config file for missing information\n"
 "  --force       -f   : Assemble the array even if some superblocks appear out-of-date\n"
-"  --update=     -U   : Update superblock: either sparc2.2 or super-minor\n"
+"  --update=     -U   : Update superblock: one of sparc2.2, super-minor or summaries\n"
 "\n"
 " For detail or examine:\n"
 "  --brief       -b   : Just print device name and UUID\n"
@@ -344,7 +344,7 @@ char Help_assemble[] =
 "                       for a full array are present\n"
 "  --force       -f   : Assemble the array even if some superblocks appear\n"
 "                     : out-of-date.  This involves modifying the superblocks.\n"
-"  --update=     -U   : Update superblock: either sparc2.2 or super-minor\n"
+"  --update=     -U   : Update superblock: one of sparc2.2, super-minor or summaries\n"
 ;
 
 char Help_manage[] =

diff ./mdadm.c~current~ ./mdadm.c
--- ./mdadm.c~current~	2003-08-05 16:39:52.000000000 +1000
+++ ./mdadm.c	2003-08-05 16:52:37.000000000 +1000
@@ -397,7 +397,9 @@ int main(int argc, char *argv[])
 			if (strcmp(update, "sparc2.2")==0) continue;
 			if (strcmp(update, "super-minor") == 0)
 				continue;
-			fprintf(stderr, Name ": '--update %s' invalid.  Only 'sparc2.2' or 'super-minor' supported\n",update);
+			if (strcmp(update, "summaries")==0)
+				continue;
+			fprintf(stderr, Name ": '--update %s' invalid.  Only 'sparc2.2', 'super-minor' or 'summaries' supported\n",update);
 			exit(2);
 
 		case O(ASSEMBLE,'c'): /* config file */
