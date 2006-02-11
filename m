From: "Paul M." <paul@gpmidi.net>
Subject: Re: Adding Latency To Disk Access
Date: Sat, 11 Feb 2006 09:50:48 +0000
Message-ID: <dd43dcfb0602110150t2a1b6018va55323e5801fdbae@mail.gmail.com>
References: <dd43dcfb0602061349l437a69b8w365dc38dc5809682@mail.gmail.com>
	 <43E7DF87.6060000@s5r6.in-berlin.de>
	 <dd43dcfb0602070312r1349d555r5217a4e246b7be6@mail.gmail.com>
	 <43E8A9B6.7040902@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E8A9B6.7040902@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  I am currently trying to build a RAID5 array across 12 disks. The
problem is there is a bug in the linux firewire drivers that is causes
problems when multiple disks are accessed randomly at the same time.
As you can imagine the soft RAID5 drivers try to do exactly that -
access all 12 disks at once.
  Can the software raid drivers be made to only access one disk at a
time and to wait for a requested to be fulfilled before submitting
another?
-Paul

On 2/7/06, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Paul M. wrote:
> > On 2/6/06, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> ...
> >>Do sbp2, ieee1394, or ohci1394 log messages during I/O?
> >
> > Yup, stuff like:
> >
> > Jan 29 19:03:34 bob kernel: ieee1394: sbp2: aborting sbp2 command
> > Jan 29 19:03:34 bob kernel: scsi3 : destination target 1, lun 0
> > Jan 29 19:03:34 bob kernel:         command: Read (10): 28 00 09 ad b0
> > 3f 00 00 58 00
> > Jan 29 19:04:27 bob kernel: ieee1394: sbp2: aborting sbp2 command
> > Jan 29 19:04:27 bob kernel: scsi1 : destination target 1, lun 0
> > Jan 29 19:04:27 bob kernel:         command: Write (10): 2a 00 00 0b
> > 83 e7 00 00 f8 00
>
> Hmm, the usual... Sbp2 is certainly doing something wrong but we don't
> know what. I hope I can spend some time during this month on this problem.
>
> > I've put this and some other stuff at the bottom of the message.
>
> Thanks.
>
> >>>I currently have serial_io=1 but need a way to add some latency in.
> >>
> >>Perhaps you actually want more fairness rather than more latency.
> >
> > Perhaps. I guess the question is: What is windows doing differently?
>
> It features an SBP-2 driver without the bug that we were unable to find
> yet...
>
> >>There is no way to easily modify sbp2 WRT latency or fairness because
> >>(a) it is not the proper layer and (b) sbp2 handles normal I/O from
> >>software interrupt context. I plan to do something about the latter.
> >
> > damn. Guess I'll hope that its possible to slow stuff down from the md
> > drivers. It might be easier there since it will have all the IO for
> > the disks in one spot.
>
> Sbp2 could be converted to use a single Scsi_Host for all devices, and
> the queue depth of this host could be set down to one. (Performance will
> go down the drain.) This modification won't be easy of course.
>
> However you could try the max_speed parameter of sbp2, as a desparate
> last measure to slow everything further down.
>
> Now to the syslog:
>
> > Jan 29 09:06:43 bob kernel: ohci1394: fw-host0: Unexpected PCI
> > resource length of 1000!
>
> No problem at all, despite the exclamation mark.
>
> ...
> > Jan 29 09:06:45 bob kernel: Badness in ohci_hw_csr_reg at
> > drivers/ieee1394/ohci1394.c:3188 (Not tainted)
> > Jan 29 09:06:45 bob kernel:  [<c8866fcf>] ohci_hw_csr_reg+0xaa/0xac [ohci1394]
> > Jan 29 09:06:45 bob kernel:  [<c8866f25>] ohci_hw_csr_reg+0x0/0xac [ohci1394]
> > Jan 29 09:06:45 bob kernel:  [<c88c2e04>] host_reset+0x71/0x11c [ieee1394]
> > Jan 29 09:06:45 bob kernel:  [<c88c260c>]
> > highlevel_host_reset+0x2f/0x42 [ieee1394]
> > Jan 29 09:06:45 bob kernel:  [<c8865fae>] ohci_irq_handler+0x788/0x7a9
> > [ohci1394]
>
> As far as I have seen, only Redhat/ FC kernels report this "badness"
> despite its existing in all kernels. It is not a critical problem but we
> should do something about it eventually. It does not concern sbp2 though.
>
> ...
> > Jan 29 09:06:46 bob kernel: sda: asking for cache data failed
> > Jan 29 09:06:46 bob kernel: sda: assuming drive cache: write through
>
> No problem AFAIK.
>
> ...
> > Jan 29 19:00:20 bob kernel: ieee1394: sbp2: aborting sbp2 command
> ...
>
> And here we go again...
> --
> Stefan Richter
> -=====-=-==- --=- --===
> http://arcgraph.de/sr/
>
