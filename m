From: Neil Brown <neilb@suse.de>
Subject: Re: Future of md multipath
Date: Thu, 5 Mar 2009 13:49:56 +1100
Message-ID: <18863.15828.150450.275712@notabene.brown>
References: <20090303180433.GA27569@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christoph Hellwig on Tuesday March 3
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 3, hch@lst.de wrote:
> Just noticed that we still have the old md-based multipath driver
> in the tree, which seem to not have gotten any attention since we
> got dm multipath.
> 
> Is there any reason to keep it or should we deprecate it and kill
> it after a couple of kernel releases?

I'm in favour of deprecating it.  Whenever I hear of people using it I
suggest dm-multipath, but there could people I don't here about.
I think the upcoming mdadm-3.0 will need a compile-time option to
enable multipath, so people will only get it if they really really
want it.

So feel free to propose patches.

Thanks :-)

NeilBrown
