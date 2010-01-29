From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm PATCH 0/2] Improvement: new logging library for mdadm/mdmon
Date: Fri, 29 Jan 2010 15:23:35 -0700
Message-ID: <4B635FE7.4040908@intel.com>
References: <20100128155922.32091.12709.stgit@awojcik-linux>	 <20100129205242.62e4049d@notabene> <1264781188.2788.99.camel@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264781188.2788.99.camel@awojcik-linux>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Artur" <artur.wojcik@intel.com>
Cc: Neil Brown <neilb@suse.de>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Wojcik, Artur wrote:
> On Fri, 2010-01-29 at 09:52 +0000, Neil Brown wrote:
>> I'd probably need a lot of convincing to add something like this to mdadm.
>>
> 
> I did not expect this patch to be accepted without convincing you or at
> least without a lot of explanations :). What interest you the most?
> 
> The reason for this improvement/patch is:
> 
> 1) to unify the way mdadm and mdmon log messages,

Unification implies code reduction, this is currently just code movement.

> 2) to have logs from mdadm and mdmon applications at the same time
> 3) to be able to capture log messages when system is booting, 
> 4) to simplify the source code. 

The only one that would be interesting from a debug perspective is 3, 
but syslog is not available in the initramfs and I currently do not see 
how it would be much better than just redirecting the console to the 
serial port and logging it there.  The dprintf() calls in mdmon are 
sometimes useful, but I am skeptical of needing those on all the time.

Can you identify debug scenarios that require this level of logging 
sophistication (versus doing one-off build/configuration changes to dump 
some diagnostic info)?  As it stands this looks like a solution looking 
for a problem.

--
Dan

