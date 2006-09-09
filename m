From: Sandra McGrew <nurse1@longviewcomm.net>
Subject: Re: 2 Hard Drives & RAID
Date: Sat, 09 Sep 2006 17:11:33 -0500
Message-ID: <edve80$p4j$1@sea.gmane.org>
References: <ednknc$gk$4@sea.gmane.org> <Pine.LNX.4.64.0609091548080.14845@p34.internal.lan> <45031F68.4020403@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm looking into the Debian, 'Sarge' Info Center and under the device column
it shows
Device          Type            Size            Mount  Point
/dev/fd0        auto            N/A             /media/floppy0
/dev/hda1       Ext3            35.9            /
/dev/hdc        iso9660         N/A             /media/cdrom1
/dev/hdd        iso9660         N/A             /media/cdrom0

So, it doesn't look like it is seeing the other hard drive... it is
connected and the BIOS sees it... therefore, it's available to the system,
I'm just not certain how to  see it and once I can do that, I will worry
'bout formating it next... there is a nice utility for that... I'm not
certain, but I think that I can handle that part... if I could just find
the other drive... unless, I'm wrong about this info center showing me all
the drives... 

another point is that in Konquer, under 'Hard Disc'... then 'Dev'...
'ataraid' is the first folder... 

I hope that this information will help you to see what I'm seeing a little
better... 
I don't see anything that looks like "cat /proc/mdstat"??? What is that???
I would appreciate any help that you give me...
                        Thanks for all the help so far,
                                                        Dan

berk walker wrote:

> Justin Piszcz wrote:
> 
>>
>>
>> On Wed, 6 Sep 2006, Sandra L. McGrew wrote:
>>
>>> I have two hard drives installed in this DELL GX110 Optiplex computer. I
>>> believe that they are configured in RAID5, but am not certain. Is
>>> there a
>>> graphical method of determining how many drives are being used and
>>> how they
>>> are configured???
>>> I'm using Debian, 'Sarge'...
>>>
>>> The computer is incrediby fast... I'm thinking that could be because
>>> it's a
>>> DELL or because the drives are mirrored...
>>>             I would apppreciate any help that you can give me...
>>>                   Most sincerley,
>>>                                Dan (nurse1@longviewcomm[removethis].net)
>>>
>>> -
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> RAID5 requires 3 drives or more.
>>
>> To check your disks type: fdisk -l as root.
>>
>> Justin.
>>
>>
> Actually, RAID5 requires 2 drives, but that does defeat most of the
> reason for RAID5 in the 1st place.
> 
> I think that "cat /proc/mdstat" is a fast way to see if the box sees the
> drives as RAID.  If you have mdadm installed, it has a wealth of querys
> - assuming that you do have some RAID items - and they may be whole
> disks or partitions.
> 
> b-
> 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


