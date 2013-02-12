From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Shrinking raid array
Date: Tue, 12 Feb 2013 19:43:57 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302121942490.32644@uplift.swm.pp.se>
References: <511A6554.1010100@ubuntu.com> <511A7052.9020802@ubuntu.com> <alpine.DEB.2.00.1302121852000.32644@uplift.swm.pp.se> <511A85D8.5070803@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511A85D8.5070803@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 12 Feb 2013, Phillip Susi wrote:

> You move the superblock, then shrink the partition...

As far as I know, mdadm has no code to shrink partitions?

> But it looks like mdadm doesn't move the superblock even though it no
> longer is using the full partition.

I think that is perfectly reasonable. Otherwise the superblock wouldn't be 
found next time if the partition wasn't resized.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
