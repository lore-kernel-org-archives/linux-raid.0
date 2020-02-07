From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Is it possible to break one full RAID-1 to two degraded RAID-1?
Date: Fri, 7 Feb 2020 01:02:24 -0600
Message-ID: <0c70c04f-d8d0-0c44-e603-46c101b21cc1@gmail.com>
References: <1120831b-13e6-6a5d-8908-ee6a312e7302@gmail.com>
 <aa41492c-1ad7-070f-9bc6-646977364758@thelounge.net>
 <2c4fedff-a1c9-6ca3-5385-72b542a4a0b4@gmail.com>
 <551449ed-49f9-e567-09d3-981f4cf9eea9@thelounge.net>
 <5E32855D.3020906@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E32855D.3020906@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I got no response on this and want to take a shot before going the 
backup way.

Assuming (hda1 and hdb1 in raid1 md0) Will the following work?

 1. Fail and remove hdb1
 2. Create new RAID1 md1 with hdb1 and missing
 3. dd md0 onto md1
 4. Make both bootable. (I suppose I need to change UUID of md1
    partitions. I suppose that is easy)
 5. Boot both and double check
 6. Now upgrade md0 without fear.
 7. Boot and test the new system for a couple of days to make sure
    everything is fine.
 8. If that fails, delete md0, and add hda1 to md1. If not delete md1
    and add hdb1 to md0

Regards
Ramesh

On 1/30/20 1:27 AM, Wols Lists wrote:
> On 30/01/20 06:30, Reindl Harald wrote:
>>> Thanks. I thought of this, but both disk in question are nvme ssd with
>>>> manually added heat sink. It will be a hassle to remove and reinstall. I
>>>> think I will go with the back up rather than remove disk physically.
>> why would you remove it phyiscally to remove it rom the array? seriously?
> Because if you physically remove it, BOTH disks will think they are the
> surviving copy. You could "assemble" either disk on its own and recover
> the array.
>
> But if you remove a disk with --fail --remove, does that tamper with the
> superblock? Would that prevent that disk being re-assembled on its own?
> Seriously. I don't know. And were I in the OP's shoes I would be asking
> the same question.
>
> This is where you want something COW in the stack. Lvm. Btrfs. Where you
> can just take a snapshot, upgrade the system, and if it all goes
> pear-shaped you throw the snapshot away.
>
> Cheers,
> Wol
