From: David Liontooth <lionteeth@cogweb.net>
Subject: Re: Raid0 rebuild slows to a crawl
Date: Fri, 13 Jan 2012 15:06:51 +0530
Message-ID: <4F0FFB33.5090808@cogweb.net>
References: <4F0FE4CD.3070703@cogweb.net> <4F0FEF00.7080300@uni-konstanz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0FEF00.7080300@uni-konstanz.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Much appreciated! I'll notify next-of-kin.

Cheers,
Dave

On 01/13/2012 02:14 PM, Kay Diederichs wrote:
> On 01/13/2012 09:01 AM, David Liontooth wrote:
>>
>> I'm trying to use a WD3200AAKX-001CA0 drive in a raid1 configuration
>> (Debian squeeze mdadm 3.1.4-1+8efb9d1), but adding it is unusably slow:
>>
>> # cat /proc/mdstat
>> Personalities : [raid1]
>> md1 : active raid1 sdb3[2] sda3[1]
>> 73015360 blocks [2/1] [_U]
>> [>....................] recovery = 0.0% (28928/73015360)
>> finish=2521.6min speed=482K/sec
>>
>> dmesg shows no errors:
>>
>> md: recovery of RAID array md0
>> md: minimum _guaranteed_ speed: 1000 KB/sec/disk.
>> md: using maximum available idle IO bandwidth (but not more than 200000
>> KB/sec) for recovery.
>>
>> The drive itself doesn't seem to have a problem, though it's not
>> particularly fast:
>>
>> # hdparm -tT /dev/sdb
>>
>> /dev/sdb:
>> Timing cached reads: 11220 MB in 2.00 seconds = 5614.03 MB/sec
>> Timing buffered disk reads: 174 MB in 6.44 seconds = 27.01 MB/sec
>>
>> # smartctl -a /dev/sdb
>>
>> 5 Reallocated_Sector_Ct 0x0033 133 133 140 Pre-fail Always 
>> FAILING_NOW 1265
>>
>> # hdparm -i /dev/sdb
>>
>> /dev/sdb:
>>
>> Model=WDC WD3200AAKX-001CA0, FwRev=15.01H15, SerialNo=WD-WCAYUEJ66523
>> Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs 
>> FmtGapReq }
>> RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=50
>> BuffType=unknown, BuffSize=16384kB, MaxMultSect=16, MultSect=off
>> CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=625142448
>> IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
>> PIO modes: pio0 pio3 pio4
>> DMA modes: mdma0 mdma1 mdma2
>> UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
>> AdvancedPM=no WriteCache=enabled
>> Drive conforms to: Unspecified: ATA/ATAPI-1,2,3,4,5,6,7
>>
>> * signifies the current active mode
>>
>> Is this a known problem? Only see it with this WD drive.
>>
>> Cheers,
>> Dave
>>
>
> Hi Dave,
>
> I'd say your drive is dying if its Reallocated_Sector_Ct is 1265. 
> Dying drives often are really slow; they spend the time on trying to 
> overcome error states.
>
> HTH,
> Kay
>

