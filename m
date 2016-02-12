From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: md raid5 on top of dmcrypt, or dmcrypt on top of md raid5?
Date: Fri, 12 Feb 2016 10:30:22 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1602121020570.11524@uplift.swm.pp.se>
References: <20160211162959.GG13969@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160211162959.GG13969@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 11 Feb 2016, Marc MERLIN wrote:

> But can someone confirm that indeed if I have a single md device, and 4 
> CPUs, my throughput is not limited by a single CPU decrypting the 
> device?

There have been multiple discussions about this over time, and since you 
didn't qualify "not good" with a number, it's hard to say if this is your 
problem or not.

If you're getting around 100-300 megabyte/s or something, and "top" shows 
high CPU utilization for a few processes and some cores idling (use "1" 
and "H" option after starting top to see individual cores), and "iostat -x 
5" shows the drives as not topping out, then most likely you're indeed 
being hit by dmcrypt not being multithreaded and/or AES-NI not working.

I personally run the same kind of setup as you, I use md->dmcrypt->lvm->fs 
as stack. Performance isn't stellar (I just tried and I get 500 megabyte/s 
read on a machine I am pretty sure AES-NI is working from the start, but 
on another machine where I think AES-NI probably isn't loaded early 
enough, I only got 250 megabyte/s).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
