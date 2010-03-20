From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID1 On 3 Drives
Date: Sat, 20 Mar 2010 12:08:40 -0400
Message-ID: <4BA4F308.8010303@tmr.com>
References: <4B9C11FB.7040604@gmx.net>	 <d80f793f1003131518u2bfe77e9k52ef77e3d2c68360@mail.gmail.com>	 <4B9C24B6.7040507@tmr.com> <d80f793f1003150530y1b229f43s1f140f91ab74f3e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1003150530y1b229f43s1f140f91ab74f3e8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Mennens <carloswill@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Carlos Mennens wrote:
> On Sat, Mar 13, 2010 at 6:50 PM, Bill Davidsen <davidsen@tmr.com> wrote:
>   
>> Having a spare on raid-1 is fairly pointless, it hurts performance and buys
>> you nothing. Having one more copy of the data built and ready serves you
>> better.
>>     
>
> Can you explain this as I find this interesting. How does having a
> /boot partition on 3 drives with 1 spare hurt performance? Are you
> saying that I would get better drive performance if I had all 4 disk
> partitions active members of my RAID1 /boot? I just don't understand
> how the 4th disk doing nothing but acting as a spare would hinder
> performance.
>
>   
In RAID-1 any drive which is a member of the array is already a spare, 
they are all the same. So if a drive failed you would just stop using 
it. Having a spare makes no sense, since the spare would be rebuilt 
using the same data it would have contained as a member of the array. 
Note that while the "spare" is being rebuilt the array will be quite 
busy and response will be poor, not an issue if /boot is the only thing 
on the drives, but more of an issue if the array just uses partitions 
and the thrashing of a spare rebuild slows other arrays on the same drives.

Finally, RAID-1 supposedly will read from an unbusy drive if there are 
multiple reads against the array, allowing overlapping of seek and 
transfer. That's only an issue for /boot if you are trying for a ten 
second boot time, but it applies to all RAID-1 arrays.

> Secondly, if the above statement also applies to my / partition? Would
> you suggest using all 4 drives as active partitions in a RAID5 array
> too? If I have a 3 disk RAID5 and one hot spare, do you think I would
> get less performance value for my configuration?
>   

No, because the drives are not all the same, so you can't keep a copy of 
just the drive ready to fail next. For RAID-[456&10] you want at least 
one spare for reliability and fast return to full performance.

Ask again if I didn't give enough detail.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

