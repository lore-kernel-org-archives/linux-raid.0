From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Fw: DriveReady SeekComplete problems
Date: Sun, 12 May 2002 10:27:39 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0205121022520.2333-100000@uplift.swm.pp.se>
References: <001701c1f79e$50349000$c264a8c0@hoytpub.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001701c1f79e$50349000$c264a8c0@hoytpub.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 9 May 2002, Artur Jasowicz wrote:

> I am building a file server with 5 drive software RAID5 array. I am
> using three IWill SIDE-100 (Highpoint 370A) controllers as my IDE
> interfaces, not using their RAID functionality. One Maxtor 160GB drive
> per channel, two channels per controller. I plan on adding hot spare as
> the sixth drive in the future. There's one 160GB partition on each
> drive. Linux version 2.4.19-pre7smp-020502b (root@production) (gcc
> version 2.96 20000731 (Red Hat Linux 7.1 2.96-98)) #6 SMP Thu May 2
> 12:15:34 CDT 2002 This is a dual Athlon 2000+ MP on Tyan Tiger S2466N-4
> with 1GB RAM. OS and swap runs on separate drives and controllers. This
> array will be just for data once it is configured.

I get the exact same errors you get with my VP-6 SMP board when using its 
onboard HPT370 controller.

cat /proc/interrupts 
           CPU0       CPU1       
  0:    6197040    6197246    IO-APIC-edge  timer
  1:        440        380    IO-APIC-edge  keyboard
  2:          0          0          XT-PIC  cascade
  8:          0          1    IO-APIC-edge  rtc
 14:      63320      61241    IO-APIC-edge  ide0
 15:    3548204    3537369    IO-APIC-edge  ide1
 16:     429475     430742   IO-APIC-level  aic7xxx
 18:    4602335    4601175   IO-APIC-level  ide2, ide3, aic7xxx
 19:   30045123   30046213   IO-APIC-level  eth0

My theory is that it's the interrupt sharing that is causing some of the 
problems, or some kind of DMA channel mixup. I have no problem with any of 
the other drives connected to the primary IDE controller (ide0 and ide1).

Anyone know if I can force the kernel to not share interrupts.

I am using the Red Hat supplied 2.4.18 kernel that comes with redhat 7.3. 
When I used the 2.4.9-31 kernel with redhat 7.2 before I got no errors but 
instead data corruption on the ide2 and ide3 drives (which are two 120 gig 
maxtors in a raid0 config). This could be due to a faulty cable though, I 
swapped that one too.

Currently I have stability problems with the box, if I use the ide2 and 
ide3 drives a lot the machine freezes.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

