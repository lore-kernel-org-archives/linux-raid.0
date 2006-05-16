From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: raid0 over 2 h/w raid5's OOPSing at mkfs
Date: Tue, 16 May 2006 11:02:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0605161055590.29380@chaos.egr.duke.edu>
References: <Pine.LNX.4.62.0605151440080.29380@chaos.egr.duke.edu>
 <17513.4351.71436.972341@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17513.4351.71436.972341@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 16 May 2006 at 9:38am, Neil Brown wrote

> On Monday May 15, jlb17@duke.edu wrote:
>> I've got a x86_64 system with 2 3ware 9550SX-12s, each set up as a raid5
>> w/ a hot spare.  Over that, I do a software raid0 stripe via:
>>
>> mdadm -C /dev/md0 -c 512 -l 0 -n 2 /dev/sd[bc]1
>>
>> Whenever I try to format md0 (I've tried both mke2fs and mkfs.xfs), the
>> system OOPSes.  I'm running centos-4 with the default kernel, but I've
>> upgraded the 3ware driver/firmware to the most recent versions.  Based on
>> the OOPS I'll paste below, who should I be blaming for this crash?  Any
>> ideas on how to fix it?  Thanks.
>
> Try this.
>
> http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1eb29128c644581fa51f822545921394ad4f719f
>
> Raid0 has troubles in 64bit machines back in 2.6.9 days.

That certainly looks to have done it -- thanks!

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
