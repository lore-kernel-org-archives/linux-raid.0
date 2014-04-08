From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Assistance needed with a failed RAID-5 array
Date: Tue, 8 Apr 2014 10:21:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1404081014410.10236@uplift.swm.pp.se>
References: <5342F15E.5040509@a-1networks.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5342F15E.5040509@a-1networks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alan Worstell <aworstell@a-1networks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 7 Apr 2014, Alan Worstell wrote:

> Hello,
> This morning I discovered that a raid-5 array I had created last week is
> listing all 3 drives in a failed state:
>
> md1 : active raid5 sdm1[4](F) sdp1[3](F) sdl1[1](F) sdo1[0](F)
>       3726024192 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/0]
> [___]
>
> This array has some pretty critical stuff on it I would like to get
> back. Here is a link with /var/log/messages, dmesg, and the output
> of|mdadm --examine on all of the members: |||
> http://filebin.net/ryi7vq7reg
> Any assistance would be greatly appreciated.

There are a lot of problems related to sdd, but that doesn't seem to be 
part of the above array.

I would advice you to try to use --assemble --force on the above md1, 
however the event count on all the component drives are quite diverse (52, 
81, 41 and 29). If this device contains important data, how can the event 
count be so low? You seem to have created it 4-5 days ago?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
