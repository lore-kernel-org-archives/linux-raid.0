From: Phil Turmel <philip@turmel.org>
Subject: Re: AW: AW: QNAP 8 port RAID5 md0 recovery of missing MBR and md
 superblocks
Date: Mon, 17 Feb 2014 14:21:52 -0500
Message-ID: <53026150.2080806@turmel.org>
References: <52CBF747.7020505@epos-cat.de> <A2EC67620EC7424F9EC3DD49243E9060466DC09B@AUDIINSX0328.audi.vwg> <A2EC67620EC7424F9EC3DD49243E9060466EC018@AUDIINSX0328.audi.vwg> <530212E5.2030003@turmel.org> <A2EC67620EC7424F9EC3DD49243E9060466EC088@AUDIINSX0328.audi.vwg>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A2EC67620EC7424F9EC3DD49243E9060466EC088@AUDIINSX0328.audi.vwg>
Sender: linux-raid-owner@vger.kernel.org
To: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>, "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/17/2014 02:10 PM, Samer, Michael (I/ET-83, extern) wrote:
>> Good morning Michael,
> 
> Hello Phil
> 
>> On 02/17/2014 08:33 AM, Samer, Michael (I/ET-83, extern) wrote:
>>> Greetings to all
>>>
>>> As my thread from the 6.2.2014 didn't bring any hint or any reply or way out, I need >advise if my way is approved:
>>
>> I travel a lot, and didn't see your posts.  Help from someone usually
>> pops up.  Sorry it didn't work that way for you.
> 
> I'd have asked more frequently and surely the case is not FAQ.
> 
> That's the last --examine I did four weeks ago (before I recovered the part/volume table again:
> 
> /dev/sda3:
>            Magic : a92b4efc
>          Version : 0.90.00
>             UUID : 52d7d080:5c40de46:bc741f30:65cb5a0d
>    Creation Time : Sun Jan 27 23:10:25 2013
>       Raid Level : raid5
>    Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
>       Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
>     Raid Devices : 8
>    Total Devices : 7
> Preferred Minor : 0
> 
>      Update Time : Sun Apr 21 14:14:49 2013
>            State : active
>   Active Devices : 7
> Working Devices : 7
>   Failed Devices : 1
>    Spare Devices : 0
>         Checksum : 91564c42 - correct
>           Events : 136
> 
>           Layout : left-symmetric
>       Chunk Size : 64K
> 
>        Number   Major   Minor   RaidDevice State
> this     3       8       51        3      active sync   /dev/sdd3

Ok. Stop here.  This report shows /dev/sda3 where the metadata thought
it was /dev/sdd3.  So your device names have been changing.

Please redo the --examine operation on all of the /dev/sdX3 partitions
and report again.

Also report an excerpt of "ls -l /dev/disk/by-id/" that shows the device
name vs. serial number for all of the drives involved.

Also report kernel and mdadm versions.  The report format is an older style.

Phil
