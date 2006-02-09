From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 7] md: Introduction - raid5 reshape mark-2
Date: Thu, 9 Feb 2006 14:32:45 +1100
Message-ID: <17386.47069.138562.339803@cse.unsw.edu.au>
References: <20060124112626.4447.patches@notabene>
	<43E8D53E.4010202@idgmail.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Henrik Holst on Tuesday February 7
Sender: linux-raid-owner@vger.kernel.org
To: Henrik Holst <henrik.holst@idgmail.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 7, henrik.holst@idgmail.se wrote:
> Hello linux world!
> 
> Excuse me for being so ignorant but /exactly how/ do I go about to find
> out which files to download from kernel.org that will approve these
> patches?

I always make them against the latest -mm kernel, so that would be a
good place to start.  However things change quickly and I can't
promise it will apply against whatever is the 'latest' today.

If you would like to nominate a particular recent kernel, I'll create
a patch set that is guaranteed to apply against that. (Testing is
always appreciated, and well worth that small effort on my part).

NeilBrown

> 
> [snip from N. Browns initial post]
> 
> >
> > [PATCH 001 of 7] md: Split disks array out of raid5 conf structure so it is easier to grow.
> > [PATCH 002 of 7] md: Allow stripes to be expanded in preparation for expanding an array.
> > [PATCH 003 of 7] md: Infrastructure to allow normal IO to continue while array is expanding.
> > [PATCH 004 of 7] md: Core of raid5 resize process
> > [PATCH 005 of 7] md: Final stages of raid5 expand code.
> > [PATCH 006 of 7] md: Checkpoint and allow restart of raid5 reshape
> > [PATCH 007 of 7] md: Only checkpoint expansion progress occasionally.
> >
> 
> I only get lot's of "chunk failed" when running patch command on my
> src.tar.gz kernels. :-(
> 
> Thanks for advice,
> 
> Henrik Holst. Certified kernel patch noob.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
