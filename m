From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID 5: weird size results after Grow
Date: Sun, 14 Oct 2007 01:05:43 -0400
Message-ID: <4711A3A7.8060900@tmr.com>
References: <47107DB5.10103@iki.fi> <4710C337.40708@tmr.com> <4710F021.30508@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4710F021.30508@iki.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Marko Berg <marko.berg@iki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Marko Berg wrote:
> Bill Davidsen wrote:
>> Marko Berg wrote:
>>> I added a fourth drive to a RAID 5 array. After some complications 
>>> related to adding a new HD controller at the same time, and thus 
>>> changing some device names, I re-created the array and got it 
>>> working (in the sense "nothing degraded"). But size results are 
>>> weird. Each component partition is 320 G, does anyone have an 
>>> explanation for the "Used Dev Size" field value below? The 960 G 
>>> total size is as it should be, but in practice Linux reports the 
>>> array only having 625,019,608 blocks.
>>
>> I don't see that number below, what command reported this?
>
> For instance df:
>
> $ df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/md0             625019608 358223356 235539408  61% /usr/pub
>
>>> How can this be, even though the array should be clean with 4 active 
>>> devices?

df reports the size of the filesystem, mdadm reports the size of the array.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

