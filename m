From: Phil Turmel <philip@turmel.org>
Subject: Re: Script to save array info
Date: Thu, 21 Jun 2012 09:20:47 +0200
Message-ID: <4FE2CB4F.4080106@turmel.org>
References: <20120620232149.GA7767@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120620232149.GA7767@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/21/2012 01:21 AM, Wakko Warner wrote:
> After reading some of the stories about lost metadata, I was wondering if
> anyone had a script that would output the member info for each device with
> the device's physical serial number.
> 
> For a crude one I did this while in /sys/block:
> for x in sd*;do
> 	echo /dev/$x
> 	/lib/udev/scsi_id --export --page=0x80 --whitelisted /dev/$x
> 	mdadm -E /dev/$x
> done
> 
> And saved the output.  It works for me because all but 3 of my raid members
> are full disks.

You might try "lsdrv"[1].  It reports the entire block storage tree
starting from real devices with serial numbers.  I tuck away a copy any
time I change a server's drive setup.

Phil

[1] http://github.com/pturmel/lsdrv
