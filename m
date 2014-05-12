From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: boot fails incrementally starting raid arrays
Date: Sun, 11 May 2014 21:04:25 -0500
Message-ID: <53702C29.9070906@hardwarefreak.com>
References: <536FC1F4.8060802@gmx.at>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <536FC1F4.8060802@gmx.at>
Sender: linux-raid-owner@vger.kernel.org
To: Steven <steven-e@gmx.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/11/2014 1:31 PM, Steven wrote:
> Hello Guy's,
> 
> i recently setuped a small ubuntu 14.4 Server, with 1x SSD Drive (Ubuntu
> installation on it) and 2x 3TB HDD drive, wich i combined to a Raid1
> with mdadm (File Shares are on the Raid).
> 
> now sometimes (arround every 3 time) i reboot, the Server hangs on boot:
> 
> |incrementally starting raid arrays
> mdadm: Create user root not found
> mdadm: create group disk not found
> incrementally started raid arrays|
> 
> these 4 lines keep repeating ( i waited arround 10 mins) if i reboot
> with ctrl + alt + del, the sever starts normal.
> If i look at the raid with  "|mdadm --detail /dev/md0" everything looks ok.
> 
> as i'M just a linux beginer and didn't find anything related to that
> error on the web, im really desperate.
> 
> As far as i figured the problem out, something within the initramfs
> seems to go wrong?
> I allready tried to add these boot options to Grub
> bootdegraded=true
> raid=noautodetect
> 
> didn't help.

You're not booting the OS from the md array, but from a single SSD,
thus nothing about the array is needed in grub nor in the initrd image.
 The array should be started via post-boot scripts.

Cheers,

Stan
