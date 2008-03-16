From: Bas van Schaik <bas@tuxes.nl>
Subject: Redundancy check using "echo check > sync_action": error reporting?
Date: Sun, 16 Mar 2008 15:21:11 +0100
Message-ID: <47DD2CD7.2090802@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

As we speak, I'm trying to debug a real weird type of filesystem
corruption in a quite complex layered system with networking involved:

  ATA over Ethernet - RAID5 - LVM - CryptoLoop - EXT3

In plain English: four storage servers export a bunch of block devices
using AoE, the "cluster frontend" uses those devices to build three
RAID5 arrays. Those arrays are the basis of a large LVM volume group, in
which an Logical Volume was created with an encrypted 2.5TB EXT3
filesystem (cryptoloop).

Recently the system suffered massive filesystem corruption, which even
made e2fsck crash. Theodore Tso was able to analyze and fix the
filesystem partially and found out that some random garbage was written
to the EXT3 inode tables, as well some other weird corruptions.
Personally, I'm suspecting one of the storage servers or the network to
have caused these severe corruptions, but I have never seen any errors
on the RAID5 level.

The (Debian) system runs a montly check of the RAID5 arrays using Martin
F. Krafft's checkarray script. Basically this scripts performs a "echo
check > /sys/block/$array/md/sync_action" for all arrays. With my
(basic) knowledge of RAID5 I assume this check only recomputes the sums
and compares them to the stored XOR'ed value. This makes me wonder:

1) Will the kernel actually warn me when an inconsistency is found?
Reading some other posts on the lists, it seems the kernel will print a
"read error corrected!", is that correct? Note that I'm using kernel
2.6.18 (Debian stable), was it already implemented that way in that kernel?

2) How can the RAID code actually correct such a read error on RAID5?
How does it know which device actually contains the faulty data?

The answers to those questions are very important to me: if the kernel
actually warns me when an inconsistency is found, that rules out the
possibility that there is something wrong with the network or one of the
storage servers. Actually that would mean that the "cluster frontend" is
causing the corruptions.

Kind regards,

  -- Bas van Schaik
