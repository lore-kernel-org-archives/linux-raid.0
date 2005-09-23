From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Fri, 23 Sep 2005 10:59:02 +0200
Message-ID: <17203.50134.95668.144452@cse.unsw.edu.au>
References: <20050920143346.GA5777@uio.no>
	<17200.9302.242957.23189@cse.unsw.edu.au>
	<20050920153622.GA14287@uio.no>
	<17202.55529.310871.877019@cse.unsw.edu.au>
	<20050922163220.GA27401@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steinar H. Gunderson on Thursday September 22
Sender: linux-raid-owner@vger.kernel.org
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 22, sgunderson@bigfoot.com wrote:
> 
> > 2/ Reserve the stripe_heads needed for a chunk-resize in make_request
> >    (where it is safe to block) rather than in handle_stripe.
> 
> Hm. make_request is never called from the sync code, is it? My understanding
> was that make_request was called whenever userspace wanted to read/write
> something, and only then.

Sorry, I meant sync_request.

NeilBrown
