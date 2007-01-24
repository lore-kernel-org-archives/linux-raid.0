From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 002 of 4] md: Make 'repair' actually work for raid1.
Date: Wed, 24 Jan 2007 18:27:24 +1100
Message-ID: <17847.2652.255906.33304@notabene.brown>
References: <20070123112437.29357.patches@notabene>
	<1070123002652.29462@suse.de>
	<20070123225747.caa15292.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Tuesday January 23
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 23, akpm@osdl.org wrote:
> On Tue, 23 Jan 2007 11:26:52 +1100
> NeilBrown <neilb@suse.de> wrote:
> 
> > +					for (j = 0; j < vcnt ; j++)
> > +						memcpy(page_address(sbio->bi_io_vec[j].bv_page),
> > +						       page_address(pbio->bi_io_vec[j].bv_page),
> > +						       PAGE_SIZE);
> 
> I trust these BIOs are known to only contain suitably-allocated, MD-private
> pages?  Because if these pages can be user pages then this change is
> spectacularly buggy ;)

Your trust is well placed.
This is in the 'resync' path, were all buffers are allocated in lowmem
and are full pages and so-forth, so this is perfectly safe.

NeilBrown
