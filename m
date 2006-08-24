From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: Linux: Why software RAID?
Date: Thu, 24 Aug 2006 07:43:30 +0200 (MEST)
Message-ID: <Pine.GSO.4.64.0608240742000.16414@montezuma.acc.umu.se>
References: <44ED1E41.40606@garzik.org> <44ED3723.3090308@nortel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44ED3723.3090308@nortel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Friesen <cfriesen@nortel.com>
Cc: Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, marc@perkel.com
List-Id: linux-raid.ids

On Wed, 23 Aug 2006, Chris Friesen wrote:

> Jeff Garzik wrote:
>
>> But anyway, to help answer the question of hardware vs. software RAID, I 
>> wrote up a page:
>>
>>     http://linux.yyz.us/why-software-raid.html
>
> Just curious...with these guys 
> (http://www.bigfootnetworks.com/KillerOverview.aspx) putting linux on a PCI 
> NIC to allow them to bypass Windows' network stack, has anyone ever 
> considered doing "hardware" raid by using an embedded cpu running linux 
> software RAID, with battery-backed memory?

I'd expect this to be the reason why md offload support to xor engines and 
whatever turns up. It makes very little sense for a modern server/desktop 
CPU, but for the embedded ones it does.

/Mattias Wadenstein
