From: Marc MERLIN <marc@merlins.org>
Subject: Re: Can reading a raid drive trigger all the other drives in that
 set?
Date: Thu, 1 Sep 2011 18:23:27 -0700
Message-ID: <20110902012327.GK30313@merlins.org>
References: <20110628162205.GG20420@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110628162205.GG20420@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 28, 2011 at 09:22:05AM -0700, Marc MERLIN wrote:
> I have ext4 over lvm2 on a sw raid5 with 2.6.39.1
> 
> In order to save power I have my drives spin down.
> 
> When I access my filesystem mount point, I get hangs of 30sec or a bit more
> as each and every drive are woken up serially.
> 
> Is there any chance to put a patch in the block layer so that when it gets a
> read on a block after a certain timeout, it just does one dummy read on all
> the other droves in parallel so that all the drives have a chance to spin
> back up at the same time and not serially?

Ok, so the lack of answer probably means 'no' :)

Given that, is there a user space way to do this?
I'm thinking I might be able to poll drives every second to see if they
were spun down and got an IO. If any drive gets an IO, then the other
ones all get a dummy read, although I'd have to make sure that read is
random so that it can't be in the cache.

I take it there is no such code in existence yet, correct? :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
