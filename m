From: Michael L <michael.lessard@cegonhatech.com>
Subject: Convert none raid to software raid 1
Date: Tue, 18 Mar 2003 07:48:52 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E7715B4.7040408@cegonhatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All !

 I have make all are in the software raid how-to, when i cat 
/proc/mdstat, all my partition is mirroring.
I efs2ck -f my patrtion + resize2fs, all goes good, i modify my root 
device in grub to /dev/md0 ( i have try to with lilo) now when i reboot
i receve i kernel panic, no init foud :(

 Does i need to do anyting special to install my raid root device in 
grub (or lilo)

 Thanks

Michael
http://www.cegonhatech.com



