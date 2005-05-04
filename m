From: Tyler <pml@dtbb.net>
Subject: Re: raid 1 with static kernel.
Date: Wed, 04 May 2005 08:56:21 -0700
Message-ID: <4278F0A5.60406@dtbb.net>
References: <23ADBF4236843B469BE57F05F135897602E744DB@srvntexc2.swfr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23ADBF4236843B469BE57F05F135897602E744DB@srvntexc2.swfr>
Sender: linux-raid-owner@vger.kernel.org
To: Glatzel Tino <tino.glatzel@badenIT.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Try this howto:

http://www.linuxsa.org.au/mailing-list/2003-07/1270.html

Regards,
Tyler.

Glatzel Tino wrote:

>hello list,
>
>
>my system is a Debian GNU Linux Sarge. The kernelversion is 2.6.10 without
>modulsupport.
>The partion id is  fd.
>In the first step, the complete system is installed on /dev/hda3.
>In the second step, i have created a raid 1 device:
>mdadm --create /dev/md0 --level 1 --raid-device=2 /dev/hda1 /dev/hdc1
>mkfs -t ext3 /dev/md0
>mount /dev/md0 /mnt
>cp -pr /boot /mnt
>umount /mnt
>
>I want to mount /dev/md0 in /boot
>change in the /etc/fstab
>/dev/md0       /boot   ext3    defaults    0      2
>
>
>
>after a reboot, i see the mounted devices:
>
>/dev/hda3 on / type ext3 (rw,errors=remount-ro)
>/dev/md0 on /boot type ext3 (rw)
>
>so, i think i will never need the files in the old /boot directory.
>
>umount /boot
>cd /boot
>ls
>System.map-2.6.8-1-386
>config-2.6.8-1-386      vmlinuz-2.6.10
>grub                    vmlinuz-2.6.10-raid-grsec
>initrd.img-2.6.8-1-386  vmlinuz-2.6.10-raid-grsec-hotplug
>lost+found              vmlinuz-2.6.8-1-386
>System.map-2.6.10
>
>
>
>rm -r *
>cd ..
>mount /boot
>ls /boot
>System.map-2.6.8-1-386
>config-2.6.8-1-386      vmlinuz-2.6.10
>grub                    vmlinuz-2.6.10-raid-grsec
>initrd.img-2.6.8-1-386  vmlinuz-2.6.10-raid-grsec-hotplug
>lost+found              vmlinuz-2.6.8-1-386
>System.map-2.6.10
>
>
>after a reboot, i see the following message from Grub:
>
>GRUB Loading Stage1.5
>
>GRUB loading, please wait ...
>Error 15
>
>
>Ok, i think GRUB can`t access to /dev/md0
>what can i do?
>
>
>Tino
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

