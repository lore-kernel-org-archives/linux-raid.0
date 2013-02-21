From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 17:43:43 +0100
Message-ID: <51264EBF.9090000@heisl.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51264E26.9050100@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 21.02.2013 17:41, schrieb Phil Turmel:
> On 02/21/2013 11:32 AM, Stone wrote:
>
>> This is my ouput from the badblocks
>> 1073006628
>> 1073006629
>> 1073006630
>> 1073006631
>> 1073006632
>> 1073006633
>> 1073006634
>> 1073006635
>> 1073006636
>> 1073006637
>> 1073006638
>> 1073006639
> These 12 are together.  (Three real sectors.)
>
>> 1073101016
>> 1073101017
>> 1073101018
>> 1073101019
>> 1073101020
>> 1073101021
>> 1073101022
>> 1073101023
>> 1073101024
>> 1073101025
>> 1073101026
>> 1073101027
> And these twelve are together.
>
>> 1335739456
>> 1335739457
>> 1335739458
>> 1335739459
>> 1335739460
>> 1335739461
>> 1335739462
>> 1335739463
> These eight.
>
>> 1346771164
>> 1346771165
>> 1346771166
>> 1346771167
>> 1346771168
>> 1346771169
>> 1346771170
>> 1346771171
> And these eight.
>
>> 1348581732
>> 1348581733
>> 1348581734
>> 1348581735
>> 1348581736
>> 1348581737
>> 1348581738
>> 1348581739
> And these eight.
>
> So you actually have five bad spots, two or three sectors apiece.
>
> dd if=/dev/zero bs=1024 count=12 seek=1073006628 of=/dev/sdc1
> dd if=/dev/zero bs=1024 count=12 seek=1073101016 of=/dev/sdc1
> dd if=/dev/zero bs=1024 count=8 seek=1335739456 of=/dev/sdc1
> dd if=/dev/zero bs=1024 count=8 seek=1346771164 of=/dev/sdc1
> dd if=/dev/zero bs=1024 count=8 seek=1348581732 of=/dev/sdc1
>
> One last check:  Did you run "badblocks /dev/sdc" or "badblocks /dev/sdc1" ?
>
> Phil
"/dev/sdc1"
history: "badblocks -v /dev/sdc1 -o /root/badblocks_sdc1.txt"
