From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Faulty disk detection code: looking to tweak it for network devices
Date: Tue, 5 Aug 2003 12:36:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16175.6185.517151.469809@gargle.gargle.HOWL>
References: <Pine.LNX.4.44.0308041612440.965-100000@jaw.lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ryan P. Joseph on Monday August 4
To: rjoseph@kerr.lanl.gov
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 4, rjoseph@jaw.lanl.gov wrote:
> Hello,
> 
> So, my real question is: where in the blazes does the MD/RAID system actually,
> really, seriously detect a failed disk?!  And when it does this, what is the
> path of function calls taken to say "hey, this disk is failed, don't use it!"?

(talk 2.4 language here)
When raid5 want to schedule I/O on a block, it (Among other things)
sets  b_end_io to either raid5_end_read_request or
raid5_end_write_request depending on type of request, and then calls
generic_make_request to submit the request.

When the request completes, the b_end_io function will be called.  The
second argument to the function ("uptodate") is '1' if the request was
successful, and '0' if it failed (no further details of failure mode,
sorry).

If uptodate== 0, md_error is called which marks the device as faulty
and calls raid5_error which marks it faulty again....

Eventually handle_stripe() gets called on the stripe again.  It
notices that the data still needs to be read or written, but now that
device is failed so it uses some other strategy to accomplish the
desired gaol.

Let me know if you need anything else clarified.

NeilBrown
