From: berk walker <berk@panix.com>
Subject: Re: 2 Hard Drives & RAID
Date: Sat, 09 Sep 2006 16:09:12 -0400
Message-ID: <45031F68.4020403@panix.com>
References: <ednknc$gk$4@sea.gmane.org> <Pine.LNX.4.64.0609091548080.14845@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0609091548080.14845@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Sandra L. McGrew" <momo_1@alltel.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:

>
>
> On Wed, 6 Sep 2006, Sandra L. McGrew wrote:
>
>> I have two hard drives installed in this DELL GX110 Optiplex computer. I
>> believe that they are configured in RAID5, but am not certain. Is 
>> there a
>> graphical method of determining how many drives are being used and 
>> how they
>> are configured???
>> I'm using Debian, 'Sarge'...
>>
>> The computer is incrediby fast... I'm thinking that could be because 
>> it's a
>> DELL or because the drives are mirrored...
>>             I would apppreciate any help that you can give me...
>>                   Most sincerley,
>>                                Dan (nurse1@longviewcomm[removethis].net)
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> RAID5 requires 3 drives or more.
>
> To check your disks type: fdisk -l as root.
>
> Justin.
>
>
Actually, RAID5 requires 2 drives, but that does defeat most of the 
reason for RAID5 in the 1st place.

I think that "cat /proc/mdstat" is a fast way to see if the box sees the 
drives as RAID.  If you have mdadm installed, it has a wealth of querys 
- assuming that you do have some RAID items - and they may be whole 
disks or partitions.

b-


