From: Eric Shubert <ejs@shubes.net>
Subject: Re: MD raid and different  elevators  (disk i/o schedulers)
Date: Thu, 29 Jul 2010 10:23:31 -0700
Message-ID: <i2sdej$hhu$2@dough.gmane.org>
References: <4C51540E.9050005@kurgan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C51540E.9050005@kurgan.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Fabio Muzzi wrote:
> 
> I have tried to find information about this question in google, but 
> found nothing.
> 
> The question is: are there issues using different disk i/o schedulers 
> (by appending elevator=xxx to the kernel boot command line) when using 
> md RAID1 or RAID5?
> 
> I seem to remember that someone told me that using elevator=deadline can 
> cause perfectly good disks to be kicked from the RAID because of some 
> latency issues that make the disk seem unresponsive (and dead) to the 
> raid software.
> 
> Is this true? Are there compatibility issues using different i/o 
> schedulers with software raid?
> 
> 
> Thanks
> 

I've been running several vmware server hosts with elevator=deadline on 
raid1 for a year or so now, with no problems.

-- 
-Eric 'shubes'

