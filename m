From: Aaron Gee <cluge1669@netscape.net>
Subject: Re: changing MD device
Date: Thu, 15 Jan 2004 14:36:45 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4006EBCD.50907@netscape.net>
References: <4005B847.5090306@netscape.net> <20040114220159.GM26406@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040114220159.GM26406@percy.comedia.it>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the advice, worked like a charm. I'm including the full 
procedure below for those that may need it in the future.

 > bluca@comedia.it wrote:
 > if your rescue disk contains mdadm you can use the
 > mdadm -A -U super-minor /dev/md1 /dev/hd?? once
 > and the array will be started and the minor updated

How to change software raid minor number with RH installs.

1. On your running system get and install mdadm
2. mount a blank floppy, copy /sbin/mdadm to floppy
3. On your running system tar up /dev/md*  (tar -cvf /mnt/floppy/dev.tar 
/dev/md*)
4. Boot from rescue disk - do NOT mount your linux install
5. At sh prompt, switch disks, mount the floppy that contains the tar 
file and mdadm
6. untar the devices (RH rescue disks only create /dev entries for 
arrays that it finds)
you should now have several /dev/md* entries. 
7. Copy mdadm to /sbin annd run it using the command line above
example: mdadm -A -U super-minor /dev/md[new number here] /dev/1stdev 
/dev/2nd /dev/etc
8. cat /proc/mdstat - is the array running and synched now?  Should be.
9. Mount your system useing the new device number where appropriate and 
modify /etc/fstab, /etc/raidtab and /etc/grub.conf to match your new 
raid settings
10.unmount all your system partitions and reboot

cluge

