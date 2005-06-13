From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 02:45:25 -0400
Message-ID: <42AD2B85.30303@pobox.com>
References: <200506111613.42962.dvadell@lantech.com.ar> <20050611192606.GA4055@pentafluge.infradead.org> <42AB49BC.50104@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AB49BC.50104@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "Diego M. Vadell" <dvadell@lantech.com.ar>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Jeff Garzik wrote:
> 
>> On Sat, Jun 11, 2005 at 04:13:42PM +0000, Diego M. Vadell wrote:
>>
>>> Hi,
>>>   A new computer arrived at work with 4 160GB SATA disks. I made a
>>> couple of RAID 1 (mirror) with two disks each, and then joined them wih
>>> LVM. Now I have 320GB in my root volume.
>>>
>>> My boss asked me to test it, so we all gathered and unplugged the data
>>> cable of one of the disks. I was hoping to see linux making warnings for
>>
>>
>> Hotplug is not supported yet.  Don't do that :)
> 
> 
> It isn't hotPLUG -- it's hotUNplug.  Happens when drive is dying for

Same difference to me:  both require new code.

	Jeff



