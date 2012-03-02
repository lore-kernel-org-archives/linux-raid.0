From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Fri, 02 Mar 2012 14:15:08 +0100
Message-ID: <4F50C7DC.3000700@profihost.ag>
References: <4F4C9A11.9060302@profihost.ag>	<4F4F4B1D.4050000@redhat.com>	<4F4F4EB3.6030909@profihost.ag>	<4F4F519E.7040206@redhat.com>	<4F508864.4050600@profihost.ag> <20120302100648.fe4e725f2e98880c839357b0@bbaw.de> <4F508EB6.2030101@profihost.ag> <4F5091BF.1000102@anonymous.org.uk> <4F509402.8070503@profihost.ag> <4F50ABA3.1070603@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F50ABA3.1070603@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: =?UTF-8?B?TGFycyBUw6R1YmVy?= <taeuber@bbaw.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> No. When booting with MBR, all that goes in the boot sector is enough to
> load the next stage. That next stage will include the raid1x module. It
> lives in the gap between the MBR and the first partition - with old
> fdisk, that was 31K, with more recent fdisk it's 1MB. With no partition
> table on the drives and 1.2 metadata, there's only 3.5K for it, which
> isn't enough.
But that's why i've a BIOS_GRUB partition on the raid and so also on the
disk. Shouldn't it be the same size for 0.9 which starts at the
beginning, too?

> What's actually happening with metadata 0.90 or 1.0, because they have
> their data from the beginning, is that the partition table, GRUB etc
> that you have installed into md127 appears to the BIOS as two drives
> with boot sectors, partition tables, etc, and it then proceeds to boot
> off the first drive.
So the bios needs to read the partition table? I thought the MBR would
be enough.

> Until grub has loaded, you rely on the fact that
> what you installed inside the RAID-1 is laid out in exactly the way the
> BIOS expects to find it on a single drive.
>
> What you've done with metadata 1.2 is put GRUB in a place that needs
> GRUB to find it.
With metadata 0.9 i can install grub on sda and sdb even when there's no
part. table.

But with 1.2 grub says it cannot find a partition table so it cannot
install . So it seems to be a grub bug? grub-probe correctly dectecs a
1.2 metadata md raid on the disks but then still doesn't want to install
with the no partition table message.

Stefan
