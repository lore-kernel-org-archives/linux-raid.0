From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 07:41:50 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0803020741150.13994@p34.internal.lan>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 2 Mar 2008, Christian Pernegger wrote:

> Hi all!
>
> I'm not doing this for the first time but there were a few interesting
> / worrying points during the setup process and I'd rather clear those
> up now.
>
> Hardware:
> Tyan Thunder K8W (S2885)
> Dual Opteron 254, 2GB (2x2x512MB) RAM, 2x Promise SATA II TX4, Adaptec 29160
> 4x WD RE2-GP 1TB on the Promise (for raid5)
> 1x Maxtor Atlas 15K II on the Adaptec (system disk)
>
> OS:
> Debian testing-amd64
> linux-2.6.22-3
> mke2fs 1.40.6
> mdadm
>
> I did a badblocks -v -s -t random -w on all future RAID disks in
> parallel to test / burn-in.
> Result: no bad blocks, decent speed (vmstat: 148MB/s total read,
> 220MB/s total write), BUT the following error (once):
>
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata2.00: (port_status 0x20080000)
> ata2.00: cmd 25/00:80:80:a1:55/00:00:3a:00:00/e0 tag 0 cdb 0x0 data 65536 in
>         res 50/00:00:ff:a1:55/00:00:3a:00:00/e0 Emask 0x2 (HSM violation)
> ata2: soft resetting port
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: configured for UDMA/133
> ata2: EH complete
> sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
> sd 2:0:0:0: [sdc] Write Protect is off
> sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA

Disable NCQ and your problem will go away.

echo 1 > /sys/block/$i/device/queue_depth

Justin.


