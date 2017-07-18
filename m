From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: 3-disk fail on raid-6, examining my options...
Date: Tue, 18 Jul 2017 16:25:50 -0400
Message-ID: <20170718202550.GA2533@animx.eu.org>
References: <07b77b80-4bee-3820-6a0d-3323ef06a3f3@ultratux.net>
 <596E6D72.8050108@youngman.org.uk>
Reply-To: Wakko Warner <wakko@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <596E6D72.8050108@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Maarten <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wols Lists wrote:
> On 18/07/17 18:20, Maarten wrote:
> > Now from what I've gathered over the years and from earlier incidents, I
> > have now 1 (one) chance left to rescue data off this array; by hopefully
> > cloning the bad 3rd-failed drive with the aid of dd_rescue and
> > re-assembling --force the fully-degraded array. (Only IF that drive is
> > still responsive and can be cloned)
> 
> If it clones successfully, great. If it clones, but with badblocks, I
> keep on asking - is there any way we can work together to turn
> dd-rescue's log into a utility that will flag failed blocks as "unreadable"?

I wrote a shell script that will output a device mapper table to do this. 
It will do either zero or error targets for failed blocks.  It's not
automatic and does require a block device (loop for files).  I've used this
several times at work and works for me.

I'm not sure if this is what you're talking about or not, but if you want
the script, I'll post it.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
