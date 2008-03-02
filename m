From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 02 Mar 2008 21:33:51 +0300
Message-ID: <47CAF30F.7040502@msgid.tls.msk.ru>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>	 <47CAC5BF.6060600@msgid.tls.msk.ru> <bb145bd20803020832x744c2674nd0a6a30e445b5453@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803020832x744c2674nd0a6a30e445b5453@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Christian Pernegger wrote:
>>  > OK. Back to the fs again, same command, different device. Still
>>  > glacially slow (and still running), only now the whole box is at a
>>  > standstill, too. cat /proc/cpuinfo takes about 3 minutes (!) to
>>  > complete, I'm still waiting for top to launch (15min and counting).
>>  > I'll leave mke2fs running for now ...
>>
>>  What's the state of your array at this point - is it resyncing?
> 
> Yes. Didn't think it would matter (much). Never did before.

It does.  If everything works ok, it should not, but it's not your
case ;)

>>   o how about making filesystem(s) on individual disks first, to see
>>     how that will work out?  Maybe on each of them in parallel? :)
> 
> Running. System is perfectly responsive during 4x mke2fs -j -q on raw devices.
> Done. Upper bound for duration is 8 minutes (probaby much lower,
> forgot to let it beep on completion), which is much better than the 2
> hours with the syncing RAID.

Aha.  Excellent.

>  26:    1041479        267   IO-APIC-fasteoi   sata_promise
>  27:          0          0   IO-APIC-fasteoi   sata_promise

> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  0  4      0  12864 1769688  10000    0    0     0 146822  539  809  0 26 23 51

Ok.  146Mb/sec.

> Cpu(s):  1.3%us,  8.1%sy,  0.0%ni, 41.6%id, 46.0%wa,  0.7%hi,  2.3%si,  0.0%st

46.0% waiting

> I hope you can interpret that :)

Some ;)

>>   o try --assume-clean when creating the array
> 
> mke2fs (same command as in first post) now running on fresh
> --assumed-clean array w/o crypto. System is only marginally less
> responsive than under idle load, if at all.

So the responsibility problem is solved here, right?  I mean, if
there's no resync going on (the case with --assume-clean), the rest
of the system works as expected, right?

> But inode table writing speed is only about 8-10/second. For the
> single disk case I couldn't read the numbers fast enough.

Note that mkfs now has to do 3x more work, too - since the device
is 3x (for 4-drive raid5) larger.

> chris@jesus:~$ cat /proc/interrupts
>  26:    1211165        267   IO-APIC-fasteoi   sata_promise
>  27:          0          0   IO-APIC-fasteoi   sata_promise
> 
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  0  1      0  11092 1813376  10804    0    0     0 13316  535 5201  0  9 51 40

That's 10 times slower than in the case of 4 individual disks.

> Cpu(s):  0.0%us, 10.1%sy,  0.0%ni, 55.6%id, 33.7%wa,  0.2%hi,  0.3%si,  0.0%st

and only 33.7% waiting, which is probably due to the lack of
parallelism.

> From vmstat I gather that total write throughput is an order of
> magnitude slower than on the 4 raw disks in parallel. Naturally the
> mke2fs on the raid isn't parallelized but it should still be
> sequential enough to get the max for a single disk (~60-40MB/s),
> right?

Well, not really.  Mkfs is doing many small writes all over the
place, so each is seek+write.  And it's syncronous - no next write
gets submitted till the current one completes.

Ok.  For now I don't see a problem (over than that there IS a problem
somewhere - obviously).  Interrupts are ok.  System time (10.1%) in
second case doesn't look right, but it was 8.1% before...

Only 2 guesses left.  And I really mean "guesses", because I can't
say definitely what's going on anyway.

First, try to disable bitmaps on the raid array, and see if it makes
any difference.  For some reason I think it will... ;)

And second, the whole thing looks pretty much like a more general
problem discussed here and elsewhere last few days.  I mean handling
of parallel reads and writes - when single write may stall reads
for quite some time and vise versa.  I see it every day on disks
without NCQ/TCQ - system is mostly single-tasking, sorta like
ol'good MS-DOG :)  Good TCQ-enabled drives survives very high load
while the system is still more-or-less responsible (and I forgot when
I last saw "bad" TCQ-enabled drive - even 10 y/o 4Gb seagate has
excellent TCQ support ;).  And all modern SATA stuff works pretty
much like old IDE drives, which were designed "for personal use",
or "single-task only" -- even ones that CLAMS to support NCQ in
reality does not....  But that's a long story, and your disks
and/or controllers (or the combination) don't even support NCQ...

/mjt
