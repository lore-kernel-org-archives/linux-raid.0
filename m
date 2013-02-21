From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 11:46:55 -0500
Message-ID: <51264F7F.3020508@turmel.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51264EBF.9090000@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/21/2013 11:43 AM, Stone wrote:
> Am 21.02.2013 17:41, schrieb Phil Turmel:

>> So you actually have five bad spots, two or three sectors apiece.
>>
>> dd if=/dev/zero bs=1024 count=12 seek=1073006628 of=/dev/sdc1
>> dd if=/dev/zero bs=1024 count=12 seek=1073101016 of=/dev/sdc1
>> dd if=/dev/zero bs=1024 count=8 seek=1335739456 of=/dev/sdc1
>> dd if=/dev/zero bs=1024 count=8 seek=1346771164 of=/dev/sdc1
>> dd if=/dev/zero bs=1024 count=8 seek=1348581732 of=/dev/sdc1
>>
>> One last check:  Did you run "badblocks /dev/sdc" or "badblocks
>> /dev/sdc1" ?
>>
>> Phil
> "/dev/sdc1"
> history: "badblocks -v /dev/sdc1 -o /root/badblocks_sdc1.txt"

Very good.  So have you learned enough to be confident when you hit the
<enter> key?  :-)

Phil
