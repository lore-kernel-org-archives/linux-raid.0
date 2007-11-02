From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Implementing low level timeouts within MD
Date: Fri, 02 Nov 2007 08:44:34 -0400
Message-ID: <472B1BB2.2060302@tmr.com>
References: <1193418753.4771.17.camel@w100>	 <1193425254.10336.290.camel@firewall.xsintricity.com>	 <87tzoc7soa.fsf@willow.rfc1149.net>  <1193721577.3876.12.camel@w100>	 <1193765984.10336.519.camel@firewall.xsintricity.com>	 <1193893689.3649.19.camel@w100>	 <1193944573.10336.684.camel@firewall.xsintricity.com> <1193992909.3649.75.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193992909.3649.75.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alberto Alonso wrote:
> On Thu, 2007-11-01 at 15:16 -0400, Doug Ledford wrote:
>   
>> Not in the older kernel versions you were running, no.
>>     
>
> These "old versions" (specially the RHEL) are supposed to be
> the official versions supported by Redhat and the hardware 
> vendors, as they were very specific as to what versions of 
> Linux were supported.

So the vendors of the failing drives claimed that these kernels were 
supported? That's great, most vendors don't even consider Linux 
supported. What response did you get when you reported the problem to 
Redhat on your RHEL support contract? Did they agree that this hardware, 
and its use for software raid, was supported and intended?

>  Of all people, I would think you would
> appreciate that. Sorry if I sound frustrated and upset, but 
> it is clearly a result of what "supported and tested" really 
> means in this case. I don't want to go into a discussion of
> commercial distros, which are "supported" as this is nor the
> time nor the place but I don't want to open the door to the
> excuse of "its an old kernel", it wasn't when it got installed.
>   
The problem is in the time travel module. It didn't properly cope with 
future hardware, and since you have very long uptimes, I'm reasonably 
sure you haven't updated the kernel to get fixes installed.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

