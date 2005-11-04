From: Peter Lauda <plauda@rx30.com>
Subject: still a boot issue
Date: 04 Nov 2005 11:59:57 -0500
Message-ID: <1131123603.4595.11.camel@plauda5.rx30.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have been making some progress with my attempted raid1 of boot and
root... but I just can't get it to boot. I have looked at several docs
and tried umpteen times to tweak based on suggestions and documentation.
So if there is any other advice out there.. please... I am near the end
of my rope.

I have a system with two sata drives and a 2.4.29 kernel w/mdadm and the
md driver in the kernel. I see the raid personalities in /proc/mdstat
when the system boots.

I have added a kernel parm md=1,/dev/sda3,/dev/sdb3  to my grub.conf
line. 

When I boot the system it fails to setup the array md1 because it cannot
read the superblock for the array. Is this because the /dev/sda3 fs is
already loading or mounted?  

An entry in /var/log/messages tells me:

md: could not lock [08:03] zero size?


What else should I look for?  I may be forced to give up on software
raid completely if I cannot solve this mystery. That will mean the
windows grunts here will have more ammo to insist on a change to windows
platforms for our servers....  grumble!

hoping against hope for input.

cheers...

--p



