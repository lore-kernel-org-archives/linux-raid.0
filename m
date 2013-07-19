From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: How does md(adm) work with fake-raid ?
Date: Fri, 19 Jul 2013 09:08:16 +0200
Message-ID: <CAC9WiBiup8RfusZo51DjAsTOLyr1F-LxgGGCWRCakYURskz7rA@mail.gmail.com>
References: <CAC9WiBjU_A0jsB4KoX4B9ohT4TD3cYuDdioM6hSWfK13Otjs-Q@mail.gmail.com>
	<51E86613.9050505@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51E86613.9050505@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

On Fri, Jul 19, 2013 at 12:02 AM, Martin Wilck <mwilck@arcor.de> wrote:
>
> Fake RAID uses a part of every disk to record information about the RAID
> arrays. This is called meta data, and your BIOS uses it for setting up
> the drives.
>
> Under Linux, first you need a low level SATA or SAS driver that detects
> your physical drives, e.g. the ahci driver.
>
> md can then detect the DDF meta data on your disk just like the BIOS,
> assemble the array(s), mirror the data, and do other RAID operations.
>

Yes, but my question is about how md cooperate with the BIOS in this case ?

> Distributions can set this up automatically. Currently most distros
> don't do this for DDF (they do it only for fake RAID using the Intel
> Matrix (IMSM) format). For DDF, for historical reasons, most
> distributions will setup a mapping using dmraid (device mapper based
> mirroring). That will also basically work, but it isn't a
> fully-functional RAID implementation such as MD. The magic to set up
> either MD or dmraid automatically as disks are detected is hidden in the
> distro's udev rules, and possibly in the distro's installer logic.

That's true, and I'm in the process of "fixing" the default setup
(dmraid, done during my distro installation) with MD.

>
> The DDF functionality in mdadm is not quite as complete as for other
> meta data formats, in particular IMSM. I am currently working on
> improving it, because I want to use just a similar fake RAID under Linux
> as you, and fully benefit from MD's feature set.

That's an interesting information thanks.

>
> Before doing real work with DDF on your system, make sure that the BIOS
> still detects your drives correctly after MD/DDF has written its meta
> data (this happens when an array is shut down, for example).
> There is a small but non-zero risk that the BIOS may reject the
> configuration as written by MD. The same may happen e.g. for a Windows
> fake RAID driver.

That's a good idea.

Are there any procedures described out there that I could follow to
test MD DFF ?

>
> If you experience any problems, be sure to report them here.
>

I will.

Thank you.
--
Francis
