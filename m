From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm dynamic multipathing
Date: Mon, 4 Sep 2006 15:14:18 +1000
Message-ID: <17659.46634.460877.139173@cse.unsw.edu.au>
References: <Pine.SOC.4.61.0608311235360.23597@cove>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from D. Lane Ware on Thursday August 31
Sender: linux-raid-owner@vger.kernel.org
To: "D. Lane Ware" <dlware@uchicago.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 31, dlware@uchicago.edu wrote:
> Hi all,
> 
> Just wondering if there is any way to get mdadm created multipath devices 
> to re-activate a previously disabled path?
> 
> I know I can
> 
> mdadm /dev/md0 -f /dev/sdx -r /dev/sdx -a /dev/sdx
> 
> to re-activate it, but I want mdadm to do it on its own.
> 
> Will the monitoring tool allow this (running it in daemon mode)?
> 
> Is there any plan to include dynamic multipathing in the future?
> 
> I've used Sun's disksuite multipathing in the past and IBM's sdd/vpath 
> tools and it just worked, so I kind of just expected it here.
> 
> Thanks for any help you can provide.

No, mdadm doesn't do that.

md/multipath is not being actively supported.
Most multipath development effort is centring around dm/multipath.

However I'm happy to accept and review patches to md/multipath and/or
mdadm for multipath support.

NeilBrown

-- 
VGER BF report: H 1.30853e-05
