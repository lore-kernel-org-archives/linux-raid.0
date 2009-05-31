From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Upgrading a software RAID
Date: Sun, 31 May 2009 02:17:30 +0200
Message-ID: <20090531001730.GA16311@rap.rap.dk>
References: <4A1EA095.9090406@usherbrooke.ca> <4A217BA8.1080208@tmr.com> <4A217C6C.7080301@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A217C6C.7080301@usherbrooke.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Cc: Bill Davidsen <davidsen@tmr.com>, robin@robinhill.me.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 30, 2009 at 02:35:24PM -0400, Maxime Boissonneault wrote:
>
>>>
>>> I can not install more drives in the computer. It is a home theater  
>>> computer in a small case. I was expecting to be able to let the raid  
>>> manage the copies itself.
>>>
>>> If the / was on a RAID5, would it be able to boot with 2 disks ?
>>> If so, is it possible to convert my RAID0 to a RAID5 ?
>>> For example, I could boot on a CD, backup / onto /home, delete the  
>>> RAID0 array and recreate it as RAID5, then restore the backup. Would  
>>> this work ?
>>
>> Based on my testing (somewhat old now) and regular use, I would say  
>> raid10 is probably your best bet. It's fast and secure, and with the  
>> -f2 option for "far" copies it's able to give high transfer rates.
>
> Doesn't RAID10 means RAID 1+0, which requires 4 disks ?

Linux RAID10 is somewhat different from raid1+0, and can run with just 2
disks, with fine performance for reads in the F2 layout, almost raid0
performance, while write performance is close to raid1, with a file system in operation.

Best regards
keld
