From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Need Help with crashed RAID5 (that was rebuilding and then had
 SATA error on another drive)
Date: Mon, 29 Aug 2016 09:54:21 +1000
Message-ID: <3b008fb0-1fb3-f12f-d973-3657de6e6923@websitemanagers.com.au>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <215fd175-65b6-e24b-338f-0c44ae030573@websitemanagers.com.au>
 <CADDTLRBf9NPO6OuF4a3b+xffZgeZRqHRG+pJdPmbc9-Jat0HVQ@mail.gmail.com>
 <d6d3fe0d-3f9f-985f-9bfb-051428cf221b@websitemanagers.com.au>
 <57BBDA5B.3020706@gmail.com> <57BBDC15.5030301@gmail.com>
 <b8c6a380-7e6a-fda9-5834-b85271b26892@websitemanagers.com.au>
 <57BC61F7.8070102@gmail.com>
 <aca4e83f-9a3f-c200-7c16-3b5d9df52c1e@websitemanagers.com.au>
 <57BE450B.4030700@gmail.com>
 <56e86db5-456d-e9c1-339d-ba8903fe5dde@websitemanagers.com.au>
 <57BE52BC.6040908@gmail.com>
 <933228e0-bce4-ffad-f48d-034bf89bc07f@websitemanagers.com.au>
 <57BF9965.1020403@gmail.com> <57C0856D.8050209@youngman.org.uk>
 <57C32D8E.9030102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57C32D8E.9030102@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/08/16 04:29, Benjammin2068 wrote:
>
> On 08/26/2016 01:07 PM, Wols Lists wrote:
>> On 26/08/16 02:20, Ben wrote:
>>> [root@quantum ~]# smartctl -a /dev/sde
>>> smartctl 5.43 2012-06-30 r3573 [x86_64-linux-2.6.32-642.el6.centos.plus.x86_64] (local build)
>>> Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Seagate Barracuda (SATA 3Gb/s, 4K Sectors)
>>> Device Model:     ST1000DM003-1ER162
>>> Serial Number:    Z4YDLXWJ
>>> LU WWN Device Id: 5 000c50 091877801
>>> Firmware Version: CC45
>>> User Capacity:    1,000,204,886,016 bytes [1.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Device is:        In smartctl database [for details use: -P show]
>> Sorry Ben - that drive was NOT a smart buy !!! Seagate Barracuda :-(
>>
>> You MUST enable the timeout on this drive :-(
>>
>> Gut feel tells me most 1TB or less drives are okay in a raid - the
>> Barracudas are an exception :-( I've got two 3TB Barracudas mirrored,
>> and from reading the list, there's no way I'd go raid5 for more capacity
>> without ditching them.
>>
>> Most people seem to get WD Reds - I've asked about Seagate NAS but I've
>> not picked up on any reports about them - good or bad. Barracudas - the
>> news is pretty much all bad :-(
>>
>>
> Yea, I figured that out -- just couldn't find a decent detailed reference with what "SCT status supported" means versus the more fully featured.
When I saw this, I assume it means you can ask for the status, and it 
will tell you it is disabled, but there is no support to modify the 
status (ie, turn it on). Totally useless for all intents and purposes....

Then again, I could be wrong... but compared to your other drive which 
showed additional supports, or on my one here:
SCT capabilities:              (0x0039) SCT Status supported.
                                         SCT Error Recovery Control 
supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

ie, the second one is probably what you want, the third allows you to 
turn it on/off, and no idea about the last option....

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
