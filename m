From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 18:34:22 -0800 (AKDT)
Message-ID: <Pine.LNX.4.64.0807151831070.32734@filesrv1.baby-dragons.com>
References: <1216130769.5633.318.camel@sam.localdomain> <487CC660.9030004@ziu.info>
 <487D09E7.1010805@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <487D09E7.1010805@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Richard ,

On Wed, 16 Jul 2008, Richard Scobie wrote:
> Michal Soltys wrote:
>
>> Also looking back at other benchmarks, stripe_cache_size can have pretty 
>> tremendous effect on md raid performance. There're other settings that 
>> could matter as well (read ahead, queue depths). It would be interesting to 
>> see e.g. raid5 256k chunk comparison, done with those altered ( 
>> _especially_ md's stripe_cache_size with some high value like 16384 or 
>> 32768), and with stripe-width used in ext3 case (if it wasn't used 
>> already).
>
> Agreed. On a 16 SATA drive SAS attached md RAID6, large streaming write 
> performance goes from around 110MB/s with the default stripe_cache_size, to 
> 600MB/s using 16384.
>
> There are major read performance too, setting readahead on the md device to 
> 65536.

 	At what level (2.6.26) does one set readahead ?
 	I've searched 'mount' ,  'mdadm' ,  'Documentation/md.txt' .  Where 
else should I look ?  Obviously I am missing something .


> Regards,
> Richard

 		TIa ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
