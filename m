From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Weird RAID 1 performance
Date: Sun, 19 Sep 2004 11:10:34 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0409191001390.30137@lion.drogon.net>
References: <414CA490.9010205@movzx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <414CA490.9010205@movzx.net>
To: Andrei Badea <andrei.badea@movzx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 18 Sep 2004, Andrei Badea wrote:

> Hello,
>
> I have a RAID 1 whose write performance I tested by writing a 10 GB file
> to it:
>
> dd if=/dev/zero of=/mnt/data/zeros bs=1024 count=...
>
> Looking at GKrellM I noticed the CPU usage is very jumpy, going from a
> few to 99 percent (but usually is roughly rovers around 50 percent).
> Moreover, the transfer regularly stops for a few seconds (the CPU usage
> is then about 2 percent). The average data transfer rate was 16 MB/s,
> while the disks alone can make almost 25 MB/s.

Modern IDE drives with the correct cabling ought to be able to write at up
to 55MB/sec.

  gordon @ argus: time dd if=/dev/zero of=bigfile bs=1024 count=10485760
  10485760+0 records in
  10485760+0 records out
  2.570u 77.210s 3:43.44 35.7%    0+0k 0+0io 101pf+0w
  gordon @ argus: du -h bigfile
  11G     bigfile

Doing the math on elapsed time gives me about 45 MB/sec

Thats to an Ext3, RAID1 mount with 2 IDE drives. (hda, hdc)


So the first thing to check (as it's the easiest) is the drivers. Do you
have the right drivers installed for the hardware you have?

I'm guessing it's a PCI card (from /dev/hde1 and /dev/hdg1 in your
raidtab) or maybe a 2nd on-board controller with a pseudo RAID function.

Run hdparm /dev/hde /dev/hdg and see what you get. You ought to have DMA
turned on. If it's not, then you need to make sure you have the right
driver compiled into the kernel (or the right module loaded)

The next thing to look for is interrupt sharing. I've found a lot of
motherboards appear to have broken interrupt controllers. If it's running
with an APIC, check /proc/interrupts for MIS or ERR numbers > 0. Try
turning the APIC off (either by not compiling it into the kernel, or
passing the noapic flag in the kernel boot line (append="noapic" in
lilo.conf) The BIOS might also have a mode for either PIC or APIC.

You also might want to check /proc/interrupts to try to make sure every
device has its own interrupt anyway, but this might be impossible to do
depending on your hardware. I'm guessing you have a 2-port PCI card and
are using 2 cables off it (one drive per cable which is good) and if so
it'll probably have just one interrpt for both devices. If you have a 2nd
card, try that, then it's one drive per card which might be better.

> Is this normal behavior? Can the write performance be tuned (to be less
> "jumpy")?

Interupts (and/or more likely the controllers) seem to me to be the
biggest bug/feature of a modern motherboard )-: I've seen systems work
fine - until you load up the Ethernet interface, or start to use the
(scsi) tape drive. Maybe the video capture card is in the same interrupt
and the hardware just can't cope with it? I have observed "jumpy"
behaviour as you describe too.

> The reason I'm asking is that I'm encoutering hangs when video capturing
> to this RAID using mencoder and huffyuv. I'm not experiencing the hangs
> when capturing to another partition (not RAID). Neither did I experience
>   hangs during the dd copy.

Writing to a RADI1 is going to do double the IO that writing to a single
devie will do. You might want to try to un-raid the devices and try to
write to just one of teh disks, then the other, but my guess is that you
won't see the problem until you load the bus/interrupt system by writing
to both as the same time (which RAID1 will try to do)

You might also want to see if theres some process stuffing data out to a
log-file via syslog during the capture. Some log files will get flushed
out on every write which might affect performance. See if anythings
growing in /var/log during a capture and check its entry in
/etc/syslog.conf. This might not be obviously a problem, but it could be
causing writes to a different disk (I'm guessing you have a /dev/hda to
boot from which is where the log-files go). So writing to that non-RAID
disk is fine, but load the system up with writing to that drive and the 2
RAID drives and ...

> Maybe the RAID 1 is just not suited for video capture?

I suspect the issues with your PC are more likely to be some hardware &
software (interrupt)  problem rather than the RAID1 code. I've been using
the Linux s/w RAID for many years now and not had a problem with the
drivers at all - in all cases it's been the underlying hardware (or
specific PCI/IDE hardware drivers) which has been the issue.

Good luck!

Gordon
