From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Shrinking raid array
Date: Tue, 12 Feb 2013 18:53:06 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302121852000.32644@uplift.swm.pp.se>
References: <511A6554.1010100@ubuntu.com> <511A7052.9020802@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511A7052.9020802@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 12 Feb 2013, Phillip Susi wrote:

> I just noticed that reducing the used dev size has not moved the 
> metadata, so it is looking like it just isn't possible to shrink the md 
> partition with metadata format 1.0?

From "man mdadm"

"The different sub-versions store the superblock at different locations on 
the device, either at the end (for 1.0), at the start (for 1.1) or 4K from 
the start (for 1.2)"

I don't really see how it could be shrunk with a superblock at the end, 
then you wouldn't be able to find it next time...

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
