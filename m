From: jlcenter@comcast.net
Subject: Install grub2 to /dev/md126 fails
Date: Sat, 31 Dec 2011 03:59:13 +0000 (UTC)
Message-ID: <760811954.244872.1325303953552.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've been trying to install Ubuntu 11.10 on a mdadm imsm raid1 array, but it fails installing grub.  I had to chroot /target to install mdadm from the distribution.  I've also upgraded to the latest version of mdadm, hoping this would fix the problem.  This is the error I'm getting:

root@ubuntu:/# grub-install --recheck /dev/md/V1
/usr/sbin/grub-probe: error: no such disk.
Auto-detection of a filesystem of /dev/md126p3 failed.
Try with --recheck.
If the problem persists please report this together with the output of "/usr/sbin/grub-probe --device-map="/boot/grub/device.map" --target=fs -v /boot/grub" to <bug-grub@gnu.org>

Here's how mdadm sees my config:

root@ubuntu:/dev# mdadm --examine --scan
ARRAY metadata=imsm UUID=92ae2913:95d651ca:62154f33:7069b04c
ARRAY /dev/md/V1 container=92ae2913:95d651ca:62154f33:7069b04c member=0 UUID=71b12777:c6a51a84:5b0f1d11:0bd6e497

I also tried with several variations of /dev/md126, etc., but always with the same result.  I also tried to install directly to one of the disks in the array, but this didn't work, either.  When I ran grub-probe, I got the following error:

/usr/sbin/grub-probe: info: opening mduuid/71b12777c6a51a845b0f1d110bd6e497,3.
/usr/sbin/grub-probe: error: no such disk.

What could be causing this problem?  How do I fix it?  Please let me know if I need to supply more information to troubleshoot this problem.

Thanks.

    -John
