From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Deleting an raid device
Date: Tue, 25 May 2004 17:10:08 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40B345B0.40108@wasp.net.au>
References: <002501c44257$7135dd80$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002501c44257$7135dd80$6705a8c0@a30>
To: me@heyjay.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

me@heyjay.com wrote:
> Hi,
> 
> What are the proper steps for deleting all remnants of a previous raid
> install?

<I inserted some lame joke here using /dev/zero and dd but I re-thought it after picturing someone 
blindly doing a cut and paste, then cursing me for zeroing their boot disk by mistake.>

> I've done:
> mdadm --stop /dev/md0
> mdadm --zero-superblock /dev/md0
> 
> But I still see it getting stopped on shutdown.

Have you blitzed the /etc/raidtab file? (If you had one that is)
You may be seeing your distribution trying to shutdown the array on shutdown rather than something 
actually being stopped.

Regards,
Brad

