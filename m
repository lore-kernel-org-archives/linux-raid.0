From: Pieter De Wit <pieter@insync.za.net>
Subject: Re: Looking for help how to migrate 2disk RAID1 to 3 disk RAID6
Date: Thu, 02 Jan 2014 11:06:03 +1300
Message-ID: <52C4914B.90301@insync.za.net>
References: <1388537511.5058.22.camel@oxygen.netxsys.com>	 <52C36908.2010701@insync.za.net>	 <1388552041.5058.25.camel@oxygen.netxsys.com>	 <52C3EEE2.10402@insync.za.net> <1388589051.5058.43.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1388589051.5058.43.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k-list@adamski.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/01/2014 04:10, Krzysztof Adamski wrote:
> On Wed, 2014-01-01 at 23:33 +1300, Pieter De Wit wrote:
>
> Based of what you are saying you probably would not believe that RAID5
> can be made with 2 drives, DATA + 1 PARITY. But Linux RAID supports that
> just fine (thanks Neil).
Yeah - you right there - I can't see why you would have a "RAID1 set 
with parity", nor can I see how the calculations would work. Then again, 
I am not a MD developer and I am not going to look at the source code. I 
would like to know what the command line would look like to create this, 
for educational purposes.
> Hot spares are a joke, you have to wait for a drive to fail before you
> use them, that can be to late. A 3 drive RAID1 make more sense. On one
> system I have a 8 drive RAID1 (the /boot partition) the / (root)
> partition is a 8 drive RAID6.
>
>
IMHO, you have answered your question of what RAID level you need to 
run, RAID1. As for your original question of the data migration, I would 
move the data over on a filesystem level. I used to have this neat trick 
where by I created soft symlink between the "new" and "old" locations, 
from memory, it only works between different block devices. You then 
instruct linux to copy the data to "itself". Since it's a symlink it 
copies the data to the new device. It was something along those lines. 
You need to mount the source as read only, iirc. Contact me off list if 
you want more details.

Cheers,

Pieter
