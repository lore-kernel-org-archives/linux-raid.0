From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
Date: Thu, 28 Jun 2007 04:38:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706280437170.1406@p34.internal.lan>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan>
 <46832E60.9000006@rabbit.us> <Pine.LNX.4.64.0706280406520.1406@p34.internal.lan>
 <46837056.4050306@rabbit.us> <Pine.LNX.4.64.0706280426500.1406@p34.internal.lan>
 <46837307.20005@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46837307.20005@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 28 Jun 2007, Peter Rabbitson wrote:

> Justin Piszcz wrote:
>> 
>> On Thu, 28 Jun 2007, Peter Rabbitson wrote:
>> 
>>> Interesting, I came up with the same results (1M chunk being superior) 
>>> with a completely different raid set with XFS on top:
>>> 
>>> ...
>>> 
>>> Could it be attributed to XFS itself?
>>> 
>>> Peter
>>> 
>> 
>> Good question, by the way how much cache do the drives have that you are 
>> testing with?
>> 
>
> I believe 8MB, but I am not sure I am looking at the right number:
>
> root@Arzamas:~# hdparm -i /dev/sda
>
> /dev/sda:
>
> Model=aMtxro7 2Y050M                          , FwRev=AY5RH10W, 
> SerialNo=6YB6Z7E4
> Config={ Fixed }
> RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
> BuffType=DualPortCache, BuffSize=7936kB, MaxMultSect=16, MultSect=?0?
> CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
> IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
> PIO modes:  pio0 pio1 pio2 pio3 pio4
> DMA modes:  mdma0 mdma1 mdma2
> UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5
> AdvancedPM=yes: disabled (255) WriteCache=enabled
> Drive conforms to: ATA/ATAPI-7 T13 1532D revision 0:  ATA/ATAPI-1 
> ATA/ATAPI-2 ATA/ATAPI-3 ATA/ATAPI-4 ATA/ATAPI-5 ATA/ATAPI-6 ATA/ATAPI-7
>
> * signifies the current active mode
>
> root@Arzamas:~#
>
> 1M chunk consistently delivered best performance with:
>
> o A plain dumb dd run
> o bonnie
> o two bonnie threads
> o iozone with 4 threads
>
> My RA is set at 256 for the drives and 16384 for the array (128k and 8M 
> respectively)
>

8MB yup: BuffSize=7936kB.

My read ahead is set to 64 megabytes and 16384 for the stripe_size_cache.

Justin.
