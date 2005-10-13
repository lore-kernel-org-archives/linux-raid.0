From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md 004 of 5] Allow a manual resync with md
Date: Thu, 13 Oct 2005 15:18:34 +1000
Message-ID: <17229.60970.294343.705459@cse.unsw.edu.au>
References: <20051004151922.28715.patches@notabene>
	<1051004052347.28827@suse.de>
	<20051011165607.43fc05bf.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Tuesday October 11
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 11, akpm@osdl.org wrote:
> NeilBrown <neilb@suse.de> wrote:
> >
> > static ssize_t
> > +md_show_scan(mddev_t *mddev, char *page)
> > +{
> > +	char *type = "none";
> > +	if (mddev->recovery &
> > +	    ((1<<MD_RECOVERY_RUNNING) || (1<<MD_RECOVERY_NEEDED))) {
> 
> Shouldn't this be a bitwise OR?

Yes, though given that my testing showed it worked fine, there is
little practical difference!!

The constant value is becomes '1' instead of '33', and the '32' bit is
only set for extremely short periods of time, so not testing doesn't
make a visible difference!

I will, ofcourse, fix it.

Thanks for reviewing the patches.

NeilBrown

