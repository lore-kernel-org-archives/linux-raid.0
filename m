From: Claudiu Rad-Lohanel <jazzman@misalpina.net>
Subject: Re: recovering failed and unrecognizable RAID5 during mdadm --grow
 without backup
Date: Fri, 13 May 2016 17:26:02 +0300
Message-ID: <3b4ae5f5-af19-744b-cab3-aad317ea3a82@misalpina.net>
References: <1b26650f-0b2c-2485-f781-e3fd26340741@misalpina.net>
 <5734D23D.6030400@turmel.org>
 <f06998d6-8e1e-c8ea-a22c-1307935092c3@misalpina.net>
 <5734E637.6030307@turmel.org>
 <7cf56631-7909-6a92-f0b2-05dd02722ee8@misalpina.net>
 <5735DF05.8080706@turmel.org> <5735E07F.2030802@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5735E07F.2030802@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 5/13/2016 5:11 PM, Phil Turmel wrote:
> On 05/13/2016 10:04 AM, Phil Turmel wrote:
>> On 05/12/2016 05:37 PM, Claudiu Rad wrote:
>>
>>> how can i safely stop this reshape and assuming my / partition inside
>>> the array is sane enough restart the actual server normally after
>>> fsck-ing all volumes?
>> Well, your root is inside the array.  So you won't be able to boot
>> without the array assembling in the initramfs, which needs manual
>> intervention to supply the backup file.
> Actually, if it still isn't too far into the reshape, you could use
> --revert-reshape.  Then it'll reshape back to the original chunk size
> what it has done so far.  That might be quicker than finishing the
> reshape.  Then you could reboot into your normal OS.

this is interesting.

1. i can't find any documentation anywhere about the --revert-reshape 
option. how should the command look like? is it available in v3.3.2?

2. is it safe?

-- 
jazzman

