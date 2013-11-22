From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: ARC-1120 and MD very sloooow
Date: Fri, 22 Nov 2013 12:17:06 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1311221215310.1157@uplift.swm.pp.se>
References: <1385118796.8091.31.camel@bews002.euractiv.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1385118796.8091.31.camel@bews002.euractiv.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jimmy Thrasibule <thrasibule.jimmy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Nov 2013, Jimmy Thrasibule wrote:

> Any advise would be appreciated.

"iostat -x 5" is something I use to see what's going on in more detail. 
Let it run during your writing.

If you see a lot of reading from the drives, it might be good to tune 
/sys/block/mdX/md/stripe_cache_size to something larger than the default 
256 setting.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
