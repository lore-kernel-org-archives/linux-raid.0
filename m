From: Luca Berra <bluca@comedia.it>
Subject: Re: mdadm raid6->LVM->ext4 setup
Date: Tue, 16 Nov 2010 23:17:22 +0100
Message-ID: <20101116221722.GC8943@maude.comedia.it>
References: <4CE2C8AC.7010103@geograph.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CE2C8AC.7010103@geograph.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 16, 2010 at 08:08:44PM +0200, Zoltan Szecsei wrote:
> ***  Setup:
> 8 * 5900RPM Seagte 2TB drives on SiI3132 PCIx x1 card.
> Linux gs0 2.6.32-25-generic #45-Ubuntu SMP Sat Oct 16 19:52:42 UTC 2010 
> x86_64 GNU/Linux
> mdadm - v3.1.4 - 31st August 2010
>   LVM version:     2.02.54(1) (2009-10-26)
>   Library version: 1.02.39 (2009-10-26)
>   Driver version:  4.15.0
> mke2fs 1.41.11 (14-Mar-2010)
>
> ***  Commands used:
> mdadm --create /dev/md0 --metadata=1.2 --auto=md --assume-clean 
> --bitmap=internal --bitmap-chunk=131072 --chunk=512 --level=6 
> --raid-devices=8 /dev/sd[abcdefgh]
> mdadm --detail --scan >> /etc/mdadm.conf
> mdadm --assemble /dev/md0
as i said this is not useful
> pvcreate --metadatasize 512 /dev/md0
you should use --dataalignment, not --metadatasize, also you should
align to a full stripe
> vgcreate geo_vg0 /dev/md0
> lvcreate -n geo_lvm0 -l 100%FREE geo_vg0
> mkfs -t ext4  -m 1-b 4096 -E stride=128,stripe-width=768 
> /dev/geo_vg0/geo_lvm0
-- 
Luca Berra -- bluca@comedia.it
