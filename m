From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: RAID-6 corruption
Date: Fri, 30 Jul 2004 15:47:21 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <cedqi9$nh$1@terminus.zytor.com>
References: <20040729212046.GA27332@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <20040729212046.GA27332@jim.sh>
By author:    Jim Paris <jim@jtan.com>
In newsgroup: linux.dev.raid
> 
> Hello,
> 
> (I've posted some messages about this to linux-raid, but haven't
> gotten much of a response; this time I'm cc'ing to linux-kernel)
> 

I haven't seen any of those messages, so this is the first case happening.

> I am seeing reproducible corruption with software RAID-6 on an array
> that has been created with missing disks.  The attached script
> demonstrates this easily through loopback devices, but I see the
> problem just the same on real drives.
> 
> I do not see the problem with full RAID-6 arrays (no missing disks),
> nor do I see it on RAID-5 arrays on the same system.  I haven't seen
> the corruption when writing directly to the md device, but I haven't
> tested that very much.
> 
> Tested on 2.6.6, 2.6.7, 2.6.8-rc2, with mdadm 1.5.0 and 1.6.0.
> See attached.

I will look at it.

	-hpa
