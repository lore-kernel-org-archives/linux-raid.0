From: Martin Wilck <mwilck@arcor.de>
Subject: Re: How does md(adm) work with fake-raid ?
Date: Fri, 19 Jul 2013 00:03:50 +0200
Message-ID: <51E86646.8020107@arcor.de>
References: <CAC9WiBjU_A0jsB4KoX4B9ohT4TD3cYuDdioM6hSWfK13Otjs-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjU_A0jsB4KoX4B9ohT4TD3cYuDdioM6hSWfK13Otjs-Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/18/2013 10:37 PM, Francis Moreau wrote:
> Hello,
> 
> Sorry if the question is stupid but I'm a rookie in md things, but I'd
> like to understand the big picture here.
> 
> I've been told to use mdadm whenever possible even if my raid is
> handled by the bios (fake raid) which use the ddf metadata format.
> (unfortunately it seems that I can't desactive this fake raid in
> favour of linux soft raid). It's RAID1 BTW.
> 
> So my question is rather simple: in my understanding the bios is doing
> the mirroring, but when setting up the md device, linux (kernel or
> userspace, I don't really know) also handles the mirroring for RAID1
> personnality. Is Linux clever enough to see that the mirroring is done
> by the bios in my case ?
> 
> Could anybody teach me the big picture ?

Fake RAID uses a part of every disk to record information about the RAID
arrays. This is called meta data, and your BIOS uses it for setting up
the drives.

Under Linux, first you need a low level SATA or SAS driver that detects
your physical drives, e.g. the ahci driver.

md can then detect the DDF meta data on your disk just like the BIOS,
assemble the array(s), mirror the data, and do other RAID operations.

Distributions can set this up automatically. Currently most distros
don't do this for DDF (they do it only for fake RAID using the Intel
Matrix (IMSM) format). For DDF, for historical reasons, most
distributions will setup a mapping using dmraid (device mapper based
mirroring). That will also basically work, but it isn't a
fully-functional RAID implementation such as MD. The magic to set up
either MD or dmraid automatically as disks are detected is hidden in the
distro's udev rules, and possibly in the distro's installer logic.

The DDF functionality in mdadm is not quite as complete as for other
meta data formats, in particular IMSM. I am currently working on
improving it, because I want to use just a similar fake RAID under Linux
as you, and fully benefit from MD's feature set.

Before doing real work with DDF on your system, make sure that the BIOS
still detects your drives correctly after MD/DDF has written its meta
data (this happens when an array is shut down, for example).
There is a small but non-zero risk that the BIOS may reject the
configuration as written by MD. The same may happen e.g. for a Windows
fake RAID driver.

If you experience any problems, be sure to report them here.

DDF metadata is always at the end of the disks. Thus you can save your
configuration by backing up the last sectors. The size of the meta data
is at least 32MB but may be larger depending on the BIOS implementation.

Hope this helps.
Martin

> 
> Thanks a lot.
> --
> Francis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

