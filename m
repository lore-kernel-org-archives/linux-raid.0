From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH 2.6] md debug fixes
Date: Fri, 23 Jan 2004 11:23:41 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16400.27021.639037.55877@notabene.cse.unsw.edu.au>
References: <401039A1.D82E8B8D@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Thursday January 22
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 22, Paul.Clements@SteelEye.com wrote:
> Hi Neil,
> 
> While running md with debug turned on, I noticed a couple of things that
> could maybe use changing. 
> 
> The first change simply makes one of the debug messages a little more
> useful (printing a thread's name rather than just a hex pointer value). 
> 
> The second fix is necessary to avoid an oops when md_error is called.
> Because md_error is generally called when a device has failed, the
> chance of the rdev parameter being NULL is fairly high. I hit this oops
> several times in testing.
> 
> Patch attached, please apply.

I've submitted it for 2.6.  I don't think I'll bother for 2.4

Thanks,
NeilBrown
