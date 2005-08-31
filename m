From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Thu, 01 Sep 2005 01:29:06 +0400
Message-ID: <43162122.703@tls.msk.ru>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH> <4316050B.1060805@tls.msk.ru> <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH> <43160DF2.6000504@tls.msk.ru>  <007401c5ae6a$7e9cd160$c100a8c0@NCNF5131FTH> <1125520778.3194.18.camel@x1-6-00-0d-60-fd-e8-4c> <008b01c5ae6c$e4db5e90$c100a8c0@NCNF5131FTH> <1125521616.3194.22.camel@x1-6-00-0d-60-fd-e8-4c> <00ab01c5ae6f$1bb27410$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00ab01c5ae6f$1bb27410$c100a8c0@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David M. Strang wrote:
[]

> Is there something a little deeper to this error message?
> 
> Aug 31 04:48:15 abyss kernel: scsi2 (12:0): rejecting I/O to offline device
> Aug 31 04:48:15 abyss kernel: raid5: Disk failure on sdm, disabling device.

If you reread my message, I hope you will find a bit of clue:

  echo y > /sys/block/sdm/device/delete
(or something like that anyway.)

That's needed for exactly this purpose: to remove a device which is
marked 'offline' in the kernel somewhere - to be able to re-add it
later - either with this script or just doing that magic add-single-device
command manually.

/mjt
