From: Twigathy <twigathy@gmail.com>
Subject: Re: Booting off of RAID10 versus RAID1
Date: Thu, 8 May 2008 18:16:31 +0100
Message-ID: <1f0f1a960805081016k3aebfdecj3450f3edb1470a43@mail.gmail.com>
References: <06c201c8b128$1c4bf045$5209f40a@exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <06c201c8b128$1c4bf045$5209f40a@exchange.rackspace.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My desktop NFS boots off my fileserver, with a local /boot partition
on a 2GB CompactFlash card in an IDE -> CF adapter bought for pennies
on fleabay. With a partition like /boot that doesn't get written to
very often (Only on kernel updates and initrd changes) I don't see the
write limitations as being too much of a problem. Not sure how well
they would fare in a raid1 setup, but again they'd only be written to
occasionally.

2008/5/8 David Lethe <david@santools.com>:
> I know of several vendors that have linux-based NAS appliance vendors who do this. It is rock solid, as long as you don't use consumer-quality usb flash.  Check specs on flash memory for throughput and write cycles and ECC and choose accordingly. Also look into IDE mounted flash. It directly plugs into IDE plug on mobo, so it will be internal, and emulates an ide disk.
>
>
>
>  -----Original Message-----
>
>  From:  "David Greaves" <david@dgreaves.com>
>  Subj:  Re: Booting off of RAID10 versus RAID1
>  Date:  Thu May 8, 2008 10:31 am
>  Size:  556 bytes
>  To:  "Maurice Hilarius" <maurice@harddata.com>
>  cc:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
>
>  Maurice Hilarius wrote:
>  > After recent issues discovered with RAID1 and failing disks, I am
>  > contemplating alternatives to ensure more reliability.
>  >
>  > The question that arises: Is there any way to boot a system from a
>  > RAID10 md?
>
>  I've been wondering about booting grub/initrd from a flash USB stick (industrial
>  quality if needed).
>
>  David
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
