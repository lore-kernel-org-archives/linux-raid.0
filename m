From: keld@keldix.com
Subject: Re: Linux MD? Or an H710p?
Date: Tue, 22 Oct 2013 17:29:57 +0200
Message-ID: <20131022152957.GC5580@www5.open-std.org>
References: <526328AE.2020908@gmail.com> <21093.14265.261728.755087@quad.stoffel.home> <5265C89A.4000908@gmail.com> <52662849.1080003@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52662849.1080003@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Steve Bergman <sbergman27@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It would be nice if we could get some benchmarks on this.
I would be inetersted in also figures from a standard raid10,far configuration.

best regards
keld

On Tue, Oct 22, 2013 at 09:24:57AM +0200, David Brown wrote:
> On 22/10/13 02:36, Steve Bergman wrote:
> 
> <snip>
> 
> > But hey, this is going to be a very nice opportunity for observing XFS's
> > savvy with parallel i/o.
> 
> You mentioned using a 6-drive RAID10 in your first email, with XFS on
> top of that.  Stan is the expert here, but my understanding is that you
> should go for three 2-drive RAID1 pairs, and then use an md linear
> "raid" for these pairs and put XFS on top of that in order to get the
> full benefits of XFS parallelism.
> 
> mvh.,
> 
> David
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
