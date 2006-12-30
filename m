From: Gordon Henderson <gordon@drogon.net>
Subject: Re: A few questions before assembling Linux 7.5TB RAID 5 array
Date: Sat, 30 Dec 2006 22:55:18 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0612302250440.3127@lion.drogon.net>
References: <slrneollp6.4ps.ylee@pobox.com> <4596E8AC.3050407@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4596E8AC.3050407@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yeechang Lee <ylee@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


   Yeechang Lee wrote:
> [Also posted to 
> comp.sys.ibm.pc.hardware.storage,comp.arch.storage,alt.comp.hardware.pc-homebuilt,comp.os.linux.hardware.]
> 
> I'm shortly going to be setting up a Linux software RAID 5 array using
> 16 500GB SATA drives [...]

I'm of the opinion that more drives means more chance of failure, but 
maybe it's just me. I got bitten with a 2-drive failure once in an 8-drive 
RAID-5 set a couple of years ago. Fortunately with the aid of mdadm, etc. 
and having direct access to the drives rather than having them hidden away 
behind some hardware device I was able to recover the data that time, and 
now SMART is getting cleverer ... Howerver ...

Did you consider RAID-6?

I've been using it for some time now (over a year?)

But maybe drives are becoming more reliable though - not lost a drive in 
the past year!

Gordon
