From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 14:54:16 -0400
Message-ID: <487E43D8.60106@hp.com>
References: <1216130769.5633.318.camel@sam.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216130769.5633.318.camel@sam.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Martin <monkeyiq@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ben Martin wrote:
> Hi,
>   Apologies if posting this here is inappropriate but a recent article
> of mine compares the Linux Kernel RAID code to an $800 hardware RAID
> card and might be of interest to list members:
> 
> http://www.linux.com/feature/140734
> 

Hi Ben -

Did you do any performance testing of running /multiple/ disks through
the Adaptec card w/out HW RAID enabled - for example, comparing the 4
ports on the mobo against 4 drives exported through the Adaptec card?

I wonder if there are any potential bottleneck issues with the single
adapter card handling 6 independent drives (when testing SW RAID) versus
one exported "drive" (when testing HW RAID).

Regards,
Alan
