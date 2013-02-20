From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Wed, 20 Feb 2013 19:32:34 +0100
Message-ID: <512516C2.3010105@heisl.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5124196F.6090000@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 20.02.2013 01:31, schrieb Phil Turmel:
> You forgot to include linux-raid again.  I'm adding them back to the
> CC:.  Please always use "reply to all" in your email client.
Sorry.
> I will look for your detailed reply tomorrow.
>
> Phil
>
> On 02/19/2013 05:23 PM, Stone wrote:
>> Am 19.02.2013 23:08, schrieb Phil Turmel:
>>> On 02/19/2013 04:31 PM, Stone wrote:
>>>
>>> [trim /]
>>>
>>>>> [trim /]
>>>> ok. my system is a ubuntu 12.04
>>>> i can install a older mdadm or a install a old ubuntu like 11.04. there
>>>> is a older mdadm on board.
>>> Using the older ubuntu as a LiveCD should be fine--you don't have to
>>> uninistall your current system.
>>>
>>> [trim /]
>>>
>>>> ok. here my next steps
>>>> i find a older mdadm or i install a older ubunt with an older mdadm on
>>>> board.
>>>> then i stop my md2 device and recreate it with: mdadm --create /dev/md2
>>>> --assume-clean --verbose --level=5 --raid-devices=4 /dev/sdc1 /dev/sdd1
>>>> missing /dev/sdf1
>>> Yes.  But read all the way through first....
>>>
>>>> with a little bit of hope i can open the device.
>>> But *don't* mount it!  Use "fsck -n" after you open it to verify it is
>>> Ok.  If you mount it, and the chunk size is wrong, it will damage your
>>> encrypted filesystem.
>>>
>>>> if not. i stop the md2 and recreate it with? with the parameter chunk?
>>>> and with what value? do you have a range for me?
>>> The current default is 512.  The old default was 64.  I'd try that if
>>> 512 doesn't work.  After that you'll have to guess.
>> Ok i will test this tomorrow.
>>>> here the timeout infos:
>>>> for x in /sys/block/sd*/device/timeout ; do echo $x ; cat $x ; done
>>>> /sys/block/sda/device/timeout
>>>> 30
>>>> /sys/block/sdb/device/timeout
>>>> 30
>>>> /sys/block/sdc/device/timeout
>>>> 30
>>>> /sys/block/sdd/device/timeout
>>>> 30
>>>> /sys/block/sde/device/timeout
>>>> 30
>>>> /sys/block/sdf/device/timeout
>>>> 30
>>> Ok, these are all Linux default.  30 seconds.
>>>
>>>> here the smart infos:
>>> Uh oh.  Two serious issues:
>>>
>>>> smartctl -x /dev/sdc1
>>>> smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-23-generic] (local
>>>> build)
>>>> Copyright (C) 2002-11 by Bruce Allen,
>>>> http://smartmontools.sourceforge.net
>>> [trim /]
>>>
>>>>     5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
>>>>     7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
>>>>     9 Power_On_Hours          -O--CK   078   078   000    -    16219
>>>>    10 Spin_Retry_Count        -O--CK   100   100   000    -    0
>>>>    11 Calibration_Retry_Count -O--CK   100   253   000    -    0
>>>>    12 Power_Cycle_Count       -O--CK   100   100   000    -    84
>>>> 192 Power-Off_Retract_Count -O--CK   200   200   000    -    82
>>>> 193 Load_Cycle_Count        -O--CK   169   169   000    -    94419
>>>> 194 Temperature_Celsius     -O---K   114   106   000    -    36
>>>> 196 Reallocated_Event_Count -O--CK   200   200   000    -    0
>>>> 197 Current_Pending_Sector  -O--CK   200   200   000    -    2
>>> Serious issue #1:
>>>
>>> You have unreadable sectors on sdc.  When you hit them during rebuild,
>>> sdc will be kicked out (again).  They might not be permanent errors, but
>>> you can't tell until the drive is given fresh data to write over them.
>>>
>>> You have two choices:
>>>
>>> 1) use ddrescue to copy sdc onto a new drive, then use it in place of
>>> sdc when you re-create the array, or
>>>
>>> 2) use badblocks to find the exact locations of the bad sectors, then
>>> write zeros to those sectors using dd.
>>>
>>> Either way, you have lost whatever those sectors used to hold.
befor i will recreate the raid with an older mdadm i would search the 
badblocks. is this right?
i have check all drives and the sdc device had badblock:
Pass completed, 48 bad blocks found. (48/0/0 errors)
but die binary dont give me the info where they are..
i have used this command in a screen badblocks -v /dev/sdc1
>>> [trim /]
>> yes this cheep WD Green drives. i have 4 new better drives here the i
>> will use instead. this means i will get the raid running and than i copy
>> all the data on the new drives.
>>>> SCT Status Version:                  3
>>>> SCT Version (vendor specific):       258 (0x0102)
>>>> SCT Support Level:                   1
>>>> Device State:                        Active (0)
>>>> Current Temperature:                    36 Celsius
>>>> Power Cycle Min/Max Temperature:     33/37 Celsius
>>>> Lifetime    Min/Max Temperature:     33/44 Celsius
>>>> Under/Over Temperature Limit Count:   0/0
>>>> SCT Temperature History Version:     2
>>>> Temperature Sampling Period:         1 minute
>>>> Temperature Logging Interval:        1 minute
>>>> Min/Max recommended Temperature:      0/60 Celsius
>>>> Min/Max Temperature Limit:           -41/85 Celsius
>>>> Temperature History Size (Index):    478 (314)
>>>>
>>>> Index    Estimated Time   Temperature Celsius
>>>>    315    2013-02-19 14:26    36  *****************
>>>>    ...    ..(476 skipped).    ..  *****************
>>>>    314    2013-02-19 22:23    36  *****************
>>>>
>>>> Warning: device does not support SCT Error Recovery Control command
>>> Serious issue #2:
>>>
>>> Error timeout mismatch.  Your cheap drives do not support Error Recovery
>>> Control.  That means when they run into unreadable sectors, they will
>>> spend a couple minutes trying "extra hard" to get the data.
>>>
>>> But linux is only going to wait 30 seconds.  Then it will reset the SATA
>>> link and try again.  But the drive will *not* give up its error recovery
>>> effort, and will not even *talk* to the linux driver in the meantime, so
>>> the linux driver will disconnect the drive and report errors for all
>>> remaining requests.  This will cause MD to kick the drive out.
>>>
>>> You only have one choice:
>>>
>>> 1) Set a long timeout in the linux drivers for the drives in your array,
>>> on every boot.  Something like:
>>>
>>> for x in /sys/block/sd[cdef]/device/timeout ; do echo 180 >$x ; done
>>>
>>> If you had slightly better drives, SCTERC would be supported.  On
>>> desktop drives at power up, it is disabled.  But you would be able to
>>> enable a normal 7.0 second timeout in the drives using smartctl.  (In a
>>> script, on every boot up.)  Enterprise "raid" drives do this by default.
>>>
>>> [trim /]
>>>
>>>> smartctl -x /dev/sdd1
>>>> smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-23-generic] (local
>>>> build)
>>>> Copyright (C) 2002-11 by Bruce Allen,
>>>> http://smartmontools.sourceforge.net
>>> [trim /]
>>>
>>>> SMART Attributes Data Structure revision number: 16
>>>> Vendor Specific SMART Attributes with Thresholds:
>>>> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>>>>     1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    534
>>>>     3 Spin_Up_Time            POS--K   172   171   021    -    6383
>>>>     4 Start_Stop_Count        -O--CK   100   100   000    -    586
>>>>     5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    2
>>> You already have two relocations on this drive.
>>>
>>>>     7 Seek_Error_Rate         -OSR-K   100   253   000    -    0
>>>>     9 Power_On_Hours          -O--CK   085   085   000    -    11487
>>> In less than two years.  You should pay close attention to this.
>>>
>>> Phil
>> i think i must learn to interpret the smart values better.
>> thank you.
>> i will send you tomorrow my new info with the older mdadm version.

