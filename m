From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: Help With RAID Configuration
Date: Tue, 25 Jan 2011 16:18:31 +0100
Message-ID: <4D3EE9C7.8030008@gmail.com>
References: <AANLkTi=_tU68DF+WocBfdzW0chDgivinCeKCJ2D0LVO-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=_tU68DF+WocBfdzW0chDgivinCeKCJ2D0LVO-@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Mennens <carloswill@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dne 25.1.2011 15:53, Carlos Mennens napsal(a):
> I've got 4 identical 1 TB drives and would like to use them in a
> software RAID configuration on my home server. I'm running Debian
> Linux using 'mdadm' utility to manage the software RAID. I don't know
> how much I've read is fact or dated or even false so I decided I would
> ask here to get help from people who know more about this than I do.
> This is essentially just a file server machine to store all my data so
> being that I've got four identical SATA hard drives, I was thinking
> about doing RAID level 5. I guess I'll start here and ask if that is
> the recommended level of RAID. I think RAID level 5 will be fine for
> my general server usage. My second issue is partitioning the four
> individual drives to get maximum performance / space from them.
> Basically just asking here how would you or you recommend I partition
> the drives? I was thinking about doing three seperate partitions per
> drive:
> 
> /dev/sda1 = 4 GB (swap)
> /dev/sda2 = 1 GB (/boot)
> /dev/sda3 = 995 GB (/)
> 
> Now from that partition schema above, obviously all the types will be
> 'fd' for RAID and the partition for /boot is going to be bootable. My
> confusion is that I read Grub doesn't support booting from RAID 5
> since Grub can't handle disk assembly. If /dev/sdx2 (sda2, sdb2, sdc2,
> sdd2) are partitioned for /boot (bootable), how would you guys
> configure this RAID to match up equally? I don't think I do a RAID
> level 1 on 4 identical partitions, right? Can anyone please help and
> tell me how I should configure these 4 identical drives to work on my
> system? How would you set this up?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

You can use RAID1 with 2+ drives without any problems.

sd[a-d]1 /boot (128MB?, RAID1)  - metadata 0.90 for GRUB compatibility
sd[a-d]2 /     (2GB?,   RAID10) - for better system maintenance
sd[a-d]3 swap  (2GB?,   RAID10) - for high availability
sd[a-d]4 /data (REST,   RAID5)

Since you mentioned Debian, wait with new installation for new version
(around february).

HTH, Z.
