From: Daniele Madama <d.madama@gmail.com>
Subject: Re: Delivery Status Notification (Failure)
Date: Thu, 27 May 2010 14:10:16 +0200
Message-ID: <AANLkTin2vW2UImQx6qrrvZboxeHShPCM56P6QkoUjRi1@mail.gmail.com>
References: <AANLkTilb4hhy3BYp6OvpyGAe7vCQQjaPEmi12NxDdP9i@mail.gmail.com>
	<001485f795f4535fdd048790ecd6@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001485f795f4535fdd048790ecd6@google.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
sorry if the question is already posted, but I googled a lot without succes.
I'm in the following scenario:
I have a CentOS 5.5 server with a single HD installation, I'd like to add a
second disk and put them in a RAID 1. I followed two guide [1] [2] but when
I reboot the system I get a error [3] that tell me

....
Waiting for driver initialization.
Scanning and configuring dmraid supported devices
Creating root device.
Mounting root filesystem.
mount: could not find filesystem '/dev/root'
Setting up other filesystems.
Setting up new root fs
setuproot: moving /dev failed: No such file or directory
no fstab.sys, mounting internal defaults
setuproot: error mounting /proc: No such file or directory
setuproot: error mounting /sys: No such file or directory
Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
switchroot: mount failed: No such file or directory
Kernel panic - not syncing: Attempted to kill init!

Can you give me a hint to proceed?

TIA,
Daniele


[1] http://www.howtoforge.org/how-to-set-up-software-raid1-on-a-running-system-incl-grub-configuration-centos-5.3
[2] http://www.geroleo.com/?p=524
[3] http://www.danysoft.org/img/raid-error.jpg

--
The box said "Requires Windows XP or better" .... so I
installed Linux !
-o=|=o-

Daniele Madama

http://www.danysoft.org
