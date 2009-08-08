From: "NeilBrown" <neilb@suse.de>
Subject: Re: raid10 problem with spare disk
Date: Sun, 9 Aug 2009 07:17:50 +1000 (EST)
Message-ID: <20b671d0bba986ff7c119757440a8c26.squirrel@neil.brown.name>
References: <1249755852.5095.86.camel@ilievnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1249755852.5095.86.camel@ilievnet.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Iliev <daniel.iliev@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, August 9, 2009 4:24 am, Daniel Iliev wrote:
> Hi,
>
> I have (had!?) a raid10 built of sd[a-d]3, with 2 far copies
> on /dev/md2.
>
> sda died.
> Next the ext4 on md2 got damaged beyond fsck repair. This has nothing to
> do with the raid, but is still relevant. The FS had 2 dirs for which
> fsck was reporting "have null as parent" Fix<y>", but couldn't really
> fix it. Anyway the FS is/was still mountable and readable and I decided
> to get smart. The idea was:
>
> physically attach the new sda (I've already received the replacement
> disk)
> mdadm /dev/md2 --fail /dev/sdc3
> mdadm /dev/md2 --remove /dev/sdc3
>
> (to use its space together with sda for backup & restore)
>
> mkfs.ext4 /dev/sda
> mkfs.ext4 /dev/sdc
>
> mkdir -r /mnt/sd{a,c}
> mount /dev/sda /mnt/sda
> mount /dev/sdc /mnt/sdc
>
> tar cpf /mnt/sda/backup1.tar /home/data/<half/the/data/>
> tar cpf /mnt/sdc/backup2.tar /home/data/<the/rest>
>
> umount /dev/md2
> mkfs.ext4 /dev/md2
> mount /dev/md2
>
> tar xpf /mnt/sda/backup1.tar -C /home/data/
> tar xpf /mnt/sdc/backup2.tar -C /home/data/
> umount /mnt/*
> rm -r /mnt/sd?
>
> sfdisk -d /dev/sdb | sfdisk /dev/sda
> sfdisk -d /dev/sdb | sfdisk /dev/sdc
>
> mdadm /dev/md2 -add /dev/sda3
> mdadm /dev/md2 -add /dev/sdc3
>
>
> What happened is that I removed sdc3, mounted md2, saw the data,
> unmounted md2 and tried to "mdadm /dev/md2 --re-add /dev/sdc3", so I'd
> go trough the backup & restore routine later.

Possibly md thought there had been some change in the array and it
was too late to re-add an old device.  If you have a bitmap that
might make it work better.


>
> Unfortunately for some reason mdadm added sdc3 as spare. I stopped md2
> and tried to assemble it again, but this time mdadm said there wera no
> eneough drives to start the array and sdc3 was still marked as spare.

Can you try assembling the array adding "--verbose" and post the full
output as well as the exact version of kernel and mdadm?

NeilBrown


>
> Is there any chance to get this array working with sd[b-d]3 only and
> execute the initial plan?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

