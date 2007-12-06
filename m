From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Thu, 6 Dec 2007 15:05:11 -0800
Message-ID: <20071206150511.e0dd0b07.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
	<20071206140038.f06e18ad.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0712061737500.8523@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712061737500.8523@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

On Thu, 6 Dec 2007 17:38:08 -0500 (EST)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> 
> 
> On Thu, 6 Dec 2007, Andrew Morton wrote:
> 
> > On Sat, 1 Dec 2007 06:26:08 -0500 (EST)
> > Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >
> >> I am putting a new machine together and I have dual raptor raid 1 for the
> >> root, which works just fine under all stress tests.
> >>
> >> Then I have the WD 750 GiB drive (not RE2, desktop ones for ~150-160 on
> >> sale now adays):
> >>
> >> I ran the following:
> >>
> >> dd if=/dev/zero of=/dev/sdc
> >> dd if=/dev/zero of=/dev/sdd
> >> dd if=/dev/zero of=/dev/sde
> >>
> >> (as it is always a very good idea to do this with any new disk)
> >>
> >> And sometime along the way(?) (i had gone to sleep and let it run), this
> >> occurred:
> >>
> >> [42880.680144] ata3.00: exception Emask 0x10 SAct 0x0 SErr 0x4010000
> >> action 0x2 frozen
> >
> > Gee we're seeing a lot of these lately.
> >
> >> [42880.680231] ata3.00: irq_stat 0x00400040, connection status changed
> >> [42880.680290] ata3.00: cmd ec/00:00:00:00:00/00:00:00:00:00/00 tag 0 cdb
> >> 0x0 data 512 in
> >> [42880.680292]          res 40/00:ac:d8:64:54/00:00:57:00:00/40 Emask 0x10
> >> (ATA bus error)
> >> [42881.841899] ata3: soft resetting port
> >> [42885.966320] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >> [42915.919042] ata3.00: qc timeout (cmd 0xec)
> >> [42915.919094] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> >> [42915.919149] ata3.00: revalidation failed (errno=-5)
> >> [42915.919206] ata3: failed to recover some devices, retrying in 5 secs
> >> [42920.912458] ata3: hard resetting port
> >> [42926.411363] ata3: port is slow to respond, please be patient (Status
> >> 0x80)
> >> [42930.943080] ata3: COMRESET failed (errno=-16)
> >> [42930.943130] ata3: hard resetting port
> >> [42931.399628] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >> [42931.413523] ata3.00: configured for UDMA/133
> >> [42931.413586] ata3: EH pending after completion, repeating EH (cnt=4)
> >> [42931.413655] ata3: EH complete
> >> [42931.413719] sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors
> >> (750156 MB)
> >> [42931.413809] sd 2:0:0:0: [sdc] Write Protect is off
> >> [42931.413856] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> >> [42931.413867] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
> >> enabled, doesn't support DPO or FUA
> >>
> >> Usually when I see this sort of thing with another box I have full of
> >> raptors, it was due to a bad raptor and I never saw it again after I
> >> replaced the disk that it happened on, but that was using the Intel P965
> >> chipset.
> >>
> >> For this board, it is a Gigabyte GSP-P35-DS4 (Rev 2.0) and I have all of
> >> the drives (2 raptors, 3 750s connected to the Intel ICH9 Southbridge).
> >>
> >> I am going to do some further testing but does this indicate a bad drive?
> >> Bad cable?  Bad connector?
> >>
> >> As you can see above, /dev/sdc stopped responding for a little bit and
> >> then the kernel reset the port.
> >>
> >> Why is this though?  What is the likely root cause?  Should I replace the
> >> drive?  Obviously this is not normal and cannot be good at all, the idea
> >> is to put these drives in a RAID5 and if one is going to timeout that is
> >> going to cause the array to go degraded and thus be worthless in a raid5
> >> configuration.
> >>
> >> Can anyone offer any insight here?
> >
> > It would be interesting to try 2.6.21 or 2.6.22.
> >
> 
> This was due to NCQ issues (disabling it fixed the problem).
> 

I cannot locate any further email discussion on this topic.

Disabling NCQ at either compile time or runtime is not a "fix" and further
work should be done here to maek the kernel run acceptably on that
hardware.
