From: Anssi Hannula <anssi.hannula@gmail.com>
Subject: Re: Recovery speed at 1MB/s/device, unable to change
Date: Mon, 24 Apr 2006 00:37:48 +0300
Message-ID: <444BF3AC.4090804@gmail.com>
References: <444BD3E7.4090601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <444BD3E7.4090601@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Anssi Hannula wrote:
> The speed is only 2000K/sec, even after I set:
> ---
> # cat /proc/sys/dev/raid/speed_limit_min
> 10000
> # cat /proc/sys/dev/raid/speed_limit_max
> 400000
> ---
> 
> The system is about 90% idle, so there should be more bandwidth.
> 
> ---
> # cat /proc/version
> Linux version 2.6.17-rc2-git4 (anssi@delta.onse.fi) (gcc version 4.0.1
> (4.0.1-5mdk for Mandriva Linux release 2006.0)) #1 Sun Apr 23 00:56:30
> EEST 2006
> ---

Hmm... I don't know if this is related, but something seems to be really
wrong.

I run the following set of commands:

# dd if=/dev/zero of=ohase count=5K
# dd if=/dev/zero of=ohase2 count=5K
# losetup /dev/loop0 ohase
# losetup /dev/loop1 ohase2
# mdadm --create /dev/md_d1 -ap --level=5 --raid-devices=2 /dev/loop0
missing
# fdisk /dev/md_d1
(created one partition)
# mkfs.ext3 /dev/md_d1p1
# mount /dev/md_d1p1 /mnt/test
# echo jopajoo > /mnt/iso/test
# mdadm --manage /dev/md_d1 --add /dev/loop1
# mdadm --grow /dev/md_d1 --raid-devices=3 --backup-file backupfile
mdadm: Need to backup 128K of critical section..
mdadm: /dev/md_d1: Cannot get array details from sysfs

Strace shows that it's trying to access
"/sys/block/md_d4/md/component_size".

Why is this?

-- 
Anssi Hannula

