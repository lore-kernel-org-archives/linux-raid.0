From: david@lang.hm
Subject: Re: Linux mdadm superblock question.
Date: Mon, 15 Feb 2010 19:18:32 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1002151916280.5135@asgard.lang.hm>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <20100216112708.4a863f86@notabene.brown> <4B79F3CE.5030907@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B79F3CE.5030907@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Brown <neilb@suse.de>, Michael Evans <mjevans1983@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 15 Feb 2010, H. Peter Anvin wrote:

> On 02/15/2010 04:27 PM, Neil Brown wrote:
>
> There are three options:
>
> a) either don't boot from it (separate /boot);
> b) use a bootloader which installs in the MBR and
> hopefully-unpartitioned disk areas (e.g. Grub);
> c) use a nonstandard custom MBR.
>
> Neither (b) or (c), of course, allow for chainloading from another OS
> install and thus are bad for interoperability.

I have had no problems with XFS partitions and lilo as the bootloader. 
I've been doing this for a couple of years now without realizing that 
there is supposed to be a problem.

David Lang
