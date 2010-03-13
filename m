From: Neil Brown <neilb@suse.de>
Subject: Re: RAID1 On 3 Drives
Date: Sun, 14 Mar 2010 08:26:49 +1100
Message-ID: <20100314082649.187dae9a@notabene.brown>
References: <d80f793f1003131306i1eb1d839w5552e048001e6193@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1003131306i1eb1d839w5552e048001e6193@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Mennens <carloswill@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 13 Mar 2010 16:06:38 -0500
Carlos Mennens <carloswill@gmail.com> wrote:

> I was told by my distributions Wiki page that Grub doesn't support
> RAID 5 or RAID 6 so I would need to create a volume with three disks
> and set the level to RAID 1:
> 
> # mdadm --create /dev/md1 --level=1 --raid-devices=3 /dev/sda1
> /dev/sdb1 /dev/sdc1 --spare-devices=1 /dev/sdd1
> 
> Is this possible to mirror three identical drive partitions? I was
> talking to some co-workers and was told that I could only pair two
> drives on RAID 1.

Your co-workers are wrong, at least for md raid.  With md, a RAID1 can have
any number of devices from 1 upwards - the limit varies in different
situations but is at least 28.

Try it and see.

NeilBrown

> 
> Can anyone please help me understand this?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

