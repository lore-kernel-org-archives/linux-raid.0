From: Neil Brown <neilb@suse.de>
Subject: Re: stripe_cache_size ?
Date: Fri, 9 Dec 2005 20:47:40 +1100
Message-ID: <17305.21180.376781.954660@cse.unsw.edu.au>
References: <01a501c5fc9c$bd138d00$9d02a8c0@southa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kyle Wong on Friday December 9
Sender: linux-raid-owner@vger.kernel.org
To: Kyle Wong <kylewong@southa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 9, kylewong@southa.com wrote:
> Hi,
> 
> I found that there's a new sysfs "stripe_cache_size" variable. I want to
> know how does it affect RAID5 read / write performance (if any) ?
> Please cc to me if possible, thanks.

Would you like to try it out and see?
Any value from about 10 to a few thousand should be perfectly safe,
though very large values may cause the system to run short of memory.

The memory used is approximately
   stripe_cache_size * 4K * number-of-drives

NeilBrown
