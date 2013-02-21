From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 20:17:05 +0100
Message-ID: <512672B1.4020103@heisl.org>
References: <5123A1CC.2000003@heisl.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heis
 l.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51267192.6090205@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 21.02.2013 20:12, schrieb Stone:
> Am 21.02.2013 19:54, schrieb Phil Turmel:
>> On 02/21/2013 01:29 PM, Stone wrote:
>>> Am 21.02.2013 19:11, schrieb Phil Turmel:
>>>> On 02/21/2013 01:08 PM, Stone wrote:
>>>>
>>>>> ok i have checked all superblocks but i get always the same message.
>>>>> here one sample:
>>>>> fsck.ext4 -n -b 644972544 /dev/mapper/md2_nas
>>>>> e2fsck 1.41.14 (22-Dec-2010)
>>>>> fsck.ext4: Invalid argument while trying to open /dev/mapper/md2_nas
>>>>>
>>>>> The superblock could not be read or does not describe a correct ext2
>>>>> filesystem.  If the device is valid and it really contains an ext2
>>>>> filesystem (and not swap or ufs or something else), then the 
>>>>> superblock
>>>>> is corrupt, and you might try running e2fsck with an alternate
>>>>> superblock:
>>>>>       e2fsck -b 8193 <device>
>>>> You very likely have the wrong chunk size.
>>>>
>>>> Close luks, stop md2, and re-create with --chunk=64
>>>>
>>>> And then try to fsck again.  (Without -b at first.)
>>>>
>>>> Phil
>>> ok. with --chunk=64 i cannot open the luks.
>>> in witch steps (chunk) should i continue?
>> That is a big surprise.  The luks signature should not move with chunk
>> size.  Please use "mdadm -E /dev/sdc1" to recheck your data offset.
>>
sorry i forgot
  mdadm -E /dev/sdc1
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : e5ace834:7cbb3655:4fd2e7b8:3e07b6d3
            Name : ubuntu:2  (local to host ubuntu)
   Creation Time : Thu Feb 21 18:57:51 2013
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907027037 (1863.02 GiB 2000.40 GB)
      Array Size : 11721071616 (5589.04 GiB 6001.19 GB)
   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 368e4744:35adf66a:826f9d1b:11c606b6

     Update Time : Thu Feb 21 18:57:51 2013
        Checksum : 558db826 - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AA.A ('A' == active, '.' == missing)
>> If that wasn't it, please show the hexdump for the entire luks
>> signature.  I'd like to see its payload offset.
>>
>> Also, if you go back to --chunk=512, open the luks, you could run the
>> following command to find possible superblock locations:
>>
>> hexdump -C /dev/mapper/md2_nas |egrep '^[0-9a-f]+30  .+  53 ef' >sb.lst
>>
>> (May take a long time to read the whole array)
>>
>> Phil
> with --chunk=512 i can open the luks but i cannot found a good 
> superblock.
> yes i can run the hexdump but i think this runs 8 hours or longer.
> start the hexdump?
> can i try more today?

