From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Wed, 31 Aug 2005 15:41:08 -0400
Message-ID: <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH> <4316050B.1060805@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm --remove /dev/md0 /dev/sdm
mdadm: hot removed /dev/sdm
mdadm --add /dev/md0 /dev/sdm
mdadm: Cannot open /dev/sdm: No such device or address

The device is disabled at a 'hardware?' level -- I can't even cfdisk 
/dev/sdm

----- Original Message ----- 
From: Michael Tokarev
To: David M. Strang
Cc: linux-raid@vger.kernel.org
Sent: Wednesday, August 31, 2005 3:29 PM
Subject: Re: raid5: Disk failure on sdm, disabling device


David M. Strang wrote:
> Okay, my array is degraded -- and the device /dev/sdm is disabled.
>
> Short of a reboot, is there a way to re-enable the device? It's already 
> flagged as faulty in mdadm.

man mdadm
mdadm --remove /dev/mdN /dev/sdm
mdadm --add    /dev/mdN /dev/sdm

/mjt 

