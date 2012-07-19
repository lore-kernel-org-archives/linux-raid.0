From: Alex <mysqlstudent@gmail.com>
Subject: Re: Need to remove failed disk from RAID5 array
Date: Thu, 19 Jul 2012 11:37:12 -0400
Message-ID: <CAB1R3sg8qZQqFVn-So9QVViLuit7vp6sRJfn+G829hs7JEp4Zw@mail.gmail.com>
References: <CAB1R3shxBWebm13ie5gR0h++-GBTyfZrranHr8tjGkbPipV32w@mail.gmail.com>
	<50071C0A.8080307@tmr.com>
	<CAB1R3sjhES1+0XB43oXLomgH7Q6LPiTm11tPSoDJ91RRrfNy=A@mail.gmail.com>
	<20120719091611.22e16100@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120719091611.22e16100@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi,

>> I'm not sure what stats I could provide to troubleshoot this further.
>> At this rate, the 2.7T array will take a full day to resync. Is that
>> to be expected?
>
> 1) did you try increasing stripe_cache_size?
>
> 2) maybe it's an "Advanced Format" drive, the RAID partition is not properly
> aligned?

I'm not familiar with either of those settings. The sync speed is now
down to about 6M/sec, or about two days.

I tried increasing the stripe_cache_size with various values,
including 1024, 4096, and 8192 from the default 256. Looks like the
1024 is the best, but with only a marginal increase in speed from the
256. It's now about 8M/sec.

What is an AF drive?

According to dstat, after watching for a few minutes, there are some
large reads (15-17M), but all writes are small, and there are times
when read and write are very low or near zero.

There are four disks in the system. One is a WD and the others are
Seagate's of the same model. Does this tell you anything?

# hdparm -i /dev/sda

/dev/sda:

 Model=WDC WD1002FAEX-00Z3A0, FwRev=05.01D05, SerialNo=WD-WMATR0921907
 Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs FmtGapReq }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=50
 BuffType=unknown, BuffSize=unknown, MaxMultSect=16, MultSect=16
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=1953525168
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7

# hdparm -i /dev/sdb

/dev/sdb:

 Model=ST31000340NS, FwRev=SN06, SerialNo=9QJ70X3C
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=unknown, BuffSize=unknown, MaxMultSect=16, MultSect=16
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=1953525168
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: unknown:  ATA/ATAPI-4,5,6,7

Any ideas greatly appreciated. The system is also now horribly slow.

Thanks,
Alex
