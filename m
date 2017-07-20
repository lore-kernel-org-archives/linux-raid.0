From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Why can't I re-add my drive after partition shrink?
Date: Thu, 20 Jul 2017 11:23:46 +0100
Message-ID: <597084B2.7030205@youngman.org.uk>
References: <2ea5ed99-05b5-25d2-c9d4-8ce1f4945eaa@gmail.com>
 <87tw2f2425.fsf@notabene.neil.brown.name>
 <0341a04d-9aa5-7665-d9ff-527fe9fc8238@gmail.com>
 <87pod0ypmh.fsf@notabene.neil.brown.name>
 <8d3e1264-2f0a-6ee9-52b5-edddc1e6f185@gmail.com>
 <ad3c5c59-dc37-2573-341a-39a381621746@gmail.com>
 <87fudsxbmz.fsf@notabene.neil.brown.name>
 <05a2d9b7-3b6a-2b49-53ad-3436061558fc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05a2d9b7-3b6a-2b49-53ad-3436061558fc@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, NeilBrown <neilb@suse.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/07/17 01:39, Ram Ramesh wrote:
> On 07/19/2017 06:14 PM, NeilBrown wrote:
>> On Wed, Jul 19 2017, Ram Ramesh wrote:
>>
>>> Here is my attempt to repeat the steps in my last attempt to remove,
>>> repartition, re-add. Last time I did it on /dev/sdb. Now I am going to
>>> do it on /dev/sdc. Note that I have not been successful as you see at
>>> the end. I am going to keep the array degraded so that I can still get
>>> old info from /dev/sdc1, if you need anything else. I will keep it this
>>> way till tomorrow and then add the device for md to rebuild. Please ask
>>> anything else before that or send me a note to keep the array degraded
>>> so that you can examine /dev/sdc1 more.
>> Thanks.  I *love* getting all the details.  You cannot send too many
>> details!
>>
>> This:
>>> <good device still in md0>
>>>> zym [rramesh] 265 > sudo  mdadm --examine /dev/sdb1
>>>> /dev/sdb1:
>> ..
>>>>   Avail Dev Size : 6442188800 (3071.88 GiB 3298.40 GB)
>> and this:
>>
>>> <device just removed and repartitioned>
>>>> zym [rramesh] 267 > sudo mdadm --examine /dev/sdc1
>>>> /dev/sdc1:
>> ...
>>>>   Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
>> Shows the key difference.  "Avail Dev Size", aka sb->data_size, is
>> wrong.  We can fix it.
>>
>>> <Cannot re-add!!!!>
>>>> zym [rramesh] 270 > sudo mdadm /dev/md0 --re-add /dev/sdc1
>>>> mdadm: --re-add for /dev/sdc1 to /dev/md0 is not possible
>> Please try
>>     sudo mdadm /dev/md0 --re-add /dev/sdc1 --update=devicesize
>>
>> Thanks,
>> NeilBrown
> 
> Neil,
> 
> Thanks a ton. That does it. It got re-added without any issue. It is
> rebuilding because the array was used to record two TV programs when it
> was in degraded state. But the re-add is accepted.
> 
>> zym [rramesh] 274 > sudo mdadm /dev/md0 --re-add /dev/sdc1
>> --update=devicesize
>> Size was 11720780943
>> Size is 6442188800
>> mdadm: re-added /dev/sdc1
>> zym [rramesh] 275 > cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md0 : active raid6 sdc1[10] sdb1[6] sdg1[11] sdd1[12] sdf1[8] sde1[9]
>>       12348030976 blocks super 1.2 level 6, 64k chunk, algorithm 2
>> [6/5] [UU_UUU]
>>       [========>............]  recovery = 42.6%
>> (1316769920/3087007744) finish=292.2min speed=100952K/sec
>>       bitmap: 2/23 pages [8KB], 65536KB chunk
>>
>> unused devices: <none>
> 
> Wol,
> 
>    If you read this, this may worth a mention on wiki page.
> 
> Ramesh
> 
Got that :-)

I'll have to think how to do that - probably a section on the use of
--update to fix problems. Anyway, I've marked this email so when I work
my way through stuff I'll find it :-)

Cheers,
Wol

