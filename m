From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25
 kernel
Date: Wed, 4 Aug 2004 19:51:43 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408041947010.22523-100000@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.3.96.1040804040733.28482A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1040804040733.28482A-100000@Maggie.Linux-Consulting.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 	fdisk.automated.sh | fdisk /dev/hda

no offense, but yuck.  I recently cloned the partitions from one sata onto the other 7:

sfdisk -d /dev/sda > parts
for d in /dev/sd[b-h]; do sfdisk $d < parts; done

regards, mark hahn.

