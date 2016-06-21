From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: unbalanced RAID5 / performance issues
Date: Tue, 21 Jun 2016 12:29:38 +1000
Message-ID: <5768A692.5090306@websitemanagers.com.au>
References: <20160620104455.Horde.Cu9WNhgOSFjDC3hgl4ZCm01@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160620104455.Horde.Cu9WNhgOSFjDC3hgl4ZCm01@www3.nde.ag>
Sender: linux-raid-owner@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/06/16 18:44, Jens-U. Mozdzen wrote:
> Hi Adam,
>
> Zitat von Adam Goryachev <adam@websitemanagers.com.au>:
>> Hi,
>>
>> I have a RAID5 array which consists of 8 x Intel 480GB SSD, single 
>> partition on each covering 100% of the drive.
>> [...]
>> I'm finding that the underlying disk utilisation is "uneven" ie, one 
>> or two disks is used a lot more heavily than the others. This is best 
>> seen with iostat:
>> iostat -x -N /dev/sd? 5
>> This will show 5 second averages... so we should expect the average 
>> utilisation of all disks to be equal ( I expect, I am probably wrong).
>> Ignoring the first output, since that is values since the system was 
>> booted, I've copied three sample from after that.
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s wkB/s 
>> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> sdf             128.00   194.00   86.80  141.20   897.70 1289.60    
>> 19.19     0.04    0.18    0.16    0.20   0.13   2.96
>> sdh             110.80   138.60   83.40  139.20   808.80 1063.20    
>> 16.82     0.08    0.34    0.21    0.42   0.31   6.96
>> sde             120.80   162.00   90.60  117.80   866.40 1073.60    
>> 18.62     0.09    0.42    0.12    0.65   0.38   7.84
>> sdb             141.80   184.60  110.60  130.60  1104.30 1219.20    
>> 19.27     0.04    0.15    0.14    0.16   0.11   2.64
>> sda             126.00   153.80   89.80  120.40   921.00 1048.00    
>> 18.73     0.13    0.61    0.14    0.96   0.57  12.08
>> sdg             132.20   168.40  113.00  122.80  1037.60 1116.80    
>> 18.27     0.05    0.21    0.28    0.15   0.15   3.60
>> sdd             122.20   180.80   99.80  135.60   958.40 1219.20    
>> 18.50     0.04    0.16    0.20    0.13   0.10   2.40
>> sdc             112.80   178.60   87.40  115.20   824.00 1128.80    
>> 19.28     0.17    0.85    0.43    1.17   0.75  15.20
>> [...]
>> As you can see, sdc (and sda) has a much higher utilisation compared 
>> to all the other drives, but we can see the actual reads/writes are 
>> similar across all drives.
>
> looking at those numbers, it might not be the (effective) utilization 
> that's higher, but the time the SSDs spend handling the requests.
>
> As you already ruled out model issues for sda, further probable causes 
> that I'd check might be
>
> - a different firmware level for sda
All the Series 520 drives are running identical firmware (checked with 
smartctl) but I can't confirm if that is the latest firmware or not, I 
can find the intel tool to upgrade the firmware, but it doesn't specify 
what the current firmware version is for this model.
> - disk problems (anything useful in the SMART numbers?)
No, what started all this is I did find some unusual numbers on one 
disk, but that was a 160GB SSD used for the OS itself, not part of the 
array, and it has now been replaced (purchased a new one, but Intel will 
replace the old one eventually). All other drives SMART details look 
reasonable....

> - connection issues (are all disks connected to the same (type of) 
> controller?)
All disks are connected to the same controller....
01:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic 
SAS2308 PCI-Express Fusion-MPT SAS-2 (rev 05)

>
> I can't comment on the RAID parameter questions, though.

I just get the feeling that specific drives are being "worked" harder 
than others, and I'm not sure why.
I'm considering moving to either RAID10 or RAID50 in the future to try 
to improve performance, but I'm honestly not sure that this is really 
the problem anyway. By my calculations, if I double the number of 
drives, and move to RAID10, then I can double the read performance and 
improve write performance (I'm not exactly sure of the math here, how 
does one calculate write performance on RAID5 when you need to do 
read/modify/write?), alternatively, RAID50 (with 16 drives, with 4 
drives in 4 RAID5 sub-arrays) should also double read performance, but 
also improve write performance compared to the current, but not as much 
as RAID10 would. Although RAID50 will give more storage capacity than 
the RAID10....
I think my real issue is perhaps latency, and that the real "bottleneck" 
is at the DRBD layer rather than raid, but I'm trying to optimise each 
part that doesn't look right as I go.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
