From: Mike Hardy <mhardy@h3c.com>
Subject: Re: swap on RAID (was Re: swp - Re: ext3 journal on software raid)
Date: Thu, 06 Jan 2005 09:46:55 -0800
Message-ID: <41DD798F.8030902@h3c.com>
References: <41DC9420.5030701@h3c.com> <Pine.LNX.3.96.1050105210224.11158B-100000@Maggie.Linux-Consulting.com> <20050106093811.GB99565@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050106093811.GB99565@caffreys.strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Andy Smith wrote:

> I interpret your views as (a) but I interpret Mike's as "there are
> people who are saying that a correctly sized machine can have zero
> swap configured."
> 
> Having no swap configured and merely using no swap in normal
> circumstances are very very different situations.

You are correct that I was getting at the zero swap argument - and I 
agree that it is vastly different from simply not expecting it. It is 
important to know that there is no inherent need for swap in the kernel 
though - it is simply used as more "memory" (albeit slower, and with 
some optimizations to work better with real memory) and if you don't 
need it, you don't need it.

That said, I mentioned my servers run with swap for the same reason I 
run with raid. I don't plan on having a disk very often (if at all), and 
I don't plan on needing swap very often (if at all), but when it 
happens, I expect my machine to keep running. (or at least I hope it does)

-Mike
