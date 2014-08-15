From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Unable to re-add a disk  after a reboot.
Date: Fri, 15 Aug 2014 06:27:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1408150625400.7929@uplift.swm.pp.se>
References: <53ED416E.8010504@gmail.com> <20140815101924.1d09363d@notabene.brown> <53ED6379.8030404@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53ED6379.8030404@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: NeilBrown <neilb@suse.de>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 14 Aug 2014, Ram Ramesh wrote:

> I thought write-intent bitmap was not a good idea. May be I did not 
> research enough. This brings me to the next (probably more important) 
> question. How do I replace a old drive that has not died without having 
> to rebuild? If I did a dd image xfer will it accept the replacement?

If you have a fairly recent kernel and mdadm, there is mdadm --replace.

https://unix.stackexchange.com/questions/74924/how-to-safely-replace-a-not-yet-failed-disk-in-a-linux-raid5-array

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
