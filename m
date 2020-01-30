From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Is it possible to break one full RAID-1 to two degraded RAID-1?
Date: Thu, 30 Jan 2020 07:27:25 +0000
Message-ID: <5E32855D.3020906@youngman.org.uk>
References: <1120831b-13e6-6a5d-8908-ee6a312e7302@gmail.com>
 <aa41492c-1ad7-070f-9bc6-646977364758@thelounge.net>
 <2c4fedff-a1c9-6ca3-5385-72b542a4a0b4@gmail.com>
 <551449ed-49f9-e567-09d3-981f4cf9eea9@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <551449ed-49f9-e567-09d3-981f4cf9eea9@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/01/20 06:30, Reindl Harald wrote:
>> Thanks. I thought of this, but both disk in question are nvme ssd with
>> > manually added heat sink. It will be a hassle to remove and reinstall. I
>> > think I will go with the back up rather than remove disk physically. 

> why would you remove it phyiscally to remove it rom the array? seriously?

Because if you physically remove it, BOTH disks will think they are the
surviving copy. You could "assemble" either disk on its own and recover
the array.

But if you remove a disk with --fail --remove, does that tamper with the
superblock? Would that prevent that disk being re-assembled on its own?
Seriously. I don't know. And were I in the OP's shoes I would be asking
the same question.

This is where you want something COW in the stack. Lvm. Btrfs. Where you
can just take a snapshot, upgrade the system, and if it all goes
pear-shaped you throw the snapshot away.

Cheers,
Wol
