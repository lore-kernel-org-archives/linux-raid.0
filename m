From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Wed, 24 Mar 2004 13:09:35 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040324190935.GA18057@lists.us.dell.com>
References: <760890000.1079727553@aslan.btc.adaptec.com> <16479.50592.944904.708098@notabene.cse.unsw.edu.au> <2128160000.1080023015@aslan.btc.adaptec.com> <16480.61927.863086.637055@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16480.61927.863086.637055@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 24, 2004 at 01:26:47PM +1100, Neil Brown wrote:
> On Monday March 22, gibbs@scsiguy.com wrote:
> > One suggestion that was recently raised was to present these changes
> > in the form of an alternate "EMD" driver to avoid any potential
> > breakage of the existing MD.  Do you have any opinion on this?
> 
> I seriously think the best long-term approach for your emd work is to
> get it integrated into md.  I do listen to reason and I am not
> completely head-strong, but I do have opinions, and you would need to
> put in the effort to convincing me.

I completely agree that long-term, md and emd need to be the same.
However, watching the pain that the IDE changes took in early 2.5, I'd
like to see emd be merged alongside md for the short-term while the
kinks get worked out, keeping in mind the desire to merge them
together again soon as that happens. 

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
