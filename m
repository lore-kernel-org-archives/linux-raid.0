From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 16:20:22 +0200
Message-ID: <06fc825a-149f-1d59-0a30-6decb431c844@powerlamerz.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com>
 <760766b7-1801-0b2a-6ef1-2da910d976f0@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <760766b7-1801-0b2a-6ef1-2da910d976f0@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/23/2017 04:09 PM, Patrik Dahlström wrote:
> 
> 
> On 04/23/2017 04:06 PM, Brad Campbell wrote:
>> On 23/04/17 17:47, Patrik Dahlström wrote:
>>> Hello,
>>>
>>> Here's the story:
>>>
>>> I started with a 5x6 TB raid5 array. I added another 6 TB drive and
>>> started to grow the array. However, one of my SATA cables were bad and
>>> the reshape gave me lots of I/O errors.
>>>
>>> Instead of fixing the SATA cable issue directly, I shutdown the server
>>> and swapped places of 2 drives. My reasoning was that putting the new
>>> drive in a good slot would reduce the I/O errors. Bad move, I know. I
>>> tried a few commands but was not able to continue the reshape.
>>>
>>
>> Nobody seems to have mentioned the reshape issue. What sort of reshape
>> were you running? How far into the reshape did it get? Do you have any
>> logs of the errors (which might at least indicate whereabouts in the
>> array things were before you pushed it over the edge)?
> These were the grow commands I ran:
> mdadm --add /dev/md1 /dev/sdf
> mdadm --grow --raid-devices=6 /dev/md1
> 
I found the kernel log output from when I ran the command:
[ 1912.303661] md: bind<sdf>
[ 1912.355423] RAID conf printout:
[ 1912.355426]  --- level:5 rd:5 wd:5
[ 1912.355428]  disk 0, o:1, dev:sda
[ 1912.355429]  disk 1, o:1, dev:sdb
[ 1912.355430]  disk 2, o:1, dev:sdd
[ 1912.355431]  disk 3, o:1, dev:sdc
[ 1912.355432]  disk 4, o:1, dev:sde
[ 1937.287333] RAID conf printout:
[ 1937.287341]  --- level:5 rd:6 wd:6
[ 1937.287347]  disk 0, o:1, dev:sda
[ 1937.287351]  disk 1, o:1, dev:sdb
[ 1937.287355]  disk 2, o:1, dev:sdd
[ 1937.287358]  disk 3, o:1, dev:sdc
[ 1937.287361]  disk 4, o:1, dev:sde
[ 1937.287365]  disk 5, o:1, dev:sdf
[ 1937.287469] md: reshape of RAID array md1
[ 1937.287475] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1937.287478] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
[ 1937.287487] md: using 128k window, over a total of 5860391424k.
[ 1937.424014] ata6.00: exception Emask 0x10 SAct 0x20000 SErr 0x480100 action 0x6 frozen
[ 1937.424086] ata6.00: irq_stat 0x08000000, interface fatal error
[ 1937.424134] ata6: SError: { UnrecovData 10B8B Handshk }
[ 1937.424179] ata6.00: failed command: WRITE FPDMA QUEUED
[ 1937.424227] ata6.00: cmd 61/40:88:00:dc:03/01:00:00:00:00/40 tag 17 ncq 163840 out
[ 1937.424227]          res 40/00:88:00:dc:03/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
[ 1937.424341] ata6.00: status: { DRDY }
[ 1937.424375] ata6: hard resetting link
[ 1937.743934] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 1937.745491] ata6.00: configured for UDMA/133
[ 1937.745498] ata6: EH complete
[ 1937.751920] ata6.00: exception Emask 0x10 SAct 0xc00000 SErr 0x400100 action 0x6 frozen
[ 1937.751948] ata6.00: irq_stat 0x08000000, interface fatal error
[ 1937.751966] ata6: SError: { UnrecovData Handshk }
[ 1937.751982] ata6.00: failed command: WRITE FPDMA QUEUED
[ 1937.751999] ata6.00: cmd 61/b8:b0:80:e2:03/02:00:00:00:00/40 tag 22 ncq 356352 out
[ 1937.751999]          res 40/00:b8:40:dd:03/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
[ 1937.752042] ata6.00: status: { DRDY }
[ 1937.752053] ata6.00: failed command: WRITE FPDMA QUEUED
[ 1937.752070] ata6.00: cmd 61/40:b8:40:dd:03/05:00:00:00:00/40 tag 23 ncq 688128 out
[ 1937.752070]          res 40/00:b8:40:dd:03/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
[ 1937.752113] ata6.00: status: { DRDY }
[ 1937.752125] ata6: hard resetting link
[ 1938.072176] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 1938.074013] ata6.00: configured for UDMA/133
[ 1938.074036] ata6: EH complete
etc.

The rest is lots and lots of I/O errors due to bad SATA cable.

> It got to roughly 15-17 % before I decided that the I/O errors were more
> scary than stopping the reshape.
>>
>>
>> What you'll have is one part of the array in one configuration, the
>> remaining part in another and no record of where that split begins.
> Like I said, ~15-17 % into the reshape.
>>
>> Regards,
>> Brad
