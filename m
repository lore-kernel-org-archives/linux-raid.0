From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: debian9/raid1 assembly/unexpected failure opening device
Date: Thu, 31 Aug 2017 18:12:18 +0100
Message-ID: <59A84372.2090006@youngman.org.uk>
References: <CAGv-CE+UwWraQpVF8hG+OBxj1B7Gwbh7tUcMq7hKz0MQ0NWd-w@mail.gmail.com>
 <CA+res+QAvW_WeULtzwVN8jyYvRgSt8bUFXbHDu5Fg9Wyo85_xw@mail.gmail.com>
 <CAGv-CEJfZZQfQKzwVRdgtkAy7PrAQFL8uKDADkAJZdyQn9NvnQ@mail.gmail.com>
 <59A81E07.3020806@youngman.org.uk>
 <CAGv-CELfookNhwhtXDq89E-8ZZdvOa0tiUHxk-E1Nf_uvh-kQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGv-CELfookNhwhtXDq89E-8ZZdvOa0tiUHxk-E1Nf_uvh-kQw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joel Walberg <joel.walberg@gmail.com>
Cc: Jack Wang <jack.wang.usish@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/08/17 14:51, Joel Walberg wrote:
> While I hadn't seen that section on the Wiki, it's certainly something
> that I'll be using to decide my next purchase after fully reading the
> links that are provided there.

I keep on intending to add a page for the smartctl information sections
from various drives, just haven't got round to it ...

There seem to be three main classes of raid drives out there, WD Reds,
Seagate  NASs, and Toshiba N300 raid drives. Everybody seems to buy
Reds, I've only recently seen NASs, and the N300s come with 4TB the
smallest drive. They all seem to cost about 50% more than the basic
desktop drives, but that's still amazingly cheap ...

Cheers,
Wol
> 
> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
> 
> On Thu, Aug 31, 2017 at 8:32 AM, Wols Lists <antlists@youngman.org.uk> wrote:
>> On 31/08/17 14:12, Joel Walberg wrote:
>>> ## === START OF INFORMATION SECTION ===
>>>>> ## Model Family:     Seagate Barracuda 7200.14 (AF)
>>>>> ## Device Model:     ST3000DM001-1ER166
>>>>> ## Serial Number:    Z5009M1W
>>>>> ## LU WWN Device Id: 5 000c50 07903c6be
>>>>> ## Firmware Version: CC43
>>>>> ## User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>>>> ## Sector Sizes:     512 bytes logical, 4096 bytes physical
>>>>> ## Rotation Rate:    7200 rpm
>>>>> ## Form Factor:      3.5 inches
>>>>> ## Device is:        In smartctl database [for details use: -P show]
>>>>> ## ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
>>>>> ## SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
>>>>> ## Local Time is:    Thu Aug 31 05:31:38 2017 MDT
>>>>> ## SMART support is: Available - device has SMART capability.
>>>>> ## SMART support is: Enabled
>>>>> ## AAM feature is:   Unavailable
>>>>> ## APM level is:     254 (maximum performance)
>>>>> ## Rd look-ahead is: Enabled
>>>>> ## Write cache is:   Enabled
>>>>> ## ATA Security is:  Disabled, frozen [SEC2]
>>>>> ## Wt Cache Reorder: Unavailable
>>
>> Just a quick response - just noticed it and I'm heading out - but.
>> Seagate Barracuda. You have read the section on the wiki about Timeout
>> Mismatch, I take it? These drives do NOT support ERC.
>>
>> Cheers,
>> Wol
> 
> 
> 

