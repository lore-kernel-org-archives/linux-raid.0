From: pants <pants@cs.hmc.edu>
Subject: Re: Assembly failure
Date: Tue, 10 Jul 2012 10:05:05 -0700
Message-ID: <20120710170505.GB20161@WOPR.ST.HMC.Edu>
References: <20120710163345.GB29855@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120710163345.GB29855@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 10, 2012 at 05:33:45PM +0100, Brian Candler wrote:
> metadata (see below) suggests that some drives think members 1/3/4 are
> missing, but those drives think the array is fine.  The "Events" counts are
> different on some members though.

I have had this problem before; in fact, it is the usual behavior when a
drive begins to fail.  If the three drives in question fail to assemble,
it is usually because they aren't readable/writable by your system, and
therefore can't have their metadata changed to reflect the degenerate
state of the array.  I would check the SMART status of the drives and
look into your logs to see if any ATA errors exist, but my suspicion is
that, at assembly, none of those drives was talking to your system.

If you feel that the drives are fine and that this is some random fluke,
you can simply add the drives back to the array (you may have to wipe
their metadata blocks) while using --assume-clean to ensure that the
data on the newly added drives is kept.

Good luck!

pants.
