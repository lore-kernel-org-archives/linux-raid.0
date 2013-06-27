From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH 0/6] raid6check fixes
Date: Thu, 27 Jun 2013 22:49:00 +0200
Message-ID: <20130627204900.GA2240@lazy.lzy>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
 <20130619100803.03fde6d5@notabene.brown>
 <20130620161639.GA3033@lazy.lzy>
 <20130624170458.568dafcb@notabene.brown>
 <20130624171016.GA2237@lazy.lzy>
 <20130625095422.29d3079b@notabene.brown>
 <20130625164628.GA2261@lazy.lzy>
 <20130627142719.5ffbf0ce@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130627142719.5ffbf0ce@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-raid@vger.kernel.org, Robert Buchholz <rbu@goodpoint.de>
List-Id: linux-raid.ids

On Thu, Jun 27, 2013 at 02:27:19PM +1000, NeilBrown wrote:
[...]
> I've just had a little look at raid6test - because some of the selftests were
> failing.
> 
> The default output is rather verbose.  Verbose output can be good, but not as
> the default I think.
> 
> However, more importantly, it pays too much heed to the chunksize.
> 
> If the start of one chunk on drive X is bad, and the end of a corresponding
> chunk on drive Y is bad, then it will complain that it cannot figure out the
> problem.
> It shouldn't do that.  It shouldn't even look at whole chunks at a time.
> 
> It should look at blocks.  Maybe 512bytes or 1K or 4K any of those would do.
> Then for each block it should figure out if there is a problem, and maybe
> auto-fix it.

Hi Neil,

thanks for the feedback.

I checked "mdadm" man page and it states that the chunk
size is always a multiple of 4K (and a power of 2).
I assume this is correct, so I would suggest 4K as
block size. Also because of SSD and many HDD which
are already 4K.

What do you think?

Does it seem reasonable to you?

"raid6check" is processing and collecting statistics
"per byte", I assume it should not need a big architectural
change in order to fit 4K.

About the verbosity, I know, this was already discussed.
My idea was to reduce it, once the other code stabilize.

Thanks,

bye,

pg

> Having two blocks on different drives being bad might be cause for extra
> warnings, but it doesn't make any difference if they are in the same stripe
> or in different stripes.
> 
> i.e. the chunksize should be used only as part of the calculation to work out
> the layout at any particular place in the array.  It should not be used as a
> unit for reading and writing data.
> 
> In anyone feels like addressing that issue, I would be very receptive to
> patches :-)
> 
> NeilBrown



-- 

piergiorgio
