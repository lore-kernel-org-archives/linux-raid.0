From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Question: how to identify failing disk in a RAID1
Date: Thu, 17 Apr 2008 09:12:02 -0400
Message-ID: <48074CA2.2020004@tmr.com>
References: <48025B8D.2030803@harddata.com> <alpine.DEB.1.10.0804131529300.11311@p34.internal.lan> <4802AFEB.9020006@tmr.com> <4802CDA2.605@harddata.com> <4803886E.3050007@tmr.com> <4804CD4F.7080303@harddata.com> <4804F09D.5070503@tmr.com> <48050DD6.7020404@harddata.com> <48055EFA.8060505@tmr.com> <480607F2.3060504@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <480607F2.3060504@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Maurice Hilarius wrote:
> Morning Bill.
>
> BTW< I want to say "Thanks for your help with this" first.
> Just in case I forgot.
>
> So, I ran "check" once. It complained, and failed.
>
Does the failure provide any useful information?

> A few hours later, I ran it again, and it immediately returned "0"
>
I totally don't understand that, assuming that the first check was sone.

> I am still puzzled:
> Why it failed the first time
> Why it returned a result in a couple of seconds the second time.
> What it tells me?
>    I gather this means the md0 device is healthy.
>
I don't think so, I've never had a check *fail*, I just expect it to 
tell me how bad things are.

> So, meanwhile back at the ranch, I still think sda is failing..

I think it's time to be keeping a good backup, and hopefully someone 
else has a good thought on running this down more.

> Any thoughts on that?

The only thought I have at the moment is marginal power supply, and 
that's just because it can generate all manner of odd behaviors, rather 
than any other hints. Sorry.

If you aren't getting errors from SMART or logs, and I don't remember 
you sending me that info, I'm not sure how you determine which drive is 
the problem.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


