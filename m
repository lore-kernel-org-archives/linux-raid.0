From: Hubert Verstraete <hubskml@free.fr>
Subject: Re: mdadm 2.6 creates slow RAID 5 while mdadm 2.5.6 rocks
Date: Mon, 11 Feb 2008 09:38:12 +0100
Message-ID: <47B00974.5030303@free.fr>
References: <47AC7463.7000502@free.fr> <20080208081649.rfx07p98ckcgc0sg@estone.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080208081649.rfx07p98ckcgc0sg@estone.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

michael@estone.ca wrote:
> Quoting Hubert Verstraete:
>
>> Hi All,
>>
>> My RAID 5 array is running slow.
>> I've made a lot of test to find out where this issue is laying.
>> I've come to the conclusion that once the array is created with mdadm
>> 2.6.x (up to 2.6.4), whatever the kernel you run, whatever the mdadm
>> you use to re-assemble the array, the array's performance is very
>> degraded.
>>
>> Would this be a bug in mdadm 2.6 ?
>> Are you seeing this issue too ?
> I may have seen this before too.
> What happens if you don't make an array that is partitionable?
> Just create an /dev/mdx device, or, if you must use a partitionable 
> array,
> what happens to your benchmarks on your 2nd partition of your array?
> Say, /dev/md_d0p2 ?
>
> My symptons were similar that any partitionable Raid 5 array would be 
> slower, but ony on the first partition.
> mdadm version 2.5.6
> kernel 2.6.18
>
> Mike
Thanks for the idea.
I've tried with a non partitionable array and with a 2nd partition and 
got the same damn slow result on write performance :(

I'm appending the two new tests to the bonnie results:
2.6.18.8_mdadm_2.5.6,4G,,,38656,5,24171,6,,,182130,26,518.9,1,16,1033,3,+++++,+++,861,2,1224,3,+++++,+++,806,3 

2.6.18.8_mdadm_2.6.4,4G,,,19191,2,15845,4,,,164907,26,491.9,1,16,697,2,+++++,+++,546,1,710,2,+++++,+++,465,2 

2.6.22.6_mdadm_2.5.6,4G,,,49108,8,29441,7,,,174038,21,455.5,1,16,1351,4,+++++,+++,1073,3,1416,5,+++++,+++,696,4 

2.6.22.6_mdadm_2.6.4,4G,,,18010,3,16763,4,,,185106,24,421.6,1,16,928,6,+++++,+++,659,3,871,7,+++++,+++,699,3 

2.6.24-git17_mdadm_2.5.6,4G,,,126319,24,34342,4,,,79924,0,180.8,0,16,1566,5,+++++,+++,1459,3,1800,4,+++++,+++,1123,2 

2.6.24-git17_mdadm_2.6.4,4G,,,24482,4,19717,3,,,79953,0,594.6,2,16,918,3,+++++,+++,715,2,907,3,+++++,+++,763,2 

2.6.24-git17_mdadm_2.6.4_partition_2,4G,,,24338,4,21351,4,,,170408,19,580.7,1,16,933,3,+++++,+++,889,3,895,3,+++++,+++,725,2 

2.6.24-git17_mdadm_2.6.4_non_partitionable,4G,,,23798,4,20845,4,,,169994,19,627.7,1,16,1257,3,+++++,+++,1068,3,1180,4,+++++,+++,872,2 


Nevertheless, in the 2 tests, the read performance is back to the one I 
had in 2.6.22 and before. There might be a regression in 2.6.24 for 
reading on the first partition of a partionable array...

Hubert
