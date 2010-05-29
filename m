From: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>
Subject: Re: recovering from a controller failure
Date: Sat, 29 May 2010 16:36:10 -0500
Message-ID: <20100529213610.GC7501@flews.lairds.us>
References: <20100529190751.GM2167@flews.lairds.us>
 <4C01849D.8080101@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C01849D.8080101@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 30, 2010 at 09:18:21AM +1200, Richard wrote:

> This happened to me before I discovered that LSI SAS1068E no longer
> reliably tolerate querying via smartd/smartctl.
> 
> Have a look at https://bugzilla.kernel.org/show_bug.cgi?id=14831
> 
> and there is a patch that seems to fix it here:
> 
> http://lkml.org/lkml/2010/4/26/335

Good news!  I appreciate the information.  I'm planning to update these
machines with new kernels and will include this patch.

> Use hdparm if you need serial numbers.

The labels Sun puts on the drives has numbers from the "device model."
I will see if hdparm yields those numbers...once this is all settled. 
Thanks for the suggestion.

> In the the half dozen or so tests I have done, where more than 2
> drives have been thrown out of md RAID6 arrays due to these
> controller resets,
> reassembly using --force has worked with no data corruption, but
> this may have been good luck.

Wow!  That's encouraging.  I would feel amazingly more confident if
someone would give me the exact command to try.  This is not a good
time for me to exercise my ignorance by experimenting.

Thank you for your helpful insight!

--kyler
