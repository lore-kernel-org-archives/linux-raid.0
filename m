From: Doug Ledford <dledford@redhat.com>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Thu, 01 Sep 2011 12:31:12 -0400
Message-ID: <4E5FB350.3040905@redhat.com>
References: <4E5FA4B5.6010407@macroscoop.nl> <4E5FAEF3.60501@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FAEF3.60501@macroscoop.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/01/2011 12:12 PM, Pim Zandbergen wrote:
> On 09/01/2011 05:28 PM, Pim Zandbergen wrote:
>>
>>
>> What should I do to find the cause?
>
> Additional information:
>
> Both the original 2TB drives as well as the new 3TB drives were GPT
> formatted with partition type FD00
>
> This is information about the currently shrunk array:
>
>
> # mdadm --detail /dev/md0
> /dev/md0:
> Version : 0.90

Why is your raid metadata using this old version?  mdadm-3.2.2-6.fc15 
will not create this version of raid array by default.  There is a 
reason we have updated to a new superblock.  Does this problem still 
occur if you use a newer superblock format (one of the version 1.x 
versions)?

> Creation Time : Wed Feb 8 23:22:15 2006
> Raid Level : raid5
> Array Size : 4696690944 (4479.11 GiB 4809.41 GB)
> Used Dev Size : 782781824 (746.52 GiB 801.57 GB)

This looks like some sort of sector count wrap, which might be related 
to version 0.90 superblock usage. 3TB - 2.2TB (roughly the wrap point) = 
800GB, which is precisely how much of each device you are using to 
create a 4.8TB array.

> Raid Devices : 7
> Total Devices : 7
> Preferred Minor : 0
> Persistence : Superblock is persistent
>
> Update Time : Tue Aug 30 21:50:50 2011
> State : clean
> Active Devices : 7
> Working Devices : 7
> Failed Devices : 0
> Spare Devices : 0
>
> Layout : left-symmetric
> Chunk Size : 64K
>
> UUID : 1bf1b0e2:82d487c5:f6f36a45:766001d1
> Events : 0.3157574
>
> Number Major Minor RaidDevice State
> 0 8 161 0 active sync /dev/sdk1
> 1 8 177 1 active sync /dev/sdl1
> 2 8 193 2 active sync /dev/sdm1
> 3 8 145 3 active sync /dev/sdj1
> 4 8 209 4 active sync /dev/sdn1
> 5 8 225 5 active sync /dev/sdo1
> 6 8 129 6 active sync /dev/sdi1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

