From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID over Firewire
Date: Mon, 04 Sep 2006 13:41:17 -0400
Message-ID: <44FC653D.8020600@tmr.com>
References: <44EB94BE.8080907@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44EB94BE.8080907@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Scobie wrote:

> Has anyone had any experience or comment regarding linux RAID over 
> ieee1394?
>
> As a budget backup solution, I am considering using a pair of 500GB 
> drives, each connected to a firewire 400 port, configured as a linear 
> array, to which the contents of an onboard array will be rsynced weekly.
>
> In theory, throughput performance should not be an issue, but it would 
> be great to hear from somone who has done this.

It should work, but I don't like it... it leaves you with a lot of 
exposure between backups.

Unless your data change a lot, you might consider a good incremental 
dump program to DVD or similar.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

