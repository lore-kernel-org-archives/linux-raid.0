From: Tom Walsh <tom@openhardware.net>
Subject: array always resyncs on boot
Date: Sat, 29 Nov 2008 16:23:17 -0500
Message-ID: <4931B2C5.5060403@openhardware.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

<sigh> I need help!

It  is not like I haven't build a raid array before, I've got three
systems using a mix of raid1 and raid5 that have been running for
about two years.  Those systems are okay.  It is problems that
developed with this fourth system.

This system was constructed about 10 months ago using six 320G drives
(4 Seagage ST3320620AS and 2 Western Digital WD3200AAKS-0).  The
system ran fine until two months ago when I had to shutdown the system
for a few weeks.  When I powered up the system, it declared that the
raid5 array needed to undergo a resync.  Subsequent reboots of that
system persistently resulted in a resync!

In the past few weeks of chasing the problem down, I have replaced
*EVERYTHING*!  RAM, Motheboard, cables, Q6600 CPU, power supply,
switched from PCI-16e video card to a PCI video, removed all non-
essential cards and USB devices.  The only thing that has not been
changed in this system is the CPU fan.  And still, the raid array
insists upon resyncing.

I've overhauled the software, replaced the operating system
innumerable times with several Mandriva distros: 2008, 2008.1, 2009.
Removed the Mandriva kernel and compiled a stock 2.6.27.7 from
ftp.kernel.org.  Ran the Seagate SeaTools on all four drives, no
errors.  Ran the Western Digital Date Lifeguard on the two drives, no
errors.  Changed from raid5 to raid10, still resyncs on boot.

What am I doing wrong!?

mdadm --create /dev/md0 --level=10 --raid-devices=6 /dev/sd[a-f]5
mke2fs -j /dev/md0
mdadm -Eb /dev/sda5 >> /etc/mdadm
# edit mdadm.conf
blkid /dev/md0 >> /etc/fstab
# edit fstab

I just cannot keep the system from resyncing on every boot.  I've
gotten to the point that I'm thinking that I may have been root'ed and
the boot flash of the drives has been reflashed...  Ok, that is
reaching for an answer, I know.  This is time to ask for help.  help!

-- 
Tom Walsh - WN3L - Embedded Systems Consultant
http://openhardware.net http://cyberiansoftware.com http://openzipit.org
"Windows? No thanks, I have work to do..."
----------------------------------------------------

