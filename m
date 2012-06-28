From: George Shuklin <george.shuklin@gmail.com>
Subject: Re: how to get 'peer disk' in raid configuration?
Date: Thu, 28 Jun 2012 08:37:07 +0400
Message-ID: <4FEBDF73.4070107@gmail.com>
References: <4FEB9C69.9060608@gmail.com> <20120628102652.12521e0b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120628102652.12521e0b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On 28.06.2012 04:26, NeilBrown wrote:
> On Thu, 28 Jun 2012 03:51:05 +0400 George Shuklin<george.shuklin@gmail.com>
> wrote:
>
>> Few days ago met intersting question:
>>
>> Let assume we have RAID10 on 4 disks. We want to remove two  disks
>> without  breaking array.
>>
>> How we can know which drive is safe to eject? For 1st drive it obvious:
>> any of. Second is more complicated: we need eject mirror part of 'second
>> pair'.
> Rules is simple.  Don't remove adjacent devices (where the last is
> considered to be adjacent to the first).
>
> There are some pairs of adjacent devices that it is safe to remove, but it is
> always safe to remove a device that is not adjacent to a removed devices.
>
>> How we can know exact topology of raid? (--detail does not provide
>> enough information, IMHO).
> What - exactly - would you like to see in --detail.
> Your answer must take into account the possibility of an odd number of
> devices, of more than 2 copies of each block, and of near, far, and offset
> modes.
>
> (Patches preferred, but English-language descriptions are acceptable :-)
Well... Actually I've prefer to have something like --fail-safe, which 
will reject 'fail' operation for disk in array if this will make array 
unusable. I'm not sure if this can be adequately represented in 
--detail  (f.e. RAID10 on 5 disks), but some kind of 'safe operations' 
will be really nice.

N.B. Few month ago HP launch it new servers, with special indicator on 
enclosure for 'critical drives' which shall not be ejected (or array 
will fail). I think have some way to get that information for linux-raid 
will be really nice...
