From: Aniket Kulkarni <aniket@netezza.com>
Subject: Re: [PATCH] md: Fix =?utf-8?b?bnJfcGVuZGluZw==?= race during raid10 recovery
Date: Thu, 25 Nov 2010 01:36:42 +0000 (UTC)
Message-ID: <loom.20101125T023013-905@post.gmane.org>
References: <1290020270.3055.12.camel@aniket-desktop> <20101124162953.4a405299@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb <at> suse.de> writes:
> > The fix is -
> > 
> > 1. Increment wr.nr_pending immediately after selecting a good target. 
Ofcourse
> > the decrements will be added to error paths in sync_request and 
end_sync_read.
> > 2. Don't submit recovery IOs to faulty targets
> 
> Hi again,
>  I've been thinking about this some more and cannot see that it is a real
>  problem.
>  Do you have an actual 'oops' showing a crash in this situation?
> 
>  The reason it shouldn't happen is that devices are only removed by
>  remove_and_add_devices, and that is only called when no resync/recovery is
>  happening.
>  So when a device fail, the recovery will abort (waiting for all requests to
>  complete), then failed devices are removed and possibly spares are added,
>  then possible recovery starts up again.
> 
>  So it should work correctly as it is....

Hi Neil

You are right, the 'oops' is possible only if devices can be removed during an 
active recovery.

I have a patch for that but I had forgotten to include in the original posting. 
As you have suggested, let me go back and post the patches I have as a series.

Thanks
--
aniket

