From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: [BUG?] count of "Spare Devices" wrong after fail/remove/add
Date: Wed, 22 Jan 2003 09:46:24 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E2E5A60.5070309@fl.priv.at>
References: <3E2CA044.5030202@fl.priv.at> <15918.7346.888218.690481@notabene.cse.unsw.edu.au>
Reply-To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15918.7346.888218.690481@notabene.cse.unsw.edu.au>
To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday January 21, fl@fl.priv.at wrote:
>>  Active Devices : 2
>>Working Devices : 2
>>  Failed Devices : 0
>>   Spare Devices : 2
>>
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       3        1        0      active sync   /dev/hda1
>>        1      22        1        1      active sync   /dev/hdc1
>>            UUID : d876333b:694e852b:e9a6f40f:0beb90f9
>>
>>I do wounder why I've got 2 spare drives despite the fact that I
>>did not add any. I've just got two drives in this raid1 that's it.
> 
> Yes, it's probably a bug in the kernel code. The counting in the 2.4 code is very
> clumsy.  I think it is benign so it wont be fixed.  The code in 2.5 is
> very different and shouldn't have this problem.

Ok. Just wanted to let you know.


>>PS: Array Size : 40209024 (38.35 GiB 41.22 GB)
>>should IMHO be
>>     Array Size : 40209024 (38.35 GiB 40.21 GB)
> 
> I disgree. An array side of 40209024 means that many kibibytes.
> i.e. 40209024 * 1024 which is
>    41174040576  bytes.
> 

Hmmm...why don't we forget about this kibibytes sh.. anyways,
it's not worth the troubles IMHO.

-- 
MfG / Regards
Friedrich Lobenstock

