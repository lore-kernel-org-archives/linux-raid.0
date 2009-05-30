From: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Subject: Re: Upgrading a software RAID
Date: Sat, 30 May 2009 14:35:24 -0400
Message-ID: <4A217C6C.7080301@usherbrooke.ca>
References: <4A1EA095.9090406@usherbrooke.ca> <4A217BA8.1080208@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A217BA8.1080208@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: robin@robinhill.me.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>>
>> I can not install more drives in the computer. It is a home theater 
>> computer in a small case. I was expecting to be able to let the raid 
>> manage the copies itself.
>>
>> If the / was on a RAID5, would it be able to boot with 2 disks ?
>> If so, is it possible to convert my RAID0 to a RAID5 ?
>> For example, I could boot on a CD, backup / onto /home, delete the 
>> RAID0 array and recreate it as RAID5, then restore the backup. Would 
>> this work ?
>
> Based on my testing (somewhat old now) and regular use, I would say 
> raid10 is probably your best bet. It's fast and secure, and with the 
> -f2 option for "far" copies it's able to give high transfer rates.

Doesn't RAID10 means RAID 1+0, which requires 4 disks ?
