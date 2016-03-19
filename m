From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Raid server Motherboard recommendation.
Date: Sat, 19 Mar 2016 13:42:23 -0500
Message-ID: <56ED9D8F.7090303@gmail.com>
References: <5643FD4A.4070709@gmail.com> <20151112122908.0406d170@natsu>
 <56449EE5.3010002@gmail.com> <20151112151105.GA32385@EIS>
 <56E9E056.7000204@gmail.com> <20160317095252.GA3822@EIS>
 <56EB87E3.6060504@gmail.com>
 <20160318154152.10835s56gu5tsab4@webmail.uniserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160318154152.10835s56gu5tsab4@webmail.uniserve.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Stevens <geek@uniserve.com>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Roman Mamedov <rm@romanrm.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/18/2016 05:41 PM, Dave Stevens wrote:
> Quoting Ram Ramesh <rramesh2400@gmail.com>:
>
>> On 03/17/2016 04:52 AM, Andreas Klauer wrote:
>>> On Wed, Mar 16, 2016 at 05:38:14PM -0500, Ram Ramesh wrote:
>>>> If you don't mind, could you share with me the standalone card that 
>>>> you
>>>> use?
>>> I think this is the same I use:
>>>
>>> http://www.ebay.com/itm/PCI-E-Express-SATA3-SATA3-0-6Gb-s-eSATA-SATA-III-Card-ASMEDIA1061-/231378681315 
>>>
>>>
>>> It has two ports, and you can choose between internal and external 
>>> via 4 jumpers per port.
>>>
>>> You also find this Asmedia chipset on a lot of Asus/Asrock 
>>> mainboards that have two additional SATA ports.
>>>
>>>> BTW, have you stressed your card through a rebuild/checkarray?
>>> I run checkarray every day (each day a different part of disk so 
>>> entire disk is covered in a week or so) with no issue.
>>>
>>> I also mirror my single SSD disk to the HDD RAID once a week.
>>>
>>> I can run a mkfs.ext4 -c -c on a LVM partition at a later time, but 
>>> so far no issues whatsoever.
>>>
>>> Regards
>>> Andreas Klauer
>> Thanks.
>>
>> I saw similar one on Amazon too: 
>> http://www.amazon.com/Express-Adapter-Converter-ASMEDIA-ASM1061/dp/B008BZAVVE
>>
>> I am getting asrock extreme6 and that will be enough for the next 
>> 6months (eventually I want to have a total of 12). Before that time, 
>> I will probably buy the card you have given unless I get nervous 
>> about ebay vendor and choose amazon version.
>>
>> Regards
>> Rameshn
>
>
> Hi Ramesh,
>
> Why are you considering only hardware RAID? Software RAID is basically 
> free and you needn't be concerned about board manufacturers going out 
> of business or changing the board BIOS and so on.
>
> Dave
>
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
>
>
Dave,

   Not sure what you mean. I am only talking about mdadm. I just needed 
extra sata ports to hook up more drives. None of my
conversation is about hardware raid. I have never used or wanted to have 
hardware raid.

Ramesh

