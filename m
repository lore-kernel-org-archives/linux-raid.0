From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Fri, 22 Feb 2013 21:43:03 +0100
Message-ID: <5127D857.9090204@heisl.org>
References: <5123A1CC.2000003@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heis
 l.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010508090408010601050407"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5127B64A.3000808@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010508090408010601050407
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 22.02.2013 19:17, schrieb Stone:
> Am 22.02.2013 16:37, schrieb Phil Turmel:
>> On 02/22/2013 09:58 AM, Stone wrote:
>>> Am 22.02.2013 14:53, schrieb Phil Turmel:
>>>> On 02/22/2013 05:31 AM, stone@heisl.org wrote:
>>>>> to work on the live cd is very slow.
>>>>> i will kick out my two system drives and take one new and install 
>>>>> a old
>>>>> system (ubuntu 11.04, i think on this system i have created the first
>>>>> time the raid) to it.
>>>>>
>>>>> do you have new infos from the hexdump or other news to try out some
>>>>> things the get the raid and the luks running?
>>>> Unfortunately, no.  The hexdump had no real superblock candidates 
>>>> that I
>>>> could see.  That strongly suggests that there remain some ordering
>>>> issues.  I would try chunk sizes down to 8k.  If that still doesn't
>>>> work, consider re-creating with a different drive order--it's a slim
>>>> possibility that "sdc1 sdd1 missing sdf1" isn't correct.
>>>>
>>>> Meanwhile, you haven't supplied the complete hexdump of your luks
>>>> signature sector.  It may not help, but it would show the payload 
>>>> offset.
>> What about this part?
yes i can run a hexdum over the hole device but with chunk and with 
device order?
>>
>>> i have installed the system now with one system drive.
>>> the raid devices are now: sdb1 sdc1 sdd1(brocken not sync) sde1
>> Ok.
>>
>>> i have now tested all chunk's from 512k to 8k
>>> 512 Open Luks but no superblock
>>> 256 Open Luks but no superblock
>>> 128 No key available with this passphrase
>>> 64 No key available with this passphrase
>>> 32 No key available with this passphrase
>>> 16 No key available with this passphrase
>>> 8 No key available with this passphrase
>> Ok, but on the smaller chunk sizes, the device order could impact
>> interpretation of the key material.  You should repeat the small chunk
>> tests with the drive order variations below.
>>
>> Make a grid with chunk size on one axis, and drive order on the other
>> axis.  Mark each combination with yes or no if it can open luks.  If it
>> can, save the output of "fsck -n" in a file.  This would be a good thing
>> to script.
>>
>> After the script is done, look at all the saved files to see if any look
>> like possible solutions.
> i write a script and send my results back but you really wont a fsck 
> -n /dev/mapper/md2_nas?
> the output i veeeery long like this:
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529020 
> for in-use block map
> Illegal block number passed to ext2fs_test_block_bitmap #2667529021 
> for in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529021 
> for in-use block map
> Illegal block number passed to ext2fs_test_block_bitmap #2667529022 
> for in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529022 
> for in-use block map
> Illegal block number passed to ext2fs_test_block_bitmap #2667529023 
> for in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529023 
> for in-use block map
> Illegal block number passed to ext2fs_test_block_bitmap #2667529024 
> for in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529024 
> for in-use block map
> Illegal block number passed to ext2fs_test_block_bitmap #2667529025 
> for in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529025 
> for in-use block map
>>> 512k and 256k working better...
>>> next tests:
>>> mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5
>>> --raid-devices=4 /dev/sde1 /dev/sdb1 missing /dev/sdc1
>>>      No Luks
>>> mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5
>>> --raid-devices=4 /dev/sdc1 /dev/sdb1 missing /dev/sde1
>>>      No Luks
>>> mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5
>>> --raid-devices=4 /dev/sdc1 missing /dev/sdb1 /dev/sde1
>>>      No Luks
>>> mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5
>>> --raid-devices=4 /dev/sdb1 /dev/sde1 /dev/sdc1 missing
>>>      fsck.ext4: Invalid argument while trying to open 
>>> /dev/mapper/md2_nas
>>>      fsck.ext4: Bad magic number in super-block while trying to open
>>> /dev/mapper/md2_nas
>>> mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5
>>> --raid-devices=4 /dev/sde1 /dev/sdc1 /dev/sdb1 missing
>>>      No Luks
>>> mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5
>>> --raid-devices=4 /dev/sdc1 /dev/sde1 /dev/sdb1 missing
>>>      No Luks
>>> mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5
>>> --raid-devices=4 /dev/sdb1 /dev/sdc1 /dev/sde1 missing
>>>      fsck.ext4: Invalid argument while trying to open 
>>> /dev/mapper/md2_nas
>>>      fsck.ext4: Bad magic number in super-block while trying to open
>>> /dev/mapper/md2_nas
>>>
>>> do you think that i should try do mount the partion as RO? but i think
>>> this is not working because the damaged filesystem. right?
>> Do *not* mount at all.  Even a read-only mount isn't really
>> read-only--it will try to play back the journal, and will try to write
>> to the superblocks.
>>
>> Phil
>
so hello again.
the script was running and i looked at my logs.

this results i have
with chunk-size 8,16,32,64,128 i have always the same error: Enter 
passphrase for /dev/md2: No key available with this passphrase.

the first time to open it is possible with chunk 256

i send you some logs from 256 and 512

at 512 i get the first results with checksum errors.
i think the right size is 512?! but the filesystem is brocken?!


--------------010508090408010601050407
Content-Type: application/octet-stream;
 name="results.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="results.zip"

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
--------------010508090408010601050407--
