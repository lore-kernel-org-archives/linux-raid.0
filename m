From: gabe peters <gabe.peters@gmail.com>
Subject: RE: getting a linux boot loader (preferably grub) installed on an
 intel imsm raid
Date: Sat, 21 Aug 2010 00:53:26 -0700
Message-ID: <AANLkTimXLWC5RzNQgJ_M9aY4Lmy30tZOVmWX_pmjzyCJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's my first time using a mailing list in many years, hopefully i've
got this threaded properly. (Intended as a reply to "Jiang, Dave" and
"K. Posern")

I've got an intel MSM RAID0 set up nearly identical to K. Posern, my
differences are that i'm using an older revision controller (lspci
shows revision 02) - the 4 SATA drives are SSDs (though that shouldn't
matter), the imsm container is set up as /dev/md127 and the raid
volume (RAID-0) as /dev/md126. I am able to successfully read and
write from all partitions on the RAID-0 (I set up windows 7 on another
partition prior to attempting to get the linux partition(s) bootable)

Aside from the differences in the partition table, all errors I'm
receiving are the same. Running under Gentoo using the svn -9999
ebuild for grub2 (also tried grub in multiple ways receiving the same
error 22 message)

Incidental to the errors, my motivation to run with this configuration
is to maintain a dual boot with Windows 7 x64 Ultimate. I previously
had an mdadm software raid set up (RAID-1 /boot and RAID-0 /) which I
had no problem booting up with. But ideally i'd like to be able to use
Grub/Grub2 as the bootloader, and load both linux (Gentoo multilib
x86_64) and Windows 7 x64 from the RAID-0.

Any insight will be welcome, I suppose this message amounts to nothing
more than a simple "me, too!" though!
