From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Sun, 2 Dec 2007 04:11:59 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712020409280.30169@p34.internal.lan>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
 <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712010722590.28887@p34.internal.lan> <20071201174733.646a5c35@absurd>
 <Pine.LNX.4.64.0712011155110.6257@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712011155110.6257@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids



On Sat, 1 Dec 2007, Justin Piszcz wrote:

>
>
> On Sat, 1 Dec 2007, Janek Kozicki wrote:
>
>> Justin Piszcz said:     (by the date of Sat, 1 Dec 2007 07:23:41 -0500 
>> (EST))
>> 
>>>>> dd if=/dev/zero of=/dev/sdc
>>> 
>>> The purpose is with any new disk its good to write to all the blocks and
>>> let the drive to all of the re-mapping before you put 'real' data on it.
>>> Let it crap out or fail before I put my data on it.
>> 
>> better use badblocks. It writes data, then reads it afterwards:
>> In this example the data is semi random (quicker than /dev/urandom ;)
>> 
>> badblocks -c 10240 -s -w -t random -v /dev/sdc
>> 
>> -- 
>> Janek Kozicki                                                         |
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>
> Will give this a shot and see if I can reproduce the error, thanks.
>

The badblocks did not do anything; however, when I built a software raid 5 
and the performed a dd:

/usr/bin/time dd if=/dev/zero of=fill_disk bs=1M

I saw this somewhere along the way:

[30189.967531] RAID5 conf printout:
[30189.967576]  --- rd:3 wd:3
[30189.967617]  disk 0, o:1, dev:sdc1
[30189.967660]  disk 1, o:1, dev:sdd1
[30189.967716]  disk 2, o:1, dev:sde1
[42332.936615] ata5.00: exception Emask 0x2 SAct 0x7000 SErr 0x0 action 
0x2 frozen
[42332.936706] ata5.00: spurious completions during NCQ issue=0x0 
SAct=0x7000 FIS=004040a1:00000800
[42332.936804] ata5.00: cmd 61/08:60:6f:4d:2a/00:00:27:00:00/40 tag 12 cdb 
0x0 data 4096 out
[42332.936805]          res 40/00:74:0f:49:2a/00:00:27:00:00/40 Emask 0x2 
(HSM violation)
[42332.936977] ata5.00: cmd 61/08:68:77:4d:2a/00:00:27:00:00/40 tag 13 cdb 
0x0 data 4096 out
[42332.936981]          res 40/00:74:0f:49:2a/00:00:27:00:00/40 Emask 0x2 
(HSM violation)
[42332.937162] ata5.00: cmd 61/00:70:0f:49:2a/04:00:27:00:00/40 tag 14 cdb 
0x0 data 524288 out
[42332.937163]          res 40/00:74:0f:49:2a/00:00:27:00:00/40 Emask 0x2 
(HSM violation)
[42333.240054] ata5: soft resetting port
[42333.494462] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[42333.506592] ata5.00: configured for UDMA/133
[42333.506652] ata5: EH complete
[42333.506741] sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors 
(750156 MB)
[42333.506834] sd 4:0:0:0: [sde] Write Protect is off
[42333.506887] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[42333.506905] sd 4:0:0:0: [sde] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA

Next test, I will turn off NCQ and try to make the problem re-occur.
If anyone else has any thoughts here..?
I ran long smart tests on all 3 disks, they all ran successfully.

Perhaps these drives need to be NCQ BLACKLISTED with the P35 chipset?

Justin.
