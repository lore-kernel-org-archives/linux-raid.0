From: Niccolo Rigacci <niccolo@rigacci.org>
Subject: Re: Cutting power without breaking RAID
Date: Thu, 29 Jun 2006 11:48:06 +0200
Message-ID: <20060629094806.GB8313@rigacci.org>
References: <20060628214350.GA23970@rigacci.org> <17571.20553.319133.437688@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17571.20553.319133.437688@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jun 29, 2006 at 02:00:09PM +1000, Neil Brown wrote:
> With 2.6, 
>    killall -9 md0_raid1
> 
> should do the trick (assuming root is on /dev/md0.  If it is elsewhere,
> choose a different process name).

Thanks, this is what I was looking for!

I will try remounting read-only and killing the md0_raid1.
I will keep you informed.

-- 
Niccolo Rigacci
Firenze - Italy

Iraq, missione di pace: 38725 morti - www.iraqbodycount.net
