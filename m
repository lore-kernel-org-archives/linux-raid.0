From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID partitions, or RAID disks and partition array?
Date: Fri, 22 Aug 2014 12:34:34 -0600
Message-ID: <F8AB938C-5A75-42E9-A27C-21CF912D96A6@colorremedies.com>
References: <CAH_2Ghc3tW4rD_iS7LO47ot6xURJq-RTrEyd3Z-swN2vA=4pPA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_2Ghc3tW4rD_iS7LO47ot6xURJq-RTrEyd3Z-swN2vA=4pPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Aug 22, 2014, at 10:52 AM, Adam Talbot <ajtalbot1@gmail.com> wrote:

> I hope this is an easy one.  I have two drives I would like to mirror
> as my boot drive.
> 1) Should I mirror the drives, then partition the RAID device (md0)?
> 2) Should I partition the the drives then RAID the partitions?
> 
> What is the best practice, and why?

Most common is 2, because it allows you to exclude e.g. swap from being mirrored. If it's included, you will find that scrub checks show bogus mismatches and you won't know for sure if they're due to swap or some real problem. See man 4 md for more information on scrubs and raid1/raid10. There are also bootloader complications that come up with layout 1.

Recovery will involve more steps with layout 2, because you'll be replacing multiple faulty devices: one for each partition on the dead drive.

Since it's to be bootable, you probably want a resiliently bootable setup that can boot degraded. If so you'll want to use partition type code 0xDA, mdadm metadata 1.2, and GRUB2. Why? Because mdadm metadata 1.2 is what's recommended these days and avoids the inconsistency that develops if you mount a filesystem before assembling the md device, which is possible with metadata 0.9 and 1.0. GRUB2 because it reads metadata 1.2 directly, including degraded, and for that matter can even read md raid5/6. The MBR type code 0xDA is obscure and not supported by parted, but is supported by fdisk. 0xFD is intended for metadata 0.9, kernel autodetect. So if you aren't using that version of metadata you should use 0xDA which indicates the partition is not a file system, which it isn't, it's a raid memb
 er device first. The filesystem materializes only once the md device is assembled (degraded or normal).

It's all a bit tricky because as far as I know, no distribution's GUI installer does this exactly correct on all counts. Most are still using 0xFD for type code, and metadata 1.0 or 1.1. It's probably not dangerous or there'd be screaming users. But if you want best practice, use what's recommended. And then if there are bugs you have a lot more leverage in getting them fixed.

Things are slightly different if the firmware is BIOS but you're using GPT partitioning; or if the firmware is UEFI (and of course GPT partitioning). So if either of those are the case, let us know.

Chris Murphy