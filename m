From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 17:32:24 +0100
Message-ID: <51264C18.8000201@heisl.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5126421E.3040702@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 21.02.2013 16:49, schrieb Phil Turmel:
> On 02/21/2013 10:38 AM, Phil Turmel wrote:
>> On 02/21/2013 10:30 AM, stone@heisl.org wrote:
>>
>>> dd if=/dev/zero bs=4096 count=1 seek=1073006628 of=/dev/sdc1
>>> dd: `/dev/sdc1': cannot seek: Invalid argument
>>> 0+0 records in
>>> 0+0 records out
>>> 0 bytes (0 B) copied, 0,000493485 s, 0,0 kB/s
>>>
>>> is there a problem with the bs parameter?
>>> shoud i try dd if=/dev/zero bs=512 count=8 seek=1073006628 of=/dev/sdc1
>>> ?
>> How did you get 1073006628?  That is around the 4T mark?
>>
>> Please show the badblocks output file.
This is my ouput from the badblocks
1073006628
1073006629
1073006630
1073006631
1073006632
1073006633
1073006634
1073006635
1073006636
1073006637
1073006638
1073006639
1073101016
1073101017
1073101018
1073101019
1073101020
1073101021
1073101022
1073101023
1073101024
1073101025
1073101026
1073101027
1335739456
1335739457
1335739458
1335739459
1335739460
1335739461
1335739462
1335739463
1346771164
1346771165
1346771166
1346771167
1346771168
1346771169
1346771170
1346771171
1348581732
1348581733
1348581734
1348581735
1348581736
1348581737
1348581738
1348581739
> I'm going to guess you didn't specify the block size when you used
> badblocks.  It defaults to 1024.  If so, dd needs "bs=1024"
>
> It is likely that your 48 errors are really 12 errors, four sequential
> "blocks" for each.  Your drives are advanced format, so they really have
> 4k sectors, and that should have been specified to badblocks.
>
> If so, you need to fix the sequential blocks together, or the drive will
> fail to perform read-modify-write.
>
> You probably need:
>
> dd if=/dev/zero bs=1024 count=4 seek=1073006628 of=/dev/sdc1
>
> But recheck everything carefully.  You can't undo whatever dd does.
>
> Phil
I will do this carefully. This is the reason why i will check with you a 
command befor i press the destroying return key.
Yes i think i have 4k sectors.
This means the only 12 blocks are damaged and i do the dd only for each 
fourth block

for example
dd if=/dev/zero bs=1024 count=4 seek=1073006628 of=/dev/sdc1
dd if=/dev/zero bs=1024 count=4 seek=1073006632 of=/dev/sdc1
dd if=/dev/zero bs=1024 count=4 seek=1073006636 of=/dev/sdc1

i think this must work but what shall i do when i get the same error? 
try the next block in the seek?

thx


