From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: User space RAID-6 access
Date: Tue, 1 Feb 2011 22:00:19 +0100
Message-ID: <20110201210019.GA16130@lazy.lzy>
References: <20110131202054.GA15712@lazy.lzy>
 <20110201075259.4beaf501@notabene.brown>
 <20110201192154.GA2696@lazy.lzy>
 <20110202071850.3b671c1e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110202071850.3b671c1e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I didn't realise that you wanted to look at the members of the array while
> the array was active!!  That is a bit harder.  But not impossible.

Well, let's say that would be optimal, but even
off-line could be OK.

BTW, what does it mean "off-line"?
Does it mean that /dev/mdX exists, but it is not
used (un-mounted), or it is just read-only, or
it should *not* exists and only the componing
HDDs are available?
 
> If you write a couple of numbers to 'suspend_lo' and 'suspend_hi' in sysfs,
> then writes to blocks between those two array addresses will be blocked.
> So you could suspend a region, look at the blocks, then un-suspend.

Oh, thanks, I will consider the option.

bye,

-- 

piergiorgio
