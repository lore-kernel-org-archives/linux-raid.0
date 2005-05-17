From: Jay Strauss <me@heyjay.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Tue, 17 May 2005 18:00:26 -0500
Message-ID: <428A778A.9020209@heyjay.com>
References: <428A09A3.9000802@heyjay.com> <Pine.LNX.4.56.0505171649090.32621@lion.drogon.net> <428A1924.8030801@heyjay.com> <Pine.LNX.4.56.0505171720070.32621@lion.drogon.net> <428A2133.4080202@h3c.com> <428A594E.5080207@heyjay.com> <428A59F9.5050908@h3c.com> <428A6D27.7070703@medien.uni-weimar.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428A6D27.7070703@medien.uni-weimar.de>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias Hofmann <tobias.hofmann@medien.uni-weimar.de>
Cc: Mike Hardy <mhardy@h3c.com>, Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tobias Hofmann wrote:
> On 17.05.2005 22:54, Mike Hardy wrote:
> 
> [...]
> 
>> That's fine-grained tuning mostly though, and not really on topic for
>> you as it appears you have something entirely different going on. What
>> exactly is going on, I must admit, I don't know. :-/
> 
> 
> <delurk>
> Well, let's find out then, no? ;)
> 
> Jay, you said it yourself - Knoppix seems to be setting something 
> different than Sarge. I am not very familiar with both, but doing a 
> lspci on both (just in case they "see" something different) and 
> comparing, like Gordon suggested, the output of dmesg | less (or a less 
> /var/log/dmesg) on both systems might give you an idea where things 
> start to go differently.
> 
> I would look for differences in the discovery of (the) 
> ide-controller(s), and how the HDs are discovered/treated.
> 
> For completeness' sake, the kernel version of each try could give the 
> experts an idea of differences I am not aware of.
> 
> I am sure to have forgotten something here, but for starters, it might 
> work.
> 
> Just my 2c, good luck, tobi... ;)

Ok :), when I get home I'll be doing everything everyone has asked

It's a drag booting knoppix on this machine, it takes forever

Jay

