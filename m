From: Robin Bowes <robin-gmane@robinbowes.com>
Subject: Re: mdadm segfault
Date: Fri, 17 Dec 2004 17:57:09 +0000
Message-ID: <cpv6lg$r2n$1@sea.gmane.org>
References: <41C20D66.8040906@pobox.com> <16834.25092.142003.103800@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16834.25092.142003.103800@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> Why don't people read the release notes?

Do you really need to ask? :)

> 
>  From "ANNOUNCE-1.8.1":
> 
>    This is a "development" release of mdadm.  It should *not* be
>    considered stable and should be used primarily for testing.
>    The current "stable" version is 1.8.0.
> 
> 
> I guess I should release a "1.9.0" and use "1.8.2 ..." for devel
> releases.

It might be an idea to create "dev" and "production" branches.

Personally, I read the original 1.8.1 announcement on this list and 
stayed with 1.8.0, but I can see how others, accustomed to the usual 
high quality of your releases would think that 1.8.1 would be as stable 
as 1.8.0.

How about 1.x.y-dev or 1.x.y-bzz (eg b20 b=beta)?

R.
-- 
http://robinbowes.com

