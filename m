From: Tim Moore <tim.moore@nsr500.net>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Sun, 13 Feb 2005 20:49:06 -0800
Message-ID: <42102DC2.3030004@nsr500.net>
References: <200502031743.j13Hha910546@www.watkins-home.com> <42026860.1000409@zytor.com> <Pine.LNX.4.56.0502031822160.9028@lion.drogon.net> <200502040904.38264.andrew@walrond.org> <Pine.LNX.4.56.0502041031470.29133@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0502041031470.29133@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Gordon Henderson wrote:
> What I wanted was an 8-way RAID-1 for the boot partition (all of /, in
> reality) and I've done this many times in the past on other 2-5 way
> systems without issue. So I do the stuff I've done in the past, and theres
> nothing really new to me in that respect. (I'm using LILO) So when I try
> to get it to boot off the md device, it boots and says LIL and then
> nothing more. (Lilo diagnostics interpret this as a media failure, or
> geometry mismatch) If I make it boot off /dev/sda1 then it would work.

We put /boot on 100MB /dev/sda1 partition, rest of drive is md.  Lilo 
script section does
dd if=/dev/sda of=/boot/boot446.sda bs=446 count=1 && \
fdisk -l /dev/sda > /boot/fdisk.sda && \
dd if=/dev/sda1 of=/dev/sdb1
every time a new kernel is built.  Recovery is much easier without RAID 
involved (lilo 22.6).  I've considered manipulating the boot block/disk 
label on copy so that it would boot off any off sda1 or sdb1 transparently.

> (ie. boot off /dev/sda1, root on /dev/md1, an 8-way RAID-1) I tried many
> combinations of old (Debian woody) & new Lilo (compiled from the latest
> source), I even tried GRUB at one point with no luck either. It was more
> frustrating as the turn-around time is several minutes by the time you go
> through the BIOS to change the boot device, then reboot, change lilo.conf,
> then try again )-:
> 
> It seemed more stable with just one PCI card in, so I have a 4-port card
> on order as a last ditch attempt to make it work - I did try re-flashing
> the BIOS on one board, (I have 2) as it seemed to be about a year old and
> there are several updates on the Tyan web-site, however that resulted in
> wiping out the BIOS - it seemed to be going just fine, then it went beep
> and was silent forever more )-: Anyone in the SW have a flash
> programmer/copier handy???

Flashing from 1.x to 2.02b, same problem.  Power off, pull plug, pull both 
power connectors off mobo, wait 15 seconds, clear CMOS for 15 seconds, 
reboot, reset BIOS, no worries.

> Maybe, or maybe we just move to an Intel system, although power
> dissipation was a consideration and the Opterons are attractive in that
> aspect... The case has a 600W PSU before anyone asks..

Yeech.  Get the 8131's working and you'll never go back.  No Northbridge 
bottlenecks, thank you.
