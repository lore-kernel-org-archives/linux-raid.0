From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Fri, 15 Feb 2013 15:51:01 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302151549040.32644@uplift.swm.pp.se>
References: <20130215125936.166240@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130215125936.166240@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 15 Feb 2013, Dragon wrote:

> In my case the superblock seems to be on all disks persistant, i use the same version and chunk-size.

The problem is that you used --create which just overwrites your old 
superblocks. So the information on your current superblocks might very 
well be wrong. The order of the drives might be wrong, you might have 
wrong chunk size, you might have wrong data offset, you might even have 
wrong superblock version.

Since you didn't save the superblock information before you did --create, 
it's hard to give you advice on how to proceed.

If you have old log entries (syslog) from when the raid was successfully 
started and stopped before you ran into trouble, that might contain some 
information that might help.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
