From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Wed, 23 Feb 2011 17:14:31 -0600
Message-ID: <4D6594D7.7020609@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <4D63BC6D.8010209@hardwarefreak.com> <ik0gkm$nn$1@dough.gmane.org> <4D64A082.9000601@hardwarefreak.com> <ik33nt$fd8$1@dough.gmane.org> <4D6518ED.1080908@anonymous.org.uk> <ik38ch$amr$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ik38ch$amr$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown put forth on 2/23/2011 9:15 AM:

> Basically you are comparing a 4-drive RAID-6 to a 4-drive RAID-10.  I
> think the RAID-10 will be faster for streamed reads, and a lot faster

In this 4 drive configuration, RAID6 might be ever so slightly faster in
read performance, but RAID10 will very likely be faster in every other
category, to include degraded performance and rebuild time.  I can't say
definitively as I've not actually tested these setups head to head.

> for small writes.  You get improved safety in that you still have a
> one-drive redundancy after a drive has failed, but you pay for it in
> longer and more demanding rebuilds.

Just to be clear, you're saying the RAID6 rebuilds are longer and more
demanding than RAID10.  To state the opposite would be incorrect.

-- 
Stan
