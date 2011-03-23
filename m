From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Convert RAID5 to RAID6 in a live system
Date: Wed, 23 Mar 2011 09:07:56 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1103230905480.4842@uplift.swm.pp.se>
References: <201103230843.59080.stefan.roese@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103230843.59080.stefan.roese@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Roese <stefan.roese@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 23 Mar 2011, Stefan Roese wrote:

> I'm currently in the process of converting a 3 disk RAID5 array into a 4 disk
> RAID5 array. I'm using mdadm 3.1.4 and Linux kernel 2.6.35-28-generic
> (Ubuntu). My questions now is this conversion save in a live (running) system?
> Or is this now allowed/supported?

I guess you wanted to say "4 disk RAID6 array"?

In that case, yes, I have done it on 2.6.32 and mdadm version (something 
older) and it went just fine.

Neil wrote about it here <http://neil.brown.name/blog/20090817000931>.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
