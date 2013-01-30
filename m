From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Persistent failures with simple md setup
Date: Wed, 30 Jan 2013 10:07:24 +0100
Message-ID: <5108E2CC.4010806@profitbricks.com>
References: <1565063.1kpR7lz4Ph@xrated>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1565063.1kpR7lz4Ph@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 29.01.2013 23:14, Hans-Peter Jansen wrote:
[...]
> ~# cat /proc/mdstat
> Personalities : [raid1] [raid0] [raid10] [raid6] [raid5] [raid4] 
> md3 : active raid1 sda4[0]
>       869702736 blocks super 1.0 [2/1] [U_]
>       bitmap: 57/415 pages [228KB], 1024KB chunk
> 
> md0 : active raid1 sda1[0]
>       96376 blocks super 1.0 [2/1] [U_]
>       bitmap: 1/6 pages [4KB], 8KB chunk
> 
> md1 : active (auto-read-only) raid1 sdb2[1] sda2[0]
>       2096468 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/8 pages [0KB], 128KB chunk
> 
> md124 : active raid1 sdb3[1] sda3[0]
>       104856180 blocks super 1.0 [2/2] [UU]
>       bitmap: 8/200 pages [32KB], 256KB chunk
> 
> This looks like some kind of race during device detection.
> The full boot sequence log leading to this mess is attached. 

[...]

> Could some kind soul tell me, what's going on here?

Funny, we've observed similar strange behavior when putting MD devices
on iSCSI/SRP exports. We connect to the SCSI target and udev does lots
of crap assembling only 1/2 or even 0/2 devices. This is why we disable
all udev rules related to MD and do it by custom scripts.

In mdadm 3.2.6 a possible fix has been introduced.

Check: git log mdadm-3.2.5..mdadm-3.2.6


commit 090900c3d2eb5b3aef5251a21228483c32246cc7
Author: Harald Hoyer <harald@redhat.com>
Date:   Mon Aug 13 08:00:21 2012 +1000

    udev-rules: prevent systemd from mount devices before they are ready.

commit b7e05d2373313dd8d0cb687479ad58a88f37d29f
Author: NeilBrown <neilb@suse.de>
Date:   Thu May 24 11:49:49 2012 +1000

    udev-rules: prevent systemd from mount devices before they are ready.


Does mdadm 3.2.6 solve this?

Cheers,
Sebastian

