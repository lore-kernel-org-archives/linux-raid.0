From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Unable to re-add a disk  after a reboot.
Date: Thu, 14 Aug 2014 23:45:02 -0500
Message-ID: <53ED904E.3040200@gmail.com>
References: <53ED416E.8010504@gmail.com> <20140815101924.1d09363d@notabene.brown> <53ED6379.8030404@gmail.com> <alpine.DEB.2.02.1408150625400.7929@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1408150625400.7929@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: NeilBrown <neilb@suse.de>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/14/2014 11:27 PM, Mikael Abrahamsson wrote:
> On Thu, 14 Aug 2014, Ram Ramesh wrote:
>
>> I thought write-intent bitmap was not a good idea. May be I did not 
>> research enough. This brings me to the next (probably more important) 
>> question. How do I replace a old drive that has not died without 
>> having to rebuild? If I did a dd image xfer will it accept the 
>> replacement?
>
> If you have a fairly recent kernel and mdadm, there is mdadm --replace.
>
> https://unix.stackexchange.com/questions/74924/how-to-safely-replace-a-not-yet-failed-disk-in-a-linux-raid5-array 
>
>
Thanks. If I may, I like to ask one related question. I have a disk that 
is already kicked out. Will adding a bitmap to degraded array help in 
-re_add the device? I doubt it, but I rather ask before trying as I am 
paranoid after the disk failure.

Ramesh

