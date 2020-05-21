From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: failed disks, mapper, and "Invalid argument"
Date: Thu, 21 May 2020 09:13:13 +0100
Message-ID: <5EC63819.5010508@youngman.org.uk>
References: <20200520200514.GE1415@justpickone.org>
 <5EC5BBEF.7070002@youngman.org.uk> <20200520235347.GF1415@justpickone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200520235347.GF1415@justpickone.org>
Sender: linux-raid-owner@vger.kernel.org
To: David T-G <davidtg-robot@justpickone.org>, Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/05/20 00:53, David T-G wrote:
>   diskfarm:root:13:/mnt/scratch/disks> mdadm --assemble --force /dev/md0 --verbose /dev/sda1 /dev/sdb1 /dev/sdc1
>   mdadm: looking for devices for /dev/md0
>   mdadm: /dev/sda1 is busy - skipping
>   mdadm: /dev/sdb1 is busy - skipping
>   mdadm: /dev/sdc1 is busy - skipping
> 
> like the overlay is keeping me from the raw devices, so I'd have to tear
> down all of that to try the real thing.  I'll h old off on that...

Did you do an mdadm --stop before trying the force assemble? That
implies to me you've got the remnants of a previous attempt lying around...

Not sure which command it is - "cat /proc/mdstat" maybe, but make sure
ALL your arrays are stopped (unless you know they are running okay)
before you try stuff.

Cheers,
Wol
