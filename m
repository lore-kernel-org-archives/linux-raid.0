From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Help - this doesn't look good...
Date: Tue, 30 Nov 2004 13:23:27 +1100
Message-ID: <16811.55711.183234.578489@cse.unsw.edu.au>
References: <41A5D897.3010600@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Thursday November 25
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 25, david@dgreaves.com wrote:
> Sigh,
> 
> I'm having what might be xfs/nfsd conflicts and thought I'd reboot into 
> an old 2.6.6 kernel which used to be stable.
> 
> Of course it spotted the fd partitions and tried to start the array.
> It failed (the old kernel didn't have a driver for the new controller so 
> some devices were missing)
> 
> However when I came back to 2.6.9 I get the rather conflicting status 
> shown below.

You might need to explain to me what is "conflicting".  It looks to be
like the array as 6 working devices and one spare, and that due to an
unclean shutdown it is resyncing the 6 working devices.

NeilBrown
