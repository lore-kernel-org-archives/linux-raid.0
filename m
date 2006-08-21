From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH] Fix a potential NULL dereference in md/raid1
Date: Mon, 21 Aug 2006 11:36:21 -0700
Message-ID: <20060821183621.GB17339@kroah.com>
References: <20060821100439.22490.patches@notabene> <1060821000526.22545@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1060821000526.22545@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Stable <stable@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Aug 21, 2006 at 10:05:26AM +1000, NeilBrown wrote:
> patch for 2.6.17 stable series.
> Thanks,
> NeilBrown
> ### Comments for Changeset
> 
> At the point where this 'atomic_add' is, rdev could be NULL,
> as seen by the fact that we test for this in the very next 
> statement.
> Further is it is really the wrong place of the add.
> We could add to the count of corrected errors 
> once the are sure it was corrected, not before
> trying to correct it.
> 
> Signed-off-by: Neil Brown <neilb@suse.de>

Queued for -stable, thanks.

greg k-h
