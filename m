From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Wed, 31 Aug 2005 13:28:21 -0600
Message-ID: <1125516500.3194.3.camel@x1-6-00-0d-60-fd-e8-4c>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2005-08-31 at 13:26, David M. Strang wrote:
> Okay, my array is degraded -- and the device /dev/sdm is disabled.
> 
> Short of a reboot, is there a way to re-enable the device? It's already 
> flagged as faulty in mdadm.

Have you tried to remove /dev/sdm from the RAID and add it back in?  I
guess that the larger question is what caused it to be flagged faulty?

Forrest

