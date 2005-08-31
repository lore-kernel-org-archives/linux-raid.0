From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Thu, 01 Sep 2005 00:07:14 +0400
Message-ID: <43160DF2.6000504@tls.msk.ru>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH> <4316050B.1060805@tls.msk.ru> <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David M. Strang wrote:
> mdadm --remove /dev/md0 /dev/sdm
> mdadm: hot removed /dev/sdm
> mdadm --add /dev/md0 /dev/sdm
> mdadm: Cannot open /dev/sdm: No such device or address
> 
> The device is disabled at a 'hardware?' level -- I can't even cfdisk 
> /dev/sdm

Please don't top-post.

Well, you didn't mention that it's disappeared from the system
(as opposed to the raid array only).  And no, I for one don't
know how to re-add it - there are numerous reasons why it may
had disappeared, and it may be of different kinds of drive too
(like, SCSI or SATA).  Some cases can be handled (like, sending
"bus reset" and "start unit" commands followed by bus rescan
sometimes helps).  But it's safer to just reboot anyway (cold
reboot, with power off).

/mjt
