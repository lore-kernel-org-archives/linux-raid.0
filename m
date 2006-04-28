From: Neil Brown <neilb@suse.de>
Subject: Re: Mdadm -- how to add another device in a linear mode?
Date: Fri, 28 Apr 2006 10:23:36 +1000
Message-ID: <17489.24712.256684.732074@cse.unsw.edu.au>
References: <BAY107-F20BDB03238474AB39AA90BCA270@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from m l on Thursday January 12
Sender: linux-raid-owner@vger.kernel.org
To: m l <cmoimartin@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 12, cmoimartin@hotmail.com wrote:
> Hi all,
> 
> 1- I would like to create a linear raid level with one device. (or with 
> raid0)
> 2- I would like to add another device to the first one.
> 
> Anyone knows how ?

Currently the only way is to recreate the array with extra devices.
This will not corrupt any old data.

I have a patch somewhere that supports extending a linear array while
it is active, but I haven't properly reviewed, tested, and submitted
it yet.... maybe one day.

NeilBrown
