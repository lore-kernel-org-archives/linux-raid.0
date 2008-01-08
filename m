From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 1, new disk can't be added after replacing faulty disk
Date: Tue, 8 Jan 2008 15:35:00 +1100
Message-ID: <18306.64884.866266.620787@notabene.brown>
References: <1199713488.3202.19.camel@localhost.localdomain>
	<e9c3a7c20801071111t11bdd5fx1b8d59bd0a763c4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Monday January 7
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Radu Rendec <radu.rendec@ines.ro>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 7, dan.j.williams@intel.com wrote:
> On Jan 7, 2008 6:44 AM, Radu Rendec <radu.rendec@ines.ro> wrote:
> > I'm experiencing trouble when trying to add a new disk to a raid 1 array
> > after having replaced a faulty disk.
> >
> [..]
> > # mdadm --version
> > mdadm - v2.6.2 - 21st May 2007
> >
> [..]
> > However, this happens with both mdadm 2.6.2 and 2.6.4. I downgraded to
> > 2.5.4 and it works like a charm.
> 
> Looks like you are running into the issue described here:
> http://marc.info/?l=linux-raid&m=119892098129022&w=2

I cannot easily reproduce this.  I suspect it is sensitive to the
exact size of the devices involved.

Please test this patch and see if it fixes the problem.
If not, please tell me the exact sizes of the partition being used
(e.g. cat /proc/partitions) and I will try harder to reproduce it.

Thanks,
NeilBrown



diff --git a/super1.c b/super1.c
index 2b096d3..9eec460 100644
--- a/super1.c
+++ b/super1.c
@@ -903,7 +903,7 @@ static int write_init_super1(struct supertype *st, void *sbv,
 	 * for a bitmap.
 	 */
 	array_size = __le64_to_cpu(sb->size);
-	/* work out how much space we left of a bitmap */
+	/* work out how much space we left for a bitmap */
 	bm_space = choose_bm_space(array_size);
 
 	switch(st->minor_version) {
@@ -913,6 +913,8 @@ static int write_init_super1(struct supertype *st, void *sbv,
 		sb_offset &= ~(4*2-1);
 		sb->super_offset = __cpu_to_le64(sb_offset);
 		sb->data_offset = __cpu_to_le64(0);
+		if (sb_offset - bm_space < array_size)
+			bm_space = sb_offset - array_size;
 		sb->data_size = __cpu_to_le64(sb_offset - bm_space);
 		break;
 	case 1:
