From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: endianness of Linux kernel RAID
Date: Thu, 4 Aug 2005 16:47:08 +1000
Message-ID: <17137.47596.652834.79165@cse.unsw.edu.au>
References: <20050803120656.GA16696@anthropohedron.net>
	<17137.42015.808716.889138@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Thursday August 4
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Botsis <aaron@blight.com>, Gregory Seidman <gsslist+linuxraid@anthropohedron.net>, Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday August 4, neilb@cse.unsw.edu.au wrote:
> 
> Oopps....
> I meant to send the following in reply to a recent message from
> Gregory Seidman, but inadvertently send it in reply to an earlier
> message from Aaron Botsis (which I must have missed..)
> 
> Still, the offer is open to either, or anyone else.


I decided to try it anyway...

The following patch, when applied to mdadm-2.0-devel-3 (Recently
released) should allow:

  mdadm --examine --metadata=0.swap /dev/sda1

which will show the superblock with bytes swapped.  If that looks right for
all devices, then

  mdadm --assemble /dev/mdX --update=byteorder /dev/sda1 /dev/sdb1 ...


will assemble the array after swapping the byte order on all devices.
Once it has been assembled this way, the superblocks will have the
correct byte order, and in future the array can be assembled in the
normal way.

Feedback would be very welcome.

Thanks,
NeilBrown

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./Assemble.c     |    3 +++
 ./mdadm.c        |   14 ++++++++++++++
 ./super0.c       |   40 +++++++++++++++++++++++++++++++++++++++-

diff ./Assemble.c~current~ ./Assemble.c
--- ./Assemble.c~current~	2005-08-01 10:51:45.000000000 +1000
+++ ./Assemble.c	2005-08-04 16:40:12.000000000 +1000
@@ -334,6 +334,9 @@ int Assemble(struct supertype *st, char 
 		free(super);
 	super = NULL;
 
+	if (update && strcmp(update, "byteorder")==0)
+		st->minor_version = 90;
+
 	if (devcnt == 0) {
 		fprintf(stderr, Name ": no devices found for %s\n",
 			mddev);

diff ./mdadm.c~current~ ./mdadm.c
--- ./mdadm.c~current~	2005-07-07 09:19:53.000000000 +1000
+++ ./mdadm.c	2005-08-04 16:39:36.000000000 +1000
@@ -547,6 +547,20 @@ int main(int argc, char *argv[])
 				continue;
 			if (strcmp(update, "resync")==0)
 				continue;
+			if (strcmp(update, "byteorder")==0) {
+				if (ss) {
+					fprintf(stderr, Name ": must not set metadata type with --update=byteorder.\n");
+					exit(2);
+				}
+				for(i=0; !ss && superlist[i]; i++) 
+					ss = superlist[i]->match_metadata_desc("0.swap");
+				if (!ss) {
+					fprintf(stderr, Name ": INTERNAL ERROR cannot find 0.swap\n");
+					exit(2);
+				}
+
+				continue;
+			}
 			fprintf(stderr, Name ": '--update %s' invalid.  Only 'sparc2.2', 'super-minor', 'resync' or 'summaries' supported\n",update);
 			exit(2);
 

diff ./super0.c~current~ ./super0.c
--- ./super0.c~current~	2005-08-02 16:37:09.000000000 +1000
+++ ./super0.c	2005-08-04 16:43:10.000000000 +1000
@@ -52,7 +52,39 @@ static unsigned long calc_sb0_csum(mdp_s
 	return newcsum;
 }
 
+
+void super0_swap_endian(struct mdp_superblock_s *sb)
+{
+	/* as super0 superblocks are host-endian, it is sometimes
+	 * useful to be able to swap the endianness 
+	 * as (almost) everything is u32's we byte-swap every 4byte
+	 * number.
+	 * We then also have to swap the events_hi and events_lo
+	 */
+	char *sbc = (char *)sb;
+	__u32 t32;
+	int i;
+
+	for (i=0; i < MD_SB_BYTES ; i+=4) {
+		char t = sbc[i];
+		sbc[i] = sbc[i+3];
+		sbc[i+3] = t;
+		t=sbc[i+1];
+		sbc[i+1]=sbc[i+2];
+		sbc[i+2]=t;
+	}
+	t32 = sb->events_hi;
+	sb->events_hi = sb->events_lo;
+	sb->events_lo = t32;
+
+	t32 = sb->cp_events_hi;
+	sb->cp_events_hi = sb->cp_events_lo;
+	sb->cp_events_lo = t32;
+
+}	
+
 #ifndef MDASSEMBLE
+
 static void examine_super0(void *sbv)
 {
 	mdp_super_t *sb = sbv;
@@ -572,6 +604,9 @@ static int load_super0(struct supertype 
 		return 1;
 	}
 
+	if (st->ss && st->minor_version == 9)
+		super0_swap_endian(super);
+
 	if (super->md_magic != MD_SB_MAGIC) {
 		if (devname)
 			fprintf(stderr, Name ": No super block found on %s (Expected magic %08x, got %08x)\n",
@@ -611,6 +646,10 @@ static struct supertype *match_metadata_
 		)
 		return st;
 
+	st->minor_version = 9; /* flag for 'byte-swapped' */
+	if (strcmp(arg, "0.swap")==0)
+		return st;
+
 	free(st);
 	return NULL;
 }
@@ -742,7 +781,6 @@ int write_bitmap0(struct supertype *st, 
 
 	return rv;
 }
-	
 
 struct superswitch super0 = {
 #ifndef MDASSEMBLE


