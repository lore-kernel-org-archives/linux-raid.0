From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: Mount Linux Raid Array on new install
Date: Fri, 16 Dec 2011 14:47:34 +0100
Message-ID: <4EEB4BF6.7030300@redhat.com>
References: <4EE7BA4B.7070709@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EE7BA4B.7070709@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/13/11 21:49, Jonathan Tripathy wrote:
> Hi Everyone,
> 
> I've got a pretty basic question and I hope someone can help me.
> 
> Currently, I have a server with 4 spindles. The 4 spindles (sda, sdb,
> sdc and sdd) have the follow MD RAID arrays on them:
> 
> RAID1 (all 4 disks) for host OS (/)
> RAID1 (all 4 disks) for swap
> RAID1 (all 4 disks) for /boot
> RAID10 (all 4 disks) for LVM
> 
> I wish to move my host OS onto a USB flash disk, and use my metal
> spindles solely for the RAID10 LVM. Assuming I install a fresh copy of
> CentOS onto a USB stick, how would I go about re-mounting the RAID10
> array, without destroying any data? Obviously, I don't care about the
> swap or boot partitions. Also, the old host OS on the spindles would be
> handy to keep, however it wouldn't be the end of the world if I lost
> this. The important issue is to keep the data from the LVM array.
> 
> Any advice is appreciated

I would expect the new system to automatically detect the RAID devices,
and they should just show up in /dev/mapper etc.

That said, I wouldn't run my system off a USB flash drive, except for
basic testing. Those USB sticks aren't the most reliable things on the
planet. If you have a spare SATA slot in the system, you could purchase
a small cheat SSD drive and install your root system on that - that is
how I run my personal home server. OS on the SSD, real data on spindles.

You can get a 60-64GB SSD for about UKP 75 and a 30GB one for around UKP 50.

If you want to be sure nothing goes wrong, you can disconnect all the
RAID drives during installation, and reconnect them afterwards.
Otherwise you should just be careful to triple check that the installer
of whichever distro you are using is not touching those drives.

Cheers,
Jes
