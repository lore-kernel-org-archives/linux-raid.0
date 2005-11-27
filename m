From: Trevor Cordes <trevor@tecnopolis.ca>
Subject: DeviceDisappeared events on reboot
Date: Sun, 27 Nov 2005 08:39:19 -0600
Message-ID: <20051127143919.GA6160@pog.tecnopolis.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I setup a 2TB 10 disk RAID 6 IDE array.  Works great.  But when I reboot, 
mdadm emails me about a "DeviceDisappeared /dev/md3 Wrong-Level" event.  I 
can't find anything in the /var/log/messages related to this.

The RAID 6 array is brought up manually on boot from the standard FC3 
mdadm -A -s call in /etc/rc.sysinit.  My mdadm.conf looks like:

DEVICE partitions
ARRAY /dev/md3 UUID=dda56415:b7c1cb8e:bf0a1553:5cc3ad55

I also use separate RAID1 arrays for boot, root and swap.  Those arrays 
are on 2 bigger disks shared with the RAID 6 array.

I can't tell if the system is emailing me when it's shutting down or when 
it's coming back up, but I believe based on the time of the email it's the 
latter.

Should I be worried about this DeviceDisappeared error?  Everything seems 
ok.  What does it mean?  How do I fix it?

Thanks!
