From: Kanoalani Withington <kanoa@cfht.hawaii.edu>
Subject: Re: raid5: switching cache buffer size
Date: Fri, 13 Dec 2002 09:17:15 -1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DFA323B.3000103@cfht.hawaii.edu>
References: <Pine.LNX.4.43.0212131530510.6085-100000@unicorn.drogon.net> <3DFA2E2A.20601@comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Luca Berra <bluca@comedia.it>
Cc: Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You might also be using a journaled filesystem with the journal on the 
same volume as the data. XFS does this by default for example, writes to 
the journal are not the same block size as writes to the data volume so 
the RAID layer reports tons of messages like the ones you describe. The 
proper solution (according the XFS maintainers) is to create a small 
disk mirror for the journal separate from the data volume.

-Kanoa

Luca Berra wrote:

> Gordon Henderson wrote:
>
>> Anyone know what this means?
>>
>> My big server is currently fscking a lvm partition which sits on-top 
>> of a
>> raid5 device and the console is scrolling these messages as fast as 
>> it can.
>> It says it's switching from 0 to 512, from 512 to 0 and 0 to 1024 ( or
>> maybe 512 to 1024, its hard to tell).
>>
>> What's happening and how do I stop it?
>
>
> hi,
> you probably have filesystems of different block in the volume group,
> raid cache cannot cope with requests of varying block size so it has 
> to flush the cache each time, this only hurts performance and is not 
> problem for data safety.
>
> fix:
> 1) make sure everything on your raid5 is the same block size, if you 
> have swap you are locked to using 4k blocks, if you are using 
> snapshots 1k blocks, if you use both jump.
> 2) comment the printk in the raid5 source
>
> L.
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


