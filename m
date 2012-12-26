From: Phil Turmel <philip@turmel.org>
Subject: Re: Any risk switching mdadm to static?
Date: Wed, 26 Dec 2012 14:02:11 -0500
Message-ID: <50DB49B3.4070703@turmel.org>
References: <CAK2H+ee_u3bc7ZgN9z9CJbuSN+8HVyeTLwRaCn5hCP1fB3w8NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ee_u3bc7ZgN9z9CJbuSN+8HVyeTLwRaCn5hCP1fB3w8NQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/26/2012 12:57 PM, Mark Knecht wrote:
> Hi,
>    I run a bunch of home Gentoo systems most of which use mdadm,
> currently version 3.1.4. I do not currently use initramfs's on any of
> these systems but figure it's time for me to crawl out of my dark ages
> swamp and try to become more enlightened.
> 
>    QUESTION: Is there an significant risk that a normal Gentoo system
> of the stable variety (I.e. - not ~amd64) would encounter any problems
> booting if mdadm-3.1.4 was rebuilt using the static flag? If it
> matters most of my RAIDs are metadata-0.9. One is 1.2.

I can't answer the question off the top, but I thought I'd point out
that you probably don't need static for use with an initramfs.  Because
I run stable amd64 on one of my gentoo servers, and don't have 'static'
set for mdadm.  I use dracut with mdraid and lvm use flags to build my
initramfs images.  Rootfs is in LVM which is on MD raid10.

>    If I did encounter a problem and couldn't boot is there a way to recover?
>
>    Please note, I'm not asking right now about using mdadm from within
> an initramfs. I'm only trying to ensure that if I rebuild mdadm with
> the static flag the current system is still likely to boot OK.

From my understanding of how linking works, I'd say it *can't* hurt.

>    Folks on the Gentoo list say they didn't have any problems
> switching, but they switched a long, long time ago so I'm just trying
> to be extra sure.

HTH,

Phil

