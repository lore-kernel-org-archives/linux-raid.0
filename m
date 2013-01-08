From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: How do I tell which disk failed?
Date: Tue, 8 Jan 2013 10:55:34 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301081054520.26235@uplift.swm.pp.se>
References: <1357610701.16366.13.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357610701.16366.13.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 7 Jan 2013, Ross Boylan wrote:

> I see my array is reconstructing, but I can't tell which disk failed.
> Is there a way to?  I tried mdadm --detail on the array, mdadm --examine

You should look into the kernel logs, "dmesg" might tell you if there 
hasn't been much other log activity lately, otherwise you have to check 
the logfiles. It will log any fail events there.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
