From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Re-add not selecting drive for correct slot?
Date: Sat, 8 Aug 2015 08:11:09 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1508080809570.11810@uplift.swm.pp.se>
References: <1817382.9YhZ7ff5Yl@balsa> <alpine.DEB.2.02.1508071435340.11810@uplift.swm.pp.se> <14110213.gd3e4izigE@nell>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14110213.gd3e4izigE@nell>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 8 Aug 2015, Thomas Fjellstrom wrote:

> On August 7, 2015 02:38:22 PM Mikael Abrahamsson wrote:
>> On Thu, 6 Aug 2015, Thomas Fjellstrom wrote:
>>> Also, sdc has a much lower event count than the other drives, is that
>>> normal?
>>>
>>> /dev/sdc is the first drive that failed
>>> /dev/sdb is the one that was kicked after
>>
>> Can you please post dmesg output from when you unplugged the drive and
>> what happened to the array then? I guess you do not have "cat
>> /proc/mdstat" from then? It's weird that sdb was busy. Please post mdadm
>> version and kernel version.
>
> I posted both after the logs in the previous message, but I'll repeat here:
>
> Distro: OpenMediaVault / Debian wheezy
> Kernel: 3.16.7-ckt4-3~bpo70+1
> Mdadm: v3.2.5 (from debian) and v3.3.4-22-gccc93b3 - 05th August 2015

Ah, my bad.

First, I would recommend you to get the latest mdadm from Neils git 
repository, compile it and try to use --assemble--force using that mdadm 
instead, using the drives with the closest event count.

Hopefully it will work and not treat the drive as a spare.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
