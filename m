From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Best tool to partition Drives with new sector geometry - (WAS:
 Need Help with crashed RAID5 (that was rebuilding and then had SATA error on
 another drive))
Date: Mon, 19 Sep 2016 07:25:00 +0100
Message-ID: <57DF84BC.2040703@youngman.org.uk>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <57BBDC15.5030301@gmail.com>
 <b8c6a380-7e6a-fda9-5834-b85271b26892@websitemanagers.com.au>
 <57BC61F7.8070102@gmail.com>
 <aca4e83f-9a3f-c200-7c16-3b5d9df52c1e@websitemanagers.com.au>
 <57BE450B.4030700@gmail.com>
 <56e86db5-456d-e9c1-339d-ba8903fe5dde@websitemanagers.com.au>
 <57BE52BC.6040908@gmail.com>
 <933228e0-bce4-ffad-f48d-034bf89bc07f@websitemanagers.com.au>
 <57BF9965.1020403@gmail.com> <57C0856D.8050209@youngman.org.uk>
 <57C32D8E.9030102@gmail.com>
 <3b008fb0-1fb3-f12f-d973-3657de6e6923@websitemanagers.com.au>
 <57C38EF5.7020005@gmail.com> <57C41A47.5050506@youngman.org.uk>
 <e6180f36-f246-b4ad-ef53-8012e583b09e@gmail.com>
 <CAJCQCtQAazjCmXfSgbcJNDxtM2pHRcqbmEo1j=Og-dQRPEAzaQ@mail.gmail.com>
 <484e25ca-0a8e-f666-b1c8-ebc92a49f999@gmail.com>
 <57DEE853.4060001@youngman.org.uk>
 <4e08d03d-6759-84fd-6467-3bb2d1d9d320@gmail.com>
 <57DF055E.9060102@youngman.org.uk>
 <03f24dac-c34b-31d0-a514-0d9c99e07fd2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <03f24dac-c34b-31d0-a514-0d9c99e07fd2@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18/09/16 22:29, Benjammin2068 wrote:
> Sounds good. I was more worried about the specifics of the partition and how mdadm sees a larger sized partition -- NOT just a larger sized drive. (on which a same size partition could be built)

Yeah. I've done that a couple of times. Create the new partition larger
than the old one. dd the old partition across. Use whatever
filesystem-specific tool there was to grow the file system into all
available space on the partition.

Oh yes - and be damn careful with FAT :-) I can't remember the details,
but when there was a problem it used to prefer a faulty filesystem size
to the partition size, and would gaily sail off the end of the
partition, trashing the next partition. My "record to USB" TV seems
rather prone to this :-(

Cheers,
Wol
