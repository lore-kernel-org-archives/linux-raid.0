From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 17:24:59 +0200
Message-ID: <e57038fa-4b27-7d0c-d6c1-e583fecd503f@powerlamerz.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com>
 <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/23/2017 05:11 PM, Patrik Dahlström wrote:
> 
> 
> On 04/23/2017 04:48 PM, Andreas Klauer wrote:
>> On Sun, Apr 23, 2017 at 10:06:15PM +0800, Brad Campbell wrote:
>>> Nobody seems to have mentioned the reshape issue.
>>
>> Good point.
>>
>> If it was mid-reshape you need two sets of overlays, 
>> create two RAIDs (one for each configuration), and 
>> then find the point where it converges.
>>
>>> If my reading of the code is correct (and my memory
>>> is any good), simply adding a disk to a raid5 on a 
>>> recent enough kernel should make the resync go backwards.
>>
>> Doesn't it cut the offset by half and grow forwards...?
>>
>> With growing a disk that should give you a segment where 
>> data is identical for both 5-disk and 6-disk RAID-5. 
>> And that's where you join them using dmsetup linear.
>>
>> Before:
>>
>> /dev/loop0:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x1
>>      Array UUID : 4611f41b:0464e815:8b6f9cfe:b29c56fd
>>            Name : EIS:42  (local to host EIS)
>>   Creation Time : Sun Apr 23 16:44:59 2017
>>      Raid Level : raid5
>>    Raid Devices : 5
>>
>>  Avail Dev Size : 11720783024 (5588.90 GiB 6001.04 GB)
>>      Array Size : 23441565696 (22355.62 GiB 24004.16 GB)
>>   Used Dev Size : 11720782848 (5588.90 GiB 6001.04 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=262064 sectors, after=176 sectors
>>           State : clean
>>     Device UUID : acd8d9fd:7b7cf9a0:f63369d1:907ffa66
>>
>> Internal Bitmap : 8 sectors from superblock
>>     Update Time : Sun Apr 23 16:44:59 2017
>>   Bad Block Log : 512 entries available at offset 32 sectors
>>        Checksum : f89bdc5 - correct
>>          Events : 2
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 0
>>    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
>>
>> After/During grow:
>>
>> /dev/loop0:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x45
>>      Array UUID : 4611f41b:0464e815:8b6f9cfe:b29c56fd
>>            Name : EIS:42  (local to host EIS)
>>   Creation Time : Sun Apr 23 16:44:59 2017
>>      Raid Level : raid5
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 11720783024 (5588.90 GiB 6001.04 GB)
>>      Array Size : 29301957120 (27944.52 GiB 30005.20 GB)
>>   Used Dev Size : 11720782848 (5588.90 GiB 6001.04 GB)
>>     Data Offset : 262144 sectors
>> |     New Offset : 257024 sectors
>>    Super Offset : 8 sectors
>>           State : clean
>>     Device UUID : acd8d9fd:7b7cf9a0:f63369d1:907ffa66
>>
>> Internal Bitmap : 8 sectors from superblock
>> |  Reshape pos'n : 1472000 (1437.50 MiB 1507.33 MB)
>> |  Delta Devices : 1 (5->6)
>>
>>     Update Time : Sun Apr 23 16:45:38 2017
>>   Bad Block Log : 512 entries available at offset 32 sectors
>>        Checksum : fbd9a55 - correct
>>          Events : 30
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 0
>>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
>>
>> Basically you have to know the New Offset 
>> (search first 128M of your drives for filesystem headers, that should be it)
> Let's see if I understand you correctly:
> 
> * I try to find 0x53EF (ext4 magic) within the first 128M of
> /dev/sd[abcde]. Not after? This will be an indication of my "New
> Offset". I need to adjust the offset a bit since the ext4 magic is
> located at 0x438 offset.
> 
Okay, I located what appears to be a ext4 file system header at
0x7B80000 in both /dev/sda and /dev/sdf. I used this command:
dd if=/dev/sda bs=524288 count=256 | ./ext2scan

where ext2scan comes from https://goo.gl/2TnZSR

>> and then guess the Reshape pos'n by comparing raw data at offset X 
>> (find non-zero data at identical offsets for both raid sets)
> 
> * I create a 5 and a 6 drive raid set and try to find an offset where
> they both carry the same raw data. With some overlays, I should be able
> to create both these raids at the same time, correct?
I'm still working on this one. Should I start looking at ~15% of the raid?

What is the next step after this?

> 
>>
>> Regards
>> Andreas Klauer
>>
