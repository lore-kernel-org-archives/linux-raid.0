From: EJ Vincent <ej@ejane.org>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Sun, 30 Sep 2012 15:20:12 -0400
Message-ID: <50689B6C.8000307@ejane.org>
References: <loom.20120930T105755-205@post.gmane.org> <alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/30/2012 6:04 AM, Mikael Abrahamsson wrote:
> On Sun, 30 Sep 2012, EJ wrote:
>
>> Fast forward to now, I've upgraded the system to 12.04 LTS and have 
>> lost access to my array. The array itself is a nine (9) disk raid6 
>> managed by mdadm.
>
> What version of kernel for 12.04 were you running?
>
> If you didn't upgrade your kernel, you might have been hit by the bug 
> described in:
>
> <http://neil.brown.name/blog/20120615073245>
>

Hello,

I'm running the stock version of Ubuntu 12.04.0, using kernel 
3.2.0-23-generic.

That link looks interesting-- I'm not sure if I triggered the bug how 
Mr. Neil Brown describes it, but I definitely have symptoms on some (not 
all) the disks of RAID level "-unknown-" and devices appearing to be 
spares.

I'm hesitant to re-create the array again (using mdadm) because 
according to that blog post, for RAID-6, the order of devices are 
important, and with this being a 9 disk array and no record of device 
order in logs or from my own memory, I have no idea what the proper 
order might be.

I do know that 1) I was using metadata version 1.2, 2) the array was not 
degraded and subsequently 3) no disks were missing.

Am I over-estimating the importance of the order and should proceed with 
the re-creation, or perhaps wait for Neil himself to weigh in the problem?

Thanks for all the responses, much appreciated.

-EJ
