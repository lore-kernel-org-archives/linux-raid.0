From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: read errors corrected
Date: Sat, 15 Jan 2011 13:00:06 +0100
Message-ID: <4D318C46.7060204@texsoft.it>
References: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com> <4D1C5B4F.8050506@texsoft.it> <AANLkTimm6P=Lb1uzC83Va323V+Q0e1xSzFfuc2ze-8Fp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimm6P=Lb1uzC83Va323V+Q0e1xSzFfuc2ze-8Fp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/30/2010 05:41 PM, James wrote:
> Inline.
>
> On Thu, Dec 30, 2010 at 05:13, Giovanni Tessore<giotex@texsoft.it>  wrote:
>> On 12/30/2010 04:20 AM, James wrote:
>>> Can someone point me in the right direction?
>>> (a) what causes these errors precisely?
>>> (b) is the error benign? How can I determine if it is *likely* a
>>> hardware problem? (I imagine it's probably impossible to tell if it's
>>> HW until it's too late)
>>> (c) are these errors expected in a RAID array that is heavily used?
>>> (d) what kind of errors should I see regarding "read errors" that
>>> *would* indicate an imminent hardware failure?
>> (a) these errors usually come from defective disk sectors. raid recostructs
>> the missing sector from parity from other disks in the array, then rewrites
>> the sector on the defective disk; if the sector is rewritten without error
>> (maybe the hd remaps the sector into its reserved area), then just the log
>> messages is displayed.
>>
>> (b) with raid-6 it's almost benign; to get troubles you should get a read
>> error on same sector for>2 disks; or have 2 disks failed and out of the
>> array and get a read error on one of the other disks while recostructing the
>> array; or have 1 disk failed and get a read error on same sector on>1 disk
>> while recostructing (with raid-5 it's almost dangerous instead, as you can
>> have big troubles if a disk fails and you get a read error on another disk
>> while recostructing; that happened to me!)
>>
>> (c) no; it's also a good rule to perform a periodic scrub of the array
>> (check of the array), to reveal and correct defective sectors
>>
>> (d) check smart status of the disks, for "relocated sectors count"; also if
>> md superblock is>= 1 there is a persistent count of corrected read errors
>> for each device into /sys/block/mdXX/md/dev-XX/errors, when this counter
>> reaches 256 the disk is marked failed; ihmo when a disk is giving even few
>> corrected read errors in a short interval its better to replace it.
> Good call.
>
> Here's the output of the reallocated sector count:
>
> ~ # for i in a b c d ; do smartctl -a /dev/sd$i | grep Realloc ; done
>    5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
> Always       -       1
>    5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
> Always       -       3
>    5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
> Always       -       5
>    5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
> Always       -       1
>
> Are these values high? Low? Acceptable?
>
> How about values like "Raw_Read_Error_Rate" and "Seek_Error_Rate" -- I
> believe I've read those are values that are normally very high...is
> this true?
>
> ~ # for i in a b c d ; do smartctl -a /dev/sd$i | grep
> Raw_Read_Error_Rate ; done
>    1 Raw_Read_Error_Rate     0x000f   116   099   006    Pre-fail
> Always       -       106523474
>    1 Raw_Read_Error_Rate     0x000f   114   099   006    Pre-fail
> Always       -       77952706
>    1 Raw_Read_Error_Rate     0x000f   117   099   006    Pre-fail
> Always       -       137525325
>    1 Raw_Read_Error_Rate     0x000f   118   099   006    Pre-fail
> Always       -       179042738
>
> ...and...
>
>   ~ # for i in a b c d ; do smartctl -a /dev/sd$i | grep
> Seek_Error_Rate ; done
>    7 Seek_Error_Rate         0x000f   072   060   030    Pre-fail
> Always       -       14923821
>    7 Seek_Error_Rate         0x000f   072   060   030    Pre-fail
> Always       -       15648709
>    7 Seek_Error_Rate         0x000f   072   060   030    Pre-fail
> Always       -       15733727
>    7 Seek_Error_Rate         0x000f   071   060   030    Pre-fail
> Always       -       14279452
>
> Thoughts appreciated.
>

As I know,  Reallocated_Sector_Ct is the most meaningful SMART parameter 
related to disk sectors health.
Also check for Current_Pending_Sector (sector that gave read on error 
and has not been reallocated yet).
The values of your disks seems quite safe at the moment.
Be proactive if the value grows in short time.

I had same problem this week, one of my disk gave >800 reallocated read 
errors.
The disk was still marked good and alive into array, but I replaced it 
immediately.

Regards.

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


