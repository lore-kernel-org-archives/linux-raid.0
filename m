From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Re-add not selecting drive for correct slot?
Date: Fri, 7 Aug 2015 14:38:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1508071435340.11810@uplift.swm.pp.se>
References: <1817382.9YhZ7ff5Yl@balsa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1817382.9YhZ7ff5Yl@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 6 Aug 2015, Thomas Fjellstrom wrote:

> Also, sdc has a much lower event count than the other drives, is that
> normal?
>
> /dev/sdc is the first drive that failed
> /dev/sdb is the one that was kicked after

Can you please post dmesg output from when you unplugged the drive and 
what happened to the array then? I guess you do not have "cat 
/proc/mdstat" from then? It's weird that sdb was busy. Please post mdadm 
version and kernel version.

The event count is increased when writes occur to the array, so that sdc 
would have a much lower event count is normal because it was out of the 
array for much longer time than sdb was.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
