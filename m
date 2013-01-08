From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: How do I tell which disk failed?
Date: Tue, 08 Jan 2013 09:20:05 -0800
Message-ID: <1357665605.16366.161.camel@corn.betterworld.us>
References: <1357610701.16366.13.camel@corn.betterworld.us>
	 <alpine.DEB.2.00.1301081054520.26235@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1301081054520.26235@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: ross@biostat.ucsf.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2013-01-08 at 10:55 +0100, Mikael Abrahamsson wrote:
> On Mon, 7 Jan 2013, Ross Boylan wrote:
> 
> > I see my array is reconstructing, but I can't tell which disk failed.
> > Is there a way to?  I tried mdadm --detail on the array, mdadm --examine
> 
> You should look into the kernel logs, "dmesg" might tell you if there 
> hasn't been much other log activity lately, otherwise you have to check 
> the logfiles. It will log any fail events there.

I checked the logs and didn't see anything about a drive failing, though
there were some smartd reports of changes in drive parameters like
temperature.

