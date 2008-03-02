From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 17:32:45 +0100
Message-ID: <bb145bd20803020832x744c2674nd0a6a30e445b5453@mail.gmail.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
	 <47CAC5BF.6060600@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47CAC5BF.6060600@msgid.tls.msk.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

>  > OK. Back to the fs again, same command, different device. Still
>  > glacially slow (and still running), only now the whole box is at a
>  > standstill, too. cat /proc/cpuinfo takes about 3 minutes (!) to
>  > complete, I'm still waiting for top to launch (15min and counting).
>  > I'll leave mke2fs running for now ...
>
>  What's the state of your array at this point - is it resyncing?

Yes. Didn't think it would matter (much). Never did before.

>   o how about making filesystem(s) on individual disks first, to see
>     how that will work out?  Maybe on each of them in parallel? :)

Running. System is perfectly responsive during 4x mke2fs -j -q on raw devices.
Done. Upper bound for duration is 8 minutes (probaby much lower,
forgot to let it beep on completion), which is much better than the 2
hours with the syncing RAID.


chris@jesus:~$ cat /proc/interrupts
           CPU0       CPU1
  0:       4939    1920632   IO-APIC-edge      timer
  1:        113        133   IO-APIC-edge      i8042
  6:          0          3   IO-APIC-edge      floppy
  7:          0          0   IO-APIC-edge      parport0
  8:          0          1   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          0          4   IO-APIC-edge      i8042
 14:          0        182   IO-APIC-edge      ide0
 19:         87         34   IO-APIC-fasteoi   ohci_hcd:usb1,
ohci_hcd:usb2, firewire_ohci
 24:      10142         57   IO-APIC-fasteoi   eth0
 26:    1041479        267   IO-APIC-fasteoi   sata_promise
 27:          0          0   IO-APIC-fasteoi   sata_promise
 28:       7141       2789   IO-APIC-fasteoi   aic7xxx
NMI:          0          0
LOC:    1925715    1925691
ERR:          0


chris@jesus:~$ vmstat 2
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 3  4      0  12716 1770264   9972    0    0  1034  4902  196  883  0  9 78 13
 0  4      0  11404 1771260   9972    0    0     0 150156  544  874  0 26 28 46
 0  4      0  11836 1771016  10024    0    0     0 147500  544  682  0 26 26 48
 0  4      0  12572 1770036  10108    0    0     0 131022  515  506  0 25 13 62
 0  4      0  12864 1769688  10000    0    0     0 146822  539  809  0 26 23 51
 0  4      0  12132 1769988   9956    0    0     0 145942  536  900  0 26 15 59
 0  4      0  12520 1770324   9976    0    0     0 144638  536  820  0 26 32 42


top - 17:08:55 up  2:12,  2 users,  load average: 4.37, 3.13, 1.49
Tasks:  78 total,   1 running,  77 sleeping,   0 stopped,   0 zombie
Cpu(s):  1.3%us,  8.1%sy,  0.0%ni, 41.6%id, 46.0%wa,  0.7%hi,  2.3%si,  0.0%st
Mem:   2063940k total,  2051316k used,    12624k free,  1746616k buffers


I hope you can interpret that :)

>   o try --assume-clean when creating the array

mke2fs (same command as in first post) now running on fresh
--assumed-clean array w/o crypto. System is only marginally less
responsive than under idle load, if at all.
But inode table writing speed is only about 8-10/second. For the
single disk case I couldn't read the numbers fast enough.

chris@jesus:~$ cat /proc/interrupts
           CPU0       CPU1
  0:       7485    2227196   IO-APIC-edge      timer
  1:        113        133   IO-APIC-edge      i8042
  6:          0          3   IO-APIC-edge      floppy
  7:          0          0   IO-APIC-edge      parport0
  8:          0          1   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          0          4   IO-APIC-edge      i8042
 14:          0        182   IO-APIC-edge      ide0
 19:        101         39   IO-APIC-fasteoi   ohci_hcd:usb1,
ohci_hcd:usb2, firewire_ohci
 24:      15656         57   IO-APIC-fasteoi   eth0
 26:    1211165        267   IO-APIC-fasteoi   sata_promise
 27:          0          0   IO-APIC-fasteoi   sata_promise
 28:       7892       2938   IO-APIC-fasteoi   aic7xxx
NMI:          0          0
LOC:    2234843    2234819
ERR:          0


chris@jesus:~$ vmstat 2
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  1      0  12996 1811456  10860    0    0   912  4824  194  867  0  9 78 13
 0  0      0  11532 1812992  10832    0    0     0 12924  532 4992  0 11 61 28
 0  1      0  11092 1813376  10804    0    0     0 13316  535 5201  0  9 51 40
 0  0      0  12968 1811584  10832    0    0     0 12570  518 4890  0  9 58 32
 0  1      0  11724 1812736  10816    0    0     0 12818  508 5337  0 10 52 38
 0  0      0  12780 1811712  10804    0    0     0 13994  546 5055  0  9 52 40


top - 17:26:37 up  2:29,  2 users,  load average: 2.89, 2.12, 1.42
Tasks:  75 total,   2 running,  73 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us, 10.1%sy,  0.0%ni, 55.6%id, 33.7%wa,  0.2%hi,  0.3%si,  0.0%st
Mem:   2063940k total,  2052148k used,    11792k free,  1812288k buffers

From vmstat I gather that total write throughput is an order of
magnitude slower than on the 4 raw disks in parallel. Naturally the
mke2fs on the raid isn't parallelized but it should still be
sequential enough to get the max for a single disk (~60-40MB/s),
right?

Thanks for helping.

C.
