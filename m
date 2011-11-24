From: Dominique <dcouot@hotmail.com>
Subject: Ubuntu mdadm Raid and EFI
Date: Thu, 24 Nov 2011 15:09:23 +0100
Message-ID: <BLU0-SMTP47112CA111EE95226BAE366C9CE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

After testing mdadm on virtual machines, I bought new hardware, as I 
thought I was ready... Well think again.

My HW setup is as follow:
Asus MB P8H67-I (with a Corei5 CPU)
8 GB Memory
6 x 3 TB WD HDD (AHCI mode in the BIOS)
OS: Ubuntu 11.04 x64 Server

My intended SW setup  is as follow:
md1 /boot on RAID1 6 HDD (250 MB x6)
md2 /swap on RAID1 6 HDD (32 GB x6)
md3 / on RAID5 6 HDD (3 TB x6)

First thing first, I followed the usual setup process, with one 
surprise, the boot flag did not hold in the md1 setup. Not a show 
stopper at this step.
When trying to write the GRUB2 information I got stuck with the 
impossility to write the information.
Obviously I could not boot from the HDD after restart.

I then realized that this MB uses a BIOS EFI.
Since that's pretty new stuff for the PC world (not on the MAC side 
though), I am wondering how to mix EFI with RAID... ?

Any help will be more than welcome.

Dominique
