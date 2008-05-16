From: David Greaves <david@dgreaves.com>
Subject: Re: Regression- XFS won't mount on partitioned md array
Date: Fri, 16 May 2008 19:05:01 +0100
Message-ID: <482DCCCD.8020503@dgreaves.com>
References: <482DC043.5000307@dgreaves.com> <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

> Ouch, still on 2.6.25.1 here, didn't reboot yet, but I do not use
> mdraid'ed partitions, just regular mdraid, if you boot back to 2.6.20.7
> does it work again?
Yes, no probs.

It came in prior to 2.6.25-rc1
The machine has a root xfs filesystem with an internal log on a sata disk and a
data filesystem on a partitioned array with an external log (also on the
partitioned array).
Only the partitioned array/external-log filesystem is affected.

David

