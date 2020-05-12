From: antlists <antlists@youngman.org.uk>
Subject: Re: raid6check extremely slow ?
Date: Tue, 12 May 2020 21:54:21 +0100
Message-ID: <34f66548-1fcf-d38b-4c2d-88d43c1b19d0@youngman.org.uk>
References: <20200510120725.20947240E1A@gemini.denx.de>
 <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com>
 <20200511064022.591C5240E1A@gemini.denx.de>
 <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com>
 <20200511161415.GA8049@lazy.lzy>
 <23d84744-9e3c-adc1-3af1-6498b9bcf750@cloud.ionos.com>
 <24249.54587.74070.71273@base.ty.sabi.co.uk> <20200512160943.GC7261@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200512160943.GC7261@lazy.lzy>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Peter Grandi <pg@lxraid.list.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/05/2020 17:09, Piergiorgio Sartor wrote:
> About the check -> maybe lock -> re-check,
> it is a possible workaround, but I find it
> a bit extreme.

This seems the best (most obvious?) solution to me.

If the system is under light write pressure, and the disk is healthy, it 
will scan pretty quickly with almost no locking.

If the system is under heavy pressure, chances are there'll be a fair 
few stripes needing rechecking, but even at it's worst it'll only be as 
bad as the current setup.

And if the system is somewhere inbetween, you still stand a good chance 
of a fast scan.

At the end of the day, the rule should always be "lock only if you need 
to" so looking for problems with an optimistic no-lock scan, then 
locking only if needed to check and fix the problem, just feels right.

Cheers,
Wol
