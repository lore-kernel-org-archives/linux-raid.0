From: Mirko Benz <mirko.benz@web.de>
Subject: Re: RAID 5 write performance advice
Date: Wed, 24 Aug 2005 15:43:39 +0200
Message-ID: <430C798B.1030107@web.de>
References: <430C2EA6.2050103@web.de> <1124887589.5550.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1124887589.5550.27.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

The RAID5 configuration is: 8 SATA disks, 8 port Marvel SATA PCI-X 
controller chip (SuperMicro board), Dual Xeon, 1 GB RAM, stripe size 
64K, no spare disk.

Measurements are performed to the ram md device with:
disktest -PT -T30 -h1 -K8 -B65536 -ID /dev/md0
using the default stripe size (64K). 128K stripe size does not make a 
real difference.

We have also increased the RAID 5 stripe cache by setting NR_STRIPES to 
a larger value but without any perceptible effect.

If Linux uses "stripe write" why is it so much slower than HW Raid? Is 
it disabled by default?

8 disks: 7 data disks + parity @ 64k stripe size = 448k data per stripe
The request size was smaller (tested up to 256K) than the size of a stripe.
We have seen errors for larger request sizes (e.g. 1 MB). Does Linux 
require the request size to be larger than a stripe to take advantage 
of  "stripe write"?

Regards,
Mirko

Ming Zhang schrieb:

>On Wed, 2005-08-24 at 10:24 +0200, Mirko Benz wrote:
>  
>
>>Hello,
>>
>>We have recently tested Linux 2.6.12 SW RAID versus HW Raid. For SW Raid 
>>we used Linux 2.6.12 with 8 Seagate SATA NCQ disks no spare on a Dual 
>>Xeon platform. For HW Raid we used a Arc-1120 SATA Raid controller and a 
>>Fibre Channel Raid System (Dual 2 Gb, Infortrend).
>>
>>READ     SW:877 ARC:693 IFT:366
>>(MB/s @64k BS using disktest with raw device)
>>
>>Read SW Raid performance is better than HW Raid. The FC RAID is limited 
>>by the interface.
>>
>>WRITE    SW:140 ARC:371 IFT:352
>>
>>For SW RAID 5 we needed to adjust the scheduling policy. By default we 
>>got only 60 MB/s. SW RAID 0 write performance @64k is 522 MB/s.
>>    
>>
>how u test and get these number?
>
>what is u raid5 configuration? chunk size?
>
>  
>
>>Based on the performance numbers it looks like Linux SW RAID reads every 
>>data element of a stripe + parity in parallel, performs xor operations 
>>and than writes the data back to disk in parallel.
>>
>>The HW Raid controllers seem to be a bit smarter in this regard. When 
>>they encounter a large write with enough data for a full stripe they 
>>seem to spare the read and perform only the xor + write in parallel. 
>>Hence no seek is required and in can be closer to RAID0 write performance.
>>    
>>
>this is stripe write and linux MD have this.
>
>
>
>  
>
>>We have an application were large amounts of data need to be 
>>sequentially written to disk (e.g. 100 MB at once). The storage system 
>>has an USV so write caching can be utilized.
>>
>>I would like to have an advice if write performance similar to HW Raid 
>>controllers is possible with Linux or if there is something else that we 
>>could apply.
>>
>>Thanks in advance,
>>Mirko
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>    
>>
>
>
>  
>

