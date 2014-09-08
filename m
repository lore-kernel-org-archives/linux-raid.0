From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID0 size over 2 TB
Date: Mon, 8 Sep 2014 12:19:24 -0600
Message-ID: <EC31326C-A2AE-4096-8542-E8E9BD5A43B7@colorremedies.com>
References: <20140906230928.BB645CEE@pobox.sk>, <20140908170037.451e2376@notabene.brown>, <20140908091811.1DD1140C@pobox.sk> <alpine.DEB.2.02.1409080920510.14735@uplift.swm.pp.se> <20140908092450.8E735FB7@pobox.sk>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140908092450.8E735FB7@pobox.sk>
Sender: linux-raid-owner@vger.kernel.org
To: azurIt <azurit@pobox.sk>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 8, 2014, at 1:24 AM, azurIt <azurit@pobox.sk> wrote:

>> 
>> CC: linux-raid@vger.kernel.org
>> On Mon, 8 Sep 2014, azurIt wrote:
>> 
>>> I, of course, didn't use fdisk to create partitions - they were created using cgdisk, but it's graphical tool so i wasn't able to send output from it, so i get output from fdisk to prove, that partitions are large enough.
>>> 
>>> # cat /proc/partitions
>>> major minor  #blocks  name
>>> 
>>>  8       33 2147483647 sdc1
>>>  8       49 2147483647 sdd1
>> 
>> .... they're not.
>> 
>> -- 
>> Mikael Abrahamsson    email: swmike@swm.pp.se
> 
> 
> 
> 
> so why cgdisk and also fdisk sees them as 4TB?

Newer versions of fdisk do support GPT. Yours isn't new enough. Since you have cgdisk, you should use:

gdisk -l /dev/sdc

or

parted -s /dev/sdc u s p


Chris Murphy