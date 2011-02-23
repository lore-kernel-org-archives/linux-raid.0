From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: removing AHCI SATA devices
Date: Wed, 23 Feb 2011 08:27:47 +0000
Message-ID: <4D64C503.1080304@gmail.com>
References: <AANLkTimkAMh9T0G_6XyajcMVv9gbNn1-gPpvmBSAAfPY@mail.gmail.com> <4D642C54.9040604@garzik.org>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D642C54.9040604@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thanks Jeff.   It just seems like a hit and miss solution (no way of 
knowing all data has been written to and that the device has been 
unmounted from all filesystems).  I kinda expected some kind of 'it is 
safe to remove /dev/sdb' in dmesg.

cheers
Simon

On 22/02/2011 21:36, Jeff Garzik wrote:
> On 02/22/2011 11:05 AM, Simon Mcnair wrote:
>> hi all,
>> Whilst I am aware that with AHCI and SATAII I can just unplug a HDD at
>> will what is the correct process for doing a 'clean' dismount ?
>>
>> Since MD is a layer over the top of the physical device how can you
>> ensure with certainty that all data has been flushed and the device
>> removal is clean ?
>
> Simply unplugged the hard drive's SATA cable should be fine.
>
>     Jeff
>
>
>
