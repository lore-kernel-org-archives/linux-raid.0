From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: fd filesystem and RAID1
Date: Mon, 05 Apr 2004 10:58:54 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87oeq7me9d.fsf@enki.rimspace.net>
References: <1080948756.999.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03 Apr 2004, Ninti Systems wrote:
> I've been able to do everything involved in setting up a simple RAID1
> with 2 IDE disks on Slackware 9.1 except get it to actually keep
> working on reboot.
> 
> I installed on one disk, built 'degraded' RAID1 devices on the second
> disk, copied data, etc. I can hot add devices from the original disk
> to the RAID arrays. RAID devices in /etc/fstab come up (in degraded
> mode) on boot.
> 
> The problem is that hot-added devices never stick, the RAID arrays are
> always degraded again on reboot. 
> 
> mdadm complains of missing superblocks. I have read the man page but
> can't see how to manage superblocks (create/delete) if this is even
> possible.
> 
> I'm wondering if have to make the original install partitions type
> 'fd' as well as those on the second disk?

The kernel auto-discovery will only probe a partition that has type
'fd', so if you want both parts of the mirror to work, both need to be
type 'fd'.

     Daniel

-- 
Democracy is ever eager for rapid progress, and the only
progress which can be rapid is progress made down hill.
        -- Sir James Jeans

