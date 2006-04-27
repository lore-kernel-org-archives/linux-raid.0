From: Neil Brown <neilb@suse.de>
Subject: Re: Trying to start dirty, degraded RAID6 array
Date: Thu, 27 Apr 2006 10:52:14 +1000
Message-ID: <17488.5566.917635.665506@cse.unsw.edu.au>
References: <44500439.1020108@nighthawkrad.net>
	<17488.2813.780066.749611@cse.unsw.edu.au>
	<44500EB0.6030006@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christopher Smith on Thursday April 27
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 27, csmith@nighthawkrad.net wrote:
> Neil Brown wrote:
> > The '-f' is meant to make this work.  However it seems there is a bug.
> > 
> > Could you please test this patch?  It isn't exactly the right fix, but
> > it definitely won't hurt.
> 
> Thanks, Neil, I'll give this a go when I get home tonight.
> 
> Is there any way to start an array without kicking off a rebuild ?

echo 1 > /sys/module/md_mod/parameters/start_ro 

If you do this, then arrays will be read-only when they are started,
and so will not do a rebuild.  The first write request to the array
(e.g. if you mount a filesystem) will cause a switch to read/write and
any required rebuild will start. 

echo 0 > ....
will revert the effect.

This requires a reasonably recent kernel.

NeilBrown
