From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 08:04:09 +0100
Message-ID: <5125C6E9.4050802@heisl.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5125184A.6040707@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 20.02.2013 19:39, schrieb Phil Turmel:
> On 02/20/2013 01:32 PM, Stone wrote:
>>>> Am 19.02.2013 23:08, schrieb Phil Turmel:
>>>>> Serious issue #1:
>>>>>
>>>>> You have unreadable sectors on sdc.  When you hit them during rebuild,
>>>>> sdc will be kicked out (again).  They might not be permanent errors,
>>>>> but
>>>>> you can't tell until the drive is given fresh data to write over them.
>>>>>
>>>>> You have two choices:
>>>>>
>>>>> 1) use ddrescue to copy sdc onto a new drive, then use it in place of
>>>>> sdc when you re-create the array, or
>>>>>
>>>>> 2) use badblocks to find the exact locations of the bad sectors, then
>>>>> write zeros to those sectors using dd.
>>>>>
>>>>> Either way, you have lost whatever those sectors used to hold.
>> befor i will recreate the raid with an older mdadm i would search the
>> badblocks. is this right?
> Yes, and write zeros to those blocks to either fix them or relocate them.
Ok i have now a list of my badblocks.
Now i fix them with dd
dd if=/dev/zero of=/dev/sdc1 bs=1073006628 cout=1
and this for all badblocks?

with this command i fill the badblocks with a null but override data? i 
cannot damage my data with this or?

thank you.
>
>> i have check all drives and the sdc device had badblock:
>> Pass completed, 48 bad blocks found. (48/0/0 errors)
>> but die binary dont give me the info where they are..
>> i have used this command in a screen badblocks -v /dev/sdc1
> "man badblocks"
>
> You should use the "-o" option to save the list.
>
> Phil

