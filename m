From: Tobias Hofmann <tobias.hofmann@medien.uni-weimar.de>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Wed, 18 May 2005 00:16:07 +0200
Message-ID: <428A6D27.7070703@medien.uni-weimar.de>
References: <428A09A3.9000802@heyjay.com> <Pine.LNX.4.56.0505171649090.32621@lion.drogon.net> <428A1924.8030801@heyjay.com> <Pine.LNX.4.56.0505171720070.32621@lion.drogon.net> <428A2133.4080202@h3c.com> <428A594E.5080207@heyjay.com> <428A59F9.5050908@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428A59F9.5050908@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: Jay Strauss <me@heyjay.com>, Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17.05.2005 22:54, Mike Hardy wrote:

[...]

> That's fine-grained tuning mostly though, and not really on topic for
> you as it appears you have something entirely different going on. What
> exactly is going on, I must admit, I don't know. :-/

<delurk>
Well, let's find out then, no? ;)

Jay, you said it yourself - Knoppix seems to be setting something 
different than Sarge. I am not very familiar with both, but doing a 
lspci on both (just in case they "see" something different) and 
comparing, like Gordon suggested, the output of dmesg | less (or a less 
/var/log/dmesg) on both systems might give you an idea where things 
start to go differently.

I would look for differences in the discovery of (the) 
ide-controller(s), and how the HDs are discovered/treated.

For completeness' sake, the kernel version of each try could give the 
experts an idea of differences I am not aware of.

I am sure to have forgotten something here, but for starters, it might work.

Just my 2c, good luck, tobi... ;)
