From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Fri, 15 Feb 2013 20:12:44 +0800
Message-ID: <511E263C.6070704@fnarfbargle.com>
References: <20130214213908.282850@gmx.net> <alpine.DEB.2.00.1302151055500.32644@uplift.swm.pp.se> <511E1890.6060708@fnarfbargle.com> <alpine.DEB.2.00.1302151220060.32644@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1302151220060.32644@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/02/13 19:23, Mikael Abrahamsson wrote:
> On Fri, 15 Feb 2013, Brad Campbell wrote:
>
>> To the point I've been ready to submit a patch for --assume-clean along the lines of what hdparm 
>> does and makes you also attach --please-destroy-my-disk before it'll work.
>
> Yes, I think this is an excellent idea. It should have --please-destroy-my-disk, and if there are 
> existing superblocks, it should save the contents of mdadm --examine before overwriting or 
> zero:ing them.

Please don't get me wrong. There is no nice way of protecting fools from themselves short of 
revoking their license to breed, it's just from my severely opinionated viewpoint that this looks 
like a sane idea. I'm quite prepared to be slapped, and in fact probably need it.
> --assemble --force should list the drive event count and say which drives have differing event 
> counts and ask for confirmation that this is really what the operator wants to do. If the event 
> count differs more than 50 (or some other value), there should be a requirement for 
> --please-destroy-my-array to be added :P
>
>> --assume-clean is great for those that need it, but for the great majority who rely on google and 
>> wikis it's a data-destroyer.
>
This is not a sleight on Neil and/or mdadm. The tools are wonderful, it's those that compose 
permanent articles without a full understanding that need adjusting. Unfortunately it's also those 
that don't really care as long as it drives page hits or reputation.

Brad (the unpleasant)
