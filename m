From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: sata_nv and RAID1
Date: Sun, 12 Jun 2005 00:29:48 +0400
Message-ID: <42AB49BC.50104@tls.msk.ru>
References: <200506111613.42962.dvadell@lantech.com.ar> <20050611192606.GA4055@pentafluge.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050611192606.GA4055@pentafluge.infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Diego M. Vadell" <dvadell@lantech.com.ar>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
> On Sat, Jun 11, 2005 at 04:13:42PM +0000, Diego M. Vadell wrote:
> 
>>Hi,
>>   A new computer arrived at work with 4 160GB SATA disks. I made a
>>couple of RAID 1 (mirror) with two disks each, and then joined them wih
>>LVM. Now I have 320GB in my root volume.
>>
>>My boss asked me to test it, so we all gathered and unplugged the data
>>cable of one of the disks. I was hoping to see linux making warnings for
> 
> Hotplug is not supported yet.  Don't do that :)

It isn't hotPLUG -- it's hotUNplug.  Happens when drive is dying for
example, or when the cable is flaky, or due to millions of other
reasons...  And.. I for one expect linux to react to such a situation
*somehow* - after all, raid is used for this very stuff too, to be
able to continue running a system if one of the drives failed...

/mjt
