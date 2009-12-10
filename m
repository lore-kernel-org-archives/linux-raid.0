From: Neil Brown <neilb@suse.de>
Subject: Re: Growing Linear RAID
Date: Thu, 10 Dec 2009 20:30:08 +1100
Message-ID: <20091210203008.69cbbe97@notabene.brown>
References: <8338BD137FF1B64EB341218BD702985E02C8C03B@BLR-EC-MBX03.wipro.com>
	<20091210123353.66100b41@notabene.brown>
	<8338BD137FF1B64EB341218BD702985E02C8C165@BLR-EC-MBX03.wipro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8338BD137FF1B64EB341218BD702985E02C8C165@BLR-EC-MBX03.wipro.com>
Sender: linux-raid-owner@vger.kernel.org
To: senthilkumar.muthukalai@wipro.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 10 Dec 2009 13:54:29 +0530
<senthilkumar.muthukalai@wipro.com> wrote:

> Neil,
> 
> I get only the following message under /var/log/
> 
> [root@NAS00226b1755a0 ~]# mdadm /dev/md0 --grow --add /dev/sata3 
> mdadm: Cannot add new disk to this array
> 
> Dec  9 20:37:58 NAS00226b1755a0 kernel: md: export_rdev(sdc)
> 
> [root@NAS00226b1755a0 ~]# mdadm /dev/md0 --grow --add /dev/sata4
> mdadm: Cannot add new disk to this array
> 
> Dec  9 20:38:30 NAS00226b1755a0 kernel: md: export_rdev(sdd)
>

Thanks - that narrows it down quite a bit.

I think that if you run mdadm under 'strace' you will find that the ioctl
fails with ENOSPC.
It seems that growing a linear array didn't work reliably until 2.6.22.

You need 

  commit a778b73ff793d34c0082f76110f73a7754915067

to make it work properly.

NeilBrown
