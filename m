From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: disable raid autodetect at boot
Date: Mon, 23 May 2011 14:35:56 +0400
Message-ID: <4DDA388C.2020000@msgid.tls.msk.ru>
References: <BANLkTim=K8b_3jD5RAdMT6+0TYQXNAHBtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTim=K8b_3jD5RAdMT6+0TYQXNAHBtg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

23.05.2011 13:36, Alexander Lyakas wrote:
> Hello,
> 
> I have a simple raid1 created on top of /dev/sda and /dev/sdb. After I
> reboot, I would like to always manually assemble the raid. However,
> every time the machine reboots, it looks like md tries to
> automatically reassemble the raid, but usually binds only one of the
> source devices:
> 
> 16936	May 23 11:47:36 vc kernel: [    3.472926] md: linear personality
> registered for level -1
..
> 16971	May 23 11:47:36 vc kernel: [    6.059194] md: bind<sdb>

This is not kernel autodetection, this is your initramfs/initrd
and mdadm.  Or maybe mdadm in the regular root filesystem.

/mjt
