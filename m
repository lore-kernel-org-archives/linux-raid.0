From: Stephen Lee <splee@plexio.com>
Subject: Re: How to set speed_limit_max for mdrecoveryd?
Date: 24 Sep 2002 07:40:31 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1032878432.8864.10.camel@ralph.plexio.private>
References: <A5974D8E5F98D511BB910002A50A66470580D1FE@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A5974D8E5F98D511BB910002A50A66470580D1FE@hdsmsx103.hd.intel.com>
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2002-09-24 at 07:01, Cress, Andrew R wrote:
> 
> I couldn't find this is a quick scan of the code, and thought it should be
> documented somewhere.  Maybe I just have a blind spot.  Can someone tell me
> how to set the speed_limit_max variable for mdrecoveryd?  
> 

Try this:

echo some_value > /proc/sys/dev/raid/speed_limit_max

or what ever value you wish.

Stephen


