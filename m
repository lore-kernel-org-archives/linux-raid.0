From: Tim Small <tim@buttersideup.com>
Subject: Software vs. Hardware RAID
Date: Tue, 03 Aug 2004 12:47:49 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <410F7B65.3090407@buttersideup.com>
References: <Pine.LNX.4.44.0408010858370.7382-100000@uplift.swm.pp.se> <Pine.LNX.4.56.0408010804370.6442@lion.drogon.net> <Pine.LNX.4.58.0408021554070.7168@taurus.cesta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0408021554070.7168@taurus.cesta.com>
To: Julian Cowley <julian@lava.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Julian Cowley wrote:

>Recently I did a survey of this very question (hardware vs. software
>RAID) based on the comments from this mailing list:
>
>Software
>--------
>
>- CPU must handle operations
>- twice the I/O bandwidth when using RAID1
>  
>
Yes (during writes)

>+ non-proprietary disk format
>+ open source implementation
>- limited or non-existent support for hot-swapping, even with SATA
>  (see http://www.redhat.com/archives/fedora-test-list/2004-March/msg01204.html)
>  
>
I've swapped out SCSI drives with software RAID on a live system - it 
isn't 100% smooth, as it triggers a bus reset on these systems, and 
hence about 15 seconds of no-I/O, but the machine did work afterwards, 
and no reboot was required.  For SATA hot-swap, see this article:

http://kerneltrap.org/node/view/3432

>- OS-specific format (can't be shared between Linux, Windows, etc.)
>  
>
Well, you can configure a partition as mirrored using Linux software 
RAID, and then have Windows use the rest of the disk..  Whether you 
could then have Windows use it's own software RAID on the rest of the 
disk, I couldn't say..  As long as you kept access to read-only you 
could probably then read the whole of the fs content from both OS (why 
do you want to run Windows anyway? :o)

>+ drives can be anything (ie. a mixture of SATA, PATA, Firewire, USB, etc.)
>- disk surface testing must be done manually (7/2004)
>  
>
Smartd can automate this e.g. these lines in smartd.conf will tell the 
drives to do an extended self-test at 1am, and 2am on Saturday...

/dev/hda -a -s L/../../6/01 -m root
/dev/hdc -a -s L/../../6/02 -m root

This may catch blocks which are going bad before they become unreadable 
(i.e. when the hardware and/or firmware ECC algorithms are still able to 
reconstruct the data), and cause the drive to silently remap these 
blocks - so these may well save you an array degradation...

>- no bad block relocation (7/2004)
>  
>
Most drives will do this automatically, except in the event of data loss 
(i.e. if it can't reconstruct the correct data, it will just return a 
read error - if you try to write the entire block, it will then remap 
it) - with software RAID, you will end up with a degraded array at the 
moment.  It would be cool if the software raid subsystem would try to 
rewrite individual blocks which have had read failures (assuming it has 
info on the other disks, or n RAM to do this) before marking the whole 
partition as bad, but it doesn't at the moment (AFAIK).

I've had cases (on IBM 75GXP drives <spit>), where two drives in a 
mirror have independently had different unreadable sectors, and the 
hardware RAID controller has kicked out drives, and left the OS with an 
unusable array (although together, both drives have all the data - 
grrr).  If this was software RAID, the same thing would have happened, 
but at least I would have been able to manually copy bad blocks from the 
failed drive using dd, without taking down the OS.

>- no parity verification (7/2004)
>- no mirror verification (7/2004)
>  
>
True, but with the exception of kernel bugs, arrays shouldn't get into 
these states.  Would be a nice feature tho'.

>+ reputedly, much better performance than hardware raid
>  
>
Can be I think, yes.  e.g. I get ~120 MB/Sec linear device reads/writes 
on a 3x 10k rpm 75G (all drives on a single U320 SCSI bus) software 
raid5 array that I've built.  With modern CPUs, the processing overhead 
required for RAID is not highly significant - a bit higher if an array 
is degraded, and on RAID5 writes of course - e.g. see this kernel output 
on a dual Xeon 2.8GHz box:

raid5: using function: pIII_sse (3649.600 MB/sec)

And this on a dual Opteron 248

raid5: using function: generic_sse (6744.000 MB/sec)

so parity calculation is not a serious overhead these days, but the 
extra I/O may be - on the 2.8GHz Xeon box (which is the aforementioned 
3x 10k rpm SCSI machine, running 2.4.26), I see:

Read from RAID5:

119MB/Sec, with 25% kernel CPU usage

Read from RAID5 (degraded array):

127MB/Sec, with 60% kernel CPU usage

>Hardware
>--------
>
>+ off-loads the CPU
>+ I/O bandwidth needed on a RAID1 system is same as single disk
>  
>
again, this is only for writes, you get a similar effect with RAID5 
(e.g. a four disk RAID5 needs 1.25 times the writes)

>- proprietary disk format (although limited drivers are available for Linux)
>- proprietary implementation
>+ easy hot-swapping (some controllers even indicate the bad drive with an LED)
>+ non-OS-specific (can share between Linux, Windows, etc.)
>- some features may not be supported on non-Windows operating systems
>  
>
you can also add "non-Redhat kernels" to this list...

>+ able to create logical disks that seem like physical disks to the OS
>  
>
and associated with this - less trouble with boot loaders (e.g. booting 
from a degraded array as root fs)

>+ bad sector relocation (on the fly?)
>  
>
Depends on the controller  e.g. 3ware does now, but it didn't used to

>- drives must connect to the controller and all must be same type (e.g. SATA)
>+ disk surface testing done automatically
>+ automatic bad block relocation
>+ parity verification
>+ mirror verification
>  
>
You can add a "maybe" to the last four - all depends on the 
implementation, and if you can't get the management software to run on 
your kernel/distribution, then you may not get any of them (or degraded 
array notification!) without using the RAID controller's BIOS.

Add to this another negative - patchy SMART support (only 3ware supports 
smartd pass-through at the moment, AFAIK) - which is useful if you want 
more granularity than "drive good", or "drive bad", e.g. the ability to 
read serial numbers, firmware versions, drive temperatures, SMART error 
log entries, interface errors, remapped block count, spin-up count, 
power-on hours etc. whilst the OS is up and running.

Tim.

