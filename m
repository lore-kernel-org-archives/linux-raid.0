From: Flynn <flynn@kodachi.com>
Subject: Re: raid5 to utilize upto 8 cores
Date: Thu, 16 Aug 2012 11:47:43 -0400
Message-ID: <618E70B9E92CDF1ACC007B06@ryoohko.local>
References: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com>
  <502C8C18.5070501@hardwarefreak.com> <502CA6CE.1080105@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <502CA6CE.1080105@hesbynett.no>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: stan@hardwarefreak.com, vincent Ferrer <vincentchicago1@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> However, there was a recent thread here about someone with a similar
> setup (on hard disks) who had a failure during such a rebuild and had
> lots of trouble...

That was me.  The rebuilds _did_ happen sequentially, not in parallel.  The 
trouble was that by the time the first one finished, the critical-section 
backup for the second one was considered too old to be restored, so mdadm 
--assemble balked.  The fix was simply to tell mdadm --assemble to go 
forward with the old backup; all is well now.

So from my experience, yes, multiple partitions (with magnetic disks) are 
definitely an administrative hassle, and can sometimes get you into actual 
trouble.  Barring some real benefit to set against those real costs, I'd 
say it'd be better to not do it.  [ :) ]

(BTW David, I found that your constructive commentary added much to the 
discussion, both here and in my original thread -- thanks.)

 -- Flynn

--
America will never be destroyed from the outside. If we falter, and lose
our freedoms, it will be because we destroyed ourselves.
                                                         (Abraham Lincoln)

