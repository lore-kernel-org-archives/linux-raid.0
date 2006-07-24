From: hahn@physics.mcmaster.ca
Subject: Re: Drives of same model in RAID 1/10 ?
Date: Mon, 24 Jul 2006 17:54:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0607241746370.12006@coffee.psychology.mcmaster.ca>
References: <ea34i5$k2a$1@sea.gmane.org> <20060724214359.GV21855@strugglers.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060724214359.GV21855@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> I am in the process of deciding which SATA-II drives should I choose for an
>> external RAID system. I heard that it was safer to choose drives from
>> different manufacturers to reduce the chance of near-simultaneous failure
>> due to model-specific issues.
>> Is this so?
>
> It's certainly safer.. whether you think it is worth the trouble is
> your call.

it would be great to know the numbers.  I WAG that this pretty 
theoretical model-specific failure mode is insignificant compared 
to environment or wear/load-specific ones.  I can imagine the former
was more of a concern in the days of disks on shared buses (SCSI, FC, 
even IDE), when a model-specific response to some protocol oddity
might cause group failures.

nowadays, a SATA disk will probably share power, air, vibration with 
its peers, and in some sense, IO load.  but I suspect there's enough
variance in the latter to make synchronized dying uncommon.  at least 
short-scale synchrony.  vendor would be much less relevant to 
power/air/vibration issues.
