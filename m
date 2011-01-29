From: David Brown <david.brown@hesbynett.no>
Subject: Re: raid over ethernet
Date: Sat, 29 Jan 2011 19:34:12 +0100
Message-ID: <ii1mj5$mah$1@dough.gmane.org>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com> <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/01/11 07:42, Mikael Abrahamsson wrote:
> On Fri, 28 Jan 2011, Roberto Spadim wrote:
>
>> hi guys, i was thinking about raid over ethernet... there's a solution
>> to make a syncronous replica of my filesystem? no problem if my
>> primary server get down, i can mout my replica fsck it and continue
>> with available data
>> i was reading about nbd, anyone have more ideas?
>
> Look into AoE (ATA over Ethernet).
>

I think AoE is limited to fairly direct connections - it doesn't use IP, 
and can't be routed (at least not easily - I'm sure it is possible if 
you try hard enough).  The alternative is iSCSI, which does use IP and 
can therefore be routed and passed around over networks.  AoE is 
therefore slightly more efficient, and iSCSI more flexible.

If you are looking at making a raid1 with an iSCSI or AoE target as one 
of the disks, consider using a write-intent bitmap and the 
--write-mostly and --write-behind flags.

