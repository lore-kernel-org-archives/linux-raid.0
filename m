From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Tue, 30 Oct 2007 21:37:32 +0100
Message-ID: <20071030213732.04b40e94@absurd>
References: <20071030210721.386ca2fa@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071030210721.386ca2fa@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki said:     (by the date of Tue, 30 Oct 2007 21:07:21 +0100)

> then I did 'dd if=/dev/hda1 of=/dev/md0'. I carefully checked that
> the partition sizes match exactly. So now md0 contains the same thing
> as hda1. 

in fact, to check the size I was using 'fdisk -l' because it gives
size in bytes (not in blocks), like this:

backup:~# fdisk -l /dev/md0

Disk /dev/md0: 1003 MB, 1003356160 bytes

And the same for /dev/hda1

But that's a detail, just so you know that I dd'ed my root partition
correctly and I can mount /dev/md0 without problems.

-- 
Janek Kozicki                                                         |
