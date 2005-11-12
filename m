From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: /boot on RAID5 with GRUB
Date: Sat, 12 Nov 2005 09:14:53 +0000
Message-ID: <62b0912f0511120114j20f1964fg8eca07e2cf0d75fc@mail.gmail.com>
References: <437516E8.5080000@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <437516E8.5080000@fastmail.fm>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Spencer Tuttle <rodeojones@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Spencer Tuttle wrote:
> Is it possible to have /boot on /dev/md_d0p1 in a RAID5 configuration
> and boot with GRUB?

Only if you get yourself a PCI card with a RAID BIOS on it and attach
the disks to that.
The RAID BIOS hooks interrupt 13 and allows GRUB (or DOS or LILO for
that matter) to see the RAID5 array instead of the individual disks.

Obviously any RAID card will do, it doesn't matter whether it has a
CPU to do the RAID calculations or not (known as fake-RAID and ataraid
if it doesn't).
