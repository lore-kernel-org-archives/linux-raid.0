From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: detection/correction of corruption with raid6
Date: Wed, 17 Dec 2008 09:48:55 -0500
Message-ID: <49491157.9060805@tmr.com>
References: <1229464713.6159.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1229464713.6159.16.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Piergiorgio Sartor wrote:
> Why a RAID system might have inconsistencies?
> Why do we have a "check" command at all, to run weekly or monthly?
>   

Because alpha particles fly by, most systems don't have ECC memory, a 
passing truck and noisy jet create a beat frequency that causes a once 
in a century bit flip on a good cable connection, power line noise 
creeps in, or maybe an angel farts.

My question is why we don't use available techniques to fix this since 
we have the software to find it for us.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


