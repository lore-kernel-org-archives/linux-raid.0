From: Chris Murphy <lists@colorremedies.com>
Subject: Re: grub and mdadm
Date: Sun, 9 Mar 2014 21:01:38 -0600
Message-ID: <AE60B6C3-B0BD-45C7-93EB-8E3C50D4300C@colorremedies.com>
References: <531D0637.4080009@shaw.ca>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <531D0637.4080009@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mar 9, 2014, at 6:24 PM, AdsGroup <AdsGroup@shaw.ca> wrote:

> In the past I have used whole drives (<2TB) as block devices for mdadm raid and a separate single drive for grub, boot, swap, root and home with no problem. I now want to upgrade (non-UEFI bios machine) to multiple 3TB drives thinking 3 active in Raid 5 with 1 spare again using the full drives as block devices and installing Lubuntu 12.10 LTS alternate for server/command line.
> 
> Using Lubuntu 13.10 desktop live (therefore recent mdadm, gparted, parted, etc) I've created and easily assembled/started the mdadm array /dev/md0 from sd[a-c], sdd as spare. I then partition /dev/md0 on MIB boundaries the following in order 1MB free space, 2MB bios-grub, 200MB boot, 10GB swap, remainder root (5.6 TB?) with 1MB trailing free space.

The disks should be partitioned first, so that each disk has a completely whole BIOS boot, with a complete GRUB core.img. The only reason why this worked is probably a bit of luck that grub-install of core.img put it in a single chunk that just so happened to be on the same disk with the initial bootsstrap code. But this setup isn't bootable degraded, like it could be if the layout were minimally partitioned first so that BIOS boot is outside of the array.

> 
> Then rebooting to 12.10 alternate for install I have difficulties installing grub anywhere. Even fails using boot-repair (link below) Any ideas?


Just use the newer 13.10 GRUB, you don't need a 2nd instance to boot the older distribution. Just write a forwarding entry in the 13.10 grub.cfg, via /etc/grub.d/custom_40, using the configfile command pointing to the 12.10 grub.cfg. 


Chris Murphy