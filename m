From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: Data corruption on software raid.
Date: Sun, 18 Mar 2007 23:00:05 +0100
Message-ID: <20070318220005.GN6063@freshdot.net>
References: <20070318131606.GJ6063@freshdot.net> <Pine.LNX.4.64.0703180959090.32397@p34.internal.lan> <45FD6DCF.3040300@tmr.com> <20070318173849.GM6063@freshdot.net> <45FD870C.3020403@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45FD870C.3020403@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Bill Davidsen (davidsen@tmr.com):

> Here are several pertinent sections from Neils posts, topic 
> "mismatch_cnt questions"
[..]
> Does any of that explain why I raise the possibility of the data 
> changing as the file is written?

Yeah, that helps. But as i understand, these 'differences' are quickly
smoothed out. I tested the data after receiving it completely.

First thing i'll do is try to get a new disk for sdb, as SMART is dodgy
on the thing. Hopefully that will solve the problems, if it doesn't the
controller will be replaced.

I still think it's weird...

Regards,
Sander.
-- 
| 42.7 percent of all statistics are made up on the spot.
| 1024D/08CEC94D - 34B3 3314 B146 E13C 70C8  9BDB D463 7E41 08CE C94D
