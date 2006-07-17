From: "whc86 (sent by Nabble.com)" <lists@nabble.com>
Subject: troubleshooting PNY S-cure
Date: Mon, 17 Jul 2006 12:49:52 -0700 (PDT)
Message-ID: <5367261.post@talk.nabble.com>
Reply-To: whc86 <willconstable@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am setting up a mythtv backend server on fedora 5 using 5x Seagate 300gb
drives and PNY S-cure Raid 3.  the bulk of the 1.2 TB is a jfs partition
while there is a 100 mb /boot partition in ext2 also.  the OS runs from /
partition and /swap partition on a WD raptor on a different controller.

My raid array keeps losing drives.  Its usually drive 3 but sometiems drive
4, but they usually rebuild and then thigns are reported as 'all is well'
again.  No interruption to functionality during these drive failures for the
past 2 weeks (added the raid and drives to my comptuer 2 weeks ago)

Yesterday, i think drives 3 and 4 failed together-- after a reboot pny bios
said 3 and 4 not attached-- after anotehr reboot, it 'array rebuilding',
showing drive 3 as failed but 4 as fine.  However, unlike the past failures,
this time i only get to a grub> prompt and dont know how to/if i can boot
the system

I have rma'd the card and two drives, but am curious about other reasons
this might be failing.  How much power should i need?  at first, all ran
from a single 400w fanless psu.  

Athlon 2600, Asus A7v8x, gig of DDR333, raptor 74, 5x Seagate 7200 Sata, 2
optical drives, 2 PCI cards plus raid card

after first failure, took 400 w psu from the closet and shorted the 'on'
lead to the ground so it would run, then tied the ground from the closet psu
to the psu in my system.  I put all hard drives on the closet psu and
resumed using the system.  Things seemed to work better for a while but i
had another couple harmless failures and then the major one...

any help would be great!
thanks,
will
-- 
View this message in context: http://www.nabble.com/troubleshooting-PNY-S-cure-tf1956814.html#a5367261
Sent from the linux-raid forum at Nabble.com.

