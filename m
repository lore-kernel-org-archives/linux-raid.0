From: Jerome Alet <alet@librelogiciel.com>
Subject: strange problem with software raid 5
Date: Mon, 25 Oct 2004 15:31:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041025133122.GB12488@mail.librelogiciel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

I've got a problem which has me stuck for a too long time now

Let me explain, this is LONG...

I had an assembled PC with an Adaptec 29160 SCSI adapter
and some IBM 36 Gb 10000t/min hard disks, not used in a raid array,
which failed one after the other during several months

We decided once again replace the faulty SCSI disk and to install a 
software raid5 array of 4 Maxtor 160 Gb IDE disks, plugged into a 
Promise IDE Fasttrak Raid Lite controller *but not used as a Raid 
controller*, and this worked fine during 7 months, with Debian stock 
kernel 2.4.18 (Woody)

Then the new SCSI disk failed again (3rd one !!!), and so we
tested both the disks we already changed (we kept them fortunately)
and the controller, and it was the controller which was faulty finally.

but unfortunately our RAID5 array was destroyed at the time the SCSI
controller died (for the last time), and we don't know the reason
since it was plugged into an IDE controller...

So we changed the SCSI controller for an Adaptec 29320, which seems
to work just fine so far (we upgraded the server to Sarge and
a 2.4.27 smp kernel, the one from the distribution), but our RAID5
array refused to start : some disks are not detected or are detected
at boot time, maybe depending on the weather or some magic thing,
I don't know....

Finally I was able to make the 4 IDE drives recognized again,
using the pdc202xx_old kernel module, I recreated the array,
which synced with no apparent problem, restored 55 Gb of datas, 
and we worked with it last week with no problem.

All was fine, until this morning when the server seemed to have
stopped and failed to restart, because again some IDE disks weren't
correctly recognized (the SCSI part with the new controller is still fine)

The kernel logs show some I/O errors occuring on the RAID array on
October 23th, and timeouts, for a moment before the server died.

Now again I've got the 4 IDE drives recognized (I still don't
know why), but the RAID5 array refuses to start saying that 2
of my 3 disks are faulty (the 4th one is the spare)

Question : what can I do now ? 

FYI I don't think this is an hardware problem since the same
RAID array worked for several months before, but I suspect
a conflict somewhere.

cat /proc/interrupts gives me :

           CPU0       CPU1       
  0:     738969     746913    IO-APIC-edge  timer
  1:        446        296    IO-APIC-edge  keyboard
  2:          0          0          XT-PIC  cascade
  8:          2          2    IO-APIC-edge  rtc
 11:         34         18   IO-APIC-level  aic79xx
 14:          5          7    IO-APIC-edge  ide0
 15:   32542012   32565155   IO-APIC-level  aic79xx, ide2, ide3, eth0
NMI:          0          0 
LOC:    1485325    1484507 
ERR:          0
MIS:         66

and what is on IRQ15 seems to be "a lot" !

ide0 is the "normal" ide controller with just a CDROM on it,
ide2 and ide3 are the Fasttrak IDE RAID controller Lite (not used
as RAID) on which are plugged hde, hdf, hdg and hdh which are
the disks in my RAID5 array (hdh being the spare drive)

I basically think that the new SCSI controller is in IRQ conflict
with the IDE RAID controller's channels and the network card,
but I'm stuck, I don't know what to do now...

Thanks in advance for any help

Jerome Alet
