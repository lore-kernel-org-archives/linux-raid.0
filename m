From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Mon, 17 Oct 2005 08:55:45 +1000
Message-ID: <17234.55921.769147.227160@cse.unsw.edu.au>
References: <20050920143346.GA5777@uio.no>
	<17200.9302.242957.23189@cse.unsw.edu.au>
	<20050920153622.GA14287@uio.no>
	<17202.55529.310871.877019@cse.unsw.edu.au>
	<20050924014412.GA19832@uio.no>
	<17221.59105.846162.739316@cse.unsw.edu.au>
	<20051014194621.GA31390@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steinar H. Gunderson on Friday October 14
Sender: linux-raid-owner@vger.kernel.org
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 14, sgunderson@bigfoot.com wrote:
> On Fri, Oct 07, 2005 at 01:09:21PM +1000, Neil Brown wrote:
> > However it is usually easier to read a whole patch - reading a patch
> > that removes bits of a previous patch, and depends on other bits of
> > it, requires holding too much in one's brain at once.  If you could
> > possibly send a complete patch against a recent release kernel, it
> > would make review a lot easier.
> 
> Here's the latest version of the patch. What's been done since last
> time:

Thanks a lot for this, I really appreciate it!

> 
> - There's no longer a set of $,1r|(Blarger$,1r}(B stripes; instead, they're all shrunk
>   and then expanded, like you requested the last time.
> - The expand stripes are preallocated in sync_request(), again like you 
>   requested.
> - Likewise, the raid5_conf struct is never reallocated; instead, I just make
>   sure it supports MAX_MD_DEVS devices in the first place. This wasted a
>   kilobyte or so per active device, but it removed a _lot_ of fiddly code,
>   so I believe it's a good thing.

I really don't like having hard-coded maximums like this.  However it
makes perfect sense to keep that piece of code really simple while we
make sure the rest of the code work.  So I'm happy for it to stay with
a hard-coded maximum for now, but I will probably want to change it
back to re-allocating raid5_conf once the rest of the code is stable.


> - The patch in general is a lot slimmer (about half the size of the original
>   patch). Lots of special-case code has been thrown out and replaced by using
>   the generic functions instead (for, say, all the parity disk layout stuff).

Half the size sounds like a great step forward!! :-)
I'll have a close look at all the code sometime today and get back to
you with any comments.

Thanks again,
NeilBrown
