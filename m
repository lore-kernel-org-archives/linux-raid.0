From: Danilo Godec <danci@agenda.si>
Subject: Re: some question in SoftRaid
Date: Fri, 24 May 2002 08:21:33 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0205240801200.24719-100000@duplo.agenda.si>
References: <OFFD9E56CF.EF1F1E2A-ON48256BC3.000D7788@legend.com.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OFFD9E56CF.EF1F1E2A-ON48256BC3.000D7788@legend.com.cn>
To: lilha@legend.com.cn
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 24 May 2002 lilha@legend.com.cn wrote:

> but how to use raidhotremove combination or the new mdadm?
> i try it:
> #raidstop /dev/md3
> #raidhotremove /dev/md3
> No target disk specified!

If you want the array completely removed, you don't need to use the
'raidhotremove' command. This is intended for removing a block device from
the array.

And you don't have to stop the array. You can remove the disk from an
active array. For example, assuming that it is /dev/hda3 you want to
remove:

# raidsetfaulty /dev/md3 /dev/hda3
# raidhotremove /deV/md3 /dev/hda3

For completely removing the array you should just stop it (raidstop
/dev/md3) and change the partition types from 0xfd, so the kernel won't
autodetect them at next boot. Otherwise, after issuing the raidstop, the
array is stopped and the partitions should be usable.

> is there any doc about how to remove raid?

I think the RAID-HOWTO pretty much covers it.

http://unthought.net/Software-RAID.HOWTO/

> and what is the new mdadm?

mdadm is a new utility for managing Linux SW RAID. You should check the
archive of this list for more about it.

   D.


