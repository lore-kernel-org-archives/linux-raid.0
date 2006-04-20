From: Neil Brown <neilb@suse.de>
Subject: Re: Soft lockup with 2.6.17-rc1 on amd64
Date: Thu, 20 Apr 2006 14:53:58 +1000
Message-ID: <17479.5094.438679.603825@cse.unsw.edu.au>
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

Actually, I wouldn't bother.  I've read further and missed the fact
that inode_init_once was being called already.

Is this delay reproducible at all?  If so I'll get you to put some
tracing in.

However, I somehow doubt it is reproducible, as it is very similar to

   https://bugzilla.novell.com/show_bug.cgi?id=152099

and that wasn't reproducible.

But if it is... great!

NeilBrown
