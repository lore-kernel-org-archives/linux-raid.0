From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Wed, 31 Aug 2005 23:29:15 +0400
Message-ID: <4316050B.1060805@tls.msk.ru>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David M. Strang wrote:
> Okay, my array is degraded -- and the device /dev/sdm is disabled.
> 
> Short of a reboot, is there a way to re-enable the device? It's already 
> flagged as faulty in mdadm.

man mdadm
mdadm --remove /dev/mdN /dev/sdm
mdadm --add    /dev/mdN /dev/sdm

/mjt
