From: d4lamar <d4lamar@gmail.com>
Subject: Re: RESYNC Bug ? [was Re: Stop resync operation]
Date: Tue, 10 Nov 2015 07:53:25 +0100
Message-ID: <CAF8SPVK_S0QGETNvZacmnN7Y=T0d0MFYWZsEWEke1sHf=YHX-A@mail.gmail.com>
References: <CAF8SPVJigc-NjeEZVinzx1YFLE6CjMBBMNpxjSzpsi_bi2kovg@mail.gmail.com>
	<564171DE.3020808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <564171DE.3020808@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anugraha Sinha <asinha.mailinglist@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2015-11-10 5:26 GMT+01:00 Anugraha Sinha <asinha.mailinglist@gmail.com>:
> Hi,
>
> Could you share your kernel version and mdadm package version, please?

Of course.

2.6.32-220.7.1.el6.lustre.4033.x86_64
mdadm-3.2.2-9.xrtx.5.x86_64

Thanks,
d4lamar

> On 11/10/2015 1:13 PM, d4lamar wrote:
>>
>> Dear Developers,
>>
>> I am here again to ask you support about RESYNC operation.
>> In my first mail I asked if there were any method to stop a running
>> RESYNC.
>>
>> Now I am experiencing a very strange behaviour... RESYNC operation
>> exceeded 100% completion percentage...
>>
>> # cat /proc/mdstat
>> Tue Nov 10 05:02:41 CET 2015
>> Personalities : [raid1] [raid10] [linear]
>> md66 : active linear md0[0]
>> 2939452080 blocks super 1.2 4k rounding
>>
>> md0 : active raid10 sdab[17](S) sdt[16](S) sdaj[0] sdx[12] sdai[11]
>> sdah[9] sdam[15] sdae[7] sdas[6] sdaa[5] sdap[4] sdao[3] sdaf[14]
>> sdz[1]
>> 2939453104 blocks super 1.2 4K chunks 2 near-copies [14/12]
>> [UUUUUUUUUU_UU_]
>> [=========================>] resync =129.9% (545894292/419921872)
>> finish=20192933978332.0min speed=7612K/sec
>> bitmap: 22/22 pages [88KB], 65536KB chunk
>>
>> md65 : active raid1 sdal[0] sdar[1]
>> 419921875 blocks super 1.2 [2/2] [UU]
>> bitmap: 0/4 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>>
>> Are you aware of such possible behaviour ? Do you think I have just hit a
>> BUG ?
>>
>> Thanks and Best Regards,
>> d4lamar
>>
>> 2015-11-06 7:44 GMT+01:00 d4lamar <d4lamar@gmail.com>:
>>>
>>> Dear Developers,
>>>
>>> I have a question for you.
>>>
>>> I have a raid10 md array:
>>>
>>> Is it theoretically possible to stop a running resync operation and
>>> mark the array as clean without stopping the array ?
>>>
>>> I do not want the resync to be respawned automatically.
>>>
>>> Thanks and Best Regards,
>>> d4lamar
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
