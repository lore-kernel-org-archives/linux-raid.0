From: Harry Mangalam <hjm@tacgi.com>
Subject: More tales of horror from the linux (HW) raid crypt
Date: Mon, 20 Jun 2005 18:53:11 -0700
Message-ID: <200506201853.11768.hjm@tacgi.com>
References: <5d96567b05061804477325d743@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b05061804477325d743@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

From the traffic, this list seems to be heavily slanted towards the SW aspect 
of Linux RAID, but there have been a few postings (other than mine) about the 
HW aspects of it.  So, apologies for the verbarea on the HW aspects, but at 
least a few people have told me that this running monologue of raid troubles 
has been useful, so herein, some more.  If I'm reiterating what is part of a 
FAQ, please let me know, but I read a lot of them and didn't stumble across 
much of this.


short version:  test ALL your disks before you use them, especially in a RAID 
set, especially the 'recertified' ones.

long version: An FYI for anyone who uses disks in their computers... and 
definitely for those thinking of setting up either software or hardware raids

I refer you to previous posts to this list about the detailed background, but 
it's briefly alluded to at the end of this list - more failures of the HW 
RAID on a dual opteron running ubuntu linux amd64-k8-SMP.

I pulled the 3ware controller and used the onboard Silicon Image controller to 
run diagnostic SMART tests on all the 'recertified' SD-series disks that came 
back from WD.  It's probably possible to use the 3ware controller (someone of 
the linux raid list indicated he did so), but I wanted the 3ware controller 
out of the loop because we suspected it as well.  I used the linux command 
'smartctl -t long /dev/sdx (where x=a-d).  smartctl is part of the 
smartmontools package and can be used to test SATA disks as well as PATA 
disks (altho I've been told that the kernel has to be patched to do this - 
I'm using a Ubuntu-supplied kernel which works out-of-the-box).  The long test 
lasts about 90 minutes for a 250GB disk and can be performed in parallel on 
each disk.

 5 (FIVE!) of them (out of 9 returned from WD) failed that test - either they 
already had logged errors (SMART devices store their last 5 errors to their 
onboard memory), or they failed the short test (~2 minutes) or they failed 
the long test with unrecoverable errors.  They're on their way back to WD for 
other replacements

However, these are a superset of the disks that the 3ware controller failed on 
when being used for an array (see the message below) - I now think that the 
problem is either with the power supply (possible, but unlikely) or the disks 
(definitely), as well as the hotswap cages (definitely).  I'm pretty sure 
that the controller is fine - it's been running with 5 disks in RAID5 for 
several days now with no errors or warnings at all.

That makes me extremely suspicious of WD's 'recertified' drives, but that's 
the only avenue we have to get replacements right now.  And I'll be dang sure 
to test ALL of them before I store data on them.

I do have to reiterate, now that I've been running bonnie++ on both the SW 
RAID5 (on 4 disks - all that the onboard controller would control) and on the 
3ware-controlled RAID5 that the SW is slightly faster and actually seems to 
use about as much CPU time as the 3ware in these tests.  It's also more 
flexible in terms of how you set up and partition the devices.  It's also so 
MUCH cheaper - using the onboard SATA controller and a $20 4 port SATA 
controller, I could control the same number of disks as the 3ware (8) but the 
3ware costs $500.  The big advantage of the 3ware controller is (relative) 
simplicity.  Plug in controller, plug in disks, hit power switch, go into 
3ware BIOS, allocate disks to a RAID unit, boot the OS, make a filesystem on 
the /dev/sdx and mount it.  You can set/get some basic configuration and 
information from the 3ware utilities but not to the extent that you can with 
mdadm and the related utils.


post below is to a 3ware support tech.

> > As a reminder of the system, it's currently
> > - dual opteron IWILL DK8X Mobo, Gb ethernet
> > - Silicon image 4port SATA controller onboard (now disabled),
> > - 3ware 9500S 8 port card running 8x250GB WD 2500SD disks in RAID5.
> > - Disks are in 2x 4slot Chenbro hotswap RAID cages.
> > - running kubuntu Linux in pure 64bit mode (altho bringing up KDE
> >   currently locks the system in some configurations)
> > - using kernel image 2.6.11-1-amd64-k8-smp as a kubuntu debian install
> >     (NOT custom-compiled)
> > - OS is running from a separate WD 200GB IDE disk
> >     (which recently bonked at 3 months old, replaced by WD without
> > complaint.) - on an APC UPS (runnning apcupsd communicating thru a usb
> > cable)
> >
> > The 9500 that you sent to me was put into service as soon as we got
> > enough SD disks to make a raid5 - 3 of them, on ports 0-2, in the 1st
> > hotswap cage.
> >
> > During that time, the array stayed up and seemed to be stable over about
> > 1 week of heavy testing.  Once we got all the disks replace with SD
> > disks, I set it up as 8 disks in a RAID5 and things seemed to be fine for
> > about a day. Then, the disk on port 3 had problems.  I replaced it and
> > again it appeared to go bad.  I then disconnected it from the hotswap
> > cage and connected it directly to the controller.  That seemed to solve
> > that problem, so there definitely is a problem with one hotswap cage -
> > it's being replaced.
> >
> >
> > However after that incident, there have been 3 more with disks on the
> > other hotswap cage, on different ports, one of port 6 (4 warnings of:
> > Sector repair completed: port=6, LBA=0x622CE39, and then the error:
> > Degraded unit detected: unit=0, port=6.  I wasn't sure if it was a
> > seating error or a real disk error, so I pulled the disk and re-seated it
> > (and the controller accepted it fine) but then after it rebuilt the
> > array, it failed again on that port.  OK, I replaced the drive.  Then
> > port 7 reported:(0x04:0x0023): Sector repair completed: port=7,
> > LBA=0x2062320
> >
> > I started a series of copy and read/write tests to make sure the array
> > was stable under load, and then just as the array filled up, it failed
> > again, this time again on port 3: (0x04:0x0002): Degraded unit detected:
> > unit=0, port=3 (this port is connected directly to the controller).
> >
> > And this morning, I saw that yet another drive looks like it has failed
> > or at least is unresponsive:(0x04:0x0009): Drive timeout detected: port=5
> >
> > Discounting the incidents that seem to be related to the bad hotswap
> > cage, that's still 4 disks (with MTBF of 1Mhr) that have gone bad in 2
> > days.
> >
> > I then connected all the disks directly to the controller to remove all
> > hotswap cage influence, and the disk on port 3 almost immediately was
> > marked bad - I have to say that this again sounds like a controller
> > problem.  An amazing statistical convergence of random disk failures?
> > Electrical failure (the system is on a relatively good APC UPS (SMART UPS
> > 1000), so the voltage supply should be good, and no other problems have
> > been seen.  I guess I could throw the Power supply on a scope to see if
> > it's stable, but there have been no other such glitches (unless it's an
> > uneven power supply that is causing the disks to die).
> >
> > Currently most of the disks that were marked bad by the 3ware controller
> > are being tested under the onboard silicon image controller in a raid5
> > config. I'll test over the weekend to see what they do.

At this point I tested the disks using the smartctl, and found out the bad 
ones.  The SW RAID stayed up without errors until I brought it down to 
install the 3ware controller.

-- 
Cheers, Harry
Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
            <<plain text preferred>>
_______________________________________________
List-Info: https://maillists.uci.edu/mailman/listinfo/uci-linux
-- 
Cheers, Harry
Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
            <<plain text preferred>>
