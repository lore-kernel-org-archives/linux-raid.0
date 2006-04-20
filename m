From: Neil Brown <neilb@suse.de>
Subject: Re: Soft lockup with 2.6.17-rc1 on amd64
Date: Thu, 20 Apr 2006 16:35:51 +1000
Message-ID: <17479.11207.24738.466684@cse.unsw.edu.au>
References: <20060420024134.GA2798@samfundet.no>
	<17479.2316.814366.755975@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Thursday April 20
Sender: linux-raid-owner@vger.kernel.org
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 20, neilb@suse.de wrote:
> On Thursday April 20, sgunderson@bigfoot.com wrote:
> > (Please Cc me on any replies, I'm not on the list.)
> Always!
> 
> 
> > [   37.406668] md: raid6 personality registered for level 6
> > [   37.726168] md: bind<dm-0>
> > [   37.729096] md: bind<dm-1>
> > [   37.742155] md: bind<dm-2>
> > [   37.745266] md: bind<dm-3>
> > [   47.736121] BUG: soft lockup detected on CPU#1!
> > [   47.740655] 
> > [   47.740655] Call Trace: <IRQ> <ffffffff80247e68>{softlockup_tick+218}
> > [   47.748483]        <ffffffff8022f59f>{update_process_times+66} <ffffffff80212ffa>{smp_local_timer_interrupt+35}
> > [   47.758681]        <ffffffff80213614>{smp_apic_timer_interrupt+65} <ffffffff8020a106>{apic_timer_interrupt+98} <EOI>
> > [   47.769352]        <ffffffff8028ad41>{mpage_writepages+730} <ffffffff802495bd>{find_get_pages+91}
> > [   47.778304]        <ffffffff8024fd99>{pagevec_lookup+23} <ffffffff8025096d>{invalidate_mapping_pages+183}
> > [   47.787981]        <ffffffff80212c8d>{smp_call_function+48} <ffffffff880c44e3>{:md_mod:do_md_run+664}
> ....
> > [  123.802707] raid5: device dm-3 operational as raid disk 3
> > [  123.808102] raid5: device dm-2 operational as raid disk 2
> 
> Wow! 76 second to set up a raid5 array  - all of that invalidating an
> inode which would not have had any valid data in it!
> 
> Can you try this patch please?

Yeh, that one was completely wrong.  I think this one will fix it, but
it probably isn't reproducible, so you probably cannot test it.

However: could you please  give me details of dm-[0-3]?  Particularly
how big they are, but also what sort of dm target and what underlying
devices.
Also, what is the clock speed of your processor - I assume it is not
just hyper-threading but actually has two independent core?

Thanks,
NeilBrown

---------------------------------------
Remove softlockup from invalidate_mapping_pages.

If invalidate_mapping_pages is called to invalidate a very large
mapping (e.g. a very large block device) and if the only active page
in that device is near the end  (or at least, at a very large  index),
such as, say, the superblock of an md array, and if that page
happens to be locked when invalidate_mapping_pages is called,
then
  pagevec_lookup will return this page and
  as it is locked, 'next' will be incremented and pagevec_lookup
  will be called again. and again. and again.
  while we count from 0 upto a very large number.

We should really always set 'next' to 'page->index+1' before going
around the loop again, not just if the page isn't locked.


Cc: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./mm/truncate.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff ./mm/truncate.c~current~ ./mm/truncate.c
--- ./mm/truncate.c~current~	2006-04-20 15:27:22.000000000 +1000
+++ ./mm/truncate.c	2006-04-20 15:38:20.000000000 +1000
@@ -238,13 +238,11 @@ unsigned long invalidate_mapping_pages(s
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
-			if (TestSetPageLocked(page)) {
-				next++;
+			next = page->index+1;
+
+			if (TestSetPageLocked(page))
 				continue;
-			}
-			if (page->index > next)
-				next = page->index;
-			next++;
+
 			if (PageDirty(page) || PageWriteback(page))
 				goto unlock;
 			if (page_mapped(page))
