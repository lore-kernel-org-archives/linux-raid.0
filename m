From: "Matthew Simpson" <matthew@symatec-computer.com>
Subject: Re: how to turn down cpu usage of raid ?
Date: Mon, 2 Feb 2004 20:25:17 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <02ad01c3e9fc$f70d4be0$0100a8c0@KARI>
References: <Pine.LNX.4.44.0402022000380.5536-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No, I'm not using DMA.  :(

/dev/hda:
 multcount    =  0 (off)
 IO_support   =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  0 (off)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    =  8 (on)
 geometry     = 10587/240/63, sectors = 160086528, start = 0

Model=Maxtor 6Y080P0, FwRev=YAR41BW0, SerialNo=Y24BG1QE
 Config={ Fixed }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=57
 BuffType=DualPortCache, BuffSize=7936kB, MaxMultSect=16, MultSect=off
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=160086528
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5 udma6
 AdvancedPM=yes: disabled (255) WriteCache=enabled
 Drive conforms to: :  1 2 3 4 5 6 7

hdc is the same of course, they are matched disks.

I did some googling on hdparm before and found out how to change things, but
I am nervous about changing my production servers after testing hdparm on
another server.  The problem is that my two production servers are using the
Intel chipset [same board], and the test server is using a Via chipset.  I
was able to set multcount to 16, IO support to 3 [32-bit sync], but I
tried -X66 -u1 -d1 and OOPSed the kernel.  Not sure if it was the -X66,
the -u1, or the -d1 that killed it, but I'm not sure what is safe to screw
with, and I can't hose a production server.  Of course the Intel boards
might be better....

Here is the other server, same Intel controller, but WDC disks instead of
Maxtor:

/dev/hda:
 multcount    =  0 (off)
 IO_support   =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  0 (off)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    =  8 (on)
 geometry     = 9729/255/63, sectors = 156301488, start = 0

 Model=WDC WD800JB-00ETA0, FwRev=77.07W77, SerialNo=WD-WCAHL4821776
 Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs FmtGapReq }
 RawCHS=16383/16/63, TrkSize=57600, SectSize=600, ECCbytes=74
 BuffType=DualPortCache, BuffSize=8192kB, MaxMultSect=16, MultSect=off
 CurCHS=65535/1/63, CurSects=4128705, LBA=yes, LBAsects=156301488
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: device does not report version:  1 2 3 4 5 6

What is the most important value to help this problem out?  I did some tests
with hdparm -Tt on the Via server, and adding multcount 16 and changing the
IO_support to 32-bit sync actually HURT performance instead of helping it.
If DMA is the biggest issue here, I can try turning turning that on and hope
for the best...

yours,
Matthew

----- Original Message ----- 
From: "Mark Hahn" <hahn@physics.mcmaster.ca>
To: "Matthew Simpson" <matthew@symatec-computer.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Monday, February 02, 2004 7:37 PM
Subject: Re: how to turn down cpu usage of raid ?


> > Help!  I am having complaints from users about CPU spikes when writing
to my
> > RAID 1 array.
>
> I can think of two answers: first, are you sure your drives are configured
> sanely?  that is, using dma?  with any reasonable kernel, they should be,
> but its possible to compile in the wrong driver or make some other
mistake.
> hdparm -iv /dev/hda and hdc should show using_dma=1.  you can also look
> at /proc/ide/hda/settings.
>
> second, perhaps you should simply make the kernel less lazy at starting
> writes.  here's some basic settings from 2.4:
>
> [hahn@hahn hahn]$ cat /proc/sys/vm/bdflush
> 30      500     0       0       500     3000    60      20      0
>
>  Value      Meaning
>  nfract     Percentage of buffer cache dirty to activate bdflush
>  ndirty     Maximum number of dirty blocks to  write out per wake-cycle
>  dummy      Unused
>  dummy      Unused
>  interval   jiffies delay between kupdate flushes
>  age_buffer Time for normal buffer to age before we flush it
>  nfract_sync Percentage of buffer cache dirty to activate bdflush
>  synchronously
>  nfract_stop_bdflush Percetange of buffer cache dirty to stop bdflush
>  dummy      Unused
>
>
> in theory, this means:
> - wake up bdflush when 30% of buffers are dirty.
> - write up to 500 blocks per wakeup.
> - 5 seconds between wakeups.
> - let a buffer age for 30 seconds before flushing it.
> - if 60% of buffers are dirty, start throttling dirtiers.
> - stop bdflush when < 20% of buffers are dirty.
>
> of course, the code doesn't exactly do this, and 2.6 is very different.
> still, I'm guessing that:
> - 500 buffers (pages, right?) is too little
> - 5 seconds is to infrequent
> - 30 seconds is probably too long
>
> I have the fileserver for one of my clusters running much smoother with
> ndirty=1000, interval=200 and age_buffer=1000.  my logic is that the disk
> system can sustain around 200 MB/s, so flushing 4MB per wakeup is pretty
> minimal.  I also hate to see the typical burstiness of bdflush - no IO
> between bursts at 5 second intervals.  I'd rather see a smoother stream of
> write-outs - perhaps even a 1-second interval.  finally, Unix's
traditional
> 30-second laziness is mainly done in the hopes that a temporary file will
be
> deleted before ever hitting the disk (and/or writes will be combined).  I
> think 30 seconds is an eternity nowadays, and 10 seconds is more
reasonable.
>
> in short:
> echo '30 1000 0 0 200 1000 60 20 0' > /proc/sys/vm/bdflush
>
> perhaps:
> echo '30 1000 0 0 100 1000 60 20 0' > /proc/sys/vm/bdflush
>
> for extra credit, investigate whether nfract=30 is too high (I think so,
on
> today's big-memory systems).  whether higher ndirty improves balance
(these
> writes would compete with application IO, so might hurt, albeit less with
> 2.6's smarter IO scheduler.)  whether the sync/stop parameters make a
> difference, too - throttling dirtiers should probably kick in earlier,
> but if you lower nfract, also lower nfract_stop_bdflush...
>
> > Is there a way I can tune software RAID so that writing
> > updates doesn't interfere with other applications?
>
> remember also that many servers don't need atime updates; this can make a
big
> difference in some cases.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

