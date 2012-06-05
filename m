From: "Joachim Otahal (privat)" <Jou@gmx.net>
Subject: Re: RAID5 with two drive sizes question
Date: Tue, 05 Jun 2012 21:41:39 +0200
Message-ID: <4FCE60F3.4040606@gmx.net>
References: <4FCE4199.7030705@gmx.net> <20120605233953.2086cc4c@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120605233953.2086cc4c@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov schrieb:
> On Tue, 05 Jun 2012 19:27:53 +0200
> "Joachim Otahal (privat)"<Jou@gmx.net>  wrote:
>
>> Hi,
>> Debian 6.0.4 / superblock 1.2
>> sdc1 = 1.5 TB
>> sdd1 = 1.5 TB (cannot be used during --create, contains still data)
>> sde1 = 1 TB
>> sdf1 = 1 TB
>> sdg1 = 1 TB
>>
>> Target: RADI5 with 4.5 TB capacity.
>>
>> The normal case would be:
>> mdadm -C /dev/md3 --bitmap=internal -l 5 -n 5 /dev/sdc1 /dev/sdd1
>> /dev/sde1 /dev/sdf1 /dev/sdg1
>> What I expect: since the first and the second drive are 1.5 TB size the
>> third fouth and fifth drive are treated like 2*1.5 TB, creating a 4.5 TB
>> RAID.
> Lolwhat.

Hey, there is a reason why I ask, no need to lol.

>> What would really be created: I know here are people that know and not
>> guess : ).
> 5x1TB RAID5. Lowest common device size across all RAID members is utilized in
> an array.
>
> But what you do after that, is you also create a separate 2x0.5TB RAID1 from
> the 1.5TB drives' "tails", and join both arrays into a single larger volume using LVM.
>
> The result: 4.5 TB of usable space, with one-drive-loss tolerance (provided by
> RAID5 in the first 4 TB, and by RAID1 in the 0.5TB "tail").

Thanks for clearing that up. I probably would have noticed when trying 
in a few weeks, but knowing beforehand helps.

To make you lol more, following would work too:
Use only 750GB partitions, use the 3*250 GB loss at the end of each 1 TB 
drive for the fourth 750 GB, and RAID6 those 8*750. Result is 4.5 TB 
with a one-drive-loss tolerance and really bad performance.
I spare you the 500 GB partitions example which result in 4.5 TB with a 
one-drive-loss tolerance and really bad performance.

Jou

