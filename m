From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 008 of 10] md: Allow raid 'layout' to be read and set via sysfs.
Date: Thu, 1 Jun 2006 15:44:19 +1000
Message-ID: <17534.32435.740138.527260@cse.unsw.edu.au>
References: <20060601150955.27444.patches@notabene>
	<1060601051408.27637@suse.de>
	<20060601053459.GL2697@moss.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Wright on Wednesday May 31
Sender: linux-raid-owner@vger.kernel.org
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 31, chrisw@sous-sol.org wrote:
> * NeilBrown (neilb@suse.de) wrote:
> > +static struct md_sysfs_entry md_layout =
> > +__ATTR(layout, 0655, layout_show, layout_store);
> 
> 0644?

I think the correct response is "Doh!" :-)

Yes, thanks,
NeilBrown
