From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25 kernel
Date: Wed, 4 Aug 2004 04:12:28 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1040804040733.28482A-100000@Maggie.Linux-Consulting.com>
References: <200408041129.44767.m.watts@eris.qinetiq.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408041129.44767.m.watts@eris.qinetiq.com>
To: Mark Watts <m.watts@eris.qinetiq.com>
Cc: linux-raid@vger.kernel.org, Robin Bowes <robin-lists@robinbowes.com>
List-Id: linux-raid.ids



On Wed, 4 Aug 2004, Mark Watts wrote:

> Talking of partitioning several disks the same, is there an easy way to 
> automate this?

# imagine the sequence of the characters you type to fdisk
echo n
echo p
echo 1
echo 1
echo +256M
.....

and run that script for each new unpartitioned/virgin /dev/hda disk ..

	fdisk.automated.sh | fdisk /dev/hda

sample partition script:
	http://linux-consulting.com/Boot/Linux-1U/clone.suse-8.2.fdisk.sh1

sample cloning script:
	... tar ... onto target disk

	http://linux-consulting.com/Boot/Linux-1U/clone.suse-8.2.sh

works good when you're doing 10's, 100's of identical disks ... or 
same partition scheme ...

c ya
alvin


